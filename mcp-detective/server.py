"""Servidor MCP de casos y alertas en memoria, disponible mediante stdio."""

import json
from pathlib import Path
from threading import Lock

from mcp.server import MCPServer
from mcp.server.mcpserver.exceptions import ToolError


class ErrorValidacion(ValueError, ToolError):
    """ValueError esperado cuyo mensaje MCP puede comunicar al cliente."""


def cargar_casos() -> dict:
    """Carga los casos desde el JSON situado junto a este archivo."""
    with Path(__file__).with_name("casos.json").open(encoding="utf-8") as archivo:
        return json.load(archivo)


def resumir_casos(casos: dict) -> list[dict]:
    """Devuelve identificador, sistema y cantidad de eventos sin conclusiones."""
    return [
        {"id": caso_id, "sistema": caso["sistema"], "cantidad_eventos": len(caso["eventos"])}
        for caso_id, caso in casos.items()
    ]


def validar_caso(casos: dict, caso_id: str) -> None:
    """Rechaza identificadores que no correspondan a un caso existente."""
    if not isinstance(caso_id, str) or caso_id not in casos:
        raise ErrorValidacion(f"El caso {caso_id!r} no existe.")


def obtener_eventos(casos: dict, caso_id: str) -> list[dict]:
    """Devuelve copias de los eventos exactos de un caso existente."""
    validar_caso(casos, caso_id)
    return [evento.copy() for evento in casos[caso_id]["eventos"]]


_bloqueo_alertas = Lock()


def guardar_alerta(
    casos: dict, alertas: dict, caso_id: str, nivel: str, motivo: str
) -> dict:
    """Valida y guarda una sola alerta por caso en el diccionario en memoria."""
    validar_caso(casos, caso_id)
    if not isinstance(nivel, str) or nivel not in ("bajo", "medio", "alto"):
        raise ErrorValidacion("El nivel debe ser bajo, medio o alto.")
    if not isinstance(motivo, str) or not motivo.strip():
        raise ErrorValidacion("El motivo debe contener al menos un carácter no blanco.")

    # La comprobación y el guardado son indivisibles ante llamadas simultáneas.
    with _bloqueo_alertas:
        if caso_id in alertas:
            raise ErrorValidacion(f"Ya existe una alerta registrada para el caso {caso_id!r}.")
        alerta = {
            "caso_id": caso_id,
            "nivel": nivel,
            "motivo": motivo,
            "estado": "registrada",
        }
        alertas[caso_id] = alerta
        return alerta.copy()


_casos = cargar_casos()
_alertas: dict = {}
mcp = MCPServer("mcp-detective")


@mcp.tool()
def listar_casos() -> list[dict]:
    """Lista el id, sistema y cantidad de eventos de cada caso, sin conclusiones."""
    return resumir_casos(_casos)


@mcp.tool()
def consultar_eventos(caso_id: str) -> list[dict]:
    """Consulta los eventos exactos del caso; genera ValueError si no existe."""
    return obtener_eventos(_casos, caso_id)


@mcp.tool()
def registrar_alerta(caso_id: str, nivel: str, motivo: str) -> dict:
    """Registra una alerta por caso con nivel bajo/medio/alto y motivo no blanco.

    Genera ValueError ante un caso inexistente, datos inválidos o una alerta duplicada.
    Las alertas permanecen únicamente en memoria durante la ejecución del servidor.
    """
    return guardar_alerta(_casos, _alertas, caso_id, nivel, motivo)


if __name__ == "__main__":
    mcp.run(transport="stdio")
