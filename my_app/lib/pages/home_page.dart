import 'package:flutter/material.dart';
import '../utils/note_storage.dart';
import 'add_note_page.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  List<String> notes = [];

  @override
  void initState() {
    super.initState();
    loadNotes();
  }

  void loadNotes() async {
    List<String> savedNotes = await NoteStorage.loadNotes();
    setState(() {
      notes = savedNotes;
    });
  }

  void addNote(String note) {
    setState(() {
      notes.add(note);
    });
    NoteStorage.saveNotes(notes);
  }

  void editNote(int index, String newNote) {
    setState(() {
      notes[index] = newNote;
    });
    NoteStorage.saveNotes(notes);
  }

  Future<void> deleteNote(int index) async {
    bool? confirmDelete = await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Delete Note"),
            content: Text("Are you sure you want to delete this note?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false), // Do not delete
                child: Text("Cancel"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true), // Confirm delete
                child: Text("Delete", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );

    if (confirmDelete == true) {
      setState(() {
        notes.removeAt(index);
      });
      NoteStorage.saveNotes(notes);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3F3F3),
      appBar: AppBar(
        title: Text(
          'Simple Notes',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 5,
        backgroundColor: Colors.deepPurple,
      ),
      body:
          notes.isEmpty
              ? Center(
                child: Text(
                  'No notes added yet!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
              )
              : Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: ListView.builder(
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    return Dismissible(
                      key: Key(notes[index]),
                      direction: DismissDirection.endToStart,
                      confirmDismiss: (direction) async {
                        return await showDialog(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                title: Text("Delete Note"),
                                content: Text(
                                  "Are you sure you want to delete this note?",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed:
                                        () => Navigator.pop(context, false),
                                    child: Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed:
                                        () => Navigator.pop(context, true),
                                    child: Text(
                                      "Delete",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                        );
                      },
                      onDismissed: (direction) {
                        deleteNote(index);
                      },
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: 20),
                        child: Icon(Icons.delete, color: Colors.white),
                      ),
                      child: Container(
                        margin: EdgeInsets.only(bottom: 12),
                        padding: EdgeInsets.all(15),
                        width: MediaQuery.of(context).size.width * 0.75,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 6,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  String? updatedNote = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) =>
                                              AddNotePage(note: notes[index]),
                                    ),
                                  );
                                  if (updatedNote != null) {
                                    editNote(index, updatedNote);
                                  }
                                },
                                child: Text(
                                  notes[index],
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => deleteNote(index),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.deepPurple,
        icon: Icon(Icons.add, color: Colors.white, size: 28),
        label: Text(
          'Add Note',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        onPressed: () async {
          String? newNote = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddNotePage()),
          );
          if (newNote != null) {
            addNote(newNote);
          }
        },
      ),
    );
  }
}
