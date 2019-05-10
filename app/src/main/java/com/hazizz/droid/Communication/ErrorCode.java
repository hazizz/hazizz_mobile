package com.hazizz.droid.communication;

public enum ErrorCode {
    UNKNOWN_ERROR(1, "Unidentified error! Please report it."),
    INVALID_DATA(2, "Invalid data! Bad request!"),
    DATABASE_ERROR(3, "Unidentified error in the database! Please report it."),
    PATH_VARIABLE_MISSING(4, "Path variable missing! Bad request!"),
    BAD_FORMATTING(5, "Bad formatting in request."),
    INVALID_HTTP_METHOD(6, "The HTTP method is invalid."),
    NOT_TRIMMED(7, "You must trim the incoming data"),
    REQUEST_PARAMETERS_MISSING(8, "You must include all request parameters!"),
    GENERAL_AUTHENTICATION_ERROR(10, "Unidentified authentication error!"),
    FORBIDDEN(11, "Forbidden!"),
    INVALID_PASSWORD(12, "Password incorrect!"),
    ACCOUNT_LOCKED(13, "This account is locked!"),
    ACCOUNT_DISABLED(14, "This account is disabled!"),
    ACCOUNT_EXPIRED(15, "This account has expired!"),
    UNKNOWN_PERMISSION(16, "Unknown permission!"),
    BAD_AUTHENTICATION_REQUEST(17, "Not valid authentication request! Bad request!"),
    INVALID_TOKEN(18, "The given token is invalid!"),
    RATE_LIMIT_REACHED(19, "Too many requests! Please slow down!"),
    RECAPTCHA_ERROR(20, "Recaptcha error has occurred!"),
    REFRESH_TOKEN_INVALID(21, "Refresh token invalid!"),
    ELEVATION_TOKEN_INVALID(22, "Elevation token invalid!"),
    AUTH_TOKEN_INVALID(23, "Authentication token invalid!"),
    AUTH_SERVER_UNAVAILABLE(24, "Authentication server not available right now!"),
    GENERAL_USER_ERROR(30, "Unidentified user error! Please report it."),
    USER_NOT_FOUND(31,"User not found!"),
    USERNAME_CONFLICT(32, "Username is already taken!"),
    EMAIL_CONFLICT(33, "Email address is already taken!"),
    REGISTRATION_DISABLED(34, "Registration is disabled!"),
    CONSENT_MISSING(35, "Cannot register without consent!"),
    DISPLAYNAME_INVALID(36, "Display name is invalid!"),
    GENERAL_GROUP_ERROR(50, "Unidentified group error! Please report it!"),
    GROUP_NOT_FOUND(51,"Group not found!"),
    GROUP_NAME_CONFLICT(52, "Group name is already taken!"),
    CAN_NOT_JOIN_GROUP(53,  "You can not join that group!"),
    CAN_NOT_INVITE(54, "You can not invite a user to that group!"),
    USER_ALREADY_IN_GROUP(55,"User is already in the group!"),
    BAD_PASSWORD(56, "The password was incorrect!"),
    USER_NOT_IN_GROUP(57, "User is not in the group!"),
    PASSWORD_REQUIRED(58, "Password is required for password protected group"),
    GROUP_LIMIT(59, "Your group limit has been reached!"),
    GENERAL_TASK_ERROR(70,  "Unidentified task error! Please report it!"),
    TASK_NOT_FOUND(71, "Task not found!"),
    TASK_DATE_INVALID(72, "Due creationDate invalid"),
    TASK_LIMIT(73,  "Task limit has been reached."),
    GENERAL_COMMENT_ERROR(90, "Unidentified comment error! Please report it!"),
    COMMENT_SECTION_NOT_FOUND(91, "Comment task not found!"),
    COMMENT_NOT_FOUND(92,  "Comment not found!"),
    USER_ALREADY_HAS_COMMENT(93, "User has reached the max limit of comments on this task."),
    USER_DO_NOT_OWN_COMMENT(94, "User does not have ownership of that comment."),
    GENERAL_SUBJECT_ERROR(110, "Unidentified subject error! Please report it!"),
    SUBJECT_NOT_FOUND(111, "Subject not found!"),
    SUBJECT_LIMIT(112, "The group has reached it's subject limit!"),
    GENERAL_PPICTURE_ERROR(120, "Unidentified profile picture error! Please report it!"),
    PPICTURE_SIZE_ERROR(121, "The picture's size not appropriate!"),
    PPICTURE_FORMAT_ERROR(122, "The picture's format is invalid!"),
    GENERAL_THERA_ERROR(130, "Unrecognized kreta error! Please report it!"),
    THERA_AUTHENTICATION_ERROR(131, "The authentication request was declined."),
    THERA_SESSION_NOT_FOUND(132, "The requested session was not found!"),
    THERA_IN_SESSION_ERROR(133, "The user already has thera session"),
    THERA_URL_NON_EXISTANT(134, "The sent URL is not in the THERA database"),
    THERA_BAD_WEEKNUMBER(135, "The week number must be between 1-53"),
    THERA_SESSION_NOT_ACTIVE(136, "The thera session must be active!"),
    GENERAL_ANNOUNCEMENT_ERROR(150, "Unrecognized announcement error! Please report it!"),
    ANNOUNCEMENT_NOT_FOUND(151, "Announcement not found!"),
    ANNOUNCEMENT_LIMIT(152, "The group has reached it's announcement limit");

    private int code;
    private String errorMessage;

    ErrorCode(int code, String errorMessage) {
        this.code = code;
        this.errorMessage = errorMessage;
    }

    public static ErrorCode fromInt(int from){
        for(ErrorCode errorCode : ErrorCode.values()){
            if (errorCode.code == from)
                return errorCode;
        }
        return UNKNOWN_ERROR;
    }

    public int toInt() {
        return code;
    }

    public String getErrorMessage(){
        return errorMessage;
    }

    public boolean equals(int errorCode){
        return this.code == errorCode;
    }
}
