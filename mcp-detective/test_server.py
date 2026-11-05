"""Pruebas de datos, validación y herramientas sin conexiones de red."""

import asyncio
import importlib.util
import sys
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path

import pytest
from mcp import Client
from mcp.client.stdio import StdioServerParameters


@pytest.fixture
def servidor(monkeypatch, tmp_path):
    """Importa un servidor nuevo desde otro directorio para aislar cada prueba."""
    ruta = Path(__file__).with_name("server.py")
    monkeypatch.chdir(tmp_path)
    spec = importlib.util.spec_from_file_location("detective_server", ruta)
    modulo = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(modulo)
    return modulo


def test_listar_casos_sin_conclusiones(servidor):
    assert servidor.listar_casos() == [
        {"id": "INC-001", "sistema": "portal_acceso", "cantidad_eventos": 2},
        {"id": "INC-002", "sistema": "portal_acceso", "cantidad_eventos": 6},
        {"id": "INC-003", "sistema": "panel_administracion", "cantidad_eventos": 5},
    ]


@pytest.mark.parametrize(
    "caso_id,usuario,ip,horas,eventos",
    [
        ("INC-001", "ana", "198.51.100.10", ["08:41", "08:42"],
         ["LOGIN_FAILED", "LOGIN_SUCCESS"]),
        ("INC-002", "admin", "203.0.113.25",
         ["02:10", "02:11", "02:12", "02:13", "02:14", "02:15"],
         ["LOGIN_FAILED"] * 6),
        ("INC-003", "admin", "192.0.2.50",
         ["03:00", "03:01", "03:02", "03:03", "03:04"],
         ["LOGIN_FAILED"] * 4 + ["LOGIN_SUCCESS"]),
    ],
)
def test_eventos_exactos(servidor, caso_id, usuario, ip, horas, eventos):
    esperado = [
        {"hora": hora, "usuario": usuario, "ip": ip, "evento": evento}
        for hora, evento in zip(horas, eventos)
    ]
    resultado = servidor.consultar_eventos(caso_id)
    assert resultado == esperado
    resultado[0]["evento"] = "MODIFICADO"
    assert servidor.consultar_eventos(caso_id) == esperado


def test_caso_inexistente(servidor):
    with pytest.raises(ValueError, match="INC-999.*no existe"):
        servidor.consultar_eventos("INC-999")
    with pytest.raises(ValueError, match="INC-999.*no existe"):
        servidor.registrar_alerta("INC-999", "alto", "Revisar")
    assert servidor._alertas == {}


@pytest.mark.parametrize("nivel", ["bajo", "medio", "alto"])
def test_registrar_alerta_y_rechazar_duplicado(servidor, nivel):
    motivo = "  Revisar los eventos  "
    esperado = {
        "caso_id": "INC-002", "nivel": nivel,
        "motivo": motivo, "estado": "registrada",
    }
    resultado = servidor.registrar_alerta("INC-002", nivel, motivo)
    assert resultado == esperado
    resultado["motivo"] = "MODIFICADO"
    with pytest.raises(ValueError, match="Ya existe.*INC-002"):
        servidor.registrar_alerta("INC-002", "alto", "Otro motivo")
    assert servidor._alertas == {"INC-002": esperado}
    assert servidor.registrar_alerta("INC-001", "bajo", "Revisar")["estado"] == "registrada"


@pytest.mark.parametrize("nivel", ["", "ALTO", "critico", " alto ", None, 1, []])
def test_nivel_invalido_no_guarda(servidor, nivel):
    with pytest.raises(ValueError, match="nivel"):
        servidor.registrar_alerta("INC-001", nivel, "Revisar")
    assert servidor._alertas == {}


@pytest.mark.parametrize("motivo", ["", " ", "\t\n", "\u2003", None, 1, []])
def test_motivo_invalido_no_guarda(servidor, motivo):
    with pytest.raises(ValueError, match="motivo"):
        servidor.registrar_alerta("INC-001", "medio", motivo)
    assert servidor._alertas == {}


def test_llamadas_simultaneas_guardan_una_sola_alerta(servidor):
    def registrar(numero):
        try:
            return servidor.registrar_alerta("INC-003", "alto", f"Motivo {numero}")
        except ValueError:
            return None

    with ThreadPoolExecutor(max_workers=8) as ejecutor:
        resultados = list(ejecutor.map(registrar, range(20)))
    assert sum(resultado is not None for resultado in resultados) == 1
    assert len(servidor._alertas) == 1


def test_protocolo_stdio_y_mensajes_de_error(tmp_path):
    async def verificar():
        parametros = StdioServerParameters(
            command=sys.executable,
            args=[str(Path(__file__).with_name("server.py"))],
            cwd=tmp_path,
        )
        async with Client(parametros) as cliente:
            herramientas = await cliente.list_tools()
            assert {tool.name for tool in herramientas.tools} == {
                "listar_casos", "consultar_eventos", "registrar_alerta"
            }
            listado = await cliente.call_tool("listar_casos", {})
            assert not listado.model_dump(by_alias=True).get("isError", False)
            eventos = await cliente.call_tool("consultar_eventos", {"caso_id": "INC-003"})
            assert not eventos.model_dump(by_alias=True).get("isError", False)

            rechazos = [
                ("consultar_eventos", {"caso_id": "INC-999"}, "no existe"),
                ("registrar_alerta", {"caso_id": "INC-999", "nivel": "alto", "motivo": "Revisar"}, "no existe"),
                ("registrar_alerta", {"caso_id": "INC-001", "nivel": "critico", "motivo": "Revisar"}, "nivel"),
                ("registrar_alerta", {"caso_id": "INC-001", "nivel": "alto", "motivo": "  "}, "motivo"),
            ]
            for nombre, argumentos, mensaje in rechazos:
                resultado = await cliente.call_tool(nombre, argumentos)
                assert resultado.model_dump(by_alias=True)["isError"]
                assert mensaje in resultado.content[0].text

            argumentos = {"caso_id": "INC-001", "nivel": "alto", "motivo": "Revisar"}
            registro = await cliente.call_tool("registrar_alerta", argumentos)
            assert not registro.model_dump(by_alias=True).get("isError", False)
            duplicado = await cliente.call_tool("registrar_alerta", argumentos)
            assert duplicado.model_dump(by_alias=True)["isError"]
            assert "Ya existe" in duplicado.content[0].text

    asyncio.run(verificar())
