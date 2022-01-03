import 'package:flutter/material.dart';
import 'package:horse_app/state/db.dart';
import 'package:horse_app/utils/utils.dart';

class HorseListItem extends StatelessWidget {
  final Horse horse;
  final Function(Horse) onTap;
  final Widget? trailing;

  const HorseListItem(
      {Key? key, required this.horse, this.trailing, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ListTile(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        tileColor: Theme.of(context).colorScheme.surface,
        contentPadding:
            const EdgeInsets.only(left: 8, right: 16, top: 0, bottom: 0),
        minVerticalPadding: 0,
        leading: SizedBox(
          child: horse.photo != null
              ? Image.memory(horse.photo!)
              : const SizedBox.shrink(),
          width: 80,
          height: 64,
        ),
        title: Text(horse.displayName),
        subtitle: Text(
            '${horse.registrationName} - ${DateTime.now().difference(horse.dateOfBirth).inDays ~/ 365} years old'),
        isThreeLine: true,
        onTap: () => onTap(horse),
        trailing: trailing,
      ),
    );
  }
}
