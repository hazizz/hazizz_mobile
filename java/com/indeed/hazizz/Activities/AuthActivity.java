package com.indeed.hazizz.Activities;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.util.Log;

import com.indeed.hazizz.Communication.MiddleMan;
import com.indeed.hazizz.ErrorHandler;
import com.indeed.hazizz.Fragments.AuthFrags.FirstFragment;
import com.indeed.hazizz.Fragments.CreateSubjectFragment;
import com.indeed.hazizz.Fragments.CreateTaskFragment;
import com.indeed.hazizz.Fragments.GroupMainFragment;
import com.indeed.hazizz.Fragments.GroupsFragment;
import com.indeed.hazizz.Fragments.MainFragment;
import com.indeed.hazizz.Fragments.ViewTaskFragment;
import com.indeed.hazizz.R;
import com.indeed.hazizz.RequestSenderRunnable;
import com.indeed.hazizz.SharedPrefs;
import com.indeed.hazizz.TokenManager;
import com.indeed.hazizz.Transactor;

import java.util.Set;

public class AuthActivity extends AppCompatActivity {

    public Toolbar toolbar;
    private Fragment currentFrag;

    private static final String threadName = "unique_name";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_auth);

       // Thread.currentThread().interrupt();

     //   Thread SenderThread = new Thread(new RequestSenderRunnable(this));
     //   SenderThread.start();

        Set<Thread> threads = Thread.getAllStackTraces().keySet();

        boolean foundIt = false;

        for (Thread t : threads) {
            if(t.getName().equals(threadName)){
                foundIt = true;
                break;
            }
        }
        if(!foundIt){
            Thread SenderThread = new Thread(new RequestSenderRunnable(this), threadName);
            SenderThread.start();
        }
/*
        if (Thread.currentThread().getName().equals("1234")){
            Log.e("hey", "thread1 is already running");
        }else{
            Thread.currentThread().interrupt();
            Thread SenderThread = new Thread(new RequestSenderRunnable(this), "1234");
            SenderThread.start();
            Log.e("hey", "thread1 wasnt  running");
        } */

        toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

      //  ErrorHandler.unExpectedResponseDialog(this);


        //   Log.e("hey" , "server is running: " + MiddleMan.serverReachable());

    //    getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        if(SharedPrefs.getBoolean(this, "autoLogin", "autoLogin") && TokenManager.getUseToken(this).length() >= 210){
            Intent i = new Intent(this, MainActivity.class);
            startActivity(i);
        }else {
            Transactor.fragmentFirst(getSupportFragmentManager().beginTransaction());
        }
    }

    @Override
    public void onBackPressed() {
        currentFrag = Transactor.getCurrentFragment(getSupportFragmentManager());
        if(currentFrag instanceof FirstFragment) {}
        else{
            Transactor.fragmentFirst(getSupportFragmentManager().beginTransaction());
        }
    }
}
