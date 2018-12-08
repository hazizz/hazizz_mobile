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

    public static String textToBitmap(String input) {
        return Hashing.sha256()
                .hashString(input, Charset.forName("UTF-8"))
                .toString();
    }
}
