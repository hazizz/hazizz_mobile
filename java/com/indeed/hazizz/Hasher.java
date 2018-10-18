package com.indeed.hazizz;

import android.os.Build;
import android.util.Log;

import com.google.common.hash.Hashing;

import java.io.UnsupportedEncodingException;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Base64;

public abstract class Hasher {

    public static String hashString(String input) {
      /*  try {
            Log.e("hey", "hashbyteInput: " + input);
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(input.getBytes(Charset.forName("UTF-8")));
            Log.e("hey", "hashbyte: " + hash);
            //  String encoded = Base64.getEncoder().encodeToString(hash);
            String encoded1 = new String(hash, Charset.forName("UTF-8"));
            Log.e("hey", "hashbyteToString: " + encoded1);
            return encoded1;
        }catch (NoSuchAlgorithmException e) {
            return "nope";
        } */

     /*   try{
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            md.update(input.getBytes());
            return bytesToHex(md.digest());
        } catch(Exception ex){
            throw new RuntimeException(ex);
        } */
     /*   StringBuffer sb = new StringBuffer();
        try{
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            md.update(data.getBytes());
            byte byteData[] = md.digest();

            for (int i = 0; i < byteData.length; i++) {
                sb.append(Integer.toString((byteData[i] & 0xff) + 0x100, 16).substring(1));
            }
        } catch(Exception e){
            e.printStackTrace();
        }
        Log.e("hey", "hashbyte: " + sb.toString());
        return sb.toString();
    } */

     return Hashing.sha256()
                .hashString(input, Charset.forName("UTF-8"))
                .toString();
    }
}
