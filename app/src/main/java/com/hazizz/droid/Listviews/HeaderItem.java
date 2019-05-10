package com.hazizz.droid.listviews;

import lombok.Data;

@Data
public class HeaderItem extends Item{

    String date;

    public HeaderItem(String date){
        super();
        this.date = date;

        type = ItemTypeEnum.HEADER;

    }
}
