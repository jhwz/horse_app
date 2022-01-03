part of 'db.dart';

extension EventHelpers on Event {
  // the ID for the notification that will be shown for an event
  int get notificationID => id;

  // the ID for the notification that will be shown a day before the event
  int get reminderNotificationID => -id;

  String get formattedType => formatStr(type);
}
