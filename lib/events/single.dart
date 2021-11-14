import 'package:flutter/material.dart';

import '../utils/utils.dart';
import "../state/db.dart";

class EventSummaryPage extends StatefulWidget {
  final EventHorse event;

  const EventSummaryPage({Key? key, required this.event}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EventSummaryPageState();
}

class _EventSummaryPageState extends State<EventSummaryPage> {
  static const String _title = 'Log Summary';

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

    // if (e is DrenchEvent) {
    //   out.add(textWidget("Drench Type", e.drenchType));
    // } else if (e is FarrierEvent) {
    //   //
    // } else if (e is MiteTreatmentEvent) {
    //   out.add(textWidget("Mite Treatment Type", e.miteTreatmentType));
    // } else if (e is DentistEvent) {
    //   //
    // } else if (e is FoalingEvent) {
    //   out.add(textWidget("Foal Sex", e.foalSex.toSexString()));
    //   out.add(textWidget("Foal Colour", e.foalColour));
    //   out.add(textWidget("Foal Sire", e.sireRegistrationName));
    // } else if (e is FeedEvent) {
    //   //
    // } else if (e is VetEvent) {
    //   //
    // } else if (e is PregnancyScans) {
    //   out.add(
    //       textWidget(null, e.inFoal ? "In Foal" : "Not In Foal", bold: true));
    //   out.add(textWidget("Days in foal", e.numberOfDays.toString()));

    //   if (e.inFoal) {
    //     if (e.numberOfDays != null) {
    //       var conception = e.date.subtract(Duration(days: e.numberOfDays!));
    //       var estimateFoaling = conception.add(const Duration(days: 338));

    //       out.add(textWidget("Estimate Conception", conception.date()));
    //       out.add(textWidget("Estimate Foaling Date", estimateFoaling.date()));
    //     }
    //     out.add(textWidget("Foal Sire", e.sireRegistrationName ?? "N/A"));
    //   }
    // }

    out = out
        .map<Widget>((w) => Padding(
              padding: const EdgeInsets.only(left: 32, right: 32, top: 12),
              child: w,
            ))
        .toList();

    if (out.isNotEmpty) {
      out.insert(
          0,
          Row(
            children: [
              Text(
                "   Event Specific Details",
                style: Theme.of(context).textTheme.subtitle2,
              ),
              const Expanded(
                child: Divider(
                  thickness: 1,
                  indent: 6,
                  endIndent: 12,
                ),
              )
            ],
          ));
    }
    return out;
  }

  @override
  Widget build(BuildContext context) {
    final e = widget.event;
    return Scaffold(
      appBar: AppBar(title: const Text(_title)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Text(
                formatStr(e.type),
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: "Horse",
                  border: InputBorder.none,
                ),
                controller: TextEditingController(
                  text: e.horse.name,
                ),
                readOnly: true,
                focusNode:
                    FocusNode(canRequestFocus: false, skipTraversal: true),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: "Time of event",
                  border: InputBorder.none,
                ),
                controller: TextEditingController(text: e.date.dateTime()),
                readOnly: true,
                focusNode:
                    FocusNode(canRequestFocus: false, skipTraversal: true),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 32, right: 32, bottom: 12),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: "Event notes",
                  border: InputBorder.none,
                ),
                controller: TextEditingController(
                  text: e.notes != "" ? e.notes : "None",
                ),
                readOnly: true,
                maxLines: null,
                focusNode:
                    FocusNode(canRequestFocus: false, skipTraversal: true),
              ),
            ),
            ..._buildEvents(e),
          ],
        ),
      ),
    );
  }
}
