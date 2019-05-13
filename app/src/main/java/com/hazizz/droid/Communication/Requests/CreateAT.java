package com.hazizz.droid.communication.requests;

import android.app.Activity;
import android.util.Log;


import com.hazizz.droid.communication.RequestSender;
import com.hazizz.droid.communication.requests.parent.Request;
import com.hazizz.droid.communication.Strings;
import com.hazizz.droid.communication.responsePojos.CustomResponseHandler;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class CreateAT extends Request {
    private String p_whereName, p_byName;
    private int p_byId;
    public CreateAT(Activity act, CustomResponseHandler rh, Strings.Path p_whereName, String p_byName, int p_byId,
                    int b_taskType, String b_taskTitle, String b_description, String b_dueDate) {
        super(act, rh);
        Log.e("hey", "created CreateAT object");

        this.p_whereName = p_whereName.toString();
        this.p_byName = p_byName;
        this.p_byId = p_byId;

        body.put("taskType", b_taskType);
        body.put("taskTitle", b_taskTitle);
        body.put("description", b_description);
        body.put("dueDate", b_dueDate);

    }

    public CreateAT(Activity act, CustomResponseHandler rh, Strings.Path p_whereName, Strings.Path p_byName, int p_byId,
                    String b_announcementTitle, String b_description) {
        super(act, rh);
        Log.e("hey", "created CreateAT object");
        this.p_whereName = p_whereName.toString();
        this.p_byName = p_byName.toString();
        this.p_byId = p_byId;

        body.put("announcementTitle", b_announcementTitle);
        body.put("description", b_description);

    }


    public void setupCall() {

        putHeaderContentType();
        putHeaderAuthToken();
        buildCall(RequestSender.getHazizzRequestTypes().createAT(p_whereName, p_byName,
                Integer.toString(p_byId), header, body));



    }
    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {
        cOnResponse.onSuccessfulResponse();
    }
}
