package com.indeed.hazizz.Fragments;

import lombok.Data;

@Data
public class Group {
    public Group(String name) {
        this.name = name;
    }

    private String name;


}
