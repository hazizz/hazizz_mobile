package com.indeed.hazizz;

public enum FragTag {
    main ("mainFrag"),
    chat ("chatFrag"),
    createTask ("createTaskFrag"),
    groupMain ("groupMainFrag"),
    groups ("groupsFrag"),
    viewTask ("viewTaskFrag");

    private String text;

    FragTag(String text) {
        this.text = text;
    }

    public String toString(){
        return text;
    }
}
