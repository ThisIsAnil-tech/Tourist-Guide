from fastapi import APIRouter, Request, Form, Depends
from app.database import get_database
from app.services.sos_pipeline_service import create_sos_event
from app.utils.validators import parse_sms_sos_body
from app.constants import DeliveryTier
from app.config import settings
from app.exceptions import UnauthorizedException
from twilio.request_validator import RequestValidator

router = APIRouter()


@router.post("")
async def receive_sms(
    request: Request,
    From: str = Form(...),
    Body: str = Form(...),
    db=Depends(get_database),
):
    if settings.SMS_WEBHOOK_VALIDATE_SIGNATURE:
        validator = RequestValidator(settings.TWILIO_AUTH_TOKEN)
        signature = request.headers.get("X-Twilio-Signature", "")
        form_data = await request.form()
        url = str(request.url)
        valid = validator.validate(url, dict(form_data), signature)
        if not valid:
            raise UnauthorizedException("Invalid webhook signature")

    parsed = parse_sms_sos_body(Body)
    if not parsed:
        return {"message": "Ignored malformed SMS"}

    user = await db["users"].find_one({"phone": From})
    if not user:
        return {"message": "Unknown sender"}

    await create_sos_event(
        db=db,
        user_id=str(user["_id"]),
        event_type=parsed["event_type"],
        location=parsed["location"],
        delivered_via=DeliveryTier.SMS.value,
    )
    return {"message": "SOS registered via SMS"}