from pydantic import BaseModel, Field, ConfigDict, BeforeValidator
from typing import Optional, Annotated
from datetime import datetime

PyObjectId = Annotated[str, BeforeValidator(str)]


class ZoneCreate(BaseModel):
    name: str
    polygon: dict
    coordinates: dict
    region_keywords: list[str] = []
    risk_score: float = Field(default=1.0, ge=1, le=10)


class ZoneOut(BaseModel):
    model_config = ConfigDict(populate_by_name=True)

    id: PyObjectId = Field(alias="_id")
    name: str
    polygon: dict
    coordinates: dict
    region_keywords: list[str] = []
    risk_score: float
    weather_snapshot: dict = {}
    news_summary: Optional[str] = None
    last_updated: datetime