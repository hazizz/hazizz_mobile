package com.indeed.hazizz.Activities;

import android.os.Bundle;
import android.support.design.widget.FloatingActionButton;
import android.support.design.widget.Snackbar;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

import com.indeed.hazizz.AndroidThings;
import com.indeed.hazizz.Communication.POJO.Response.CustomResponseHandler;
import com.indeed.hazizz.Communication.POJO.Response.POJOerror;
import com.indeed.hazizz.R;

import java.util.HashMap;

import okhttp3.ResponseBody;
import retrofit2.Call;

public class FeedbackActivity extends AppCompatActivity {

    TextView textView_feedback;
    Button button_feedback;

    CustomResponseHandler rh = new CustomResponseHandler() {
        @Override
        public void onResponse(HashMap<String, Object> response) {

        }

        @Override
        public void onPOJOResponse(Object response) {

        }

        @Override
        public void onFailure(Call<ResponseBody> call, Throwable t) {

        }

        @Override
        public void onErrorResponse(POJOerror error) {

        }

        @Override
        public void onEmptyResponse() {

        }

        @Override
        public void onSuccessfulResponse() {

        }

        @Override
        public void onNoConnection() {

        }
    };

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        textView_feedback = findViewById(R.id.textView_feedback);
        button_feedback = findViewById(R.id.button_feedback);
        button_feedback.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                // Send feedback
            }
        });

        setContentView(R.layout.activity_feedback);
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        FloatingActionButton fab = (FloatingActionButton) findViewById(R.id.fab);
        fab.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Snackbar.make(view, "Replace with your own action", Snackbar.LENGTH_LONG)
                        .setAction("Action", null).show();
            }
        });
    }

}
