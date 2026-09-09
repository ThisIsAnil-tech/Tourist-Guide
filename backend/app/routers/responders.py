from fastapi import APIRouter, Depends
from bson import ObjectId
from app.database import get_database
from app.dependencies import require_role
from app.schemas.responder_schemas import ResponderOut, ResponderCreate
from app.constants import Role
from app.exceptions import NotFoundException

router = APIRouter()


@router.post("", response_model=ResponderOut, status_code=201)
async def create_responder(
    payload: ResponderCreate,
    admin: dict = Depends(require_role(Role.ADMIN)),
    db=Depends(get_database),
):
    doc = payload.model_dump()
    result = await db["responders"].insert_one(doc)
    doc["_id"] = result.inserted_id
    return doc


@router.get("", response_model=list[ResponderOut])
async def list_responders(
    admin: dict = Depends(require_role(Role.ADMIN)),
    db=Depends(get_database),
):
    cursor = db["responders"].find({})
    return await cursor.to_list(length=500)


@router.put("/{responder_id}/verify", response_model=ResponderOut)
async def verify_responder(
    responder_id: str,
    admin: dict = Depends(require_role(Role.ADMIN)),
    db=Depends(get_database),
):
    await db["responders"].update_one(
        {"_id": ObjectId(responder_id)}, {"$set": {"verified": True}}
    )
    responder = await db["responders"].find_one({"_id": ObjectId(responder_id)})
    if not responder:
        raise NotFoundException("Responder not found")
    return responder