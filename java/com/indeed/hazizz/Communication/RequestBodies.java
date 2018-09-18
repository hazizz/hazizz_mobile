package com.indeed.hazizz.Communication;

public class RequestBodies {

    public static class Register{
        private String username;
        private String password;
        private String emailAddress;


        public Register(String username, String password, String emailAddress){
            this.username = username;
            this.password = password;
            this.emailAddress = emailAddress;
        }
        public String getPassword() {
            return username;
        }
        public String getEmailAddress() {
            return username;
        }

        public String getUsername() {
            return username;
        }
    }

    public class Auth{
        private String username;
        private String password;

        public Auth(String username, String password){
            this.username = username;
            this.password = password;
        }
    }
}
