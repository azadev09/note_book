import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:scoped_model/scoped_model.dart';
import 'TasksDBWorker.dart';
import 'TasksModel.dart' show Task, TaskModel, tasksModel;

class TasksList extends StatelessWidget {

  
  @override
  Widget build(BuildContext context) {
    return ScopedModel<TaskModel>(
      model: tasksModel,
      child: ScopedModelDescendant<TaskModel>(
        builder: (BuildContext inContext, Widget inChild, TaskModel inModel){
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add, color: Colors.white),
              onPressed: (){
                tasksModel.entityBeingEdited = Task();
                tasksModel.setStackIndex(1);
              },
            ),
            body: ListView.builder(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
              itemCount: tasksModel.entityList.length,
              itemBuilder: (BuildContext inBuildContext, int inIndex){
                Task task = tasksModel.entityList[inIndex];
                // String sDueDate;
                // if (task.dueDate != null){
                //   List dateParts = task.dueDate.split(",");
                //   DateTime dueDate = DateTime(
                //   int.parse(dateParts[0]), 
                //   int.parse(dateParts[1]),
                //   int.parse(dateParts[2])
                //   );
                //   sDueDate = DateFormat.yMMMEd("ru_RU").format(dueDate.toLocal());
                // }  
                return Container(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Slidable(
                    actionPane: SlidableBehindActionPane(),
                    actionExtentRatio: .25, 
                    child: ListTile(
                      leading: Checkbox(
                        value: task.completed == "true" ? true : false,
                        onChanged: (inValue) async{
                          task.completed = inValue.toString();
                          await TasksDBWorker.db.update(task);
                          tasksModel.loadData("tasks", TasksDBWorker.db);
                        },
                      ),
                      title: Text("${task.description}",
                      style: task.completed == "true" ?
                      TextStyle(
                        color: Theme.of(inContext).disabledColor,
                        decoration: TextDecoration.lineThrough
                      ) :
                      TextStyle(
                        color: Theme.of(inContext).textTheme.headline6.color
                      )
                      ),
                        ),
                        secondaryActions: [
                          IconSlideAction(
                            caption: "Удалить",
                            color: Colors.red,
                            icon: Icons.delete,
                            onTap: () => _deleteTask(inContext, task)
                          )
                        ],
                    ),
                );            
              }),
          );
        },
      ),
      
    );
  }



  Future _deleteTask(BuildContext inContext, Task inTask){
                      return showDialog(
                        context: inContext,
                        barrierDismissible: false,
                         builder: (BuildContext inAlertContext){
                           return AlertDialog(
                             title: Text("Delete Task"),
                             content: Text("Are you sure you want to delete ${inTask.description}?"
                             ),
                             actions: [
                               TextButton(
                                 onPressed: (){
                                   Navigator.of(inAlertContext).pop();
                                 }, child: Text("Cancel")),
                                 TextButton(
                                   child: Text("Delete"),
                                   onPressed: () async{
                                     await TasksDBWorker.db.delete(inTask.id);
                                     Navigator.of(inAlertContext).pop();
                                     ScaffoldMessenger.of(inContext).showSnackBar(
                                       SnackBar(
                                         backgroundColor: Colors.red,
                                         duration: Duration(seconds: 2),
                                         content: Text("Task Deleted"))
                                     );
                                     tasksModel.loadData("tasks", TasksDBWorker.db);
                                   }, ),
                             ],
                           );
                         });
                    }
}