package com.hazizz.droid.listviews;

public enum ItemTypeEnum {

    BASIC(0),
    HEADER(1),
    TASK(2);

    private int value;

    ItemTypeEnum(int value){
        this.value = value;
    }

    public int getValue() {
        return value;
    }

    public boolean equals(ItemTypeEnum otherItemType){
        return this == otherItemType;
    }

}
