// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:flutter_notes/config.dart';

class UpdatePage extends StatefulWidget {
  final Map<String, dynamic> note;

  const UpdatePage({
    super.key,
    required this.note,
  });

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.note['body']);
  }

  Future<void> updateNote() async {
    var url = Uri.parse('${Config.API_URL}/notes/${widget.note['id']}/update/');
    var response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: convert.jsonEncode({"body": _controller.text}),
    );

    if (response.statusCode == 200) {
      Navigator.pop(context, true); //? returns TRUE if updated is successfully
    } else {
      print('Failed to update note. Status: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Edit Note'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: _controller,
                maxLines: null,
                keyboardType: TextInputType.multiline,
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            updateNote();
          },
          tooltip: 'Save changes',
          child: const Icon(Icons.save),
        ));
  }
}
