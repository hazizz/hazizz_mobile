enum GroupTypeEnum{
  OPEN,
  CLOSED,
}






String valueOfGroupType(GroupTypeEnum groupType){
  return groupType.toString().split(".")[1];
}