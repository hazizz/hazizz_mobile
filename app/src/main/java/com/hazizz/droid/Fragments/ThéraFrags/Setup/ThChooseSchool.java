package com.hazizz.droid.Fragments.ThéraFrags.Setup;

import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.TextView;

import com.hazizz.droid.Activities.MainActivity;
import com.hazizz.droid.Communication.POJO.Response.CustomResponseHandler;
import com.hazizz.droid.Communication.Requests.RequestType.Thera.ThSchools;
import com.hazizz.droid.CustomSearchableSpinner;
import com.hazizz.droid.Communication.MiddleMan;
import com.hazizz.droid.R;

import java.util.Arrays;
import java.util.HashMap;

public class ThChooseSchool extends Fragment {

    private HashMap<String, String> schools;

    private String[] key;
    private String[] value;

    private String chosenSchool;

    private View v;

    private CustomSearchableSpinner spinner_schools;

    private TextView textView_school;
    private Button button_ok;


    private CustomResponseHandler rh = new CustomResponseHandler() {
        @Override
        public void onPOJOResponse(Object response) {
            schools = (HashMap<String, String>)response;

            Object[] a = schools.keySet().toArray();
            key = Arrays.copyOf(a, a.length, String[].class);

            a = schools.values().toArray();
            value = Arrays.copyOf(a, a.length, String[].class);
            ArrayAdapter adapter=new ArrayAdapter(getContext(), R.layout.support_simple_spinner_dropdown_item, key);
            spinner_schools.setAdapter(adapter);
        }
    };


    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.fragment_th_chose_school, container, false);
        ((MainActivity) getActivity()).onFragmentCreated();

        spinner_schools = v.findViewById(R.id.SearchableSpinner_schools);
        spinner_schools.setTitle(getString(R.string.select_school));
        spinner_schools.setPositiveButton(getString(R.string.close));


        MiddleMan.newRequest(new ThSchools(getActivity(), rh));

        button_ok = v.findViewById(R.id.button_ok);
        button_ok.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                spinner_schools.setVisibility(View.VISIBLE);
            }
        });
        textView_school = v.findViewById(R.id.textView_school);


        spinner_schools.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                chosenSchool = value[position];

                textView_school.setText(key[position]);

               // spinner_schools.setVisibility(View.INVISIBLE);

            }
            @Override public void onNothingSelected(AdapterView<?> parent) {
              //  spinner_schools.setVisibility(View.INVISIBLE);
            }
        });



        return v;
    }
}
