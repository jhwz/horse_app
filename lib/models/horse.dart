import 'dart:typed_data';
import '../db.dart';

int dateTimeToInt(DateTime dateTime) {
  return dateTime.millisecondsSinceEpoch;
}

DateTime intToDateTime(int millisecondsSinceEpoch) {
  return DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
}

enum Sex { unknown, male, female }

extension SexString on Sex {
  static const List<String> mapping = ["Unknown", "Male", "Female"];

  String toSexString() {
    return mapping[index];
  }
}

class Horse {
  // registration number
  String? registrationNumber;

  // registered name of the horse
  String registrationName;

  String sireRegistrationName;
  String damRegistrationName;

  // name to refer to the horse by
  String name;

  // gender of the horse
  Sex sex;

  // hands unit
  num height;

  DateTime dateOfBirth;

  // When the horses heat is due to appear
  DateTime? heat;

  Uint8List? photo;

  Horse({
    required this.registrationName,
    required this.dateOfBirth,
    required this.sex,
    this.registrationNumber,
    this.sireRegistrationName = '',
    this.damRegistrationName = '',
    this.name = '',
    this.height = 0,
    this.photo,
    this.heat,
  }) {
    if (name == '') {
      name = registrationName;
    }
  }

  static String _strOr(Map<String, Object?> map, String key, String def) {
    var raw = map[key];
    return raw is String ? raw : def;
  }

  static T _valOr<T>(Map<String, Object?> map, String key, T def) {
    var raw = map[key];
    return raw is T ? raw : def;
  }

  static DateTime? _getDate(Object? raw) {
    return raw is int
        ? intToDateTime(raw)
        : raw is String
            ? DateTime.parse(raw)
            : raw is DateTime
                ? raw
                : null;
  }

  factory Horse.fromMap(Map<String, Object?> map) {
    DateTime dob = _getDate(map[HorsesTable.dateOfBirth]) ?? DateTime.now();
    DateTime? heat = _getDate(map[HorsesTable.heat]);

    var rawSex = map[HorsesTable.sex];
    Sex sex = rawSex is int
        ? Sex.values[rawSex]
        : rawSex is Sex
            ? rawSex
            : Sex.unknown;

    var rawHeight = map[HorsesTable.height];
    num height = rawHeight is num
        ? rawHeight
        : rawHeight is String
            ? num.parse(rawHeight)
            : 0;

    var rawPhoto = map[HorsesTable.photo];
    Uint8List? photo =
        rawPhoto is Uint8List && rawPhoto.isNotEmpty ? rawPhoto : null;

    var rawRegistrationNumber = map[HorsesTable.registrationNumber];
    String? registrationNumber =
        rawRegistrationNumber is String ? rawRegistrationNumber : null;

    return Horse(
      registrationName: map[HorsesTable.registrationName] as String,
      registrationNumber: registrationNumber,
      dateOfBirth: dob,
      sex: sex,
      sireRegistrationName: _valOr(map, HorsesTable.sireRegistrationName, ''),
      damRegistrationName: _valOr(map, HorsesTable.damRegistrationName, ''),
      name: map[HorsesTable.name] as String,
      height: height,
      photo: photo,
      heat: heat,
    );
  }

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      HorsesTable.registrationName: registrationName,
      HorsesTable.registrationNumber: registrationNumber,
      HorsesTable.sireRegistrationName: sireRegistrationName,
      HorsesTable.damRegistrationName: damRegistrationName,
      HorsesTable.name: name,
      HorsesTable.sex: sex.index,
      HorsesTable.dateOfBirth: dateTimeToInt(dateOfBirth),
      HorsesTable.height: height,
      HorsesTable.photo: photo ?? Uint8List(0),
      HorsesTable.heat: heat != null ? dateTimeToInt(heat!) : null,
    };
    return map;
  }

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

  void setHeatDateFromPregnancy(DateTime date) {
    heat = date.add(const Duration(days: 6));
  }
}
