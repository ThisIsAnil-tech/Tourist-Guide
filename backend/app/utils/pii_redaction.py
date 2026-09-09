import logging
import re

EMAIL_PATTERN = re.compile(r"[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}")
PHONE_PATTERN = re.compile(r"\+?\d{8,15}")
TOKEN_PATTERN = re.compile(r"(Bearer\s+)?[A-Za-z0-9\-_]{20,}\.[A-Za-z0-9\-_]{10,}\.[A-Za-z0-9\-_]{10,}")


class PIIRedactionFilter(logging.Filter):
    def filter(self, record: logging.LogRecord) -> bool:
        message = record.getMessage()
        redacted = EMAIL_PATTERN.sub("[REDACTED_EMAIL]", message)
        redacted = PHONE_PATTERN.sub("[REDACTED_PHONE]", redacted)
        redacted = TOKEN_PATTERN.sub("[REDACTED_TOKEN]", redacted)
        record.msg = redacted
        record.args = ()
        return True