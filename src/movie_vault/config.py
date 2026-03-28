from __future__ import annotations

import os

from dotenv import load_dotenv


load_dotenv()


def get_connection_string() -> str:
    connection_string = os.getenv("MOVIE_VAULT_CONNECTION_STRING")
    if not connection_string:
        raise ValueError(
            "MOVIE_VAULT_CONNECTION_STRING is missing. "
            "Add it to your .env file before running the app."
        )
    return connection_string

