from datetime import datetime
from typing import Optional


class TestResultModel:
    def __init__(
        self,
        sos_event_id: Optional[str],
        model_version: str,
        predicted_class: str,
        confidence: float,
        inference_time_ms: float,
        device_info: Optional[dict] = None,
        created_at: Optional[datetime] = None,
    ):
        self.sos_event_id = sos_event_id
        self.model_version = model_version
        self.predicted_class = predicted_class
        self.confidence = confidence
        self.inference_time_ms = inference_time_ms
        self.device_info = device_info or {}
        self.created_at = created_at or datetime.utcnow()

    def to_dict(self) -> dict:
        return self.__dict__