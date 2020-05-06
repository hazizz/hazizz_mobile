enum GroupType{
  OPEN,
  CLOSED,
}






String valueOfGroupType(GroupType groupType){
  return groupType.toString().split(".")[1];
}