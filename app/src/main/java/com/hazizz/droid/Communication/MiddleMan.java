package com.hazizz.droid.Communication;

import com.hazizz.droid.Network;
import android.util.Log;
import android.widget.Toast;

import com.hazizz.droid.Communication.Requests.Request;
import com.hazizz.droid.R;

import java.util.concurrent.BlockingQueue;
import java.util.concurrent.LinkedBlockingDeque;

public class MiddleMan{
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

    public static void newRequest(Request newRequest) {
        for (Request r : requestQueue)
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

    public static void gotRequestResponse(Request r){
        waitingForResponseQueue.remove(r);
    }

    public static void callAgain(){
        for(Request r : requestQueue) {
            Log.e("hey", "call again: " + r);
            r.setupCall();
            r.makeCallAgain();
        }
    }

    public static void sendRequestsFromQ() {
        for (Request request : requestQueue) {
            request.setupCall();
            request.makeCall();
            try {
                waitingForResponseQueue.put(request);
            } catch (InterruptedException e) { e.printStackTrace(); }
        }
        for(Request r : waitingForResponseQueue){
            requestQueue.remove(r);
        }
    }
}