"""Pruebas de la lógica del servidor para la Parte 2b del Deber 5."""

import pytest

from server import cargar_casos, guardar_alerta, obtener_eventos, resumir_casos


@pytest.fixture
def casos():
    """Carga los casos para cada prueba."""
    return cargar_casos()


@pytest.fixture
def alertas():
    """Entrega un estado vacío e independiente para cada prueba."""
    return {}


# Se prueban las funciones de lógica que llaman las tres herramientas MCP.
def test_listar_casos_devuelve_exactamente_los_tres_casos(casos):
    assert resumir_casos(casos) == [
        {"id": "INC-001", "sistema": "portal_acceso", "cantidad_eventos": 2},
        {"id": "INC-002", "sistema": "portal_acceso", "cantidad_eventos": 6},
        {"id": "INC-003", "sistema": "panel_administracion", "cantidad_eventos": 5},
    ]


def test_consultar_eventos_de_caso_inexistente_genera_value_error(casos):
    with pytest.raises(ValueError, match="INC-999.*no existe"):
        obtener_eventos(casos, "INC-999")


@pytest.mark.parametrize("nivel", ["bajo", "medio", "alto"])
def test_registrar_alerta_valida(casos, alertas, nivel):
    resultado = guardar_alerta(casos, alertas, "INC-001", nivel, "Revisar acceso")

    esperado = {
        "caso_id": "INC-001",
        "nivel": nivel,
        "motivo": "Revisar acceso",
        "estado": "registrada",
    }
    assert resultado == esperado
    assert alertas == {"INC-001": esperado}


def test_registrar_segunda_alerta_del_mismo_caso_genera_error(casos, alertas):
    primera = guardar_alerta(casos, alertas, "INC-001", "medio", "Primer motivo")

    with pytest.raises(ValueError, match="Ya existe.*INC-001"):
        guardar_alerta(casos, alertas, "INC-001", "alto", "Segundo motivo")

    assert alertas == {"INC-001": primera}


@pytest.mark.parametrize("nivel", ["critico", "ALTO", ""])
def test_registrar_alerta_con_nivel_invalido(casos, alertas, nivel):
    with pytest.raises(ValueError, match="nivel"):
        guardar_alerta(casos, alertas, "INC-001", nivel, "Revisar acceso")

    assert alertas == {}


@pytest.mark.parametrize("motivo", ["", "   ", "\t\n"])
def test_registrar_alerta_con_motivo_en_blanco(casos, alertas, motivo):
    with pytest.raises(ValueError, match="motivo"):
        guardar_alerta(casos, alertas, "INC-001", "alto", motivo)

    assert alertas == {}


def test_inc_002_contiene_los_seis_eventos_exactos(casos):
    eventos = obtener_eventos(casos, "INC-002")

    assert len(eventos) == 6
    assert eventos == [
        {
            "hora": hora,
            "usuario": "admin",
            "ip": "203.0.113.25",
            "evento": "LOGIN_FAILED",
        }
        for hora in ["02:10", "02:11", "02:12", "02:13", "02:14", "02:15"]
    ]
