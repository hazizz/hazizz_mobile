package com.hazizz.droid.manager;

import android.content.Context;

import com.hazizz.droid.communication.RequestSenderRunnable;

import java.util.Set;

public class ThreadManager {
    private final String threadName = "unique_name";
    private Thread thisThread = null;
    private boolean freeze = false;
    private boolean delay = false;


    private static ThreadManager instance = null;
    private ThreadManager(){ }

    public static ThreadManager getInstance() {
        if(instance == null){
            instance = new ThreadManager();
        }
        return instance;
    }

    public void startThreadIfNotRunning(Context context){
        Set<Thread> threads = Thread.getAllStackTraces().keySet();

        boolean foundIt = false;
        for (Thread t : threads) {
            if(t.getName().equals(threadName)){
                foundIt = true;
                thisThread = t;
                break;
            }
        }
        if(!foundIt){
            Thread SenderThread = new Thread(new RequestSenderRunnable(context), threadName);
            SenderThread.start();
        }
    }

    public Thread getThread(){
        Set<Thread> threads = Thread.getAllStackTraces().keySet();
        for (Thread t : threads) {
            if(t.getName().equals(threadName)){
                return t;
            }
        }
        return null;
    }

    public void startDelay(){
        delay = true;
    }
    public void endDelay(){
        delay = false;
    }
    public boolean isDelayed(){
        return delay;
    }

    public void freezeThread() {
        freeze = true;
    }
    public void unfreezeThread(){
        freeze = false;
    }
    public boolean isFreezed(){
        return freeze;
    }
}

