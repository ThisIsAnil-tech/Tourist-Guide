from app.services.backup_service import run_full_backup
from app.logging_config import logger


async def run_scheduled_backup():
    result = await run_full_backup()
    logger.info(f"Scheduled backup completed: {result}")