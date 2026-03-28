from __future__ import annotations

import argparse

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


def main() -> None:
    parser = build_parser()
    args = parser.parse_args()

    if args.command == "list-movies":
        print_movies()
    elif args.command == "search":
        print_search_results(title=args.title, genre=args.genre)
    elif args.command == "rate":
        if not 1 <= args.rating <= 10:
            raise ValueError("Rating must be between 1 and 10.")
        repository.add_rating(movie_id=args.movie_id, rating=args.rating, review_note=args.note)
        print("Rating saved.")
    elif args.command == "list-watchlist":
        print_watchlist()


if __name__ == "__main__":
    main()
