import pytest


@pytest.mark.asyncio
async def test_grant_access_requires_active_event(client, responder_headers):
    fake_event_id = "000000000000000000000000"
    res = await client.post(
        f"/identity/grant-access/{fake_event_id}", headers=responder_headers
    )
    assert res.status_code == 403


@pytest.mark.asyncio
async def test_grant_access_success(client, tourist_headers, responder_headers):
    payload = {
        "event_type": "SCREAM",
        "location": {"lat": 12.97, "lon": 77.59},
    }
    create_res = await client.post("/sos/trigger", json=payload, headers=tourist_headers)
    event_id = create_res.json()["_id"]

    res = await client.post(
        f"/identity/grant-access/{event_id}", headers=responder_headers
    )
    assert res.status_code == 200
    assert "medical_info" in res.json()


@pytest.mark.asyncio
async def test_double_grant_returns_conflict(client, tourist_headers, responder_headers):
    payload = {
        "event_type": "SCREAM",
        "location": {"lat": 12.97, "lon": 77.59},
    }
    create_res = await client.post("/sos/trigger", json=payload, headers=tourist_headers)
    event_id = create_res.json()["_id"]

    await client.post(f"/identity/grant-access/{event_id}", headers=responder_headers)
    res2 = await client.post(f"/identity/grant-access/{event_id}", headers=responder_headers)
    assert res2.status_code == 409


@pytest.mark.asyncio
async def test_revoke_access_locks_identity(client, tourist_headers, responder_headers):
    payload = {
        "event_type": "SCREAM",
        "location": {"lat": 12.97, "lon": 77.59},
    }
    create_res = await client.post("/sos/trigger", json=payload, headers=tourist_headers)
    event_id = create_res.json()["_id"]

    await client.post(f"/identity/grant-access/{event_id}", headers=responder_headers)
    res = await client.post(
        f"/identity/revoke-access/{event_id}", headers=responder_headers
    )
    assert res.status_code == 200

    grant_again = await client.post(
        f"/identity/grant-access/{event_id}", headers=responder_headers
    )
    assert grant_again.status_code == 200


@pytest.mark.asyncio
async def test_tourist_cannot_grant_access(client, tourist_headers):
    payload = {
        "event_type": "SCREAM",
        "location": {"lat": 12.97, "lon": 77.59},
    }
    create_res = await client.post("/sos/trigger", json=payload, headers=tourist_headers)
    event_id = create_res.json()["_id"]

    res = await client.post(f"/identity/grant-access/{event_id}", headers=tourist_headers)
    assert res.status_code == 403