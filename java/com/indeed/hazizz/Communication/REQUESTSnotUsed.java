package com.indeed.hazizz.Communication;

//import static android.provider.ContactsContract.CommonDataKinds.Website.URL;

public enum REQUESTSnotUsed{
    BASEURL ("http://80.98.42.103:8080/");

    String value;
    REQUESTSnotUsed(String value){
        this.value = value;
    }

    public String getBaseUrl(){
        return value;
    }

    public enum USERS{
        PATH ("users/");

        String value;
        USERS(String value){
            this.value = value;
        }

        public String value(){
            return value;
        }

        private enum RESPONDS{
            TOKEN ("token");

            String token;
            RESPONDS(String TOKEN){
                this.token = TOKEN;
            }

            public String value(){
                return token;
            }
        }
    }

    public enum REGISTER{
        PATH ("register/");

        String key;
        REGISTER(String key){
            this.key = key;
        }

        public String value(){
            return key;
        }
    }

    public enum AUTH{
        URL ("auth/");

        String key;
        AUTH(String key){
            this.key = key;
        }

        public String value(){
            return key;
        }

        private enum RESPONDS{
            TOKEN ("token");

            String token;
            RESPONDS(String TOKEN){
                this.token = TOKEN;
            }
            public String value(){
                return token;
            }
        }
    }

    public enum ERRORS{
        TIME ("time"),
        ERRORCODE ("errorCode"), // value is int
        TITLE ("title"),
        MESSAGE ("message");

        String key;

        ERRORS(String key){
            this.key = key;
        }

        public String value(){
            return key;
        }
    }
}
