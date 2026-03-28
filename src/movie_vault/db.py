from __future__ import annotations

from contextlib import contextmanager

import pyodbc

from .config import get_connection_string


@contextmanager
def get_connection():
    connection = pyodbc.connect(get_connection_string())
    try:
        yield connection
    finally:
        connection.close()

