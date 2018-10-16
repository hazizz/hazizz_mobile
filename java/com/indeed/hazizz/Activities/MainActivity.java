package com.indeed.hazizz.Activities;

//import android.app.Fragment;
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
import com.indeed.hazizz.Communication.POJO.Response.POJOgroup;
import com.indeed.hazizz.Communication.POJO.Response.POJOme;
import com.indeed.hazizz.Communication.Requests.Request;
import com.indeed.hazizz.FragTag;
import com.indeed.hazizz.Fragments.ChatFragment;
import com.indeed.hazizz.Fragments.CreateSubjectFragment;
import com.indeed.hazizz.Fragments.CreateTaskFragment;
import com.indeed.hazizz.Fragments.GroupMainFragment;
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
    FloatingActionButton fab_addToGroup;

    private Menu menu_main;
    private MenuItem menuItem_createGroup;
    private MenuItem menuItem_joinGroup;
    private MenuItem menuItem_leaveGroup;


    private ArrayList<Integer> groupIDs;

    public Toolbar toolbar;

    CustomResponseHandler responseHandler = new CustomResponseHandler() {
        @Override
        public void onResponse(HashMap<String, Object> response) {
        }

        @Override
        public void onPOJOResponse(Object response) {
            Log.e("hey", "got pojo response");
            navUsername.setText(((POJOme) response).getUsername());
            navEmail.setText(((POJOme) response).getEmailAddress());

         /*   for(POJOgroup g : ((POJOme) response).getGroups()){
                groupIDs.add(g.getId());
                Log.e("hey", "added groupID");
            } */
          //  toMainFrag();
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

        groupIDs = new ArrayList<Integer>();
        fab_createGroup = (FloatingActionButton) findViewById(R.id.fab_createGroup);
        fab_createGroup.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Fragment currentFrag = getSupportFragmentManager().findFragmentById(R.id.fragment_container);
                if (currentFrag instanceof GroupsFragment) {
                    Log.e("hey", "instance of groupmain fragment");
                    ((GroupsFragment)currentFrag).toCreateGroup();
                }
            }
        });

   /*     fab_addToGroup = (FloatingActionButton) findViewById(R.id.fab_addToGroup);
        fab_joinGroup = (FloatingActionButton) findViewById(R.id.fab_joinGroup);
        fab_joinGroup.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Transactor.fragmentJoinGroup(getSupportFragmentManager().beginTransaction());
            }
        }); */

        fab_createTask = (FloatingActionButton) findViewById(R.id.fab_createTask);
        fab_createTask.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
             /*   Snackbar.make(view, "Replace with your own action", Snackbar.LENGTH_LONG)
                        .setAction("Action", null).show(); */
                Fragment currentFrag = getSupportFragmentManager().findFragmentById(R.id.fragment_container);
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
        drawerLayout = findViewById(R.id.drawer_layout);



        toggle = new ActionBarDrawerToggle(this, drawerLayout, R.string.open, R.string.close);

        drawerLayout.addDrawerListener(toggle);
        toggle.syncState();

        getSupportActionBar().setDisplayHomeAsUpEnabled(true);


        navLogout.setOnClickListener(new View.OnClickListener() {
             @Override
             public void onClick(View view) {
                 Log.e("hey", "pressed logout");
                 logout();

             }
             });
        MiddleMan.newRequest(getBaseContext(), "me", null, responseHandler, null);

    }

  /*  @Override
    public void onBackPressed() {
        DrawerLayout drawer = (DrawerLayout) findViewById(R.id.drawer_layout);
        if (drawer.isDrawerOpen(GravityCompat.START)) {
            drawer.closeDrawer(GravityCompat.START);
        } else {
            super.onBackPressed();
        }
    } */

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
        menu_main = menu;
        getMenuInflater().inflate(R.menu.main, menu_main);


        menuItem_createGroup = menu_main.findItem(R.id.action_createGroup);
        menuItem_joinGroup = menu_main.findItem(R.id.action_joinGroup);
        menuItem_leaveGroup = menu_main.findItem(R.id.action_leaveGroup);

        if(menuItem_createGroup == null || menuItem_joinGroup == null || menuItem_leaveGroup == null){
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
        if (id == R.id.action_leaveGroup) {

            return true;
        }
        return super.onOptionsItemSelected(item);
    }

    @SuppressWarnings("StatementWithEmptyBody")
    @Override
    public boolean onNavigationItemSelected(MenuItem item) {
        Log.e("hey", "chechk1");
        int id = item.getItemId();


        if (id == R.id.nav_home) {
            toMainFrag();
        } else if (id == R.id.nav_groups) {
            toGroupsFrag();
       /* } else if (id == R.id.nav_new_task) {
            toCreateTaskFrag(); */
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
        Intent i = new Intent(this, LoginActivity.class);
        startActivity(i);
    }


    @Override
    public void onBackPressed() {
        Fragment currentFrag = getSupportFragmentManager().findFragmentById(R.id.fragment_container);
        if      (currentFrag instanceof MainFragment) {}
        else if (currentFrag instanceof GroupsFragment) {
            Transactor.fragmentMain(getSupportFragmentManager().beginTransaction());
        }
        else if (currentFrag instanceof GroupMainFragment) {
            Transactor.fragmentGroups(getSupportFragmentManager().beginTransaction(), false);
        }
        else if (currentFrag instanceof CreateTaskFragment) {
            Transactor.fragmentMainGroup(getSupportFragmentManager().beginTransaction(), ((CreateTaskFragment)currentFrag).getGroupId(), ((CreateTaskFragment)currentFrag).getGroupName());

        }
        else if (currentFrag instanceof ViewTaskFragment) {
            Transactor.fragmentMainGroup(getSupportFragmentManager().beginTransaction(), ((ViewTaskFragment)currentFrag).getGroupId(), ((ViewTaskFragment)currentFrag).getGroupName());

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
        Fragment currentFrag = getSupportFragmentManager().findFragmentById(R.id.fragment_container);
        if (currentFrag instanceof GroupsFragment) {
            fab_createGroup.setVisibility(View.VISIBLE);
            menuItem_createGroup.setVisible(true);
            menuItem_joinGroup.setVisible(true);
        }else{
            fab_createGroup.setVisibility(View.INVISIBLE);
            menuItem_createGroup.setVisible(false);
            menuItem_joinGroup.setVisible(false);
        }

        if(currentFrag instanceof GroupMainFragment) {
            menuItem_leaveGroup.setVisible(true);
        }
        else{
            menuItem_leaveGroup.setVisible(false);

        }

        if(currentFrag instanceof CreateSubjectFragment || currentFrag instanceof CreateTaskFragment) {
            fab_createGroup.setVisibility(View.INVISIBLE);

        }

        if(currentFrag instanceof GroupsFragment){
            navView.getMenu().getItem(1).setChecked(true);
        }else{
            navView.getMenu().getItem(1).setChecked(false);
        }

        if(currentFrag instanceof MainFragment){
            navView.getMenu().getItem(0).setChecked(true);
        }else{
            navView.getMenu().getItem(0).setChecked(false);
        }

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
