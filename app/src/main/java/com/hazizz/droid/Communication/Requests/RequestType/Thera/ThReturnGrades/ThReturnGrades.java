package com.hazizz.droid.Communication.Requests.RequestType.Thera.ThReturnGrades;

import android.app.Activity;
import android.util.Log;

import com.google.gson.reflect.TypeToken;
import com.hazizz.droid.Communication.POJO.Response.CustomResponseHandler;
import com.hazizz.droid.Communication.Requests.Parent.ThRequest;
import com.hazizz.droid.Listviews.TheraGradesList.TheraGradesItem;

import java.lang.reflect.Type;
import java.util.HashMap;
import java.util.List;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class ThReturnGrades extends ThRequest {
    String p_sessionId;

    public ThReturnGrades(Activity act, CustomResponseHandler rh, int p_sessionId) {
        super(act, rh);
        Log.e("hey", "created ThReturnGrades object");
        this.p_sessionId = Integer.toString(p_sessionId);

    }
    public void setupCall() {
        headerMap.put(HEADER_AUTH, getHeaderAuthToken());
        headerMap.put("Accept", HEADER_VALUE_CONTENTTYPE);

        call = aRequest.th_returnGrades(p_sessionId ,headerMap);
    }

    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {
        Type listType = new TypeToken<HashMap<String, List<TheraGradesItem>>>(){}.getType();
        HashMap<String, List<TheraGradesItem>> castedMap = gson.fromJson(response.body().charStream(), listType);
        Log.e("hey", "grade: " + castedMap.get("angol nyelv").get(0).getWeight());
        cOnResponse.onPOJOResponse(castedMap);
    }
}


/*

    View listItem = convertView;
    if(listItem == null)
    listItem = LayoutInflater.from(mContext).inflate(R.layout.list_item,parent,false);

    Movie currentMovie = moviesList.get(position);

    ImageView image = (ImageView)listItem.findViewById(R.id.imageView_poster);
    image.setImageResource(currentMovie.getmImageDrawable());

    TextView name = (TextView) listItem.findViewById(R.id.textView_name);
    name.setText(currentMovie.getmName());

    TextView release = (TextView) listItem.findViewById(R.id.textView_release);
    release.setText(currentMovie.getmRelease());

    return listItem;
*/
    /*
    DataHolder holder = null;

        View listItem = convertView;

        if(listItem == null) {

            listItem = LayoutInflater.from(context).inflate(R.layout.th_grade_subject_item,parent,false);

            LayoutInflater inflater = ((Activity) context).getLayoutInflater();

            convertView = inflater.inflate(picID, parent, false);

            holder = new DataHolder();
            //holder.textView_grade_example = convertView.findViewById(R.id.textView_grade_example);
            holder.textView_subjectName = convertView.findViewById(R.id.textView_subjectName);
            holder.homeMadeList_grades = (LinearLayout) convertView.findViewById(R.id.linearLayout_grades);

            convertView.setTag(holder);
        }else{
            holder = (DataHolder)convertView.getTag();
        }
    * */


