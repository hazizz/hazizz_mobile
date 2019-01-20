package com.indeed.hazizz.Activities;

import android.app.Activity;
import android.os.Bundle;
import android.support.design.widget.FloatingActionButton;
import android.support.design.widget.Snackbar;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import com.indeed.hazizz.AndroidThings;
import com.indeed.hazizz.Communication.MiddleMan;
import com.indeed.hazizz.Communication.POJO.Response.CustomResponseHandler;
import com.indeed.hazizz.Communication.POJO.Response.POJOerror;
import com.indeed.hazizz.Manager;
import com.indeed.hazizz.R;
import com.indeed.hazizz.Transactor;

import java.util.HashMap;

public class FeedbackActivity extends AppCompatActivity {

    EditText editText_feedback;
    Button button_feedback;
    TextView textView_error;

    CustomResponseHandler rh = new CustomResponseHandler() {
        @Override
        public void onErrorResponse(POJOerror error) {
            textView_error.setText(R.string.error);
            button_feedback.setEnabled(true);
        }
        @Override
        public void onSuccessfulResponse() {
            Toast.makeText(getApplicationContext(), getString(R.string.toast_feedback_thanks),
                    Toast.LENGTH_LONG).show();
            goBackToFrag();
        }
        @Override
        public void onNoConnection() {
            textView_error.setText(R.string.info_noInternetAccess);
            button_feedback.setEnabled(true);
        }
    };

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_feedback);

        Activity act = this;

        textView_error = findViewById(R.id.textView_error_currentPassword);
        editText_feedback = findViewById(R.id.editText_feedback);
        button_feedback = findViewById(R.id.button_feedback);
        button_feedback.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                // Send feedback
                HashMap<String, String> data = new HashMap<>();
                HashMap<String, Object> body = new HashMap<>();
                body.put("platform", "android");
                body.put("version", AndroidThings.getAppVersion());
                body.put("message", editText_feedback.getText().toString());

                data.put("lastCall", Manager.CrashManager.getLastCall().toString());
                data.put("time", Manager.CrashManager.getError().getTime());
                data.put("errorCode", Integer.toString(Manager.CrashManager.getError().getErrorCode()));
                data.put("title", Manager.CrashManager.getError().getTitle());
                data.put("message", Manager.CrashManager.getError().getMessage());

                body.put("data", data);

                MiddleMan.newRequest(act, "feedback", body, rh, null);
                button_feedback.setEnabled(false);
            }
        });
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
        toolbar.setNavigationIcon(R.drawable.ic_arrow_back);
        toolbar.setNavigationOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                // back button pressed
                goBackToFrag();
            }
        });
        FloatingActionButton fab = (FloatingActionButton) findViewById(R.id.fab);
        fab.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Snackbar.make(view, "Replace with your own action", Snackbar.LENGTH_LONG)
                        .setAction("Action", null).show();
            }
        });
    }
    @Override
    public void onBackPressed() {
        goBackToFrag();
    }

    private void goBackToFrag(){
        Transactor.activityMain(this);
    }
}
