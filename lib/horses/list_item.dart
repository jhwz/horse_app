import 'package:drift/drift.dart';
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
          child: FutureBuilder(
            future: db.getHorseProfilePicture(horse),
            builder: (context, AsyncSnapshot<Uint8List?> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                );
              }

              if (snapshot.hasData && snapshot.data != null) {
                return Image.memory(
                  snapshot.data!,
                  fit: BoxFit.cover,
                );
              }
              return const SizedBox();
            },
          ),
          width: 64,
          height: 64,
        ),
        title: Text(horse.displayName),
        subtitle: Text(
            '${DateTime.now().difference(horse.dateOfBirth).inDays ~/ 365} years old'),
        isThreeLine: true,
        onTap: () => onTap(horse),
        trailing: trailing,
      ),
    );
  }
}
