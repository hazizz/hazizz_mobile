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
    //  private Request newRequest;

   /* public MiddleMan(){
        requestList = new ArrayList<Request>();
    } */

 /*   public MiddleMan(Context baseContext, String me, Object o, CustomResponseHandler responseHandler) {
    } */

    public MiddleMan(Context context, String requestType, HashMap<String, Object>  pp, CustomResponseHandler cOnResponse, int groupID) {

        Request newRequest = new Request(context, requestType, pp, cOnResponse, groupID);
        requestQueue.add(newRequest);
    }
    public MiddleMan(Context context, String requestType, HashMap<String, Object>  pp, CustomResponseHandler cOnResponse) {
        Request newRequest = new Request(context, requestType, pp, cOnResponse);
        requestQueue.add(newRequest);
    }

    public void sendRequest() {
       /* newRequest.requestType.setupCall();
        newRequest.makeCall(); */
    }

    public void sendRequest2() {
       /* newRequest.requestType.setupCall();
        newRequest.requestType.makeCall(); */
    }

    public static void newRequest(Context context, String requestType, HashMap<String, Object>  pp, CustomResponseHandler cOnResponse) {
        Request newRequest = new Request(context, requestType, pp, cOnResponse);
        requestQueue.add(newRequest);
    }
    public static void newRequest(Context context, String requestType, HashMap<String, Object>  pp, CustomResponseHandler cOnResponse, int groupID) {
        Request newRequest = new Request(context, requestType, pp, cOnResponse, groupID);
        requestQueue.add(newRequest);
        Log.e("hey", "q: " + requestQueue.size());
    }

    public static void sendRequestsFromQ(){
        for(Request r : requestQueue){
            r.requestType.setupCall();
            r.requestType.makeCall();
            Log.e("hey", "q: " + requestQueue.size());
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
