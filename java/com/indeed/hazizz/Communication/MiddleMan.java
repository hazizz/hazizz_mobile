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

  /*  public MiddleMan(Context context, String requestType, HashMap<String, Object>  body, CustomResponseHandler cOnResponse, int groupID) {

        Request newRequest = new Request(context, requestType, body, cOnResponse, groupID);
        requestQueue.add(newRequest);
    }
    public MiddleMan(Context context, String requestType, HashMap<String, Object>  body, CustomResponseHandler cOnResponse) {
        Request newRequest = new Request(context, requestType, body, cOnResponse);
        requestQueue.add(newRequest);
    } */

    public static void newRequest(Context context, String requestType, HashMap<String, Object>  body, CustomResponseHandler cOnResponse, HashMap<String, Object> vars) {
        Request newRequest = new Request(context, requestType, body, cOnResponse, vars);
        requestQueue.add(newRequest);
    }

   /* public static void newRequest(Context context, String requestType, HashMap<String, Object>  body, CustomResponseHandler cOnResponse, HashMap<String, Object> vars) {
        Request newRequest = new Request(context, requestType, body, cOnResponse, vars);
        requestQueue.add(newRequest);
    } */
  /*  public static void newRequest(Context context, String requestType, HashMap<String, Object>  body, CustomResponseHandler cOnResponse, int groupID) {
        Request newRequest = new Request(context, requestType, body, cOnResponse, groupID);
        requestQueue.add(newRequest);
        Log.e("hey", "q: " + requestQueue.size());
    }*/

    public static void sendRequestsFromQ(){
        int size = requestQueue.size()-1;
        Log.e("hey", "q1: " + size);
        for(int i = 0; i <= size; i++){
            requestQueue.get(0).requestType.setupCall();
            requestQueue.get(0).requestType.makeCall();
            Log.e("hey", "q: " + requestQueue.size());
            Log.e("hey", "i: " + i);
            requestQueue.remove(0);
        }
    }

    public static void removeRequestFromQ(int i){
        if(requestQueue.get(i) != null) {
            requestQueue.remove(i);
        }
        Log.e("hey", "removed");
        Log.e("hey", "q: " + requestQueue.size());
    }
}
