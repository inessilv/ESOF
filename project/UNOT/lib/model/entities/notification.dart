import 'package:flutter/rendering.dart';
import 'package:logger/logger.dart';
import 'package:uni/model/entities/event.dart';

import '../../controller/local_storage/notifications_database.dart';
import 'eventNotification.dart';
import 'exam.dart';
import 'examNotification.dart';
import 'lectureForNotification.dart';
import 'lectureNotification.dart';

/// Stores information about a lecture.
class Notification {


  List<DateTime> getDates(today) {
    List<DateTime> dates = [];
    for (int i = 0; i < 100; i++) {
      dates.add(today.add(Duration(days: i)));
    }
    return dates;
  }


  /// Get a list of LectureForNotification and based on today date create a list of lectures for notification.
  bool createNotificationsForClasses(List<LectureForNotification> lecs) {
    List<LectureNotification> notifications = [];

    // Get today date
    DateTime today = DateTime.now();

    //Get a list of 100 dates starting from today
    List<DateTime> dates = getDates(today);

    // For each lec in lecs create a notification for each date if date.weekday == lec.day
    for (LectureForNotification lec in lecs) {
      for (DateTime date in dates) {
        if (date.weekday == lec.day) {
          notifications.add(LectureNotification(
              hashValues(lec.lectureId, date),
              lec.lectureId,
              15,
              false,
              //init all notifications as inactive
              date.year.toString() + "-" +
                  date.month.toString().padLeft(2, '0') + "-" +
                  date.day.toString().padLeft(2, '0'),

              lec.startTime.toString().split(':')[0], //Hours to start
              lec.startTime.toString().split(':')[1], //Minutes
              "Notificação de Aula",
              lec.subject
          ));
        }
      }
    }


    final NotificationsDatabase db3 = NotificationsDatabase();
        db3.saveNewLecturesNotifications(notifications);



    return true;
  }










  bool createNotificationsForExams(List<Exam> exams) {
    List<ExamNotification> notifications = [];

    for (Exam exam in exams) {
      notifications.add(ExamNotification(
          hashValues(exam.examId, exam.date),
          exam.examId,
          15,
          false,
          exam.date_str,
          exam.begin.split(':')[0],
          exam.begin.split(':')[1],
          "Notificação de Exame",
          exam.subject
      ));
    }


    final NotificationsDatabase db3 = NotificationsDatabase();
        db3.saveNewExamsNotifications(notifications);


 

    return true;
  }







  bool createNotificationsForEvents(List<Event> events) {
    List<EventNotification> notifications = [];

    for (Event event in events) {
      notifications.add(EventNotification(
          hashValues(event.eventId, event.startDate),
          event.eventId,
          15,
          false,
          event.startDate,
          "",
          "",
          "Notificação de Evento",
          event.title
      ));
    }


    final NotificationsDatabase db4 = NotificationsDatabase();
        db4.saveNewEventsNotifications(notifications);


 

    return true;
  }


}



