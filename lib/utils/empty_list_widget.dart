import 'package:flutter/material.dart';

class EmptyListTemplate extends StatelessWidget {
  final String title;
  final Widget child;

  const EmptyListTemplate({Key? key, required this.title, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headline6,
          ),
          const SizedBox(height: 16),
          child
        ],
      ),
    );
  }
}
