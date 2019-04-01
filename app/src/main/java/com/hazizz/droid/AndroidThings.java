package com.hazizz.droid;

import android.content.Context;
import android.view.View;
import android.view.inputmethod.InputMethodManager;


public class AndroidThings {

    public static void closeKeyboard(Context c, View view){
        InputMethodManager imm = (InputMethodManager)c.getSystemService(Context.INPUT_METHOD_SERVICE);
        if(imm != null && view != null){
            imm.hideSoftInputFromWindow(view.getWindowToken(), 0);
        }
    }
    public static void openKeyboard(Context c, View view){
        InputMethodManager imm = (InputMethodManager)c.getSystemService(Context.INPUT_METHOD_SERVICE);
        if(imm != null && view != null){
            imm.showSoftInput(view, InputMethodManager.SHOW_IMPLICIT);
        }
    }

    public static String getAppVersion(){ // this.getCurrentFocus()
        return BuildConfig.VERSION_NAME;
    }

}
