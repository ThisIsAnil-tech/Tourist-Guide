import logging
from app.utils.pii_redaction import PIIRedactionFilter


def setup_logging() -> logging.Logger:
    log = logging.getLogger("tourist_safety")
    log.setLevel(logging.INFO)
    handler = logging.StreamHandler()
    handler.setFormatter(logging.Formatter("%(asctime)s %(levelname)s %(message)s"))
    handler.addFilter(PIIRedactionFilter())
    log.addHandler(handler)
    return log


logger = setup_logging()