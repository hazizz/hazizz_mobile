package com.indeed.hazizz;

import org.joda.time.LocalDate;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;

public abstract class D8 {
    static LocalDate today = LocalDate.now();
    static LocalDate tomorrow = today.plusDays(1);
    DateTimeFormatter dtf = DateTimeFormat.forPattern("yyyy-MM-dd");

    public static String getDateTomorrow(){
        return tomorrow.toString();
    }
}
