from fastapi import APIRouter, Depends, Query
from datetime import datetime
from app.database import get_database
from app.dependencies import get_current_user, require_role
from app.schemas.test_result_schemas import TestResultCreate, TestResultOut
from app.constants import Role

router = APIRouter()


@router.post("", response_model=TestResultOut, status_code=201)
async def submit_test_result(
    payload: TestResultCreate,
    user: dict = Depends(get_current_user),
    db=Depends(get_database),
):
    doc = payload.model_dump()
    doc["created_at"] = datetime.utcnow()
    result = await db["test_results"].insert_one(doc)
    doc["_id"] = result.inserted_id
    return doc


@router.get("", response_model=list[TestResultOut])
async def list_test_results(
    model_version: str = Query(None),
    limit: int = Query(100, le=500),
    admin: dict = Depends(require_role(Role.ADMIN)),
    db=Depends(get_database),
):
    query = {}
    if model_version:
        query["model_version"] = model_version
    cursor = db["test_results"].find(query).sort("created_at", -1).limit(limit)
    return await cursor.to_list(length=limit)