import pytest


@pytest.mark.asyncio
async def test_register_success(client):
    payload = {
        "name": "New User",
        "email": "newuser@example.com",
        "phone": "+911111111111",
        "password": "StrongPass123!",
    }
    res = await client.post("/auth/register", json=payload)
    assert res.status_code == 201
    body = res.json()
    assert "password" not in body
    assert "password_hash" not in body


@pytest.mark.asyncio
async def test_register_duplicate_email(client, tourist_user):
    payload = {
        "name": "Dup User",
        "email": "tourist@example.com",
        "phone": "+911111111112",
        "password": "StrongPass123!",
    }
    res = await client.post("/auth/register", json=payload)
    assert res.status_code == 409


@pytest.mark.asyncio
async def test_login_success(client, tourist_user):
    payload = {"email": "tourist@example.com", "password": "SecurePass123!"}
    res = await client.post("/auth/login", json=payload)
    assert res.status_code == 200
    body = res.json()
    assert "access_token" in body
    assert "refresh_token" in body


@pytest.mark.asyncio
async def test_login_wrong_password(client, tourist_user):
    payload = {"email": "tourist@example.com", "password": "WrongPass"}
    res = await client.post("/auth/login", json=payload)
    assert res.status_code == 401


@pytest.mark.asyncio
async def test_login_rate_limited(client, tourist_user):
    payload = {"email": "tourist@example.com", "password": "WrongPass"}
    for _ in range(5):
        await client.post("/auth/login", json=payload)
    res = await client.post("/auth/login", json=payload)
    assert res.status_code == 429


@pytest.mark.asyncio
async def test_logout_blacklists_token(client, tourist_headers):
    res = await client.post("/auth/logout", headers=tourist_headers)
    assert res.status_code == 200
    res2 = await client.get("/users/me", headers=tourist_headers)
    assert res2.status_code == 401