from __future__ import annotations

import argparse
import csv
from datetime import datetime
from pathlib import Path

from . import repository


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        prog="movie-vault",
        description="A simple Python + SQL Server movie tracker."
    )
    subparsers = parser.add_subparsers(dest="command", required=True)

    subparsers.add_parser("menu", help="Launch the interactive menu.")
    subparsers.add_parser("list-movies", help="Show all movies.")

    search_parser = subparsers.add_parser("search", help="Search movies by title or genre.")
    search_parser.add_argument("--title", help="Part of a movie title.")
    search_parser.add_argument("--genre", help="Exact genre name.")
    search_parser.add_argument("--director", help="Part of a director name.")

    top_rated_parser = subparsers.add_parser("top-rated", help="Show top-rated movies.")
    top_rated_parser.add_argument("--limit", type=int, default=10, help="Maximum number of movies to show.")
    top_rated_parser.add_argument("--genre", help="Optional genre filter.")
    top_rated_parser.add_argument("--director", help="Optional director filter.")

    add_movie_parser = subparsers.add_parser("add-movie", help="Add a movie to the database.")
    add_movie_parser.add_argument("--title", required=True, help="Movie title.")
    add_movie_parser.add_argument("--year", type=int, required=True, help="Release year.")
    add_movie_parser.add_argument("--genre", required=True, help="Genre name.")
    add_movie_parser.add_argument("--director", required=True, help="Director name.")
    add_movie_parser.add_argument("--runtime", type=int, required=True, help="Runtime in minutes.")
    add_movie_parser.add_argument("--average-rating", type=float, help="Optional average rating.")

    update_movie_rating_parser = subparsers.add_parser("update-rating", help="Update your latest rating for a movie.")
    update_movie_rating_parser.add_argument("--movie-id", type=int, required=True, help="Movie ID.")
    update_movie_rating_parser.add_argument("--rating", type=int, required=True, help="New rating (1-10).")

    movie_details_parser = subparsers.add_parser("movie-details", help="Show details for a specific movie.")
    movie_details_parser.add_argument("--movie-id", type=int, required=True, help="Movie ID.")

    watchlist_parser = subparsers.add_parser("add-to-watchlist", help="Add a movie to the watchlist.")
    watchlist_parser.add_argument("--movie-id", type=int, required=True, help="Movie ID.")

    remove_watchlist_parser = subparsers.add_parser(
        "remove-from-watchlist",
        help="Remove a movie from the watchlist."
    )
    remove_watchlist_parser.add_argument("--movie-id", type=int, required=True, help="Movie ID.")

    mark_watched_parser = subparsers.add_parser("mark-watched", help="Mark a watchlist movie as watched.")
    mark_watched_parser.add_argument("--movie-id", type=int, required=True, help="Movie ID.")

    rate_parser = subparsers.add_parser("rate", help="Add your personal rating for a movie.")
    rate_parser.add_argument("--movie-id", type=int, required=True, help="Movie ID.")
    rate_parser.add_argument("--rating", type=int, required=True, help="Rating from 1 to 10.")
    rate_parser.add_argument("--note", help="Optional short review note.")

    recent_watchlist_parser = subparsers.add_parser("recent-watchlist", help="Show recently added watchlist entries.")
    recent_watchlist_parser.add_argument("--limit", type=int, default=5, help="Maximum number of entries to show.")

    export_watchlist_parser = subparsers.add_parser("export-watchlist", help="Export the watchlist to a file.")
    export_watchlist_parser.add_argument("--output", required=True, help="Output file path.")

    subparsers.add_parser("list-watchlist", help="Show watchlist entries.")
    subparsers.add_parser("list-watched", help="Show watched movies from the watchlist.")
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


def print_search_results(
    title: str | None = None,
    genre: str | None = None,
    director: str | None = None,
) -> None:
    movies = repository.search_movies(title=title, genre=genre, director=director)
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

def export_watchlist(output_path: str) -> None:
    output = Path(output_path).expanduser()
    if not str(output).strip():
        raise ValueError("Output path cannot be empty.")

    items = repository.list_watchlist()
    if not items:
        print("The watchlist is empty. No file will be created.")
        return

    output.parent.mkdir(parents=True, exist_ok=True)

    try:
        with output.open("w", newline="", encoding="utf-8") as file:
            writer = csv.writer(file)
            writer.writerow([
                "watchlist_id",
                "movie_id",
                "title",
                "release_year",
                "added_on",
                "is_watched",
            ])

            for item in items:
                writer.writerow([
                    item.watchlist_id,
                    item.movie_id,
                    item.title,
                    item.release_year,
                    item.added_on,
                    item.is_watched,
                ])
    except PermissionError as error:
        raise PermissionError(
            f"Cannot write to '{output}'. Try a location in your user folder such as "
            f"'C:\\Users\\Kevin\\OneDrive\\sql\\sql-server\\exports\\watchlist.csv'."
        ) from error

    print(f"Watchlist exported to {output}.")

def print_top_rated_movies(
    limit: int = 10,
    genre: str | None = None,
    director: str | None = None,
) -> None:
    if limit <= 0:
        raise ValueError("Limit must be greater than 0.")

    movies = repository.get_top_rated_movies(limit=limit, genre=genre, director=director)
    if not movies:
        print("No top rated movies found.")
        return

    print("Top Rated Movies:")
    for movie in movies:
        print(
            f"[{movie.movie_id}] {movie.title} ({movie.release_year}) | "
            f"{movie.genre_name} | {movie.director_name} | "
            f"{movie.runtime_minutes} min | Avg: {movie.average_rating}"
        )


def print_watched_watchlist() -> None:
    items = repository.list_watchlist(watched_only=True)
    if not items:
        print("No watched movies found on the watchlist.")
        return

    for item in items:
        print(f"[{item.movie_id}] {item.title} ({item.release_year}) - Watched")


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

    movie_id, was_inserted = repository.add_movie(
        title=title,
        release_year=args.year,
        genre_name=genre,
        director_name=director,
        runtime_minutes=args.runtime,
        average_rating=args.average_rating,
    )
    if was_inserted:
        print(f"Movie added with ID {movie_id}.")
    else:
        print(f"Movie already exists with ID {movie_id}.")


def add_movie_to_watchlist(movie_id: int) -> None:
    if movie_id <= 0:
        raise ValueError("Movie ID must be greater than 0.")

    watchlist_id, was_inserted = repository.add_to_watchlist(movie_id)
    if was_inserted:
        print(f"Movie added to watchlist with entry ID {watchlist_id}.")
    else:
        print(f"Movie is already on the watchlist with entry ID {watchlist_id}.")


def mark_movie_as_watched(movie_id: int) -> None:
    if movie_id <= 0:
        raise ValueError("Movie ID must be greater than 0.")

    watchlist_id, was_updated = repository.mark_watchlist_as_watched(movie_id)
    if was_updated:
        print(f"Watchlist entry {watchlist_id} marked as watched.")
    else:
        print(f"Watchlist entry {watchlist_id} was already marked as watched.")


def remove_from_watchlist(movie_id: int) -> None:
    if movie_id <= 0:
        raise ValueError("Movie ID must be greater than 0.")

    was_deleted = repository.remove_from_watchlist(movie_id)
    if was_deleted:
        print(f"Movie ID {movie_id} removed from watchlist.")
    else:
        print(f"Movie ID {movie_id} was not found on the watchlist.")


def save_rating(movie_id: int, rating: int, note: str | None = None) -> None:
    if movie_id <= 0:
        raise ValueError("Movie ID must be greater than 0.")

    if not 1 <= rating <= 10:
        raise ValueError("Rating must be between 1 and 10.")

    repository.add_rating(movie_id=movie_id, rating=rating, review_note=note)
    print("Rating saved.")

def update_movie_rating(movie_id: int, rating: int) -> None:
    if movie_id <= 0:
        raise ValueError("Movie ID must be greater than 0.")

    if not 1 <= rating <= 10:
        raise ValueError("Rating must be between 1 and 10.")

    repository.update_rating(movie_id=movie_id, rating=rating)
    print("Rating updated.")

def print_movie_details(movie_id: int) -> None:
    if movie_id <= 0:
        raise ValueError("Movie ID must be greater than 0.")

    details = repository.get_movie_by_id(movie_id)
    if details is None:
        print(f"No movie found with ID {movie_id}.")
        return

    print(f"Title: {details.title}")
    print(f"Release Year: {details.release_year}")
    print(f"Genre: {details.genre_name}")
    print(f"Director: {details.director_name}")
    print(f"Runtime: {details.runtime_minutes} minutes")
    print(f"Average Rating: {details.average_rating}")

def print_recent_watchlist_entries(limit: int = 5) -> None:
    if limit <= 0:
        raise ValueError("Limit must be greater than 0.")

    entries = repository.get_recent_watchlist_entries(limit=limit)
    if not entries:
        print("No watchlist entries found.")
        return

    print("Recently Added Watchlist Entries:")
    for entry in entries:
        status = "Watched" if entry.is_watched else "To Watch"
        print(f"[{entry.movie_id}] {entry.title} ({entry.release_year}) - {status}")

def prompt_text(prompt: str, *, optional: bool = False) -> str | None:
    while True:
        value = input(prompt).strip()
        if value:
            return value
        if optional:
            return None
        print("A value is required.")


def prompt_int(prompt: str, *, minimum: int | None = None, maximum: int | None = None) -> int:
    while True:
        raw_value = input(prompt).strip()
        try:
            value = int(raw_value)
        except ValueError:
            print("Please enter a whole number.")
            continue

        if minimum is not None and value < minimum:
            print(f"Please enter a number greater than or equal to {minimum}.")
            continue

        if maximum is not None and value > maximum:
            print(f"Please enter a number less than or equal to {maximum}.")
            continue

        return value


def prompt_float(prompt: str, *, minimum: float | None = None, maximum: float | None = None) -> float | None:
    while True:
        raw_value = input(prompt).strip()
        if not raw_value:
            return None

        try:
            value = float(raw_value)
        except ValueError:
            print("Please enter a number like 7.5, or press Enter to skip.")
            continue

        if minimum is not None and value < minimum:
            print(f"Please enter a number greater than or equal to {minimum}.")
            continue

        if maximum is not None and value > maximum:
            print(f"Please enter a number less than or equal to {maximum}.")
            continue

        return value


def show_menu() -> None:
    print("\nMovie Vault")
    print("1. List movies")
    print("2. Search movies")
    print("3. Add movie")
    print("4. Add to watchlist")
    print("5. View watchlist")
    print("6. Mark watchlist as watched")
    print("7. Rate a movie")
    print("8. Update a movie rating")
    print("9. Remove from watchlist")
    print("10. Show watched movies only")
    print("11. Search by director")
    print("12. Top Rated Movies")
    print("13. Get movie details")
    print("14. Print recently added watchlist entries")
    print("15. Export watchlist to CSV")
    print("16. Exit")


def run_menu() -> None:
    current_year = datetime.now().year

    while True:
        show_menu()
        choice = input("Choose an option: ").strip()

        try:
            if choice == "1":
                print_movies()
            elif choice == "2":
                title = prompt_text("Title contains (press Enter to skip): ", optional=True)
                genre = prompt_text("Genre name (press Enter to skip): ", optional=True)
                director = prompt_text("Director name (press Enter to skip): ", optional=True)
                print_search_results(title=title, genre=genre, director=director)
            elif choice == "3":
                title = prompt_text("Title: ")
                year = prompt_int("Release year: ", minimum=1888, maximum=current_year)
                genre = prompt_text("Genre: ")
                director = prompt_text("Director: ")
                runtime = prompt_int("Runtime in minutes: ", minimum=1)
                average_rating = prompt_float(
                    "Average rating 0-10 (press Enter to skip): ",
                    minimum=0,
                    maximum=10,
                )
                create_movie(
                    argparse.Namespace(
                        title=title,
                        year=year,
                        genre=genre,
                        director=director,
                        runtime=runtime,
                        average_rating=average_rating,
                    )
                )
            elif choice == "4":
                movie_id = prompt_int("Movie ID to add to watchlist: ", minimum=1)
                add_movie_to_watchlist(movie_id)
            elif choice == "5":
                print_watchlist()
            elif choice == "6":
                movie_id = prompt_int("Movie ID to mark as watched: ", minimum=1)
                mark_movie_as_watched(movie_id)
            elif choice == "7":
                movie_id = prompt_int("Movie ID to rate: ", minimum=1)
                rating = prompt_int("Your rating (1-10): ", minimum=1, maximum=10)
                note = prompt_text("Optional note (press Enter to skip): ", optional=True)
                save_rating(movie_id=movie_id, rating=rating, note=note)
            elif choice == "8":
                movie_id = prompt_int("Movie ID to update rating for: ", minimum=1)
                rating = prompt_int("Your new rating (1-10): ", minimum=1, maximum=10)
                update_movie_rating(movie_id=movie_id, rating=rating)
            elif choice == "9":
                movie_id = prompt_int("Movie ID to remove from watchlist: ", minimum=1)
                remove_from_watchlist(movie_id)
            elif choice == "10":
                print_watched_watchlist()
            elif choice == "11":
                director = prompt_text("Director name to search for: ")
                print_search_results(title=None, genre=None, director=director)
            elif choice == "12":
                limit = prompt_int("How many top rated movies should be shown? ", minimum=1)
                genre = prompt_text("Genre filter (press Enter to skip): ", optional=True)
                director = prompt_text("Director filter (press Enter to skip): ", optional=True)
                print_top_rated_movies(limit=limit, genre=genre, director=director)
            elif choice == "13":
                movie_id = prompt_int("Movie ID to view details for: ", minimum=1)
                print_movie_details(movie_id)
            elif choice == "14":
                limit = prompt_int("How many recent watchlist entries should be shown? ", minimum=1)
                print_recent_watchlist_entries(limit=limit)
            elif choice == "15":
                output_path = prompt_text("Output file path: ")
                export_watchlist(output_path=output_path)
            elif choice == "16":
                print("Goodbye.")
                break
            else:
                print("Please choose a number from 1 to 16.")
        except Exception as error:
            print(f"Error: {error}")

def main() -> None:
    parser = build_parser()
    args = parser.parse_args()

    if args.command == "menu":
        run_menu()
    elif args.command == "list-movies":
        print_movies()
    elif args.command == "search":
        print_search_results(title=args.title, genre=args.genre, director=args.director)
    elif args.command == "add-movie":
        create_movie(args)
    elif args.command == "add-to-watchlist":
        add_movie_to_watchlist(args.movie_id)
    elif args.command == "mark-watched":
        mark_movie_as_watched(args.movie_id)
    elif args.command == "rate":
        save_rating(movie_id=args.movie_id, rating=args.rating, note=args.note)
    elif args.command == "list-watchlist":
        print_watchlist()
    elif args.command == "list-watched":
        print_watched_watchlist()
    elif args.command == "remove-from-watchlist":
        remove_from_watchlist(args.movie_id)
    elif args.command == "top-rated":
        print_top_rated_movies(limit=args.limit, genre=args.genre, director=args.director)
    elif args.command == "update-rating":
        update_movie_rating(movie_id=args.movie_id, rating=args.rating)
    elif args.command == "recent-watchlist":
        print_recent_watchlist_entries(limit=args.limit)
    elif args.command == "export-watchlist":
        export_watchlist(output_path=args.output)
    elif args.command == "movie-details":
        print_movie_details(movie_id=args.movie_id)
    else:
        print("Unknown command.")
  
if __name__ == "__main__":
    main()
