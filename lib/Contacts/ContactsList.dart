import 'dart:io';
import 'package:flutter/material.dart';
import 'package:note_book/utils.dart' as utils;
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:path/path.dart';
import 'ContactsDBWorker.dart';
import 'package:note_book/Contacts/ContactsModel.dart' show Contact, ContactsModel, contactsModel;



class ContactsList extends StatelessWidget {
  @override
  Widget build(BuildContext inContext) {
    return ScopedModel<ContactsModel>(
      model: contactsModel,
      child: ScopedModelDescendant<ContactsModel>(
        builder: (BuildContext inContext, Widget inChild, ContactsModel inModel){
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add, color: Colors.white,),
              onPressed: () async {
                File avatarFile = File(join(utils.docsDir.path, "avatar"));
                if (avatarFile.existsSync()){
                  avatarFile.deleteSync();
                } 
                contactsModel.entityBeingEdited = Contact();
                contactsModel.setStackIndex(1);
              },
            ),
            body: ListView.builder(
              itemCount: contactsModel.entityList.length,
              itemBuilder: (BuildContext inBuildContext, int inIndex){
                Contact contact = contactsModel.entityList[inIndex];
                File avatarFile = File(join(utils.docsDir.path, contact.id.toString()));
                bool avatarFileExists = avatarFile.existsSync();
                return Column(
                  children: [
                    Slidable(
                      actionPane: SlidableDrawerActionPane(),
                      actionExtentRatio: .25,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.indigoAccent,
                          foregroundColor: Colors.white,
                          backgroundImage: avatarFileExists ? FileImage(avatarFile) : null,
                          child: avatarFileExists ? null : Text(contact.name.substring(0, 1).toUpperCase())
                        ),
                        title: Text("${contact.name}"),
                        subtitle: contact.phone == null ?
                        null : Text("${contact.phone}"),
                      ),
                      secondaryActions: [
                        IconSlideAction(caption: "Удалить", color: Colors.red, icon: Icons.delete,
                        onTap: () => _deleteContact(inContext, contact),)
                      ],
                      ),
                      Divider(),
                  ],
                );
              },),
          );
        },
      ),
    );
  }

  Future _deleteContact(BuildContext inContext, Contact inContact) async {
    return showDialog(
      context: inContext, 
      builder: (BuildContext inAlertContext){
        return AlertDialog(
          title: Text("Удалить контакт"),
          content: Text("Вы хотите удалить контакт ${inContact.name}?"),
          actions: [
            ElevatedButton(onPressed: (){
              Navigator.of(inAlertContext).pop();
            }, child: Text("Отмена")),
          TextButton(
            child: Text("Удалить"),
            onPressed: () async {
            File avatarFile = File(join(utils.docsDir.path, inContact.id.toString()));
            if (avatarFile.existsSync()){
              avatarFile.deleteSync();
            }
            await ContactsDBWorker.db.delete(inContact.id);
            Navigator.of(inAlertContext).pop();
            ScaffoldMessenger.of(inContext).showSnackBar(
              SnackBar(
                backgroundColor: Colors.red,
                duration: Duration(seconds: 2),
                content: Text("Контакт удален"))
            );
            contactsModel.loadData("contacts", ContactsDBWorker.db);
          }, ),
          
          ],
        );
      });
  }

}