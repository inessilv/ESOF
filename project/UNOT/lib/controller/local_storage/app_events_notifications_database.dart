import 'dart:async';
import 'package:uni/controller/local_storage/app_database.dart';
import 'package:sqflite/sqflite.dart';

import '../../model/entities/event.dart';

/// Manages the app's Exams database.
/// 
/// This database stores information about the user's exams.
/// See the [Exam] class to see what data is stored in this database.
class EventsDatabase extends AppDatabase {
  EventsDatabase()
      : super('events.db', [
          '''CREATE TABLE events(eventId INTEGER PRIMARY KEY, startDate TEXT, endDate TEXT, title TEXT)
          '''
        ]);


  /// Replaces all of the data in this database with [exams].
  saveNewEvents(List<Event> events) async {
    await deleteEvents();
    await _insertEvents(events);
  }


  /// Adds all items from [exams] to this database.
  /// 
  /// If a row with the same data is present, it will be replaced.
  Future<void> _insertEvents(List<Event> events) async {
    for (Event event in events) {
      await insertInDatabase(
        'events',
        event.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }



  Future <List<Map<String, dynamic>>> getAllEvents() async {
    // Get a reference to the database
    final Database db = await this.getDatabase();

    // Query the table for All The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('events');

    await db.close();

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return maps;
  }





  /// Deletes all of the data stored in this database.
  Future<void> deleteEvents() async {
    // Get a reference to the database
    final Database db = await this.getDatabase();

    await db.delete('events');
  }
}
