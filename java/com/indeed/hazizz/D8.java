package com.indeed.hazizz;

import org.joda.time.LocalDate;
import org.joda.time.MonthDay;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;

public abstract class D8 {
    static LocalDate today = LocalDate.now();

    static LocalDate tomorrow = today.plusDays(1);
    DateTimeFormatter dtf = DateTimeFormat.forPattern("yyyy-MM-dd");

    public static String getDateTomorrow(){
        return tomorrow.toString();
    }
    public static String getDay(){
        return Integer.toString(LocalDate.now().getDayOfMonth());
    }
    public static String getMonth(){
     //   return LocalDate.now().monthOfYear().toString();
        return Integer.toString(LocalDate.now().getMonthOfYear() + 1);

    }
    public static String getYear(){
        return Integer.toString(LocalDate.now().getYear());
    }

    public static String getTimeInMillis (){
        return Integer.toString(LocalDate.now().getYear());
    }

}
