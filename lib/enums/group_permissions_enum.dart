enum GroupPermissionsEnum{
  OWNER,
  MODERATOR,
  USER,
  NULL
}

GroupPermissionsEnum toGroupPermissionsEnum(String str_permission){
  switch(str_permission){
    case "USER":
      return GroupPermissionsEnum.USER;
    case "MODERATOR":
      return GroupPermissionsEnum.MODERATOR;
    case "OWNER":
      return GroupPermissionsEnum.OWNER;
    case "NULL":
    default:
      return GroupPermissionsEnum.USER;
  }
}


String groupPermissionsEnumToString(GroupPermissionsEnum groupPermissionsEnum){
  switch(groupPermissionsEnum){
    case GroupPermissionsEnum.USER:
      return "USER";
    case GroupPermissionsEnum.MODERATOR:
      return "MODERATOR";
    case GroupPermissionsEnum.OWNER:
      return "OWNER";
    case GroupPermissionsEnum.NULL:
    default:
      return "NULL";
  }
}