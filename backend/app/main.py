from fastapi import FastAPI, Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from app.config import settings
from app.exceptions import AppException
from app.utils.correlation_id import generate_correlation_id
from app.middleware.security_headers import SecurityHeadersMiddleware
from app.logging_config import logger
from app.jobs.scheduler import start_scheduler

from app.routers import (
    auth,
    users,
    sos,
    sms_webhook,
    mesh_gateway,
    identity,
    zones,
    files,
    test_results,
    responders,
    admin,
)

docs_url = "/docs" if settings.ENV != "production" else None
redoc_url = "/redoc" if settings.ENV != "production" else None

app = FastAPI(title=settings.APP_NAME, docs_url=docs_url, redoc_url=redoc_url)

app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.cors_origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.add_middleware(SecurityHeadersMiddleware)


@app.exception_handler(AppException)
async def app_exception_handler(request: Request, exc: AppException):
    correlation_id = generate_correlation_id()
    logger.error(f"correlation_id={correlation_id} status={exc.status_code} msg={exc.message}")
    return JSONResponse(
        status_code=exc.status_code,
        content={"error": exc.message, "correlation_id": correlation_id},
    )


@app.exception_handler(Exception)
async def unhandled_exception_handler(request: Request, exc: Exception):
    correlation_id = generate_correlation_id()
    logger.error(f"correlation_id={correlation_id} unhandled_exception")
    return JSONResponse(
        status_code=500,
        content={"error": "Internal server error", "correlation_id": correlation_id},
    )


app.include_router(auth.router, prefix="/auth", tags=["auth"])
app.include_router(users.router, prefix="/users", tags=["users"])
app.include_router(sos.router, prefix="/sos", tags=["sos"])
app.include_router(sms_webhook.router, prefix="/sms-webhook", tags=["webhooks"])
app.include_router(mesh_gateway.router, prefix="/mesh", tags=["webhooks"])
app.include_router(identity.router, prefix="/identity", tags=["identity"])
app.include_router(zones.router, prefix="/zones", tags=["zones"])
app.include_router(files.router, prefix="/files", tags=["files"])
app.include_router(test_results.router, prefix="/test-results", tags=["test-results"])
app.include_router(responders.router, prefix="/responders", tags=["responders"])
app.include_router(admin.router, prefix="/admin", tags=["admin"])


@app.get("/healthz", tags=["health"])
async def healthz():
    return {"status": "ok"}


@app.on_event("startup")
async def on_startup():
    start_scheduler()