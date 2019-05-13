package com.hazizz.droid.fragments.ParentFragment;

import android.support.v4.app.Fragment;
import android.view.View;

import com.hazizz.droid.activities.BaseActivity;
import com.hazizz.droid.activities.MainActivity;
import com.hazizz.droid.other.AndroidThings;
import com.hazizz.droid.listeners.OnBackPressedListener;

public class ParentFragment extends Fragment {

    protected View v;

    protected BaseActivity baseActivity;

    // fragment setup needs to be called first
    protected void fragmentSetup(BaseActivity baseActivity){
        this.baseActivity = baseActivity;
        baseActivity.onFragmentAdded();
    }
    // fragment setup needs to be called first
    protected void fragmentSetup(BaseActivity baseActivity, int titleId){
        this.baseActivity = baseActivity;
        baseActivity.onFragmentAdded();
        if(titleId != 0){
            setTitle(titleId);
        }
    }

    protected void setTitle(int titleId){
        baseActivity.setTitle(titleId);
    }

    protected void setTitle(CharSequence title){
        baseActivity.setTitle(title);
    }




    protected void setOnBackPressedListener(OnBackPressedListener onBackPressedListener){
        baseActivity.setOnBackPressedListener(onBackPressedListener);
    }

    protected void clearFragment(){
        baseActivity.removeOnBackPressedListener();
        AndroidThings.closeKeyboard(baseActivity, v);
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        AndroidThings.closeKeyboard(baseActivity, v);
    }

    @Override
    public void onDestroyView() {
        super.onDestroyView();
        AndroidThings.closeKeyboard(baseActivity, v);
    }
}
