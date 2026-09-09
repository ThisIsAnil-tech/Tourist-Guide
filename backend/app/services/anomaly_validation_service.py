from app.utils.geo_utils import haversine

MIN_MOVEMENT_THRESHOLD_METERS = 50


async def validate_stoppage_claim(db, user_id: str, current_location: dict) -> bool:
    recent_locations_cursor = db["sos_events"].find(
        {"user_id": user_id}
    ).sort("created_at", -1).limit(5)
    recent_events = await recent_locations_cursor.to_list(length=5)

    if not recent_events:
        return True

    for event in recent_events:
        distance = haversine(current_location, event["location"])
        if distance >= MIN_MOVEMENT_THRESHOLD_METERS:
            return False

    return True