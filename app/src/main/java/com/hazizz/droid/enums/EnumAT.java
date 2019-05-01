package com.hazizz.droid.enums;

public enum EnumAT {
    TASKS("tasks"),
    ANNOUNCEMENTS("announcements");

    private String value;

    EnumAT(String value){
        this.value = value;
    }

    public String getValue() {
        return value;
    }
    public String toString() {
        return value;
    }

}
