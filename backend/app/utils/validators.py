import re

SMS_SOS_PATTERN = re.compile(
    r"SOS\s+lat:(-?\d+\.?\d*)\s+lon:(-?\d+\.?\d*)\s+type:(\w+)",
    re.IGNORECASE,
)


def parse_sms_sos_body(body: str) -> dict | None:
    match = SMS_SOS_PATTERN.search(body)
    if not match:
        return None

    lat, lon, event_type = match.groups()

    return {
        "location": {"lat": float(lat), "lon": float(lon)},
        "event_type": event_type.upper(),
    }


def is_valid_mongo_object_id(value: str) -> bool:
    return bool(re.fullmatch(r"[a-f0-9]{24}", value))