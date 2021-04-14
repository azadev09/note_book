import 'dart:io';
import 'package:flutter/material.dart';
import 'package:note_book/Contacts/Contacts.dart';
import 'package:note_book/Notes.dart';
import 'package:note_book/tasks/Tasks.dart';
import 'package:path_provider/path_provider.dart';
import 'utils.dart' as utils;


void main() {

  WidgetsFlutterBinding.ensureInitialized();


  startMeUp() async {
    Directory docsDir = await getApplicationDocumentsDirectory();
    utils.docsDir = docsDir;
    runApp(NoteBook());
  }

  startMeUp();

} 



class NoteBook extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text("NoteBook"),
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.note), text: "Заметки",),
                Tab(icon: Icon(Icons.grade), text: "Задачи",),
                Tab(icon: Icon(Icons.contact_page), text: "Контакты",),
                //Tab(icon: Icon(Icons.assignment_turned_in), text: "Tasks",)
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Notes(),
              Tasks(),
              Contacts(),
            ]
        ),),
      
    ));
  }
}
