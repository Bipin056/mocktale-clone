REST API SPEC — MOCKTALE-STYLE MOVIE REVIEW APP
Base URL
/api/v1

Authentication

JWT access token

Sent in header:

Authorization: Bearer <token>

1️⃣ AUTH APIs (MANDATORY)
Register
POST /auth/register


Body

{
  "username": "bipin",
  "email": "bipin@email.com",
  "password": "strongpassword"
}

Login
POST /auth/login


Body

{
  "email": "bipin@email.com",
  "password": "strongpassword"
}


Response

{
  "token": "jwt_token",
  "user": {
    "id": "uuid",
    "username": "bipin"
  }
}

Get Current User
GET /auth/me

2️⃣ MOVIES APIs
Get Movie (Full Page Data)
GET /movies/:movieId


Response

{
  "id": "uuid",
  "title": "Border 2",
  "overview": "...",
  "runtime": 199,
  "language": "Hindi",
  "age_rating": "13+",
  "verdict_stats": {
    "SKIP": 15,
    "TIMEPASS": 48,
    "GO_FOR_IT": 34,
    "PERFECTION": 3
  },
  "vibe_chart": {
    "Drama": 40,
    "Action": 25,
    "Romance": 15,
    "Thriller": 15,
    "Comedy": 5
  }
}

Search Movies
GET /movies/search?q=border

3️⃣ REVIEWS APIs (CORE FEATURE)
Add / Update Review
POST /reviews


Body

{
  "movie_id": "uuid",
  "verdict": "GO_FOR_IT",
  "review_text": "Strong performances...",
  "contains_spoilers": false
}


Rules

One review per user per movie

Sending POST again updates existing review

Get Movie Reviews
GET /movies/:movieId/reviews?sort=liked


Response

[
  {
    "id": "uuid",
    "username": "bipin",
    "verdict": "TIMEPASS",
    "review_text": "...",
    "likes": 124,
    "contains_spoilers": false,
    "created_at": "2026-01-31"
  }
]

Delete Review
DELETE /reviews/:reviewId

4️⃣ REVIEW LIKES
Like / Unlike Review
POST /reviews/:reviewId/like


Behavior

Toggles like

One like per user per review

5️⃣ WATCH STATUS
Mark as Watched
POST /movies/:movieId/watch

Unmark as Watched
DELETE /movies/:movieId/watch

6️⃣ COLLECTIONS APIs
Create Collection
POST /collections


Body

{
  "name": "Weekend Movies",
  "is_public": true
}

Add Movie to Collection
POST /collections/:collectionId/movies


Body

{
  "movie_id": "uuid"
}

Get User Collections
GET /users/:userId/collections

7️⃣ USER PROFILE
Get User Profile
GET /users/:userId


Response

{
  "username": "bipin",
  "reviews_count": 5,
  "followers": 1,
  "following": 1
}

Get User Reviews
GET /users/:userId/reviews?verdict=PERFECTION

8️⃣ REPORTING & ADMIN
Report Review
POST /reports


Body

{
  "review_id": "uuid",
  "reason": "Abusive language"
}

Admin: View Reports
GET /admin/reports


(Admin only)