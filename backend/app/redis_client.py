import redis.asyncio as redis
from app.config import settings
from app.logging_config import logger

_redis_available = True

try:
    redis_pool = redis.ConnectionPool(
        host=settings.REDIS_HOST,
        port=settings.REDIS_PORT,
        password=settings.REDIS_PASSWORD or None,
        decode_responses=True,
    )
except Exception:
    redis_pool = None
    _redis_available = False
    logger.warning("Redis connection pool could not be created. Rate limiting disabled.")


class _NoOpRedis:
    """Fallback stub that silently skips Redis operations when Redis is unavailable."""

    async def incr(self, key):
        return 1

    async def expire(self, key, seconds):
        pass

    async def delete(self, key):
        pass

    async def ping(self):
        return False


def get_redis() -> redis.Redis:
    if redis_pool is not None:
        return redis.Redis(connection_pool=redis_pool)
    return _NoOpRedis()