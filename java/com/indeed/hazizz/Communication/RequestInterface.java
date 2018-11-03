package com.indeed.hazizz.Communication;

import android.content.Context;

import com.indeed.hazizz.Communication.POJO.Response.CustomResponseHandler;
import com.indeed.hazizz.Communication.POJO.Response.ResponseInterface;

import org.json.JSONObject;

import java.util.HashMap;

public interface RequestInterface {
    /* protected Context context;
     protected HashMap<String, Object> body;
     protected CustomResponseHandler cOnResponse;
     protected HashMap<String, String> vars; */

     public void setupCall();
     public void makeCall();


}
