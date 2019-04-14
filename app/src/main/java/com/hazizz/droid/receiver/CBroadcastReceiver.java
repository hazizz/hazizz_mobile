package com.hazizz.droid.receiver;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;

import com.hazizz.droid.Listener.GenericListener;

public class CBroadcastReceiver extends BroadcastReceiver {

    public String[] actions = {};


    private GenericListener listener;

    @Override
    public void onReceive(final Context context, final Intent intent) {
        listener.execute();
    }

    public void setOnReceive(GenericListener listener){
        this.listener = listener;
    }

}
