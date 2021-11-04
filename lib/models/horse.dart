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

  // name to refer to the horse by
  String name;

  // gender of the horse
  Sex sex;

  // hands unit
  num height;

  DateTime dateOfBirth;

  Uint8List? photo;

  Horse(this.registrationName, this.dateOfBirth, this.sex,
      {this.name = '', this.registrationNumber, this.height = 0, this.photo}) {
    if (name == '') {
      name = registrationName;
    }
  }

  factory Horse.fromMap(Map<String, Object?> map) {
    var rawDob = map[HorsesTable.dateOfBirth];
    DateTime dob = rawDob is int
        ? intToDateTime(rawDob)
        : rawDob is String
            ? DateTime.parse(rawDob)
            : rawDob is DateTime
                ? rawDob
                : DateTime.now();

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
        rawPhoto != null && rawPhoto is Uint8List && rawPhoto.isNotEmpty
            ? rawPhoto
            : null;

    var rawRegistrationNumber = map[HorsesTable.registrationNumber];
    String? registrationNumber =
        rawRegistrationNumber is String ? rawRegistrationNumber : null;

    return Horse(
      map[HorsesTable.registrationName] as String,
      dob,
      sex,
      registrationNumber: registrationNumber,
      name: map[HorsesTable.name] as String,
      height: height,
      photo: photo,
    );
  }

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      HorsesTable.registrationName: registrationName,
      HorsesTable.registrationNumber: registrationNumber,
      HorsesTable.name: name,
      HorsesTable.sex: sex.index,
      HorsesTable.dateOfBirth: dateTimeToInt(dateOfBirth),
      HorsesTable.height: height,
      HorsesTable.photo: photo ?? Uint8List(0),
    };
    return map;
  }
}
