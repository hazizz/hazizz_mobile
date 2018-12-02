package com.indeed.hazizz.Communication;

import android.app.Activity;
import android.content.Context;
import android.os.Looper;
import android.os.Message;
import android.util.Log;

import com.indeed.hazizz.Communication.POJO.Response.CustomResponseHandler;
import com.indeed.hazizz.Communication.Requests.Request;
import com.indeed.hazizz.Network;

import java.net.InetAddress;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.logging.Handler;
import java.util.logging.LogRecord;

public abstract class MiddleMan{

    public static List<Request> requestQueue = Collections.synchronizedList(new ArrayList<Request>());
    public static List<Request> waitingForResponse = Collections.synchronizedList(new ArrayList<Request>());
    public static List<Request> waitingForCallAgain = Collections.synchronizedList(new ArrayList<Request>());
    private static Request r;

    public static boolean serverReachable(){
        {
            try {
                InetAddress.getByName("https://hazizz.duckdns.org:8081").isReachable(4000); //Replace with your name
                return true;
            } catch (Exception e) {
                return false;
            }
        }
    }

    public static void cancelAllRequest(){
        for (Request r : requestQueue) {
            r.cancelRequest();
        }
        for (Request r : waitingForResponse) {
            r.cancelRequest();
        }
    }

    public static void addToCallAgain(Request r){
        waitingForCallAgain.add(r);
    }

    public static void newRequest(Activity act, String requestType, HashMap<String, Object>  body, CustomResponseHandler cOnResponse, HashMap<String, Object> vars) {
        Request newRequest = new Request(act, requestType, body, cOnResponse, vars);
        List<Request> duplicateRequest = Collections.synchronizedList(new ArrayList<Request>());
        for (Request r : requestQueue)
            if (r.requestType.getClass() == newRequest.requestType.getClass()) {
                duplicateRequest.add(r);
                Log.e("hey", "removed1 a request");
            }
        for(Request r : duplicateRequest){
            requestQueue.remove(r);
        }
        if(Network.getActiveNetwork(act) == null || !Network.isConnectedOrConnecting(act)) {
            newRequest.cOnResponse.onNoConnection();
        }
        requestQueue.add(newRequest);
    }



    public static void newRequest(Context context, String requestType, HashMap<String, Object>  body, CustomResponseHandler cOnResponse, HashMap<String, Object> vars) {
        Request newRequest = new Request(context, requestType, body, cOnResponse, vars);
        List<Request> duplicateRequest = Collections.synchronizedList(new ArrayList<Request>());
        for (Request r : requestQueue) {
            if(r.requestType.getClass() == newRequest.requestType.getClass()){
                duplicateRequest.add(r);
                //requestQueue.remove(r);
                Log.e("hey", "removed2 a request");
            }
        }
        for(Request r : duplicateRequest){
            requestQueue.remove(r);
        }
        if(Network.getActiveNetwork(context) == null || !Network.isConnectedOrConnecting(context)) {
            newRequest.cOnResponse.onNoConnection();
        }
        requestQueue.add(newRequest);
    }

    public static void gotRequestResponse(Request r){
        waitingForResponse.remove(r);
    }

    public static void callAgain(Request a){
        a.requestType.setupCall();
        a.requestType.makeCallAgain();
       /* for(Request r : waitingForResponse){
            if(r.equals(a)){
                r.requestType.makeCallAgain();
                break;
            }
        } */
    }

    public static void callAgain(){
        for(Request r : waitingForCallAgain) {
            r.requestType.setupCall();
            r.requestType.makeCallAgain();
        }
       /* for(Request r : waitingForResponse){
            if(r.equals(a)){
                r.requestType.makeCallAgain();
                break;
            }
        } */
    }

    public static void sendRequestsFromQ() {
        for (Request r : requestQueue) {
            r.requestType.setupCall();
            r.requestType.makeCall();
            waitingForResponse.add(r);
        }
        for(Request r : waitingForResponse){
            requestQueue.remove(r);
        }

      //  requestQueue.clear();

      /*  for(Request r : requestQueueCopy){
            if(requestQueue.contains(r)){
                requestQueue.remove(r);
                Log.e("hey", "removed a request: " + r.requestType.getClass().toString());
                Log.e("hey", "2: " + requestQueue);
                break;
            }
        }
        Log.e("hey", "3: " + requestQueue); */


      //
    }
}