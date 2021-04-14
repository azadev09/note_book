
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:note_book/utils.dart' as utils;
import 'ContactsDBWorker.dart';
import 'package:path/path.dart';

import 'package:note_book/Contacts/ContactsModel.dart' show ContactsModel, contactsModel;

class ContactsEntry extends StatelessWidget {

  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _phoneEditingController = TextEditingController();
  final TextEditingController _emailEditingController = TextEditingController();


  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  ContactsEntry(){
    _nameEditingController.addListener(() {
      contactsModel.entityBeingEdited.name = _nameEditingController.text;
    });
    _phoneEditingController.addListener(() {
      contactsModel.entityBeingEdited.phone = _phoneEditingController.text;
    });
    _emailEditingController.addListener(() {
      contactsModel.entityBeingEdited.email = _emailEditingController.text;
    });

  }


  @override
  Widget build(BuildContext inContext) {

    if (contactsModel.entityBeingEdited != null) {
      _nameEditingController.text = contactsModel.entityBeingEdited.name;
      _emailEditingController.text = contactsModel.entityBeingEdited.email;
      _phoneEditingController.text = contactsModel.entityBeingEdited.phone;

    }

    return ScopedModel(
      model: contactsModel,
      child: ScopedModelDescendant<ContactsModel>(
        builder: (BuildContext inContext, Widget inChild, ContactsModel inModel){
          File avatarFile = File(join(utils.docsDir.path, "avatar"));
          if (avatarFile.existsSync() == false){
            if (inModel.entityBeingEdited != null && inModel.entityBeingEdited.id != null) {
              avatarFile = File(join(utils.docsDir.path, inModel.entityBeingEdited.id.toString()));
            }
          }
          return Scaffold(
            bottomNavigationBar: 
            Padding(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              child: Row(children: [
                TextButton(
                  child: Text("Отмена"),
                  onPressed: (){
                    File avatarFile = File(join(utils.docsDir.path, "avatar"));
                    if (avatarFile.existsSync()){
                      avatarFile.deleteSync();
                    }
                    FocusScope.of(inContext).requestFocus(FocusScopeNode());
                    inModel.setStackIndex(0);
                  },
                ),
                Spacer(),
                TextButton(child: Text("Сохранить"),
                onPressed: () {_save(inContext, inModel);},)
              ],),
            ),
            body: Form(key: _formKey,
            child: ListView(
              children: [ListTile(
                title : avatarFile.existsSync() ? Image.file(avatarFile) : Text("Вырать фото для этого контакта"),
                trailing: IconButton(icon: Icon(Icons.edit), color: Colors.blue,
                onPressed: () => _selectAvatar(inContext),),
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Имя"
                  ),
                  controller: _nameEditingController,
                  validator: (String inValue){
                    if (inValue.length == 0){
                      return "Пожалуйста введите имя";
                    }
                    return null;
                  },
                )
              ),
              ListTile(
                leading: Icon(Icons.phone),
                title: TextFormField(
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(hintText: "Tелефон"),
                  controller: _phoneEditingController,
                ),
              ),
               ListTile(
                leading: Icon(Icons.email),
                title: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(hintText: "Email"),
                  controller: _emailEditingController,
                ),
              ),
              // ListTile(
              //   leading: Icon(Icons.today),
              //   title: Text("Birthday"),
              //   subtitle: Text(contactsModel.chosenDate == null ? "" : contactsModel.chosenDate),
              //   trailing: IconButton(icon: Icon(Icons.edit),
              //   color: Colors.blue,
              //   onPressed: () async{
              //     String chosenDate = await utils.selectDate(inContext, inModel, contactsModel.entityBeingEdited.birthday);
              //     if (chosenDate != null){
              //       contactsModel.entityBeingEdited.birthday = chosenDate;
              //     }
              //   },),
              // )
              ],
            ),),
          );
        },
      ));
  }

  Future _selectAvatar(BuildContext inContext){
    return showDialog(
      context: inContext, 
      builder: (BuildContext inDialogContext){
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                GestureDetector(
                  child: Text("Выбрать фото"),
                  onTap: () async {
                    var cameraImage = await ImagePicker.pickImage(source: ImageSource.camera);
                    if (cameraImage != null) {
                      cameraImage.copySync(join(utils.docsDir.path, "avatar"));
                      contactsModel.triggerRebuild();
                    }
                    Navigator.of(inDialogContext).pop();
                  },
                ),
                Padding(padding: EdgeInsets.all(10),),
                GestureDetector(child: Text("Выбрать из галереи"),
                onTap: () async {
                  var galleryImage = await ImagePicker.pickImage(source: ImageSource.gallery);
                  if (galleryImage != null){
                    galleryImage.copySync(join(utils.docsDir.path, "avatar"));
                    contactsModel.triggerRebuild();
                  }
                  Navigator.of(inDialogContext).pop();
                },)
              ],
            ),
          ),
        );
      });
  }


    void _save(BuildContext inContext, ContactsModel inModel) async {

    if (!_formKey.currentState.validate()) { return; }
    var id;
    if (inModel.entityBeingEdited.id == null) {
      id = await ContactsDBWorker.db.create(contactsModel.entityBeingEdited);
    } else {
      id = contactsModel.entityBeingEdited.id;
      await ContactsDBWorker.db.update(contactsModel.entityBeingEdited);

    }
    File avatarFile = File(join(utils.docsDir.path, "avatar"));
    if (avatarFile.existsSync()) {
      avatarFile.renameSync(join(utils.docsDir.path, id.toString()));
    }

    contactsModel.loadData("contacts", ContactsDBWorker.db);
    inModel.setStackIndex(0);

    ScaffoldMessenger.of(inContext).showSnackBar(
      SnackBar(
        backgroundColor : Colors.green,
        duration : Duration(seconds : 2),
        content : Text("Контакт сохранен")
      )
    );

  } 
}