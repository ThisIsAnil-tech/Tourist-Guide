from pydantic import BaseModel, Field, ConfigDict, BeforeValidator
from typing import Annotated
from datetime import datetime

PyObjectId = Annotated[str, BeforeValidator(str)]


class IdentityAccessOut(BaseModel):
    event_id: str
    responder_id: str
    action: str
    timestamp: datetime


class UnlockedIdentityOut(BaseModel):
    name: str
    phone: str
    emergency_contacts: list[dict]
    medical_info: dict


class IdentityAccessLogOut(BaseModel):
    model_config = ConfigDict(populate_by_name=True)

    id: PyObjectId = Field(alias="_id")
    event_id: str
    responder_id: str
    action: str
    timestamp: datetime