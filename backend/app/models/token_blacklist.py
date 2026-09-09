from datetime import datetime


class TokenBlacklistModel:
    def __init__(self, token: str, expires_at: datetime, blacklisted_at: datetime = None):
        self.token = token
        self.expires_at = expires_at
        self.blacklisted_at = blacklisted_at or datetime.utcnow()

    def to_dict(self) -> dict:
        return self.__dict__