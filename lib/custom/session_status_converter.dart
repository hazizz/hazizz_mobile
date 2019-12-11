int getSessionStatusRank(String sessionStatus){
  switch(sessionStatus){
    case "ACTIVE":
      return 0;
    case "AUTHENTICATION_REQUIRED":
      return 1;
    case "ERROR":
      return 2;
  }
}