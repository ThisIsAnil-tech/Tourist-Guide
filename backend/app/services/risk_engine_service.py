from datetime import datetime
from app.services import weather_client, news_scraper
from app.logging_config import logger

WEATHER_WEIGHT = 0.50
NEWS_WEIGHT = 0.30
HISTORICAL_WEIGHT = 0.20

RISK_JUMP_ALERT_THRESHOLD = 3.0


async def compute_zone_risk(zone: dict) -> float:
    weather_score = await weather_client.get_risk_component(zone["coordinates"])
    news_score = await news_scraper.get_risk_component(zone.get("region_keywords", []))
    historical_score = await query_historical_incident_rate(zone["_id"])

    combined = (
        (WEATHER_WEIGHT * weather_score)
        + (NEWS_WEIGHT * news_score)
        + (HISTORICAL_WEIGHT * historical_score)
    )

    return normalize(combined, scale=(1, 10))


def normalize(value: float, scale: tuple) -> float:
    low, high = scale
    return round(low + (value * (high - low)), 2)


async def query_historical_incident_rate(zone_id) -> float:
    from app.database import get_database

    db = get_database()
    count = await db["sos_events"].count_documents({"zone_id": str(zone_id)})
    return min(count / 20, 1.0)


async def recompute_all_zone_risks():
    from app.database import get_database

    db = get_database()
    zones_cursor = db["zones"].find({})
    zones = await zones_cursor.to_list(length=1000)

    for zone in zones:
        old_score = zone.get("risk_score", 1.0)
        new_score = await compute_zone_risk(zone)

        await db["zones"].update_one(
            {"_id": zone["_id"]},
            {"$set": {"risk_score": new_score, "last_updated": datetime.utcnow()}},
        )

        if new_score - old_score >= RISK_JUMP_ALERT_THRESHOLD:
            logger.info(f"Risk spike detected for zone {zone['_id']}: {old_score} -> {new_score}")