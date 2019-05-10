package com.hazizz.droid.listviews;

public class Item {

    public Item(){

    }

    public Item(Class child){

    }

    public static ItemTypeEnum type = ItemTypeEnum.BASIC;

    public ItemTypeEnum getType(){
        return type;
    }

}
