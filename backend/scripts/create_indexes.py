import asyncio
from motor.motor_asyncio import AsyncIOMotorClient
from app.config import settings


async def create_indexes():
    client = AsyncIOMotorClient(settings.MONGO_URI)
    db = client[settings.MONGO_DB_NAME]

    await db["users"].create_index("email", unique=True)
    await db["users"].create_index("phone", unique=True)

    await db["sos_events"].create_index("user_id")
    await db["sos_events"].create_index("status")
    await db["sos_events"].create_index([("created_at", -1)])

    await db["zones"].create_index([("polygon", "2dsphere")])

    await db["identity_access_log"].create_index("event_id")
    await db["identity_access_log"].create_index([("timestamp", -1)])

    await db["file_assets"].create_index("related_sos_event_id")
    await db["file_assets"].create_index("uploaded_by")

    await db["test_results"].create_index([("created_at", -1)])
    await db["test_results"].create_index("model_version")

    await db["responders"].create_index("verified")

    await db["token_blacklist"].create_index("expires_at", expireAfterSeconds=0)

    await db["password_reset_tokens"].create_index("token", unique=True)
    await db["password_reset_tokens"].create_index("expires_at", expireAfterSeconds=0)

    client.close()
    print("Indexes created successfully.")


if __name__ == "__main__":
    asyncio.run(create_indexes())