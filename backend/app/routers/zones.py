from fastapi import APIRouter, Depends
from bson import ObjectId
from app.database import get_database
from app.dependencies import require_role
from app.schemas.zone_schemas import ZoneOut, ZoneCreate
from app.constants import Role
from app.exceptions import NotFoundException

router = APIRouter()


@router.get("", response_model=list[ZoneOut])
async def list_zones(db=Depends(get_database)):
    cursor = db["zones"].find({})
    return await cursor.to_list(length=500)


@router.get("/{zone_id}", response_model=ZoneOut)
async def get_zone(zone_id: str, db=Depends(get_database)):
    zone = await db["zones"].find_one({"_id": ObjectId(zone_id)})
    if not zone:
        raise NotFoundException("Zone not found")
    return zone


@router.post("", response_model=ZoneOut, status_code=201)
async def create_zone(
    payload: ZoneCreate,
    admin: dict = Depends(require_role(Role.ADMIN)),
    db=Depends(get_database),
):
    zone_doc = payload.model_dump()
    result = await db["zones"].insert_one(zone_doc)
    zone_doc["_id"] = result.inserted_id
    return zone_doc