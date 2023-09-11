import 'package:flutter/rendering.dart';
import 'package:logger/logger.dart';

/// Stores information about a lecture.
class Event {
  static var months = {
  'janeiro': '01',
  'fevereiro': '02',
  'março': '03',
  'abril': '04',
  'maio': '05',
  'junho': '06',
  'julho': '07',
  'agosto': '08',
  'setembro': '09',
  'outubro': '10',
  'novembro': '11',
  'dezembro': '12'
};
  int eventId;
  String startDateYear;
  String startDateMonth;
  String startDateDay;
  String endDateYear;
  String endDateMonth;
  String endDateDay;
  String title;
  String startDate;
  String endDate;

  /// Creates an instance of the class [Lecture].
  Event(
      String startDateYear,
      String startDateMonth,
      String startDateDay,
      String endDateYear,
      String endDateMonth,
      String endDateDay,
      String title
      ) {
    this.eventId = hashValues(startDate, startDateDay, endDateMonth, startDateYear);
    this.startDate = (startDateYear + '-' + months[startDateMonth] + '-' + startDateDay).replaceAll("\n", "");
    this.endDate = (endDateYear + '-' + months[endDateMonth] + '-' + endDateDay).replaceAll("\n", "");
    this.title = title;
  }



  /// Converts this lecture to a map.
  Map<String, dynamic> toMap() {
    return {
      'eventId': eventId,
      'startDate': startDate,
      'endDate': endDate,
      'title': title,
    };
  }

}