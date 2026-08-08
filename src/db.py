"""
Database connection helper.

Reads credentials from secrets.json (kept out of version control) and
returns a SQLAlchemy engine. All SQL in sql/ is meant to be run through
this engine via run_sql_file().

secrets.json format:
    {"secrets": ["username", "password", "host", "database_name"]}
"""

from pathlib import Path

import pandas as pd
from sqlalchemy import create_engine, text
from sqlalchemy.engine import Engine

SECRETS_PATH = Path(__file__).resolve().parents[1] / "secrets.json"


def get_engine(secrets_path: Path = SECRETS_PATH) -> Engine:
    if not secrets_path.exists():
        raise FileNotFoundError(
            f"No secrets.json found at {secrets_path}. Create one with "
            '{"secrets": ["username", "password", "host", "database_name"]} '
            "and keep it out of git."
        )
    username, password, host, database_name = pd.read_json(secrets_path)["secrets"]
    return create_engine(
        f"mysql+pymysql://{username}:{password}@{host}/{database_name}",
        # Required client-side for the LOAD DATA LOCAL INFILE statements in sql/,
        # in addition to the server having local_infile=ON.
        connect_args={"local_infile": True},
    )


def _split_statements(sql_text: str) -> list[str]:
    """Split a SQL script on ';', ignoring semicolons inside quoted strings.

    Needed because LOAD DATA statements use terminators like
    `FIELDS TERMINATED BY ';'`, where the ';' is data, not a separator.
    """
    statements = []
    current: list[str] = []
    quote_char = None
    escaped = False
    for char in sql_text:
        if quote_char:
            current.append(char)
            if escaped:
                escaped = False
            elif char == "\\":
                escaped = True
            elif char == quote_char:
                quote_char = None
        elif char in ("'", '"', "`"):
            quote_char = char
            current.append(char)
        elif char == ";":
            statement = "".join(current).strip()
            if statement:
                statements.append(statement)
            current = []
        else:
            current.append(char)

    tail = "".join(current).strip()
    if tail:
        statements.append(tail)
    return statements


def run_sql_file(path: str | Path, engine: Engine | None = None) -> pd.DataFrame | None:
    """Run a .sql file, executing each ';'-separated statement in order.

    Most files in sql/ are multiple statements (DROP/CREATE/LOAD DATA, then a
    trailing SELECT), which pd.read_sql can't run directly. Returns the result
    of the last statement that produced rows, or None if none did.
    """
    engine = engine or get_engine()
    statements = _split_statements(Path(path).read_text())

    result_df = None
    with engine.begin() as conn:
        for statement in statements:
            cursor_result = conn.execute(text(statement))
            if cursor_result.returns_rows:
                result_df = pd.DataFrame(cursor_result.fetchall(), columns=cursor_result.keys())
    return result_df

def run_sql(sql: str, engine: Engine | None = None) -> pd.DataFrame | None:
    """
    Run a quoted SQL string containing one or more ';'-terminated statements.

    Behaves like run_sql_file(), but operates directly on a SQL string.
    Returns the result of the last statement that produced rows, or None.
    """
    engine = engine or get_engine()
    statements = _split_statements(sql)

    result_df = None
    with engine.begin() as conn:
        for statement in statements:
            cursor_result = conn.execute(text(statement))
            if cursor_result.returns_rows:
                result_df = pd.DataFrame(cursor_result.fetchall(),
                                         columns=cursor_result.keys())
    return result_df
