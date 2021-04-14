import 'package:note_book/basemodel.dart';

class Task{

  int id;
  String description;
  String dueDate;
  String completed = "false";

  String toString(){
    return "{id = $id, description = $description, dueDate = $dueDate, completed = $completed}";
  }
}

class TaskModel extends BaseModel {

}

TaskModel tasksModel = TaskModel();