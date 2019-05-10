package com.hazizz.droid.communication;

import android.content.Context;
import android.util.Log;

import com.hazizz.droid.other.Network;
import com.hazizz.droid.manager.ThreadManager;

public class RequestSenderRunnable implements Runnable{

    private Context context;

    public RequestSenderRunnable(Context context){
        this.context = context;
    }
    @Override public void run() {
        boolean loopBool = true;

        ThreadManager threadManager = ThreadManager.getInstance();

        while(loopBool) {
          //  Log.e("hey", "ifFreezed: " + Manager.ThreadManager.isFreezed());
            if(threadManager.isDelayed()) {
                synchronized (this) {
                    try {
                        Log.e("hey", "waiting123: start");
                        this.wait(1000);
                        Log.e("hey", "waiting123: end");
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                }
                threadManager.endDelay();
                MiddleMan.callAgainRateLimit();
            }else {
                if (!threadManager.isFreezed()) {
                    if (Network.getActiveNetwork(context) != null && Network.isConnectedOrConnecting(context)) {
                        if (!MiddleMan.requestQueue.isEmpty()) {
                            MiddleMan.sendRequestsFromQ();
                        }
                    }
                }else{
                    Log.e("hey", "isFreezed");
                }
            }
        }
    }
}
