from datetime import datetime
from typing import Optional


class EmergencyContact:
    def __init__(self, name: str, phone: str):
        self.name = name
        self.phone = phone


class MedicalInfo:
    def __init__(self, blood_group: Optional[str] = None, conditions: Optional[list[str]] = None):
        self.blood_group = blood_group
        self.conditions = conditions or []


class UserModel:
    def __init__(
        self,
        name: str,
        email: str,
        phone: str,
        password_hash: str,
        role: str = "tourist",
        emergency_contacts: Optional[list[dict]] = None,
        medical_info: Optional[dict] = None,
        identity_status: str = "locked",
        unlocked_by: Optional[str] = None,
        unlocked_at: Optional[datetime] = None,
        verified: bool = False,
        created_at: Optional[datetime] = None,
    ):
        self.name = name
        self.email = email
        self.phone = phone
        self.password_hash = password_hash
        self.role = role
        self.emergency_contacts = emergency_contacts or []
        self.medical_info = medical_info or {}
        self.identity_status = identity_status
        self.unlocked_by = unlocked_by
        self.unlocked_at = unlocked_at
        self.verified = verified
        self.created_at = created_at or datetime.utcnow()

    def to_dict(self) -> dict:
        return self.__dict__