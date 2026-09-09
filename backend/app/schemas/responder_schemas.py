from pydantic import BaseModel, Field, ConfigDict, BeforeValidator
from typing import Optional, Annotated
from datetime import datetime

PyObjectId = Annotated[str, BeforeValidator(str)]


class ResponderCreate(BaseModel):
    user_id: str
    org: Optional[str] = None


class ResponderOut(BaseModel):
    model_config = ConfigDict(populate_by_name=True)

    id: PyObjectId = Field(alias="_id")
    user_id: str
    org: Optional[str] = None
    verified: bool
    assigned_events: list[str] = []
    created_at: datetime