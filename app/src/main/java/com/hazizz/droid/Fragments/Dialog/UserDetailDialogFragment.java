package com.hazizz.droid.Fragments.Dialog;

import android.graphics.Bitmap;
import android.os.Bundle;
import android.support.v4.app.DialogFragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;

import com.hazizz.droid.Communication.MiddleMan;
import com.hazizz.droid.Communication.POJO.Response.CustomResponseHandler;
import com.hazizz.droid.Communication.POJO.Response.PojoPublicUserData;
import com.hazizz.droid.Communication.Strings;
import com.hazizz.droid.Converter.Converter;
import com.hazizz.droid.R;

import java.util.EnumMap;
import java.util.HashMap;

public class UserDetailDialogFragment extends DialogFragment {

    ImageView imageView_userProfilePic;
    TextView textView_displayName;
    TextView textView_username;
    TextView textView_registrationDate;

    Button button_close;


    CustomResponseHandler rh = new CustomResponseHandler() {
        @Override
        public void onPOJOResponse(Object response) {

            PojoPublicUserData pojoObject = (PojoPublicUserData)response;


            textView_username.setText(pojoObject.getUsername());
            textView_displayName.setText(pojoObject.getDisplayName());
            textView_registrationDate.setText(pojoObject.getRegistrationDate());
        }
    };

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View v = inflater.inflate(R.layout.dialog_fragment_user_detail, container, false);

        long userId = getArguments().getLong(Strings.Path.USERID.toString());
        Bitmap profilePic = Converter.getCroppedBitmap(Converter.imageFromText(getArguments().getString(Strings.Other.PROFILEPIC.toString())));

            // Do all the stuff to initialize your custom view
        imageView_userProfilePic = v.findViewById(R.id.imageView_profilePic);
        imageView_userProfilePic.setImageBitmap(profilePic);
        textView_displayName = v.findViewById(R.id.textView_displayName);
        textView_username = v.findViewById(R.id.textView_username);
        textView_registrationDate = v.findViewById(R.id.textView_registrationDate);

        button_close = v.findViewById(R.id.button_close);
        button_close.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                dismiss();
            }
        });

        EnumMap<Strings.Path, Object> vars = new EnumMap<>(Strings.Path.class);
        vars.put(Strings.Path.USERID, userId);

        MiddleMan.newRequest(getActivity(), "getPublicUserDetail", null, rh, vars);

        return v;
    }
}