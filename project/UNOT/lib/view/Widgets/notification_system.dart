import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

class NotificationApi{
  static final _notifications = FlutterLocalNotificationsPlugin();


  static Future _notificationDetails() async {

    return NotificationDetails(
      android: AndroidNotificationDetails(
        'channel id',
        'channel name',
    ),
      iOS:  IOSNotificationDetails(),
    );
  }

  static Future init({bool initSchedule = false}) async {
    final android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final iOS = IOSInitializationSettings();
    final settings = InitializationSettings(android: android,iOS: iOS);
    await _notifications.initialize(
      settings,
    );
    tz.initializeTimeZones();
    final locationName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(locationName));
  }

  static Future showNotification  ({
  int id,
  String title,
  String body,
  DateTime date,
}) async =>
      _notifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(date,tz.local),
        await _notificationDetails(),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
    );


  static void cancelNotification(int id) async {
    await _notifications.cancel(id);
  }
}

