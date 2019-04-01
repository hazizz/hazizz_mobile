package com.hazizz.droid.Fragments.ParentFragment;

import android.support.v4.app.Fragment;
import android.view.View;

import com.hazizz.droid.Activities.MainActivity;
import com.hazizz.droid.AndroidThings;
import com.hazizz.droid.Listener.OnBackPressedListener;

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
    protected void fragmentSetup(CharSequence title){
        ((MainActivity)getActivity()).onFragmentCreated();
        if(title != null){
            setTitle(title);
        }
    }

    protected void setOnBackPressedListener(OnBackPressedListener onBackPressedListener){
        ((MainActivity)getActivity()).setOnBackPressedListener(onBackPressedListener);
    }

    /*
    @Override
    public void onDestroy() {
        super.onDestroy();

        Log.e("hey", "22 Parent onDestroy called");
    }
    */

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
