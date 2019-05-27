

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hazizz/communication/ResponseHandler.dart';
import 'package:flutter_hazizz/communication/pojos/PojoError.dart';
import 'package:flutter_hazizz/communication/pojos/PojoGroup.dart';
import 'package:flutter_hazizz/communication/requests/request_collection.dart';
import 'package:flutter_hazizz/converters/PojoConverter.dart';

import '../RequestSender.dart';

/*
class ChooseGroupDialog extends SimpleDialog{
  super({
    title: const Text('Choose an animal'),
    children: <Widget>[
    optionOne,
    optionTwo,
    optionThree,
    optionFour,
    optionFive,
    ],
  }){

  }
  EditTaskPage({Key key, this.taskId}) : super(key: key);

}
*/
void showDialogGroup(BuildContext context, Function(PojoGroup) onPicked) async{
  // flutter defined function
  List<PojoGroup> myGroups_data;
  Response response = await RequestSender().send(new GetMyGroups(
      rh: new ResponseHandler(
          onSuccessful: (Response response) async{
            print("raw response is : ${response.data}" );
              Iterable iter = getIterable(response.data);
              // Iterable parsed = jsonDecode(response.data).cast<Map<String, dynamic>>();
              myGroups_data =  iter.map<PojoGroup>((json) => PojoGroup.fromJson(json)).toList();
          },
          onError: (PojoError pojoError){
            print("log: the annonymus functions work and the errorCode : ${pojoError.errorCode}");
          }
      )));


  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
       // title: new Text("Alert Dialog title"),
        content: Container(
          height: 800,
          width: 800,
          child: ListView.builder(
              itemCount: myGroups_data.length,
              itemBuilder: (BuildContext context, int index){
                  return GestureDetector(
                    onTap: (){
                      onPicked(myGroups_data[index]);
                      Navigator.of(context).pop();

                    },
                    child: Text(myGroups_data[index].name,
                      style: TextStyle(
                        fontSize: 26
                      ),
                    )

                  );
                },
          ),
        ),

        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          new FlatButton(
            child: new Text("Close"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}


