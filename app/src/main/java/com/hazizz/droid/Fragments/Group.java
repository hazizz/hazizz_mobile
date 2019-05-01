package com.hazizz.droid.fragments;

import lombok.Data;

@Data
public class Group {
    public Group(String name) {
        this.name = name;
    }

    private String name;


}
