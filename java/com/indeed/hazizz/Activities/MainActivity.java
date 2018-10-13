package com.indeed.hazizz.Activities;

//import android.app.Fragment;
import android.app.FragmentManager;
import android.os.Bundle;
import android.support.design.widget.FloatingActionButton;
import android.support.design.widget.Snackbar;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentTransaction;
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

    private TextView navUsername;
    private TextView navEmail;
    private TextView navLogout;

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
        public void onNoResponse() {
            Log.e("hey", "NO RESPONSE");

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

        FloatingActionButton fab = (FloatingActionButton) findViewById(R.id.fab);
        fab.setOnClickListener(new View.OnClickListener() {
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
                else {
                    toGroupsFrag();
                }
            }
        });

        NavigationView navigationView = (NavigationView) findViewById(R.id.nav_view);
        navigationView.setNavigationItemSelectedListener(this);
        navigationView.bringToFront();

        View headerView = navigationView.getHeaderView(0);
        navUsername = (TextView) headerView.findViewById(R.id.textView_userName);
        navEmail = (TextView) headerView.findViewById(R.id.textView_email);
        navLogout = headerView.findViewById(R.id.textView_logout);

        MiddleMan.newRequest(getBaseContext(), "me", null, responseHandler, null);
        toMainFrag();
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
        getMenuInflater().inflate(R.menu.main, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            Log.e("hey", "action_settings");
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

    void toCreateTaskFrag(){
        Transactor.fragmentGroups(getSupportFragmentManager().beginTransaction(), true);
    }

  /*  @Override
    public void onBackPressed() {
        Log.e("hey", "onBackPressed in MainActivity");
        Fragment currentFrag = getSupportFragmentManager().findFragmentById(R.id.fragment_container);
        if (currentFrag instanceof GroupMainFragment) {
            Log.e("hey", "instance of groupmain fragment");
            Transactor.makeTransaction(new MainFragment(), getSupportFragmentManager().beginTransaction(),true, FragTag.groups.toString(), groupIDs);
        }
        if (currentFrag instanceof ViewTaskFragment) {
            Transactor.makeTransaction(new GroupMainFragment(), getSupportFragmentManager().beginTransaction(),true, FragTag.groups.toString(), groupIDs);

        }
        else if(currentFrag instanceof CreateTaskFragment || currentFrag instanceof GroupsFragment){}
        else {
            toGroupsFrag();
        }
    } */

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
