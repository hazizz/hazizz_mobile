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
        int size = requestQueue.size() - 1;
     //   Log.e("hey", "q1: " + size);
        //for (int i = 0; i <= size; i++) {
        for (Request r : requestQueue) {
          /*  requestQueue.get(0).requestType.setupCall();
            requestQueue.get(0).requestType.makeCall();
            //  Log.e("hey", "q: " + requestQueue.size());
            //  Log.e("hey", "i: " + i);
            requestQueue.remove(0); */

            r.requestType.setupCall();
            r.requestType.makeCall();
            //  Log.e("hey", "q: " + requestQueue.size());
            //  Log.e("hey", "i: " + i);
            requestQueue.remove(0);
        }
    }
}
