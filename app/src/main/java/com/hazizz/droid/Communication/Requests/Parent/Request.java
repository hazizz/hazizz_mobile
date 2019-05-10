package com.hazizz.droid.communication.requests.parent;

import android.app.Activity;
import com.hazizz.droid.communication.responsePojos.CustomResponseHandler;

public class Request extends ParentRequest {
    private static final String path = "hazizz-server/";

    public Request(){
        super(path);
        this.thisRequest = this;
    }
    public Request(Activity act, CustomResponseHandler cOnResponse){
        super(act, cOnResponse, path);
        this.thisRequest = this;
    }


}

