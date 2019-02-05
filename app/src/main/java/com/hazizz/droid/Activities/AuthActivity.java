package com.hazizz.droid.Activities;

import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;

import com.crashlytics.android.Crashlytics;
import com.crashlytics.android.answers.Answers;
import com.hazizz.droid.BuildConfig;
import com.hazizz.droid.Fragments.AuthFrags.FirstFragment;
import com.hazizz.droid.Manager;
import com.hazizz.droid.SharedPrefs;
import com.hazizz.droid.Transactor;
import com.hazizz.droid.R;

import io.fabric.sdk.android.Fabric;


public class AuthActivity extends AppCompatActivity {

    private Toolbar toolbar;
    private Fragment currentFrag;

    private static final String THREADNAME = "unique_name";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        if (!BuildConfig.DEBUG) { // only enable bug tracking in release version
            Fabric.with(this, new Crashlytics());
        }
        Fabric.with(this, new Answers());

        setContentView(R.layout.activity_auth);


        Manager.ThreadManager.startThreadIfNotRunning(this);

        toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

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
