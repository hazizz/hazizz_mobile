package com.hazizz.droid.fragments.ParentFragment;

import com.hazizz.droid.activities.BaseActivity;
import com.hazizz.droid.listeners.GenericListener;

public class TabFragment extends ParentFragment {

    private GenericListener onViewSetListener = new GenericListener() {
        @Override
        public void execute() {

        }
    };

    protected int groupId;
    protected String groupName;

    public boolean isViewShown = false;

    @Override
    protected void fragmentSetup(BaseActivity baseActivity) {
        super.fragmentSetup(baseActivity);
    }


    public void onTabSelected(){ }


    public void setOnViewSetListener(GenericListener onViewSetListener){
        this.onViewSetListener = onViewSetListener;
    }

    public void onViewSet(){
        onViewSetListener.execute();
    }


}
