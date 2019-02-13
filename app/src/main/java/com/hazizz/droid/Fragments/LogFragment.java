package com.hazizz.droid.Fragments;

import android.graphics.Bitmap;

import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.text.method.ScrollingMovementMethod;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.TextView;

import com.hazizz.droid.Activities.MainActivity;
import com.hazizz.droid.Communication.MiddleMan;
import com.hazizz.droid.Communication.POJO.Response.CustomResponseHandler;
import com.hazizz.droid.Communication.POJO.Response.POJOgroup;
import com.hazizz.droid.Communication.Requests.GetLog;
import com.hazizz.droid.R;
import java.util.List;

public class LogFragment  extends Fragment {

    public List<POJOgroup> groups;
    private View v;

    private TextView textView_log;
    private static final int logSize = 400;

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.fragment_log, container, false);
        ((MainActivity) getActivity()).onFragmentCreated();

        getActivity().setTitle("Log");

        textView_log = v.findViewById(R.id.textView_log);
        textView_log.setMovementMethod(new ScrollingMovementMethod());
        MiddleMan.newRequest(new GetLog(getActivity(), new CustomResponseHandler() {
            @Override
            public void onPOJOResponse(Object response) {
                String log = (String)response;
                textView_log.setText(log);
            }
        }, logSize));

        return v;
    }

}
