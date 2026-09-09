from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_file=".env", extra="ignore")

    ENV: str
    APP_NAME: str
    APP_PORT: int

    MONGO_URI: str
    MONGO_DB_NAME: str

    REDIS_HOST: str
    REDIS_PORT: int
    REDIS_PASSWORD: str = ""

    JWT_SECRET: str
    JWT_ALGORITHM: str = "HS256"
    JWT_ACCESS_EXPIRE_MINUTES: int = 30
    JWT_REFRESH_EXPIRE_DAYS: int = 7

    MEGA_EMAIL: str
    MEGA_PASSWORD: str

    TWILIO_ACCOUNT_SID: str
    TWILIO_AUTH_TOKEN: str
    TWILIO_FROM_NUMBER: str

    OPENWEATHER_API_KEY: str

    NEWS_API_KEY: str
    NEWS_API_BASE_URL: str

    BLOCKCHAIN_ENABLED: bool = False
    POLYGON_RPC_URL: str = ""
    CONTRACT_ADDRESS: str = ""
    BACKEND_WALLET_PRIVATE_KEY: str = ""
    CONTRACT_ABI_PATH: str = ""

    MESH_GATEWAY_API_KEY: str
    SMS_WEBHOOK_VALIDATE_SIGNATURE: bool = True

    ALLOWED_ORIGINS: str = "*"

    RATE_LIMIT_LOGIN_PER_MINUTE: int = 5
    RATE_LIMIT_PASSWORD_RESET_PER_HOUR: int = 3

    BACKUP_ENABLED: bool = True
    BACKUP_CRON_HOUR: int = 2

    @property
    def cors_origins(self) -> list[str]:
        if self.ALLOWED_ORIGINS == "*":
            return ["*"]
        return [origin.strip() for origin in self.ALLOWED_ORIGINS.split(",")]


settings = Settings()