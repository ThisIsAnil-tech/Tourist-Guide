from fastapi import APIRouter, Depends
from datetime import datetime
from app.database import get_database
from app.dependencies import require_role
from app.schemas.user_schemas import CreateAdminRequest, UserOut
from app.security import hash_password
from app.exceptions import ConflictException
from app.constants import Role

router = APIRouter()


@router.get("/dashboard-stats")
async def dashboard_stats(
    admin: dict = Depends(require_role(Role.ADMIN)),
    db=Depends(get_database),
):
    active_sos_count = await db["sos_events"].count_documents({"status": "active"})
    total_users = await db["users"].count_documents({"role": "tourist"})
    total_responders = await db["responders"].count_documents({"verified": True})

    delivery_pipeline = [
        {"$group": {"_id": "$delivered_via", "count": {"$sum": 1}}}
    ]
    delivery_breakdown = await db["sos_events"].aggregate(delivery_pipeline).to_list(length=10)

    avg_confidence_pipeline = [
        {"$group": {"_id": "$model_version", "avg_confidence": {"$avg": "$confidence"}}}
    ]
    model_accuracy = await db["test_results"].aggregate(avg_confidence_pipeline).to_list(length=20)

    return {
        "active_sos_count": active_sos_count,
        "total_users": total_users,
        "total_responders": total_responders,
        "delivery_breakdown": delivery_breakdown,
        "model_accuracy_by_version": model_accuracy,
    }


@router.post("/create-admin", response_model=UserOut, status_code=201)
async def create_admin(
    payload: CreateAdminRequest,
    admin: dict = Depends(require_role(Role.ADMIN)),
    db=Depends(get_database),
):
    existing = await db["users"].find_one(
        {"$or": [{"email": payload.email}, {"phone": payload.phone}]}
    )
    if existing:
        raise ConflictException("Email or phone already registered")

    admin_doc = {
        "name": payload.name,
        "email": payload.email,
        "phone": payload.phone,
        "password_hash": hash_password(payload.password),
        "role": Role.ADMIN.value,
        "emergency_contacts": [],
        "medical_info": {},
        "identity_status": "locked",
        "created_at": datetime.utcnow(),
    }
    result = await db["users"].insert_one(admin_doc)
    admin_doc["_id"] = result.inserted_id
    return admin_doc

@router.get("/dashboard-stats")
async def dashboard_stats(
    admin: dict = Depends(require_role(Role.ADMIN)),
    db=Depends(get_database),
):
    active_sos_count = await db["sos_events"].count_documents({"status": "active", "is_test": False})
    total_users = await db["users"].count_documents({"role": "tourist"})
    total_responders = await db["responders"].count_documents({"verified": True})

    delivery_pipeline = [
        {"$match": {"is_test": False}},
        {"$group": {"_id": "$delivered_via", "count": {"$sum": 1}}}
    ]
    delivery_breakdown = await db["sos_events"].aggregate(delivery_pipeline).to_list(length=10)

    avg_confidence_pipeline = [
        {"$group": {"_id": "$model_version", "avg_confidence": {"$avg": "$confidence"}}}
    ]
    model_accuracy = await db["test_results"].aggregate(avg_confidence_pipeline).to_list(length=20)

    return {
        "active_sos_count": active_sos_count,
        "total_users": total_users,
        "total_responders": total_responders,
        "delivery_breakdown": delivery_breakdown,
        "model_accuracy_by_version": model_accuracy,
    }