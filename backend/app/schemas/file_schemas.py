from pydantic import BaseModel, Field, ConfigDict, BeforeValidator
from typing import Optional, Annotated
from datetime import datetime

PyObjectId = Annotated[str, BeforeValidator(str)]


class FileAssetOut(BaseModel):
    model_config = ConfigDict(populate_by_name=True)

    id: PyObjectId = Field(alias="_id")
    url: str
    uploaded_by: str
    file_type: str
    size_bytes: int
    related_sos_event_id: Optional[str] = None
    created_at: datetime