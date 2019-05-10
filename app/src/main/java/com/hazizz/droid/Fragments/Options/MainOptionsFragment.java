package com.hazizz.droid.fragments.Options;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.net.Uri;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
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

import com.hazizz.droid.activities.MainActivity;
import com.hazizz.droid.cache.HCache;
import com.hazizz.droid.other.AndroidThings;
import com.hazizz.droid.cache.MeInfo.MeInfo;

import com.hazizz.droid.communication.requests.GetMyProfilePic;
import com.hazizz.droid.communication.requests.SetDisplayName;
import com.hazizz.droid.communication.requests.SetMyProfilePic;
import com.hazizz.droid.communication.responsePojos.CustomResponseHandler;
import com.hazizz.droid.communication.responsePojos.PojoError;
import com.hazizz.droid.communication.responsePojos.PojoGroup;
import com.hazizz.droid.communication.responsePojos.PojoPicSmall;
import com.hazizz.droid.converter.Converter;
import com.hazizz.droid.fragments.ParentFragment.ParentFragment;
import com.hazizz.droid.listeners.OnBackPressedListener;
import com.hazizz.droid.navigation.Transactor;
import com.hazizz.droid.communication.MiddleMan;
import com.hazizz.droid.R;
import com.hazizz.droid.other.Theme;
import com.theartofdev.edmodo.cropper.CropImage;
import com.theartofdev.edmodo.cropper.CropImageView;

import java.io.FileNotFoundException;
import java.io.InputStream;
import java.util.HashMap;
import java.util.List;

public class MainOptionsFragment extends ParentFragment {

    public List<PojoGroup> groups;
    private View v;

    private Button button_thera;
    private ImageView imageView_profilePic;
    private EditText editText_displayName;
    private ImageButton fab_profilePicCheck;
    private ImageButton imageButton_displayNameAction;
    private TextView textView_error;

    private final int PICK_PHOTO_FOR_AVATAR = 1;

    private String lastDisplayName;

    private boolean changedPic = false;
    private boolean changedDisplayName = false;


    private MeInfo meInfo;

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.fragment_options, container, false);

        fragmentSetup(R.string.settings);

        setOnBackPressedListener(new OnBackPressedListener() {
            @Override
            public void onBackPressed() {
                Transactor.fragmentMain(getFragmentManager().beginTransaction());
            }
        });

        meInfo = MeInfo.getInstance();

        imageView_profilePic = v.findViewById(R.id.imageView_profilePic);
        MiddleMan.newRequest(new GetMyProfilePic(getActivity(), new CustomResponseHandler() {
            @Override
            public void onPOJOResponse(Object response) {
                Bitmap bitmap = Converter.imageFromText(getContext(),
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
        editText_displayName.setText(HCache.getInstance().getDisplayUsername(getContext()));
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
                imageButton_displayNameAction.setImageResource(R.drawable.ic_check_black);
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
                    body.put("data", "data:image/jpeg;base64," + meInfo.getProfilePic());
                    body.put("type", "ppfull");

                    MiddleMan.newRequest(new SetMyProfilePic(getActivity(), new CustomResponseHandler() {
                        @Override
                        public void onSuccessfulResponse() {
                            fab_profilePicCheck.setImageResource(R.drawable.ic_camera_black);
                            changedPic = false;
                        }
                    }, "data:image/jpeg;base64," + meInfo.getProfilePic(), "ppfull"));
                }else{
                    pickImage();
                }
            }
        });
        imageButton_displayNameAction = v.findViewById(R.id.imageButton_checkDisplayName);
        imageButton_displayNameAction.setColorFilter(Theme.getIconColor(getContext()));
        imageButton_displayNameAction.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if(changedDisplayName) {
                    String newDisplayName = editText_displayName.getText().toString();
                    MiddleMan.newRequest(new SetDisplayName(getActivity(), new CustomResponseHandler() {
                        @Override
                        public void onErrorResponse(PojoError error) {
                            Log.e("hey", "couldnt set profile pic");
                            editText_displayName.setText(lastDisplayName);
                            AndroidThings.closeKeyboard(getContext(), v);
                        }

                        @Override
                        public void onSuccessfulResponse() {
                            imageButton_displayNameAction.setImageResource(R.drawable.ic_create_black);
                            ((MainActivity) getActivity()).setDisplayNameInNav(newDisplayName);
                            editText_displayName.clearFocus();
                            changedDisplayName = false;
                            AndroidThings.closeKeyboard(getContext(), v);
                        }
                    }, newDisplayName));
                }else{
                    editText_displayName.requestFocus();
                }
            }
        });
        imageView_profilePic.setImageBitmap(Converter.getCroppedBitmap(Converter.imageFromText(getContext(), meInfo.getProfilePic())));
        editText_displayName.setText(meInfo.getDisplayName());
        imageButton_displayNameAction.setImageResource(R.drawable.ic_create_black);

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
                        Transactor.fragmentNotificationSettings(getFragmentManager().beginTransaction());
                        break;
                    case 1:
                        //Jelszó Beállítás
                        Transactor.fragmentPassword(getFragmentManager().beginTransaction());
                        break;
                    case 2:
                        //szerver
                        Transactor.fragmentServerSettings(getFragmentManager().beginTransaction());
                        break;
                    case 3:
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
        meInfo.setProfilePic(base64_profilePic);
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
                CropImage.activity(data.getData())
                    .setActivityMenuIconColor(getResources().getColor(R.color.colorDarkText))
                    .setAspectRatio(1,1)
                    .setFixAspectRatio(true)
                    .setGuidelines(CropImageView.Guidelines.ON)
                    .setCropShape(CropImageView.CropShape.OVAL)
                    .setBorderLineThickness(8)
                    .start(getContext(), this);

            } catch (Exception e) {
                e.printStackTrace();
                Log.e("hey", "file not found!");
            }
        }
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        AndroidThings.closeKeyboard(getContext(), v);
    }
}
