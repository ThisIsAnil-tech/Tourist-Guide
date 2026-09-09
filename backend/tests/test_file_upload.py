import io
import pytest
from unittest.mock import AsyncMock, patch


@pytest.mark.asyncio
async def test_upload_valid_audio_file(client, tourist_headers):
    file_content = b"fake audio bytes"
    files = {"file": ("clip.mp3", io.BytesIO(file_content), "audio/mpeg")}

    with patch(
        "app.services.mega_service.mega_client.upload",
        new=AsyncMock(return_value="https://mega.nz/file/fake"),
    ):
        res = await client.post(
            "/files/upload",
            files=files,
            data={"file_type": "audio"},
            headers=tourist_headers,
        )
    assert res.status_code == 201
    body = res.json()
    assert body["url"].startswith("https://mega.nz")


@pytest.mark.asyncio
async def test_upload_rejects_invalid_mime(client, tourist_headers):
    file_content = b"not allowed"
    files = {"file": ("script.exe", io.BytesIO(file_content), "application/x-msdownload")}
    res = await client.post(
        "/files/upload",
        files=files,
        data={"file_type": "audio"},
        headers=tourist_headers,
    )
    assert res.status_code == 415


@pytest.mark.asyncio
async def test_upload_rejects_oversized_file(client, tourist_headers):
    file_content = b"0" * (26 * 1024 * 1024)
    files = {"file": ("big.mp3", io.BytesIO(file_content), "audio/mpeg")}
    res = await client.post(
        "/files/upload",
        files=files,
        data={"file_type": "audio"},
        headers=tourist_headers,
    )
    assert res.status_code == 413


@pytest.mark.asyncio
async def test_file_metadata_persisted_in_mongo(client, tourist_headers, mock_db):
    file_content = b"fake audio bytes"
    files = {"file": ("clip.mp3", io.BytesIO(file_content), "audio/mpeg")}

    with patch(
        "app.services.mega_service.mega_client.upload",
        new=AsyncMock(return_value="https://mega.nz/file/fake2"),
    ):
        await client.post(
            "/files/upload",
            files=files,
            data={"file_type": "audio"},
            headers=tourist_headers,
        )

    record = await mock_db["file_assets"].find_one({"url": "https://mega.nz/file/fake2"})
    assert record is not None