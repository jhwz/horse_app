import 'package:flutter/material.dart';

class KeyVal extends StatelessWidget {
  final String text;
  final String value;

  const KeyVal({Key? key, required this.text, required this.value})
      : super(key: key);

  Widget _keyWidget(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.caption,
    );
  }

  Widget _mainWidget(BuildContext context) {
    if (value.length > 30) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _keyWidget(context),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _keyWidget(context),
        Text(value, style: const TextStyle(fontSize: 16)),
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
