package com.hazizz.droid.communication.requests.parent;

import android.app.Activity;

import com.hazizz.droid.communication.responsePojos.CustomResponseHandler;

public class AuthRequest extends ParentRequest {

    private static final String path = "auth-server/";

    public AuthRequest(){
        super(path);
        this.thisRequest = this;
    }
    public AuthRequest(Activity act, CustomResponseHandler cOnResponse){
        super(act, cOnResponse, path);
        this.thisRequest = this;
    }
}