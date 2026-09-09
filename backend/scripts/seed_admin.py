import asyncio
import getpass
from datetime import datetime
from motor.motor_asyncio import AsyncIOMotorClient
from app.config import settings
from app.security import hash_password


async def seed_admin():
    client = AsyncIOMotorClient(settings.MONGO_URI)
    db = client[settings.MONGO_DB_NAME]

    existing = await db["users"].find_one({"role": "admin"})
    if existing:
        print("Admin user already exists:", existing["email"])
        client.close()
        return

    name = input("Admin name: ")
    email = input("Admin email: ")
    phone = input("Admin phone: ")
    password = getpass.getpass("Admin password: ")

    admin_doc = {
        "name": name,
        "email": email,
        "phone": phone,
        "password_hash": hash_password(password),
        "role": "admin",
        "created_at": datetime.utcnow(),
    }

    result = await db["users"].insert_one(admin_doc)
    print("Admin created with id:", result.inserted_id)

    client.close()


if __name__ == "__main__":
    asyncio.run(seed_admin())