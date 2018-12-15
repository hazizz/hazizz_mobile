package com.indeed.hazizz;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentActivity;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentTransaction;
import android.util.Log;

import com.indeed.hazizz.Activities.AuthActivity;
import com.indeed.hazizz.Activities.FeedbackActivity;
import com.indeed.hazizz.Activities.MainActivity;
import com.indeed.hazizz.Fragments.AuthFrags.FirstFragment;
import com.indeed.hazizz.Fragments.AuthFrags.LoginFragment;
import com.indeed.hazizz.Fragments.AuthFrags.RegisterFragment;
import com.indeed.hazizz.Fragments.ChatFragment;
import com.indeed.hazizz.Fragments.CommentSectionFragment;
import com.indeed.hazizz.Fragments.AnnouncementEditorFragment;
import com.indeed.hazizz.Fragments.CreateGroupFragment;
import com.indeed.hazizz.Fragments.CreateSubjectFragment;
import com.indeed.hazizz.Fragments.TaskEditorFragment;
import com.indeed.hazizz.Fragments.GroupTabs.GroupTabFragment;

import com.indeed.hazizz.Fragments.JoinGroupFragment;
import com.indeed.hazizz.Fragments.MainTab.GroupsFragment;
import com.indeed.hazizz.Fragments.MainTab.MainTabFragment;
import com.indeed.hazizz.Fragments.ViewAnnouncementFragment;
import com.indeed.hazizz.Fragments.ViewTaskFragment;

public abstract class Transactor extends FragmentActivity {
    private static boolean backStack = true;

    private static Fragment frag;

    public static Fragment getCurrentFragment(FragmentManager fManager, boolean asd){
        Fragment currentF = fManager.findFragmentById(R.id.fragment_container);
        if(asd){
            return fManager.findFragmentById(R.id.fragment_container);
        }
        if(currentF instanceof GroupTabFragment){
          //  currentFrag = ;
            return ((GroupTabFragment) currentF).getCurrentFrag();
        }
        if(currentF instanceof MainTabFragment){
            //  currentFrag = ;
            return ((MainTabFragment) currentF).getCurrentFrag();
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
        fragmentMainTab(fTransaction, 0);
    }
    public static void fragmentGroups(FragmentTransaction fTransaction){
        Fragment frag = new GroupsFragment();
        fTransaction.replace(R.id.fragment_container, frag);
        fTransaction.commit();
      // fragmentMainTab(fTransaction, 2);
    }
    public static void fragmentMainGroup(FragmentTransaction fTransaction, int groupId, String groupName){
        fragmentGroupTab(fTransaction, groupId, groupName, 0);
    }
    public static void fragmentViewTask(FragmentTransaction fTransaction, int groupId, int taskId, String groupName, boolean goBackToMain, int dest){
        Manager.DestManager.setDest(dest);

        Bundle bundle = new Bundle();
        bundle.putInt("groupId", groupId);
        bundle.putInt("taskId", taskId);
        bundle.putString("groupName", groupName);
        bundle.putBoolean("goBackToMain", goBackToMain);
        ViewTaskFragment frag = new ViewTaskFragment();
        frag.setArguments(bundle);
        fTransaction.replace(R.id.fragment_container, frag);//.addToBackStack(null);
        if(backStack){ fTransaction.addToBackStack(null); }
        fTransaction.commit();
    }
    public static void fragmentCreateTask(FragmentTransaction fTransaction, int groupId, String groupName){
        Bundle bundle = new Bundle();
        bundle.putInt("groupId", groupId);
        bundle.putInt("groupId", groupId);
        bundle.putString("groupName", groupName);
        TaskEditorFragment frag = new TaskEditorFragment();
        frag.setArguments(bundle);
        fTransaction.replace(R.id.fragment_container, frag);//.addToBackStack(null);
        if(backStack){ fTransaction.addToBackStack(null); }
        fTransaction.commit();
    }

    public static void fragmentEditTask(FragmentTransaction fTransaction, int groupId, String groupName,
                                        int taskId, String groupType, int taskSubjectId, String taskTitle,
                                        String taskDescription, int[] date){
        Bundle bundle = new Bundle();
        bundle.putInt("taskId", taskId);
        bundle.putInt("groupId", groupId);
        bundle.putString("groupName", groupName);
        bundle.putString("type", groupType);
        bundle.putInt("subject", taskSubjectId);
        bundle.putString("title", taskTitle);
        bundle.putString("description", taskDescription);
        bundle.putIntArray("date", date);
        TaskEditorFragment frag = new TaskEditorFragment();
        frag.setArguments(bundle);
        fTransaction.replace(R.id.fragment_container, frag);//.addToBackStack(null);
        if(backStack){ fTransaction.addToBackStack(null); }
        fTransaction.commit();
    }

    public static void fragmentCreateAnnouncement(FragmentTransaction fTransaction, int groupId, String groupName){
        Bundle bundle = new Bundle();
        bundle.putInt("groupId", groupId);
        bundle.putString("groupName", groupName);
        AnnouncementEditorFragment frag = new AnnouncementEditorFragment();
        frag.setArguments(bundle);
        fTransaction.replace(R.id.fragment_container, frag);//.addToBackStack(null);
        if(backStack){ fTransaction.addToBackStack(null); }
        fTransaction.commit();
    }

    public static void fragmentEditAnnouncement(FragmentTransaction fTransaction, int groupId, int announcementId, String groupName, String title, String description){
        Bundle bundle = new Bundle();
        bundle.putInt("announcementId", announcementId);
        bundle.putInt("groupId", groupId);
        bundle.putString("groupName", groupName);
        bundle.putString("title", title);
        bundle.putString("description", description);
        AnnouncementEditorFragment frag = new AnnouncementEditorFragment();
        frag.setArguments(bundle);
        fTransaction.replace(R.id.fragment_container, frag);//.addToBackStack(null);
        if(backStack){ fTransaction.addToBackStack(null); }
        fTransaction.commit();

    }



    public static void fragmentViewAnnouncement(FragmentTransaction fTransaction, int groupId, int announcementId, String groupName, boolean goBackToMain, int dest){
        Manager.DestManager.setDest(dest);

        Bundle bundle = new Bundle();
        bundle.putInt("groupId", groupId);
        bundle.putInt("announcementId", announcementId);
        bundle.putString("groupName", groupName);
        bundle.putBoolean("goBackToMain", goBackToMain);
        ViewAnnouncementFragment frag = new ViewAnnouncementFragment();
        frag.setArguments(bundle);
        fTransaction.replace(R.id.fragment_container, frag);
        if(backStack){ fTransaction.addToBackStack(null); }
        fTransaction.commit();
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
        fTransaction.replace(R.id.fragment_container, frag);
        if(backStack){ fTransaction.addToBackStack(null); }
        fTransaction.commit();
    }


    public static void fragmentSubjects(FragmentTransaction fTransaction, int groupId, String groupName){
    /*    Bundle bundle = new Bundle();
        frag = new SubjectsFragment();
        frag.setArguments(bundle);
        fTransaction.replace(R.id.fragment_container, frag);
        if(backStack){ fTransaction.addToBackStack(null); }
        fTransaction.commit(); */
        fragmentGroupTab(fTransaction, groupId, groupName, 2);
    }

    public static void fragmentCreateGroup(FragmentTransaction fTransaction){
        CreateGroupFragment frag = new CreateGroupFragment();
        fTransaction.replace(R.id.fragment_container, frag);
        if(backStack){ fTransaction.addToBackStack(null); }
        fTransaction.commit();
    }

    public static void fragmentJoinGroup(FragmentTransaction fTransaction){
        JoinGroupFragment frag = new JoinGroupFragment();
        fTransaction.replace(R.id.fragment_container, frag);
        if(backStack){ fTransaction.addToBackStack(null); }
        fTransaction.commit();
    }

    public static void fragmentGetGroupMembers(FragmentTransaction fTransaction, int groupId, String groupName){
        fragmentGroupTab(fTransaction, groupId, groupName, 3);
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

    public static void fragmentMainTab(FragmentTransaction fTransaction,int startingTab){
        Bundle bundle = new Bundle();
        bundle.putInt("startingTab", startingTab);
        MainTabFragment frag = new MainTabFragment();
        frag.setArguments(bundle);
        fTransaction.replace(R.id.fragment_container, frag);//.addToBackStack(null);
        if(backStack){ fTransaction.addToBackStack(null); }
        fTransaction.commit();
    }

    public static void fragmentCommentSection(FragmentTransaction fTransaction, int commentId){
        Bundle bundle = new Bundle();
        Log.e("hey", "id1.1 : " + commentId);
        bundle.putString("commentId", Integer.toString(commentId));
        Log.e("hey", "id1.2 : " + Integer.toString(commentId));
        CommentSectionFragment frag = new CommentSectionFragment();
        frag.setArguments(bundle);
        fTransaction.replace(R.id.fragment_container, frag);//.addToBackStack(null);
        if(backStack){ fTransaction.addToBackStack(null); }
        fTransaction.commit();
    }


    public static void fragmentGroupAnnouncement(FragmentTransaction fTransaction, int groupId, String groupName){
        fragmentGroupTab(fTransaction, groupId, groupName, 1);
    }
    public static void fragmentMainAnnouncement(FragmentTransaction fTransaction){
        fragmentMainTab(fTransaction,1);
    }
    public static void fragmentGroupTask(FragmentTransaction fTransaction, int groupId, String groupName){
        fragmentGroupTab(fTransaction, groupId, groupName, 0);
    }
    public static void fragmentMainTask(FragmentTransaction fTransaction){
        fragmentMainTab(fTransaction,0);
    }


    public static void feedbackActivity(Activity thisActivity){ //, Fragment goBackFragment){
        Intent i = new Intent(thisActivity, FeedbackActivity.class);
        thisActivity.startActivity(i);
    }

    public static void AuthActivity(Activity thisActivity){
        Intent i = new Intent(thisActivity, AuthActivity.class);
        thisActivity.startActivity(i);
    }

    public static void activityMain(Activity thisActivity){
        Intent i = new Intent(thisActivity, MainActivity.class);
        thisActivity.startActivity(i);
    }
}
