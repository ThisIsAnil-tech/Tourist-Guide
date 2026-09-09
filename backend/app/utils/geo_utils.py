import math


def haversine(point1: dict, point2: dict) -> float:
    R = 6371000
    lat1, lon1 = math.radians(point1["lat"]), math.radians(point1["lon"])
    lat2, lon2 = math.radians(point2["lat"]), math.radians(point2["lon"])

    dlat = lat2 - lat1
    dlon = lon2 - lon1

    a = math.sin(dlat / 2) ** 2 + math.cos(lat1) * math.cos(lat2) * math.sin(dlon / 2) ** 2
    c = 2 * math.asin(math.sqrt(a))

    return R * c


def point_in_polygon(point: dict, polygon: dict) -> bool:
    coordinates = polygon.get("coordinates", [[]])[0]
    x, y = point["lon"], point["lat"]
    inside = False
    n = len(coordinates)

    if n < 3:
        return False

    j = n - 1
    for i in range(n):
        xi, yi = coordinates[i][0], coordinates[i][1]
        xj, yj = coordinates[j][0], coordinates[j][1]

        intersects = ((yi > y) != (yj > y)) and (
            x < (xj - xi) * (y - yi) / (yj - yi + 1e-12) + xi
        )
        if intersects:
            inside = not inside
        j = i

    return inside