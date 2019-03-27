package com.hazizz.droid;

import android.content.Context;


public class TheraGradeColorer {

    public static int getColor(Context context, String weight){
        if(weight.equals("50")){
            return context.getResources().getColor(R.color.colorTheraGradeWeight50);
        }if(weight.equals("200")){
            return context.getResources().getColor(R.color.colorTheraGradeWeight200);
        }if(weight.equals("150")){
            return context.getResources().getColor(R.color.colorTheraGradeWeight150);
        }
        return context.getResources().getColor(R.color.colorTheraGradeWeight100);
    }

    public static int getColor(Context context, int weight){
        if(weight == 50){
            return context.getResources().getColor(R.color.colorTheraGradeWeight50);
        }if(weight == 200){
            return context.getResources().getColor(R.color.colorTheraGradeWeight200);
        }if(weight == 150){
            return context.getResources().getColor(R.color.colorTheraGradeWeight150);
        }
        return context.getResources().getColor(R.color.colorTheraGradeWeight100);
    }
}
