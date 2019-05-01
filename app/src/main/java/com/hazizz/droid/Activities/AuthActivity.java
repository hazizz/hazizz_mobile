package com.hazizz.droid.activities;

import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.util.Log;

import com.crashlytics.android.Crashlytics;
import com.crashlytics.android.answers.Answers;
import com.hazizz.droid.other.AppInfo;
import com.hazizz.droid.fragments.AuthFrags.FirstFragment;
import com.hazizz.droid.other.SharedPrefs;
import com.hazizz.droid.navigation.Transactor;
import com.hazizz.droid.R;
import com.hazizz.droid.manager.ThreadManager;

import io.fabric.sdk.android.Fabric;


public class AuthActivity extends AppCompatActivity {

    private Toolbar toolbar;
    private Fragment currentFrag;

    private static final String THREADNAME = "unique_name";

    @Override
    protected void onCreate(Bundle savedInstanceState) {

        Log.e("hey", "AuthActivity created");

        if(AppInfo.isDarkMode(getBaseContext())){
            setTheme(R.style.AppTheme_Dark);
        }else{
            setTheme(R.style.AppTheme_Light);
        }

        super.onCreate(savedInstanceState);

        if(SharedPrefs.getBoolean(this, "autoLogin", "autoLogin") && !SharedPrefs.TokenManager.getRefreshToken(this).equals("used")){
            Log.e("hey", "code: 6469");
            openMainActivity();
        }else {
            Transactor.fragmentFirst(getSupportFragmentManager().beginTransaction());
        }

        // only enable bug tracking in release version
        Fabric.with(this, new Crashlytics());

        Fabric.with(this, new Answers());

        setContentView(R.layout.activity_auth);

        ThreadManager.getInstance().startThreadIfNotRunning(this);

        toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
    }

    public void openMainActivity(){
        Log.e("hey", "in method openMainActivity");
        Intent i = new Intent(this, MainActivity.class);
        Intent thisActivityIntent = getIntent();
        if(thisActivityIntent != null && thisActivityIntent.getExtras() != null) {
            i.putExtras(thisActivityIntent.getExtras());
        }
        startActivity(i);
        finish();
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
