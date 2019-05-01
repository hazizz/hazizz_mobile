package com.hazizz.droid.fragments.ParentFragment;

import android.support.v4.app.Fragment;
import android.view.View;

import com.hazizz.droid.activities.MainActivity;
import com.hazizz.droid.other.AndroidThings;
import com.hazizz.droid.listeners.OnBackPressedListener;

public class ParentFragment extends Fragment {

    protected View v;


    protected void fragmentSetup(){
        ((MainActivity)getActivity()).onFragmentCreated();
    }

    protected void setTitle(int titleId){
        getActivity().setTitle(titleId);
    }

    protected void setTitle(CharSequence title){
        getActivity().setTitle(title);
    }


    protected void fragmentSetup(int titleId){
        ((MainActivity)getActivity()).onFragmentCreated();
        if(titleId != 0){
            setTitle(titleId);
        }
    }

    protected void setOnBackPressedListener(OnBackPressedListener onBackPressedListener){
        ((MainActivity)getActivity()).setOnBackPressedListener(onBackPressedListener);
    }

    protected void clearFragment(){
        ((MainActivity)getActivity()).removeOnBackPressedListener();
        AndroidThings.closeKeyboard(getContext(), v);
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        AndroidThings.closeKeyboard(getContext(), v);
    }
}
