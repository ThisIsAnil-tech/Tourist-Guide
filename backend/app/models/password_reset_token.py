from datetime import datetime


class PasswordResetTokenModel:
    def __init__(self, token: str, user_id: str, expires_at: datetime, created_at: datetime = None):
        self.token = token
        self.user_id = user_id
        self.expires_at = expires_at
        self.created_at = created_at or datetime.utcnow()

    def to_dict(self) -> dict:
        return self.__dict__