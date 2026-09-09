from datetime import datetime, timedelta
from bson import ObjectId
from app.utils.geo_utils import point_in_polygon
from app.services.notification_service import notify_responders

DEDUPLICATION_WINDOW_SECONDS = 60


async def create_sos_event(
    db,
    user_id: str,
    event_type: str,
    location: dict,
    delivered_via: str,
    origin_meta: dict = None,
    is_test: bool = False,
):
    existing = await db["sos_events"].find_one({
        "user_id": user_id,
        "status": "active",
        "created_at": {"$gte": datetime.utcnow() - timedelta(seconds=DEDUPLICATION_WINDOW_SECONDS)},
    })
    if existing:
        return existing

    zone_id = await resolve_zone(db, location)

    event_doc = {
        "user_id": user_id,
        "event_type": event_type,
        "location": location,
        "delivered_via": delivered_via,
        "zone_id": zone_id,
        "status": "active",
        "is_test": is_test,
        "origin_meta": origin_meta or {},
        "resolved_by": None,
        "created_at": datetime.utcnow(),
        "resolved_at": None,
    }

    result = await db["sos_events"].insert_one(event_doc)
    event_doc["_id"] = result.inserted_id

    if not is_test:
        await notify_responders(db, event_doc)

    return event_doc


async def resolve_zone(db, location: dict):
    zones_cursor = db["zones"].find({})
    zones = await zones_cursor.to_list(length=1000)
    for zone in zones:
        if point_in_polygon(location, zone["polygon"]):
            return str(zone["_id"])
    return None