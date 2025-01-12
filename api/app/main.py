from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from starlette.middleware.sessions import SessionMiddleware

from app.core.config import settings
from app.core.exceptions import APIException
from app.core.logging import configure_logging
from app.api.v1.router import api_router
from app.core.middleware import (
    RequestLoggingMiddleware,
    ResponseTimeMiddleware,
    CorrelationIDMiddleware,
)

app = FastAPI(
    title=settings.PROJECT_NAME,
    version=settings.VERSION,
    description=settings.DESCRIPTION,
    docs_url="/docs" if settings.ENABLE_DOCS else None,
    redoc_url="/redoc" if settings.ENABLE_DOCS else None,
)

# Configure logging
configure_logging()

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.CORS_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Add custom middleware
app.add_middleware(RequestLoggingMiddleware)
app.add_middleware(ResponseTimeMiddleware)
app.add_middleware(CorrelationIDMiddleware)
app.add_middleware(
    SessionMiddleware,
    secret_key=settings.JWT_SECRET,
    same_site="lax",
    https_only=settings.ENVIRONMENT != "development",
)

# Include routers
app.include_router(api_router, prefix="/api/v1")

@app.exception_handler(APIException)
async def api_exception_handler(request, exc: APIException):
    return JSONResponse(
        status_code=exc.status_code,
        content={"detail": exc.detail, "code": exc.code},
    )

@app.get("/health")
async def health_check():
    return {"status": "healthy"}
