package com.hazizz.droid.Fragments.Dialog;

import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.DialogFragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.TextView;

import com.hazizz.droid.R;
import com.hazizz.droid.Transactor;

public class InviteLinkDialogFragment extends DialogFragment {

    long groupId;
    String groupName;

    String inviteLink;

    TextView textView_link;
    TextView textView_info;

    Button button_share;
    Button button_copyLink;

    Button button_close;


    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View v = inflater.inflate(R.layout.dialog_fragment_invite_link, container, false);


        groupId = getArguments().getLong(Transactor.KEY_GROUPID);
        groupName = getArguments().getString(Transactor.KEY_GROUPNAME);

        textView_info = v.findViewById(R.id.textView_info);
        textView_info.setText(getResources().getText(R.string.invite_link_info) + " " + groupName + getResources().getText(R.string.invite_link_info_part2) + ":");
        textView_link = v.findViewById(R.id.textView_link);
        button_copyLink = v.findViewById(R.id.button_copyLink);
        button_copyLink.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if(inviteLink != null && !inviteLink.equals("")) {
                    ClipboardManager clipboard = (ClipboardManager) getContext().getSystemService(Context.CLIPBOARD_SERVICE);
                    ClipData clip = ClipData.newPlainText("this is a label123", textView_link.getText().toString());
                    clipboard.setPrimaryClip(clip);
                }
            }
        });

        button_share = v.findViewById(R.id.button_share);
        button_share.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if(inviteLink != null && !inviteLink.equals("")) {
                    try {
                        Intent shareIntent = new Intent(Intent.ACTION_SEND);
                        shareIntent.setType("text/plain");
                        shareIntent.putExtra(Intent.EXTRA_SUBJECT, R.string.app_name);
                        String shareMessage = "\n" +
                                              getResources().getString(R.string.invite_to_group_text_title) + " " +
                                              getResources().getString(R.string.invite_to_group_text_part1) + " " +
                                              groupName + " " +
                                              getResources().getString(R.string.invite_to_group_text_part2) +
                                              "\n\n" + inviteLink;
                        shareIntent.putExtra(Intent.EXTRA_TEXT, shareMessage);
                        startActivity(Intent.createChooser(shareIntent, getResources().getString(R.string.share)));
                    } catch (Exception e) {
                        //e.toString();
                    }
                }
            }
        });



        button_close = v.findViewById(R.id.button_close);
        button_close.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                dismiss();
            }
        });


        /*
        MiddleMan.newRequest(new ReturnInvitationLink(getActivity(), new CustomResponseHandler() {
            @Override
            public void onPOJOResponse(Object response) {
                inviteLink = (String)response;
                textView_link.setText(inviteLink);
            }
        }, groupId));
        */

        inviteLink = "https://hazizz.duckdns.org:9000/shortener?groupinvite=" + groupId;
        textView_link.setText(inviteLink);

        return v;
    }
}