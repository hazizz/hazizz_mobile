package com.indeed.hazizz.Communication;

import com.indeed.hazizz.Communication.POJO.Response.ResponseInterface;

import org.json.JSONObject;

public interface RequestInterface1<T> {
    public void setupCall();
    public T getResponse();
    public void makeCall();

}
