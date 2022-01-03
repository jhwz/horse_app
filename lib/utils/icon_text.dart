import 'package:flutter/material.dart';

class IconText extends StatelessWidget {
  final IconData icon;
  final String text;

  const IconText(
    this.text,
    this.icon, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon),
        const SizedBox(width: 8),
        Text(text),
      ],
    );
  }
}

class TextIcon extends StatelessWidget {
  final IconData icon;
  final String text;

  const TextIcon(
    this.text,
    this.icon, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(text),
        const SizedBox(width: 8),
        Icon(icon),
      ],
    );
  }
}
