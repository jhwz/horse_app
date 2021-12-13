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

    Widget textWidget(String? text, String value, {bool bold = false}) {
      return TextField(
        controller: TextEditingController(text: value),
        decoration: InputDecoration(
          labelText: text,
          border: InputBorder.none,
        ),
        style:
            TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal),
        readOnly: true,
        focusNode: FocusNode(canRequestFocus: false, skipTraversal: true),
      );
    }

    out = out
        .map<Widget>((w) => Padding(
              padding: const EdgeInsets.only(left: 32, right: 32, top: 12),
              child: w,
            ))
        .toList();

    return out;
  }

  @override
  Widget build(BuildContext context) {
    final e = widget.event;
    return Scaffold(
      appBar: AppBar(title: Text(formatStr(e.type))),
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
            KeyVal(text: "Notes:", value: e.notes != null ? e.notes! : "None"),
            ..._buildEvents(e),
          ],
        ),
      ),
    );
  }
}
