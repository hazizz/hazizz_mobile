package com.hazizz.droid.Fragments.ParentFragment;

import com.hazizz.droid.Listener.GenericListener;

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
    protected void fragmentSetup() {
        super.fragmentSetup();
    }


    public void onTabSelected(){ }


    public void setOnViewSetListener(GenericListener onViewSetListener){
        this.onViewSetListener = onViewSetListener;
    }

    public void onViewSet(){
        onViewSetListener.execute();
    }


}