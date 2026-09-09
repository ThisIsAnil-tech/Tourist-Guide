from fastapi import APIRouter, Depends, UploadFile, File, Form
from app.database import get_database
from app.dependencies import get_current_user
from app.services.mega_service import upload_and_register
from app.exceptions import UnsupportedMediaException, PayloadTooLargeException, NotFoundException
from bson import ObjectId

router = APIRouter()

ALLOWED_MIME_TYPES = {"audio/mpeg", "audio/wav", "audio/mp4", "image/jpeg", "image/png"}
MAX_FILE_SIZE_BYTES = 25 * 1024 * 1024


@router.post("/upload", status_code=201)
async def upload_file(
    file: UploadFile = File(...),
    file_type: str = Form(...),
    related_sos_event_id: str = Form(None),
    user: dict = Depends(get_current_user),
    db=Depends(get_database),
):
    if file.content_type not in ALLOWED_MIME_TYPES:
        raise UnsupportedMediaException("File type not allowed")

    contents = await file.read()
    if len(contents) > MAX_FILE_SIZE_BYTES:
        raise PayloadTooLargeException("File exceeds maximum allowed size")

    result = await upload_and_register(
        db=db,
        file_bytes=contents,
        uploaded_by=str(user["_id"]),
        file_type=file_type,
        related_sos_event_id=related_sos_event_id,
    )
    return result


@router.get("/{file_id}")
async def get_file(file_id: str, db=Depends(get_database)):
    file_doc = await db["file_assets"].find_one({"_id": ObjectId(file_id)})
    if not file_doc:
        raise NotFoundException("File not found")
    return file_doc