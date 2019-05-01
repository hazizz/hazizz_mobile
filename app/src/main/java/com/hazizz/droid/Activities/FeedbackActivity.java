package com.hazizz.droid.activities;

import android.app.Activity;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import com.hazizz.droid.other.AndroidThings;
import com.hazizz.droid.other.AppInfo;

import com.hazizz.droid.Communication.requests.Feedback;
import com.hazizz.droid.Communication.responsePojos.CustomResponseHandler;
import com.hazizz.droid.Communication.responsePojos.PojoError;
import com.hazizz.droid.navigation.Transactor;
import com.hazizz.droid.Communication.MiddleMan;
import com.hazizz.droid.R;

public class FeedbackActivity extends AppCompatActivity {

    EditText editText_feedback;
    Button button_feedback;
    TextView textView_error;

    CustomResponseHandler rh = new CustomResponseHandler() {
        @Override
        public void onErrorResponse(PojoError error) {
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

        if(AppInfo.isDarkMode(getBaseContext())){
            setTheme(R.style.AppTheme_Dark);
        }else{
            setTheme(R.style.AppTheme_Light);
        }

        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_feedback);
        setTitle(R.string.title_activity_feedback);
        Activity act = this;

        textView_error = findViewById(R.id.textView_error_currentPassword);
        editText_feedback = findViewById(R.id.editText_feedback);
        button_feedback = findViewById(R.id.button_feedback);
        button_feedback.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                // Send feedback
                MiddleMan.newRequest(new Feedback(act, rh,"android", AndroidThings.getAppVersion(),
                        editText_feedback.getText().toString()));
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
    }
    @Override
    public void onBackPressed() {
        goBackToFrag();
    }

    private void goBackToFrag(){
        Transactor.activityMain(this);
        finish();
    }
}
