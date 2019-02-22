package com.hazizz.droid;

import android.app.Activity;
import android.content.DialogInterface;
import android.support.v7.app.AlertDialog;

import com.hazizz.droid.AndroidThings;
import com.hazizz.droid.Communication.MiddleMan;
import com.hazizz.droid.Communication.Requests.Feedback;
import com.hazizz.droid.Manager;
import com.hazizz.droid.R;
import com.hazizz.droid.Transactor;

import java.util.HashMap;

public class ErrorHandler {

    public static void unExpectedResponseDialog(Activity act){

        try {
            AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(act);
            alertDialogBuilder.setTitle(R.string.error);
            alertDialogBuilder
                    .setMessage(R.string.info_serverUnexpectedResponse)
                    .setCancelable(false)
                    .setPositiveButton(R.string.report_bug, (dialog, id) -> {
                        Transactor.feedbackActivity(act);
                        dialog.cancel();
                    })
                    .setNegativeButton(R.string.go_back, new DialogInterface.OnClickListener() {
                        public void onClick(DialogInterface dialog, int id) {

                            /*
                            HashMap<String, String> data = new HashMap<>();
                            data.put("lastCall", Manager.CrashManager.getLastCall().toString());
                            data.put("time", Manager.CrashManager.getError().getTime());
                            data.put("errorCode", Integer.toString(Manager.CrashManager.getError().getErrorCode()));
                            data.put("title", Manager.CrashManager.getError().getTitle());
                            data.put("message", Manager.CrashManager.getError().getMessage());
                            */

                            MiddleMan.newRequest(new Feedback(act, null, "android", AndroidThings.getAppVersion(),
                                    "no message"));

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
