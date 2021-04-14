import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'NotesDBWorker.dart';
import 'NotesModel.dart' show NotesModel, notesModel;

class NotesEntry extends StatelessWidget {

  final TextEditingController _titleEditingController = TextEditingController();
  final TextEditingController _contentEditingController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  NotesEntry(){
    _titleEditingController.addListener(() {
      notesModel.entityBeingEdited.title = _titleEditingController.text;
    },);
    _contentEditingController.addListener(() {
      notesModel.entityBeingEdited.content = _contentEditingController.text;
    });
  }

  @override
  Widget build(BuildContext inContext) {
    
if (notesModel.entityBeingEdited != null) {
      _titleEditingController.text = notesModel.entityBeingEdited.title;
      _contentEditingController.text = notesModel.entityBeingEdited.content;
    }

    return ScopedModel(
      model: notesModel,
      child: ScopedModelDescendant<NotesModel>(
        builder: (BuildContext inContext, Widget inChild, NotesModel inModel){
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
                  TextButton(onPressed: (){ _save(inContext, notesModel);}, child: Text("Сохранить"))
                ],
              ),
            ),
            body: Form(
              key: _formKey,
              child: ListView(
                children: [
                  ListTile(
                    leading: Icon(Icons.title),
                    title: TextFormField(
                      decoration: InputDecoration(
                      
                        hintText: "Название"),
                      controller: _titleEditingController,
                      validator: (String inValue){
                        if (inValue.length == 0){
                          return "Пожалуйста введите название";
                        }
                        return null;
                      },
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.content_paste),
                    title: TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: 8,
                      decoration: InputDecoration(hintText: "Содержимое"),
                      controller: _contentEditingController,
                      validator: (String inValue){
                        if (inValue.length == 0){
                          return "Пожалуйста напишите содержимое";
                        }
                        return null;
                      },
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.color_lens),
                    title: Row(children: [
                      GestureDetector(
                        child: Container(
                          decoration: ShapeDecoration(
                            shape: Border.all(width: 18, color: Colors.red) + Border.all(
                              width: 6, 
                              color: notesModel.color == "red" ?
                              Colors.red : Theme.of(inContext).canvasColor
                            )
                          ),
                        ),
                        onTap: (){
                          notesModel.entityBeingEdited. color = "red";
                          notesModel.setColor("red");
                        },
                      ),
                      Spacer()
                    ],),
                  ),

                  ListTile(
                    leading: Icon(Icons.color_lens),
                    title: Row(children: [
                      GestureDetector(
                        child: Container(
                          decoration: ShapeDecoration(
                            shape: Border.all(width: 18, color: Colors.green) + Border.all(
                              width: 6, 
                              color: notesModel.color == "green" ?
                              Colors.green : Theme.of(inContext).canvasColor
                            )
                          ),
                        ),
                        onTap: (){
                          notesModel.entityBeingEdited. color = "green";
                          notesModel.setColor("green");
                        },
                      ),
                      Spacer()
                    ],),
                  ),
                  
                  ListTile(
                    leading: Icon(Icons.color_lens),
                    title: Row(children: [
                      GestureDetector(
                        child: Container(
                          decoration: ShapeDecoration(
                            shape: Border.all(width: 18, color: Colors.blue) + Border.all(
                              width: 6, 
                              color: notesModel.color == "blue" ?
                              Colors.blue : Theme.of(inContext).canvasColor
                            )
                          ),
                        ),
                        onTap: (){
                          notesModel.entityBeingEdited. color = "blue";
                          notesModel.setColor("blue");
                        },
                      ),
                      Spacer()
                    ],),
                  ),
                
                  ListTile(
                    leading: Icon(Icons.color_lens),
                    title: Row(children: [
                      GestureDetector(
                        child: Container(
                          decoration: ShapeDecoration(
                            shape: Border.all(width: 18, color: Colors.yellow) + Border.all(
                              width: 6, 
                              color: notesModel.color == "yellow" ?
                              Colors.yellow : Theme.of(inContext).canvasColor
                            )
                          ),
                        ),
                        onTap: (){
                          notesModel.entityBeingEdited. color = "yellow";
                          notesModel.setColor("yellow");
                        },
                      ),
                      Spacer()
                    ],),
                  ),

                  ListTile(
                    leading: Icon(Icons.color_lens),
                    title: Row(children: [
                      GestureDetector(
                        child: Container(
                          decoration: ShapeDecoration(
                            shape: Border.all(width: 18, color: Colors.grey) + Border.all(
                              width: 6, 
                              color: notesModel.color == "grey" ?
                              Colors.grey : Theme.of(inContext).canvasColor
                            )
                          ),
                        ),
                        onTap: (){
                          notesModel.entityBeingEdited. color = "grey";
                          notesModel.setColor("grey");
                        },
                      ),
                      Spacer()
                    ],),
                  ),

                  ListTile(
                    leading: Icon(Icons.color_lens),
                    title: Row(children: [
                      GestureDetector(
                        child: Container(
                          decoration: ShapeDecoration(
                            shape: Border.all(width: 18, color: Colors.purple) + Border.all(
                              width: 6, 
                              color: notesModel.color == "purple" ?
                              Colors.purple : Theme.of(inContext).canvasColor
                            )
                          ),
                        ),
                        onTap: (){
                          notesModel.entityBeingEdited. color = "purple";
                          notesModel.setColor("purple");
                        },
                      ),
                      Spacer()

                    ],),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      
    );
  }
  void _save(BuildContext inContext, NotesModel inModel) async {
  if (! _formKey.currentState.validate()){return; }
  if (inModel.entityBeingEdited.id == null){
    await NotesDBWorker.db.create(notesModel.entityBeingEdited);
  } else { 
    await NotesDBWorker.db.update(
      notesModel.entityBeingEdited
    );
  }
  notesModel.loadData("notes", NotesDBWorker.db);
  inModel.setStackIndex(0);
  ScaffoldMessenger.of(inContext).showSnackBar(
    SnackBar(
      backgroundColor: Colors.green,
      duration: Duration(seconds: 2),
      content: Text("Запсиь сохранена")
    )
  );
}
  
}

