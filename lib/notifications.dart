import "package:flutter_local_notifications/flutter_local_notifications.dart";
import 'package:horse_app/state/db.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initNotificatons() async {
  tz.initializeTimeZones();
  final timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName));

  const android = AndroidInitializationSettings('@mipmap/ic_launcher');

  var ios = const IOSInitializationSettings();

  const macos = MacOSInitializationSettings();

  await flutterLocalNotificationsPlugin.initialize(
    InitializationSettings(
      android: android,
      iOS: ios,
      macOS: macos,
    ),
  );
}

const eventNotificationDetails = NotificationDetails(
  android: AndroidNotificationDetails(
    'horse_app_events',
    'events',
    channelDescription: 'Event notifications',
  ),
);

scheduleNotificationForEvent(Event e, String horseName) async {
  _scheduleEventNotification(
    e,
    title: "${e.formattedType} for $horseName",
    reminderTitle: "${e.formattedType} for $horseName tomorrow",
  );
}

scheduleNotificationForEventList(Event e, int numHorses) async {
  _scheduleEventNotification(
    e,
    title: "${e.formattedType} for $numHorses horses",
    reminderTitle: "${e.formattedType} for $numHorses horses tomorrow",
  );
}

_scheduleEventNotification(Event e,
    {String? reminderTitle,
    String? reminderBody,
    String? title,
    String? body}) async {
  final reminderScheduledTime =
      tz.TZDateTime.from(e.date.subtract(const Duration(days: 1)), tz.local);
  final scheduledTime = tz.TZDateTime.from(e.date, tz.local);

  // schedule an event for a day before the event starting
  if (reminderScheduledTime.isAfter(tz.TZDateTime.now(tz.local))) {
    flutterLocalNotificationsPlugin.zonedSchedule(
      e.reminderNotificationID,
      reminderTitle,
      reminderBody,
      reminderScheduledTime,
      eventNotificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  // schedule an event for when the event starts
  if (scheduledTime.isAfter(tz.TZDateTime.now(tz.local))) {
    flutterLocalNotificationsPlugin.zonedSchedule(
      e.notificationID,
      title,
      body,
      scheduledTime,
      eventNotificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
