import httpx
from app.config import settings

WEATHER_API_URL = "https://api.openweathermap.org/data/2.5/weather"


async def get_risk_component(coordinates: dict) -> float:
    params = {
        "lat": coordinates["lat"],
        "lon": coordinates["lon"],
        "appid": settings.OPENWEATHER_API_KEY,
    }
    async with httpx.AsyncClient(timeout=10) as client:
        response = await client.get(WEATHER_API_URL, params=params)

    if response.status_code != 200:
        return 0.0

    data = response.json()
    weather_main = data.get("weather", [{}])[0].get("main", "").lower()
    wind_speed = data.get("wind", {}).get("speed", 0)
    rain_volume = data.get("rain", {}).get("1h", 0)

    severe_conditions = {"thunderstorm", "tornado", "squall", "extreme"}
    score = 0.0

    if weather_main in severe_conditions:
        score += 0.6
    if rain_volume > 10:
        score += 0.3
    if wind_speed > 15:
        score += 0.2

    return min(score, 1.0)