package com.indeed.hazizz.Communication;

import android.app.Activity;
import android.content.Context;
import android.util.Log;

import com.indeed.hazizz.Communication.POJO.Response.CustomResponseHandler;
import com.indeed.hazizz.Communication.Requests.Request;
import com.indeed.hazizz.Network;

import java.util.*;

public abstract class MiddleMan{

    public static  final List<Request> requestQueue = Collections.synchronizedList(new LinkedList<>());
    private static final  List<Request> waitingForResponse = Collections.synchronizedList(new LinkedList<>());
    private static final List<Request> waitingForCallAgain = Collections.synchronizedList(new LinkedList<>());
    private static final List<Request> canceledCalls = Collections.synchronizedList(new LinkedList<>());

    public static void cancelAllRequest(){
        synchronized (requestQueue){
            for (Request r : requestQueue) {
                r.cancelRequest();
            }
        } // TODO egész thread küldését le kell állitani
        synchronized (waitingForResponse) {
            for (Request r : waitingForResponse) {
                r.cancelRequest();
            }
        }
    }

    public static void cancelAndSaveAllRequests(){
        synchronized (requestQueue){
            for (Request r : requestQueue) {
                r.cancelRequest();
                waitingForCallAgain.add(r);
            }
        }
    }

    public static void addToCallAgain(Request r){
        synchronized (waitingForCallAgain){
            waitingForCallAgain.add(r);
            for(Request a : waitingForCallAgain) {
                Log.e("hey", "add to" + "call again list: " + a.requestType);
            }
        }
    }

    public static void newRequest(Activity act, String requestType, HashMap<String, Object>  body, CustomResponseHandler cOnResponse, EnumMap<Strings.Path, Object> vars) {
        Request newRequest = new Request(act, requestType, body, cOnResponse, vars);
        List<Request> duplicateRequest = Collections.synchronizedList(new ArrayList<Request>());
        for (Request r : requestQueue)
            if (r.requestType.getClass() == newRequest.requestType.getClass()) {
                duplicateRequest.add(r);
                Log.e("hey", "removed1 a request");
            }

        if(Network.getActiveNetwork(act) == null || !Network.isConnectedOrConnecting(act)) {
            newRequest.cOnResponse.onNoConnection();
        }
        synchronized (requestQueue){
            for(Request r : duplicateRequest){
                requestQueue.remove(r);
            }
            requestQueue.add(newRequest);
        }
    }

    public static void newRequest(Context context, String requestType, HashMap<String, Object>  body, CustomResponseHandler cOnResponse, EnumMap<Strings.Path, Object> vars) {
        Request newRequest = new Request(context, requestType, body, cOnResponse, vars);
        List<Request> duplicateRequest = Collections.synchronizedList(new ArrayList<Request>());
        for (Request r : requestQueue) {
            if(r.requestType.getClass() == newRequest.requestType.getClass()){
                duplicateRequest.add(r);
                Log.e("hey", "removed2 a request");
            }
        }
        if(Network.getActiveNetwork(context) == null || !Network.isConnectedOrConnecting(context)) {
            newRequest.cOnResponse.onNoConnection();
        }
        synchronized (requestQueue){
            for(Request r : duplicateRequest){
                requestQueue.remove(r);
            }
            requestQueue.add(newRequest);
        }
    }

    public static void gotRequestResponse(Request r){
        synchronized (waitingForCallAgain) {
            waitingForResponse.remove(r);
        }
    }

    public static void callAgain(){
        synchronized (waitingForCallAgain){
            for(Request r : waitingForCallAgain) {
                Log.e("hey", "call again: " + r.requestType);
                r.requestType.setupCall();
                r.requestType.makeCallAgain();
            }
        }
    }

    public static void sendRequestsFromQ() {
        synchronized (waitingForResponse){
            synchronized (requestQueue){
                for (Request request : requestQueue) {
                    request.requestType.setupCall();
                    request.requestType.makeCall();
                    waitingForResponse.add(request);
                }
                for(Request r : waitingForResponse){
                    requestQueue.remove(r);
                }
            }
        }
    }
}