import 'package:flutter/material.dart';

class LabelledDivider extends StatelessWidget {
  final double? left;
  final String text;
  const LabelledDivider(this.text, {Key? key, this.left}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        children: <Widget>[
          if (left != null)
            SizedBox(
              child: const Divider(
                endIndent: 10,
              ),
              width: left,
            ),
          Text(
            text,
            style: Theme.of(context).textTheme.overline,
          ),
          const Expanded(
              child: Divider(
            indent: 10,
          )),
        ],
      ),
    );
  }
}
