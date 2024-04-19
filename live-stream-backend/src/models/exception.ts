export enum HttpStatusCode {
    OK = 200,
    BAD_REQUEST = 400,
    UNAUTHORIZED = 401,
    FORBIDDEN = 403,
    NOT_FOUND = 404,
    INTERNAL_SERVER_ERROR = 500,
}

export enum ErrorCode {
    NOT_FOUND = "NOT_FOUND",
    INVALID_DATA = "INVALID_DATA",
    INVALID_CREDENTIALS = "INVALID_CRED",
    UNAUTHORISED = "UNAUTHORISED",
    FORBIDDEN = "FORBIDDEN",
    UNKNOWN = "UNKNOWN",
    CODE_EXPIRED = "CODE_EXPIRED",
    CONNECTION_EXISTS = "CONNECTION_EXISTS"
}

type ErrorArgs = {
    code?: ErrorCode,
    message?: string,
}

export class HttpException extends Error {
    status: HttpStatusCode;
    code: ErrorCode;
    message: string;

    constructor(status: HttpStatusCode, code: ErrorCode, message: string) {
        super(message)
        this.status = status
        this.code = code
        this.message = message
    }
}

export class AuthException extends HttpException {
    constructor(args?: ErrorArgs) {
        super(HttpStatusCode.UNAUTHORIZED, args?.code ?? ErrorCode.UNAUTHORISED, args?.message ?? "Unauthorised.")
    }
}

export class DisabledException extends HttpException {
    constructor(args?: ErrorArgs) {
        super(HttpStatusCode.UNAUTHORIZED, args?.code ?? ErrorCode.UNAUTHORISED, args?.message ?? "Unauthorised.")
    }
}

export class ForbiddenException extends HttpException {
    constructor(args?: ErrorArgs) {
        super(HttpStatusCode.FORBIDDEN, args?.code ?? ErrorCode.FORBIDDEN, args?.message ?? "Forbidden.")
    }
}

export class InvalidFieldValueException extends HttpException {
    constructor(fields: string[], args?: ErrorArgs) {
        super(HttpStatusCode.BAD_REQUEST, args?.code ?? ErrorCode.INVALID_DATA, args?.message ?? `Invalid value for the following field(s): ${fields.join(", ")}.`)
    }
}

export class NotFoundException extends HttpException {
    constructor(args?: ErrorArgs) {
        super(HttpStatusCode.NOT_FOUND, args?.code ?? ErrorCode.NOT_FOUND, args?.message ?? "Not found.")
    }
}

export class InternalErrorException extends HttpException {
    constructor(args?: ErrorArgs) {
        super(HttpStatusCode.INTERNAL_SERVER_ERROR, args?.code ?? ErrorCode.UNKNOWN, args?.message ?? "Internal server error.")
    }
}