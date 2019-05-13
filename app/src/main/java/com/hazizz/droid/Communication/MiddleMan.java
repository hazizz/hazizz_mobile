package com.hazizz.droid.communication;

import com.hazizz.droid.communication.requests.parent.ParentRequest;
import com.hazizz.droid.other.Network;
import android.util.Log;
import android.widget.Toast;

import com.hazizz.droid.R;

import java.util.concurrent.BlockingQueue;
import java.util.concurrent.LinkedBlockingDeque;

public class MiddleMan{
    public static BlockingQueue<ParentRequest> requestQueue = new LinkedBlockingDeque<>(10);
    public static BlockingQueue<ParentRequest> waitingForResponseQueue = new LinkedBlockingDeque<>(10);
    public static BlockingQueue<ParentRequest> rateLimitRequestQueue = new LinkedBlockingDeque<>(10);

    public static void cancelAllRequest(){
        for (RequestInterface r : requestQueue) {
            r.cancelRequest();
        }
        for (RequestInterface r : waitingForResponseQueue) {
            r.cancelRequest();
        }
    }

    public static void cancelAndSaveAllRequests() {
        for (ParentRequest r : requestQueue) {
            r.cancelRequest();
            try {
                requestQueue.put(r);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }

    public static void addToCallAgain(ParentRequest r) {
        try {
            requestQueue.put(r);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }

    public static void addToRateLimitQueue(ParentRequest r) {
        try {
            rateLimitRequestQueue.put(r);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }

    public static void newRequest(ParentRequest newRequest) {
        for (RequestInterface r : requestQueue)
            if (r.getClass() == newRequest.getClass()) {
                requestQueue.remove(r);
            }
        if(Network.getActiveNetwork(newRequest.getContext()) == null || !Network.isConnectedOrConnecting(newRequest.getContext())) {
            newRequest.getResponseHandler().onNoConnection();
            Toast.makeText(newRequest.getContext(), R.string.info_noInternetAccess, Toast.LENGTH_LONG).show();
        }
        try {
            requestQueue.put(newRequest);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }

    /*
    public static void newThRequest(ThRequest newRequest) {
        for (RequestInterface r : requestQueue)
            if (r.getClass() == newRequest.getClass()) {
                requestQueue.remove(r);
            }
        if(Network.getActiveNetwork(newRequest.getActivity()) == null || !Network.isConnectedOrConnecting(newRequest.getActivity())) {
            newRequest.getResponseHandler().onNoConnection();
            Toast.makeText(newRequest.getActivity(), R.string.info_noInternetAccess, Toast.LENGTH_LONG).show();
        }
        try {
            requestQueue.put(newRequest);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }
    */

    public static void gotRequestResponse(RequestInterface r){
        waitingForResponseQueue.remove(r);
    }

    public static void callAgain(){
        for(RequestInterface r : requestQueue) {
            Log.e("hey", "call again: " + r);
            r.setupCall();
            r.makeCallAgain();

        }

    }

    public static void callAgainRateLimit(){
        for(RequestInterface r : rateLimitRequestQueue) {
            Log.e("hey", "call again2: " + r);
            r.setupCall();
            r.makeCallAgain();
            rateLimitRequestQueue.remove(r);
        }
    }

    public static void sendRequestsFromQ() {
        for (ParentRequest request : requestQueue) {
            request.setupCall();
            RequestSender.callAsync(request);
           // request.makeCall();
            try {
                waitingForResponseQueue.put(request);
            } catch (InterruptedException e) { e.printStackTrace(); }
        }
        for(RequestInterface r : waitingForResponseQueue){
            requestQueue.remove(r);
        }
    }
}