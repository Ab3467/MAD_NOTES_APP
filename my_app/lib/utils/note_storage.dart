import 'package:shared_preferences/shared_preferences.dart';

class NoteStorage {
  static Future<List<String>> loadNotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('notes') ?? [];
  }

  static Future<void> saveNotes(List<String> notes) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('notes', notes);
  }
}
