import 'package:flutter/material.dart';
import 'package:horse_app/horses/list.dart';
import 'package:horse_app/horses/list_item.dart';
import 'package:horse_app/horses/single.dart';
import 'package:horse_app/utils/keyval.dart';

import '../utils/utils.dart';
import "../state/db.dart";

class EventSummaryPage extends StatefulWidget {
  final EventHorse event;

  const EventSummaryPage({Key? key, required this.event}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EventSummaryPageState();
}

class _EventSummaryPageState extends State<EventSummaryPage> {
  List<Widget> _buildEvents(Event e) {
    var out = <Widget>[];

    if (e.extra != null) {
      for (final key in e.extra!.keys) {
        if (e.extra![key] is! String) continue;

        out.add(
          KeyVal(
            text: formatStr(key),
            value: formatStr(e.extra![key]),
          ),
        );
      }
    }

    return out;
  }

  @override
  Widget build(BuildContext context) {
    final e = widget.event;
    return Scaffold(
      appBar: AppBar(title: Text(e.formattedType)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            HorseListItem(
              horse: e.horse,
              onTap: (Horse h) => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HorseProfilePage(horse: e.horse),
                ),
              ),
            ),
            KeyVal(text: "Time of event:", value: e.date.dateTime()),
            KeyVal(
              text: "Notes:",
              value: e.notes != null ? e.notes! : "None",
              muted: e.notes == null,
            ),
            ..._buildEvents(e),
          ],
        ),
      ),
    );
  }
}
