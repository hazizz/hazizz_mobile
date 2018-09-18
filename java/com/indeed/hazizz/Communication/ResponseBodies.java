package com.indeed.hazizz.Communication;

public class ResponseBodies{

    public static class Error{
        private static String time;
        private static int errorCode;
        private static String title;
        private static String message;

        public Error(String time, int errorCode, String title, String message){
            this.time = time;
            this.errorCode = errorCode;
            this.title = title;
            this.message = message;
        }

        public static String getTime(){
            return time;
        }
        public static int getErrorCode(){ return errorCode; }
        public static String getTitle(){
            return title;
        }
        public static String getMessage(){
            return message;
        }

    }

    public class Auth{
        private String token;

        private Auth(String token){
            this.token = token;
        }

        public String getToken(){
            return token;
        }
    }

    public int getErrorCode(){
        return 0;
    }
    public void a(){
        int b = 0;
    }
}

