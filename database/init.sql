-- Enable UUID support
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

--------------------------------------------------
-- ENUMS
--------------------------------------------------
CREATE TYPE verdict_type AS ENUM (
  'SKIP',
  'TIMEPASS',
  'GO_FOR_IT',
  'PERFECTION'
);

CREATE TYPE user_role AS ENUM (
  'user',
  'admin'
);

--------------------------------------------------
-- USERS
--------------------------------------------------
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  username VARCHAR(50) UNIQUE NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  password_hash TEXT NOT NULL,
  avatar_url TEXT,
  bio TEXT,
  role user_role DEFAULT 'user',
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

--------------------------------------------------
-- MOVIES
--------------------------------------------------
CREATE TABLE movies (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  tmdb_id INTEGER UNIQUE,
  title VARCHAR(255) NOT NULL,
  overview TEXT,
  release_date DATE,
  runtime_minutes INTEGER,
  language VARCHAR(50),
  country VARCHAR(50),
  age_rating VARCHAR(20),
  poster_url TEXT,
  banner_url TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);

--------------------------------------------------
-- GENRES
--------------------------------------------------
CREATE TABLE genres (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE movie_genres (
  movie_id UUID REFERENCES movies(id) ON DELETE CASCADE,
  genre_id UUID REFERENCES genres(id) ON DELETE CASCADE,
  PRIMARY KEY (movie_id, genre_id)
);

--------------------------------------------------
-- REVIEWS
--------------------------------------------------
CREATE TABLE reviews (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  movie_id UUID REFERENCES movies(id) ON DELETE CASCADE,
  verdict verdict_type NOT NULL,
  review_text TEXT,
  contains_spoilers BOOLEAN DEFAULT FALSE,
  likes_count INTEGER DEFAULT 0,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  UNIQUE (user_id, movie_id)
);

--------------------------------------------------
-- REVIEW LIKES
--------------------------------------------------
CREATE TABLE review_likes (
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  review_id UUID REFERENCES reviews(id) ON DELETE CASCADE,
  created_at TIMESTAMP DEFAULT NOW(),
  PRIMARY KEY (user_id, review_id)
);

--------------------------------------------------
-- COLLECTIONS
--------------------------------------------------
CREATE TABLE collections (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  name VARCHAR(255) NOT NULL,
  is_public BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE collection_movies (
  collection_id UUID REFERENCES collections(id) ON DELETE CASCADE,
  movie_id UUID REFERENCES movies(id) ON DELETE CASCADE,
  created_at TIMESTAMP DEFAULT NOW(),
  PRIMARY KEY (collection_id, movie_id)
);

--------------------------------------------------
-- WATCH STATUS
--------------------------------------------------
CREATE TABLE watch_status (
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  movie_id UUID REFERENCES movies(id) ON DELETE CASCADE,
  watched BOOLEAN DEFAULT FALSE,
  watched_at TIMESTAMP,
  PRIMARY KEY (user_id, movie_id)
);

--------------------------------------------------
-- PEOPLE (CAST & CREW)
--------------------------------------------------
CREATE TABLE people (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name VARCHAR(255) NOT NULL,
  profile_image TEXT
);

CREATE TABLE movie_cast (
  movie_id UUID REFERENCES movies(id) ON DELETE CASCADE,
  person_id UUID REFERENCES people(id) ON DELETE CASCADE,
  character_name VARCHAR(255),
  PRIMARY KEY (movie_id, person_id)
);

CREATE TABLE movie_crew (
  movie_id UUID REFERENCES movies(id) ON DELETE CASCADE,
  person_id UUID REFERENCES people(id) ON DELETE CASCADE,
  role VARCHAR(100),
  PRIMARY KEY (movie_id, person_id, role)
);

--------------------------------------------------
-- REPORTS (MODERATION)
--------------------------------------------------
CREATE TABLE reports (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  reporter_id UUID REFERENCES users(id) ON DELETE CASCADE,
  review_id UUID REFERENCES reviews(id) ON DELETE CASCADE,
  reason TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);

--------------------------------------------------
-- INDEXES (PERFORMANCE)
--------------------------------------------------
CREATE INDEX idx_reviews_movie ON reviews(movie_id);
CREATE INDEX idx_reviews_user ON reviews(user_id);
CREATE INDEX idx_review_likes_review ON review_likes(review_id);
CREATE INDEX idx_movies_tmdb ON movies(tmdb_id);