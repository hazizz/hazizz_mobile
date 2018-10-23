package com.indeed.hazizz.Communication;

import android.content.Context;
        import android.os.Looper;
        import android.os.Message;
        import android.util.Log;

        import com.indeed.hazizz.Communication.POJO.Response.CustomResponseHandler;
        import com.indeed.hazizz.Communication.Requests.Request;

        import java.util.ArrayList;
        import java.util.HashMap;
        import java.util.logging.Handler;
        import java.util.logging.LogRecord;

public abstract class MiddleMan{

    public static ArrayList<Request> requestQueue = new ArrayList<>();

    public static void newRequest(Context context, String requestType, HashMap<String, Object>  body, CustomResponseHandler cOnResponse, HashMap<String, Object> vars) {
        Request newRequest = new Request(context, requestType, body, cOnResponse, vars);
        requestQueue.add(newRequest);
    }

    public static void sendRequestsFromQ() {
        for (Request r : requestQueue) {
            r.requestType.setupCall();
            r.requestType.makeCall();
        }
        requestQueue.clear();
    }
}
