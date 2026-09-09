from pydantic import BaseModel, Field, ConfigDict, BeforeValidator
from typing import Optional, Annotated
from datetime import datetime

PyObjectId = Annotated[str, BeforeValidator(str)]


class LocationIn(BaseModel):
    lat: float = Field(ge=-90, le=90)
    lon: float = Field(ge=-180, le=180)


class SOSCreate(BaseModel):
    event_type: str
    location: LocationIn
    is_test: bool = False


class MeshRelayIn(BaseModel):
    user_id: str
    event_type: str
    location: LocationIn
    hop_count: int = Field(ge=0)
    relay_chain: list[str] = []


class SOSOut(BaseModel):
    model_config = ConfigDict(populate_by_name=True)

    id: PyObjectId = Field(alias="_id")
    user_id: PyObjectId
    event_type: str
    location: dict
    delivered_via: str
    zone_id: Optional[str] = None
    status: str
    is_test: bool = False
    origin_meta: dict = {}
    resolved_by: Optional[str] = None
    created_at: datetime
    resolved_at: Optional[datetime] = None