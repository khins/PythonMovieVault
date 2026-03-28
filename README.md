# Movie Vault

Movie Vault is a beginner-friendly Python project that uses Microsoft SQL Server as the backend database. It is designed to help you practice:

- Python basics
- functions and modules
- environment variables
- database connections
- SQL queries and stored procedures
- Git workflow on a real project

## Project Idea

This app is a command-line movie tracker where you can:

- list movies
- search by title
- filter by genre
- add your own rating
- manage a watchlist

That gives us a practical project without too much UI complexity, so we can focus on Python and SQL.

## Project Structure

```text
sql-server/
  docs/
  mssql/
    01_create_database.sql
    02_schema.sql
    03_seed_data.sql
  src/
    movie_vault/
      __init__.py
      cli.py
      config.py
      db.py
      models.py
      repository.py
  .gitignore
  README.md
  requirements.txt
```

## Python Setup

Python is not currently installed in this workspace, so install Python 3.12+ first.

After that:

```powershell
py -m venv .venv
.venv\Scripts\Activate.ps1
pip install -r requirements.txt
```

## SQL Server Setup

Run these scripts in order in SQL Server Management Studio:

1. `mssql/01_create_database.sql`
2. `mssql/02_schema.sql`
3. `mssql/03_seed_data.sql`

## Environment Variables

Create a `.env` file in the project root:

```env
MOVIE_VAULT_CONNECTION_STRING=DRIVER={ODBC Driver 17 for SQL Server};SERVER=localhost;DATABASE=MovieVault;Trusted_Connection=yes;TrustServerCertificate=yes;
```

If you use SQL authentication, change the connection string accordingly.

## Run The App

Start the interactive menu:

```powershell
python -m src.movie_vault.cli menu
```

Or run single commands directly:

```powershell
python -m src.movie_vault.cli list-movies
python -m src.movie_vault.cli search --title inception
python -m src.movie_vault.cli list-watchlist
python -m src.movie_vault.cli add-movie --title "Arrival" --year 2016 --genre "Sci-Fi" --director "Denis Villeneuve" --runtime 116 --average-rating 7.9
python -m src.movie_vault.cli add-to-watchlist --movie-id 9
python -m src.movie_vault.cli rate --movie-id 1 --rating 9
```

## Suggested Learning Path

1. Run the app and read through `cli.py`.
2. Study how `repository.py` sends SQL to the database.
3. Add a new command such as `add-movie`.
4. Replace one inline SQL query with a stored procedure call.
5. Write your own reports in SQL Server and connect them to Python.

## Git Workflow

This project is set up to be tracked locally with Git first. Later, once you create the GitHub repo, you can connect it with:

```powershell
git remote add origin <your-github-url>
git branch -M main
git push -u origin main
```
