package com.indeed.hazizz.Converter;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.PorterDuff;
import android.graphics.PorterDuffXfermode;
import android.graphics.Rect;
import android.util.Base64;

import com.google.common.hash.Hashing;

import java.io.ByteArrayOutputStream;
import java.nio.charset.Charset;

public abstract class Converter {

    private Converter(){}

    public static Bitmap imageFromText(String encodedImage){
        if(encodedImage != null && !encodedImage.equals("")) {
            if (encodedImage.startsWith("data")) {
                encodedImage = encodedImage.split(",")[1];
            }
            byte[] decodedString = Base64.decode(encodedImage, Base64.DEFAULT);
            return BitmapFactory.decodeByteArray(decodedString, 0, decodedString.length);
        }else{return null;}
    }

    public static String imageToText(Bitmap bitmap){
        if(bitmap != null) {
            ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
            bitmap.compress(Bitmap.CompressFormat.JPEG, 100, outputStream);
            byte[] byteArray = outputStream.toByteArray();
            return Base64.encodeToString(byteArray, Base64.DEFAULT);
        }else{return null;}
    }

    public static String hashString(String input) {
        if (input != null) {
            if (!input.equals("")) {
                return Hashing.sha256()
                        .hashString(input, Charset.forName("UTF-8"))
                        .toString();
            }
        }
        return null;
    }

    public static Bitmap scaleBitmapToRegular(Bitmap bitmap){
        if(bitmap != null) {
            return Bitmap.createScaledBitmap(bitmap, 90, 90, false);
        }else{return null;}
    }

    public static Bitmap getCroppedBitmap(Bitmap bitmap) {
        if(bitmap != null) {
            Bitmap output = Bitmap.createBitmap(bitmap.getWidth(),
                    bitmap.getHeight(), Bitmap.Config.ARGB_8888);
            Canvas canvas = new Canvas(output);

            final int color = 0xff424242;
            final Paint paint = new Paint();
            final Rect rect = new Rect(0, 0, bitmap.getWidth(), bitmap.getHeight());

            paint.setAntiAlias(true);
            canvas.drawARGB(0, 0, 0, 0);
            paint.setColor(color);
            canvas.drawCircle(bitmap.getWidth() / 2, bitmap.getHeight() / 2,
                    bitmap.getWidth() / 2, paint);
            paint.setXfermode(new PorterDuffXfermode(PorterDuff.Mode.SRC_IN));
            canvas.drawBitmap(bitmap, rect, rect, paint);
            return output;
        }else{
            return null;
        }
    }

}
