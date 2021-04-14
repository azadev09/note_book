import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:note_book/utils.dart' as utils;
import 'TasksDBWorker.dart';
import 'TasksModel.dart' show TaskModel, tasksModel;

class TasksEntry extends StatelessWidget {

  final TextEditingController _descriptionEditingController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TasksEntry(){
    _descriptionEditingController.addListener(() {
      tasksModel.entityBeingEdited.description = _descriptionEditingController.text;
    });

  }


  @override
  Widget build(BuildContext inContext) {

   if (tasksModel.entityBeingEdited != null) {
      _descriptionEditingController.text = tasksModel.entityBeingEdited.description;
    }

    return ScopedModel(
      model: tasksModel,
      child: ScopedModelDescendant<TaskModel>(
        builder: (BuildContext inContext, Widget inChild, TaskModel inModel){
          return Scaffold(
            bottomNavigationBar: Padding(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              child: Row(
                children: [
                  TextButton(onPressed: (){
                    FocusScope.of(inContext).requestFocus(FocusNode());
                    inModel.setStackIndex(0);
                  }, child: Text("Отмена")),
                  Spacer(),
                  TextButton(onPressed: () { _save(inContext, tasksModel);}, child: Text("Сохранить"))
                ],
              ),
            ),
            body: Form(
              key: _formKey,
              child: ListView(
                children: [
                  ListTile(
                    leading: Icon(Icons.description),
                    title: TextFormField(
                      maxLines: 4,
                      decoration: InputDecoration(hintText: "Описание"),
                      controller: _descriptionEditingController,
                      validator: (String inValue){
                        if (inValue.length == 0){
                          return "Пожалуйста напишите описание";
                        }
                        return null;
                      },
                    ),
                  ),
                  // ListTile(
                  //   leading: Icon(Icons.today),
                  //   title: Text("Due Date"),
                  //   subtitle: Text(
                  //     tasksModel.chosenDate == null ? " " : tasksModel.chosenDate),
                  //   trailing: IconButton(
                  //     icon: Icon(Icons.edit), color: Colors.blue,
                  //   onPressed: () async { 
                  //     String chosenDate = await utils.selectDate(
                  //       inContext, tasksModel, 
                  //       tasksModel.entityBeingEdited.dueDate);
                  //     if (chosenDate != null){
                  //       tasksModel.entityBeingEdited.dueDate = chosenDate;
                  //     }
                  //   }),
                  // )
                  ]
              )),
          );
        },
      )
    );
  }
  void _save(BuildContext inContext, TaskModel inModel) async {
  if (! _formKey.currentState.validate()){return; }
  if (inModel.entityBeingEdited.id == null){
    await TasksDBWorker.db.create(tasksModel.entityBeingEdited);
  } else { 
    await TasksDBWorker.db.update(
      tasksModel.entityBeingEdited
    );
  }
  tasksModel.loadData("tasks", TasksDBWorker.db);
  inModel.setStackIndex(0);
  ScaffoldMessenger.of(inContext).showSnackBar(
    SnackBar(
      backgroundColor: Colors.green,
      duration: Duration(seconds: 2),
      content: Text("Задача сохранена")
    )
  );
}
}