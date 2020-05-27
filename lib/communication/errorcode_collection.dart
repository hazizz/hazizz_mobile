class ErrorCode{
  final int code;
  final String message;
  const ErrorCode(this.code, this.message);

  static ErrorCode fromInt(int from){
    for(ErrorCode errorCode in ErrorCodes.list){
    if (errorCode.code == from)
    return errorCode;
    }
    return ErrorCodes.UNKNOWN_ERROR;
  }

  bool equals(int errorCode){
    return this.code == errorCode;
  }

  @override
  bool operator == (dynamic other) {
    if (other is ErrorCode ){
      return this.code == other.code;
    }
    if( other is int){
      return this.code == other;
    }
    return false;
  }
}

class ErrorCodes {
  //region Primary errors
  static const
  UNKNOWN_ERROR = ErrorCode(1, "Unidentified error! Please report it."),
  INVALID_DATA = ErrorCode(2, "Invalid data! Bad request!"),
  DATABASE_ERROR = ErrorCode(3, "Unidentified error in the database! Please report it."),
  PATH_VARIABLE_MISSING = ErrorCode(4, "Path variable missing! Bad request!"),
  BAD_FORMATTING = ErrorCode(5, "Bad formatting in request."),
  INVALID_HTTP_METHOD = ErrorCode(6, "The HTTP method is invalid."), 
  NOT_TRIMMED = ErrorCode(7, "You must trim the incoming data"),
  REQUEST_PARAMETERS_MISSING = ErrorCode(8, "You must include all request parameters!"),
  //endregion
  //region Authentication errors
  GENERAL_AUTHENTICATION_ERROR = ErrorCode(10, "Unidentified authentication error!"),
  FORBIDDEN = ErrorCode(11, "Forbidden!"),
  INVALID_PASSWORD = ErrorCode(12, "Password incorrect!"),
  ACCOUNT_LOCKED = ErrorCode(13, "This account is locked!"),
  ACCOUNT_DISABLED = ErrorCode(14, "This account is disabled!"),
  ACCOUNT_EXPIRED = ErrorCode(15, "This account has expired!"),
  UNKNOWN_PERMISSION = ErrorCode(16, "Unknown permission!"),
  BAD_AUTHENTICATION_REQUEST = ErrorCode(17, "Not valid authentication request! Bad request!"),
  INVALID_TOKEN = ErrorCode(18, "The given token is invalid!"),
  RATE_LIMIT_REACHED = ErrorCode(19, "Too many requests! Please slow down!"),
  RECAPTCHA_ERROR = ErrorCode(20, "Recaptcha error has occurred!"),
  REFRESH_TOKEN_INVALID = ErrorCode(21, "Refresh token invalid!"),
  ELEVATION_TOKEN_INVALID = ErrorCode(22, "Elevation token invalid!"),
  AUTH_TOKEN_INVALID = ErrorCode(23, "Authentication token invalid!"),
  AUTH_SERVER_UNAVAILABLE = ErrorCode(24, "Authentication server not available right now!"),
  INVALID_OPENID_TOKEN = ErrorCode(25, "Nem megfelelő az openID token a Google library szerint, próbáld kiolvasni jwt.io oldalon"),
  NO_ASSOCIATED_EMAIL = ErrorCode(26, "No associated email address"),
  //endregion
  //region User errors
  GENERAL_USER_ERROR = ErrorCode(30, "Unidentified user error! Please report it."),
  USER_NOT_FOUND = ErrorCode(31,"User not found!"),
  USERNAME_CONFLICT = ErrorCode(32, "Username is already taken!"),
  EMAIL_CONFLICT = ErrorCode(33, "Email address is already taken!"),
  REGISTRATION_DISABLED = ErrorCode(34, "Registration is disabled!"),
  CONSENT_MISSING = ErrorCode(35, "Cannot register without consent!"),
  DISPLAYNAME_INVALID = ErrorCode(36, "Display name is invalid!"),
  //endregion
  //region Group errors
  GENERAL_GROUP_ERROR = ErrorCode(50, "Unidentified group error! Please report it!"),
  GROUP_NOT_FOUND = ErrorCode(51,"Group not found!"),
  GROUP_NAME_CONFLICT = ErrorCode(52, "Group name is already taken!"),
  CAN_NOT_JOIN_GROUP = ErrorCode(53,  "You can not join that group!"),
  CAN_NOT_INVITE = ErrorCode(54, "You can not invite a user to that group!"),
  USER_ALREADY_IN_GROUP = ErrorCode(55,"User is already in the group!"),
  BAD_PASSWORD = ErrorCode(56, "The password was incorrect!"),
  USER_NOT_IN_GROUP = ErrorCode(57, "User is not in the group!"),
  PASSWORD_REQUIRED = ErrorCode(58, "Password is required for password protected group"),
  GROUP_LIMIT = ErrorCode(59, "Your group limit has been reached!"),
  //endregion
  //region Task errors
  GENERAL_TASK_ERROR = ErrorCode(70,  "Unidentified task error! Please report it!"),
  TASK_NOT_FOUND = ErrorCode(71, "Task not found!"),
  TASK_DATE_INVALID = ErrorCode(72, "Due creationDate invalid"),
  TASK_LIMIT = ErrorCode(73,  "Task limit has been reached."),
  //endregion
  //region Comment errors
  GENERAL_COMMENT_ERROR = ErrorCode(90, "Unidentified comment error! Please report it!"),
  COMMENT_SECTION_NOT_FOUND = ErrorCode(91, "Comment task not found!"),
  COMMENT_NOT_FOUND = ErrorCode(92,  "Comment not found!"),
  USER_ALREADY_HAS_COMMENT = ErrorCode(93, "User has reached the max limit of comments on this task."),
  USER_DO_NOT_OWN_COMMENT = ErrorCode(94, "User does not have ownership of that comment."),
  //endregion
  //region Subject errors
  GENERAL_SUBJECT_ERROR = ErrorCode(110, "Unidentified subject error! Please report it!"),
  SUBJECT_NOT_FOUND = ErrorCode(111, "Subject not found!"),
  SUBJECT_LIMIT = ErrorCode(112, "The group has reached it's subject limit!"),
  //endregion
  //region Profile picture errors
  GENERAL_PPICTURE_ERROR = ErrorCode(120, "Unidentified profile picture error! Please report it!"),
  PPICTURE_SIZE_ERROR = ErrorCode(121, "The picture's size not appropriate!"),
  PPICTURE_FORMAT_ERROR = ErrorCode(122, "The picture's format is invalid!"),
  //endregion
  //region Kreta errors
  GENERAL_THERA_ERROR = ErrorCode(130, "Unrecognized kreta error! Please report it!"),
  THERA_AUTHENTICATION_ERROR = ErrorCode(131, "The authentication request was declined."),
  THERA_SESSION_NOT_FOUND = ErrorCode(132, "The requested session was not found!"),
  THERA_IN_SESSION_ERROR = ErrorCode(133, "The user already has thera session"),
  THERA_URL_NON_EXISTANT = ErrorCode(134, "The sent URL is not in the THERA database"),
  THERA_BAD_WEEKNUMBER = ErrorCode(135, "The week number must be between 1-53"),
  THERA_SESSION_NOT_ACTIVE = ErrorCode(136, "The thera session must be active!"),
  //endregion
  //region Announcement errors
  GENERAL_ANNOUNCEMENT_ERROR = ErrorCode(150, "Unrecognized announcement error! Please report it!"),
  ANNOUNCEMENT_NOT_FOUND = ErrorCode(151, "Announcement not found!"),
  ANNOUNCEMENT_LIMIT = ErrorCode(152, "The group has reached it's announcement limit");
  //endregion

  //region Wrapping the errors into a list
  static final List<ErrorCode> list = [
    UNKNOWN_ERROR,
    INVALID_DATA,
    DATABASE_ERROR,
    PATH_VARIABLE_MISSING,
    BAD_FORMATTING,
    INVALID_HTTP_METHOD,
    NOT_TRIMMED,
    REQUEST_PARAMETERS_MISSING,
    GENERAL_AUTHENTICATION_ERROR,
    FORBIDDEN,
    INVALID_PASSWORD,
    ACCOUNT_LOCKED,
    ACCOUNT_DISABLED,
    ACCOUNT_EXPIRED ,
    UNKNOWN_PERMISSION,
    BAD_AUTHENTICATION_REQUEST,
    INVALID_TOKEN,
    RATE_LIMIT_REACHED,
    RECAPTCHA_ERROR,
    REFRESH_TOKEN_INVALID,
    ELEVATION_TOKEN_INVALID,
    AUTH_TOKEN_INVALID,
    AUTH_SERVER_UNAVAILABLE,
    GENERAL_USER_ERROR ,
    USER_NOT_FOUND ,
    USERNAME_CONFLICT,
    EMAIL_CONFLICT,
    REGISTRATION_DISABLED,
    CONSENT_MISSING ,
    DISPLAYNAME_INVALID,
    GENERAL_GROUP_ERROR,
    GROUP_NOT_FOUND,
    GROUP_NAME_CONFLICT,
    CAN_NOT_JOIN_GROUP,
    CAN_NOT_INVITE,
    USER_ALREADY_IN_GROUP,
    BAD_PASSWORD,
    USER_NOT_IN_GROUP,
    PASSWORD_REQUIRED,
    GROUP_LIMIT,
    GENERAL_TASK_ERROR,
    TASK_NOT_FOUND,
    TASK_DATE_INVALID,
    TASK_LIMIT,
    GENERAL_COMMENT_ERROR,
    COMMENT_SECTION_NOT_FOUND,
    COMMENT_NOT_FOUND,
    USER_ALREADY_HAS_COMMENT,
    USER_DO_NOT_OWN_COMMENT,
    GENERAL_SUBJECT_ERROR,
    SUBJECT_NOT_FOUND,
    SUBJECT_LIMIT,
    GENERAL_PPICTURE_ERROR,
    PPICTURE_SIZE_ERROR,
    PPICTURE_FORMAT_ERROR,
    GENERAL_THERA_ERROR,
    THERA_AUTHENTICATION_ERROR,
    THERA_SESSION_NOT_FOUND,
    THERA_IN_SESSION_ERROR,
    THERA_URL_NON_EXISTANT,
    THERA_BAD_WEEKNUMBER,
    THERA_SESSION_NOT_ACTIVE,
    GENERAL_ANNOUNCEMENT_ERROR,
    ANNOUNCEMENT_NOT_FOUND,
    ANNOUNCEMENT_LIMIT
  ];
//endregion
}
