package com.hazizz.droid.communication.responsePojos;

import java.util.ArrayList;

import lombok.Data;

@Data
public class PojoPermisionUsers implements Pojo {

    private ArrayList<PojoUser> OWNER;

    private ArrayList<PojoUser> MODERATOR;

    private ArrayList<PojoUser> USER;

    private ArrayList<PojoUser> NULL;


    public PojoPermisionUsers(ArrayList<PojoUser> OWNER, ArrayList<PojoUser> MODERATOR,
                              ArrayList<PojoUser> USER, ArrayList<PojoUser> NULL){

        this.OWNER = OWNER == null ? new ArrayList<PojoUser>() : OWNER;
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
