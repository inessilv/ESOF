import 'package:http/http.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/controller/parsers/parser_schedule_html.dart';
import 'package:uni/controller/schedule_fetcher/schedule_fetcher.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/course.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:redux/redux.dart';
import 'package:logger/logger.dart';

import '../../model/entities/lectureForNotification.dart';

/// Class for fetching the user's lectures from the schedule's HTML page.
class ScheduleFetcherHtml extends ScheduleFetcher {
  /// Fetches the user's lectures from the schedule's HTML page.
  @override
  Future<List<Lecture>> getLectures(Store<AppState> store) async {
    final List<Course> courses = store.state.content['profile'].courses;
    final dates = getDates();
    final List<Response> lectureResponses = await Future.wait(courses.map(
        (course) => NetworkRouter.getWithCookies(
            NetworkRouter.getBaseUrlFromSession(
                    store.state.content['session']) +
                '''
hor_geral.estudantes_view?pv_fest_id=${course.festId}&pv_ano_lectivo=${dates.lectiveYear}&p_semana_inicio=${dates.beginWeek}&p_semana_fim=${dates.endWeek}''',
            {},
            store.state.content['session'])));

    Logger().e('WILL CALL SCRAPER');

    final List<Lecture> lectures = await Future.wait(
            lectureResponses.map((response) => getScheduleFromHtml(response)))
        .then((schedules) => schedules.expand((schedule) => schedule).toList());


    lectures.sort((l1, l2) => l1.compare(l2));
    return lectures;
  }






  /// Fetches the user's lectures from the schedule's HTML page.
  @override
  Future<List<LectureForNotification>> getLecturesForNotifications(Store<AppState> store) async {
    final List<Course> courses = store.state.content['profile'].courses;
    final dates = getDates();
    final List<Response> lectureResponses = await Future.wait(courses.map(
            (course) => NetworkRouter.getWithCookies(
            NetworkRouter.getBaseUrlFromSession(
                store.state.content['session']) +
                '''
hor_geral.estudantes_view?pv_fest_id=${course.festId}&pv_ano_lectivo=${dates.lectiveYear}&p_semana_inicio=${dates.beginWeek}&p_semana_fim=${dates.endWeek}''',
            {},
            store.state.content['session'])));

    Logger().e('WILL CALL SCRAPER');

    final List<LectureForNotification> lectures = await Future.wait(
        lectureResponses.map((response) => getScheduleForNotificationFromHtml(response)))
        .then((schedules) => schedules.expand((schedule) => schedule).toList());


    return lectures;
  }
}
