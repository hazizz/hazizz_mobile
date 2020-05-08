import 'package:flutter/material.dart';
import 'package:mobile/services/task_similarity_checker.dart';

import 'listItems/similar_task_item_widget.dart';

class SimilarTasksWidget extends StatefulWidget {
  final List<TaskSimilarity> similarTasks;

  SimilarTasksWidget({Key key, @required this.similarTasks}) : super(key: key);


  @override
  _SimilarTasksWidgetState createState() => _SimilarTasksWidgetState();
}

class _SimilarTasksWidgetState extends State<SimilarTasksWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width - 10,
        height: MediaQuery.of(context).size.height -  80,
        padding: EdgeInsets.all(20),
        child: Card(
          child: Column(
            children: [
              Text("Similar tasks"),
              Expanded(
                child: ListView.builder(
                    itemCount: widget.similarTasks.length,
                    itemBuilder: (context, index){
                      return SimilarTaskItemWidget(taskSimilarity: widget.similarTasks[index],);
                    }
                ),
              ),
              Text("Wasn't this task created already?"),
              Row(
                children: <Widget>[
                  RaisedButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Text(
                      "Delete task",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: const Color(0xFF1BC0C5),
                  ),
                  Spacer(),
                  RaisedButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: Text(
                      "Create task",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: const Color(0xFF1BC0C5),
                  )
                ],
              )
            ],
          ),
        )
      ),
    );
  }
}