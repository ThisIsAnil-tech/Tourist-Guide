from fastapi import Depends, Header
from jose import JWTError
from bson import ObjectId
from app.database import get_database
from app.security import decode_token
from app.exceptions import UnauthorizedException, ForbiddenException
from app.constants import Role


async def get_token_from_header(authorization: str = Header(None)) -> str:
    if not authorization or not authorization.startswith("Bearer "):
        raise UnauthorizedException("Missing or invalid authorization header")
    return authorization.split(" ", 1)[1]


async def get_current_user(
    token: str = Depends(get_token_from_header),
    db=Depends(get_database),
):
    try:
        payload = decode_token(token)
    except JWTError:
        raise UnauthorizedException("Invalid or expired token")

    if payload.get("type") != "access":
        raise UnauthorizedException("Invalid token type")

    blacklisted = await db["token_blacklist"].find_one({"token": token})
    if blacklisted:
        raise UnauthorizedException("Token has been revoked")

    user_id = payload.get("sub")
    if not user_id:
        raise UnauthorizedException("Invalid token payload")

    user = await db["users"].find_one({"_id": ObjectId(user_id)})
    if not user:
        raise UnauthorizedException("User not found")

    return user


def require_role(*allowed_roles: Role):
    async def role_checker(user: dict = Depends(get_current_user)):
        if user.get("role") not in [r.value for r in allowed_roles]:
            raise ForbiddenException("Insufficient permissions")
        return user

    return role_checker