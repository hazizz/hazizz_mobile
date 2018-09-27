package com.indeed.hazizz.Communication.POJO.Response;

import java.util.List;

import lombok.Data;

@Data
public class POJOsubjects {

    List<POJOsubject> subjects;

    POJOsubjects(List<POJOsubject> subjects){
        this.subjects = subjects;
    }

}
