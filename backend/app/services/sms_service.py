from twilio.rest import Client
from app.config import settings
from app.logging_config import logger

_twilio_client = None


def get_twilio_client():
    global _twilio_client
    if _twilio_client is None:
        _twilio_client = Client(settings.TWILIO_ACCOUNT_SID, settings.TWILIO_AUTH_TOKEN)
    return _twilio_client


async def send_sos_sms(to_number: str, event_type: str, location: dict):
    client = get_twilio_client()
    body = f"SOS Alert type:{event_type}"

    try:
        client.messages.create(
            body=body,
            from_=settings.TWILIO_FROM_NUMBER,
            to=to_number,
        )
        logger.info(f"SMS sent to redacted_number status=success")
    except Exception:
        logger.error("SMS delivery failed")


async def send_plain_sms(to_number: str, body: str) -> bool:
    client = get_twilio_client()

    try:
        client.messages.create(
            body=body,
            from_=settings.TWILIO_FROM_NUMBER,
            to=to_number,
        )
        logger.info("SMS sent to redacted_number status=success")
        return True
    except Exception:
        logger.error("SMS delivery failed")
        return False