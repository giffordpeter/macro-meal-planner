from typing import Any, Dict, Optional

from fastapi import HTTPException, status


class APIException(HTTPException):
    def __init__(
        self,
        status_code: int,
        detail: str,
        code: str,
        headers: Optional[Dict[str, Any]] = None,
    ) -> None:
        super().__init__(status_code=status_code, detail=detail, headers=headers)
        self.code = code


class NotFoundException(APIException):
    def __init__(self, detail: str, code: str = "NOT_FOUND") -> None:
        super().__init__(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=detail,
            code=code,
        )


class UnauthorizedException(APIException):
    def __init__(self, detail: str = "Not authenticated", code: str = "UNAUTHORIZED") -> None:
        super().__init__(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail=detail,
            code=code,
            headers={"WWW-Authenticate": "Bearer"},
        )


class ForbiddenException(APIException):
    def __init__(self, detail: str = "Not authorized", code: str = "FORBIDDEN") -> None:
        super().__init__(
            status_code=status.HTTP_403_FORBIDDEN,
            detail=detail,
            code=code,
        )


class BadRequestException(APIException):
    def __init__(self, detail: str, code: str = "BAD_REQUEST") -> None:
        super().__init__(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=detail,
            code=code,
        )


class ConflictException(APIException):
    def __init__(self, detail: str, code: str = "CONFLICT") -> None:
        super().__init__(
            status_code=status.HTTP_409_CONFLICT,
            detail=detail,
            code=code,
        )
