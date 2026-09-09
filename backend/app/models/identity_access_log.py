from datetime import datetime


class IdentityAccessLogModel:
    def __init__(
        self,
        event_id: str,
        responder_id: str,
        action: str,
        timestamp: datetime = None,
    ):
        self.event_id = event_id
        self.responder_id = responder_id
        self.action = action
        self.timestamp = timestamp or datetime.utcnow()

    def to_dict(self) -> dict:
        return self.__dict__