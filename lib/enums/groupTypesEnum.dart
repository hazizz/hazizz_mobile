enum GroupType{
  OPEN,
  INVITE_ONLY,
  PASSWORD,
}






String valueOfGroupType(GroupType groupType){
  return groupType.toString().split(".")[1];
}