package com.hazizz.droid.Fragments.ThéraFrags.Setup;

import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import com.hazizz.droid.Fragments.ParentFragment.ParentFragment;
import com.hazizz.droid.R;
import com.hazizz.droid.SharedPrefs;

public class TheraLoadingFragment extends ParentFragment {
    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.fragment_th_loading, container, false);
        Log.e("hey", "TheraLoadingFragment fragment created");

        fragmentSetup(R.string.loading);


        // check for session state
        SharedPrefs.ThSessionManager.getSessionId(getContext());



        return v;
    }
}

