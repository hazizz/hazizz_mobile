package com.hazizz.droid.Converter;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.PorterDuff;
import android.graphics.PorterDuffXfermode;
import android.graphics.Rect;
import android.util.Base64;
import android.util.Log;

import com.google.common.hash.Hashing;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;
import com.hazizz.droid.Communication.POJO.Response.Pojo;
import com.hazizz.droid.Listviews.TheraGradesList.TheraGradesItem;
import com.hazizz.droid.R;

import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.lang.reflect.Type;
import java.nio.charset.Charset;
import java.util.List;
import java.util.TreeMap;

public class Converter {

    private Converter(){}

    public static Bitmap imageFromText(Context context, String encodedImage){
        if(encodedImage != null && !encodedImage.equals("")) {
            if (encodedImage.startsWith("data")) {
                encodedImage = encodedImage.split(",")[1];
            }
            byte[] decodedString = Base64.decode(encodedImage, Base64.DEFAULT);
            return BitmapFactory.decodeByteArray(decodedString, 0, decodedString.length);
        }else{
            return BitmapFactory.decodeResource(context.getResources(), R.mipmap.ic_launcher_round);
        }
    }

    public static Bitmap imageFromText(InputStream inputStream){
         return BitmapFactory.decodeStream(inputStream);

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

    /*
    public static <T> T toObject(String deserializedObject, Class<T> c){
        Gson gson = new GsonBuilder().serializeNulls().excludeFieldsWithoutExposeAnnotation().create();

   //   Type type = new TypeToken<>(){}.getType();
     //  Log.e("hey", "type: " + type.toString());
       // TreeMap<String, List<TheraGradesItem>> castedObject2 = gson.fromJson(deserializedObject, );
       // o = gson.fromJson(deserializedObject, o.getClass());
        T o = gson.fromJson(deserializedObject, c);
        return o;
    }
    */
}
