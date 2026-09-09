import asyncio
from app.services.backup_service import run_full_backup


async def main():
    result = await run_full_backup()
    print("Backup completed:", result)


if __name__ == "__main__":
    asyncio.run(main())