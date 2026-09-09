from datetime import datetime
from typing import Optional


class ZoneModel:
    def __init__(
        self,
        name: str,
        polygon: dict,
        coordinates: dict,
        region_keywords: Optional[list[str]] = None,
        risk_score: float = 1.0,
        weather_snapshot: Optional[dict] = None,
        news_summary: Optional[str] = None,
        last_updated: Optional[datetime] = None,
    ):
        self.name = name
        self.polygon = polygon
        self.coordinates = coordinates
        self.region_keywords = region_keywords or []
        self.risk_score = risk_score
        self.weather_snapshot = weather_snapshot or {}
        self.news_summary = news_summary
        self.last_updated = last_updated or datetime.utcnow()

    def to_dict(self) -> dict:
        return self.__dict__