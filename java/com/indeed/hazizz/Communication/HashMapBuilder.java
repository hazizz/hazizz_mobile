package com.indeed.hazizz.Communication;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;

public class HashMapBuilder {

    private HashMap<String, Object> theHm;

   // RequestBodies.Register user = new RequestBodies.Register(username, password, email);

    public HashMapBuilder(HashMap<String, Object> theHm){
        this.theHm = theHm;
    }

    public Object getValue(Object key){
        return theHm.get(key);
    }

    public void addField(String key, Object value){
        theHm.put(key, value);
    }

    public HashMap<String, Object> getMap(){
        return theHm;
    }
}
