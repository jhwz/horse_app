import 'package:flutter/material.dart';

class AppBarSearch extends StatelessWidget {
  final void Function(String) onChanged;

  const AppBarSearch({Key? key, required this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      autofocus: true,
      decoration: InputDecoration(
        hintText: 'Filter...',
        border: InputBorder.none,
        fillColor: Theme.of(context).colorScheme.surface,
        filled: true,
      ),
    );
  }
}
