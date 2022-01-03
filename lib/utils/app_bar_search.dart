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
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          gapPadding: 0,
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        fillColor: Theme.of(context).colorScheme.surface,
        filled: true,
      ),
    );
  }
}

class AppBarAnimator extends StatelessWidget {
  final Widget child;
  const AppBarAnimator({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 100),
      transitionBuilder: (Widget child, Animation<double> animation) {
        final offsetAnimation =
            Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
                .animate(animation);
        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
      child: child,
    );
  }
}
