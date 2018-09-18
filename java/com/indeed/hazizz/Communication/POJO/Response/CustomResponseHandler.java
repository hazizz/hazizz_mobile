package com.indeed.hazizz.Communication.POJO.Response;

import java.util.HashMap;

public interface CustomResponseHandler {

    public void onResponse(HashMap<String, Object> response);
    public void onResponse1(Object response);
    public void onFailure();
    public void onErrorResponse(HashMap<String, Object> response);

}
