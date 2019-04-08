package com.hazizz.droid.Activities;

import android.app.Activity;
import android.app.AlarmManager;
import android.app.AlertDialog;
import android.app.Notification;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.media.RingtoneManager;
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
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.crashlytics.android.Crashlytics;
import com.crashlytics.android.answers.Answers;
import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.firebase.dynamiclinks.FirebaseDynamicLinks;
import com.google.firebase.dynamiclinks.PendingDynamicLinkData;
import com.hazizz.droid.Cache.MeInfo.MeInfo;
import com.hazizz.droid.Communication.POJO.Response.CustomResponseHandler;
import com.hazizz.droid.Communication.POJO.Response.POJOerror;
import com.hazizz.droid.Communication.POJO.Response.POJOme;
import com.hazizz.droid.Communication.POJO.Response.PojoPicSmall;
import com.hazizz.droid.Communication.Requests.GetMyProfilePic;
import com.hazizz.droid.Communication.Requests.JoinGroup;
import com.hazizz.droid.Communication.Requests.Me;
import com.hazizz.droid.Communication.Requests.MessageOfTheDay;
import com.hazizz.droid.Communication.Requests.Parent.Request;
import com.hazizz.droid.Converter.Converter;
import com.hazizz.droid.Fragments.GroupTabs.GetGroupMembersFragment;
import com.hazizz.droid.Fragments.GroupTabs.GroupAnnouncementFragment;
import com.hazizz.droid.Fragments.GroupTabs.GroupMainFragment;
import com.hazizz.droid.Fragments.GroupTabs.GroupTabFragment;
import com.hazizz.droid.Fragments.GroupTabs.SubjectsFragment;
import com.hazizz.droid.Fragments.MainTab.GroupsFragment;
import com.hazizz.droid.Fragments.MainTab.MainAnnouncementFragment;
import com.hazizz.droid.Fragments.MainTab.MainFragment;
import com.hazizz.droid.Fragments.MyTasksFragment;
import com.hazizz.droid.Listener.OnBackPressedListener;
import com.hazizz.droid.Manager;
import com.hazizz.droid.Notification.NotificationReciever;
import com.hazizz.droid.Notification.TaskReporterNotification;
import com.hazizz.droid.SharedPrefs;
import com.hazizz.droid.Transactor;
import com.hazizz.droid.Communication.MiddleMan;
import com.hazizz.droid.R;

import java.util.Calendar;
import java.util.TimeZone;

import io.fabric.sdk.android.Fabric;
import okhttp3.ResponseBody;
import retrofit2.Call;

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

    public static String strNavUsername;
    public static String strNavEmail;
    public static String strNavDisplayName;

    FloatingActionButton fab_joinGroup;
    FloatingActionButton fab_action;

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
            POJOme pojo = (POJOme) response;
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
        super.onCreate(savedInstanceState);

        //if (!BuildConfig.DEBUG) { // only enable bug tracking in release version
        Fabric.with(this, new Crashlytics());
       // }
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

                                    @Override
                                    public void onErrorResponse(POJOerror error) {
                                        if(error.getErrorCode() == 55){ // user already in group
                                            Transactor.fragmentMainGroup(getSupportFragmentManager().beginTransaction(), groupId);
                                            Toast.makeText(thisActivity, getString(R.string.already_in_group),
                                                    Toast.LENGTH_LONG).show();
                                        }
                                    }
                                    @Override
                                    public void onSuccessfulResponse() {
                                        Transactor.fragmentMainGroup(getSupportFragmentManager().beginTransaction(), groupId);
                                        Toast.makeText(thisActivity, getString(R.string.added_to_group),
                                                Toast.LENGTH_LONG).show();
                                    }
                                };

                                MiddleMan.newRequest(new JoinGroup(thisActivity, rh_joinGroup, groupId));
                        }else{
                            Log.e("hey", "deep link uri is null");
                        }

                        Log.e("hey", "dynamic link lol: " + deepLink);
                        // Handle the deep link. For example, open the linked
                        // content, or apply promotional credit to the user's
                        // account.
                        // ...

                        // ...
                    }
                })
                .addOnFailureListener(this, new OnFailureListener() {
                    @Override
                    public void onFailure(@NonNull Exception e) {
                        Log.w("hey", "getDynamicLink:onFailure", e);
                    }
                });

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

        menu_nav = navView.getMenu();
        menuItem_home     = menu_nav.getItem(0);
        menuItem_groups   = menu_nav.getItem(1);
        menuItem_myTasks  = menu_nav.getItem(2);
        menuItem_thera    = menu_nav.getItem(3);
        menuItem_settings = menu_nav.getItem(4);
        menuItem_logs     = menu_nav.getItem(5);


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
                 SharedPrefs.ThSessionManager.clearSession(getBaseContext());
                 SharedPrefs.ThLoginData.clearAllData(getBaseContext());
                 Intent i = new Intent(thisActivity, AuthActivity.class);
                 finish();
                 startActivity(i);
             }
             });

        MiddleMan.newRequest(new MessageOfTheDay(this, rh_motd));

        MiddleMan.newRequest(new GetMyProfilePic(this, rh_profilePic));

        MiddleMan.newRequest(new Me(this, responseHandler));



        TaskReporterNotification.setNotification(getApplicationContext(), 8, 5);



    }

    private void scheduleNotification(Context context, Notification notification, int delay) {

     //   Intent notificationIntent = new Intent(MainActivity.this, NotificationReciever.class);
      //  notificationIntent.putExtra(NotificationReciever.NOTIFICATION_ID, 1);
    //    notificationIntent.putExtra(NotificationReciever.NOTIFICATION, notification);
      //  PendingIntent pendingIntent = PendingIntent.getBroadcast(MainActivity.this, 0, notificationIntent, PendingIntent.FLAG_UPDATE_CURRENT);

    //    long futureInMillis = SystemClock.elapsedRealtime() + delay;
     //   AlarmManager alarmManager = (AlarmManager)getSystemService(Context.ALARM_SERVICE);

      //  alarmManager.set(AlarmManager.ELAPSED_REALTIME, futureInMillis, pendingIntent);

        Calendar updateTime = Calendar.getInstance();
        updateTime.setTimeZone(TimeZone.getTimeZone("GMT"));
        updateTime.set(Calendar.HOUR_OF_DAY, 20);
        updateTime.set(Calendar.MINUTE, 2);

        Intent notificationIntent = new Intent(context, NotificationReciever.class);
        notificationIntent.putExtra(NotificationReciever.NOTIFICATION_ID, 1);
        notificationIntent.putExtra(NotificationReciever.NOTIFICATION, notification);


        PendingIntent pendingIntent = PendingIntent.getBroadcast(context,0, notificationIntent, PendingIntent.FLAG_CANCEL_CURRENT);
        AlarmManager alarms = (AlarmManager) context.getSystemService(Context.ALARM_SERVICE);
        alarms.setInexactRepeating(AlarmManager.RTC_WAKEUP,
                updateTime.getTimeInMillis(),
                AlarmManager.INTERVAL_DAY, pendingIntent);

       // alarmManager.setInexactRepeating(AlarmManager.RTC_WAKEUP, futureInMillis,
        //        AlarmManager.INTERVAL_DAY, pendingIntent);

    }

    private Notification getNotification(Context context, String content) {
      //  Notification.Builder builder = new Notification.Builder(MainActivity.this);
       // builder.setContentTitle("Scheduled Notification");
       // builder.setContentText(content);
       // Uri soundUri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION);
       // builder.setSound(soundUri);
       // builder.setDefaults(Notification.DEFAULT_LIGHTS | Notification.DEFAULT_SOUND);

        /*
        Notification notification = new Notification.BigTextStyle(builder)
                .setContentTitle("Scheduled Notification")
                .setContentText(content)
                .bigText(myText).build()
                */
        if(RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION) == null){
            Log.e("hey", "88 sound is null");
        }else{
            Log.e("hey", "88 sound is NOT null");
        }

        Notification noti = new Notification.Builder(context)
                .setStyle(new Notification.BigTextStyle().bigText("big text big text big text big text big text big text big text big text " +
                        "big text big text big text big text big text big text big text big text big text " +
                        "big text big text big text big text big text big text big text big text big text " +
                        "big text big text big text big text big text big text "))
                .setContentTitle("Feladataid:")
                .setContentText("3 befejezetlen feladat holnapra")
                .setSmallIcon(R.mipmap.ic_launcher2)

               // .setDefaults(Notification.DEFAULT_ALL)

                .setSound(RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION))

              //  .setDefaults(Notification.DEFAULT_LIGHTS | Notification.DEFAULT_SOUND)

                .build();
        if(noti == null){
            Log.e("hey", "88 Notif is null");
        }else{Log.e("hey", "88 Notif is NOT null");}
        return noti;
    }

    @Override
    public void onResume(){
        super.onResume();
        invalidateOptionsMenu();
        Log.e("hey", "onResume is trigered");

        /*
        Uri uri = this.getIntent().getData();
        if(uri!=null){
            Uri inside_uri = Uri.parse(uri.getQuery());
            if(inside_uri!=null) {
                int groupId = Integer.parseInt(inside_uri.getQueryParameter("group"));
                Log.e("hey", "deep link: " + inside_uri);
                Log.e("hey", "deep link groupId: " + groupId);

                CustomResponseHandler rh_joinGroup = new CustomResponseHandler() {

                    @Override
                    public void onErrorResponse(POJOerror error) {
                        if(error.getErrorCode() == 55){ // user already in group
                            Transactor.fragmentMainGroup(getSupportFragmentManager().beginTransaction(), groupId);
                            Toast.makeText(thisActivity, getString(R.string.already_in_group),
                                    Toast.LENGTH_LONG).show();
                        }
                    }
                    @Override
                    public void onSuccessfulResponse() {
                        Transactor.fragmentMainGroup(getSupportFragmentManager().beginTransaction(), groupId);
                        Toast.makeText(thisActivity, getString(R.string.added_to_group),
                                Toast.LENGTH_LONG).show();
                    }
                };

                MiddleMan.newRequest(new JoinGroup(this, rh_joinGroup, groupId));

            }
        }else{
            Log.e("hey", "deep link uri is null");
        }
        */

        //  android:launchMode="singleTop"

        /*
        <intent-filter android:label="@string/app_name">
                <action android:name="android.intent.action.VIEW" />
                <category android:name="android.intent.category.DEFAULT" />
                <category android:name="android.intent.category.BROWSABLE" />
                <!-- Accepts URIs that begin with "http://www.example.com/gizmos” -->
                <data android:scheme="https"
        android:host="hazizz.duckdns.org:9000"
        android:path="/shortener"
                />
                <!-- note that the leading "/" is required for pathPrefix-->
            </intent-filter>

        */


    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        Log.e("hey", "onCreateOptionsMenu asdasd");

      //  menu_options = menu;
      //  getMenuInflater().inflate(R.menu.main, menu_options);

      //  menuItem_leaveGroup = menu_options.findItem(R.id.action_leaveGroup);
      //  menuItem_profilePic = menu_options.findItem(R.id.action_profilePic);
      //  menuItem_feedback = menu_options.findItem(R.id.action_feedback);
      //  menuItem_settings = menu_options.findItem(R.id.action_settings);

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
      //  Transactor.fragmentCreateTask(getSupportFragmentManager().beginTransaction(), Manager.DestManager.TOMAIN);
       // Manager.DestManager.setDest(Manager.DestManager.TOCREATETASK);
       // Transactor.fragmentGroups(getSupportFragmentManager().beginTransaction());
        Transactor.fragmentCreatorAT(getSupportFragmentManager().beginTransaction(), GroupsFragment.Dest.TOCREATETASK);

    }
    void toAnnouncementEditorFrag(){
      //  Manager.DestManager.setDest(Manager.DestManager.TOCREATEANNOUNCEMENT);
      //  Transactor.fragmentGroups(getSupportFragmentManager().beginTransaction());
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
      /*  currentFrag = Transactor.getCurrentFragment(getSupportFragmentManager(), true);

        if (currentFrag instanceof GroupTabFragment) {//GroupMainFragment
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
        */
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
           // if(menuItem_feedback != null && menuItem_leaveGroup != null
          //         && menuItem_profilePic != null) {
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
     //   if(menuItem_feedback != null && menuItem_leaveGroup != null
     //           && menuItem_profilePic != null) {
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
      //  }
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
