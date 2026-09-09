import pytest
import pytest_asyncio
from httpx import AsyncClient, ASGITransport
from mongomock_motor import AsyncMongoMockClient
from datetime import datetime, timedelta

from app.main import app
from app import database
from app.security import hash_password, create_access_token


@pytest_asyncio.fixture
async def mock_db():
    client = AsyncMongoMockClient()
    db = client["tourist_safety_test"]
    app.dependency_overrides[database.get_database] = lambda: db
    yield db
    app.dependency_overrides.clear()


@pytest_asyncio.fixture
async def client(mock_db):
    transport = ASGITransport(app=app)
    async with AsyncClient(transport=transport, base_url="http://test") as ac:
        yield ac


@pytest_asyncio.fixture
async def tourist_user(mock_db):
    user = {
        "name": "Test Tourist",
        "email": "tourist@example.com",
        "phone": "+911234567890",
        "password_hash": hash_password("SecurePass123!"),
        "role": "tourist",
        "identity_status": "locked",
        "created_at": datetime.utcnow(),
    }
    result = await mock_db["users"].insert_one(user)
    user["_id"] = result.inserted_id
    return user


@pytest_asyncio.fixture
async def responder_user(mock_db):
    user = {
        "name": "Test Responder",
        "email": "responder@example.com",
        "phone": "+911234567891",
        "password_hash": hash_password("SecurePass123!"),
        "role": "responder",
        "verified": True,
        "created_at": datetime.utcnow(),
    }
    result = await mock_db["users"].insert_one(user)
    user["_id"] = result.inserted_id
    return user


@pytest_asyncio.fixture
async def admin_user(mock_db):
    user = {
        "name": "Test Admin",
        "email": "admin@example.com",
        "phone": "+911234567892",
        "password_hash": hash_password("SecurePass123!"),
        "role": "admin",
        "created_at": datetime.utcnow(),
    }
    result = await mock_db["users"].insert_one(user)
    user["_id"] = result.inserted_id
    return user


def auth_header(user_id, role):
    token = create_access_token({"sub": str(user_id), "role": role})
    return {"Authorization": f"Bearer {token}"}


@pytest.fixture
def tourist_headers(tourist_user):
    return auth_header(tourist_user["_id"], "tourist")


@pytest.fixture
def responder_headers(responder_user):
    return auth_header(responder_user["_id"], "responder")


@pytest.fixture
def admin_headers(admin_user):
    return auth_header(admin_user["_id"], "admin")


@pytest.fixture
def expired_token(tourist_user):
    return create_access_token(
        {"sub": str(tourist_user["_id"]), "role": "tourist"},
        expires_delta=timedelta(minutes=-5),
    )