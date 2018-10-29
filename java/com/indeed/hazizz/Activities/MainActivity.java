package com.indeed.hazizz.Activities;

//import android.app.Fragment;
import android.app.Activity;
import android.app.FragmentManager;
import android.content.Intent;
import android.net.TrafficStats;
import android.os.Bundle;
import android.support.design.widget.FloatingActionButton;
import android.support.design.widget.Snackbar;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentTransaction;
import android.support.v7.app.ActionBarDrawerToggle;
import android.util.Log;
import android.view.SubMenu;
import android.view.View;
import android.support.design.widget.NavigationView;
import android.support.v4.view.GravityCompat;
import android.support.v4.widget.DrawerLayout;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.TextView;

import com.indeed.hazizz.Communication.MiddleMan;
import com.indeed.hazizz.Communication.POJO.Response.CustomResponseHandler;
import com.indeed.hazizz.Communication.POJO.Response.POJOerror;
import com.indeed.hazizz.Communication.POJO.Response.POJOme;
import com.indeed.hazizz.Fragments.CreateSubjectFragment;
import com.indeed.hazizz.Fragments.CreateTaskFragment;
import com.indeed.hazizz.Fragments.GetGroupMembersFragment;
import com.indeed.hazizz.Fragments.GroupMainFragment;
import com.indeed.hazizz.Fragments.GroupTabs.GroupTabFragment;
import com.indeed.hazizz.Fragments.GroupsFragment;
import com.indeed.hazizz.Fragments.MainFragment;
import com.indeed.hazizz.Fragments.ViewTaskFragment;
import com.indeed.hazizz.Listviews.GroupList.GroupItem;
import com.indeed.hazizz.R;
import com.indeed.hazizz.Transactor;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

public class MainActivity extends AppCompatActivity
        implements NavigationView.OnNavigationItemSelectedListener {


    private DrawerLayout drawerLayout;
    private NavigationView navView;
    private ActionBarDrawerToggle toggle;

    private TextView navUsername;
    private TextView navEmail;
    private TextView navLogout;

    FloatingActionButton fab_joinGroup;
    FloatingActionButton fab_createGroup;
    FloatingActionButton fab_createTask;

    private Menu menu_options;
    private MenuItem menuItem_createGroup;
    private MenuItem menuItem_joinGroup;
 //   private MenuItem menuItem_leaveGroup;

    private Menu menu_nav;

    private MenuItem menu_groups;
    private MenuItem menu_mainGroup;

    private Toolbar toolbar;
    private Fragment currentFrag;

    private ArrayList<Integer> groupIDs;

    CustomResponseHandler responseHandler = new CustomResponseHandler() {
        @Override
        public void onResponse(HashMap<String, Object> response) {
        }

        @Override
        public void onPOJOResponse(Object response) {
            Log.e("hey", "got pojo response");
            navUsername.setText(((POJOme) response).getUsername());
            navEmail.setText(((POJOme) response).getEmailAddress());
        }
        @Override
        public void onFailure() {
            Log.e("hey", "4");
            Log.e("hey", "got here onFailure");
        }
        @Override
        public void onEmptyResponse() {
            Log.e("hey", "NO RESPONSE");
        }

        @Override
        public void onSuccessfulResponse() {

        }

        @Override
        public void onNoConnection() {

        }

        @Override
        public void onErrorResponse(POJOerror error) {
            Log.e("hey", "onErrorResponse");
        }
    };

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        groupIDs = new ArrayList<>();

        fab_joinGroup = findViewById(R.id.fab_joinGroup);
        fab_joinGroup.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Transactor.fragmentJoinGroup(getSupportFragmentManager().beginTransaction());
            }
        });

        fab_createGroup = (FloatingActionButton) findViewById(R.id.fab_createGroup);
        fab_createGroup.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                currentFrag = Transactor.getCurrentFragment(getSupportFragmentManager());
                if (currentFrag instanceof GroupsFragment) {
                    Log.e("hey", "instance of groupmain fragment");
                    ((GroupsFragment)currentFrag).toCreateGroup();
                }
            }
        });

        fab_createTask = (FloatingActionButton) findViewById(R.id.fab_createTask);
        fab_createTask.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
             /*   Snackbar.make(view, "Replace with your own action", Snackbar.LENGTH_LONG)
                        .setAction("Action", null).show(); */
                currentFrag = Transactor.getCurrentFragment(getSupportFragmentManager());
                if (currentFrag instanceof GroupMainFragment) {
                    Log.e("hey", "instance of groupmain fragment");
                    ((GroupMainFragment)currentFrag).toCreateTask();
                }
                else if (currentFrag instanceof ViewTaskFragment) {
                    ((ViewTaskFragment)currentFrag).toCreateTask();
                }
                else if(currentFrag instanceof CreateTaskFragment || currentFrag instanceof GroupsFragment){}
                else if (currentFrag instanceof MainFragment) {
                    toCreateTaskFrag(true);
                }
                else {
                    toGroupsFrag();
                }
            }
        });
        navView = (NavigationView) findViewById(R.id.nav_view);
        navView.setNavigationItemSelectedListener(this);
        navView.bringToFront();

        View headerView = navView.getHeaderView(0);
        navUsername = (TextView) headerView.findViewById(R.id.textView_userName);
        navEmail = (TextView) headerView.findViewById(R.id.textView_email);
        navLogout = findViewById(R.id.textView_logout);

        menu_nav = navView.getMenu();

        menu_groups= menu_nav.getItem(2);
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
                 Log.e("hey", "pressed logout");
                 Intent i = new Intent(thisActivity, AuthActivity.class);
                 startActivity(i);

             }
             });
        MiddleMan.newRequest(getBaseContext(), "me", null, responseHandler, null);

    }

 /*   @Override
    public void onResume(){
        super.onResume();
        Log.e("hey", "onResume is trigered");
        toMainFrag();
    }
    @Override
    public void onStart(){
        super.onStart();
        Log.e("hey", "onResume is trigered");
        toMainFrag();
    } */


    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        menu_options = menu;
        getMenuInflater().inflate(R.menu.main, menu_options);


        menuItem_createGroup = menu_options.findItem(R.id.action_createGroup);
        menuItem_joinGroup = menu_options.findItem(R.id.action_joinGroup);
      //  menuItem_leaveGroup = menu_options.findItem(R.id.action_leaveGroup);

        if(menuItem_createGroup == null || menuItem_joinGroup == null ){// || menuItem_leaveGroup == null){
            Log.e("hey", "menu items are null");
        }

        toMainFrag();

        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        Fragment cFrag = Transactor.getCurrentFragment(getSupportFragmentManager());
        if(toggle.onOptionsItemSelected(item)){
            return true;
        }
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_createGroup) {
            Transactor.fragmentCreateGroup(getSupportFragmentManager().beginTransaction());
            return true;
        }
        if (id == R.id.action_joinGroup) {
            Transactor.fragmentJoinGroup(getSupportFragmentManager().beginTransaction());
            return true;
        }
      /*  if (id == R.id.action_leaveGroup) {
            ((GroupTabFragment)cFrag).leaveGroup();

            return true;
        } */
        return super.onOptionsItemSelected(item);
    }

    @SuppressWarnings("StatementWithEmptyBody")
    @Override
    public boolean onNavigationItemSelected(MenuItem item) {
        Log.e("hey", "chechk1");
        int id = item.getItemId();

        currentFrag = Transactor.getCurrentFragment(getSupportFragmentManager());
        if (id == R.id.nav_home) {
            toMainFrag();
        } else if (id == R.id.nav_groups) {
            toGroupsFrag();
       /* } else if (id == R.id.nav_new_task) {
            toCreateTaskFrag(); */
        } else if (id == R.id.nav_newGroup) {
           // ((GroupsFragment)currentFrag).toCreateGroup();
            Transactor.fragmentCreateGroup(getSupportFragmentManager().beginTransaction());
        } else if (id == R.id.nav_joinGroup) {
            //((GroupsFragment)currentFrag).
            Transactor.fragmentJoinGroup(getSupportFragmentManager().beginTransaction());
        }
        else if (id == R.id.nav_tasks) {
            //((GroupsFragment)currentFrag).
            ((GroupTabFragment)currentFrag).setTab(2);

        }else if (id == R.id.nav_groupMembers) {
            //((GroupsFragment)currentFrag).
            ((GroupTabFragment)currentFrag).setTab(1);
        }

        DrawerLayout drawer = (DrawerLayout) findViewById(R.id.drawer_layout);
        drawer.closeDrawer(GravityCompat.START);
        return true;
    }

    void toGroupsFrag(){
        Transactor.fragmentGroups(getSupportFragmentManager().beginTransaction(), false);
    }

    void toMainFrag(){
        Transactor.fragmentMain(getSupportFragmentManager().beginTransaction());
    }

    void toCreateTaskFrag(boolean dest){
        Transactor.fragmentGroups(getSupportFragmentManager().beginTransaction(), dest);
    }

    void logout(){
        Intent i = new Intent(this, AuthActivity.class);
        startActivity(i);
    }


    @Override
    public void onBackPressed() {
        currentFrag = Transactor.getCurrentFragment(getSupportFragmentManager());
        if      (currentFrag instanceof MainFragment) {}
        else if (currentFrag instanceof GroupsFragment) {
            Transactor.fragmentMain(getSupportFragmentManager().beginTransaction());
        }
        else if (currentFrag instanceof GroupMainFragment) {
            Transactor.fragmentGroups(getSupportFragmentManager().beginTransaction(), false);
        }
        else if (currentFrag instanceof CreateTaskFragment) {
            Transactor.fragmentMainGroup(getSupportFragmentManager().beginTransaction(), ((CreateTaskFragment)currentFrag).getGroupId(), ((CreateTaskFragment)currentFrag).getGroupName());
         //   Transactor.fragmentGroupTab(getSupportFragmentManager().beginTransaction(), ((CreateTaskFragment)currentFrag).getGroupId(), ((CreateTaskFragment)currentFrag).getGroupName());
        }
        else if (currentFrag instanceof ViewTaskFragment) {
            if(!((ViewTaskFragment)currentFrag).getGoBackToMain()) {
                Transactor.fragmentMainGroup(getSupportFragmentManager().beginTransaction(), ((ViewTaskFragment) currentFrag).getGroupId(), ((ViewTaskFragment) currentFrag).getGroupName());
            }else{
                Transactor.fragmentMain(getSupportFragmentManager().beginTransaction());
            }
          //  Transactor.fragmentGroupTab(getSupportFragmentManager().beginTransaction(), ((CreateTaskFragment)currentFrag).getGroupId(), ((CreateTaskFragment)currentFrag).getGroupName());

        }
        else if (currentFrag instanceof CreateSubjectFragment) {
            ((CreateSubjectFragment) currentFrag).goBack();
        }
        else {
            Log.e("hey", "back button pressed and Else block is being called");
            Transactor.fragmentMain(getSupportFragmentManager().beginTransaction());
        }
    }

    public void onFragmentCreated(){
        currentFrag = Transactor.getCurrentFragment(getSupportFragmentManager());
        if (currentFrag instanceof GroupsFragment) {
            fab_createGroup.setVisibility(View.VISIBLE);
        //    menuItem_createGroup.setVisible(true);
        //    menuItem_joinGroup.setVisible(true);
            navView.getMenu().getItem(1).setVisible(false);
          //  navView.getMenu().getItem(1).setChecked(true);
            menu_groups.setVisible(true);
        }else{
            fab_createGroup.setVisibility(View.INVISIBLE);
           //0 menuItem_createGroup.setVisible(false);
           // menuItem_joinGroup.setVisible(false);
            navView.getMenu().getItem(1).setVisible(true);
            menu_groups.setVisible(false);
        }

        if(currentFrag instanceof GroupsFragment) {

            fab_joinGroup.setVisibility(View.VISIBLE);
        }
        else{
            fab_joinGroup.setVisibility(View.INVISIBLE);

        }

        if(currentFrag instanceof CreateSubjectFragment) {
            fab_createGroup.setVisibility(View.INVISIBLE);
        //    fab_createTask.setVisibility(View.INVISIBLE);
        }else{
          //  fab_createTask.setVisibility(View.VISIBLE);
        }

        if(currentFrag instanceof MainFragment){
            navView.getMenu().getItem(0).setChecked(true);
        }else{
            navView.getMenu().getItem(0).setChecked(false);
        }

        if(currentFrag instanceof MainFragment ) {
            //  menuItem_leaveGroup.setVisible(true);
            fab_createTask.setVisibility(View.VISIBLE);
        }else{
            fab_createTask.setVisibility(View.INVISIBLE);

        }
    }

    public void setGroupName(String name){
        menu_mainGroup.setTitle("Csoportok: " + name);
    }

    /*@Override
    public void onBackPressed() {

        int count = getFragmentManager().getBackStackEntryCount();

        if (count == 0) {
            super.onBackPressed();
            //additional code
        } else {
            getFragmentManager().popBackStack();
        }

    } */
}
