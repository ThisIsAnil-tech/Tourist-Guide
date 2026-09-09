from datetime import datetime
from typing import Optional


class FileAssetModel:
    def __init__(
        self,
        url: str,
        uploaded_by: str,
        file_type: str,
        size_bytes: int,
        related_sos_event_id: Optional[str] = None,
        created_at: Optional[datetime] = None,
    ):
        self.url = url
        self.uploaded_by = uploaded_by
        self.file_type = file_type
        self.size_bytes = size_bytes
        self.related_sos_event_id = related_sos_event_id
        self.created_at = created_at or datetime.utcnow()

    def to_dict(self) -> dict:
        return self.__dict__