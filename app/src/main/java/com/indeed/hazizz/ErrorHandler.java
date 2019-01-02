package com.indeed.hazizz;

import android.app.Activity;
import android.support.v7.app.AlertDialog;
import android.content.DialogInterface;
import android.util.Log;

import com.indeed.hazizz.Communication.MiddleMan;

import java.util.HashMap;

public abstract class ErrorHandler {

    public static void unExpectedResponseDialog(Activity act){




        try {
            AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(act);
            alertDialogBuilder.setTitle("Hiba");
            alertDialogBuilder
                    .setMessage("Nem megszokott válasz a szervertől")
                    .setCancelable(false)
                    .setPositiveButton("Hiba Jelentés", (dialog, id) -> {
                        Transactor.feedbackActivity(act);
                        dialog.cancel();
                    })
                    .setNegativeButton("Vissza", new DialogInterface.OnClickListener() {
                        public void onClick(DialogInterface dialog, int id) {

                            HashMap<String, String> data = new HashMap<>();
                            HashMap<String, Object> body = new HashMap<>();
                            body.put("platform", "android");
                            body.put("version", AndroidThings.getAppVersion());
                            body.put("message", "no message");

                            data.put("lastCall", Manager.CrashManager.getLastCall().toString());
                            data.put("time", Manager.CrashManager.getError().getTime());
                            data.put("errorCode", Integer.toString(Manager.CrashManager.getError().getErrorCode()));
                            data.put("title", Manager.CrashManager.getError().getTitle());
                            data.put("message", Manager.CrashManager.getError().getMessage());

                            body.put("data", data);

                            MiddleMan.newRequest(act, "feedback", body, null, null);

                            Manager.CrashManager.reset();
                            dialog.cancel();
                        }
                    });
            AlertDialog alertDialog = alertDialogBuilder.create();
            alertDialog.show();
        }
        catch (Exception e){
            e.printStackTrace();
        }
    }
}
