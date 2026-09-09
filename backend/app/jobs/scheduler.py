from apscheduler.schedulers.asyncio import AsyncIOScheduler
from app.config import settings
from app.jobs.backup_job import run_scheduled_backup
from app.services.risk_engine_service import recompute_all_zone_risks
from app.logging_config import logger

scheduler = AsyncIOScheduler()


def start_scheduler():
    scheduler.add_job(
        recompute_all_zone_risks,
        "interval",
        minutes=15,
        id="risk_score_recompute",
        replace_existing=True,
    )

    if settings.BACKUP_ENABLED:
        scheduler.add_job(
            run_scheduled_backup,
            "cron",
            hour=settings.BACKUP_CRON_HOUR,
            id="daily_backup",
            replace_existing=True,
        )

    scheduler.add_job(
        auto_resolve_stale_events,
        "interval",
        minutes=30,
        id="stale_event_cleanup",
        replace_existing=True,
    )

    scheduler.start()
    logger.info("Scheduler started")


async def auto_resolve_stale_events():
    from app.database import get_database
    from app.services.identity_state_machine import revoke_stale_access

    db = get_database()
    await revoke_stale_access(db)