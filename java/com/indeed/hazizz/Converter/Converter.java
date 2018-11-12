package com.indeed.hazizz.Converter;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.util.Base64;

import com.google.common.hash.Hashing;

import java.io.ByteArrayOutputStream;
import java.nio.charset.Charset;

public abstract class Converter {

    public static Bitmap imageFromText(String encodedImage){
        byte[] decodedString = Base64.decode(encodedImage, Base64.DEFAULT);
        return BitmapFactory.decodeByteArray(decodedString, 0, decodedString.length);
    }

    public static String imageToText(Bitmap bitmap){
        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
        bitmap.compress(Bitmap.CompressFormat.JPEG, 100, outputStream);
        byte[] byteArray = outputStream.toByteArray();
        return Base64.encodeToString(byteArray, Base64.DEFAULT);
    }

    public static String hashString(String input) {
        return Hashing.sha256()
                .hashString(input, Charset.forName("UTF-8"))
                .toString();
    }

}
