import 'package:http/http.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/course.dart';
import 'package:redux/redux.dart';
import 'package:logger/logger.dart';

import '../../model/entities/event.dart';
import '../parsers/parser_events_html.dart';

  Future<List<Event>> getEvents(Store<AppState> store) async {

    final List<Course> courses = store.state.content['profile'].courses;


final List<Response> eventsResponse = await Future.wait(courses.map(
            (course) => NetworkRouter.getWithCookies(
            NetworkRouter.getBaseUrlFromSession(
                store.state.content['session']) +
                 '''noticias_geral.eventos?p_g_eventos=0''', {},
            store.state.content['session'])));


    final List<Event> events = await Future.wait(
            eventsResponse.map((response) => getEventsFromHtml(response)))
        .then((schedules) => schedules.expand((schedule) => schedule).toList());

    Logger().e('EVENTS FETCHED');

    return events;


    
  }




