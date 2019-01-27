package com.hazizz.droid.Listviews.GroupList;

import lombok.Data;

@Data
public class GroupItem {

    int pic;
    String groupName;
    int groupId;

    public GroupItem(int pic, String groupName, int groupId){
        this.pic = pic;
        this.groupName = groupName;
        this.groupId = groupId;
    }
}
