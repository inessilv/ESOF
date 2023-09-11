import 'package:flutter/rendering.dart';
import 'package:logger/logger.dart';

/// Stores information about a lecture.
class ExamNotification {
  int notificationId; 
  int lectureId;
  int minutesBefore;
  bool isActive;
  String dateOfNotification;
  String hourOfNotification;
  String minuteOfNotification;
  String title;
  String description;

  /// Creates an instance of the class [Lecture].
  ExamNotification(
  int notificationId,
  int lectureId,
  int minutesBefore,
  bool isActive,
  String dateOfNotification,
  String hourOfNotification,
  String minuteOfNotification,
  String title,
  String description) {
    this.notificationId = notificationId;
    this.lectureId = lectureId;
    this.minutesBefore = minutesBefore;
    this.isActive = isActive;
    this.dateOfNotification = dateOfNotification;
    this.hourOfNotification = hourOfNotification;
    this.minuteOfNotification = minuteOfNotification;
    this.title = title;
    this.description = description;
  }


  /// Converts this lecture to a map.
  Map<String, dynamic> toMap() {
    return {
      'notificationId': notificationId,
      'mainId': lectureId,
      "typeOfNotification": "Exam",
      'minutesBefore': minutesBefore,
      'isActive': isActive,
      'dateOfNotification': dateOfNotification,
      'hourOfNotification': hourOfNotification,
      'minuteOfNotification': minuteOfNotification,
      'title': title,
      'description': description,
    };
    }


/// Prints the data in this lecture to the [Logger] with an INFO level.
printNotification() 
{

  return;

      //Get today date
    DateTime now = DateTime.now();
    Logger().e("notificationId: $notificationId");
    Logger().e("mainId: $lectureId");
    Logger().i("typeOfNotification: Exam");
    Logger().i("minutesBefore: $minutesBefore");
    Logger().i("isActive: $isActive");
    Logger().i("dateOfNotification: $dateOfNotification");
    Logger().i("hourOfNotification: $hourOfNotification");
    Logger().i("minuteOfNotification: $minuteOfNotification");
    Logger().i("title: $title");
    Logger().i("description: $description");


  }




  }


