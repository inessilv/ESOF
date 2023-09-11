
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_file/open_file.dart';


import '../../controller/local_storage/app_events_notifications_database.dart';
import '../../controller/local_storage/app_exams_notifications_database.dart';


List<List<String>> getExamsForPdf(List<Map<String, dynamic>> exams){
  List<List<String>> formated_exams = [];

  formated_exams.add(['Data', 'Cadeira', 'Sala', 'Tipo', 'Hora']);

  for(Map<String, dynamic> exam in exams){
    formated_exams.add([exam['day']+exam['month'], exam['subject'], exam['rooms'], exam['examType'], exam['begin']]);
  }

return formated_exams;
  
}


List<List<String>> getEventsForPdf(List<Map<String, dynamic>> events){
  List<List<String>> formated_events = [];

  formated_events.add(['Evento', 'Início', 'Fim']);

  for(Map<String, dynamic> event in events){
    formated_events.add([event['title'], event['startDate'], event['endDate']]);
  }

  return formated_events;

}

Future<void> getNotificationsPdf() async {


ExamsForNotificationsExtension db = ExamsForNotificationsExtension();
EventsDatabase db2 = EventsDatabase();

 List<Map<String, dynamic>> exams = await db.getExamsForNotifications();
List<Map<String, dynamic>> events = await db2.getAllEvents();

final pdf = pw.Document();

  pdf.addPage(pw.MultiPage(
    pageFormat: PdfPageFormat.a4,
    margin: pw.EdgeInsets.all(32),
    build: (pw.Context context) {
      return <pw.Widget>[
      pw.Header(
      level: 0,
      child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: <pw.Widget>[
      pw.Text('UNI Notificações', textScaleFactor: 2),
      ])),
      pw.Header(level: 1, text: 'Exames'),



      pw.Padding(padding: const pw.EdgeInsets.all(10)),
      pw.Table.fromTextArray(context: context, data:  getExamsForPdf(exams)),


      pw.Header(level: 1, text: 'Eventos'),


      pw.Padding(padding: const pw.EdgeInsets.all(10)),
      pw.Table.fromTextArray(context: context, data:  getEventsForPdf(events)),
      ];
    },
  ));

        


final output = await getTemporaryDirectory();
final file = File("${output.path}/example.pdf");
await file.writeAsBytes(await pdf.save());

OpenFile.open("${output.path}/example.pdf");

}