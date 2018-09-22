package com.indeed.hazizz;

import android.os.Looper;
import android.os.Message;
import android.util.Log;

import java.util.logging.Handler;
import java.util.logging.LogRecord;

class LooperThread extends Thread {
    public Handler mHandler;

    @Override
    public void run() {
        Looper.prepare();

        mHandler = new Handler() {
            public void handleMessage(Message msg) {
                // process incoming messages here
                // this will run in non-ui/background thread
                Log.e("hey", "looping...");
            }

            @Override
            public void publish(LogRecord logRecord) {

            }

            @Override
            public void flush() {

            }

            @Override
            public void close() throws SecurityException {

            }
        };

        Looper.loop();
    }
}