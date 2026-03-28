from dataclasses import dataclass
from datetime import datetime


@dataclass
class Movie:
    movie_id: int
    title: str
    release_year: int
    genre_name: str
    director_name: str
    runtime_minutes: int
    average_rating: float | None


@dataclass
class WatchlistItem:
    watchlist_id: int
    movie_id: int
    title: str
    release_year: int
    added_on: datetime
    is_watched: bool

