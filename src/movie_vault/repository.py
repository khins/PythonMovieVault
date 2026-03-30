from __future__ import annotations

from typing import Iterable

from .db import get_connection
from .models import Movie, WatchlistItem


def _rows_to_movies(rows: Iterable) -> list[Movie]:
    return [
        Movie(
            movie_id=row.MovieId,
            title=row.Title,
            release_year=row.ReleaseYear,
            genre_name=row.GenreName,
            director_name=row.DirectorName,
            runtime_minutes=row.RuntimeMinutes,
            average_rating=float(row.AverageRating) if row.AverageRating is not None else None,
        )
        for row in rows
    ]


def list_movies() -> list[Movie]:
    with get_connection() as connection:
        cursor = connection.cursor()
        cursor.execute(
            """
            SELECT
                MovieId,
                Title,
                ReleaseYear,
                GenreName,
                DirectorName,
                RuntimeMinutes,
                AverageRating
            FROM dbo.vMovieDetails
            ORDER BY Title;
            """
        )
        return _rows_to_movies(cursor.fetchall())


def search_movies(title: str | None = None, genre: str | None = None, director: str | None = None) -> list[Movie]:
    with get_connection() as connection:
        cursor = connection.cursor()
        cursor.execute(
            "EXEC dbo.usp_SearchMovies @Title = ?, @GenreName = ?, @DirectorName = ?;",
            title,
            genre,
            director,
        )
        return _rows_to_movies(cursor.fetchall())
    
def get_top_rated_movies(limit: int = 10, genre: str | None = None, director: str | None = None) -> list[Movie]:
    with get_connection() as connection:
        cursor = connection.cursor()
        cursor.execute(
            "EXEC dbo.usp_GetTopRatedMovies @Limit = ?, @GenreName = ?, @DirectorName = ?;",
            limit,
            genre,
            director,
        )
        return _rows_to_movies(cursor.fetchall())

def add_rating(movie_id: int, rating: int, review_note: str | None = None) -> None:
    with get_connection() as connection:
        cursor = connection.cursor()
        cursor.execute(
            "EXEC dbo.usp_AddUserRating @MovieId = ?, @Rating = ?, @ReviewNote = ?;",
            movie_id,
            rating,
            review_note,
        )
        connection.commit()

def update_rating(movie_id: int, rating: int) -> None:
    with get_connection() as connection:
        cursor = connection.cursor()
        cursor.execute(
            "EXEC dbo.usp_UpdateUserRating @MovieId = ?, @Rating = ?",
            movie_id,
            rating,
        )
        cursor.fetchone()
        connection.commit()

def add_movie(
    title: str,
    release_year: int,
    genre_name: str,
    director_name: str,
    runtime_minutes: int,
    average_rating: float | None = None,
) -> tuple[int, bool]:
    with get_connection() as connection:
        cursor = connection.cursor()
        cursor.execute(
            """
            EXEC dbo.usp_AddMovie
                @Title = ?,
                @ReleaseYear = ?,
                @GenreName = ?,
                @DirectorName = ?,
                @RuntimeMinutes = ?,
                @AverageRating = ?;
            """,
            title,
            release_year,
            genre_name,
            director_name,
            runtime_minutes,
            average_rating,
        )
        row = cursor.fetchone()
        connection.commit()
        return int(row.MovieId), bool(row.WasInserted)


def add_to_watchlist(movie_id: int) -> tuple[int, bool]:
    with get_connection() as connection:
        cursor = connection.cursor()
        cursor.execute("EXEC dbo.usp_AddToWatchlist @MovieId = ?;", movie_id)
        row = cursor.fetchone()
        connection.commit()
        return int(row.WatchlistId), bool(row.WasInserted)


def remove_from_watchlist(movie_id: int) -> bool:
    with get_connection() as connection:
        cursor = connection.cursor()
        cursor.execute("EXEC dbo.usp_RemoveFromWatchlist @MovieId = ?;", movie_id)
        row = cursor.fetchone()
        connection.commit()
        return bool(row.WasDeleted)


def mark_watchlist_as_watched(movie_id: int) -> tuple[int, bool]:
    with get_connection() as connection:
        cursor = connection.cursor()
        cursor.execute("EXEC dbo.usp_MarkWatchlistAsWatched @MovieId = ?;", movie_id)
        row = cursor.fetchone()
        connection.commit()
        return int(row.WatchlistId), bool(row.WasUpdated)


def list_watchlist(*, watched_only: bool = False) -> list[WatchlistItem]:
    with get_connection() as connection:
        cursor = connection.cursor()
        cursor.execute("EXEC dbo.usp_GetWatchlist @WatchedOnly = ?;", watched_only)
        rows = cursor.fetchall()

    return [
        WatchlistItem(
            watchlist_id=row.WatchlistId,
            movie_id=row.MovieId,
            title=row.Title,
            release_year=row.ReleaseYear,
            added_on=row.AddedOn,
            is_watched=bool(row.IsWatched),
        )
        for row in rows
    ]
