// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_notes/widgets/note.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:flutter_notes/config.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> notes = [];
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    getNotes();
  }

  void getNotes() async {
    var url = Uri.parse('${Config.API_URL}/notes/');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body) as List<dynamic>;
      setState(() {
        notes = jsonResponse;
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  Future<void> createNote(String body) async {
    var url = Uri.parse('${Config.API_URL}/notes/create/');
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: convert.jsonEncode({
        "body": controller.text,
      }),
    );

    if (response.statusCode == 200) {
      print('Note created successfully');
      controller.clear();
      getNotes();
    } else {
      print('Failed to create note. Status: ${response.statusCode}');
    }
  }

  Future<void> deleteNote(int id) async {
    var url = Uri.parse('${Config.API_URL}/notes/$id/delete/');
    var response = await http.delete(url);

    if (response.statusCode == 200) {
      print('Note deleted successfully');
      getNotes();
    } else {
      print('Failed to delete note. Status: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          getNotes();
        },
        child: notes.isEmpty
            ? const Center(
                child: Text(
                  'No notes available. Try adding a new note!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(255, 50, 110, 156),
                  ),
                ),
              )
            : ListView.builder(
                itemCount: notes.length,
                itemBuilder: (ctx, index) => NoteWidget(
                  note: notes[index],
                  onDelete: () {
                    deleteNote(notes[index]['id']);
                  },
                  getNotes: () {
                    getNotes();
                  },
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('New Note'),
                content: TextField(
                  controller: controller,
                  decoration: const InputDecoration(hintText: "Note text"),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      controller.clear();
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      if (controller.text.isNotEmpty) {
                        createNote(controller.text);
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text('Save'),
                  ),
                ],
              );
            },
          );
        },
        tooltip: 'Add Note',
        child: const Icon(Icons.add),
      ),
    );
  }
}
