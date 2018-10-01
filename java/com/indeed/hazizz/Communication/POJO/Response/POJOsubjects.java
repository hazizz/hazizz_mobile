package com.indeed.hazizz.Communication.POJO.Response;

import java.util.List;

import lombok.Data;

@Data
public class POJOsubjects {

    private final List<POJOsubject> subjects;

    public POJOsubjects(List<POJOsubject> subjects){
        this.subjects = subjects;
    }

}
