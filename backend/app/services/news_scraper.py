import httpx
from bs4 import BeautifulSoup
from app.config import settings

DANGER_KEYWORDS = [
    "landslide", "flood", "wildfire", "attack", "unrest",
    "closure", "warning", "evacuate", "storm", "avalanche",
]


async def get_risk_component(region_keywords: list[str]) -> float:
    if not region_keywords:
        return 0.0

    query = " OR ".join(region_keywords)
    params = {
        "q": query,
        "apiKey": settings.NEWS_API_KEY,
        "sortBy": "publishedAt",
        "pageSize": 10,
    }

    async with httpx.AsyncClient(timeout=10) as client:
        response = await client.get(f"{settings.NEWS_API_BASE_URL}/everything", params=params)

    if response.status_code != 200:
        return 0.0

    articles = response.json().get("articles", [])
    hits = 0

    for article in articles:
        title = article.get("title", "").lower()
        description = article.get("description", "") or ""
        text = BeautifulSoup(description, "html.parser").get_text().lower()

        for keyword in DANGER_KEYWORDS:
            if keyword in title or keyword in text:
                hits += 1
                break

    return min(hits / max(len(articles), 1), 1.0)