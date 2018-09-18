package com.indeed.hazizz.Communication.POJO.Requests;

//import com.indeed.hazizz.Communication.POJO.ParentPOJO;

public class Register implements RequestInterface {

    private String username;
    private String password;
    private String emailAddress;

    public Register(String username, String password, String emailAddress){
        this.username = username;
        this.password = password;
        this.emailAddress = emailAddress;
    }

    public String getUsername(){
        return username;
    }
    public String getPassword(){
        return password;
    }
    public String getEmailAddress(){
        return emailAddress;
    }

}
