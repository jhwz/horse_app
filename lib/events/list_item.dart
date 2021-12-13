import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import '../utils/utils.dart';
import "../state/db.dart";

// A single item in the list of events on the main page.
// Applies to both past and future events.
class TopEventListItem extends StatelessWidget {
  final EventHorse event;
  final Function(EventHorse) onTap;

  const TopEventListItem({
    Key? key,
    required this.event,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minVerticalPadding: 0,
      title: Text(
        formatStr(event.type),
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text(event.horse.displayName), Text(event.date.date())]),
      isThreeLine: true,
      onTap: () => onTap(event),
    );
  }
}

class NestedEventListItem extends StatelessWidget {
  final EventHorse event;
  final Function(EventHorse) onTap;

  const NestedEventListItem({
    Key? key,
    required this.event,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minVerticalPadding: 0,
      contentPadding: const EdgeInsets.only(left: 20, right: 16),
      title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(
          formatStr(event.horse.displayName),
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        Text(event.date.date()),
      ]),
      onTap: () => onTap(event),
    );
  }
}

// An expandable item which when expanded, displays a group of list items which share
// a common event type.
class EventListGroup extends StatefulWidget {
  final Function(EventHorse) onTap;
  final List<EventHorse> events;

  const EventListGroup({Key? key, required this.events, required this.onTap})
      : super(key: key);

  @override
  State<EventListGroup> createState() => _EventListGroupState();
}

class _EventListGroupState extends State<EventListGroup> {
  bool _expanded = false;

  Widget _header(BuildContext context) {
    return ListTile(
      onTap: () => setState(() => _expanded = !_expanded),
      title: Text(
        formatStr(widget.events[0].type),
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
      subtitle:
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('${widget.events.length} horses'),
      ]),
      trailing:
          Icon(_expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
      isThreeLine: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expandable(
      theme: ExpandableThemeData(
        iconColor: Theme.of(context).colorScheme.onBackground,
        animationDuration: const Duration(milliseconds: 400),
      ),
      controller: ExpandableController(initialExpanded: _expanded),
      collapsed: _header(context),
      expanded: Column(children: [
        _header(context),
        ...widget.events
            .map((e) => NestedEventListItem(
                  event: e,
                  onTap: widget.onTap,
                ))
            .toList(),
        const Divider(
          height: 2,
          thickness: 2,
        ),
      ]),
    );
  }
}
