package com.hazizz.droid;

import android.app.Activity;
import android.content.DialogInterface;
import android.support.v7.app.AlertDialog;

import com.hazizz.droid.Communication.MiddleMan;
import com.hazizz.droid.Communication.Requests.Feedback;

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
                            data.put("lastCall", Manager.CrashManager.getLastCall().toString());
                            data.put("time", Manager.CrashManager.getError().getTime());
                            data.put("errorCode", Integer.toString(Manager.CrashManager.getError().getErrorCode()));
                            data.put("title", Manager.CrashManager.getError().getTitle());
                            data.put("message", Manager.CrashManager.getError().getMessage());

                            MiddleMan.newRequest(new Feedback(act, null, "android",AndroidThings.getAppVersion(),
                                    "no message", data));

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
