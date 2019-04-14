package com.hazizz.droid;

import android.app.Activity;
import android.content.Context;
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
import com.hazizz.droid.Fragments.CommentSectionFragment;
import com.hazizz.droid.Fragments.CreateGroupFragment;
import com.hazizz.droid.Fragments.CreateSubjectFragment;
import com.hazizz.droid.Fragments.Dialog.DateViewerDialogFragment;
import com.hazizz.droid.Fragments.Dialog.InviteLinkDialogFragment;
import com.hazizz.droid.Fragments.Dialog.ManageSubjectDialog;
import com.hazizz.droid.Fragments.Dialog.ThClassViewerDialogFragment;
import com.hazizz.droid.Fragments.Dialog.ThGreadeViewerDialogFragment;
import com.hazizz.droid.Fragments.Dialog.UserDetailDialogFragment;
import com.hazizz.droid.Fragments.GroupTabs.GroupTabFragment;
import com.hazizz.droid.Fragments.JoinGroupFragment;
import com.hazizz.droid.Fragments.LogFragment;
import com.hazizz.droid.Fragments.MainTab.GroupsFragment;
import com.hazizz.droid.Fragments.MainTab.MainTabFragment;
import com.hazizz.droid.Fragments.MyTasksFragment;
import com.hazizz.droid.Fragments.Options.MainOptionsFragment;
import com.hazizz.droid.Fragments.Options.NotificationSettingsFragment;
import com.hazizz.droid.Fragments.Options.PasswordFragment;
import com.hazizz.droid.Fragments.Options.ServerSettingsFragment;
import com.hazizz.droid.Fragments.TaskEditorFragment;
import com.hazizz.droid.Fragments.ThéraFrags.Setup.TheraGradesFragment;
import com.hazizz.droid.Fragments.ThéraFrags.Setup.TheraLoadingFragment;
import com.hazizz.droid.Fragments.ThéraFrags.Setup.TheraLoginFragment;
import com.hazizz.droid.Fragments.ThéraFrags.Setup.TheraMainFragment;
import com.hazizz.droid.Fragments.ThéraFrags.Setup.TheraSchedulesFragment;
import com.hazizz.droid.Fragments.ThéraFrags.Setup.TheraUsersFragment;
import com.hazizz.droid.Fragments.ViewAnnouncementFragment;
import com.hazizz.droid.Fragments.ViewTaskFragment;
import com.hazizz.droid.Listviews.TheraGradesList.TheraGradesItem;
import com.hazizz.droid.Listviews.TheraReturnSchedules.ClassItem;

import javax.annotation.Nonnull;

public class Transactor extends FragmentActivity {
    private static boolean backStack = true;

    public static final String KEY_GROUPID = Strings.Path.GROUPID.toString();
    public static final String KEY_SUBJECTID = Strings.Path.SUBJECTID.toString();
    public static final String KEY_TASKID = Strings.Path.TASKID.toString();
    public static final String KEY_ANNOUNCEMENTID = Strings.Path.ANNOUNCEMENTID.toString();
    public static final String KEY_TYPEID = "typeId";
    public static final String KEY_USERID = Strings.Path.USERID.toString();
    public static final String KEY_RANK = "rank";
    public static final String KEY_DATE = "date";
    public static final String KEY_GROUPNAME = "groupName";
    public static final String KEY_SUBJECTNAME = "subjectName";
    public static final String KEY_TYPENAME = "typeName";
    public static final String KEY_WHERE = "where";
    public static final String KEY_TYPE = "type";
    public static final String KEY_DEST = "dest";
    public static final String KEY_MODE = "mode";
    public static final String KEY_TITLE = "title";
    public static final String KEY_DESCRIPTION = "description";

    public static final String KEY_STARTINGTAB = "startingTab";
    public static final String KEY_GOBACKTOMAIN = "goBackToMain";
    public static final String KEY_CURRENTSUBJECTNAME = "currentSubjectName";


    public static Fragment getCurrentFragment(FragmentManager fManager, boolean absolute){
        Fragment currentF = fManager.findFragmentById(R.id.fragment_container);
        if(absolute){
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

    public static void fragmentDialogInviteLink(@Nonnull FragmentTransaction fTransaction, long groupId, String groupName){
        Bundle bundle = new Bundle();
        bundle.putLong(KEY_GROUPID, groupId);
        bundle.putString(KEY_GROUPNAME, groupName);

        DialogFragment dialogFragment = new InviteLinkDialogFragment();
        dialogFragment.setArguments(bundle);
        dialogFragment.show(fTransaction, "dialog");
    }

    public static void fragmentThDialogClass(@Nonnull FragmentTransaction fTransaction, ClassItem classItem){
        Bundle bundle = new Bundle();
        bundle.putParcelable("class", classItem);

        DialogFragment dialogFragment = new ThClassViewerDialogFragment();
        dialogFragment.setArguments(bundle);
        dialogFragment.show(fTransaction, "dialog");
    }

    public static void fragmentThDialogGrade(@Nonnull FragmentTransaction fTransaction, TheraGradesItem gradeItem){
        Bundle bundle = new Bundle();
        bundle.putParcelable("grade", gradeItem);

        DialogFragment dialogFragment = new ThGreadeViewerDialogFragment();
        dialogFragment.setArguments(bundle);
        dialogFragment.show(fTransaction, "dialog");
    }

    public static void fragmentThDialogGrade(@Nonnull FragmentManager fragmentManager, TheraGradesItem gradeItem){
        Bundle bundle = new Bundle();
        bundle.putParcelable("grade", gradeItem);

        DialogFragment dialogFragment = new ThGreadeViewerDialogFragment();
        dialogFragment.setArguments(bundle);
        dialogFragment.show(fragmentManager.beginTransaction(), "dialog");
    }

    public static void fragmentDialogManageSubject(@Nonnull FragmentTransaction fTransaction, long groupId, long subjectId, String currentSubjectName){
        Bundle bundle = new Bundle();
        bundle.putLong(KEY_GROUPID, groupId);
        bundle.putLong(KEY_SUBJECTID, subjectId);
        bundle.putString(KEY_CURRENTSUBJECTNAME, currentSubjectName);

        DialogFragment dialogFragment = new ManageSubjectDialog();
        dialogFragment.setArguments(bundle);
        dialogFragment.show(fTransaction, "dialog");

    }

    public static void fragmentDialogShowUserDetailDialog(@Nonnull FragmentTransaction fTransaction, long userId, int userRank, String userProfilePic){
        Bundle bundle = new Bundle();
        bundle.putLong(KEY_USERID, userId);
        bundle.putString(Strings.Other.PROFILEPIC.toString(), userProfilePic);
        bundle.putInt(KEY_RANK, userRank);
        DialogFragment dialogFragment = new UserDetailDialogFragment();
        dialogFragment.setArguments(bundle);
        dialogFragment.show(fTransaction, "dialog");
    }


    public static void fragmentDialogDateViewer(@Nonnull FragmentTransaction fTransaction, String date){
        Bundle bundle = new Bundle();
        bundle.putString(KEY_DATE , date);
        DialogFragment dialogFragment = new DateViewerDialogFragment();
        dialogFragment.setArguments(bundle);
        dialogFragment.show(fTransaction, "dialog");

    }


    public static void fragmentLogs(@Nonnull FragmentTransaction fTransaction){
        LogFragment frag = new LogFragment();
        fTransaction.replace(R.id.fragment_container, frag);//.addToBackStack(null);
        if(backStack){ fTransaction.addToBackStack(null); }
        fTransaction.commitAllowingStateLoss();
    }

    public static void fragmentFirst(@Nonnull FragmentTransaction fTransaction){
        FirstFragment frag = new FirstFragment();
        fTransaction.replace(R.id.fragment_container, frag);//.addToBackStack(null);
        if(backStack){ fTransaction.addToBackStack(null); }
        fTransaction.commitAllowingStateLoss();
    }

    public static void fragmentRegister(@Nonnull FragmentTransaction fTransaction){
        RegisterFragment frag = new RegisterFragment();
        fTransaction.replace(R.id.fragment_container, frag);//.addToBackStack(null);
        if(backStack){ fTransaction.addToBackStack(null); }
        fTransaction.commitAllowingStateLoss();
    }
    public static void fragmentLogin(@Nonnull FragmentTransaction fTransaction){
        LoginFragment frag = new LoginFragment();
        fTransaction.replace(R.id.fragment_container, frag);//.addToBackStack(null);
        if(backStack){ fTransaction.addToBackStack(null); }
        fTransaction.commitAllowingStateLoss();
    }

    public static void fragmentPassword(@Nonnull FragmentTransaction fTransaction){
        PasswordFragment frag = new PasswordFragment();
        fTransaction.replace(R.id.fragment_container, frag);//.addToBackStack(null);
        if(backStack){ fTransaction.addToBackStack(null); }
        fTransaction.commitAllowingStateLoss();
    }

    public static void fragmentNotificationSettings(@Nonnull FragmentTransaction fTransaction){
        NotificationSettingsFragment frag = new NotificationSettingsFragment();
        fTransaction.replace(R.id.fragment_container, frag);
        fTransaction.commitAllowingStateLoss();
    }


    public static void fragmentServerSettings(@Nonnull FragmentTransaction fTransaction){
        ServerSettingsFragment frag = new ServerSettingsFragment();
        fTransaction.replace(R.id.fragment_container, frag);
        fTransaction.commitAllowingStateLoss();
    }

    public static void fragmentOptions(@Nonnull FragmentTransaction fTransaction){
        Bundle bundle = new Bundle();
        Fragment frag = new MainOptionsFragment();
        frag.setArguments(bundle);
        fTransaction.replace(R.id.fragment_container, frag);//.addToBackStack(null);
        if(backStack){ fTransaction.addToBackStack(null); }
        fTransaction.commitAllowingStateLoss();
    }


    public static void fragmentMain(@Nonnull FragmentTransaction fTransaction){
        fragmentMainTab(fTransaction, 0);
    }
    public static void fragmentGroups(@NonNull FragmentTransaction fTransaction){
        Fragment frag = new GroupsFragment();
        fTransaction.replace(R.id.fragment_container, frag);
        fTransaction.commitAllowingStateLoss();
      // fragmentMainTab(fTransaction, 2);
    }
    public static void fragmentMainGroup(@Nonnull FragmentTransaction fTransaction, int groupId, String groupName){
        fragmentGroupTab(fTransaction, groupId, groupName, 0);
    }

    public static void fragmentMainGroup(@Nonnull FragmentTransaction fTransaction, int groupId){
        fragmentGroupTab(fTransaction, groupId, "", 0);
    }


    public static void fragmentToATChooser(@Nonnull FragmentTransaction fTransaction, int where){
       //  Manager.DestManager.setDest(where);
       //  fragmentGroups(fTransaction);
        fragmentATChooser(fTransaction);
    }

    public static void fragmentATChooser(@Nonnull FragmentTransaction fTransaction){
       // Manager.GroupManager.setGroupId(groupId);Manager.GroupManager.setGroupName(groupName);
        Fragment frag = new ATChooserFragment();
        fTransaction.replace(R.id.fragment_container, frag);
        fTransaction.commitAllowingStateLoss();
    }

    public static void fragmentMyTasks(@Nonnull FragmentTransaction fTransaction){

        MyTasksFragment frag = new MyTasksFragment();
        fTransaction.replace(R.id.fragment_container, frag);
        fTransaction.commitAllowingStateLoss();
    }


    public static void fragmentViewTask(@Nonnull FragmentTransaction fTransaction,
                                        int taskId, boolean goBackToMain, Strings.Dest dest, boolean mode){

        Bundle bundle = new Bundle();
        bundle.putInt(KEY_DEST, dest.getValue());
        bundle.putInt(Strings.Path.TASKID.toString(), taskId);
        bundle.putBoolean(KEY_GOBACKTOMAIN, goBackToMain);
        bundle.putBoolean(KEY_MODE, mode);
        Fragment frag = new ViewTaskFragment();
        frag.setArguments(bundle);
        fTransaction.replace(R.id.fragment_container, frag);//.addToBackStack(null);
        if(backStack){ fTransaction.addToBackStack(null); }
        fTransaction.commitAllowingStateLoss();
    }


    public static void fragmentCreateMyTask(@Nonnull FragmentTransaction fTransaction){
        Bundle bundle = new Bundle();
        TaskEditorFragment frag = new TaskEditorFragment();
        bundle.putShort(KEY_WHERE, TaskEditorFragment.MYMODE);
        bundle.putShort(KEY_TYPE, TaskEditorFragment.CREATEMODE);
        frag.setArguments(bundle);
        fTransaction.replace(R.id.fragment_container, frag);//.addToBackStack(null);
        if(backStack){ fTransaction.addToBackStack(null); }
        fTransaction.commitAllowingStateLoss();
    }

    public static void fragmentEditMyTask(@Nonnull FragmentTransaction fTransaction){
        Bundle bundle = new Bundle();
        TaskEditorFragment frag = new TaskEditorFragment();
        bundle.putShort(KEY_WHERE, TaskEditorFragment.MYMODE);
        bundle.putShort(KEY_TYPE, TaskEditorFragment.EDITMODE);
        frag.setArguments(bundle);
        fTransaction.replace(R.id.fragment_container, frag);//.addToBackStack(null);
        if(backStack){ fTransaction.addToBackStack(null); }
        fTransaction.commitAllowingStateLoss();
    }

    public static void fragmentCreateTask(@Nonnull FragmentTransaction fTransaction, int groupId, String groupName, Strings.Dest dest){

        Bundle bundle = new Bundle();
        bundle.putInt(KEY_DEST, dest.getValue());
      //  Manager.GroupManager.setGroupId(groupId);
        bundle.putInt(Strings.Path.GROUPID.toString(), groupId);
        bundle.putString(KEY_GROUPNAME, groupName);
        bundle.putShort(KEY_WHERE, TaskEditorFragment.GROUPMODE);
        bundle.putShort(KEY_TYPE, TaskEditorFragment.CREATEMODE);
        TaskEditorFragment frag = new TaskEditorFragment();
        frag.setArguments(bundle);
        fTransaction.replace(R.id.fragment_container, frag);//.addToBackStack(null);
        if(backStack){ fTransaction.addToBackStack(null); }
        fTransaction.commitAllowingStateLoss();
    }

    public static void fragmentCreateTask(@Nonnull FragmentTransaction fTransaction, Strings.Dest dest){
      //  Manager.DestManager.setDest(dest);
        Bundle bundle = new Bundle();
        bundle.putInt(KEY_DEST, dest.getValue());

        TaskEditorFragment frag = new TaskEditorFragment();
        frag.setArguments(bundle);
        fTransaction.replace(R.id.fragment_container, frag);//.addToBackStack(null);
        if(backStack){ fTransaction.addToBackStack(null); }
        fTransaction.commitAllowingStateLoss();
    }

    public static void fragmentEditMyTask(@Nonnull FragmentTransaction fTransaction, int taskId, PojoType type,
                                          String taskTitle, String taskDescription, String date, Strings.Dest dest){
        Bundle bundle = new Bundle();
        bundle.putInt(KEY_DEST, dest.getValue());
        bundle.putShort(KEY_WHERE, TaskEditorFragment.GROUPMODE);
        bundle.putShort(KEY_TYPE, TaskEditorFragment.EDITMODE);
        bundle.putInt(KEY_TASKID, taskId);
        bundle.putLong(KEY_TYPEID, type.getId());
        bundle.putString(KEY_TYPENAME, type.getName());
        bundle.putString(KEY_TITLE, taskTitle);
        bundle.putString(KEY_DESCRIPTION, taskDescription);
        bundle.putString(KEY_DATE, date);
        TaskEditorFragment frag = new TaskEditorFragment();
        frag.setArguments(bundle);
        fTransaction.replace(R.id.fragment_container, frag);
        if(backStack){ fTransaction.addToBackStack(null); }
        fTransaction.commitAllowingStateLoss();
    }

    public static void fragmentEditTask(@Nonnull FragmentTransaction fTransaction, int groupId, String groupName,
                                        int taskId, PojoType type, int taskSubjectId, String subjectName, String taskTitle,
                                        String taskDescription, String date, Strings.Dest dest){
        Bundle bundle = new Bundle();
        bundle.putInt(KEY_DEST, dest.getValue());
        bundle.putShort(KEY_WHERE, TaskEditorFragment.GROUPMODE);
        bundle.putShort(KEY_TYPE, TaskEditorFragment.EDITMODE);
        bundle.putInt(KEY_TASKID, taskId);
        bundle.putInt(Strings.Path.GROUPID.toString(), groupId);
        bundle.putString(KEY_GROUPNAME, groupName);
        //  bundle.putString(KEY_TYPENAME, type.getName());
        bundle.putLong(KEY_TYPEID, type.getId());
        bundle.putString(KEY_TYPENAME, type.getName());
        bundle.putInt(KEY_SUBJECTID, taskSubjectId);
        bundle.putString(KEY_SUBJECTNAME, subjectName);
        bundle.putString(KEY_TITLE, taskTitle);
        bundle.putString(KEY_DESCRIPTION, taskDescription);
        bundle.putString(KEY_DATE, date);
        TaskEditorFragment frag = new TaskEditorFragment();
        frag.setArguments(bundle);
        fTransaction.replace(R.id.fragment_container, frag);
        if(backStack){ fTransaction.addToBackStack(null); }
        fTransaction.commitAllowingStateLoss();
    }


    public static void fragmentCreatorAT(@Nonnull FragmentTransaction fTransaction, GroupsFragment.Dest dest){
        Fragment frag = new GroupsFragment();
        Bundle bundle = new Bundle();
        bundle.putInt(KEY_DEST, dest.getValue());
        frag.setArguments(bundle);
        fTransaction.replace(R.id.fragment_container, frag);
        fTransaction.commitAllowingStateLoss();
    }

    public static void fragmentCreateAnnouncement(@Nonnull FragmentTransaction fTransaction, int groupId, String groupName, Strings.Dest dest){
        Bundle bundle = new Bundle();
        bundle.putInt(KEY_DEST, dest.getValue());
        bundle.putInt(Strings.Path.GROUPID.toString(), groupId);
        bundle.putString(KEY_GROUPNAME, groupName);
        AnnouncementEditorFragment frag = new AnnouncementEditorFragment();
        frag.setArguments(bundle);
        fTransaction.replace(R.id.fragment_container, frag);
        if(backStack){ fTransaction.addToBackStack(null); }
        fTransaction.commitAllowingStateLoss();
    }
    public static void fragmentCreateAnnouncement(@Nonnull FragmentTransaction fTransaction, Strings.Dest dest){
        AnnouncementEditorFragment frag = new AnnouncementEditorFragment();
        Bundle bundle = new Bundle();
        bundle.putInt(KEY_DEST, dest.getValue());
        frag.setArguments(bundle);
        fTransaction.replace(R.id.fragment_container, frag);//.addToBackStack(null);
        fTransaction.commitAllowingStateLoss();
    }

    public static void fragmentEditAnnouncement(@Nonnull FragmentTransaction fTransaction, int groupId, int announcementId, String groupName, String title, String description, Strings.Dest dest){

        Bundle bundle = new Bundle();
        bundle.putInt(KEY_DEST, dest.getValue());
        bundle.putInt(KEY_ANNOUNCEMENTID, announcementId);
        bundle.putInt(Strings.Path.GROUPID.toString(), groupId);
        bundle.putString(KEY_GROUPNAME, groupName);
        bundle.putString(KEY_TITLE, title);
        bundle.putString(KEY_DESCRIPTION, description);
        AnnouncementEditorFragment frag = new AnnouncementEditorFragment();
        frag.setArguments(bundle);
        fTransaction.replace(R.id.fragment_container, frag);//.addToBackStack(null);
        if(backStack){ fTransaction.addToBackStack(null); }
        fTransaction.commitAllowingStateLoss();
    }



    public static void fragmentViewAnnouncement(@Nonnull FragmentTransaction fTransaction,int announcementId,
                                                 boolean goBackToMain, Strings.Dest dest){
        Bundle bundle = new Bundle();
        bundle.putInt(KEY_DEST, dest.getValue());
        bundle.putInt(Strings.Path.ANNOUNCEMENTID.toString(), announcementId);
        bundle.putBoolean(KEY_GOBACKTOMAIN, goBackToMain);
        ViewAnnouncementFragment frag = new ViewAnnouncementFragment();
        frag.setArguments(bundle);
        fTransaction.replace(R.id.fragment_container, frag);
        if(backStack){ fTransaction.addToBackStack(null); }
        fTransaction.commitAllowingStateLoss();
    }


    public static void fragmentCreateSubject(@Nonnull FragmentTransaction fTransaction, int groupId, String groupName){
        Bundle bundle = new Bundle();
        CreateSubjectFragment frag = new CreateSubjectFragment();
        bundle.putInt(KEY_GROUPID, groupId);
        bundle.putString(KEY_GROUPNAME, groupName);
        frag.setArguments(bundle);
        fTransaction.replace(R.id.fragment_container, frag);
        if(backStack){ fTransaction.addToBackStack(null); }
        fTransaction.commitAllowingStateLoss();
    }


    public static void fragmentSubjects(@Nonnull FragmentTransaction fTransaction, int groupId, String groupName){
    /*    Bundle bundle = new Bundle();
        frag = new SubjectsFragment();
        frag.setArguments(bundle);
        fTransaction.replace(R.id.fragment_container, frag);
        if(backStack){ fTransaction.addToBackStack(null); }
        fTransaction.commitAllowingStateLoss(); */
        fragmentGroupTab(fTransaction, groupId, groupName, 2);
    }

    public static void fragmentCreateGroup(@Nonnull FragmentTransaction fTransaction){
        CreateGroupFragment frag = new CreateGroupFragment();
        fTransaction.replace(R.id.fragment_container, frag);
        if(backStack){ fTransaction.addToBackStack(null); }
        fTransaction.commitAllowingStateLoss();
    }

    public static void fragmentJoinGroup(@Nonnull FragmentTransaction fTransaction){
        JoinGroupFragment frag = new JoinGroupFragment();
        fTransaction.replace(R.id.fragment_container, frag);
        if(backStack){ fTransaction.addToBackStack(null); }
        fTransaction.commitAllowingStateLoss();
    }

    public static void fragmentGetGroupMembers(@Nonnull FragmentTransaction fTransaction, int groupId, String groupName){
        fragmentGroupTab(fTransaction, groupId, groupName, 3);
    }

    public static void fragmentGroupTab(@Nonnull FragmentTransaction fTransaction, int groupId, String groupName, int startingTab){
        Bundle bundle = new Bundle();
        bundle.putInt(Strings.Path.GROUPID.toString(), groupId);
        bundle.putString(KEY_GROUPNAME, groupName);
        bundle.putInt(KEY_STARTINGTAB, startingTab);
        GroupTabFragment frag = new GroupTabFragment();
        frag.setArguments(bundle);
        fTransaction.replace(R.id.fragment_container, frag);//.addToBackStack(null);
        if(backStack){ fTransaction.addToBackStack(null); }
        fTransaction.commitAllowingStateLoss();
    }

    public static void fragmentMainTab(@Nonnull FragmentTransaction fTransaction,int startingTab){
        Bundle bundle = new Bundle();
        bundle.putInt(KEY_STARTINGTAB, startingTab);
        MainTabFragment frag = new MainTabFragment();
        frag.setArguments(bundle);
        fTransaction.replace(R.id.fragment_container, frag);
        if(backStack){ fTransaction.addToBackStack(null); }
        fTransaction.commitAllowingStateLoss();
    }

    public static void fragmentCommentSection(@Nonnull FragmentTransaction fTransaction, String whereName, int whereId){
        Bundle bundle = new Bundle();
        bundle.putString(Strings.Path.WHERENAME.toString(), whereName);
        bundle.putInt(Strings.Path.WHEREID.toString(), whereId);

        CommentSectionFragment frag = new CommentSectionFragment();
        frag.setArguments(bundle);
        fTransaction.replace(R.id.fragment_container, frag);
        if(backStack){ fTransaction.addToBackStack(null); }
        fTransaction.commitAllowingStateLoss();
    }

    public static void fragmentComments(@Nonnull FragmentTransaction fTransaction, String whereName,int whereId){
        Bundle bundle = new Bundle();
        bundle.putString(Strings.Path.WHERENAME.toString(), whereName);
        bundle.putInt(Strings.Path.WHEREID.toString(), whereId);
        CommentSectionFragment frag = new CommentSectionFragment();
        frag.setArguments(bundle);
        fTransaction.replace(R.id.fragment_container, frag);
        if(backStack){fTransaction.addToBackStack(null);}
        fTransaction.commitAllowingStateLoss();
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


    public static void fragmentThLoading(@Nonnull FragmentTransaction fTransaction){
        TheraLoadingFragment frag = new TheraLoadingFragment();
        fTransaction.replace(R.id.fragment_container, frag);
        if(backStack){fTransaction.addToBackStack(null);}
        fTransaction.commitAllowingStateLoss();
    }

    public static void fragmentThLoginAuthSession(@Nonnull FragmentTransaction fTransaction, long session, String school, String username){
        Bundle bundle = new Bundle();
        bundle.putLong("sessionId", session);
        bundle.putString("school", school);
        bundle.putString("username", username);
        TheraLoginFragment frag = new TheraLoginFragment();
        frag.setArguments(bundle);

        fTransaction.replace(R.id.fragment_container, frag);
        if(backStack){fTransaction.addToBackStack(null);}
        fTransaction.commitAllowingStateLoss();
    }

    public static void fragmentThLogin(@Nonnull FragmentTransaction fTransaction){
        TheraLoginFragment frag = new TheraLoginFragment();
        fTransaction.replace(R.id.fragment_container, frag);
        if(backStack){fTransaction.addToBackStack(null);}
        fTransaction.commitAllowingStateLoss();
    }

    public static void fragmentThUsers(@Nonnull FragmentTransaction fTransaction){
        TheraUsersFragment frag = new TheraUsersFragment();
        fTransaction.replace(R.id.fragment_container, frag);
        if(backStack){fTransaction.addToBackStack(null);}
        fTransaction.commitAllowingStateLoss();
    }

    public static void fragmentThMain(@Nonnull FragmentTransaction fTransaction){
        TheraMainFragment frag = new TheraMainFragment();
        fTransaction.replace(R.id.fragment_container, frag);
        if(backStack){fTransaction.addToBackStack(null);}
        fTransaction.commitAllowingStateLoss();
    }
    public static void fragmentThMain(@Nonnull FragmentTransaction fTransaction, String username){
        TheraMainFragment frag = new TheraMainFragment();
        fTransaction.replace(R.id.fragment_container, frag);
        if(backStack){fTransaction.addToBackStack(null);}
        fTransaction.commitAllowingStateLoss();
    }


    public static void fragmentThSchedules(@Nonnull FragmentTransaction fTransaction){
        TheraSchedulesFragment frag = new TheraSchedulesFragment();
        fTransaction.replace(R.id.fragment_container, frag);
        if(backStack){fTransaction.addToBackStack(null);}
        fTransaction.commitAllowingStateLoss();
    }


    public static void fragmentThGrades(@Nonnull FragmentTransaction fTransaction){
        TheraGradesFragment frag = new TheraGradesFragment();
        fTransaction.replace(R.id.fragment_container, frag);
        if(backStack){fTransaction.addToBackStack(null);}
        fTransaction.commitAllowingStateLoss();
    }





    public static void feedbackActivity(Activity thisActivity){
        Intent i = new Intent(thisActivity, FeedbackActivity.class);
        thisActivity.startActivity(i);
    }

    public static void AuthActivity(Activity thisActivity){
        Intent i = new Intent(thisActivity, AuthActivity.class);
        thisActivity.startActivity(i);
    }

    public static void authActivity(Context context){
        Intent i = new Intent(context, AuthActivity.class);
        context.startActivity(i);
    }

    public static void activityMain(Activity thisActivity){
        Intent i = new Intent(thisActivity, MainActivity.class);
        thisActivity.startActivity(i);
    }
}
