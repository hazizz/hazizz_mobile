package com.hazizz.droid.Communication.Requests.RequestType.Thera.ThReturnGrades;

import lombok.Data;

@Data
public class PojoGrade {

    String Date;
    String Weight;
    String Theme;
    int NumberValue;

    public PojoGrade( String Date,  String Weight,  String Theme,  int NumberValue){
        this.Date = Date;
        this.Weight = Weight;
        this.Theme = Theme;
        this.NumberValue = NumberValue;
    }
}
