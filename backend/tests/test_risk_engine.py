import pytest
from unittest.mock import AsyncMock, patch

from app.services.risk_engine_service import compute_zone_risk


@pytest.mark.asyncio
async def test_compute_zone_risk_weighted_formula():
    zone = {
        "_id": "zone1",
        "coordinates": {"lat": 12.97, "lon": 77.59},
        "region_keywords": ["Bangalore"],
    }

    with patch(
        "app.services.risk_engine_service.weather_client.get_risk_component",
        new=AsyncMock(return_value=0.8),
    ), patch(
        "app.services.risk_engine_service.news_scraper.get_risk_component",
        new=AsyncMock(return_value=0.4),
    ), patch(
        "app.services.risk_engine_service.query_historical_incident_rate",
        new=AsyncMock(return_value=0.2),
    ):
        score = await compute_zone_risk(zone)
        expected = (0.5 * 0.8) + (0.3 * 0.4) + (0.2 * 0.2)
        assert round(score, 2) == round(expected * 9 + 1, 2)


@pytest.mark.asyncio
async def test_risk_score_bounds_within_one_to_ten():
    zone = {
        "_id": "zone2",
        "coordinates": {"lat": 0, "lon": 0},
        "region_keywords": [],
    }
    with patch(
        "app.services.risk_engine_service.weather_client.get_risk_component",
        new=AsyncMock(return_value=1.0),
    ), patch(
        "app.services.risk_engine_service.news_scraper.get_risk_component",
        new=AsyncMock(return_value=1.0),
    ), patch(
        "app.services.risk_engine_service.query_historical_incident_rate",
        new=AsyncMock(return_value=1.0),
    ):
        score = await compute_zone_risk(zone)
        assert 1 <= score <= 10