import logging
import sys
from typing import Any, Dict

from app.core.config import settings

class CustomFormatter(logging.Formatter):
    """Custom formatter adding correlation ID to log records."""

    def format(self, record: logging.LogRecord) -> str:
        if not hasattr(record, "correlation_id"):
            record.correlation_id = "N/A"
        return super().format(record)


def configure_logging() -> None:
    """Configure logging for the application."""
    # Create handlers
    console_handler = logging.StreamHandler(sys.stdout)
    console_handler.setFormatter(
        CustomFormatter(
            fmt="%(asctime)s - %(name)s - [%(correlation_id)s] - %(levelname)s - %(message)s",
            datefmt="%Y-%m-%d %H:%M:%S",
        )
    )

    # Configure root logger
    root_logger = logging.getLogger()
    root_logger.setLevel(settings.LOG_LEVEL.upper())
    root_logger.addHandler(console_handler)

    # Configure uvicorn access logger
    uvicorn_logger = logging.getLogger("uvicorn.access")
    uvicorn_logger.handlers = []
    uvicorn_logger.addHandler(console_handler)

    # Configure application logger
    app_logger = logging.getLogger("app")
    app_logger.setLevel(settings.LOG_LEVEL.upper())
    app_logger.handlers = []
    app_logger.addHandler(console_handler)
    app_logger.propagate = False


class LoggerAdapter(logging.LoggerAdapter):
    """Adapter for adding correlation ID to log records."""

    def process(self, msg: str, kwargs: Dict[str, Any]) -> tuple[str, Dict[str, Any]]:
        if "extra" not in kwargs:
            kwargs["extra"] = {}
        if "correlation_id" not in kwargs["extra"]:
            kwargs["extra"]["correlation_id"] = "N/A"
        return msg, kwargs


# Create logger instance
logger = LoggerAdapter(logging.getLogger("app"), extra={"correlation_id": None})
