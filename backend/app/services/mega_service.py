import asyncio
from datetime import datetime
from app.config import settings

if not hasattr(asyncio, "coroutine"):
    def _coroutine_shim(func):
        return func
    asyncio.coroutine = _coroutine_shim

_mega_client = None


def get_mega_client():
    global _mega_client
    if _mega_client is None:
        from mega import Mega
        mega = Mega()
        _mega_client = mega.login(settings.MEGA_EMAIL, settings.MEGA_PASSWORD)
    return _mega_client


async def upload_and_register(
    db,
    file_bytes: bytes,
    uploaded_by: str,
    file_type: str,
    related_sos_event_id: str = None,
):
    mega_client = get_mega_client()
    filename = f"{file_type}_{uploaded_by}_{int(datetime.utcnow().timestamp())}"

    temp_path = f"/tmp/{filename}"
    with open(temp_path, "wb") as f:
        f.write(file_bytes)

    uploaded_file = mega_client.upload(temp_path)
    file_url = mega_client.get_upload_link(uploaded_file)

    file_doc = {
        "url": file_url,
        "uploaded_by": uploaded_by,
        "file_type": file_type,
        "size_bytes": len(file_bytes),
        "related_sos_event_id": related_sos_event_id,
        "created_at": datetime.utcnow(),
    }

    result = await db["file_assets"].insert_one(file_doc)
    file_doc["_id"] = result.inserted_id

    return file_doc