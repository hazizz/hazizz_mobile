package com.indeed.hazizz.Activities;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.util.Log;

import com.indeed.hazizz.Fragments.AuthFrags.FirstFragment;
import com.indeed.hazizz.Fragments.CreateSubjectFragment;
import com.indeed.hazizz.Fragments.CreateTaskFragment;
import com.indeed.hazizz.Fragments.GroupMainFragment;
import com.indeed.hazizz.Fragments.GroupsFragment;
import com.indeed.hazizz.Fragments.MainFragment;
import com.indeed.hazizz.Fragments.ViewTaskFragment;
import com.indeed.hazizz.R;
import com.indeed.hazizz.RequestSenderRunnable;
import com.indeed.hazizz.Transactor;

public class AuthActivity extends AppCompatActivity {

    public Toolbar toolbar;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_auth);

        Thread SenderThread = new Thread(new RequestSenderRunnable(this));
        SenderThread.start();

        toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

    //    getSupportActionBar().setDisplayHomeAsUpEnabled(true);

        Transactor.fragmentFirst(getSupportFragmentManager().beginTransaction());
    }

    @Override
    public void onBackPressed() {
        Fragment currentFrag = getSupportFragmentManager().findFragmentById(R.id.fragment_container);
        if(currentFrag instanceof FirstFragment) {}
        else{
            Transactor.fragmentFirst(getSupportFragmentManager().beginTransaction());
        }
    }
}
