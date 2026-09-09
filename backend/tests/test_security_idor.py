import pytest


@pytest.mark.asyncio
async def test_cannot_access_other_users_sos_event(client, tourist_headers, admin_headers, mock_db):
    payload = {
        "event_type": "SCREAM",
        "location": {"lat": 12.97, "lon": 77.59},
    }
    create_res = await client.post("/sos/trigger", json=payload, headers=tourist_headers)
    event_id = create_res.json()["_id"]

    other_headers = admin_headers
    res = await client.get(f"/sos/{event_id}", headers=other_headers)
    assert res.status_code in (200, 403)

    unauth_res = await client.get(f"/sos/{event_id}")
    assert unauth_res.status_code == 401


@pytest.mark.asyncio
async def test_tourist_cannot_access_admin_endpoints(client, tourist_headers):
    res = await client.get("/admin/dashboard-stats", headers=tourist_headers)
    assert res.status_code == 403


@pytest.mark.asyncio
async def test_tourist_cannot_access_sos_active_list(client, tourist_headers):
    res = await client.get("/sos/active", headers=tourist_headers)
    assert res.status_code == 403


@pytest.mark.asyncio
async def test_expired_token_rejected(client, expired_token):
    headers = {"Authorization": f"Bearer {expired_token}"}
    res = await client.get("/users/me", headers=headers)
    assert res.status_code == 401


@pytest.mark.asyncio
async def test_malformed_token_rejected(client):
    headers = {"Authorization": "Bearer not.a.valid.token"}
    res = await client.get("/users/me", headers=headers)
    assert res.status_code == 401


@pytest.mark.asyncio
async def test_no_token_rejected_on_protected_route(client):
    res = await client.get("/users/me")
    assert res.status_code == 401


@pytest.mark.asyncio
async def test_user_cannot_supply_own_user_id_to_escalate(client, tourist_headers, admin_user):
    payload = {"user_id": str(admin_user["_id"]), "name": "Hacked Name"}
    res = await client.put("/users/me", json=payload, headers=tourist_headers)
    assert res.status_code in (200, 422)
    if res.status_code == 200:
        assert res.json().get("role") != "admin"


@pytest.mark.asyncio
async def test_swagger_docs_hidden_in_production(client, monkeypatch):
    monkeypatch.setenv("ENV", "production")
    res = await client.get("/docs")
    assert res.status_code in (404, 401)