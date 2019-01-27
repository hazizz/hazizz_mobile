package com.hazizz.droid;

import android.content.Context;
import android.view.View;
import android.view.inputmethod.InputMethodManager;

import com.hazizz.droid.BuildConfig;

public interface AndroidThings {

    public static void closeKeyboard(Context c, View view){
        InputMethodManager imm = (InputMethodManager)c.getSystemService(Context.INPUT_METHOD_SERVICE);
        if(imm != null){
            imm.hideSoftInputFromWindow(view.getWindowToken(), 0);
        }
    }

    public static String getAppVersion(){ // this.getCurrentFocus()
        return BuildConfig.VERSION_NAME;
    }

}
