from bson import ObjectId
from app.services.sms_service import send_sos_sms
from app.logging_config import logger


async def notify_responders(db, event: dict):
    responders_cursor = db["responders"].find({"verified": True})
    responders = await responders_cursor.to_list(length=100)

    for responder in responders:
        logger.info(f"Notifying responder for event {event['_id']}")

    await notify_emergency_contacts(db, event)


async def notify_emergency_contacts(db, event: dict):
    user = await db["users"].find_one({"_id": ObjectId(event["user_id"])})
    if not user:
        return

    for contact in user.get("emergency_contacts", []):
        await send_sos_sms(contact["phone"], event["event_type"], event["location"])