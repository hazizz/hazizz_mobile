package com.indeed.hazizz;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentActivity;
import android.support.v4.app.FragmentTransaction;
import android.util.Log;

import com.indeed.hazizz.Fragments.GroupFragment;

import java.util.HashMap;
import java.util.Map;

public abstract class Transactor extends FragmentActivity {


    public static void makeTransaction(Fragment frag, FragmentTransaction fragmentTransaction){
        fragmentTransaction.add(R.id.fragment_container, frag);
        fragmentTransaction.commit();
    }

    public static void makeTransaction(Fragment frag, FragmentTransaction fragmentTransaction, HashMap<String, Object> vars){
        Bundle bundle = new Bundle();
        for(Map.Entry<String, Object> entry : vars.entrySet()) {
            bundle.putString(entry.getKey(), entry.getValue().toString());
            Log.e("hey", "asd1" + entry.getKey() + ", " + entry.getValue());
        }
        frag.setArguments(bundle);

        fragmentTransaction.add(R.id.fragment_container, frag);
        fragmentTransaction.commit();
    }
}
