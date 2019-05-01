package com.hazizz.droid.activities;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.Intent;
import android.graphics.Bitmap;
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import android.support.annotation.NonNull;
import android.support.design.widget.FloatingActionButton;
import android.support.design.widget.NavigationView;
import android.support.v4.app.Fragment;
import android.support.v4.view.GravityCompat;
import android.support.v4.widget.DrawerLayout;
import android.support.v7.app.ActionBarDrawerToggle;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.crashlytics.android.Crashlytics;
import com.crashlytics.android.answers.Answers;
import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.firebase.dynamiclinks.FirebaseDynamicLinks;
import com.google.firebase.dynamiclinks.PendingDynamicLinkData;
import com.hazizz.droid.other.AppInfo;
import com.hazizz.droid.cache.MeInfo.MeInfo;

import com.hazizz.droid.Communication.requests.GetMyProfilePic;
import com.hazizz.droid.Communication.requests.JoinGroup;
import com.hazizz.droid.Communication.requests.Me;
import com.hazizz.droid.Communication.requests.MessageOfTheDay;
import com.hazizz.droid.Communication.requests.parent.Request;
import com.hazizz.droid.Communication.Strings;
import com.hazizz.droid.Communication.responsePojos.CustomResponseHandler;
import com.hazizz.droid.Communication.responsePojos.PojoError;
import com.hazizz.droid.Communication.responsePojos.PojoMe;
import com.hazizz.droid.Communication.responsePojos.PojoPicSmall;
import com.hazizz.droid.converter.Converter;
import com.hazizz.droid.fragments.GroupTabs.GetGroupMembersFragment;
import com.hazizz.droid.fragments.GroupTabs.GroupAnnouncementFragment;
import com.hazizz.droid.fragments.GroupTabs.GroupMainFragment;
import com.hazizz.droid.fragments.GroupTabs.SubjectsFragment;
import com.hazizz.droid.fragments.MainTab.GroupsFragment;
import com.hazizz.droid.fragments.MainTab.MainAnnouncementFragment;
import com.hazizz.droid.fragments.MainTab.MainFragment;
import com.hazizz.droid.fragments.MyTasksFragment;
import com.hazizz.droid.fragments.ViewTaskFragment;
import com.hazizz.droid.listeners.OnBackPressedListener;
import com.hazizz.droid.notification.TaskReporterNotification;
import com.hazizz.droid.other.SharedPrefs;
import com.hazizz.droid.navigation.Transactor;
import com.hazizz.droid.Communication.MiddleMan;
import com.hazizz.droid.R;
import com.hazizz.droid.manager.ThreadManager;

import io.fabric.sdk.android.Fabric;

public class MainActivity extends AppCompatActivity
        implements NavigationView.OnNavigationItemSelectedListener {

    private static final int PICK_PHOTO_FOR_AVATAR = 1;

    private boolean doubleBackToExitPressedOnce;

    private DrawerLayout drawerLayout;
    private NavigationView navView;
    private ActionBarDrawerToggle toggle;

    private ImageView navProfilePic;
    private TextView navUsername;
    private TextView navEmail;
    private TextView navLogout;

    private ImageButton imageButton_darkMode;

    public static String strNavUsername;
    public static String strNavEmail;
    public static String strNavDisplayName;

    FloatingActionButton fab_joinGroup;
    FloatingActionButton fab_action;

    private Menu optionsMenu;

    private Menu menu_nav;
    private MenuItem menuItem_home;
    private MenuItem menuItem_groups;
    private MenuItem menuItem_myTasks;
    private MenuItem menuItem_thera;
    private MenuItem menuItem_settings;
    private MenuItem menuItem_logs;

    private Toolbar toolbar;
    private Fragment currentFrag;

    private Activity thisActivity = this;

    private MeInfo meInfo;

    private OnBackPressedListener currentBackPressedListener;

    public static final String value_INTENT_MODE_CHOOSER = "chooser";
    public static final String value_INTENT_MODE_VIEWTASK = "viewTask";
    public static final String key_INTENT_MODE = "mode";
    public static final String key_INTENT_GROUPID = "groupId";
    public static final String key_INTENT_TASKID = "taskId";


    private boolean gotMyProfilePicRespond = false;

    private boolean toMainFrag = false;
    CustomResponseHandler rh_profilePic = new CustomResponseHandler() {
        @Override
        public void onPOJOResponse(Object response) {
            Bitmap bitmap = Converter.imageFromText(getBaseContext(),
                    ((PojoPicSmall)response).getData().split(",")[1]);
            bitmap = Converter.scaleBitmapToRegular(bitmap);
            bitmap = Converter.getCroppedBitmap(bitmap);

            meInfo.setProfilePic(Converter.imageToText(bitmap));
            setProfileImageInNav(bitmap);
        }
    };

    CustomResponseHandler responseHandler = new CustomResponseHandler() {
        @Override
        public void onPOJOResponse(Object response) {
            PojoMe pojo = (PojoMe) response;
            SharedPrefs.save(getApplicationContext(),"userInfo", "username",pojo.getUsername());
            strNavEmail = (pojo.getEmailAddress());
            strNavUsername = (pojo.getUsername());
            strNavDisplayName = (pojo.getDisplayName());
            meInfo.setUserId(pojo.getId());
            meInfo.setProfileName(strNavUsername);
            meInfo.setDisplayName(strNavDisplayName);
            meInfo.setProfileEmail(strNavEmail);
            setDisplayNameInNav(strNavDisplayName);
            navEmail.setText(strNavEmail);
        }
    };

    CustomResponseHandler rh_motd = new CustomResponseHandler() {
        @Override
        public void onPOJOResponse(Object response) {
            String motd = (String)response;
            if(!motd.equals("") && !SharedPrefs.getString(getBaseContext(), "motd", "message").equals(motd)) {
                    AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(MainActivity.this);
                    alertDialogBuilder.setTitle("Napi üzenet");
                    alertDialogBuilder
                        .setMessage(motd)
                        .setCancelable(true)
                        .setPositiveButton("Oké", (dialog, id) -> {
                            SharedPrefs.save(getBaseContext(), "motd", "message", motd);
                            dialog.cancel();
                        });
                    AlertDialog alertDialog = alertDialogBuilder.create();
                    alertDialog.show();
            }
        }
    };

    @Override
    protected void onCreate(Bundle savedInstanceState) {

        if(AppInfo.isDarkMode(getBaseContext())){
            setTheme(R.style.AppTheme_Dark);
        }else{
            setTheme(R.style.AppTheme_Light);
        }

        super.onCreate(savedInstanceState);

        //if (!BuildConfig.DEBUG) { // only enable bug tracking in release version
        Fabric.with(this, new Crashlytics());
        Fabric.with(this, new Answers());

        if(!SharedPrefs.Server.hasChangedAddress(this)) {
            SharedPrefs.Server.setMainAddress(this, Request.BASE_URL);
        }

        meInfo = MeInfo.getInstance();

        FirebaseDynamicLinks.getInstance()
                .getDynamicLink(getIntent())
                .addOnSuccessListener(this, new OnSuccessListener<PendingDynamicLinkData>() {
                    @Override
                    public void onSuccess(PendingDynamicLinkData pendingDynamicLinkData) {
                        // Get deep link from result (may be null if no link is found)
                        Uri deepLink = null;
                        if (pendingDynamicLinkData != null) {
                            deepLink = pendingDynamicLinkData.getLink();
                        }
                        if(deepLink!=null){
                            int groupId = Integer.parseInt(deepLink.getQueryParameter("group"));

                                CustomResponseHandler rh_joinGroup = new CustomResponseHandler() {

                                    @Override public void onErrorResponse(PojoError error) {
                                        if(error.getErrorCode() == 55){ // user already in group
                                            Transactor.fragmentMainGroup(getSupportFragmentManager().beginTransaction(), groupId);
                                            Toast.makeText(thisActivity, getString(R.string.already_in_group),
                                                    Toast.LENGTH_LONG).show();
                                        }
                                    }
                                    @Override public void onSuccessfulResponse() {
                                        Transactor.fragmentMainGroup(getSupportFragmentManager().beginTransaction(), groupId);
                                        Toast.makeText(thisActivity, getString(R.string.added_to_group),
                                                Toast.LENGTH_LONG).show();
                                    }
                                };
                                MiddleMan.newRequest(new JoinGroup(thisActivity, rh_joinGroup, groupId));
                        }
                        Log.e("hey", "dynamic link lol: " + deepLink);
                    }
                })
                .addOnFailureListener(this, new OnFailureListener() {
                    @Override
                    public void onFailure(@NonNull Exception e) {
                        Log.w("hey", "getDynamicLink:onFailure", e);
                    }
                });

        setContentView(R.layout.activity_main);

        ThreadManager.getInstance().startThreadIfNotRunning(this);

        toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        fab_joinGroup = findViewById(R.id.fab_joinGroup);
        fab_joinGroup.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Transactor.fragmentJoinGroup(getSupportFragmentManager().beginTransaction());
                fab_joinGroup.setVisibility(View.INVISIBLE);
            }
        });
        toMainFrag = true;

        fab_action = (FloatingActionButton) findViewById(R.id.fab_action);
        fab_action.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Log.e("hey", "fab_action CLICKed");
                currentFrag = Transactor.getCurrentFragment(getSupportFragmentManager(), false);

                if (currentFrag instanceof GroupMainFragment) {
                    ((GroupMainFragment)currentFrag).toTaskEditor(getSupportFragmentManager());
                } else if (currentFrag instanceof GroupAnnouncementFragment) {
                    ((GroupAnnouncementFragment)currentFrag).toAnnouncementEditor(getSupportFragmentManager());
                }else if (currentFrag instanceof MainAnnouncementFragment) {
                    toAnnouncementEditorFrag();
                } else if (currentFrag instanceof SubjectsFragment) {
                    ((SubjectsFragment)currentFrag).toCreateSubject(getSupportFragmentManager());
                } else if (currentFrag instanceof MainFragment) {
                    toCreateTaskFrag();
                } else if (currentFrag instanceof GroupsFragment) {
                    ((GroupsFragment)currentFrag).toCreateGroup(getSupportFragmentManager());
                }else if (currentFrag instanceof MyTasksFragment) {
                    ((MyTasksFragment)currentFrag).toCreateTask();
                }else if (currentFrag instanceof GetGroupMembersFragment) {
                    ((GetGroupMembersFragment)currentFrag).openInviteLinkDialog(getSupportFragmentManager());
                }
            }
        });
        navView = (NavigationView) findViewById(R.id.nav_view);

        navView.setNavigationItemSelectedListener(this);
        navView.bringToFront();

        View headerView = navView.getHeaderView(0);
        navProfilePic = (ImageView) headerView.findViewById(R.id.imageView_memberProfilePic);
        navUsername = (TextView) headerView.findViewById(R.id.textView_name);
        navEmail = (TextView) headerView.findViewById(R.id.textView_email);
        navLogout = findViewById(R.id.textView_logout);

        imageButton_darkMode = findViewById(R.id.imageButton_darkMode);
        imageButton_darkMode.setOnClickListener(new View.OnClickListener() {
            @Override public void onClick(View v) {

                if(AppInfo.isDarkMode(getBaseContext())){
                    AppInfo.setDarkMode(getBaseContext(), false);
                    setTheme(R.style.AppTheme_Light);
                }else{
                    AppInfo.setDarkMode(getBaseContext(), true);
                    setTheme(R.style.AppTheme_Dark);
                }

                Intent intent = new Intent(thisActivity, MainActivity.class);

                finish();

                startActivity(intent);
                // removes the slide animation
                overridePendingTransition(0, 0);
            }
        });

        menu_nav = navView.getMenu();
        menuItem_home     = menu_nav.getItem(0);
        menuItem_groups   = menu_nav.getItem(1);
        menuItem_myTasks  = menu_nav.getItem(2);
        menuItem_thera    = menu_nav.getItem(3);
        menuItem_settings = menu_nav.getItem(4);
        menuItem_logs     = menu_nav.getItem(5);

        drawerLayout = findViewById(R.id.drawer_layout);
        drawerLayout.addDrawerListener(new DrawerLayout.DrawerListener() {
            @Override public void onDrawerSlide(@NonNull View drawerView, float slideOffset) { }
            @Override
            public void onDrawerOpened(@NonNull View drawerView) {
                if(!gotMyProfilePicRespond){
                    MiddleMan.newRequest(new Me(thisActivity, responseHandler));
                    MiddleMan.newRequest(new GetMyProfilePic(thisActivity, rh_profilePic));
                    gotMyProfilePicRespond = true;
                }
            }
            @Override public void onDrawerClosed(@NonNull View drawerView) { }
            @Override public void onDrawerStateChanged(int newState) { }
        });
        toggle = new ActionBarDrawerToggle(this, drawerLayout, R.string.open, R.string.close);
        drawerLayout.addDrawerListener(toggle);
        toggle.syncState();

        getSupportActionBar().setDisplayHomeAsUpEnabled(true);

        Activity thisActivity = this;

        navLogout.setOnClickListener(new View.OnClickListener() {
             @Override public void onClick(View view) {
                 SharedPrefs.savePref(getBaseContext(), "autoLogin", "autoLogin", false);
                 SharedPrefs.TokenManager.invalidateTokens(getBaseContext());
                 SharedPrefs.ThSessionManager.clearSession(getBaseContext());
                 SharedPrefs.ThLoginData.clearAllData(getBaseContext());
                 Intent i = new Intent(thisActivity, AuthActivity.class);
                 finish();
                 startActivity(i);
             }
        });

        MiddleMan.newRequest(new MessageOfTheDay(this, rh_motd));

        if(AppInfo.isFirstTimeLaunched(getBaseContext())){
            Transactor.authActivity(getBaseContext());
            TaskReporterNotification.enable(getBaseContext());
            TaskReporterNotification.setScheduleForNotification(getBaseContext(), 17, 0);
        }

        if(AppInfo.isDarkMode(getBaseContext())){
            imageButton_darkMode.setImageDrawable(getResources().getDrawable(R.drawable.ic_sun));
        }else{
            imageButton_darkMode.setImageDrawable(getResources().getDrawable(R.drawable.ic_moon_gray));
        }

        boolean receivedIntentTask = receiveIntentTask();
        if(!receivedIntentTask && toMainFrag) {
            toMainFrag();
            toMainFrag = false;
        }
    }

    @Override
    public void onResume() {
        receiveIntentTask();
        super.onResume();
        Log.e("hey", "onResume is trigered");
    }

    private boolean receiveIntentTask(){
        Intent intent = getIntent();
        String mode = intent.getStringExtra(key_INTENT_MODE);
        if(mode != null){
            if(mode.equals(value_INTENT_MODE_VIEWTASK)) {
                int groupId = intent.getIntExtra(key_INTENT_GROUPID, 0);
                int taskId = intent.getIntExtra(key_INTENT_TASKID, 0);
                Log.e("hey", "group and task id: " + groupId + ", " + taskId);
                if (groupId != 0) {
                    Transactor.fragmentViewTask(getSupportFragmentManager().beginTransaction(), (int) taskId,
                            true, Strings.Dest.TOMAIN, ViewTaskFragment.publicMode);
                } else {
                    Transactor.fragmentViewTask(getSupportFragmentManager().beginTransaction(), (int) taskId,
                            true, Strings.Dest.TOMAIN, ViewTaskFragment.myMode);
                }
            }else if(mode.equals(value_INTENT_MODE_CHOOSER)){
                Transactor.fragmentATChooser(getSupportFragmentManager().beginTransaction());
            }
            return true;
        }
        return false;
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        Log.e("hey", "onCreateOptionsMenu called");
        return super.onCreateOptionsMenu(menu);
    }


    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        if(toggle.onOptionsItemSelected(item)){
            return true;
        }
        return false;
    }

    @SuppressWarnings("StatementWithEmptyBody")
    @Override
    public boolean onNavigationItemSelected(MenuItem item) {
        currentFrag = Transactor.getCurrentFragment(getSupportFragmentManager(), false);
        switch (item.getItemId()) {
            case R.id.nav_home:
                toMainFrag();
                break;
            case R.id.nav_groups:
                toGroupsFrag();
                break;
            case R.id.nav_mytasks:
                Transactor.fragmentMyTasks(getSupportFragmentManager().beginTransaction());
                break;
            case R.id.nav_thera:
                Transactor.fragmentThMain(getSupportFragmentManager().beginTransaction());
                break;
            case R.id.nav_settings:
                Transactor.fragmentOptions(getSupportFragmentManager().beginTransaction());
                break;
            case R.id.nav_feedback:
                Transactor.feedbackActivity(this);
                break;
            case R.id.nav_logs:
                Transactor.fragmentLogs(getSupportFragmentManager().beginTransaction());
                break;

        }
        DrawerLayout drawer = (DrawerLayout) findViewById(R.id.drawer_layout);
        drawer.closeDrawer(GravityCompat.START);
        return true;
    }
    void toGroupsFrag(){
        Transactor.fragmentGroups(getSupportFragmentManager().beginTransaction());
    }
    void toMainFrag(){
        Transactor.fragmentMain(getSupportFragmentManager().beginTransaction());
    }

    void toCreateTaskFrag(){
        Transactor.fragmentCreatorAT(getSupportFragmentManager().beginTransaction(), GroupsFragment.Dest.TOCREATETASK);

    }
    void toAnnouncementEditorFrag(){
        Transactor.fragmentCreatorAT(getSupportFragmentManager().beginTransaction(), GroupsFragment.Dest.TOCREATEANNOUNCEMET);

    }

    public void setOnBackPressedListener(OnBackPressedListener listener){
        currentBackPressedListener = listener;
    }

    public void removeOnBackPressedListener(){
        currentBackPressedListener = null;
    }

    @Override
    public void onBackPressed() {
        Fragment currentFrag = Transactor.getCurrentFragment(getSupportFragmentManager(), false);
        if(currentFrag instanceof MainFragment || currentFrag instanceof MainAnnouncementFragment){
            if (doubleBackToExitPressedOnce) {
                // close application
                if(android.os.Build.VERSION.SDK_INT >= 21){
                    finishAndRemoveTask();
                } else {
                    finish();
                }
                return;
            }
            this.doubleBackToExitPressedOnce = true;
            Toast.makeText(this, R.string.press_again_to_exit, Toast.LENGTH_SHORT).show();

            new Handler().postDelayed(new Runnable() {
                @Override public void run() {
                    doubleBackToExitPressedOnce=false;
                }
            }, 2000);
        }
        else if(currentBackPressedListener != null){
            currentBackPressedListener.onBackPressed();
            return;
        }else{
            Transactor.fragmentMain(getSupportFragmentManager().beginTransaction());
        }
    }

    public void hideFabs(){
        fab_action.setVisibility(View.INVISIBLE);
        fab_joinGroup.setVisibility(View.INVISIBLE);
    }

    public void onFragmentCreated(){
        currentFrag = Transactor.getCurrentFragment(getSupportFragmentManager(), false);

        if (currentFrag instanceof GroupAnnouncementFragment || currentFrag instanceof GroupMainFragment
            || currentFrag instanceof MainAnnouncementFragment || currentFrag instanceof MainFragment
            || currentFrag instanceof MyTasksFragment ) {
            fab_action.setVisibility(View.VISIBLE);
                if (currentFrag instanceof MainFragment) {
                    navView.getMenu().getItem(0).setChecked(true);
                } else {
                    navView.getMenu().getItem(0).setChecked(false);
                }
        } else {
            fab_action.setVisibility(View.INVISIBLE);
        }
        if (currentFrag instanceof GroupsFragment) {
            fab_joinGroup.setVisibility(View.VISIBLE);
            navView.getMenu().getItem(1).setChecked(true);
            fab_action.setVisibility(View.VISIBLE);
        } else {
            fab_joinGroup.setVisibility(View.INVISIBLE);
            navView.getMenu().getItem(1).setChecked(false);
        }
    }

    public void onTabSelected(Fragment currentFrag){
            if (currentFrag instanceof GroupAnnouncementFragment || currentFrag instanceof GroupMainFragment
                    || currentFrag instanceof MainAnnouncementFragment || currentFrag instanceof SubjectsFragment
                    || currentFrag instanceof MainFragment || currentFrag instanceof GroupsFragment
                    || currentFrag instanceof GetGroupMembersFragment) {
                fab_action.setVisibility(View.VISIBLE);
                if (currentFrag instanceof GroupsFragment) {
                    fab_joinGroup.setVisibility(View.VISIBLE);
                    navView.getMenu().getItem(1).setChecked(true);
                } else {
                    fab_joinGroup.setVisibility(View.INVISIBLE);
                    navView.getMenu().getItem(1).setChecked(false);
                }
                if (currentFrag instanceof MainFragment) {
                    navView.getMenu().getItem(0).setChecked(true);
                } else {
                    navView.getMenu().getItem(0).setChecked(false);
                }
            } else {
                fab_action.setVisibility(View.INVISIBLE);
            }
    }
    public void pickImage() {
        Intent intent = new Intent(Intent.ACTION_GET_CONTENT);
        intent.setType("image/*");
        startActivityForResult(intent, PICK_PHOTO_FOR_AVATAR);
    }

    public void setProfileImageInNav(Bitmap bitmap){
        navProfilePic.setImageBitmap(bitmap);
    }

    public void setDisplayNameInNav(String newDisplayName){
        navUsername.setText(newDisplayName);
    }

    public void activateHiddenFeatures(){
        menuItem_thera.setVisible(true);
        menuItem_logs.setVisible(true);
    }
}
