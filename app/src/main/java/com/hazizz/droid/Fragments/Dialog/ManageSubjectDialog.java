package com.hazizz.droid.Fragments.Dialog;

import android.content.DialogInterface;
import android.os.Bundle;
import android.support.v4.app.DialogFragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;

import com.hazizz.droid.AndroidThings;
import com.hazizz.droid.Communication.MiddleMan;
import com.hazizz.droid.Communication.POJO.Response.CustomResponseHandler;
import com.hazizz.droid.Communication.Requests.Subject.DeleteSubject;
import com.hazizz.droid.Communication.Requests.Subject.EditSubject;
import com.hazizz.droid.Communication.Strings;
import com.hazizz.droid.Fragments.GroupTabs.SubjectsFragment;
import com.hazizz.droid.Manager;
import com.hazizz.droid.R;
import com.hazizz.droid.Transactor;

public class ManageSubjectDialog extends DialogFragment {

    TextView textView_subjectName;
    EditText editText_subjectName;
    Button button_close;
    Button button_edit;
    Button button_delete;
    ImageView button_check_edit;

    long groupId, subjectId;
    String currentSubjectName;


    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View v = inflater.inflate(R.layout.dialog_fragment_manager_subject, container, false);

        groupId = getArguments().getLong(Strings.Path.GROUPID.toString());
        subjectId = getArguments().getLong(Strings.Path.SUBJECTID.toString());
        currentSubjectName = getArguments().getString("currentSubjectName");


        textView_subjectName = v.findViewById(R.id.textView_subjectName);
        editText_subjectName = v.findViewById(R.id.editText_subjectName);
        button_edit = v.findViewById(R.id.button_edit);
        button_delete = v.findViewById(R.id.button_delete);
        button_close = v.findViewById(R.id.button_close);
        button_check_edit = v.findViewById(R.id.imageButton_check_edit);

        if(Strings.Rank.MODERATOR.getValue() > Manager.MeInfo.getRankInCurrentGroup().getValue()){
            button_edit.setVisibility(View.INVISIBLE);
            button_delete.setVisibility(View.INVISIBLE);


        }

        textView_subjectName.setText(currentSubjectName);

        button_edit.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                editText_subjectName.setVisibility(View.VISIBLE);
                AndroidThings.openKeyboard(getContext(), editText_subjectName);
                editText_subjectName.setText(textView_subjectName.getText());
                editText_subjectName.setSelection(editText_subjectName.getText().length());

                textView_subjectName.setVisibility(View.INVISIBLE);
                editText_subjectName.setText(textView_subjectName.getText());
                button_check_edit.setVisibility(View.VISIBLE);


            }
        });

        button_check_edit.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                String newSubjectName = editText_subjectName.getText().toString();
                if(newSubjectName.length() > 1){
                    MiddleMan.newRequest(new EditSubject(getActivity(), new CustomResponseHandler() {
                        @Override
                        public void onSuccessfulResponse() {
                            editText_subjectName.setVisibility(View.INVISIBLE);
                            textView_subjectName.setVisibility(View.VISIBLE);
                            textView_subjectName.setText(editText_subjectName.getText().toString());
                            button_check_edit.setVisibility(View.INVISIBLE);

                            AndroidThings.closeKeyboard(getContext(), editText_subjectName);
                        }
                    }, groupId, subjectId, editText_subjectName.getText().toString()));
                }
            }
        });


        button_delete.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                MiddleMan.newRequest(new DeleteSubject(getActivity(), new CustomResponseHandler() {
                    @Override
                    public void onSuccessfulResponse() {
                        dismiss();
                        AndroidThings.closeKeyboard(getContext(), editText_subjectName);
                    }
                }, groupId, subjectId));
            }
        });

        button_close = v.findViewById(R.id.button_close);
        button_close.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                dismiss();
                AndroidThings.closeKeyboard(getContext(), editText_subjectName);
            }
        });


        return v;
    }

    @Override
    public void onDismiss(DialogInterface dialog) {
        super.onDismiss(dialog);
    //    ((SubjectsFragment)Transactor.getCurrentFragment(getFragmentManager(), false)).getSubjects(getActivity());
    }
}