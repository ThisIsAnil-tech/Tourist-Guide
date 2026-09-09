from datetime import datetime
from typing import Optional


class Location:
    def __init__(self, lat: float, lon: float):
        self.lat = lat
        self.lon = lon


class OriginMeta:
    def __init__(self, hop_count: Optional[int] = None, relay_chain: Optional[list[str]] = None):
        self.hop_count = hop_count
        self.relay_chain = relay_chain or []


class SOSEventModel:
    def __init__(
        self,
        user_id: str,
        event_type: str,
        location: dict,
        delivered_via: str,
        zone_id: Optional[str] = None,
        status: str = "active",
        origin_meta: Optional[dict] = None,
        resolved_by: Optional[str] = None,
        created_at: Optional[datetime] = None,
        resolved_at: Optional[datetime] = None,
    ):
        self.user_id = user_id
        self.event_type = event_type
        self.location = location
        self.delivered_via = delivered_via
        self.zone_id = zone_id
        self.status = status
        self.origin_meta = origin_meta or {}
        self.resolved_by = resolved_by
        self.created_at = created_at or datetime.utcnow()
        self.resolved_at = resolved_at

    def to_dict(self) -> dict:
        return self.__dict__