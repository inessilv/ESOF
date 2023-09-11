import 'package:flutter/rendering.dart';
import 'package:logger/logger.dart';

/// Stores information about a lecture.
class LectureForNotification {
  static var dayName = [
    'Segunda-feira',
    'Terça-feira',
    'Quarta-feira',
    'Quinta-feira',
    'Sexta-feira',
    'Sábado',
    'Domingo'
  ];
  int lectureId;
  String subject;
  String completeTitle;
  String startTime;
  String typeClass;
  String room;
  String teacher;
  String classNumber;
  int day;
  int blocks;
  int classTime; // Duration of class

  /// Creates an instance of the class [Lecture].
  LectureForNotification(
      int lectureId,
      String subject,
      String completeTitle,
      String typeClass,
      int blocks,
      String room,
      String teacher,
      String classNumber,
      String startTime,
      int classTime,
      int day
      ) {
    this.lectureId = lectureId;
    this.subject = subject;
    this.completeTitle = completeTitle;
    this.typeClass = typeClass;
    this.room = room;
    this.teacher = teacher;
    this.day = day;
    this.blocks = blocks;
    this.classNumber = classNumber;
    this.startTime = startTime;
    this.classTime = classTime;
  }



  /// Converts this lecture to a map.
  Map<String, dynamic> toMap() {
    return {
      'lectureId': lectureId,
      'subject': subject,
      'completeTitle': completeTitle,
      'typeClass': typeClass,
      'blocks': blocks,
      'room': room,
      'teacher': teacher,
      'classNumber': classNumber,
      'day': day,
      'startTime': startTime,
      'classTime': classTime
    };
    }


      /// Prints the data in this lecture to the [Logger] with an INFO level.
  printLecture() {

    Logger().i(
        'LectureForNotification: subject: $subject, completeTitle: $completeTitle, typeClass: $typeClass, blocks: $blocks, room: $room, teacher: $teacher, day: $day, startTime: $startTime, classTime: $classTime');
  }


  @override
  int get hashCode => hashValues(
      subject,
      completeTitle,
      typeClass,
      blocks,
      room,
      teacher,
      day,
      startTime,
      classTime);

  @override
  bool operator ==(o) =>
      o is LectureForNotification &&
      o.subject == subject &&
      o.completeTitle == completeTitle &&
      o.typeClass == typeClass &&
      o.blocks == blocks &&
      o.room == room &&
      o.teacher == teacher &&
      o.day == day &&
      o.startTime == startTime &&
      o.classTime == classTime;

  }


