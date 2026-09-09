from fastapi import APIRouter, Depends
from datetime import datetime
from bson import ObjectId
from app.database import get_database
from app.security import hash_password, verify_password, create_access_token, create_refresh_token, decode_token
from app.schemas.auth_schemas import (
    RegisterRequest,
    LoginRequest,
    TokenResponse,
    RefreshRequest,
    ForgotPasswordRequest,
    ResetPasswordRequest,
    ChangePasswordRequest,
)
from app.schemas.user_schemas import UserOut
from app.exceptions import ConflictException, UnauthorizedException
from app.middleware.rate_limiter import login_rate_limit, password_reset_rate_limit
from app.dependencies import get_current_user, get_token_from_header
from app.services.password_reset_service import (
    create_reset_token,
    send_reset_notification,
    validate_and_consume_token,
)
from app.constants import Role

router = APIRouter()


@router.post("/register", response_model=UserOut, status_code=201)
async def register(payload: RegisterRequest, db=Depends(get_database)):
    existing = await db["users"].find_one(
        {"$or": [{"email": payload.email}, {"phone": payload.phone}]}
    )
    if existing:
        raise ConflictException("Email or phone already registered")

    user_doc = {
        "name": payload.name,
        "email": payload.email,
        "phone": payload.phone,
        "password_hash": hash_password(payload.password),
        "role": Role.TOURIST.value,
        "emergency_contacts": [],
        "medical_info": {},
        "identity_status": "locked",
        "created_at": datetime.utcnow(),
    }
    result = await db["users"].insert_one(user_doc)
    user_doc["_id"] = result.inserted_id
    return user_doc


@router.post("/login", response_model=TokenResponse)
async def login(payload: LoginRequest, db=Depends(get_database)):
    await login_rate_limit(payload.email)

    user = await db["users"].find_one({"email": payload.email})
    if not user or not verify_password(payload.password, user["password_hash"]):
        raise UnauthorizedException("Invalid credentials")

    access_token = create_access_token({"sub": str(user["_id"]), "role": user["role"]})
    refresh_token = create_refresh_token({"sub": str(user["_id"]), "role": user["role"]})
    return {"access_token": access_token, "refresh_token": refresh_token, "token_type": "bearer"}


@router.post("/refresh", response_model=TokenResponse)
async def refresh(payload: RefreshRequest):
    try:
        decoded = decode_token(payload.refresh_token)
    except Exception:
        raise UnauthorizedException("Invalid refresh token")

    if decoded.get("type") != "refresh":
        raise UnauthorizedException("Invalid token type")

    access_token = create_access_token({"sub": decoded["sub"], "role": decoded["role"]})
    return {"access_token": access_token, "refresh_token": payload.refresh_token, "token_type": "bearer"}


@router.post("/logout")
async def logout(
    token: str = Depends(get_token_from_header),
    user: dict = Depends(get_current_user),
    db=Depends(get_database),
):
    decoded = decode_token(token)
    expires_at = datetime.utcfromtimestamp(decoded["exp"])
    await db["token_blacklist"].insert_one({
        "token": token,
        "expires_at": expires_at,
        "blacklisted_at": datetime.utcnow(),
    })
    return {"message": "Logged out"}


@router.post("/forgot-password")
async def forgot_password(payload: ForgotPasswordRequest, db=Depends(get_database)):
    await password_reset_rate_limit(payload.email)

    user = await db["users"].find_one({"email": payload.email})
    if user:
        token = await create_reset_token(db, str(user["_id"]))
        await send_reset_notification(user["phone"], token)

    return {"message": "If that email is registered, a reset code has been sent via SMS"}


@router.post("/reset-password")
async def reset_password(payload: ResetPasswordRequest, db=Depends(get_database)):
    user_id = await validate_and_consume_token(db, payload.token)
    if not user_id:
        raise UnauthorizedException("Invalid or expired reset code")

    await db["users"].update_one(
        {"_id": ObjectId(user_id)},
        {"$set": {"password_hash": hash_password(payload.new_password)}},
    )
    return {"message": "Password reset successful"}


@router.put("/change-password")
async def change_password(
    payload: ChangePasswordRequest,
    user: dict = Depends(get_current_user),
    db=Depends(get_database),
):
    if not verify_password(payload.old_password, user["password_hash"]):
        raise UnauthorizedException("Current password is incorrect")

    await db["users"].update_one(
        {"_id": user["_id"]},
        {"$set": {"password_hash": hash_password(payload.new_password)}},
    )
    return {"message": "Password changed successfully"}