import './horse.dart';
import '../db.dart';

class EventType {
  static const String drench = "drench";
  static const String farrier = "farrier";
  static const String miteTreatment = "miteTreatment";
  static const String dentist = "dentist";
  static const String foaling = "foaling";
  static const String feed = "feed";
  static const String vet = "vet";
  static const String pregnancyScans = "pregnancyScan";

  static const order = [
    drench,
    farrier,
    miteTreatment,
    dentist,
    foaling,
    feed,
    vet,
    pregnancyScans
  ];
}

Event createEventFromMap(Map<String, Object?> map, Horse h,
    {String? eventType}) {
  switch (eventType ?? map[EventsTable.type] as String) {
    case EventType.drench:
      return DrenchEvent.fromMap(map, h);
    case EventType.farrier:
      return FarrierEvent.fromMap(map, h);
    case EventType.miteTreatment:
      return MiteTreatmentEvent.fromMap(map, h);
    case EventType.dentist:
      return DentistEvent.fromMap(map, h);
    case EventType.foaling:
      return FoalingEvent.fromMap(map, h);
    case EventType.feed:
      return FeedEvent.fromMap(map, h);
    case EventType.vet:
      return VetEvent.fromMap(map, h);
    case EventType.pregnancyScans:
      return PregnancyScans.fromMap(map, h);
    default:
      throw Exception("Unknown event type: ${map[EventsTable.type]}");
  }
}

abstract class Event {
  int id = -1;
  DateTime date = DateTime.now();
  Horse horse;
  String notes = '';

  String get type;

  Event._fromMap(Map<String, Object?> map, this.horse) {
    var rawDate = map[EventsTable.date];
    date = rawDate is int
        ? intToDateTime(rawDate)
        : rawDate is DateTime
            ? rawDate
            : DateTime.now();

    var rawNotes = map[EventsTable.notes];
    notes = rawNotes is String ? rawNotes : '';

    var rawId = map[EventsTable.id];
    id = rawId is int ? rawId : -1;
  }

  Map<String, Object?> toMap() {
    return <String, Object?>{
      EventsTable.id: id >= 0 ? id : null,
      EventsTable.date: dateTimeToInt(date),
      EventsTable.horseRegistrationName: horse.registrationName,
      EventsTable.notes: notes,
      EventsTable.type: type
    };
  }
}

class DrenchEvent extends Event {
  String drenchType;

  DrenchEvent._fromMap(Map<String, Object?> map, horse, this.drenchType)
      : super._fromMap(map, horse);

  factory DrenchEvent.fromMap(Map<String, Object?> map, horse) {
    var rawDrenchType = map[EventsTable.drench_type];
    String drenchType = rawDrenchType is String ? rawDrenchType : '';

    return DrenchEvent._fromMap(map, horse, drenchType);
  }

  @override
  Map<String, Object?> toMap() {
    var m = super.toMap();
    m[EventsTable.drench_type] = drenchType;
    return m;
  }

  @override
  String get type => EventType.drench;
}

//
// FarrierEvent
//
class FarrierEvent extends Event {
  FarrierEvent.fromMap(Map<String, Object?> map, horse)
      : super._fromMap(map, horse);

  @override
  String get type => EventType.farrier;
}

//
// MiteTreatmentEvent
//
class MiteTreatmentEvent extends Event {
  String miteTreatmentType;

  @override
  String get type => EventType.miteTreatment;

  MiteTreatmentEvent._fromMap(
      Map<String, Object?> map, horse, this.miteTreatmentType)
      : super._fromMap(map, horse);
  factory MiteTreatmentEvent.fromMap(Map<String, Object?> map, horse) {
    var raw = map[EventsTable.miteTreatment_type];
    String miteTreatmentType = raw is String ? raw : '';

    return MiteTreatmentEvent._fromMap(map, horse, miteTreatmentType);
  }

  @override
  Map<String, Object?> toMap() {
    var m = super.toMap();
    m[EventsTable.miteTreatment_type] = miteTreatmentType;
    return m;
  }
}

//
// DentistEvent
//
class DentistEvent extends Event {
  DentistEvent.fromMap(Map<String, Object?> map, horse)
      : super._fromMap(map, horse);

  @override
  String get type => EventType.dentist;
}

class FoalingEvent extends Event {
  Sex foalSex;
  String foalColour;
  String sireRegistrationName;

  FoalingEvent._fromMap(Map<String, Object?> map, horse, this.foalColour,
      this.foalSex, this.sireRegistrationName)
      : super._fromMap(map, horse);

  factory FoalingEvent.fromMap(Map<String, Object?> map, horse) {
    var rawFoalSex = map[EventsTable.foaling_foalSex];
    Sex foalSex = rawFoalSex is int
        ? Sex.values[rawFoalSex]
        : rawFoalSex is Sex
            ? rawFoalSex
            : Sex.unknown;

    var rawFoalColour = map[EventsTable.foaling_foalColour];
    String foalColour = rawFoalColour is String ? rawFoalColour : '';

    var rawSireRegistrationName = map[EventsTable.sireRegistrationName];
    String sireRegistrationName =
        rawSireRegistrationName is String ? rawSireRegistrationName : '';

    return FoalingEvent._fromMap(
        map, horse, foalColour, foalSex, sireRegistrationName);
  }

  @override
  Map<String, Object?> toMap() {
    var m = super.toMap();
    m[EventsTable.foaling_foalSex] = foalSex.index;
    m[EventsTable.foaling_foalColour] = foalColour;
    m[EventsTable.sireRegistrationName] = sireRegistrationName;

    return m;
  }

  @override
  String get type => EventType.foaling;
}

class FeedEvent extends Event {
  @override
  String get type => EventType.feed;

  @override
  FeedEvent.fromMap(Map<String, Object?> map, Horse horse)
      : super._fromMap(map, horse);
}

class VetEvent extends Event {
  @override
  String get type => EventType.vet;

  @override
  VetEvent.fromMap(Map<String, Object?> map, horse)
      : super._fromMap(map, horse);
}

class PregnancyScans extends Event {
  bool inFoal;
  int? numberOfDays;
  String? sireRegistrationName;

  @override
  String get type => EventType.pregnancyScans;

  PregnancyScans._fromMap(
    Map<String, Object?> map,
    horse,
    this.inFoal,
    this.numberOfDays,
    this.sireRegistrationName,
  ) : super._fromMap(map, horse);

  factory PregnancyScans.fromMap(Map<String, Object?> map, horse) {
    var rawInFoal = map[EventsTable.pregnancy_inFoal];
    bool inFoal = rawInFoal is bool
        ? rawInFoal
        : rawInFoal is int
            ? rawInFoal > 0
            : false;

    var rawNumberOfDays = map[EventsTable.pregnancy_numDays];
    int? numberOfDays = rawNumberOfDays is String
        ? int.parse(rawNumberOfDays)
        : rawNumberOfDays is int
            ? rawNumberOfDays
            : null;

    var rawSireRegistrationName = map[EventsTable.sireRegistrationName];
    String? sireRegistrationName =
        rawSireRegistrationName is String ? rawSireRegistrationName : null;

    return PregnancyScans._fromMap(
        map, horse, inFoal, numberOfDays, sireRegistrationName);
  }

  @override
  Map<String, Object?> toMap() {
    var m = super.toMap();
    m[EventsTable.pregnancy_inFoal] = inFoal ? 1 : 0;
    m[EventsTable.pregnancy_numDays] = numberOfDays;
    m[EventsTable.sireRegistrationName] = sireRegistrationName;
    return m;
  }
}
