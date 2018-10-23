package com.indeed.hazizz;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentActivity;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentTransaction;

import com.indeed.hazizz.Fragments.AuthFrags.FirstFragment;
import com.indeed.hazizz.Fragments.AuthFrags.LoginFragment;
import com.indeed.hazizz.Fragments.AuthFrags.RegisterFragment;
import com.indeed.hazizz.Fragments.ChatFragment;
import com.indeed.hazizz.Fragments.CreateGroupFragment;
import com.indeed.hazizz.Fragments.CreateSubjectFragment;
import com.indeed.hazizz.Fragments.CreateTaskFragment;
import com.indeed.hazizz.Fragments.GroupMainFragment;
import com.indeed.hazizz.Fragments.GroupTabs.GroupTabFragment;
import com.indeed.hazizz.Fragments.GroupsFragment;
import com.indeed.hazizz.Fragments.JoinGroupFragment;
import com.indeed.hazizz.Fragments.MainFragment;
import com.indeed.hazizz.Fragments.ViewTaskFragment;

public abstract class Transactor extends FragmentActivity {

    private static boolean backStack = true;

    public static Fragment getCurrentFragment(FragmentManager fManager){
        Fragment currentF = fManager.findFragmentById(R.id.fragment_container);
        if(currentF instanceof GroupTabFragment){
            return ((GroupTabFragment) currentF).getCurrentFrag();
        }else {
            return fManager.findFragmentById(R.id.fragment_container);
        }
    }

    public static void fragmentFirst(FragmentTransaction fTransaction){
        FirstFragment frag = new FirstFragment();
        fTransaction.replace(R.id.fragment_container, frag);//.addToBackStack(null);
        if(backStack){ fTransaction.addToBackStack(null); }
        fTransaction.commit();
    }

    public static void fragmentRegister(FragmentTransaction fTransaction){
        RegisterFragment frag = new RegisterFragment();
        fTransaction.replace(R.id.fragment_container, frag);//.addToBackStack(null);
        if(backStack){ fTransaction.addToBackStack(null); }
        fTransaction.commit();
    }
    public static void fragmentLogin(FragmentTransaction fTransaction){
        LoginFragment frag = new LoginFragment();
        fTransaction.replace(R.id.fragment_container, frag);//.addToBackStack(null);
        if(backStack){ fTransaction.addToBackStack(null); }
        fTransaction.commit();
    }


    public static void fragmentMain(FragmentTransaction fTransaction){
        MainFragment frag = new MainFragment();
        fTransaction.replace(R.id.fragment_container, frag);//.addToBackStack(null);
        if(backStack){ fTransaction.addToBackStack(null); }
        fTransaction.commit();
    }
    public static void fragmentGroups(FragmentTransaction fTransaction, boolean destCreateTask){
        Bundle bundle = new Bundle();
        bundle.putBoolean("destCreateTask", destCreateTask);
        GroupsFragment frag = new GroupsFragment();
        frag.setArguments(bundle);
        fTransaction.replace(R.id.fragment_container, frag);//.addToBackStack(null);
        if(backStack){ fTransaction.addToBackStack(null); }
        fTransaction.commit();
    }
    public static void fragmentMainGroup(FragmentTransaction fTransaction, int groupId, String groupName){
     /*   Bundle bundle = new Bundle();
        bundle.putInt("groupId", groupId);
        bundle.putString("groupName", groupName);
        GroupMainFragment frag = new GroupMainFragment();
        frag.setArguments(bundle);
        fTransaction.replace(R.id.fragment_container, frag);//.addToBackStack(null);
        if(backStack){ fTransaction.addToBackStack(null); }
        fTransaction.commit(); */

        fragmentGroupTab(fTransaction, groupId, groupName, 0);
    }
    public static void fragmentViewTask(FragmentTransaction fTransaction, int groupId, int taskId, String groupName){
        Bundle bundle = new Bundle();
        bundle.putInt("groupId", groupId);
        bundle.putInt("taskId", taskId);
        bundle.putString("groupName", groupName);
        ViewTaskFragment frag = new ViewTaskFragment();
        frag.setArguments(bundle);
        fTransaction.replace(R.id.fragment_container, frag);//.addToBackStack(null);
        if(backStack){ fTransaction.addToBackStack(null); }
        fTransaction.commit();
    }
    public static void fragmentCreateTask(FragmentTransaction fTransaction, int groupId, String groupName){
      /*  Bundle bundle = new Bundle();
        bundle.putInt("groupId", groupId);
        bundle.putString("groupName", groupName);
        CreateTaskFragment frag = new CreateTaskFragment();
        frag.setArguments(bundle);
        fTransaction.replace(R.id.fragment_container, frag);//.addToBackStack(null);
        if(backStack){ fTransaction.addToBackStack(null); }
        fTransaction.commit(); */
        fragmentGroupTab(fTransaction, groupId, groupName, 2);
    }
    public static void fragmentChat(FragmentTransaction fTransaction){
        ChatFragment frag = new ChatFragment();
        fTransaction.replace(R.id.fragment_container, frag);//.addToBackStack(null);
        if(backStack){ fTransaction.addToBackStack(null); }
        fTransaction.commit();
    }

    public static void fragmentCreateSubject(FragmentTransaction fTransaction, int groupId, String groupName){
        Bundle bundle = new Bundle();
        CreateSubjectFragment frag = new CreateSubjectFragment();
        bundle.putInt("groupId", groupId);
        bundle.putString("groupName", groupName);
        frag.setArguments(bundle);
        fTransaction.replace(R.id.fragment_container, frag);//.addToBackStack(null);
        if(backStack){ fTransaction.addToBackStack(null); }
        fTransaction.commit();
    }

    public static void fragmentCreateGroup(FragmentTransaction fTransaction){
        CreateGroupFragment frag = new CreateGroupFragment();
        fTransaction.replace(R.id.fragment_container, frag);//.addToBackStack(null);
        if(backStack){ fTransaction.addToBackStack(null); }
        fTransaction.commit();
    }

    public static void fragmentJoinGroup(FragmentTransaction fTransaction){
        JoinGroupFragment frag = new JoinGroupFragment();
        fTransaction.replace(R.id.fragment_container, frag);//.addToBackStack(null);
        if(backStack){ fTransaction.addToBackStack(null); }
        fTransaction.commit();
    }

    public static void fragmentGetGroupMembers(FragmentTransaction fTransaction, int groupId, String groupName){
       /* Bundle bundle = new Bundle();
        bundle.putInt("groupId", groupId);
        bundle.putString("groupName", groupName);
        bundle.putInt("startingTab", startingTab);
        GroupTabFragment frag = new GroupTabFragment();
        frag.setArguments(bundle);
        fTransaction.replace(R.id.fragment_container, frag);//.addToBackStack(null);
        if(backStack){ fTransaction.addToBackStack(null); }
        fTransaction.commit(); */
        fragmentGroupTab(fTransaction, groupId, groupName, 1);
    }

    public static void fragmentGroupTab(FragmentTransaction fTransaction, int groupId, String groupName, int startingTab){
        Bundle bundle = new Bundle();
        bundle.putInt("groupId", groupId);
        bundle.putString("groupName", groupName);
        bundle.putInt("startingTab", startingTab);
        GroupTabFragment frag = new GroupTabFragment();
        frag.setArguments(bundle);
        fTransaction.replace(R.id.fragment_container, frag);//.addToBackStack(null);
        if(backStack){ fTransaction.addToBackStack(null); }
        fTransaction.commit();
    }

}
