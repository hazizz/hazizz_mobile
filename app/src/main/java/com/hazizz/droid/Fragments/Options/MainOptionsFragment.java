package com.hazizz.droid.Fragments.Options;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.graphics.Rect;
import android.net.Uri;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.text.Editable;
import android.text.TextWatcher;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;

import com.hazizz.droid.Activities.MainActivity;
import com.hazizz.droid.Communication.POJO.Response.CustomResponseHandler;
import com.hazizz.droid.Communication.POJO.Response.POJOerror;
import com.hazizz.droid.Communication.POJO.Response.POJOgroup;
import com.hazizz.droid.Communication.POJO.Response.PojoPicSmall;
import com.hazizz.droid.Communication.Requests.GetMyProfilePic;
import com.hazizz.droid.Communication.Requests.SetDisplayName;
import com.hazizz.droid.Communication.Requests.SetMyProfilePic;
import com.hazizz.droid.Converter.Converter;
import com.hazizz.droid.Manager;
import com.hazizz.droid.Transactor;
import com.hazizz.droid.Communication.MiddleMan;
import com.hazizz.droid.R;
import com.theartofdev.edmodo.cropper.CropImage;
import com.theartofdev.edmodo.cropper.CropImageView;

import java.io.FileNotFoundException;
import java.io.InputStream;
import java.util.HashMap;
import java.util.List;

public class MainOptionsFragment extends Fragment {

    public List<POJOgroup> groups;
    private View v;

    private Button button_thera;
    private ImageView imageView_profilePic;
    private EditText editText_displayName;
    private ImageButton fab_profilePicCheck;
    private ImageButton imageButton_displayNameCheck;
    private TextView textView_error;

    private final int PICK_PHOTO_FOR_AVATAR = 1;

    private String lastDisplayName;

    private boolean changedPic = false;
    private boolean changedDisplayName = false;

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.fragment_options, container, false);
        ((MainActivity)getActivity()).onFragmentCreated();

        getActivity().setTitle(R.string.settings);

        imageView_profilePic = v.findViewById(R.id.imageView_profilePic);
        MiddleMan.newRequest(new GetMyProfilePic(getActivity(), new CustomResponseHandler() {
            @Override
            public void onPOJOResponse(Object response) {
                Bitmap bitmap = Converter.imageFromText(
                        ((PojoPicSmall)response).getData().split(",")[1]);
              //  bitmap = Converter.scaleBitmapToRegular(bitmap);
                bitmap = Converter.getCroppedBitmap(bitmap);

                imageView_profilePic.setImageBitmap(bitmap);
            }
        }).full());
        imageView_profilePic.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                editText_displayName.clearFocus();
                pickImage();
            }
        });

        createViewList();
        button_thera = v.findViewById(R.id.button_thera);
        button_thera.setOnClickListener(new View.OnClickListener() {
            @Override public void onClick(View v) {
                ((MainActivity) getActivity()).activateHiddenFeatures();
            }
        });


        textView_error = v.findViewById(R.id.textView_error_currentPassword);
        textView_error.setTextColor(Color.rgb(255, 0, 0));

        editText_displayName = v.findViewById(R.id.editText_displayName);
        editText_displayName.setOnFocusChangeListener(new View.OnFocusChangeListener() {
            @Override
            public void onFocusChange(View view, boolean hasFocus) {
                if (hasFocus) {
                    lastDisplayName = editText_displayName.getText().toString();
                }
            }
        });

        editText_displayName.addTextChangedListener(new TextWatcher() {
            public void onTextChanged(CharSequence c, int start, int before, int count) { }
            public void beforeTextChanged(CharSequence c, int start, int count, int after) { }

            public void afterTextChanged(Editable c) {
                imageButton_displayNameCheck.setImageResource(R.drawable.ic_check_black);
                int length = editText_displayName.length();
                if(length >= 4 && length <= 20) {
                    textView_error.setText("");
                    changedDisplayName = true;

                }else{
                    textView_error.setText(getString(R.string.error_displayNameLength));
                }
            }
        });

        fab_profilePicCheck = v.findViewById(R.id.fab_checkProfilePic);
        fab_profilePicCheck.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if(changedPic) {
                    HashMap<String, Object> body = new HashMap<>();
                    body.put("data", "data:image/jpeg;base64," + Manager.MeInfo.getProfilePic());
                    body.put("type", "ppfull");

                    MiddleMan.newRequest(new SetMyProfilePic(getActivity(), new CustomResponseHandler() {
                        @Override
                        public void onSuccessfulResponse() {
                            fab_profilePicCheck.setImageResource(R.drawable.ic_camera_black);
                            changedPic = false;
                        }
                    }, "data:image/jpeg;base64," + Manager.MeInfo.getProfilePic(), "ppfull"));
                }else{
                    pickImage();
                }
            }
        });
        imageButton_displayNameCheck = v.findViewById(R.id.imageButton_checkDisplayName);
        imageButton_displayNameCheck.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if(changedDisplayName) {
                    String newDisplayName = editText_displayName.getText().toString();
                    MiddleMan.newRequest(new SetDisplayName(getActivity(), new CustomResponseHandler() {
                        @Override
                        public void onErrorResponse(POJOerror error) {
                            Log.e("hey", "couldnt set profile pic");
                            editText_displayName.setText(lastDisplayName);
                        }

                        @Override
                        public void onSuccessfulResponse() {
                            imageButton_displayNameCheck.setImageResource(R.drawable.ic_create_black);
                            ((MainActivity) getActivity()).setDisplayNameInNav(newDisplayName);
                            editText_displayName.clearFocus();
                            changedDisplayName = false;
                        }
                    }, newDisplayName));
                }else{
                    editText_displayName.requestFocus();
                }
            }
        });
        imageView_profilePic.setImageBitmap(Converter.getCroppedBitmap(Converter.imageFromText(Manager.MeInfo.getProfilePic())));
        editText_displayName.setText(Manager.MeInfo.getDisplayName());
        imageButton_displayNameCheck.setImageResource(R.drawable.ic_create_black);

        fab_profilePicCheck.setImageResource(R.drawable.ic_camera_black);







        return v;
    }

    void createViewList(){
        ListView listView = (ListView)v.findViewById(R.id.listView1);

        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> adapterView, View view, int i, long l) {
                switch (i){
                    case 0:
                        //Fiók Szerkesztés
                        // átmenetileg
                        Transactor.fragmentPassword(getFragmentManager().beginTransaction());
                        break;
                    case 1:
                        //Jelszó Beállítás

                        break;
                    case 2:
                    default:
                        //Théra Beállítások
                        break;
                }
            }
        });
    }
    public void pickImage() {
        Intent intent = new Intent(Intent.ACTION_GET_CONTENT);
        intent.setType("image/*");
        startActivityForResult(intent, PICK_PHOTO_FOR_AVATAR);
    }
    public void setProfilePic(Bitmap b){
        Log.e("hey", "setProfilePic called");
        imageView_profilePic.setImageBitmap(b);
        String base64_profilePic = Converter.imageToText(b);
        Manager.MeInfo.setProfilePic(base64_profilePic);
        fab_profilePicCheck.setImageResource(R.drawable.ic_check_black);
    }


    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        if (requestCode == CropImage.CROP_IMAGE_ACTIVITY_REQUEST_CODE) {
            CropImage.ActivityResult result = CropImage.getActivityResult(data);
            if (resultCode == Activity.RESULT_OK) {
                Uri resultUri = result.getUri();

                InputStream inputStream = null;
                try {
                    inputStream = getActivity().getContentResolver().openInputStream(resultUri);
                } catch (FileNotFoundException e) {
                    e.printStackTrace();
                }
                Bitmap bitmap = Converter.imageFromText(inputStream);
                bitmap = Converter.scaleBitmapToRegular(bitmap);
                bitmap = Converter.getCroppedBitmap(bitmap);

                setProfilePic(bitmap);
                ((MainActivity) getActivity()).setProfileImageInNav(bitmap);
                changedPic = true;

            } else if (resultCode == CropImage.CROP_IMAGE_ACTIVITY_RESULT_ERROR_CODE) {
                Exception error = result.getError();
            }
        }

        if (requestCode == PICK_PHOTO_FOR_AVATAR && resultCode == Activity.RESULT_OK) {
            if (data == null) {
                return;
            }try {
/*
                CropImageView cropImageView = (CropImageView) v.findViewById(R.id.cropImageView);
                cropImageView.setAspectRatio(5, 10);
                cropImageView.setFixedAspectRatio(true);
                cropImageView.setCropShape(CropImageView.CropShape.OVAL);
                cropImageView.setScaleType(CropImageView.ScaleType.FIT_CENTER);
                cropImageView.setAutoZoomEnabled(true);
                cropImageView.setShowProgressBar(true);
                cropImageView.setCropRect(new Rect(0, 0, 800, 500));
*/



                CropImage.activity(data.getData())
                        .setActivityMenuIconColor(getResources().getColor(R.color.colorDarkText))
                        .setAspectRatio(1,1)
                        .setFixAspectRatio(true)
                        .setGuidelines(CropImageView.Guidelines.ON)
                        .setCropShape(CropImageView.CropShape.OVAL)
                        .setBorderLineThickness(8)
                        .start(getContext(), this);

              //  bitmap = cropImageView.getCroppedImage();




            } catch (Exception e) {
                e.printStackTrace();
                Log.e("hey", "file not found!");
            }
        }
    }
}
