from enum import Enum


class Role(str, Enum):
    TOURIST = "tourist"
    RESPONDER = "responder"
    ADMIN = "admin"


class EventType(str, Enum):
    SCREAM = "SCREAM"
    GLASS_BREAK = "GLASS_BREAK"
    ABNORMAL_STOPPAGE = "ABNORMAL_STOPPAGE"
    MANUAL = "MANUAL"


class DeliveryTier(str, Enum):
    INTERNET = "internet"
    SMS = "sms"
    MESH = "mesh"


class SOSStatus(str, Enum):
    ACTIVE = "active"
    RESOLVED = "resolved"


class IdentityStatus(str, Enum):
    LOCKED = "locked"
    UNLOCKED = "unlocked"


class FileType(str, Enum):
    AUDIO = "audio"
    IMAGE = "image"
    NEWS_SNAPSHOT = "news_snapshot"
    BACKUP = "backup"