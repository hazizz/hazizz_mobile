package com.hazizz.droid.receiver;

public class NetworkChangeReceiver extends CBroadcastReceiver {
    public NetworkChangeReceiver(){
        actions = new String[]{"android.net.conn.CONNECTIVITY_CHANGE"};
    }
}