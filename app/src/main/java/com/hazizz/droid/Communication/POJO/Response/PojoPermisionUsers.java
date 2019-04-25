package com.hazizz.droid.Communication.POJO.Response;

import java.util.ArrayList;

import lombok.Data;

@Data
public class PojoPermisionUsers implements Pojo {

    private ArrayList<POJOuser> OWNER;

    private ArrayList<POJOuser> MODERATOR;

    private ArrayList<POJOuser> USER;

    private ArrayList<POJOuser> NULL;


    public PojoPermisionUsers(ArrayList<POJOuser> OWNER, ArrayList<POJOuser> MODERATOR,
                              ArrayList<POJOuser> USER, ArrayList<POJOuser> NULL){

        this.OWNER = OWNER == null ? new ArrayList<POJOuser>() : OWNER;
        if(MODERATOR == null){
            this.MODERATOR = new ArrayList<>();
        }else {
            this.MODERATOR = MODERATOR;
        }if(USER == null){
            this.USER = new ArrayList<>();
        }else {
            this.USER = USER;
        }
        if(NULL == null){
            this.NULL = new ArrayList<>();
        }else {
            this.NULL = NULL;
        }
    }


}
