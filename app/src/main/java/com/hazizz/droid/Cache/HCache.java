package com.hazizz.droid.cache;

import android.content.Context;
import android.util.Log;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;
import com.hazizz.droid.Communication.requests.GetAnnouncementsFromGroup;
import com.hazizz.droid.Communication.requests.GetTasksFromGroup;
import com.hazizz.droid.Communication.responsePojos.announcementPojos.PojoAnnouncement;
import com.hazizz.droid.Communication.responsePojos.taskPojos.PojoTask;
import com.hazizz.droid.listviews.SubjectList.SubjectItem;
import com.hazizz.droid.other.SharedPrefs;

import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.List;

public class HCache {
    private Gson gson = new GsonBuilder().serializeNulls().create(); // .excludeFieldsWithoutExposeAnnotation()

    private static HCache instance = null;
    private HCache(){ }

    public static HCache getInstance() {
        if(instance == null){
            instance = new HCache();
        }
        return instance;
    }

    private static final String fileName_groupIds = "groupIds";
    private static final String fileName_all = "all";
    private static final String key_tasks = "tasks";
    private static final String key_announcements = "announcements";


    private static final int notFound = 0;


    List<PojoTask> tasksFromMe = new ArrayList<>();
    List<PojoAnnouncement> announcementsFromMe = new ArrayList<>();

    public void setTasksFromMe(Context context, String serializedArrayListTasks){
        SharedPrefs.save(context, fileName_all, key_tasks, serializedArrayListTasks);
    }
    public List< PojoTask> getTasksFromMe(Context context){
        String serialized = SharedPrefs.getString(context, fileName_all, key_tasks, null);
        Type listType = new TypeToken<ArrayList< PojoTask>>(){}.getType();
        return gson.fromJson(serialized, listType);
    }

    public void setAnnouncementsFromMe(Context context, String serializedArrayListAnnouncements){
        SharedPrefs.save(context, fileName_all, key_announcements, serializedArrayListAnnouncements);
    }
    public List<PojoAnnouncement> getAnnouncementsFromMe(Context context){
        String serialized = SharedPrefs.getString(context, fileName_all, key_announcements, null);
        Type listType = new TypeToken<ArrayList<PojoAnnouncement>>(){}.getType();
        return gson.fromJson(serialized, listType);
    }

    public Group getGroup(Context context, long groupId){
        // if there is group data cached
        if(SharedPrefs.getLong(context, fileName_groupIds, Long.toString(groupId), notFound) != notFound ){
            return new Group(groupId);
        }else{
            return new Group(groupId);
        }
    }

    public class Group{
        private String fileName_group = "group";

        private final String key_tasks = "tasks";
        private final String key_announcements = "announcements";
        private final String key_subjects = "subjects";
        private final String key_members = "members";

        private long groupId;

        List<GetTasksFromGroup> tasksFromGroup = new ArrayList<>();
        List<GetAnnouncementsFromGroup> announcementsFromGroup = new ArrayList<>();
        List<SubjectItem> subjectsFromGroup = new ArrayList<>();
        List<Member> membersFromGroup = new ArrayList<>();

        Group(long groupId){
            this.groupId = groupId;
            fileName_group = fileName_group + groupId;
        }

        public void setTasks(Context context, String serializedArrayListTasks){
            Log.e("hey", "setTasks cache");
            Log.e("hey", "setTasks cache2: " + serializedArrayListTasks);
            SharedPrefs.save(context, fileName_group, key_tasks, serializedArrayListTasks);
        }

        public void setAnnouncements(Context context, String serializedArrayListAnnouncements){
            SharedPrefs.save(context, fileName_group, key_announcements, serializedArrayListAnnouncements);
        }

        public void setSubjects(Context context, String serializedArrayListSubjects){
            SharedPrefs.save(context, fileName_group, key_subjects, serializedArrayListSubjects);
        }

        public void setMembers(Context context, String serializedArrayListMembers){
            SharedPrefs.save(context, fileName_group, key_members, serializedArrayListMembers);

        }

        public List< PojoTask> getTasks(Context context){
            String serialized = SharedPrefs.getString(context, fileName_group, key_tasks, null);
            Type listType = new TypeToken<ArrayList< PojoTask>>(){}.getType();
            return gson.fromJson(serialized, listType);
        }

        public List<GetAnnouncementsFromGroup> getAnnouncements(Context context){
            String serialized = SharedPrefs.getString(context, fileName_group, key_announcements, null);

            Type listType = new TypeToken<ArrayList<GetAnnouncementsFromGroup>>(){}.getType();

            return gson.fromJson(serialized, listType);
        }

        public List<SubjectItem> getSubjects(Context context ){
            String serialized = SharedPrefs.getString(context, fileName_group, key_subjects, null);

            Type listType = new TypeToken<ArrayList<SubjectItem>>(){}.getType();

            return gson.fromJson(serialized, listType);
        }

        public List<Member> getMembers(Context context){
            String serialized = SharedPrefs.getString(context, fileName_group, key_members, null);

            Type listType = new TypeToken<ArrayList<Member>>(){}.getType();

            return gson.fromJson(serialized, listType);
        }



    }






}
