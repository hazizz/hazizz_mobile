package com.indeed.hazizz;

import android.content.Context;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.util.Log;

import com.indeed.hazizz.Communication.MiddleMan;

public class RequestSenderRunnable implements Runnable{

    private Context context;

    public RequestSenderRunnable(Context context){
        this.context = context;
    }

    @Override
    public void run() {
        // check for internet connection
        boolean loopBool = true;
        while(loopBool) {
            if(Manager.ThreadManager.isDelayed()) {
                synchronized (this) {
                    try {
                        this.wait(2000);
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                }
                Manager.ThreadManager.endDelay();
                MiddleMan.callAgain();
            }else {
                if (!Manager.ThreadManager.isFreezed()) {
                    if (Network.getActiveNetwork(context) != null && Network.isConnectedOrConnecting(context)) {
                        if (!MiddleMan.requestQueue.isEmpty()) {
                            MiddleMan.sendRequestsFromQ();
                            Log.e("hey", "sent request");
                        }
                    }
                }
            }
        }
    }
}
