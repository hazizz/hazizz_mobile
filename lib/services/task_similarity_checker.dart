import 'package:edit_distance/edit_distance.dart';
import 'package:mobile/communication/pojos/task/PojoTask.dart';
import 'package:mobile/custom/hazizz_logger.dart';
import 'package:mobile/custom/markdown_image_remover.dart';

class TaskSimilarity {
  final double percent;
  final PojoTask task;
  const TaskSimilarity(this.percent, this.task);
}

List<TaskSimilarity> checkTaskSimilarity(String description, int subjectId, DateTime dueDate, List<PojoTask> otherTasks){
//  List<PojoTask> filteredTasks = [];
 // DateTime now = DateTime.now();

  /*
  for(PojoTaskDetailed t in otherTasks){
    if(t.creationDate.isAfter(now - 1.days)
    && t.creationDate.isBefore(now + 1.days)
    && t.subject.id == subjectId
    && t.dueDate.isAfter(dueDate - 7.days)
    && t.dueDate.isBefore(dueDate + 7.days)
    ){
      filteredTasks.add(t);
    }
  }
  */

  JaroWinkler similarityChecker = JaroWinkler();

  List<TaskSimilarity> similarTasks = [];

  for(PojoTask t in otherTasks){
    String newDescription = description.toLowerCase();
    String otherDescription = t.description.toLowerCase();

    HazizzLogger.printLog("log: lull2265: .${t.description}.");

    final intRegex = RegExp(r'\s+(\d+)\s+', multiLine: true);
    List<RegExpMatch> matches = intRegex.allMatches(newDescription).toList();

    matches[0].toString();

    List<String> charsToReplace = ["#", "*", "_", "!", "\n", ];

    charsToReplace.forEach((char) => newDescription.replaceAll(char, ""));
    otherDescription = markdownImageRemover(otherDescription);
    charsToReplace.forEach((char) => otherDescription.replaceAll(char, ""));

    double similarity = similarityChecker.normalizedDistance(newDescription, otherDescription);
    HazizzLogger.printLog("log: lull22: $similarity");

    double similarityPercent = (1 - similarity) *100;

    if(similarityPercent >= 75){
      similarTasks.add(TaskSimilarity(similarityPercent, t));
    }
  }
  return similarTasks;
}