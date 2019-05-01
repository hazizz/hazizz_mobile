package com.hazizz.droid.fragments.Dialog;

import android.graphics.Bitmap;
import android.os.Bundle;
import android.support.v4.app.DialogFragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.TextView;

import com.hazizz.droid.Communication.MiddleMan;

import com.hazizz.droid.Communication.requests.GetPublicUserDetail;
import com.hazizz.droid.Communication.requests.GetUserProfilePic;
import com.hazizz.droid.Communication.Strings;
import com.hazizz.droid.Communication.responsePojos.CustomResponseHandler;
import com.hazizz.droid.Communication.responsePojos.PojoPicSmall;
import com.hazizz.droid.Communication.responsePojos.PojoPublicUserData;
import com.hazizz.droid.converter.Converter;
import com.hazizz.droid.other.D8;
import com.hazizz.droid.R;
import com.hazizz.droid.navigation.Transactor;

public class UserDetailDialogFragment extends DialogFragment {

    ImageView imageView_userProfilePic;
    TextView textView_displayName;
    TextView textView_username;
    TextView textView_registrationDate;

    Button button_close;

    int rank;


    CustomResponseHandler rh = new CustomResponseHandler() {
        @Override
        public void onPOJOResponse(Object response) {
            PojoPublicUserData pojoObject = (PojoPublicUserData)response;

            textView_username.setText(pojoObject.getUsername());
            textView_displayName.setText(pojoObject.getDisplayName());
            textView_registrationDate.setText(D8.textToDate(pojoObject.getRegistrationDate()).getMainFormat());
        }
    };

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View v = inflater.inflate(R.layout.dialog_fragment_user_detail, container, false);

        long userId = getArguments().getLong(Transactor.KEY_USERID);
        Bitmap profilePic = Converter.getCroppedBitmap(Converter.imageFromText(getContext(), getArguments().getString(Strings.Other.PROFILEPIC.toString())));
        rank = getArguments().getInt(Transactor.KEY_RANK);
        if(rank == Strings.Rank.OWNER.getValue()){
            FrameLayout badge = v.findViewById(R.id.badge_owner);
            badge.setVisibility(View.VISIBLE);
        }
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

        MiddleMan.newRequest(new GetUserProfilePic(getActivity(), new CustomResponseHandler() {
            @Override
            public void onPOJOResponse(Object response) {
                Bitmap bitmap = Converter.imageFromText(getContext(),
                        ((PojoPicSmall)response).getData().split(",")[1]);
                //  bitmap = Converter.scaleBitmapToRegular(bitmap);
                bitmap = Converter.getCroppedBitmap(bitmap);

                imageView_userProfilePic.setImageBitmap(bitmap);
            }
        }, userId).full());

        MiddleMan.newRequest(new GetPublicUserDetail(getActivity(),  rh, (int)userId));

        return v;
    }
}