package com.hazizz.droid.Listviews.TheraGradesList;

import lombok.Data;

@Data
public class TheraGradesItem {

    String Date;
    String Weight;
    String Theme;
    int NumberValue;

    public TheraGradesItem( String Date,  String Weight,  String Theme,  int NumberValue){
        this.Date = Date;
        this.Weight = Weight;
        this.Theme = Theme;
        this.NumberValue = NumberValue;
    }
}

