package com.hazizz.droid.fragments.Options;

import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;

import com.hazizz.droid.activities.AuthActivity;
import com.hazizz.droid.activities.BaseActivity;
import com.hazizz.droid.fragments.ParentFragment.ParentFragment;
import com.hazizz.droid.R;
import com.hazizz.droid.other.SharedPrefs;

public class ServerSettingsFragment extends ParentFragment {

    private View v;

    private Button button_set;
    private EditText editText_serverAddress;


    private String lastDisplayName;


    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.fragment_settings_server, container, false);

        fragmentSetup(((BaseActivity)getActivity()), R.string.title_set_server_address);


        editText_serverAddress = v.findViewById(R.id.editText_serverAddress);
        button_set = v.findViewById(R.id.button_set);
        button_set.setOnClickListener(new View.OnClickListener() {
            @Override public void onClick(View v) {

                SharedPrefs.Server.setMainAddress(getContext(), editText_serverAddress.getText().toString());
                SharedPrefs.Server.setHasChangedAddress(getActivity());

                Intent intent = new Intent(getActivity(), AuthActivity.class);
                getActivity().finish();
                startActivity(intent);

            }
        });
        return v;
    }

}
