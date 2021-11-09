part of 'db.dart';

extension HorseHelpers on Horse {
  static const Duration cyclePeriod = Duration(days: 21);
  static const Duration heatDuration = Duration(days: 6);

  DateTime? nextHeatStart() {
    if (heat == null) {
      return null;
    }

    var now = DateTime.now();

    // horrible algorithm but it will work
    var nextHeat = heat!;
    while (nextHeat.isBefore(now)) {
      nextHeat = nextHeat.add(cyclePeriod);
    }
    return nextHeat;
  }

  DateTime? currentHeatEnd() {
    if (heat == null) {
      return null;
    }

    var now = DateTime.now();

    var nextHeat = heat!;
    var prevHeat = heat!;
    while (nextHeat.isBefore(now)) {
      prevHeat = nextHeat;
      nextHeat = nextHeat.add(cyclePeriod);
    }
    if (prevHeat.isAfter(now)) {
      return null;
    }
    return prevHeat.add(heatDuration);
  }

  bool isInHeat() {
    return currentHeatEnd()?.isAfter(DateTime.now()) ?? false;
  }

  // void setHeatDateFromPregnancy(DateTime date) {
  //   this.heat = date.add(const Duration(days: 6));
  // }
}
