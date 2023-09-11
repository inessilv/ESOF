import 'dart:async';
import 'dart:ui';

import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';
import 'package:logger/logger.dart';
import 'package:uni/model/entities/event.dart';
import 'package:uni/model/entities/lecture.dart';
import 'dart:developer';


Future<List<Event>> getEventsFromHtml(http.Response response) async {
  final document = parse(response.body);
  final List<Event> eventList = [];


  var main_box_of_events = document.querySelector(".topo");

  main_box_of_events.querySelectorAll("li").forEach((Element element){
    var complete_date = element.querySelector("b").text; // 30 de maio a 3 de junho     OR     3 de junho
    var splitted = complete_date.split(' a ');
    
    var start_date_month = "";
    var start_date_day = "";
    var end_date_month = "";
    var end_date_day = "";

    if (splitted.length == 2) {
      // Splitted with  " a "
      // Can be 30 de maio a 3 de junho OR 3 a 4 de junho
      var start_date = splitted[0];
      var end_date = splitted[1];

      // 30 de maio or 3

      var start_date_split = start_date.split(' de ');
      var end_date_split = end_date.split(' de ');

      if (start_date_split.length == 2) {
        // 30 de maio
        start_date_day = start_date_split[0];
        start_date_month = start_date_split[1];
      } else {
        // 3
        start_date_day = start_date_split[0];
        start_date_month = end_date_split[1];
      }


      end_date_day = end_date_split[0];
      end_date_month = end_date_split[1];

    } else {


      var start_date = splitted[0];
      var end_date = splitted[0];

      var start_date_split = start_date.split(' de ');
      var end_date_split = end_date.split(' de ');

      start_date_day = start_date_split[0];
      start_date_month = start_date_split[1];

      end_date_day = end_date_split[0];
      end_date_month = end_date_split[1];


    }


    // set endDateYear and startDateYear to the current year String
    var startDateYear = DateTime.now().year.toString();
    var endDateYear = DateTime.now().year.toString();


    var event_title = element.querySelector("a").text;

    Event event = Event(startDateYear, start_date_month.replaceAll(" ", "").replaceAll("\n", ""), start_date_day, endDateYear, end_date_month.replaceAll(" ", "").replaceAll("\n", ""), end_date_day, event_title);

    eventList.add(event);

    //Logger().e(event.toMap());
  });




  return eventList;
}