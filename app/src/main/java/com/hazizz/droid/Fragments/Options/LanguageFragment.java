package com.hazizz.droid.fragments.Options;

import android.content.res.Configuration;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ListView;

import com.hazizz.droid.R;
import com.hazizz.droid.activities.BaseActivity;
import com.hazizz.droid.cache.MeInfo.MeInfo;
import com.hazizz.droid.fragments.ParentFragment.ParentFragment;
import com.hazizz.droid.listeners.OnBackPressedListener;
import com.hazizz.droid.navigation.Transactor;

import java.util.Locale;

public class LanguageFragment extends ParentFragment {

    private final int PICK_PHOTO_FOR_AVATAR = 1;

    private String lastDisplayName;

    private boolean changedPic = false;
    private boolean changedDisplayName = false;


    private MeInfo meInfo;

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.fragment_options, container, false);

        fragmentSetup(((BaseActivity)getActivity()), R.string.settings);

        setOnBackPressedListener(new OnBackPressedListener() {
            @Override
            public void onBackPressed() {
                Transactor.fragmentMain(getFragmentManager().beginTransaction());
            }
        });

        meInfo = MeInfo.getInstance();

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

    public void setLanguage() {
        /*
        Configuration config = new Configuration(getResources().getConfiguration());
        config.locale = Locale.ENGLISH ;
        getResources().updateConfiguration(config,getResources().getDisplayMetrics());
        */

        /*
        Locale locale = new Locale("en");
        Locale.setDefault(locale);

        Configuration config = getContext().getResources().getConfiguration();
        config.setLocale(locale);
        context.createConfigurationContext(config);

        context.getResources().updateConfiguration(config, context.getResources().getDisplayMetrics());

*/
    }


}
