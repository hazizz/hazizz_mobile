package com.hazizz.droid.manager;

import android.content.Context;
import android.support.v4.content.res.ResourcesCompat;
import android.text.SpannableString;
import android.text.style.ForegroundColorSpan;
import android.view.MenuItem;

public class MenuManager {

    public static void changeItemTextColor(Context context, MenuItem menuItem, int colorRes){
        int color = ResourcesCompat.getColor(context.getResources(), colorRes, null);
        SpannableString spanString = new SpannableString(menuItem.getTitle().toString());
        spanString.setSpan(new ForegroundColorSpan(color), 0, spanString.length(), 0);
        menuItem.setTitle(spanString);
    }

}
