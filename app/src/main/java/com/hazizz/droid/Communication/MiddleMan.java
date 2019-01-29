package com.hazizz.droid.Communication;

import android.app.Activity;
import android.content.Context;

import com.hazizz.droid.Network;
import android.util.Log;

import com.hazizz.droid.Communication.POJO.Response.CustomResponseHandler;
import com.hazizz.droid.Communication.Requests.Request;

import java.util.EnumMap;
import java.util.HashMap;
import java.util.concurrent.BlockingQueue;
import java.util.concurrent.LinkedBlockingDeque;

public abstract class MiddleMan{

    public static BlockingQueue<Request> requestQueue = new LinkedBlockingDeque<>(10);
    public static BlockingQueue<Request> waitingForResponseQueue = new LinkedBlockingDeque<>(10);

    public static void cancelAllRequest(){
        for (Request r : requestQueue) {
            r.cancelRequest();
        }
        for (Request r : waitingForResponseQueue) {
            r.cancelRequest();
        }
    }

    public static void cancelAndSaveAllRequests() {
        for (Request r : requestQueue) {
            r.cancelRequest();
            try {
                requestQueue.put(r);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }

    public static void addToCallAgain(Request r) {
        try {
            requestQueue.put(r);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }

    public static void instantiateNewRequest(Context c, RequestInterface r){
        new Request(c, r);
    }

    public static void newRequest(Activity act, String requestType, HashMap<String, Object>  body, CustomResponseHandler cOnResponse, EnumMap<Strings.Path, Object> vars) {
        Request newRequest = new Request(act, requestType, body, cOnResponse, vars);
        for (Request r : requestQueue)
            if (r.requestType.getClass() == newRequest.requestType.getClass()) {
                requestQueue.remove(r);
            }
        if(Network.getActiveNetwork(act) == null || !Network.isConnectedOrConnecting(act)) {
            newRequest.cOnResponse.onNoConnection();
        }
        try {
            requestQueue.put(newRequest);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }

    public static void newRequest(Context context, String requestType, HashMap<String, Object>  body, CustomResponseHandler cOnResponse, EnumMap<Strings.Path, Object> vars) {
        Request newRequest = new Request(context, requestType, body, cOnResponse, vars);
        for (Request r : requestQueue) {
            if(r.requestType.getClass() == newRequest.requestType.getClass()){
                requestQueue.remove(r);
            }
        }
        if(Network.getActiveNetwork(context) == null || !Network.isConnectedOrConnecting(context)) {
            newRequest.cOnResponse.onNoConnection();
        }
        try {
            requestQueue.put(newRequest);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }

    public static void gotRequestResponse(Request r){
        waitingForResponseQueue.remove(r);
    }

    public static void callAgain(){
        for(Request r : requestQueue) {
            Log.e("hey", "call again: " + r.requestType);
            r.requestType.setupCall();
            r.requestType.makeCallAgain();
        }



    }

    public static void sendRequestsFromQ() {
        for (Request request : requestQueue) {
            request.requestType.setupCall();
            request.requestType.makeCall();
            try {
                waitingForResponseQueue.put(request);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
        for(Request r : waitingForResponseQueue){
            requestQueue.remove(r);
        }
    }
}