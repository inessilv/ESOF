import 'dart:async';
import 'dart:core';
import 'dart:core';
import 'package:logger/logger.dart';
import 'package:uni/controller/local_storage/app_database.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:sqflite/sqflite.dart';

import '../../model/entities/lectureNotification.dart';
import '../../model/entities/eventNotification.dart';
import '../../model/entities/examNotification.dart';
import '../../model/entities/lectureForNotification.dart';
import 'app_events_notifications_database.dart';
import 'app_exams_notifications_database.dart';
import 'app_lectures_for_notifications_database.dart';

/// Manages the app's Lectures database.
/// 
/// This database stores information about the user's lectures.
/// See the [Lecture] class to see what data is stored in this database.
class NotificationsDatabase extends AppDatabase {

  static final createScript =
      '''CREATE TABLE notifications(
          notificationId INTEGER PRIMARY KEY,
          mainId INTEGER,
          typeOfNotification TEXT,
          minutesBefore INTEGER,
          isActive BOOLEAN,
          dateOfNotification TEXT,
          hourOfNotification TEXT,
          minuteOfNotification TEXT,
          title TEXT,
          description TEXT)''';


  NotificationsDatabase()
      : super(
            'notifications.db',
            [
              createScript,
            ],
            onUpgrade: migrate,
            version: 3);


  /// Replaces all of the data in this database with [lecs].
  saveNewLecturesNotifications(List<LectureNotification> notifications) async {
    //await deleteLectures();
    await insertLectures(notifications);
  }



  saveNewExamsNotifications(List<ExamNotification> notifications) async {
    //await deleteExams();
    await insertExams(notifications);
  }



  saveNewEventsNotifications(List<EventNotification> notifications) async {
    //await deleteEvents();
    await insertEvents(notifications);
  }


  /// Returns a list containing all of the lectures stored in this database.
  Future<List<Lecture>> lectures() async {
    // Get a reference to the database
    final Database db = await this.getDatabase();

    // Query the table for All The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('notifications');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Lecture.fromHtml(
        maps[i]['subject'],
        maps[i]['typeClass'],
        maps[i]['day'],
        maps[i]['startTime'],
        maps[i]['blocks'],
        maps[i]['room'],
        maps[i]['teacher'],
        maps[i]['classNumber'],
      );
    });
  }

  /// Adds all items from [lecs] to this database.
  /// 
  /// If a row with the same data is present, it will be replaced.
  Future<void> insertLectures(List<LectureNotification> notifications) async {
    
    for (LectureNotification not in notifications) {
      await this.insertInDatabase(
        'notifications',
        not.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore,

      );
    }
  }


    Future<void> insertExams(List<ExamNotification> notifications) async {
    
    for (ExamNotification not in notifications) {
      await this.insertInDatabase(
        'notifications',
        not.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }
  }



      Future<void> insertEvents(List<EventNotification> notifications) async {
    
    for (EventNotification not in notifications) {
      await this.insertInDatabase(
        'notifications',
        not.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }
  }

  /// Deletes all of the data stored in this database.
  Future<void> deleteLectures() async {
    // Get a reference to the database
    final Database db = await this.getDatabase();
    //! MUST DELETE ONLT THE LECTURES NOTIFICATION
    await db.delete('notifications', where: 'typeOfNotification = ?', whereArgs: ['Lecture']);
  }


  Future<void> deleteExams() async {
    // Get a reference to the database
    final Database db = await this.getDatabase();
    //! MUST DELETE ONLT THE EXAMS NOTIFICATION
    await db.delete('notifications', where: 'typeOfNotification = ?', whereArgs: ['Exam']);
  }

  Future<void> deleteEvents() async {
    // Get a reference to the database
    final Database db = await this.getDatabase();
    //! MUST DELETE ONLT THE EXAMS NOTIFICATION
    await db.delete('notifications', where: 'typeOfNotification = ?', whereArgs: ['Event']);
  }

  Future<Map<String, dynamic>> getAllLectures() async{

     var dayName = [
      'Segunda-feira',
      'Terça-feira',
      'Quarta-feira',
      'Quinta-feira',
      'Sexta-feira',
      'Sábado',
      'Domingo'
    ];


    // Get a reference to the database
    final Database db = await this.getDatabase();

    List<Map<String, dynamic>> allNotifications = await db.rawQuery("SELECT mainId,minutesBefore, isActive, title  FROM notifications  WHERE typeOfNotification = 'Lecture'  GROUP BY mainId");

    await db.close();

    final AppLecturesForNotificationsDatabase db2_i = AppLecturesForNotificationsDatabase();
    final Database db2 = await db2_i.getDatabase();
    List<Map<String, dynamic>> allLectures = await db2.rawQuery("SELECT * FROM lecturesForNotifications");

    await db2.close();

    //Map allNotifications and allLectures when allLectures["lectureId"] == allNotifications["mainId"]
    Map<String, dynamic> allLecturesWithNotifications = Map();

    for (Map<String, dynamic> allLecture in allLectures) {
      for (Map<String, dynamic> allNotification in allNotifications) {

        int lecId =  allLecture["lectureId"];
        int notId = allNotification["mainId"];

        if (lecId == notId){
          allLecturesWithNotifications[lecId.toString()] = {
            "acr": allLecture["subject"],
            "type": allLecture["typeClass"],
            "title":allLecture["completeTitle"],
            "state": allNotification["isActive"],
            "minutesBefore": allNotification["minutesBefore"],
            "description": allNotification["title"],
            "weekday": dayName[allLecture["day"] - 1]
          };
        }
      }


    }




//Logger().e(allLectures);
//Logger().e(allNotifications);
//Logger().e(allLecturesWithNotifications);


    return allLecturesWithNotifications;


  }


  Future<Map<String, dynamic>> getAllExams() async{
    // Get a reference to the database
    final Database db = await this.getDatabase();

    List<Map<String, dynamic>> allNotifications = await db.rawQuery("SELECT mainId,minutesBefore, isActive, title  FROM notifications  WHERE typeOfNotification = 'Exam'  GROUP BY mainId");

    await db.close();

    final ExamsForNotificationsExtension db2_i = ExamsForNotificationsExtension();
    final Database db2 = await db2_i.getDatabase();
    List<Map<String, dynamic>> allLectures = await db2.rawQuery("SELECT * FROM examsForNotifications");

    await db2.close();

    Map<String, dynamic> allExamsNotifications = Map();

    for (Map<String, dynamic> allLecture in allLectures) {
      for (Map<String, dynamic> allNotification in allNotifications) {

        int lecId =  allLecture["examId"];
        int notId = allNotification["mainId"];

        if (lecId == notId){
          allExamsNotifications[lecId.toString()] = {
            "acr": allLecture["subject"],
            "state": allNotification["isActive"],
            "minutesBefore": allNotification["minutesBefore"],
            "description": allNotification["description"],
            "type": allLecture["examType"],
            "date": allLecture["day"]+"/"+allLecture["month"]+"/"+allLecture["year"],
          };
        }
      }
    }

    return allExamsNotifications;

  }



  Future<Map<String, dynamic>> getAllEvents() async{
    // Get a reference to the database
    final Database db = await this.getDatabase();

    List<Map<String, dynamic>> allNotifications = await db.rawQuery("SELECT mainId,minutesBefore, isActive, title  FROM notifications  WHERE typeOfNotification = 'Event'  GROUP BY mainId");

    await db.close();



    // Events database
    final EventsDatabase db2_i = EventsDatabase();
    final Database db2 = await db2_i.getDatabase();
    List<Map<String, dynamic>> allLectures = await db2.rawQuery("SELECT * FROM events");

    await db2.close();

    Map<String, dynamic> allEventNotification = Map();

    for (Map<String, dynamic> allLecture in allLectures) {
      for (Map<String, dynamic> allNotification in allNotifications) {
        
        int lecId =  allLecture["eventId"]; 
        int notId = allNotification["mainId"];

        if (lecId == notId){
          allEventNotification[lecId.toString()] = {
            "state": allNotification["isActive"],
            "minutesBefore": allNotification["minutesBefore"],
            "title": allLecture["title"],
            "description": allNotification["title"]
          };
          }
        }
        

      }

  Logger().e(allEventNotification);
    

   return allEventNotification;
    

  }








  Future<void> updateSpecificLectureNotification(int lectureId, bool isActive, int minutesBefore, String comment,String reminder) async {
    // Get a reference to the database
    final Database db = await this.getDatabase();

    await db.update('notifications', {
      'isActive': isActive,
      'minutesBefore': minutesBefore,
      'title': comment,
      'description' : reminder
    }, where: 'mainId = ?', whereArgs: [lectureId]);
  }


  Future<void> updateSpecificExamNotification(int examId, bool isActive, int minutesBefore, String comment) async {
    // Get a reference to the database
    final Database db = await this.getDatabase();

    await db.update('notifications', {
      'isActive': isActive,
      'minutesBefore': minutesBefore,
      'title': comment,
    }, where: 'mainId = ?', whereArgs: [examId]);
  }


  Future<void> updateSpecificEventNotification(int eventId, bool isActive, int minutesBefore, String comment, String reminder) async {
    // Get a reference to the database
    final Database db = await this.getDatabase();

    await db.update('notifications', {
      'isActive': isActive,
      'minutesBefore': minutesBefore,
      'title': comment,
      'description' : reminder
    }, where: 'mainId = ?', whereArgs: [eventId]);
  }

  Future<void> updateAllLectureNotifications(bool isActive, int minutesBefore, String comment) async {
    // Get a reference to the database
    final Database db = await this.getDatabase();

   await db.rawQuery("UPDATE notifications SET isActive = $isActive, minutesBefore = $minutesBefore, title = '$comment' WHERE typeOfNotification = 'Lecture'");

    await db.close();
  }

  Future<void> updateAllExamNotifications(bool isActive, int minutesBefore, String comment) async {
    // Get a reference to the database
    final Database db = await this.getDatabase();

   await db.rawQuery("UPDATE notifications SET isActive = $isActive, minutesBefore = $minutesBefore, title = '$comment' WHERE typeOfNotification = 'Exam'");

    await db.close();
  }

  Future<void> updateAllEventNotifications(bool isActive, int minutesBefore, String comment) async {
    // Get a reference to the database
    final Database db = await this.getDatabase();

   await db.rawQuery("UPDATE notifications SET isActive = $isActive, minutesBefore = $minutesBefore, title = '$comment' WHERE typeOfNotification = 'Event'");

    await db.close();
  }

  Future<List<Map<String, dynamic>>> getAllLecturesNotifications() async{
    // Get a reference to the database
    final Database db = await this.getDatabase();

    List<Map<String, dynamic>> allNotifications = await db.rawQuery("SELECT notificationId, minutesBefore, dateOfNotification, hourOfNotification, minuteOfNotification, title FROM notifications  WHERE typeOfNotification = 'Lecture'");

    await db.close();

    return allNotifications;
  }


  Future<List<Map<String, dynamic>>> getAllNotificationsForLectureId(int lectureId) async {
    // Get a reference to the database
    final Database db = await this.getDatabase();

    List<Map<String, dynamic>> allNotifications = await db.rawQuery("SELECT notificationId, minutesBefore, dateOfNotification, hourOfNotification, minuteOfNotification, title, description  FROM notifications  WHERE typeOfNotification = 'Lecture' AND mainId = $lectureId");

    await db.close();

    return allNotifications;
  }


  Future<List<Map<String, dynamic>>> getAllExamsNotifications() async{
    // Get a reference to the database
    final Database db = await this.getDatabase();

    List<Map<String, dynamic>> allNotifications = await db.rawQuery("SELECT notificationId, minutesBefore, dateOfNotification, hourOfNotification, minuteOfNotification, title, description  FROM notifications  WHERE typeOfNotification = 'Exam'");

    await db.close();

    return allNotifications;
  }



  Future<List<Map<String, dynamic>>> getAllNotificationsForExamId(int examId) async {
    // Get a reference to the database
    final Database db = await this.getDatabase();

    List<Map<String, dynamic>> allNotifications = await db.rawQuery("SELECT notificationId, minutesBefore, dateOfNotification, hourOfNotification, minuteOfNotification, title, description  FROM notifications  WHERE typeOfNotification = 'Exam' AND mainId = $examId");

    await db.close();

    return allNotifications;
  }


  Future<List<Map<String, dynamic>>> getAllEventsNotifications() async{
    // Get a reference to the database
    final Database db = await this.getDatabase();

    List<Map<String, dynamic>> allNotifications = await db.rawQuery("SELECT notificationId, minutesBefore, dateOfNotification, hourOfNotification, minuteOfNotification, title, description  FROM notifications  WHERE typeOfNotification = 'Event'");

    await db.close();

    return allNotifications;
  }


  Future<List<Map<String, dynamic>>> getAllNotificationsForEventId(int eventId) async {
    // Get a reference to the database
    final Database db = await this.getDatabase();

    List<Map<String, dynamic>> allNotifications = await db.rawQuery("SELECT notificationId, minutesBefore, dateOfNotification, hourOfNotification, minuteOfNotification, title, description  FROM notifications  WHERE typeOfNotification = 'Event' AND mainId = $eventId");

    await db.close();

    return allNotifications;
  }





  /// Migrates [db] from [oldVersion] to [newVersion].
  /// 
  /// *Note:* This operation only updates the schema of the tables present in
  /// the database and, as such, all data is lost.
  static FutureOr<void> migrate(
      Database db, int oldVersion, int newVersion) async {
    final batch = db.batch();
    if (oldVersion == 1) {
      batch.execute('DROP TABLE IF EXISTS notifications');
      batch.execute(createScript);
    } else if (oldVersion == 2) {
      //batch.execute(updateClassNumber);
    }
    await batch.commit();
  }
}
