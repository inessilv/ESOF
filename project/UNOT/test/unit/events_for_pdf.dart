import 'package:test/test.dart';
import 'package:uni/model/entities/notifications_pdf.dart';

void main() {
  group('Notifications PDF', () {
    test('Get exams for pdf should return a non-empty list ', () {

      List<Map<String, dynamic>> exams = [
        {
          "day": "09",
          "month": "Junho",
          "subject": "CT",
          "rooms": "B103",
          "examType": "ER",
          "begin": "11:29"
        },
        {
          "day": "10",
          "month": "Julho",
          "subject": "TC",
          "rooms": "B104",
          "examType": "EN",
          "begin": "11:30"
        },
        {
          "day": "11",
          "month": "Agosto",
          "subject": "SO",
          "rooms": "B139",
          "examType": "EN",
          "begin": "11:30"
        },
        {
          "day": "12",
          "month": "Setembro",
          "subject": "OS",
          "rooms": "B140",
          "examType": "ER",
          "begin": "11:32"
        }
      ];

      List<List<String>> formated_exams = getExamsForPdf(exams);

      expect(formated_exams.length - 1, 4);
    });
    test('Get events for pdf should return a non-empty list ', () {
      List<Map<String, dynamic>> events = [
      {
        "title": "Fire Extinguisher Technologies",
        "startDate": "2022-06-21",
        "endDate": "2032-06-21"
      },
      {
        "title":"PRODEC Seminars" ,
        "startDate": "2022-06-22",
        "endDate": "2022-06-22"
      },
      {
        "title": "XVI Jornadas de Ciência da Informação",
        "startDate": "2022-06-27",
        "endDate": "2022-06-27"
      },
      {
        "title": "Hello World",
        "startDate": "2022-06-29",
        "endDate": "2022-06-29"
      },
      ];

      List<List<String>> formated_events = getEventsForPdf(events);

      expect(formated_events.length - 1, 4);
    });
  });
}