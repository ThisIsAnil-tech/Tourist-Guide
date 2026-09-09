# Tourist Safety Backend

FastAPI backend for the Smart Tourist Safety and Incident Response System.

## Setup

1. Copy `.env.example` to `.env` and fill in real values.
2. Run `docker-compose up --build`.
3. API docs available at `/docs` in non-production environments only.

## Security Notice

CORS is currently open to all origins for development. Restrict `ALLOWED_ORIGINS`
in `.env` to the mobile app and admin dashboard domains before production deployment.

If any secret was ever hardcoded during development, rotate it immediately
before launch, since old values persist in git history.