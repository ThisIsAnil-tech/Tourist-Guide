from fastapi import APIRouter, Depends, Query
from datetime import datetime
from app.database import get_database
from app.dependencies import get_current_user, require_role
from app.schemas.user_schemas import UserOut, UserUpdate, EmergencyContactIn
from app.constants import Role

router = APIRouter()


@router.get("", response_model=list[UserOut])
async def list_users(
    search: str = Query(None),
    limit: int = Query(100, le=500),
    admin: dict = Depends(require_role(Role.ADMIN)),
    db=Depends(get_database),
):
    query = {"role": Role.TOURIST.value}
    if search:
        query["$or"] = [
            {"name": {"$regex": search, "$options": "i"}},
            {"email": {"$regex": search, "$options": "i"}},
            {"phone": {"$regex": search, "$options": "i"}},
        ]
    cursor = db["users"].find(query).sort("created_at", -1).limit(limit)
    return await cursor.to_list(length=limit)


@router.get("/me", response_model=UserOut)
async def get_me(user: dict = Depends(get_current_user)):
    return user


@router.put("/me", response_model=UserOut)
async def update_me(
    payload: UserUpdate,
    user: dict = Depends(get_current_user),
    db=Depends(get_database),
):
    update_fields = payload.model_dump(exclude_unset=True, exclude={"role"})
    if update_fields:
        await db["users"].update_one({"_id": user["_id"]}, {"$set": update_fields})
    updated = await db["users"].find_one({"_id": user["_id"]})
    return updated


@router.post("/me/emergency-contacts", response_model=UserOut)
async def add_emergency_contact(
    payload: EmergencyContactIn,
    user: dict = Depends(get_current_user),
    db=Depends(get_database),
):
    await db["users"].update_one(
        {"_id": user["_id"]},
        {"$push": {"emergency_contacts": payload.model_dump()}},
    )
    updated = await db["users"].find_one({"_id": user["_id"]})
    return updated


@router.delete("/me")
async def delete_me(user: dict = Depends(get_current_user), db=Depends(get_database)):
    await db["users"].update_one(
        {"_id": user["_id"]},
        {"$set": {
            "name": "Deleted User",
            "email": f"deleted_{user['_id']}@example.com",
            "phone": f"deleted_{user['_id']}",
            "emergency_contacts": [],
            "medical_info": {},
            "deleted_at": datetime.utcnow(),
        }},
    )
    return {"message": "Account deleted"}