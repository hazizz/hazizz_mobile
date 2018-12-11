package com.indeed.hazizz.Activities;

import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;

import com.indeed.hazizz.Fragments.AuthFrags.FirstFragment;
import com.indeed.hazizz.Manager;
import com.indeed.hazizz.R;
import com.indeed.hazizz.RequestSenderRunnable;
import com.indeed.hazizz.SharedPrefs;
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

        Manager.ThreadManager.startThreadIfNotRunning(this);
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
        if(SharedPrefs.getBoolean(this, "autoLogin", "autoLogin") && !SharedPrefs.TokenManager.getRefreshToken(this).equals("used")){
            Intent i = new Intent(this, MainActivity.class);
            startActivity(i);
        }else {
            Transactor.fragmentFirst(getSupportFragmentManager().beginTransaction());
        }
    }

    @Override
    public void onBackPressed() {
        currentFrag = Transactor.getCurrentFragment(getSupportFragmentManager(), false);
        if(currentFrag instanceof FirstFragment) {}
        else{
            Transactor.fragmentFirst(getSupportFragmentManager().beginTransaction());
        }
    }

    @Override
    public void onResume() {
        super.onResume();
    }

    @Override
    public void onRestart() {
        super.onRestart();
    }
}
