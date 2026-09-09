from app.redis_client import get_redis


async def increment_and_check(key: str, max_attempts: int, window_seconds: int) -> bool:
    redis = get_redis()
    current = await redis.incr(key)
    if current == 1:
        await redis.expire(key, window_seconds)
    return current <= max_attempts


async def reset_key(key: str):
    redis = get_redis()
    await redis.delete(key)