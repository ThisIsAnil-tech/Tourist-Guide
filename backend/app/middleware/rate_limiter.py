from app.redis_client import get_redis
from app.exceptions import RateLimitException
from app.logging_config import logger


async def check_rate_limit(key: str, max_attempts: int, window_seconds: int):
    try:
        r = get_redis()
        current = await r.incr(key)
        if current == 1:
            await r.expire(key, window_seconds)
        if current > max_attempts:
            raise RateLimitException("Too many attempts, please try again later")
    except RateLimitException:
        raise
    except Exception:
        logger.warning("Redis unavailable – rate limiting skipped")


async def login_rate_limit(identifier: str):
    from app.config import settings

    key = f"rate_limit:login:{identifier}"
    await check_rate_limit(key, settings.RATE_LIMIT_LOGIN_PER_MINUTE, 60)


async def password_reset_rate_limit(identifier: str):
    from app.config import settings

    key = f"rate_limit:password_reset:{identifier}"
    await check_rate_limit(key, settings.RATE_LIMIT_PASSWORD_RESET_PER_HOUR, 3600)