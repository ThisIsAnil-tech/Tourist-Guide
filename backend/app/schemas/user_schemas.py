from pydantic import BaseModel, Field, ConfigDict, BeforeValidator, EmailStr
from typing import Optional, Annotated
from datetime import datetime

PyObjectId = Annotated[str, BeforeValidator(str)]


class EmergencyContactIn(BaseModel):
    name: str
    phone: str


class MedicalInfoIn(BaseModel):
    blood_group: Optional[str] = None
    conditions: Optional[list[str]] = None


class UserUpdate(BaseModel):
    name: Optional[str] = None
    emergency_contacts: Optional[list[EmergencyContactIn]] = None
    medical_info: Optional[MedicalInfoIn] = None


class CreateAdminRequest(BaseModel):
    name: str = Field(min_length=2, max_length=100)
    email: EmailStr
    phone: str = Field(min_length=8, max_length=15)
    password: str = Field(min_length=8, max_length=128)


class UserOut(BaseModel):
    model_config = ConfigDict(populate_by_name=True)

    id: PyObjectId = Field(alias="_id")
    name: str
    email: str
    phone: str
    role: str
    emergency_contacts: list[dict] = []
    medical_info: dict = {}
    identity_status: str = "locked"
    created_at: datetime