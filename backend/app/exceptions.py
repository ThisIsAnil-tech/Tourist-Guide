class AppException(Exception):
    def __init__(self, status_code: int, message: str):
        self.status_code = status_code
        self.message = message


class NotFoundException(AppException):
    def __init__(self, message: str = "Resource not found"):
        super().__init__(404, message)


class ConflictException(AppException):
    def __init__(self, message: str = "Conflict"):
        super().__init__(409, message)


class UnauthorizedException(AppException):
    def __init__(self, message: str = "Unauthorized"):
        super().__init__(401, message)


class ForbiddenException(AppException):
    def __init__(self, message: str = "Forbidden"):
        super().__init__(403, message)


class RateLimitException(AppException):
    def __init__(self, message: str = "Too many requests"):
        super().__init__(429, message)


class UnsupportedMediaException(AppException):
    def __init__(self, message: str = "Unsupported file type"):
        super().__init__(415, message)


class PayloadTooLargeException(AppException):
    def __init__(self, message: str = "File too large"):
        super().__init__(413, message)