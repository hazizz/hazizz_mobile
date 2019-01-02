package com.indeed.hazizz.Activities;

import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;

import com.indeed.hazizz.Fragments.AuthFrags.FirstFragment;
import com.indeed.hazizz.Manager;
import com.indeed.hazizz.R;
import com.indeed.hazizz.SharedPrefs;
import com.indeed.hazizz.Transactor;


public class AuthActivity extends AppCompatActivity {

    private Toolbar toolbar;
    private Fragment currentFrag;

    private static final String THREADNAME = "unique_name";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);


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
