package com.indeed.hazizz;

import android.content.Context;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.util.Log;

import com.indeed.hazizz.Communication.MiddleMan;

public class OfflineRunnable implements Runnable{

    private Context context;

    public OfflineRunnable(Context context){
        this.context = context;
    }

    @Override
    public void run() {
        // check for internet connection
        boolean loopBool = true;
        while(loopBool) {

            ConnectivityManager cm = (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);
            NetworkInfo activeNetwork = cm.getActiveNetworkInfo();
            if(activeNetwork != null && activeNetwork.isConnectedOrConnecting()){
                Log.e("hey", "found connection");
                if (!MiddleMan.requestQueue.isEmpty()) {
                   // try{ Thread.sleep(500); }catch(InterruptedException e){ }
                    MiddleMan.sendRequestsFromQ();
                    Log.e("hey", "sent request");
                  //  loopBool = false;
                 //   MiddleMan.removeRequestFromQ(0);
                   // MiddleMan.requestQueue.remove(0);
                }
            }
        }
    }
}
