package com.indeed.hazizz.Communication;

import static com.indeed.hazizz.Communication.ErrorCode.*;
import static com.indeed.hazizz.Communication.ErrorCode.FORBIDDEN;
import static com.indeed.hazizz.Communication.HttpStatus.*;

public class ResponseHandler {

    private int errorCode;
    private int httpStatus;

    public int checkHttpStatus(int s){
        httpStatus = s;
        if     (httpStatus == 200){ on200(); return 200;}
        else if(httpStatus == 201){ on201(); return 201;}
        else if(httpStatus == 202){ on202(); return 202;}
        else if(httpStatus == 203){ on203(); return 203;}
        else if(httpStatus == 204){ on204(); return 204;}
        else if(httpStatus == 205){ on205(); return 205;}
        else if(httpStatus == 206){ on206(); return 206;}
        else if(httpStatus == 400){ on400(); return 400;}
        else if(httpStatus == 401){ on401(); return 401;}
        else if(httpStatus == 403){ on403(); return 403;}
        else if(httpStatus == 404){ on404(); return 404;}
        else if(httpStatus == 405){ on405(); return 405;}
        else if(httpStatus == 406){ on406(); return 406;}
        else if(httpStatus == 407){ on407(); return 407;}
        else if(httpStatus == 408){ on408(); return 408;}
        else if(httpStatus == 409){ on409(); return 409;}
        else if(httpStatus == 410){ on410(); return 410;}
        else if(httpStatus == 500){ on500(); return 500;}
        else if(httpStatus == 501){ on501(); return 501;}
        else if(httpStatus == 502){ on502(); return 502;}
        else if(httpStatus == 503){ on503(); return 503;}
        else if(httpStatus == 504){ on504(); return 504;}
        else if(httpStatus == 505){ on505(); return 505;}
        else if(httpStatus == 506){ on506(); return 506;}
        else if(httpStatus == 507){ on507(); return 507;}
        else if(httpStatus == 508){ on508(); return 508;}
        else if(httpStatus == 509){ on509(); return 509;}
        else if(httpStatus == 510){ on510(); return 510;}
        else if(httpStatus == 511){ on511(); return 511;}
        return 0;
    }

    public void on200(){};
    public void on201(){};
    public void on202(){};
    public void on203(){};
    public void on204(){};
    public void on205(){};
    public void on206(){};
    public void on400(){};
    public void on401(){};
    public void on403(){};
    public void on404(){};
    public void on405(){};
    public void on406(){};
    public void on407(){};
    public void on408(){};
    public void on409(){};
    public void on410(){};
    public void on500(){};
    public void on501(){};
    public void on502(){};
    public void on503(){};
    public void on504(){};
    public void on505(){};
    public void on506(){};
    public void on507(){};
    public void on508(){};
    public void on509(){};
    public void on510(){};
    public void on511(){};

    public void checkErrorCode(int ec) {
        errorCode = ec;
        if (errorCode == UNKNOW_ERROR.toInt()) onUnknowError();
        else if (errorCode == INVALID_DATA.toInt()) onInvalidData();
        else if (errorCode == INVALID_DATA.toInt()) onInvalidData();
        else if (errorCode == DATABASE_ERROR.toInt()) onDatabaseError();
        else if (errorCode == PATH_VARIABLE_MISSING.toInt()) onPathVariableMissing();
        else if (errorCode == FORBIDDEN.toInt()) onForbidden();
        else if (errorCode == GENERAL_AUTHENTICATION_ERROR.toInt()) onGeneralAuthenticationError();
        else if (errorCode == INVALID_PASSWORD.toInt()) onInvalidPassword();
        else if (errorCode == ACCOUNT_LOCKED.toInt()) onAccountLocked();
        else if (errorCode == ACCOUNT_DISABLED.toInt()) onAccountDisabled();
        else if (errorCode == ACCOUNT_EXPIRED.toInt()) onAccountExpired();
        else if (errorCode == UNKNOWN_PERMISSION.toInt()) onUnkownPermission();
        else if (errorCode == BAD_AUTHENTICATION_REQUEST.toInt()) onBadAuthenticationRequest();
        else if (errorCode == GENERAL_USER_ERROR.toInt()) onGeneralUserError();
        else if (errorCode == USER_NOT_FOUND.toInt()) onUserNotFound();
        else if (errorCode == USERNAME_CONFLICT.toInt()) onUsernameConflict();
        else if (errorCode == EMAIL_CONFLICT.toInt()) onEmailConflict();
        else if (errorCode == GENERAL_GROUP_ERROR.toInt()) onGeneralGroupError();
        else if (errorCode == GROUP_NOT_FOUND.toInt()) onGroupNotFound();
        else if (errorCode == GROUP_NAME_CONFLICT.toInt()) onGroupNameConflict();
        else{

        }
    }

    public void onUnknowError(){};
    public void onInvalidData(){};
    public void onDatabaseError(){};
    public void onPathVariableMissing(){};
    public void onForbidden(){};
    public void onGeneralAuthenticationError(){};
    public void onInvalidPassword(){};
    public void onAccountLocked(){};
    public void onAccountDisabled(){};
    public void onAccountExpired(){};
    public void onUnkownPermission(){};
    public void onBadAuthenticationRequest(){};
    public void onGeneralUserError(){};
    public void onUserNotFound(){};
    public void onUsernameConflict(){};
    public void onGeneralGroupError(){};
    public void onEmailConflict(){};
    public void onGroupNotFound(){};
    public void onGroupNameConflict(){};

}
