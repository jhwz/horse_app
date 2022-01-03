import 'package:flutter/material.dart';
import 'package:horse_app/theme.dart';

class KeyVal extends StatelessWidget {
  final String text;
  final String value;
  final bool muted;

  const KeyVal(
      {Key? key, required this.text, required this.value, this.muted = false})
      : super(key: key);

  Widget _keyWidget(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.caption,
    );
  }

  Widget _valueWidget(BuildContext context) {
    return Text(
      value,
      style: TextStyle(
        fontSize: 16,
        color: muted
            ? Theme.of(context)
                .colorScheme
                .onBackground
                .mute(50, Theme.of(context).brightness)
            : null,
      ),
    );
  }

  Widget _mainWidget(BuildContext context) {
    if (value.length > 30) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [_keyWidget(context)]),
          _valueWidget(context),
        ],
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _keyWidget(context),
        _valueWidget(context),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
      child: _mainWidget(context),
    );
  }
}
