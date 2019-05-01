package com.hazizz.droid.receiver;

import android.content.Context;
import android.content.IntentFilter;

import com.hazizz.droid.listeners.GenericListener;

public class BroadcastReceiverHandler {

    CBroadcastReceiver cBroadcastReceiver;

    public BroadcastReceiverHandler(CBroadcastReceiver broadcastReceiver){
        this.cBroadcastReceiver = broadcastReceiver;
    }

    public void register(Context context){
        IntentFilter filter = new IntentFilter();
        for(int i = 0; i < cBroadcastReceiver.actions.length; i++) {
            filter.addAction(cBroadcastReceiver.actions[i]);
        }
        context.getApplicationContext().registerReceiver(cBroadcastReceiver, filter);
    }

    public void unregister(Context context){
        context.getApplicationContext().unregisterReceiver(cBroadcastReceiver);
    }

    public void setOnReceive(GenericListener listener){
        cBroadcastReceiver.setOnReceive(listener);
    }

}
