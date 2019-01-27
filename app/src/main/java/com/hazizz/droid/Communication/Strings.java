package com.hazizz.droid.Communication;

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

        GROUPTYPE_OPEN("OPEN"),
        GROUPTYPE_INVITE_ONLY("INVITE_ONLY"),
        GROUPTYPE_PASSWORD("PASSWORD"),

        PASSWORD("password"),

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

    public enum Rank {
        OWNER(3),
        MODERATOR(2),
        USER(1),
        NULL(0);

        private int value;

        Rank(int value){
            this.value = value;
        }

        public int getValue() {
            return value;
        }
    }


}
