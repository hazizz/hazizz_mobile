package com.indeed.hazizz.Communication;

import android.content.Context;
import android.os.Looper;
import android.os.Message;
import android.util.Log;

import com.indeed.hazizz.Communication.POJO.Response.CustomResponseHandler;
import com.indeed.hazizz.Communication.Requests.Request;
import com.indeed.hazizz.Network;

import java.net.InetAddress;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.logging.Handler;
import java.util.logging.LogRecord;

public abstract class MiddleMan{

    public static ArrayList<Request> requestQueue = new ArrayList<>();

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

    public static void newRequest(Context context, String requestType, HashMap<String, Object>  body, CustomResponseHandler cOnResponse, HashMap<String, String> vars) {
        Request newRequest = new Request(context, requestType, body, cOnResponse, vars);
        for (Request r : requestQueue) {
            if(r.requestType.getClass() == newRequest.requestType.getClass()){
                requestQueue.remove(r);
            }
        }
        if(Network.getActiveNetwork(context) == null || !Network.isConnectedOrConnecting(context)) {
            newRequest.cOnResponse.onNoConnection();
        }
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