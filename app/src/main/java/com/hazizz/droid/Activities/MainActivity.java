package com.hazizz.droid.Activities;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.Intent;
import android.graphics.Bitmap;
import android.os.Bundle;
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
import android.widget.ImageView;
import android.widget.TextView;

import com.crashlytics.android.Crashlytics;
import com.crashlytics.android.answers.Answers;
import com.hazizz.droid.Communication.POJO.Response.CustomResponseHandler;
import com.hazizz.droid.Communication.POJO.Response.POJOme;
import com.hazizz.droid.Communication.POJO.Response.PojoPicSmall;
import com.hazizz.droid.Communication.Requests.GetMyProfilePic;
import com.hazizz.droid.Communication.Requests.Me;
import com.hazizz.droid.Communication.Requests.MessageOfTheDay;
import com.hazizz.droid.Converter.Converter;
import com.hazizz.droid.Fragments.CreateSubjectFragment;
import com.hazizz.droid.Fragments.GroupTabs.GroupAnnouncementFragment;
import com.hazizz.droid.Fragments.GroupTabs.GroupMainFragment;
import com.hazizz.droid.Fragments.GroupTabs.GroupTabFragment;
import com.hazizz.droid.Fragments.GroupTabs.SubjectsFragment;
import com.hazizz.droid.Fragments.MainTab.GroupsFragment;
import com.hazizz.droid.Fragments.MainTab.MainAnnouncementFragment;
import com.hazizz.droid.Fragments.MainTab.MainFragment;
import com.hazizz.droid.Fragments.ViewTaskFragment;
import com.hazizz.droid.Manager;
import com.hazizz.droid.SharedPrefs;
import com.hazizz.droid.Transactor;
import com.hazizz.droid.BuildConfig;
import com.hazizz.droid.Communication.MiddleMan;
import com.hazizz.droid.R;

import java.util.HashMap;

import io.fabric.sdk.android.Fabric;
import okhttp3.ResponseBody;
import retrofit2.Call;

public class MainActivity extends AppCompatActivity
        implements NavigationView.OnNavigationItemSelectedListener {

    private static final int PICK_PHOTO_FOR_AVATAR = 1;

    private DrawerLayout drawerLayout;
    private NavigationView navView;
    private ActionBarDrawerToggle toggle;

    private ImageView navProfilePic;
    private TextView navUsername;
    private TextView navEmail;
    private TextView navLogout;

    public static String strNavUsername;
    public static String strNavEmail;
    public static String strNavDisplayName;

    FloatingActionButton fab_joinGroup;
    FloatingActionButton fab_action;

    private Menu menu_options;
    private MenuItem menuItem_leaveGroup;
    private MenuItem menuItem_profilePic;
    private MenuItem menuItem_feedback;
    private MenuItem menuItem_settings;


    private Menu menu_nav;

    private MenuItem menu_mainGroup;

    private Toolbar toolbar;
    private Fragment currentFrag;

    private Activity thisActivity = this;

    private boolean toMainFrag = false;
    CustomResponseHandler rh_profilePic = new CustomResponseHandler() {
        @Override
        public void onPOJOResponse(Object response) {
            Bitmap bitmap = Converter.imageFromText(
                    ((PojoPicSmall)response).getData().split(",")[1]);
            bitmap = Converter.scaleBitmapToRegular(bitmap);
            bitmap = Converter.getCroppedBitmap(bitmap);

            Manager.MeInfo.setProfilePic(Converter.imageToText(bitmap));
            setProfileImageInNav(bitmap);
        }
    };

    CustomResponseHandler responseHandler = new CustomResponseHandler() {
        @Override
        public void onPOJOResponse(Object response) {
            POJOme pojo = (POJOme) response;
            SharedPrefs.save(getApplicationContext(),"userInfo", "username",pojo.getUsername());
            strNavEmail = (pojo.getEmailAddress());
            strNavUsername = (pojo.getUsername());
            strNavDisplayName = (pojo.getDisplayName());
            Manager.MeInfo.setId(pojo.getId());
            Manager.MeInfo.setProfileName(strNavUsername);
            Manager.MeInfo.setDisplayName(strNavDisplayName);
            Manager.MeInfo.setProfileEmail(strNavEmail);
            setDisplayNameInNav(strNavDisplayName);
            navEmail.setText(strNavEmail);
        }
    };

    CustomResponseHandler rh_motd = new CustomResponseHandler() {
        @Override
        public void onPOJOResponse(Object response) {
            String motd = (String)response;
            Log.e("hey", "MOTD: " + motd);
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
            }else{
                Log.e("hey", "Message of the day is not");
            }
        }
    };

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        if (!BuildConfig.DEBUG) { // only enable bug tracking in release version
            Fabric.with(this, new Crashlytics());
        }
        Fabric.with(this, new Answers());

        setContentView(R.layout.activity_main);

        Manager.ThreadManager.startThreadIfNotRunning(this);

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
                    Log.e("hey", "instance of groupmain fragment");
                    ((GroupMainFragment)currentFrag).toTaskEditor(getSupportFragmentManager());
                }
                else if (currentFrag instanceof GroupAnnouncementFragment) {
                    ((GroupAnnouncementFragment)currentFrag).toAnnouncementEditor(getSupportFragmentManager());
                }else if (currentFrag instanceof MainAnnouncementFragment) {
                    toAnnouncementEditorFrag();
                }
                else if (currentFrag instanceof SubjectsFragment) {
                    ((SubjectsFragment)currentFrag).toCreateSubject(getSupportFragmentManager());
                }
             //   else if(currentFrag instanceof TaskEditorFragment || currentFrag instanceof GroupsFragment){}
                else if (currentFrag instanceof MainFragment) {
                    toCreateTaskFrag();
                }
                else if (currentFrag instanceof GroupsFragment) {
                    Log.e("hey", "instance of groupmain fragment111");
                    ((GroupsFragment)currentFrag).toCreateGroup(getSupportFragmentManager());
                }
            }
        });
        navView = (NavigationView) findViewById(R.id.nav_view);
        navView.setNavigationItemSelectedListener(this);
        navView.bringToFront();

        View headerView = navView.getHeaderView(0);
        navProfilePic = (ImageView) headerView.findViewById(R.id.imageView_memberProfilePic);
        navUsername = (TextView) headerView.findViewById(R.id.subject_name);
        navEmail = (TextView) headerView.findViewById(R.id.textView_email);
        navLogout = findViewById(R.id.textView_logout);

        menu_nav = navView.getMenu();

        menu_mainGroup = menu_nav.getItem(3);

        drawerLayout = findViewById(R.id.drawer_layout);
        toggle = new ActionBarDrawerToggle(this, drawerLayout, R.string.open, R.string.close);
        drawerLayout.addDrawerListener(toggle);
        toggle.syncState();

        getSupportActionBar().setDisplayHomeAsUpEnabled(true);

        Activity thisActivity = this;

        navLogout.setOnClickListener(new View.OnClickListener() {
             @Override
             public void onClick(View view) {
                 SharedPrefs.savePref(getBaseContext(), "autoLogin", "autoLogin", false);
                 SharedPrefs.TokenManager.invalidateTokens(getBaseContext());
                 Intent i = new Intent(thisActivity, AuthActivity.class);
                 finish();
                 startActivity(i);
             }
             });





        MiddleMan.newRequest(new MessageOfTheDay(this, rh_motd));

        MiddleMan.newRequest(new GetMyProfilePic(this, rh_profilePic));

        MiddleMan.newRequest(new Me(this, responseHandler));
    }

    @Override
    public void onResume(){
        super.onResume();
        invalidateOptionsMenu();
        Log.e("hey", "onResume is trigered");
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        Log.e("hey", "onCreateOptionsMenu asdasd");

        menu_options = menu;
        getMenuInflater().inflate(R.menu.main, menu_options);

        menuItem_leaveGroup = menu_options.findItem(R.id.action_leaveGroup);
        menuItem_profilePic = menu_options.findItem(R.id.action_profilePic);
        menuItem_feedback = menu_options.findItem(R.id.action_feedback);
        menuItem_settings = menu_options.findItem(R.id.action_settings);

        if(Manager.WidgetManager.getDest() == Manager.WidgetManager.TOATCHOOSER){
            Transactor.fragmentATChooser(getSupportFragmentManager().beginTransaction());
            Log.e("hey", "TOATCHOOSER hah");
        }
        else if(toMainFrag) {
            toMainFrag();
            toMainFrag = false;
        }
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        Fragment cFrag = Transactor.getCurrentFragment(getSupportFragmentManager(), false);
        if(toggle.onOptionsItemSelected(item)){
            return true;
        }
        switch (item.getItemId()){
            case R.id.action_leaveGroup:
                ((GroupTabFragment)cFrag).leaveGroup();
                return true;
            case R.id.action_profilePic:
                pickImage();
                return true;
            case R.id.action_feedback:
                Transactor.feedbackActivity(this);
                return true;
            case R.id.action_settings:
                Transactor.fragmentOptions(getSupportFragmentManager().beginTransaction());
                return true;
        }
        return super.onOptionsItemSelected(item);
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
            case R.id.nav_newGroup:
                Transactor.fragmentCreateGroup(getSupportFragmentManager().beginTransaction());
                break;
            case R.id.nav_thera:
                Transactor.fragmentThSchool(getSupportFragmentManager().beginTransaction());
                break;
            case R.id.nav_settings:
                Transactor.fragmentOptions(getSupportFragmentManager().beginTransaction());
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
        Manager.DestManager.setDest(Manager.DestManager.TOCREATETASK);
        Transactor.fragmentGroups(getSupportFragmentManager().beginTransaction());
    }
    void toAnnouncementEditorFrag(){
        Manager.DestManager.setDest(Manager.DestManager.TOCREATEANNOUNCEMENT);
        Transactor.fragmentGroups(getSupportFragmentManager().beginTransaction());
    }
    @Override
    public void onBackPressed() {
        Log.e("hey", "backButton pressed");
        currentFrag = Transactor.getCurrentFragment(getSupportFragmentManager(), true);
        if      (currentFrag instanceof MainFragment) {}
        else if (currentFrag instanceof GroupsFragment) {
            Transactor.fragmentMain(getSupportFragmentManager().beginTransaction());
        }
        else if (currentFrag instanceof GroupTabFragment) {//GroupMainFragment
            Transactor.fragmentGroups(getSupportFragmentManager().beginTransaction());
        }
        else if (currentFrag instanceof ViewTaskFragment) {
            if(!((ViewTaskFragment)currentFrag).getGoBackToMain()) {
                Transactor.fragmentMainGroup(getSupportFragmentManager().beginTransaction(), ((ViewTaskFragment) currentFrag).getGroupId(), ((ViewTaskFragment) currentFrag).getGroupName());
            }else{
                Transactor.fragmentMain(getSupportFragmentManager().beginTransaction());
            }
        } else if (currentFrag instanceof CreateSubjectFragment) {
            ((CreateSubjectFragment) currentFrag).goBack();
        } else {
            Log.e("hey", "back button pressed and Else block is being called");
            Transactor.fragmentMain(getSupportFragmentManager().beginTransaction());
        }
    }
    public void onFragmentCreated(){
        currentFrag = Transactor.getCurrentFragment(getSupportFragmentManager(), false);

        if (currentFrag instanceof GroupAnnouncementFragment || currentFrag instanceof GroupMainFragment
            || currentFrag instanceof MainAnnouncementFragment || currentFrag instanceof MainFragment) {
            fab_action.setVisibility(View.VISIBLE);
            if(menuItem_feedback != null && menuItem_leaveGroup != null
                    && menuItem_profilePic != null) {
                if (currentFrag instanceof MainFragment) {
                    navView.getMenu().getItem(0).setChecked(true);
                } else {
                    navView.getMenu().getItem(0).setChecked(false);
                }
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
        if(menuItem_feedback != null && menuItem_leaveGroup != null
                && menuItem_profilePic != null) {
            if (currentFrag instanceof GroupAnnouncementFragment || currentFrag instanceof GroupMainFragment
                    || currentFrag instanceof MainAnnouncementFragment || currentFrag instanceof SubjectsFragment
                    || currentFrag instanceof MainFragment || currentFrag instanceof GroupsFragment) {
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

    public void activateThéra(){
        menu_nav.getItem(2).setVisible(true);
    }



}
