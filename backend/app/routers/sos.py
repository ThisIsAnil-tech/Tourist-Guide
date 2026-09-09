from fastapi import APIRouter, Depends, Query
from bson import ObjectId
from datetime import datetime
from app.database import get_database
from app.dependencies import get_current_user, require_role
from app.schemas.sos_schemas import SOSCreate, SOSOut
from app.services.sos_pipeline_service import create_sos_event
from app.services.identity_state_machine import revoke_access
from app.constants import DeliveryTier, Role
from app.exceptions import NotFoundException, ForbiddenException

router = APIRouter()


@router.post("/trigger", response_model=SOSOut, status_code=201)
async def trigger_sos(
    payload: SOSCreate,
    user: dict = Depends(get_current_user),
    db=Depends(get_database),
):
    event = await create_sos_event(
        db=db,
        user_id=str(user["_id"]),
        event_type=payload.event_type,
        location=payload.location.model_dump(),
        delivered_via=DeliveryTier.INTERNET.value,
        is_test=payload.is_test,
    )
    return event


@router.get("/active", response_model=list[SOSOut])
async def get_active_sos(
    user: dict = Depends(require_role(Role.ADMIN, Role.RESPONDER)),
    db=Depends(get_database),
):
    cursor = db["sos_events"].find({"status": "active", "is_test": False}).sort("created_at", -1)
    return await cursor.to_list(length=200)


@router.get("/my-events", response_model=list[SOSOut])
async def get_my_events(
    limit: int = Query(50, le=200),
    user: dict = Depends(get_current_user),
    db=Depends(get_database),
):
    cursor = db["sos_events"].find({"user_id": str(user["_id"])}).sort("created_at", -1).limit(limit)
    return await cursor.to_list(length=limit)


@router.get("/{event_id}", response_model=SOSOut)
async def get_sos_event(
    event_id: str,
    user: dict = Depends(get_current_user),
    db=Depends(get_database),
):
    event = await db["sos_events"].find_one({"_id": ObjectId(event_id)})
    if not event:
        raise NotFoundException("SOS event not found")

    is_owner = str(event["user_id"]) == str(user["_id"])
    is_authorized = user["role"] in [Role.RESPONDER.value, Role.ADMIN.value]
    if not is_owner and not is_authorized:
        raise ForbiddenException("Not authorized to view this event")

    return event


@router.put("/{event_id}/resolve", response_model=SOSOut)
async def resolve_sos_event(
    event_id: str,
    user: dict = Depends(get_current_user),
    db=Depends(get_database),
):
    event = await db["sos_events"].find_one({"_id": ObjectId(event_id)})
    if not event:
        raise NotFoundException("SOS event not found")

    is_owner = str(event["user_id"]) == str(user["_id"])
    is_authorized = user["role"] in [Role.RESPONDER.value, Role.ADMIN.value]
    if not is_owner and not is_authorized:
        raise ForbiddenException("Not authorized to resolve this event")

    await db["sos_events"].update_one(
        {"_id": ObjectId(event_id)},
        {"$set": {"status": "resolved", "resolved_by": str(user["_id"]), "resolved_at": datetime.utcnow()}},
    )
    await revoke_access(db, event_id)

    return await db["sos_events"].find_one({"_id": ObjectId(event_id)})