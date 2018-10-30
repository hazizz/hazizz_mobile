package com.indeed.hazizz;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.util.Log;

public abstract class ErrorHandler {

    public static void unExpectedResponseDialog(Context context){
        AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(context);

        alertDialogBuilder.setTitle("Hiba");

        alertDialogBuilder
                .setMessage("Nem megszokott válasz a szervertől")
                .setCancelable(false)
                .setPositiveButton("Hiba Jelentés",new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog,int id) {
                        // if this button is clicked, close
                        // current activity
                        dialog.cancel();
                        Log.e("hey", "hiba jelentés");
                    }
                })
                .setNegativeButton("Vissza",new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog,int id) {
                        // if this button is clicked, just close
                        // the dialog box and do nothing
                        dialog.cancel();
                        Log.e("hey", "Vissza");
                    }
                });

        AlertDialog alertDialog = alertDialogBuilder.create();
        alertDialog.show();
    }

}
