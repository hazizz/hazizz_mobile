package com.indeed.hazizz.Activities;

import android.os.Bundle;
import android.support.design.widget.FloatingActionButton;
import android.support.design.widget.Snackbar;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentTransaction;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.support.design.widget.NavigationView;
import android.support.v4.view.GravityCompat;
import android.support.v4.widget.DrawerLayout;
import android.support.v7.app.ActionBarDrawerToggle;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.TextView;

import com.indeed.hazizz.Communication.MiddleMan;
import com.indeed.hazizz.Communication.POJO.Response.CustomResponseHandler;
import com.indeed.hazizz.Communication.POJO.Response.POJOgroup;
import com.indeed.hazizz.Communication.POJO.Response.POJOme;
import com.indeed.hazizz.Fragments.ChatFragment;
import com.indeed.hazizz.Fragments.GroupFragment;
import com.indeed.hazizz.Listviews.GroupList.CustomAdapter;
import com.indeed.hazizz.Listviews.GroupList.GroupItem;
import com.indeed.hazizz.R;
import com.indeed.hazizz.SharedPrefs;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

public class MainActivity extends AppCompatActivity
        implements NavigationView.OnNavigationItemSelectedListener {

    private TextView textView_userName;
    private TextView textView_email;

    private ArrayList<Integer> groupIDs;

    private List<GroupItem> listGroup;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);

        groupIDs = new ArrayList<Integer>();

        FloatingActionButton fab = (FloatingActionButton) findViewById(R.id.fab);
        fab.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Snackbar.make(view, "Replace with your own action", Snackbar.LENGTH_LONG)
                        .setAction("Action", null).show();
            }
        });

        NavigationView navigationView = (NavigationView) findViewById(R.id.nav_view);
        navigationView.setNavigationItemSelectedListener(this);
        navigationView.bringToFront();

        View headerView = navigationView.getHeaderView(0);
        TextView navUsername = (TextView) headerView.findViewById(R.id.textView_userName);
        TextView navEmail = (TextView) headerView.findViewById(R.id.textView_email);

        CustomResponseHandler responseHandler = new CustomResponseHandler() {
            @Override
            public void onResponse(HashMap<String, Object> response) {
            }

            @Override
            public void onPOJOResponse(Object response) {
                navUsername.setText(((POJOme) response).getUsername());
                navEmail.setText(((POJOme) response).getEmailAddress());

                for(POJOgroup g : ((POJOme) response).getGroups()){
                    groupIDs.add(g.getId());
                    Log.e("hey", "added groupID");
                }
        }

            @Override
            public void onFailure() {
                Log.e("hey", "4");
                Log.e("hey", "got here onFailure");
            }
            @Override
            public void onErrorResponse(HashMap<String, Object> errorResponse) {
                Log.e("hey", "onErrorResponse");
            }
        };

        MiddleMan.newRequest(getBaseContext(), "me", null, responseHandler);

     /*   ListView name = (ListView)findViewById(R.id.listView1);

        listGroup = new ArrayList<>();

        for(int i = 0; i < 10; i++) {
            listGroup.add(new GroupItem(R.drawable.ic_launcher_background, "a Group Name"));
        }

        ListView listView = (ListView)findViewById(R.id.listView1);

        CustomAdapter adapter = new CustomAdapter(this, R.layout.list_item, listGroup);

        if(adapter == null){
            Log.e("hey", "adapter is null");

        }
        if(listView == null){
            Log.e("hey", "listView is null");
        }

        Log.e("hey", "all set0");

        listView.setAdapter(adapter);

        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> adapterView, View view, int i, long l) {
                Log.e("hey", "clicked");
            }
        });
        Log.e("hey", "all set"); */

    }

    @Override
    public void onBackPressed() {
        DrawerLayout drawer = (DrawerLayout) findViewById(R.id.drawer_layout);
        if (drawer.isDrawerOpen(GravityCompat.START)) {
            drawer.closeDrawer(GravityCompat.START);
        } else {
            super.onBackPressed();
        }
    }

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

        if (id == R.id.nav_groups) {
            // TODO send groupIDs to fragment
            Bundle bundle = new Bundle();
            bundle.putIntegerArrayList("groupIDs", groupIDs);
            GroupFragment groupFragment = new GroupFragment();
            groupFragment.setArguments(bundle);

            makeTransaction(groupFragment);

        } else if (id == R.id.nav_unfinished_homeworks) {
            ChatFragment chatFragment = new ChatFragment();
            makeTransaction(chatFragment);
        } else if (id == R.id.nav_finished_homeworks) {

        } else if (id == R.id.nav_manage) {

        } else if (id == R.id.nav_share) {

        } else if (id == R.id.nav_send) {

        }
        DrawerLayout drawer = (DrawerLayout) findViewById(R.id.drawer_layout);
        drawer.closeDrawer(GravityCompat.START);
        return true;
    }

    public void makeTransaction(Fragment frag){
        FragmentTransaction fragmentTransaction = getSupportFragmentManager().beginTransaction();
        fragmentTransaction.add(R.id.fragment_container, frag);
        fragmentTransaction.commit();
    }
}
