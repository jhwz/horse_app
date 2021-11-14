import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import '../utils/utils.dart';
import "../state/db.dart";

// A single item in the list of events on the main page.
// Applies to both past and future events.
class EventListItem extends StatelessWidget {
  final EventHorse event;
  final Function(EventHorse) onTap;

  const EventListItem({Key? key, required this.event, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        formatStr(event.type),
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text(event.horse.name), Text(event.date.date())]),
      isThreeLine: true,
      onTap: () {
        onTap(event);
      },
    );
  }
}

// An expandable item which when expanded, displays a group of list items which share
// a common event type.
class EventListGroup extends StatelessWidget {
  final Function(EventHorse) onTap;
  final List<EventHorse> events;

  const EventListGroup({Key? key, required this.events, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpandablePanel(
      header: ListTile(
        title: Text(
          formatStr(events[0].type),
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('${events.length} horses'),
        ]),
        isThreeLine: true,
      ),
      collapsed: const SizedBox.shrink(),
      expanded: Column(
        children:
            events.map((e) => EventListItem(event: e, onTap: onTap)).toList(),
      ),
    );
  }
}
