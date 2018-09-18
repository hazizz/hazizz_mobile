package com.indeed.hazizz.Communication;



import android.content.Context;
import android.support.v4.util.Pair;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

import com.android.volley.AuthFailureError;
import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonArrayRequest;
import com.android.volley.toolbox.JsonObjectRequest;
import com.android.volley.toolbox.Volley;
import com.indeed.hazizz.R;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

public class Rest {
  //  private RequestQueue mQueue;
    private static ArrayList<String> keys ;
    Map<String, String> answers = new HashMap<String, String>();

   // Response.Listener<JSONObject> listener
    public MyListener mylistener = new MyListener();
    public static MyErrorListener myErrorListener = new MyErrorListener();

    private Rest(){
       // mQueue = Volley.newRequestQueue(this);
      //  mQueue = Volley.newRequestQueue();
    }

    public static Map<String, Object> sendRequestGet(String url, ArrayList<String> k, RequestQueue mQueue){
        keys = k;
        final Map<String, Object> answers = new HashMap<>();
        JsonArrayRequest request = new JsonArrayRequest(Request.Method.GET, url, null,
                new Response.Listener<JSONArray>() {
                    @Override
                    public void onResponse(JSONArray response) {
                        try {

                            for(int i = 0; i < response.length(); i++) {
                                JSONObject anObject = response.getJSONObject(i);
                                Iterator<String> iter = anObject.keys();
                                while(iter.hasNext()){
                                    String key = iter.next();
                                    Object value = anObject.get(key);//anObject.getString(keys.get(i)); // TODO a string és az int value is jó kell hogy legyen
                                    answers.put(key, value);
                                }
                            }

                            //return new Pair<>("a", 0);
                        }catch (JSONException e){
                            e.printStackTrace();

                        }
                    }
                }, new Response.ErrorListener(){
            @Override
            public void onErrorResponse(VolleyError error) {
                error.printStackTrace();
            }
        });

        mQueue.add(request);
        return answers;
    }

    public static void sendRequestGet(String url, Context context){

        RequestQueue mQueue = Volley.newRequestQueue(context);
      //  Map<String, String> answers;
        JsonObjectRequest request = new JsonObjectRequest(Request.Method.GET, url, null,
                new Response.Listener<JSONObject>() {
                    @Override
                    public void onResponse(JSONObject response) {
                        try {
                            Log.e("hey", "0");
                            Iterator<String> iter = response.keys();
                            Log.e("hey", "0.1");
                            while(iter.hasNext()){
                                Log.e("hey", "0.2");
                                String key = iter.next();
                                Log.e("hey", "0.3");
                                Object value = response.get(key);//anObject.getString(keys.get(i)); // TODO a string és az int value is jó kell hogy legyen
                                Log.e("hey", value.toString());
                                //    answers.put(key, (String)value);
                            }
                            Log.e("hey", "1");
                        }catch (JSONException e){
                            Log.e("hey", "2.0");
                            e.printStackTrace();
                            Log.e("hey", "2.1");

                        }
                        Log.e("hey", "3.0");
                    }
                }, new Response.ErrorListener(){
            @Override
            public void onErrorResponse(VolleyError error) {
                Log.e("hey", "3.1");
                error.printStackTrace();
                Log.e("hey", "3.2");
            }
        });

        mQueue.add(request);
        Log.e("hey", "4");
     //   return answers;
    }

    public static void sendRequestPostTEST(Context context, JSONObject body){
        MyListener mylistener = new MyListener();

        RequestQueue mQueue = Volley.newRequestQueue(context);
      //  String answers1 = "";
        JsonObjectRequest request = new JsonObjectRequest(Request.Method.POST, "http://80.98.42.103:8080/register/",  body, mylistener, myErrorListener );

        mQueue.add(request);
    }

    public static void sendRequestPost(String url, Context context, JSONObject b){
        final JSONObject body = b;
        RequestQueue mQueue = Volley.newRequestQueue(context);
       // final Map<String, String> answers = new HashMap<>();
        JsonObjectRequest request = new JsonObjectRequest(Request.Method.POST, url, body,
                new Response.Listener<JSONObject>() {
                    @Override
                    public void onResponse(JSONObject response) { // this must be  an error json response
                        try {
                            String time = response.getString("time");
                            int errorCode = response.getInt("errorCode");
                            String title = response.getString("title");
                            String message = response.getString("message");
                        }catch (JSONException e){

                            e.printStackTrace();
                            Log.e("hey", "0.2");
                        }
                    }
                }, new Response.ErrorListener(){
                    @Override
                    public void onErrorResponse(VolleyError error) {
                        Log.e("hey", "1.0");
                        error.printStackTrace();
                        error.getMessage();
                        Log.e("hey", error.toString());
                        Log.e("hey", "" +error.networkResponse.statusCode);
                        Log.e("hey", "1.1");
                      //  Log.e("hey", body.get("username"));

                    }
                }){
            /*   @Override
                protected Map<String, String> getParams(){
                    Log.e("hey", "2");
                    return bodym;
                } */
                @Override
                public Map getHeaders() throws AuthFailureError {
                    HashMap headers = new HashMap();
                    headers.put("Content-Type", "application/json");
                    Log.e("hey", "5");
                    return headers;
                }


            };
        mQueue.add(request);
        Log.e("hey", "3");
       // return answers;
    }

    public static JSONArray sendRequestPost2(Request requestMethod, String url, RequestQueue mQueue){

        return null;
    }

}
