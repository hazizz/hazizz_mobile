package com.hazizz.droid.activities;

import android.support.v4.app.Fragment;
import android.support.v7.app.AppCompatActivity;

import com.hazizz.droid.listeners.OnBackPressedListener;
import com.hazizz.droid.navigation.Transactor;

public class BaseActivity extends AppCompatActivity {

    protected Fragment currentFrag;
    protected OnBackPressedListener currentBackPressedListener;

    public void onFragmentAdded(){
        currentFrag = Transactor.getCurrentFragment(getSupportFragmentManager(), false);
    }

    public void setOnBackPressedListener(OnBackPressedListener listener){
        currentBackPressedListener = listener;
    }

    public void removeOnBackPressedListener(){
        currentBackPressedListener = null;
    }
}
