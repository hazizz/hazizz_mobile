package com.indeed.hazizz.Communication;

public abstract class Strings {

    public enum Path {
        TASKS ("tasks"),
        ANNOUNCEMENTS("announcements"),
        GROUPS("groups"),
        SUBJECTS("subjects"),


        ID ("id"),
        USERID("userId"),
        TASKID ("taskId"),
        ANNOUNCEMENTID("announcementId"),
        SUBJECTID("subjectId"),
        GROUPID("groupId"),
        COMMENTID("commentId"),

        WHERENAME("whereName"),
        BYNAME("byName"),
        BYID("byId"),
        WHEREID("whereId"),


        ;

        private String value;

        Path(String value){
            this.value = value;
        }

        @Override
        public String toString() {
            return value;
        }
    }

    /*
    public enum Id {
        TASKID ("taskId"),
        ANNOUNCEMENTID("announcementId"),
        SUBJECTID("subjectId"),
        GROUPID("groupId")
        ;

        private String text;

        Id(String text){
            this.text = text;
        }
    } */
}
