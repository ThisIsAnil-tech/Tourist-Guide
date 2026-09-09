from datetime import datetime, timedelta
from bson import ObjectId
from app.exceptions import ForbiddenException, ConflictException

STALE_UNLOCK_HOURS = 2


async def grant_access(db, event_id: str, responder_id: str):
    event = await db["sos_events"].find_one({"_id": ObjectId(event_id), "status": "active"})
    if not event:
        raise ForbiddenException("No active SOS event")

    result = await db["users"].find_one_and_update(
        {"_id": ObjectId(event["user_id"]), "identity_status": "locked"},
        {"$set": {
            "identity_status": "unlocked",
            "unlocked_by": responder_id,
            "unlocked_at": datetime.utcnow(),
        }},
    )

    if not result:
        raise ConflictException("Identity already unlocked")

    await db["identity_access_log"].insert_one({
        "event_id": event_id,
        "responder_id": responder_id,
        "action": "grant",
        "timestamp": datetime.utcnow(),
    })

    updated_user = await db["users"].find_one({"_id": ObjectId(event["user_id"])})
    return {
        "name": updated_user["name"],
        "phone": updated_user["phone"],
        "emergency_contacts": updated_user.get("emergency_contacts", []),
        "medical_info": updated_user.get("medical_info", {}),
    }


async def revoke_access(db, event_id: str):
    event = await db["sos_events"].find_one({"_id": ObjectId(event_id)})
    if not event:
        return

    await db["users"].update_one(
        {"_id": ObjectId(event["user_id"])},
        {"$set": {"identity_status": "locked", "unlocked_by": None, "unlocked_at": None}},
    )

    await db["identity_access_log"].insert_one({
        "event_id": event_id,
        "responder_id": event.get("resolved_by") or "system",
        "action": "revoke",
        "timestamp": datetime.utcnow(),
    })


async def revoke_stale_access(db):
    cutoff = datetime.utcnow() - timedelta(hours=STALE_UNLOCK_HOURS)
    stale_users_cursor = db["users"].find({
        "identity_status": "unlocked",
        "unlocked_at": {"$lte": cutoff},
    })
    stale_users = await stale_users_cursor.to_list(length=500)

    for user in stale_users:
        await db["users"].update_one(
            {"_id": user["_id"]},
            {"$set": {"identity_status": "locked", "unlocked_by": None, "unlocked_at": None}},
        )
        await db["identity_access_log"].insert_one({
            "event_id": "auto-stale-revoke",
            "responder_id": "system",
            "action": "revoke",
            "timestamp": datetime.utcnow(),
        })