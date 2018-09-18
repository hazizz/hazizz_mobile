package com.indeed.hazizz.Communication;

import android.util.Log;

import com.android.volley.Response;
import com.android.volley.VolleyError;

import org.json.JSONObject;

public class MyErrorListener implements Response.ErrorListener {

    @Override
    public void onErrorResponse(VolleyError error) {
        Log.e("hey", "errorResponse");
        Log.e("hey", error.toString());
        Log.e("hey", "statusCode: " +error.networkResponse.statusCode);
    }
}
