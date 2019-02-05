package com.hazizz.droid;

import android.app.Activity;
import android.app.Dialog;
import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.v4.app.DialogFragment;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentActivity;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentTransaction;

import com.hazizz.droid.Activities.AuthActivity;
import com.hazizz.droid.Activities.FeedbackActivity;
import com.hazizz.droid.Activities.MainActivity;
import com.hazizz.droid.Communication.POJO.Response.PojoType;
import com.hazizz.droid.Communication.Strings;
import com.hazizz.droid.Fragments.ATChooserFragment;
import com.hazizz.droid.Fragments.AnnouncementEditorFragment;
import com.hazizz.droid.Fragments.AuthFrags.FirstFragment;
import com.hazizz.droid.Fragments.AuthFrags.LoginFragment;
import com.hazizz.droid.Fragments.AuthFrags.RegisterFragment;
import com.hazizz.droid.Fragments.ChatFragment;
import com.hazizz.droid.Fragments.CommentSectionFragment;
import com.hazizz.droid.Fragments.CreateGroupFragment;
import com.hazizz.droid.Fragments.CreateSubjectFragment;
import com.hazizz.droid.Fragments.Dialog.DateViewerDialogFragment;
import com.hazizz.droid.Fragments.Dialog.UserDetailDialogFragment;
import com.hazizz.droid.Fragments.GroupTabs.GroupTabFragment;
import com.hazizz.droid.Fragments.JoinGroupFragment;
import com.hazizz.droid.Fragments.MainTab.GroupsFragment;
import com.hazizz.droid.Fragments.MainTab.MainTabFragment;
import com.hazizz.droid.Fragments.Options.MainOptionsFragment;
import com.hazizz.droid.Fragments.Options.PasswordFragment;
import com.hazizz.droid.Fragments.TaskEditorFragment;
import com.hazizz.droid.Fragments.ThéraFrags.Setup.ThChooseSchool;
import com.hazizz.droid.Fragments.ViewAnnouncementFragment;
import com.hazizz.droid.Fragments.ViewTaskFragment;
import com.hazizz.droid.R;

import javax.annotation.Nonnull;

public abstract class Transactor extends FragmentActivity {
    private static boolean backStack = true;


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

    public static void fragmentDialogShowUserDetailDialog(@Nonnull FragmentTransaction fTransaction, long userId, String userProfilePic){
        Bundle bundle = new Bundle();
        bundle.putLong(Strings.Path.USERID.toString(), userId);
        bundle.putString(Strings.Other.PROFILEPIC.toString(), userProfilePic);
        DialogFragment dialogFragment = new UserDetailDialogFragment();
        dialogFragment.setArguments(bundle);
        dialogFragment.show(fTransaction, "dialog");

    }

    public static void fragmentDialogDateViewer(@Nonnull FragmentTransaction fTransaction, String date){
        Bundle bundle = new Bundle();
        bundle.putString("date", date);
        DialogFragment dialogFragment = new DateViewerDialogFragment();
        dialogFragment.setArguments(bundle);
        dialogFragment.show(fTransaction, "dialog");

    }



    public static void fragmentFirst(@Nonnull FragmentTransaction fTransaction){
        FirstFragment frag = new FirstFragment();
        fTransaction.replace(R.id.fragment_container, frag);//.addToBackStack(null);
        if(backStack){ fTransaction.addToBackStack(null); }
        fTransaction.commit();
    }

    public static void fragmentRegister(@Nonnull FragmentTransaction fTransaction){
        RegisterFragment frag = new RegisterFragment();
        fTransaction.replace(R.id.fragment_container, frag);//.addToBackStack(null);
        if(backStack){ fTransaction.addToBackStack(null); }
        fTransaction.commit();
    }
    public static void fragmentLogin(@Nonnull FragmentTransaction fTransaction){
        LoginFragment frag = new LoginFragment();
        fTransaction.replace(R.id.fragment_container, frag);//.addToBackStack(null);
        if(backStack){ fTransaction.addToBackStack(null); }
        fTransaction.commit();
    }

    public static void fragmentPassword(@Nonnull FragmentTransaction fTransaction){
        PasswordFragment frag = new PasswordFragment();
        fTransaction.replace(R.id.fragment_container, frag);//.addToBackStack(null);
        if(backStack){ fTransaction.addToBackStack(null); }
        fTransaction.commit();
    }

    public static void fragmentOptions(@Nonnull FragmentTransaction fTransaction){
        Bundle bundle = new Bundle();
        Fragment frag = new MainOptionsFragment();
        frag.setArguments(bundle);
        fTransaction.replace(R.id.fragment_container, frag);//.addToBackStack(null);
        if(backStack){ fTransaction.addToBackStack(null); }
        fTransaction.commit();
    }


    public static void fragmentMain(@Nonnull FragmentTransaction fTransaction){
        fragmentMainTab(fTransaction, 0);
    }
    public static void fragmentGroups(@NonNull FragmentTransaction fTransaction){
        Fragment frag = new GroupsFragment();
        fTransaction.replace(R.id.fragment_container, frag);
        fTransaction.commit();
      // fragmentMainTab(fTransaction, 2);
    }
    public static void fragmentMainGroup(@Nonnull FragmentTransaction fTransaction, int groupId, String groupName){
        fragmentGroupTab(fTransaction, groupId, groupName, 0);
    }


    public static void fragmentToATChooser(@Nonnull FragmentTransaction fTransaction, int where){
        Manager.DestManager.setDest(where);
        fragmentGroups(fTransaction);
    }

    public static void fragmentATChooser(@Nonnull FragmentTransaction fTransaction){
       // Manager.GroupManager.setGroupId(groupId);Manager.GroupManager.setGroupName(groupName);
        Fragment frag = new ATChooserFragment();
        fTransaction.replace(R.id.fragment_container, frag);
        fTransaction.commit();
    }


    public static void fragmentViewTask(@Nonnull FragmentTransaction fTransaction,
                                        int taskId, boolean goBackToMain, int dest){
        Manager.DestManager.setDest(dest);

        Bundle bundle = new Bundle();
        bundle.putInt(Strings.Path.TASKID.toString(), taskId);
        bundle.putBoolean("goBackToMain", goBackToMain);
        ViewTaskFragment frag = new ViewTaskFragment();
        frag.setArguments(bundle);
        fTransaction.replace(R.id.fragment_container, frag);//.addToBackStack(null);
        if(backStack){ fTransaction.addToBackStack(null); }
        fTransaction.commit();
    }
    public static void fragmentCreateTask(@Nonnull FragmentTransaction fTransaction, int groupId, String groupName, int dest){
        Manager.DestManager.setDest(dest);
        Bundle bundle = new Bundle();
        bundle.putInt(Strings.Path.GROUPID.toString(), groupId);
        bundle.putString("groupName", groupName);
        TaskEditorFragment frag = new TaskEditorFragment();
        frag.setArguments(bundle);
        fTransaction.replace(R.id.fragment_container, frag);//.addToBackStack(null);
        if(backStack){ fTransaction.addToBackStack(null); }
        fTransaction.commit();
    }

    public static void fragmentEditTask(@Nonnull FragmentTransaction fTransaction, int groupId, String groupName,
                                        int taskId, PojoType type, int taskSubjectId, String subjectName, String taskTitle,
                                        String taskDescription, String date, int dest){
        Manager.DestManager.setDest(dest);
        Bundle bundle = new Bundle();
        bundle.putInt("taskId", taskId);
        bundle.putInt(Strings.Path.GROUPID.toString(), groupId);
        bundle.putString("groupName", groupName);
      //  bundle.putString("typeName", type.getName());
        bundle.putLong("typeId", type.getId());
        bundle.putString("typeName", type.getName());
        bundle.putInt("subjectId", taskSubjectId);
        bundle.putString("subjectName", subjectName);
        bundle.putString("title", taskTitle);
        bundle.putString("description", taskDescription);
        bundle.putString("date", date);
        TaskEditorFragment frag = new TaskEditorFragment();
        frag.setArguments(bundle);
        fTransaction.replace(R.id.fragment_container, frag);
        if(backStack){ fTransaction.addToBackStack(null); }
        fTransaction.commit();
    }

    public static void fragmentCreateAnnouncement(@Nonnull FragmentTransaction fTransaction, int groupId, String groupName, int dest){
        Manager.DestManager.setDest(dest);
        Bundle bundle = new Bundle();
        bundle.putInt(Strings.Path.GROUPID.toString(), groupId);
        bundle.putString("groupName", groupName);
        AnnouncementEditorFragment frag = new AnnouncementEditorFragment();
        frag.setArguments(bundle);
        fTransaction.replace(R.id.fragment_container, frag);//.addToBackStack(null);
        if(backStack){ fTransaction.addToBackStack(null); }
        fTransaction.commit();
    }

    public static void fragmentEditAnnouncement(@Nonnull FragmentTransaction fTransaction, int groupId, int announcementId, String groupName, String title, String description, int dest){
        Manager.DestManager.setDest(dest);
        Bundle bundle = new Bundle();
        bundle.putInt("announcementId", announcementId);
        bundle.putInt(Strings.Path.GROUPID.toString(), groupId);
        bundle.putString("groupName", groupName);
        bundle.putString("title", title);
        bundle.putString("description", description);
        AnnouncementEditorFragment frag = new AnnouncementEditorFragment();
        frag.setArguments(bundle);
        fTransaction.replace(R.id.fragment_container, frag);//.addToBackStack(null);
        if(backStack){ fTransaction.addToBackStack(null); }
        fTransaction.commit();
    }



    public static void fragmentViewAnnouncement(@Nonnull FragmentTransaction fTransaction,int announcementId,
                                                 boolean goBackToMain, int dest){
        Manager.DestManager.setDest(dest);

        Bundle bundle = new Bundle();
        bundle.putInt(Strings.Path.ANNOUNCEMENTID.toString(), announcementId);
        bundle.putBoolean("goBackToMain", goBackToMain);
        ViewAnnouncementFragment frag = new ViewAnnouncementFragment();
        frag.setArguments(bundle);
        fTransaction.replace(R.id.fragment_container, frag);
        if(backStack){ fTransaction.addToBackStack(null); }
        fTransaction.commit();
    }

    public static void fragmentChat(@Nonnull FragmentTransaction fTransaction){
        ChatFragment frag = new ChatFragment();
        fTransaction.replace(R.id.fragment_container, frag);
        if(backStack){ fTransaction.addToBackStack(null); }
        fTransaction.commit();
    }

    public static void fragmentCreateSubject(@Nonnull FragmentTransaction fTransaction, int groupId, String groupName){
        Bundle bundle = new Bundle();
        CreateSubjectFragment frag = new CreateSubjectFragment();
        bundle.putInt(Strings.Path.GROUPID.toString(), groupId);
        bundle.putString("groupName", groupName);
        frag.setArguments(bundle);
        fTransaction.replace(R.id.fragment_container, frag);
        if(backStack){ fTransaction.addToBackStack(null); }
        fTransaction.commit();
    }


    public static void fragmentSubjects(@Nonnull FragmentTransaction fTransaction, int groupId, String groupName){
    /*    Bundle bundle = new Bundle();
        frag = new SubjectsFragment();
        frag.setArguments(bundle);
        fTransaction.replace(R.id.fragment_container, frag);
        if(backStack){ fTransaction.addToBackStack(null); }
        fTransaction.commit(); */
        fragmentGroupTab(fTransaction, groupId, groupName, 2);
    }

    public static void fragmentCreateGroup(@Nonnull FragmentTransaction fTransaction){
        CreateGroupFragment frag = new CreateGroupFragment();
        fTransaction.replace(R.id.fragment_container, frag);
        if(backStack){ fTransaction.addToBackStack(null); }
        fTransaction.commit();
    }

    public static void fragmentJoinGroup(@Nonnull FragmentTransaction fTransaction){
        JoinGroupFragment frag = new JoinGroupFragment();
        fTransaction.replace(R.id.fragment_container, frag);
        if(backStack){ fTransaction.addToBackStack(null); }
        fTransaction.commit();
    }

    public static void fragmentGetGroupMembers(@Nonnull FragmentTransaction fTransaction, int groupId, String groupName){
        fragmentGroupTab(fTransaction, groupId, groupName, 3);
    }

    public static void fragmentGroupTab(@Nonnull FragmentTransaction fTransaction, int groupId, String groupName, int startingTab){
        Bundle bundle = new Bundle();
        bundle.putInt(Strings.Path.GROUPID.toString(), groupId);
        bundle.putString("groupName", groupName);
        bundle.putInt("startingTab", startingTab);
        GroupTabFragment frag = new GroupTabFragment();
        frag.setArguments(bundle);
        fTransaction.replace(R.id.fragment_container, frag);//.addToBackStack(null);
        if(backStack){ fTransaction.addToBackStack(null); }
        fTransaction.commit();
    }

    public static void fragmentMainTab(@Nonnull FragmentTransaction fTransaction,int startingTab){
        Bundle bundle = new Bundle();
        bundle.putInt("startingTab", startingTab);
        MainTabFragment frag = new MainTabFragment();
        frag.setArguments(bundle);
        fTransaction.replace(R.id.fragment_container, frag);//.addToBackStack(null);
        if(backStack){ fTransaction.addToBackStack(null); }
        fTransaction.commit();
    }

    public static void fragmentCommentSection(@Nonnull FragmentTransaction fTransaction, String whereName, int whereId){
        Bundle bundle = new Bundle();
        bundle.putString(Strings.Path.WHERENAME.toString(), whereName);
        bundle.putInt(Strings.Path.WHEREID.toString(), whereId);

        CommentSectionFragment frag = new CommentSectionFragment();
        frag.setArguments(bundle);
        fTransaction.replace(R.id.fragment_container, frag);
        if(backStack){ fTransaction.addToBackStack(null); }
        fTransaction.commit();
    }

    public static void fragmentComments(@Nonnull FragmentTransaction fTransaction, String whereName,int whereId){
        Bundle bundle = new Bundle();
        bundle.putString(Strings.Path.WHERENAME.toString(), whereName);
        bundle.putInt(Strings.Path.WHEREID.toString(), whereId);
        CommentSectionFragment frag = new CommentSectionFragment();
        frag.setArguments(bundle);
        fTransaction.replace(R.id.fragment_container, frag);
        if(backStack){fTransaction.addToBackStack(null);}
        fTransaction.commit();
    }


    public static void fragmentGroupAnnouncement(@Nonnull FragmentTransaction fTransaction, int groupId, String groupName){
        fragmentGroupTab(fTransaction, groupId, groupName, 1);
    }
    public static void fragmentMainAnnouncement(@Nonnull FragmentTransaction fTransaction){
        fragmentMainTab(fTransaction,1);
    }
    public static void fragmentGroupTask(@Nonnull FragmentTransaction fTransaction, int groupId, String groupName){
        fragmentGroupTab(fTransaction, groupId, groupName, 0);
    }
    public static void fragmentMainTask(@Nonnull FragmentTransaction fTransaction){
        fragmentMainTab(fTransaction,0);
    }


    public static void fragmentThSchool(@Nonnull FragmentTransaction fTransaction){
        ThChooseSchool frag = new ThChooseSchool();
        fTransaction.replace(R.id.fragment_container, frag);
        if(backStack){fTransaction.addToBackStack(null);}
        fTransaction.commit();
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
