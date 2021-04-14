import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'TasksDBWorker.dart';
import 'TasksList.dart';
import 'TasksEntry.dart';
import 'TasksModel.dart' show TaskModel, tasksModel;

class Tasks extends StatelessWidget {

  Tasks(){
    tasksModel.loadData("tasks", TasksDBWorker.db);
  }

  @override
  Widget build(BuildContext inContext) {
    return ScopedModel<TaskModel>(
      model: tasksModel,
      child: ScopedModelDescendant<TaskModel>(
        builder: (BuildContext inContext, Widget inChild, TaskModel inModel){
          return IndexedStack(
            index: inModel.stackIndex,
            children: [TasksList(), TasksEntry()],
          );
        },
      )
      
    );
  }
}