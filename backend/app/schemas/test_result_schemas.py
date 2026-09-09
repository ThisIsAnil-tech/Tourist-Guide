from pydantic import BaseModel, Field, ConfigDict, BeforeValidator
from typing import Optional, Annotated
from datetime import datetime

PyObjectId = Annotated[str, BeforeValidator(str)]


class TestResultCreate(BaseModel):
    model_config = ConfigDict(protected_namespaces=())

    sos_event_id: Optional[str] = None
    model_version: str
    predicted_class: str
    confidence: float = Field(ge=0, le=1)
    inference_time_ms: float
    device_info: dict = {}


class TestResultOut(BaseModel):
    model_config = ConfigDict(populate_by_name=True, protected_namespaces=())

    id: PyObjectId = Field(alias="_id")
    sos_event_id: Optional[str] = None
    model_version: str
    predicted_class: str
    confidence: float
    inference_time_ms: float
    device_info: dict = {}
    created_at: datetime