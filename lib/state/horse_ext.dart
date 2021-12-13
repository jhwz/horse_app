part of 'db.dart';

extension HorseHelpers on Horse {
  static const Duration cyclePeriod = Duration(days: 21);
  static const Duration heatDuration = Duration(days: 6);
  static const Duration postFoalingDuration = Duration(days: 7);

  String get displayName => name == "" ? registrationName : name;

  DateTime? nextHeatStart() {
    if (heatCycleStart == null) {
      return null;
    }

    var now = DateTime.now();

    // horrible algorithm but it will work
    var nextHeat = heatCycleStart!;
    while (nextHeat.isBefore(now)) {
      nextHeat = nextHeat.add(cyclePeriod);
    }
    return nextHeat;
  }

  DateTime? currentHeatEnd() {
    if (heatCycleStart == null) {
      return null;
    }

    var now = DateTime.now();

    var nextHeat = heatCycleStart!;
    var prevHeat = heatCycleStart!.subtract(cyclePeriod);
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

  Horse updateHeatFromFoalingDate(DateTime foalingDate) {
    return copyWith(
      heatCycleStart: Value(foalingDate.add(postFoalingDuration)),
    );
  }
}
