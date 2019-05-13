package com.hazizz.droid.other;

import android.app.Activity;
import android.content.DialogInterface;
import android.support.v7.app.AlertDialog;

import com.hazizz.droid.communication.MiddleMan;

import com.hazizz.droid.communication.requests.Feedback;
import com.hazizz.droid.communication.responsePojos.CustomResponseHandler;
import com.hazizz.droid.R;
import com.hazizz.droid.navigation.Transactor;

public class ErrorHandler {
    public static void unExpectedResponseDialog(Activity act){
        try {
            AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(act);
            alertDialogBuilder.setTitle(R.string.error);
            alertDialogBuilder
                    .setMessage(R.string.info_serverUnexpectedResponse)
                    .setCancelable(false)
                    .setPositiveButton(R.string.report_bug, (dialog, id) -> {
                        Transactor.activityFeedback(act);
                        dialog.cancel();
                    })
                    .setNegativeButton(R.string.go_back, new DialogInterface.OnClickListener() {
                        public void onClick(DialogInterface dialog, int id) {
                            MiddleMan.newRequest(new Feedback(act, new CustomResponseHandler() {},
                                    "android", AndroidThings.getAppVersion(), "no message"));

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
