package com.indeed.hazizz;

import android.app.Activity;
import android.support.v7.app.AlertDialog;
import android.content.DialogInterface;
import android.util.Log;

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
                            dialog.cancel();;
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
