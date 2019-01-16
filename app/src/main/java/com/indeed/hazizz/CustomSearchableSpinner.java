package com.indeed.hazizz;

import android.content.Context;
import android.util.AttributeSet;
import android.view.MotionEvent;
import android.view.View;

import com.toptoche.searchablespinnerlibrary.SearchableSpinner;

public class CustomSearchableSpinner extends SearchableSpinner {

    public static boolean isSpinnerDialogOpen = false;

    public CustomSearchableSpinner(Context context) {
        super(context);
    }

    public CustomSearchableSpinner(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    public CustomSearchableSpinner(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
    }

    private static final long MIN_DELAY_MS = 500;

    private long mLastClickTime;


    @Override
    public boolean onTouch(View v, MotionEvent event) {
        if (event.getAction() == MotionEvent.ACTION_UP) {

            long lastClickTime = mLastClickTime;
            long now = System.currentTimeMillis();
            mLastClickTime = now;
            if (now - lastClickTime < MIN_DELAY_MS) {
                // Too fast: ignore
                return true;
            } else {
                // Register the click
                return super.onTouch(v, event);
            }
        }
        return true;
    }
}