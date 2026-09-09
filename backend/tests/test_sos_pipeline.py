import pytest


@pytest.mark.asyncio
async def test_sos_trigger_internet_tier(client, tourist_headers):
    payload = {
        "event_type": "SCREAM",
        "location": {"lat": 12.9716, "lon": 77.5946},
    }
    res = await client.post("/sos/trigger", json=payload, headers=tourist_headers)
    assert res.status_code == 201
    body = res.json()
    assert body["delivered_via"] == "internet"
    assert body["status"] == "active"


@pytest.mark.asyncio
async def test_sos_duplicate_within_window_deduped(client, tourist_headers):
    payload = {
        "event_type": "SCREAM",
        "location": {"lat": 12.9716, "lon": 77.5946},
    }
    res1 = await client.post("/sos/trigger", json=payload, headers=tourist_headers)
    res2 = await client.post("/sos/trigger", json=payload, headers=tourist_headers)
    assert res1.json()["_id"] == res2.json()["_id"]


@pytest.mark.asyncio
async def test_mesh_gateway_requires_api_key(client):
    payload = {
        "user_id": "000000000000000000000000",
        "event_type": "ABNORMAL_STOPPAGE",
        "location": {"lat": 12.97, "lon": 77.59},
        "hop_count": 3,
        "relay_chain": ["dev1", "dev2", "dev3"],
    }
    res = await client.post("/mesh/relay-exit", json=payload)
    assert res.status_code == 401


@pytest.mark.asyncio
async def test_mesh_gateway_valid_key_creates_event(client, tourist_user, monkeypatch):
    monkeypatch.setenv("MESH_GATEWAY_API_KEY", "test-mesh-key")
    payload = {
        "user_id": str(tourist_user["_id"]),
        "event_type": "SCREAM",
        "location": {"lat": 12.97, "lon": 77.59},
        "hop_count": 2,
        "relay_chain": ["dev1", "dev2"],
    }
    headers = {"X-Mesh-Key": "test-mesh-key"}
    res = await client.post("/mesh/relay-exit", json=payload, headers=headers)
    assert res.status_code == 201
    assert res.json()["delivered_via"] == "mesh"


@pytest.mark.asyncio
async def test_sms_webhook_parses_and_creates_event(client, tourist_user):
    form_data = {
        "From": tourist_user["phone"],
        "Body": "SOS lat:12.9716 lon:77.5946 type:GLASS_BREAK",
    }
    res = await client.post("/sms-webhook", data=form_data)
    assert res.status_code == 200


@pytest.mark.asyncio
async def test_resolve_sos_event(client, tourist_headers, responder_headers):
    payload = {
        "event_type": "SCREAM",
        "location": {"lat": 12.97, "lon": 77.59},
    }
    create_res = await client.post("/sos/trigger", json=payload, headers=tourist_headers)
    event_id = create_res.json()["_id"]
    resolve_res = await client.put(f"/sos/{event_id}/resolve", headers=responder_headers)
    assert resolve_res.status_code == 200
    assert resolve_res.json()["status"] == "resolved"