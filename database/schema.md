# Database Schema — Mocktale-Style Movie Review App

This schema defines the core data model.
All APIs, backend logic, and frontend data must follow this.

--------------------------------------------------
CORE PRINCIPLES
--------------------------------------------------
- Opinion-first (verdicts, not star ratings)
- One review per user per movie
- Reviews are first-class content
- Vibe charts are derived from data
- Schema must be scalable and strict

--------------------------------------------------
1. USERS
--------------------------------------------------
users
- id (UUID, PRIMARY KEY)
- username (VARCHAR, UNIQUE, NOT NULL)
- email (VARCHAR, UNIQUE, NOT NULL)
- password_hash (TEXT, NOT NULL)
- avatar_url (TEXT)
- bio (TEXT)
- role (ENUM: user, admin)
- created_at (TIMESTAMP)
- updated_at (TIMESTAMP)

--------------------------------------------------
2. MOVIES
--------------------------------------------------
movies
- id (UUID, PRIMARY KEY)
- tmdb_id (INTEGER, UNIQUE)
- title (VARCHAR, NOT NULL)
- overview (TEXT)
- release_date (DATE)
- runtime_minutes (INTEGER)
- language (VARCHAR)
- country (VARCHAR)
- age_rating (VARCHAR)
- poster_url (TEXT)
- banner_url (TEXT)
- created_at (TIMESTAMP)

--------------------------------------------------
3. GENRES
--------------------------------------------------
genres
- id (UUID, PRIMARY KEY)
- name (VARCHAR, UNIQUE)

movie_genres
- movie_id (FK → movies.id)
- genre_id (FK → genres.id)
- PRIMARY KEY (movie_id, genre_id)

--------------------------------------------------
4. VERDICT SYSTEM (CORE FEATURE)
--------------------------------------------------
verdict_type ENUM:
- SKIP
- TIMEPASS
- GO_FOR_IT
- PERFECTION

--------------------------------------------------
5. REVIEWS
--------------------------------------------------
reviews
- id (UUID, PRIMARY KEY)
- user_id (FK → users.id)
- movie_id (FK → movies.id)
- verdict (verdict_type, NOT NULL)
- review_text (TEXT)
- contains_spoilers (BOOLEAN DEFAULT false)
- likes_count (INTEGER DEFAULT 0)
- created_at (TIMESTAMP)
- updated_at (TIMESTAMP)

CONSTRAINT:
- UNIQUE (user_id, movie_id)

--------------------------------------------------
6. REVIEW LIKES
--------------------------------------------------
review_likes
- user_id (FK → users.id)
- review_id (FK → reviews.id)
- created_at (TIMESTAMP)

PRIMARY KEY (user_id, review_id)

--------------------------------------------------
7. COLLECTIONS
--------------------------------------------------
collections
- id (UUID, PRIMARY KEY)
- user_id (FK → users.id)
- name (VARCHAR)
- is_public (BOOLEAN DEFAULT true)
- created_at (TIMESTAMP)

collection_movies
- collection_id (FK → collections.id)
- movie_id (FK → movies.id)
- created_at (TIMESTAMP)

PRIMARY KEY (collection_id, movie_id)

--------------------------------------------------
8. WATCH STATUS
--------------------------------------------------
watch_status
- user_id (FK → users.id)
- movie_id (FK → movies.id)
- watched (BOOLEAN DEFAULT false)
- watched_at (TIMESTAMP)

PRIMARY KEY (user_id, movie_id)

--------------------------------------------------
9. CAST & CREW
--------------------------------------------------
people
- id (UUID, PRIMARY KEY)
- name (VARCHAR)
- profile_image (TEXT)

movie_cast
- movie_id_