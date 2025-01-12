import time
import uuid
from typing import Callable

from fastapi import Request, Response
from starlette.middleware.base import BaseHTTPMiddleware, RequestResponseEndpoint
from starlette.types import ASGIApp

from app.core.logging import logger


class RequestLoggingMiddleware(BaseHTTPMiddleware):
    async def dispatch(
        self, request: Request, call_next: RequestResponseEndpoint
    ) -> Response:
        logger.info(
            f"Request: {request.method} {request.url.path}",
            extra={
                "correlation_id": request.headers.get("X-Correlation-ID"),
                "user_agent": request.headers.get("User-Agent"),
                "ip": request.client.host if request.client else None,
            },
        )
        response = await call_next(request)
        logger.info(
            f"Response: {response.status_code}",
            extra={
                "correlation_id": request.headers.get("X-Correlation-ID"),
                "status_code": response.status_code,
            },
        )
        return response


class ResponseTimeMiddleware(BaseHTTPMiddleware):
    async def dispatch(
        self, request: Request, call_next: RequestResponseEndpoint
    ) -> Response:
        start_time = time.time()
        response = await call_next(request)
        process_time = time.time() - start_time
        response.headers["X-Process-Time"] = str(process_time)
        return response


class CorrelationIDMiddleware(BaseHTTPMiddleware):
    def __init__(
        self,
        app: ASGIApp,
        header_name: str = "X-Correlation-ID",
    ) -> None:
        super().__init__(app)
        self.header_name = header_name

    async def dispatch(
        self, request: Request, call_next: RequestResponseEndpoint
    ) -> Response:
        correlation_id = request.headers.get(self.header_name)
        if not correlation_id:
            correlation_id = str(uuid.uuid4())
            request.headers.__dict__["_list"].append(
                (self.header_name.encode(), correlation_id.encode())
            )

        response = await call_next(request)
        response.headers[self.header_name] = correlation_id
        return response
