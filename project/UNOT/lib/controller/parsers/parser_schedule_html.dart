import 'dart:async';
import 'dart:ui';

import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';
import 'package:logger/logger.dart';
import 'package:uni/model/entities/lecture.dart';
import 'dart:developer';

import '../../model/entities/lectureForNotification.dart';

/// Extracts the user's lectures from an HTTP [response] and sorts them by date.
///
/// This function parses the schedule's HTML page.
Future<List<Lecture>> getScheduleFromHtml(http.Response response) async {
  final document = parse(response.body);
  var semana = [0, 0, 0, 0, 0, 0];

  final List<Lecture> lecturesList = [];
  document.querySelectorAll('.horario > tbody > tr').forEach((Element element) {
    if (element.getElementsByClassName('horas').isNotEmpty) {
      var day = 0;
      final List<Element> children = element.children;
      for (var i = 1; i < children.length; i++) {
        for (var d = day; d < semana.length; d++) {
          if (semana[d] == 0) {
            break;
          }
          day++;
        }
        final clsName = children[i].className;
        if (clsName == 'TE' || clsName == 'TP' || clsName == 'PL') {
          final String subject =
              children[i].querySelector('b > acronym > a').text;
          String classNumber = null;

          if (clsName == 'TP' || clsName == 'PL') {
            classNumber = children[i].querySelector('span > a').text;
          }
 
          final Element rowSmall =
          children[i].querySelector('table > tbody > tr');
          final String room = rowSmall.querySelector('td > a').text;
          final String teacher = rowSmall.querySelector('td.textod a').text;

          final String typeClass = clsName;
          final int blocks = int.parse(children[i].attributes['rowspan']);
          final String startTime = children[0].text.substring(0, 5);

          semana[day] += blocks;

          final Lecture lect = Lecture.fromHtml(subject, typeClass, day,
              startTime, blocks, room, teacher, classNumber);
          lecturesList.add(lect);

          log('\n\nThe class is: ${[subject, typeClass, day,
            startTime, blocks, room, teacher, classNumber]}');
        }
        day++;
      }
      semana = semana.expand((i) => [(i - 1) < 0 ? 0 : i - 1]).toList();
    }
  });
  lecturesList.sort((a, b) => a.compare(b));

  return lecturesList;
}





Future<List<LectureForNotification>> getScheduleForNotificationFromHtml(http.Response response) async {
  final document = parse(response.body);
  final List<LectureForNotification> lecturesList = [];

  // This map will handle compromised data levels
  var comp_index = new Map();
  //['Horas', 'Segunda', 'Terça', 'Quarta', 'Quinta', 'Sexta', 'Sábado']
  var main_header = [];
  //['08:00 - 08:30', '08:30 - 09:00', '09:00 - 09:30',......]
  var horas_k = [];
  var aulas_teste = [];



  // Adding table header to main_header
  document.querySelectorAll('.horario .b').forEach((Element element){
    main_header.add(element.text);
  });

  // Add all hours to all_hours_k
  document.querySelectorAll('.horas.k').forEach((Element element){
    horas_k.add(element.text);
  });

  var i = 0; // Controls the tr index
  document.querySelectorAll('.horario > tbody > tr').forEach((Element element) {


    var this_tr = element;
    var tr_tds_tmp = this_tr.children;
    var tr_tds = [];





    if (comp_index.keys.toList().indexOf(i) != -1){
      // This level of tr has compromised elements that causes problem
      // to get hours correctly. Need to fix that

      for (var jj in [0,1,2,3,4,5,6]){

        if (comp_index[i].indexOf(jj) != -1) {
          tr_tds.add(document.createElement("td"));
        }

        if (comp_index[i].indexOf(jj) == -1){
          // Next level is not compromised
          // Add real tr
          if (tr_tds_tmp.length > 0){
            tr_tds.add(tr_tds_tmp[0]);
            tr_tds_tmp.removeAt(0);
          }

        }

      }

    }else{
      tr_tds = tr_tds_tmp;
    }





    for (var j = 0; j < main_header.length - 1; j++){
      //Weekday 0...6
      var weekday = main_header[j];
      var start_hour = tr_tds[0].text;

      //THIS
      var this_td = tr_tds[j];



      if (this_td == null){
        continue;
      }



      //Class horas -> No classes
      //Class TE -> Teorica
      //Class TP -> Pratica
      //Class PL -> Pratica
      var IS_CLASS = this_td.className == "TE" || this_td.className == "TP" || this_td.className == "PL";

      if (IS_CLASS){

        var class_type = this_td.className;


        // Will help to get class duration
        // rowspan == 2 -> 1 hora de aula
        // rowspan == 4 -> 2 horas de aula
        var total_rowspan = int.parse(this_td.attributes['rowspan']);

        var this_start_hour_index = horas_k.indexOf(start_hour);
        var this_class_start_hour = horas_k[this_start_hour_index + 0];

        var other_info = this_td.querySelector(".formatar");
        var room = "";
        var prof_name = "";
        var prof_ac = "";

        if (other_info != null){
          var room = other_info.querySelector("tbody > tr > td > a");
          if (room != null){
            room = room.text;
          }

          var prof = other_info.querySelector("tbody > tr > td.textod");

          if (prof != null){
            prof_name = prof.text;
            var prof_ac_el = prof.querySelector("acronym");
            if (prof_ac_el != null){
              prof_ac = prof_ac_el.attributes['title'];
            }

          }


        }


        var class_symbol = this_td.querySelector("acronym > a").text;
        var class_title = this_td.querySelector("acronym").attributes["title"];
        
        int lectureId = hashValues(class_symbol, class_type, this_class_start_hour, weekday);


        final splitted_this_class_start_hour = this_class_start_hour.split(' -')[0];


        final LectureForNotification lect = LectureForNotification(lectureId, class_symbol, class_title, class_type, 0, room, prof_name, "", splitted_this_class_start_hour, total_rowspan, j);
        //lect.printLecture();
        lecturesList.add(lect);


        total_rowspan = int.parse(this_td.attributes['rowspan']).ceil();
        var all_compromised_index = total_rowspan - 1; // Only first hours are OK
        var compromised_table_row_start = i+1; // First compromised level

        // Add compromised hours to comp_index (help to fix hours for classes)
        for (var k = 0; k < all_compromised_index; k++){
          if (comp_index[compromised_table_row_start + k] == null){
            comp_index[compromised_table_row_start + k] = [];
          }

          comp_index[compromised_table_row_start + k].add(j);
        }


      }


    }




    i++;



  });


  return lecturesList;
}