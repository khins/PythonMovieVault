from __future__ import annotations

import argparse
from datetime import datetime

from . import repository


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        prog="movie-vault",
        description="A simple Python + SQL Server movie tracker."
    )
    subparsers = parser.add_subparsers(dest="command", required=True)

    subparsers.add_parser("list-movies", help="Show all movies.")

    search_parser = subparsers.add_parser("search", help="Search movies by title or genre.")
    search_parser.add_argument("--title", help="Part of a movie title.")
    search_parser.add_argument("--genre", help="Exact genre name.")

    add_movie_parser = subparsers.add_parser("add-movie", help="Add a movie to the database.")
    add_movie_parser.add_argument("--title", required=True, help="Movie title.")
    add_movie_parser.add_argument("--year", type=int, required=True, help="Release year.")
    add_movie_parser.add_argument("--genre", required=True, help="Genre name.")
    add_movie_parser.add_argument("--director", required=True, help="Director name.")
    add_movie_parser.add_argument("--runtime", type=int, required=True, help="Runtime in minutes.")
    add_movie_parser.add_argument("--average-rating", type=float, help="Optional average rating.")

    rate_parser = subparsers.add_parser("rate", help="Add your personal rating for a movie.")
    rate_parser.add_argument("--movie-id", type=int, required=True, help="Movie ID.")
    rate_parser.add_argument("--rating", type=int, required=True, help="Rating from 1 to 10.")
    rate_parser.add_argument("--note", help="Optional short review note.")

    subparsers.add_parser("list-watchlist", help="Show watchlist entries.")
    return parser


def print_movies() -> None:
    movies = repository.list_movies()
    if not movies:
        print("No movies found.")
        return

    for movie in movies:
        print(
            f"[{movie.movie_id}] {movie.title} ({movie.release_year}) | "
            f"{movie.genre_name} | {movie.director_name} | "
            f"{movie.runtime_minutes} min | Avg: {movie.average_rating}"
        )


def print_search_results(title: str | None, genre: str | None) -> None:
    movies = repository.search_movies(title=title, genre=genre)
    if not movies:
        print("No matching movies found.")
        return

    for movie in movies:
        print(f"[{movie.movie_id}] {movie.title} ({movie.release_year}) - {movie.genre_name}")


def print_watchlist() -> None:
    items = repository.list_watchlist()
    if not items:
        print("The watchlist is empty.")
        return

    for item in items:
        status = "Watched" if item.is_watched else "To Watch"
        print(f"[{item.movie_id}] {item.title} ({item.release_year}) - {status}")


def create_movie(args: argparse.Namespace) -> None:
    title = args.title.strip()
    genre = args.genre.strip()
    director = args.director.strip()
    current_year = datetime.now().year

    if not title:
        raise ValueError("Title cannot be empty.")

    if not genre:
        raise ValueError("Genre cannot be empty.")

    if not director:
        raise ValueError("Director cannot be empty.")

    if args.year < 1888 or args.year > current_year:
        raise ValueError(f"Year must be between 1888 and {current_year}.")

    if args.runtime <= 0:
        raise ValueError("Runtime must be greater than 0 minutes.")

    if args.average_rating is not None and not 0 <= args.average_rating <= 10:
        raise ValueError("Average rating must be between 0 and 10.")

    movie_id = repository.add_movie(
        title=title,
        release_year=args.year,
        genre_name=genre,
        director_name=director,
        runtime_minutes=args.runtime,
        average_rating=args.average_rating,
    )
    print(f"Movie added with ID {movie_id}.")


def main() -> None:
    parser = build_parser()
    args = parser.parse_args()

    if args.command == "list-movies":
        print_movies()
    elif args.command == "search":
        print_search_results(title=args.title, genre=args.genre)
    elif args.command == "add-movie":
        create_movie(args)
    elif args.command == "rate":
        if not 1 <= args.rating <= 10:
            raise ValueError("Rating must be between 1 and 10.")
        repository.add_rating(movie_id=args.movie_id, rating=args.rating, review_note=args.note)
        print("Rating saved.")
    elif args.command == "list-watchlist":
        print_watchlist()


if __name__ == "__main__":
    main()
