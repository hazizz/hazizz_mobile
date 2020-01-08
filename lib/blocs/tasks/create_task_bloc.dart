


import 'package:googleapis/drive/v3.dart' as driveapi;
import 'package:mobile/blocs/item_list/item_list_picker_bloc.dart';
import 'package:mobile/blocs/other/date_time_picker_bloc.dart';
import 'package:mobile/blocs/main_tab/main_tab_blocs.dart';
import 'package:mobile/blocs/other/response_states.dart';
import 'package:mobile/blocs/other/text_form_bloc.dart';
import 'package:mobile/blocs/tasks/task_maker_blocs.dart';
import 'package:mobile/blocs/tasks/tasks_bloc.dart';
import 'package:mobile/communication/pojos/PojoGroup.dart';
import 'package:mobile/communication/pojos/PojoSubject.dart';
import 'package:mobile/communication/pojos/PojoTag.dart';
import 'package:mobile/communication/pojos/task/PojoTask.dart';
import 'package:mobile/communication/requests/request_collection.dart';
import 'package:mobile/custom/hazizz_logger.dart';
import 'package:mobile/communication/request_sender.dart';
import 'package:mobile/communication/hazizz_response.dart';
import 'package:mobile/custom/image_operations.dart';
import 'package:mobile/managers/app_state_restorer.dart';
import 'package:mobile/widgets/image_viewer_widget.dart';

import '../../managers/google_drive_manager.dart';


//region EditTask bloc parts
//region EditTask events
abstract class TaskCreateEvent extends TaskMakerEvent {
  TaskCreateEvent([List props = const []]) : super(props);
}

class InitializeTaskCreateEvent extends TaskCreateEvent {
  final PojoGroup group;
  InitializeTaskCreateEvent({this.group}) :   super([group]);
  @override
  String toString() => 'InitializeTaskCreateState';
  List<Object> get props => [group];
}
//endregion

//region TaskCreate state
abstract class TaskCreateState extends TaskMakerState {
  TaskCreateState([List props = const []]) : super(props);
}

class InitializedTaskCreateState extends TaskCreateState {
  final PojoGroup group;
  InitializedTaskCreateState({this.group}) : super([group]);

  String toString() => 'InitializeTaskEditState';
  List<Object> get props => [group];
}
//endregion

//region TaskCreate bloc
class TaskCreateBloc extends TaskMakerBloc {

  PojoGroup group;

  TaskMakerAppState taskMakerAppState;

  TaskCreateBloc({this.group, this.taskMakerAppState}) : super(){

    if(taskMakerAppState != null){
      PojoTask t = taskMakerAppState.pojoTask;

      for(PojoTag t in t.tags){
        taskTagBloc.dispatch(TaskTagAddEvent(t));
      }

      if(t.subject != null) subjectItemPickerBloc.dispatch(PickedSubjectEvent(item: t.subject));
      if(t.group != null) groupItemPickerBloc.dispatch(PickedGroupEvent(item: t.group));
      if(t.description != null) descriptionBloc.dispatch(TextFormSetEvent(text: t.description));
      if(t.dueDate != null) deadlineBloc.dispatch(DateTimePickedEvent(dateTime: t.dueDate));
    }else{
      taskTagBloc.dispatch(TaskTagAddEvent(PojoTag.defaultTags[0]));
    }
  }
 
  @override
  Stream<TaskMakerState> mapEventToState(TaskMakerEvent event) async*{
    if(event is TaskMakerFailedEvent){
      yield TaskMakerFailedState();
    }
    if(event is InitializeTaskCreateEvent){
      yield InitializedTaskCreateState(group: event.group);

      if(group != null) {
        groupItemPickerBloc.dispatch(PickedGroupEvent(item: group));
      }
    }
    else if(event is TaskMakerSaveStateEvent){
      PojoGroup group;
      PojoSubject subject;
      List<String> tags = List();
      DateTime deadline;
      String description;

      String salt = event.salt;

      taskTagBloc.pickedTags.forEach((f){tags.add(f.name);});


      HazizzLogger.printLog("nuno: 1");


      ItemListState groupState =  groupItemPickerBloc.currentState;

      if (groupState is PickedGroupState) {
        group = groupItemPickerBloc.pickedItem;
        HazizzLogger.printLog("nuno: 2");
      }
      HState subjectState = subjectItemPickerBloc.currentState;
      if(subjectState is PickedSubjectState) {
        subject = subjectState.item;
      }

      DateTimePickerState deadlineState = deadlineBloc.currentState;
      if(deadlineState is DateTimePickedState) {
        deadline = deadlineState.dateTime;
      }


      description = descriptionBloc.lastText ?? "";


      PojoTask pojoTaskToSave = PojoTask(
        salt: salt,
        group: group,
        subject: subject,
        description: description,
        tags: taskTagBloc.pickedTags,
        dueDate: deadline
      );
      HazizzLogger.printLog("nuno: 3");


      List<String> imagePaths = [];
      for(HazizzImageData i in event.imageDatas){
        if(i.imageType == ImageType.FILE){
          imagePaths.add(i.imageFile.path);
        }else if(i.imageType == ImageType.GOOGLE_DRIVE){
          imagePaths.add(i.url);
        }
      }

      AppStateRestorer.saveTaskState(TaskMakerAppState(
        pojoTask: pojoTaskToSave,
        taskMakerMode: TaskMakerMode.create,
        imagePaths: imagePaths
      ));
      HazizzLogger.printLog("nuno: finished");



    }
    else if (event is TaskMakerSendEvent) {
      HazizzLogger.printLog("log: event: TaskMakerSendEvent");
      try {
        yield TaskMakerWaitingState();

        HazizzLogger.printLog("log: lul1");

        //region send
        int groupId, subjectId;
        List<String> tags = List();
        DateTime deadline;
        String description;

        String salt = event.salt;

        bool missingInfo = false;


        /*
        TaskTypePickerState typeState = taskTypePickerBloc.currentState;
        if(typeState is TaskTypePickedState){
          tags[0] = typeState.tag.getName();
        }
        */


        taskTagBloc.pickedTags.forEach((f){tags.add(f.name);});


        HazizzLogger.printLog("log: lul11");


        ItemListState groupState =  groupItemPickerBloc.currentState;

        if (groupState is PickedGroupState) {
          groupId = groupItemPickerBloc.pickedItem.id;
          HazizzLogger.printLog("log: lulu0");
        } else {
          HazizzLogger.printLog("log: lulu1");
          groupItemPickerBloc.dispatch(NotPickedEvent());
          HazizzLogger.printLog("log: lulu2");
          missingInfo = true;
        }




        HState subjectState = subjectItemPickerBloc.currentState;
        if(subjectState is PickedSubjectState) {
          subjectId = subjectState.item.id;
        }else{
          if(groupId != 0){
            HazizzLogger.printLog("log: subjectItemPickerBloc.add(NotPickedEvent());");

            subjectItemPickerBloc.dispatch(NotPickedEvent());
            missingInfo = true;
          }
        }
        HazizzLogger.printLog("log: lul12");

        HazizzLogger.printLog("log: lul2");


        DateTimePickerState deadlineState = deadlineBloc.currentState;
        if(deadlineState is DateTimePickedState) {
          deadline = deadlineState.dateTime;
        }else{
          deadlineBloc.dispatch(DateTimeNotPickedEvent());
          missingInfo = true;
        }


        description = descriptionBloc.lastText ?? "";


        HazizzLogger.printLog("log: lul3");


        if(missingInfo){
          HazizzLogger.printLog("log: missing info");
          this.dispatch(TaskMakerFailedEvent());
          return;
        }
        HazizzLogger.printLog("log: not missing info");

        List<String> imageUrls = [];
        String imageUrlsDesc = "";

        if(event.imageDatas != null && event.imageDatas.isNotEmpty){
        /*  List<List<int>> compressedImages = List();

          for(File file in event.images){
              List<int> result = await FlutterImageCompress.compressWithFile(
                file.absolute.path,
                minWidth: 2300,
                minHeight: 1500,
                quality: 94,
                rotate: 90,
              );
              compressedImages.add(result);
          }
          */
        //  ivsalt = CryptKey().genDart(8);
        //  key = HazizzCrypt.generateKey();
      /*    for(EncryptedImageData d in event.imageDatas){
            HazizzResponse imgUploadResponse = await RequestSender().getResponse(new UploadImage(
                imageData: d, key: d.key, iv: d.iv
            ));
            if(imgUploadResponse.isSuccessful){
              imgUrl = imgUploadResponse.convertedData;
            }
          }
          List<Future<HazizzResponse>> requests = [];
          */

      /*
          await GoogleDriveManager().initialize();
          List<Future<HazizzResponse>> responses = [];
          for(HazizzImageData d in event.imageDatas){
            fimageUrls.add(GoogleDriveManager().uploadImageToDrive(d));
           /* responses.add(RequestSender().getResponse(new UploadImage(
                imageData: d, key: d.key, iv: d.iv
            )));
            */
          }

          await Future.wait(fimageUrls)
              .then((List<dynamic> responses) {
            for(driveapi.File file in responses){
              imageUrls.add(file.webContentLink);
            }
          }
          );

          for(int i = 0; i < imageUrls.length; i++){
            imageUrlsDesc += "\n![hazizz_image_$i](${imageUrls[i]})";
          }
       */

          print("counter0: ${event.imageDatas.length}");
          int i = 0;

          List<Future> futures = [];
          for(HazizzImageData d in event.imageDatas){
            futures.add(d.futureUploadedToDrive);
          }
          await Future.wait(futures);

          for(HazizzImageData d in event.imageDatas){
            i++;
            print("counter1: ${d.url}");

            imageUrlsDesc += "\n![img_$i](${d.url.split("&")[0]})";
          }
        }

        HazizzResponse hazizzResponse;

        HazizzLogger.printLog("BEFORE POIOP: ${groupId}, ${subjectId},");

        if(event.imageDatas != null && event.imageDatas.isNotEmpty){
          print("majas1: ${event?.imageDatas[0]}");

          print("majas2: ${event?.imageDatas[0]?.key}");

          print("majas3: ${imageUrls}");
          print("majas4: ${description}");

          print("majas5: ${imageUrlsDesc}");

          print("leírás hosz: ${(description + imageUrlsDesc).length}");
        }

        hazizzResponse = await getResponse(new CreateTask(
            groupId: groupId,
            subjectId: subjectId,
            b_tags: tags,
            b_description: event.imageDatas.isEmpty ? description : description + imageUrlsDesc,
            b_deadline: deadline,
            b_salt: event.imageDatas.isEmpty ? null : salt
        ));

        print("majas3: broo");
        if(hazizzResponse.isSuccessful){
          if(event.imageDatas != null && event.imageDatas.isNotEmpty){
            int taskId = (hazizzResponse.convertedData as PojoTask).id;
            event.imageDatas.forEach((HazizzImageData hazizzImageData){
              hazizzImageData.renameFile(taskId);
            });
          }
          HazizzLogger.printLog("log: task making was succcessful");
          yield TaskMakerSuccessfulState(hazizzResponse.convertedData);
          MainTabBlocs().tasksBloc.dispatch(TasksFetchEvent());
        }else{
          yield TaskMakerFailedState();
        }

        //endregion

      } on Exception catch(e){
        HazizzLogger.printLog("log: Exception: ${e.toString()}");
      }
    }
  }

  @override
  TaskCreateState get initialState => InitializedTaskCreateState(group: group);

}
//endregion
//endregion












