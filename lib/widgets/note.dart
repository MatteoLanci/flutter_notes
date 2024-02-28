import 'package:flutter/material.dart';
import 'package:flutter_notes/update_page.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class NoteWidget extends StatelessWidget {
  final Map<String, dynamic> note;
  final VoidCallback onDelete;
  final VoidCallback getNotes;

  const NoteWidget({
    required this.note,
    required this.onDelete,
    required this.getNotes,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    DateTime parsedDate = DateTime.parse(
        note['updated']); //? Converte la stringa ISO8601 in un oggetto DateTime

    String formattedDate = DateFormat('dd/MM/yyyy HH:mm', 'it_IT').format(
        parsedDate); //? Formatta la data in un formato più leggibile, ad esempio "26/02/2024 18:25"

    return Slidable(
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              onDelete();
            },
            icon: Icons.delete,
            backgroundColor: Colors.red,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 50, top: 0, right: 0, bottom: 0),
        child: ListTile(
          title: Text(note['body']),
          subtitle: Text('Updated: $formattedDate'),
          // trailing: IconButton(
          //   onPressed: onDelete,
          //   icon: const Icon(Icons.delete),
          // ),
          onTap: () async {
            final result = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => UpdatePage(note: note),
              ),
            );

            if (result == true) {
              getNotes();
            }
          },
        ),
      ),
    );
  }
}
