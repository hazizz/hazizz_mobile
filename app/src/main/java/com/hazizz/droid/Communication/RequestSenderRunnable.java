package com.hazizz.droid.Communication;

import android.content.Context;
import android.util.Log;

import com.hazizz.droid.Manager;
import com.hazizz.droid.Network;

public class RequestSenderRunnable implements Runnable{

    private Context context;

    public RequestSenderRunnable(Context context){
        this.context = context;
    }
    @Override public void run() {
        boolean loopBool = true;
        while(loopBool) {
          //  Log.e("hey", "ifFreezed: " + Manager.ThreadManager.isFreezed());
            if(Manager.ThreadManager.isDelayed()) {
                synchronized (this) {
                    try {
                        Log.e("hey", "waiting123: start");
                        this.wait(1000);
                        Log.e("hey", "waiting123: end");
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                }
                Manager.ThreadManager.endDelay();
                MiddleMan.callAgainRateLimit();
            }else {
                if (!Manager.ThreadManager.isFreezed()) {
                    if (Network.getActiveNetwork(context) != null && Network.isConnectedOrConnecting(context)) {
                        if (!MiddleMan.requestQueue.isEmpty()) {
                            MiddleMan.sendRequestsFromQ();
                        }
                    }
                }else{

                }

            }
        }
    }
}
