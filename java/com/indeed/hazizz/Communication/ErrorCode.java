package com.indeed.hazizz.Communication;

import static com.indeed.hazizz.Communication.HttpStatus.*;

public enum ErrorCode {

    UNKNOW_ERROR(1, HttpStatus.INTERNAL_SERVER_ERROR),
    INVALID_DATA(2, HttpStatus.BAD_REQUEST),
    DATABASE_ERROR(3, HttpStatus.INTERNAL_SERVER_ERROR),
    PATH_VARIABLE_MISSING(4, HttpStatus.BAD_REQUEST),
    GENERAL_AUTHENTICATION_ERROR(10, HttpStatus.UNAUTHORIZED),
    FORBIDDEN(11, HttpStatus.FORBIDDEN),
    INVALID_PASSWORD(12, HttpStatus.UNAUTHORIZED),
    ACCOUNT_LOCKED(13, HttpStatus.UNAUTHORIZED),
    ACCOUNT_DISABLED(14, HttpStatus.UNAUTHORIZED),
    ACCOUNT_EXPIRED(15, HttpStatus.UNAUTHORIZED),
    UNKNOWN_PERMISSION(16, HttpStatus.NOT_FOUND),
    BAD_AUTHENTICATION_REQUEST(17, HttpStatus.UNAUTHORIZED),
    GENERAL_USER_ERROR(30, HttpStatus.INTERNAL_SERVER_ERROR),
    USER_NOT_FOUND(31, HttpStatus.NOT_FOUND),
    USERNAME_CONFLICT(32, HttpStatus.CONFLICT),
    EMAIL_CONFLICT(33, HttpStatus.CONFLICT),
    GENERAL_GROUP_ERROR(50, HttpStatus.INTERNAL_SERVER_ERROR),
    GROUP_NOT_FOUND(51, HttpStatus.NOT_FOUND),
    GROUP_NAME_CONFLICT(52, HttpStatus.CONFLICT);

    private int errorCode;
    private HttpStatus status;

    ErrorCode(int errorCode, HttpStatus status) {
        this.errorCode = errorCode;
        this.status = status;
    }

    public int toInt() {
        return errorCode;
    }

    public HttpStatus getStatus(){
        return status;
    }
}
