package com.hazizz.droid.listviews.TaskList;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.hazizz.droid.R;
import com.hazizz.droid.listviews.HeaderItem;
import com.hazizz.droid.listviews.Item;
import com.hazizz.droid.listviews.ItemTypeEnum;
import com.hazizz.droid.other.D8;

import java.util.List;

public class TaskItemAdapter  extends RecyclerView.Adapter<RecyclerView.ViewHolder> {
    Context context;

    List<Item> data;

    public static final int mainTasks = 0;
    public static final int groupTasks = 1;

    int taskMode;

    public TaskItemAdapter(Context context, List<Item> data, int taskMode) {
        this.context = context;
        this.data = data;
        this.taskMode = taskMode;

    }

    public static class TaskTypeViewHolder extends RecyclerView.ViewHolder {

        TextView taskTitle;
        TextView taskDescription;
        TextView taskFrom;
        TextView taskSubject;

        int type;

        public TaskTypeViewHolder(View itemView) {
            super(itemView);

            this.taskTitle = (TextView) itemView.findViewById(R.id.task_title);
            this.taskDescription = (TextView) itemView.findViewById(R.id.task_description);
            this.taskFrom = (TextView) itemView.findViewById(R.id.textView_group);
            this.taskSubject = (TextView) itemView.findViewById(R.id.textView_subject);

            type = 2;
        }
    }

    public static class HeaderTypeViewHolder extends RecyclerView.ViewHolder {

        TextView textView_title;
        TextView textView_deadline;

        int type;

        public HeaderTypeViewHolder(View itemView) {
            super(itemView);

            this.textView_title = (TextView) itemView.findViewById(R.id.textView_title);
            this.textView_deadline = (TextView) itemView.findViewById(R.id.textView_deadline);

            type = 1;
        }
    }

    @Override
    public int getItemViewType(int position) {
        // Just as an example, return 0 or 2 depending on position
        // Note that unlike in ListView adapters, types don't have to be contiguous

      //  Log.e("hey", "itemType32: " + data.get(position).getType().getValue());

        if (data.get(position) instanceof TaskItem) {
            return ItemTypeEnum.TASK.getValue();
        } else if (data.get(position) instanceof HeaderItem) {
            return ItemTypeEnum.HEADER.getValue();
        }
        return -1;

        /*
        if (data.get(position).getType().equals(ItemTypeEnum.TASK)) {

        } else if (data.get(position).getType().equals(ItemTypeEnum.HEADER)) {

        }
        return data.get(position).getType().getValue();
        */

    }

    @Override
    public int getItemCount() {
        return data.size();
    }

    public Item getItem(int i) {
        return data.get(i);
    }

    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view;


        if (ItemTypeEnum.HEADER.getValue() == viewType) {
            view = LayoutInflater.from(parent.getContext()).inflate(R.layout.header_item, parent, false);
            return new HeaderTypeViewHolder(view);
        } else if (ItemTypeEnum.TASK.getValue() == viewType) {
            view = LayoutInflater.from(parent.getContext()).inflate(R.layout.task_main_item, parent, false);
            return new TaskTypeViewHolder(view);
        }

        return null;
    }

    @Override
    public void onBindViewHolder(final RecyclerView.ViewHolder holder, final int position) {
        Item object = data.get(position);
        if (object != null) {
            if (ItemTypeEnum.HEADER.getValue() == holder.getItemViewType()) {// ItemTypeEnum.HEADER.getValue() == object.getType().getValue()

                HeaderItem headerItem = (HeaderItem) object;
                HeaderTypeViewHolder headerHolder = ((HeaderTypeViewHolder) holder);

                String date = headerItem.getDate();

                int daysLeft = D8.textToDate(date).daysLeft();
                String deadline = D8.textToDate(date).getMainFormat();

                String title;
                if (daysLeft == 0) {
                    title = context.getResources().getString(R.string.today);
                } else if (daysLeft == 1) {
                    title = context.getResources().getString(R.string.tomorrow);
                } else {
                    title = context.getResources().getString(R.string.header_item_in) + " " + daysLeft + " " + context.getResources().getString(R.string.header_item_day) + " " + context.getResources().getString(R.string.header_item_later);
                }

                headerHolder.textView_title.setText(title);
                headerHolder.textView_deadline.setText(deadline);

            } else if (ItemTypeEnum.TASK.getValue() == holder.getItemViewType()) {//object instanceof TaskItem
                TaskItem taskItem = (TaskItem) object;
                TaskTypeViewHolder taskHolder = ((TaskTypeViewHolder) holder);

                taskHolder.taskTitle.setText(taskItem.getTaskTitle());
                taskHolder.taskDescription.setText(taskItem.getTaskDescription());

                if(taskMode == mainTasks) {
                    if (taskItem.getGroup() != null) {
                        taskHolder.taskFrom.setText(taskItem.getGroup().getName());
                    }else {
                        taskHolder.taskFrom.setVisibility(View.GONE);
                    }
                }else{
                    taskHolder.taskFrom.setText(taskItem.getCreator().getDisplayName());
                }
                if(taskItem.getSubject() != null) {
                    taskHolder.taskSubject.setText(taskItem.getSubject().getName() + ":");
                }else{
                    taskHolder.taskSubject.setVisibility(View.GONE);
                }

            }
        }
    }

    public void clear(){
        data.clear();
        notifyDataSetChanged();
    }
}