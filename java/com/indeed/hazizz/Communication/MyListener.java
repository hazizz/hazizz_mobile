package com.indeed.hazizz.Communication;

import android.util.Log;

import com.android.volley.Response;

import org.json.JSONException;
import org.json.JSONObject;
//import com.android.volley.Response.Listener;

 //Response.Listener<JSONObject> listener
public class MyListener implements Response.Listener<JSONObject> {
    MyListener(){

    }

    @Override
    public void onResponse(JSONObject response) {
        try {
            Log.e("hey", "111");
            String time = response.getString("time");
            int errorCode = response.getInt("errorCode");
            String title = response.getString("title");
            String message = response.getString("message");
            Log.e("hey", time);
            Log.e("hey", "" + errorCode);
            Log.e("hey", title);
            Log.e("hey", message);
        }catch (JSONException e){

            e.printStackTrace();
            Log.e("hey", "0.2");
        }

    }
}
