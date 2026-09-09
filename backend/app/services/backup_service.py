import subprocess
import os
from datetime import datetime
from app.config import settings
from app.services.mega_service import upload_and_register
from app.logging_config import logger


async def run_full_backup():
    from app.database import get_database

    db = get_database()
    timestamp = int(datetime.utcnow().timestamp())
    dump_path = f"/tmp/backup_{timestamp}"

    subprocess.run(
        ["mongodump", "--uri", settings.MONGO_URI, "--out", dump_path],
        check=True,
    )

    archive_path = f"{dump_path}.tar.gz"
    subprocess.run(["tar", "-czf", archive_path, dump_path], check=True)

    with open(archive_path, "rb") as f:
        file_bytes = f.read()

    file_doc = await upload_and_register(
        db=db,
        file_bytes=file_bytes,
        uploaded_by="system",
        file_type="backup",
    )

    os.remove(archive_path)
    logger.info(f"Backup uploaded: {file_doc['url']}")

    return {"url": file_doc["url"], "timestamp": timestamp}