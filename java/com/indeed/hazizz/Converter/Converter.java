package com.indeed.hazizz.Converter;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.util.Base64;

public abstract class Converter {

    public static Bitmap imageFromText(String encodedImage){
        byte[] decodedString = Base64.decode(encodedImage, Base64.DEFAULT);
        return BitmapFactory.decodeByteArray(decodedString, 0, decodedString.length);
    }
}
