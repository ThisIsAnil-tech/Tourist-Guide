from datetime import datetime
from typing import Optional


class ResponderModel:
    def __init__(
        self,
        user_id: str,
        org: Optional[str] = None,
        verified: bool = False,
        assigned_events: Optional[list[str]] = None,
        created_at: Optional[datetime] = None,
    ):
        self.user_id = user_id
        self.org = org
        self.verified = verified
        self.assigned_events = assigned_events or []
        self.created_at = created_at or datetime.utcnow()

    def to_dict(self) -> dict:
        return self.__dict__