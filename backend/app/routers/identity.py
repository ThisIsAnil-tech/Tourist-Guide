from fastapi import APIRouter, Depends, Query
from app.database import get_database
from app.dependencies import require_role
from app.services.identity_state_machine import grant_access, revoke_access
from app.schemas.identity_schemas import IdentityAccessLogOut
from app.constants import Role

router = APIRouter()


@router.post("/grant-access/{event_id}")
async def unlock_identity(
    event_id: str,
    responder: dict = Depends(require_role(Role.RESPONDER, Role.ADMIN)),
    db=Depends(get_database),
):
    return await grant_access(db, event_id, str(responder["_id"]))


@router.post("/revoke-access/{event_id}")
async def lock_identity(
    event_id: str,
    responder: dict = Depends(require_role(Role.RESPONDER, Role.ADMIN)),
    db=Depends(get_database),
):
    await revoke_access(db, event_id)
    return {"message": "Access revoked"}


@router.get("/access-log", response_model=list[IdentityAccessLogOut])
async def get_access_log(
    limit: int = Query(200, le=1000),
    admin: dict = Depends(require_role(Role.ADMIN)),
    db=Depends(get_database),
):
    cursor = db["identity_access_log"].find({}).sort("timestamp", -1).limit(limit)
    return await cursor.to_list(length=limit)