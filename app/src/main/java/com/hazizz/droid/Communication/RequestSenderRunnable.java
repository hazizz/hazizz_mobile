package com.hazizz.droid.Communication;

import android.content.Context;

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
                        }
                    }
                }
            }
        }
    }
}
