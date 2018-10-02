package com.indeed.hazizz;

import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentActivity;
import android.support.v4.app.FragmentTransaction;

public abstract class Transactor extends FragmentActivity {

    public static void makeTransaction(Fragment frag, FragmentTransaction fragmentTransaction){
        fragmentTransaction.add(R.id.fragment_container, frag);
        fragmentTransaction.commit();
    }
}
