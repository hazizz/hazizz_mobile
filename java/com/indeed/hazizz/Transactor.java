package com.indeed.hazizz;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentActivity;
import android.support.v4.app.FragmentTransaction;
import android.util.Log;

import com.indeed.hazizz.Fragments.GroupsFragment;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

public abstract class Transactor extends FragmentActivity {

    public static void makeTransaction(Fragment frag, FragmentTransaction fragmentTransaction, String tag, Bundle bundle){
        if(bundle != null) {
            frag.setArguments(bundle);
        }
      /*  if(addToStack != null) {
            fragmentTransaction
                  //  .add(addToStack, "detail")
                    // Add this transaction to the back stack
                    .addToBackStack(null);
        } */

        fragmentTransaction.add(R.id.fragment_container, frag, tag).addToBackStack(null);
        fragmentTransaction.commit();
    }

    public static void makeTransaction(Fragment frag, FragmentTransaction fragmentTransaction, String tag, int groupId){

      /*  if(addToStack != null) {
            fragmentTransaction
                  //  .add(addToStack, "detail")
                    // Add this transaction to the back stack
                    .addToBackStack(null);
        } */
        Bundle bundle = new Bundle();
        bundle.putInt("groupId", groupId);
        frag.setArguments(bundle);
        fragmentTransaction.add(R.id.fragment_container, frag, tag).addToBackStack(null);
        fragmentTransaction.commit();
    }

    public static void makeTransaction(Fragment frag, FragmentTransaction fragmentTransaction, String tag, HashMap<String, Object> vars){
      /*  if(addToStack != null) {
            fragmentTransaction
                    .add(addToStack, "detail")
                    // Add this transaction to the back stack
                    .addToBackStack(null);
        }*/

        Bundle bundle = new Bundle();
        for(Map.Entry<String, Object> entry : vars.entrySet()) {
            bundle.putInt(entry.getKey(), (int)entry.getValue());
            Log.e("hey", "asd1" + entry.getKey() + ", " + entry.getValue());
        }
        frag.setArguments(bundle);

        fragmentTransaction.add(R.id.fragment_container, frag).addToBackStack(null);
        fragmentTransaction.commit();
    }

    public static void makeTransaction(Fragment frag, FragmentTransaction fragmentTransaction, String tag, ArrayList<Integer> vars){
      /*  if(addToStack != null) {
            fragmentTransaction
                    .add(addToStack, "detail")
                    // Add this transaction to the back stack
                    .addToBackStack(null);
        }*/

        Bundle bundle = new Bundle();

        bundle.putIntegerArrayList("groupsIds", vars);
        frag.setArguments(bundle);

        fragmentTransaction.add(R.id.fragment_container, frag).addToBackStack(null);
        fragmentTransaction.commit();
    }

    public static void makeTransaction(Fragment frag, FragmentTransaction fragmentTransaction, String tag){
        fragmentTransaction.add(R.id.fragment_container, frag, tag).addToBackStack(null);
        fragmentTransaction.commit();
    }
}
