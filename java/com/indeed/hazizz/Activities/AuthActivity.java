package com.indeed.hazizz.Activities;

import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import com.indeed.hazizz.R;
import com.indeed.hazizz.RequestSenderRunnable;
import com.indeed.hazizz.Transactor;

public class AuthActivity extends AppCompatActivity {

    public Toolbar toolbar;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_auth);

        toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

    //    getSupportActionBar().setDisplayHomeAsUpEnabled(true);

        Thread SenderThread = new Thread(new RequestSenderRunnable(this));
        SenderThread.start();

        Transactor.fragmentFirst(getSupportFragmentManager().beginTransaction());
    }
}
