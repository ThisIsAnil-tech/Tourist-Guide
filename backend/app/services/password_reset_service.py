import secrets
from datetime import datetime, timedelta
from app.services.sms_service import send_plain_sms
from app.logging_config import logger

RESET_TOKEN_EXPIRE_MINUTES = 15
RESET_CODE_LENGTH = 6


async def create_reset_token(db, user_id: str) -> str:
    token = secrets.token_urlsafe(32)
    expires_at = datetime.utcnow() + timedelta(minutes=RESET_TOKEN_EXPIRE_MINUTES)

    await db["password_reset_tokens"].insert_one({
        "token": token,
        "user_id": user_id,
        "expires_at": expires_at,
        "created_at": datetime.utcnow(),
    })

    return token


async def send_reset_notification(phone: str, token: str):
    body = f"Your Tourist Safety password reset code is: {token[:8]}. This code expires in {RESET_TOKEN_EXPIRE_MINUTES} minutes."
    sent = await send_plain_sms(phone, body)
    if not sent:
        logger.error("Password reset SMS failed to send for redacted_number")


async def validate_and_consume_token(db, token: str) -> str:
    record = await db["password_reset_tokens"].find_one({"token": token})

    if not record:
        return None

    if record["expires_at"] < datetime.utcnow():
        await db["password_reset_tokens"].delete_one({"_id": record["_id"]})
        return None

    await db["password_reset_tokens"].delete_one({"_id": record["_id"]})
    return record["user_id"]