package com.indeed.hazizz;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentActivity;
import android.support.v4.app.FragmentTransaction;
import android.util.Log;

import com.indeed.hazizz.Fragments.ChatFragment;
import com.indeed.hazizz.Fragments.CreateTaskFragment;
import com.indeed.hazizz.Fragments.GroupMainFragment;
import com.indeed.hazizz.Fragments.GroupsFragment;
import com.indeed.hazizz.Fragments.MainFragment;
import com.indeed.hazizz.Fragments.ViewTaskFragment;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

public abstract class Transactor extends FragmentActivity {

    private static boolean backStack = true;

  /*  public static void makeTransaction(Fragment frag, FragmentTransaction fragmentTransaction,Boolean backStack, String tag, Bundle bundle){
        if(bundle != null) {
            frag.setArguments(bundle);
        }
      /*  if(addToStack != null) {
            fragmentTransaction
                  //  .add(addToStack, "detail")
                    // Add this transaction to the back stack
                    .addToBackStack(null);
        }

        fragmentTransaction.add(R.id.fragment_container, frag, tag);//.addToBackStack(null);
        if(backStack){ fragmentTransaction.addToBackStack(null); }
        fragmentTransaction.commit();
    }

    public static void makeTransaction(Fragment frag, FragmentTransaction fragmentTransaction, Boolean backStack, String tag, int groupId){

      /*  if(addToStack != null) {
            fragmentTransaction
                  //  .add(addToStack, "detail")
                    // Add this transaction to the back stack
                    .addToBackStack(null);
        }
        Bundle bundle = new Bundle();
        bundle.putInt("groupId", groupId);
        frag.setArguments(bundle);
        fragmentTransaction.add(R.id.fragment_container, frag, tag);//.addToBackStack(null);
        if(backStack){ fragmentTransaction.addToBackStack(tag); }
        fragmentTransaction.commit();
    }

    public static void makeTransaction(Fragment frag, FragmentTransaction fragmentTransaction,Boolean backStack, String tag, HashMap<String, Object> vars){
      /*  if(addToStack != null) {
            fragmentTransaction
                    .add(addToStack, "detail")
                    // Add this transaction to the back stack
                    .addToBackStack(null);
        }

        Bundle bundle = new Bundle();
        for(Map.Entry<String, Object> entry : vars.entrySet()) {
            bundle.putInt(entry.getKey(), (int)entry.getValue());
            Log.e("hey", "asd1" + entry.getKey() + ", " + entry.getValue());
        }
        frag.setArguments(bundle);

        fragmentTransaction.add(R.id.fragment_container, frag);//.addToBackStack(null);
        if(backStack){fragmentTransaction.addToBackStack(tag); }
        fragmentTransaction.commit();
    }

    public static void makeTransaction(Fragment frag, FragmentTransaction fragmentTransaction,Boolean backStack, String tag, ArrayList<Integer> vars){
      /*  if(addToStack != null) {
            fragmentTransaction
                    .add(addToStack, "detail")
                    // Add this transaction to the back stack
                    .addToBackStack(null);
        }

        Bundle bundle = new Bundle();

        bundle.putIntegerArrayList("groupsIds", vars);
        frag.setArguments(bundle);

        fragmentTransaction.add(R.id.fragment_container, frag);//.addToBackStack(null);
        if(backStack){ fragmentTransaction.addToBackStack(tag); }
        fragmentTransaction.commit();
    }

    public static void makeTransaction(Fragment frag, FragmentTransaction fragmentTransaction, Boolean backStack, String tag){
        fragmentTransaction.add(R.id.fragment_container, frag, tag);//.addToBackStack(null);
        if(backStack){ fragmentTransaction.addToBackStack(tag); }
        fragmentTransaction.commit();
    } */

    public static void fragmentMain(FragmentTransaction fTransaction){
        Bundle bundle = new Bundle();
        MainFragment frag = new MainFragment();
        frag.setArguments(bundle);
        fTransaction.add(R.id.fragment_container, frag);//.addToBackStack(null);
        if(backStack){ fTransaction.addToBackStack(null); }
        fTransaction.commit();
    }
    public static void fragmentGroups(FragmentTransaction fTransaction, boolean destCreateTask){
        Bundle bundle = new Bundle();
        GroupsFragment frag = new GroupsFragment();
        if(destCreateTask){ frag.destCreateTask(); }
        frag.setArguments(bundle);
        fTransaction.add(R.id.fragment_container, frag);//.addToBackStack(null);
        if(backStack){ fTransaction.addToBackStack(null); }
        fTransaction.commit();
    }
    public static void fragmentMainGroup(FragmentTransaction fTransaction, int groupId, String groupName){
        Bundle bundle = new Bundle();
        bundle.putInt("groupId", groupId);
        bundle.putString("groupName", groupName);
        GroupMainFragment frag = new GroupMainFragment();
        frag.setArguments(bundle);
        fTransaction.add(R.id.fragment_container, frag);//.addToBackStack(null);
        if(backStack){ fTransaction.addToBackStack(null); }
        fTransaction.commit();
    }
    public static void fragmentViewTask(FragmentTransaction fTransaction, int groupId, int taskId, String groupName){
        Bundle bundle = new Bundle();
        bundle.putInt("groupId", groupId);
        bundle.putInt("taskId", taskId);
        bundle.putString("groupName", groupName);
        ViewTaskFragment frag = new ViewTaskFragment();
        frag.setArguments(bundle);
        fTransaction.add(R.id.fragment_container, frag);//.addToBackStack(null);
        if(backStack){ fTransaction.addToBackStack(null); }
        fTransaction.commit();
    }
    public static void fragmentCreateTask(FragmentTransaction fTransaction, int groupId, String groupName){
        Bundle bundle = new Bundle();
        bundle.putInt("groupId", groupId);
        bundle.putString("groupName", groupName);
        CreateTaskFragment frag = new CreateTaskFragment();
        frag.setArguments(bundle);
        fTransaction.add(R.id.fragment_container, frag);//.addToBackStack(null);
        if(backStack){ fTransaction.addToBackStack(null); }
        fTransaction.commit();
    }
    public static void fragmentChat(FragmentTransaction fTransaction){
        Bundle bundle = new Bundle();
        ChatFragment frag = new ChatFragment();
        frag.setArguments(bundle);
        fTransaction.add(R.id.fragment_container, frag);//.addToBackStack(null);
        if(backStack){ fTransaction.addToBackStack(null); }
        fTransaction.commit();
    }










}
