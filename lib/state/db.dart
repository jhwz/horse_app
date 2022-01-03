import 'dart:io';
import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:horse_app/utils/utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'db.g.dart';
part 'horse_ext.dart';
part 'event_ext.dart';

enum Sex { unknown, male, female }

extension SexString on Sex {
  static const List<String> mapping = ["Unknown", "Male", "Female"];

  String toSexString() => mapping[index];
}

class Horses extends Table {
  TextColumn get registrationName => text()();
  TextColumn get registrationNumber => text().nullable()();
  TextColumn get sireRegistrationName => text().nullable()();
  TextColumn get damRegistrationName => text().nullable()();
  TextColumn get name => text()();
  IntColumn get sex => intEnum<Sex>()();
  DateTimeColumn get dateOfBirth => dateTime()();
  RealColumn get height => real().nullable()();
  BlobColumn get photo => blob().nullable()();
  DateTimeColumn get heatCycleStart => dateTime().nullable()();
  TextColumn get notes => text().nullable()();

  IntColumn get owner =>
      integer().nullable().customConstraint('NULLABLE REFERENCES owners(id)')();
  IntColumn get breeder =>
      integer().nullable().customConstraint('NULLABLE REFERENCES owners(id)')();

  @override
  Set<Column> get primaryKey => {registrationName};
}

class Events extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get type => text()();
  TextColumn get registrationName => text()
      .customConstraint('NOT NULL REFERENCES horses(registration_name)')();
  DateTimeColumn get date => dateTime().clientDefault(() => DateTime.now())();
  TextColumn get notes => text().nullable()();
  TextColumn get extra => text().map(const JSONConverter()).nullable()();
}

class Owner extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get address => text().nullable()();
}

// composed rows on joins
class EventHorse extends Event {
  final Horse horse;
  EventHorse(this.horse, Event event)
      : super(
          date: event.date,
          type: event.type,
          notes: event.notes,
          id: event.id,
          registrationName: event.registrationName,
          extra: event.extra,
        );
}

class JSONConverter extends TypeConverter<Map<String, dynamic>, String> {
  const JSONConverter();
  @override
  Map<String, dynamic>? mapToDart(String? fromDb) =>
      fromDb != null ? json.decode(fromDb) : null;

  @override
  String mapToSql(Map<String, dynamic>? value) => json.encode(value);
}

late AppDb db;

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'app.db'));
    // file.delete();
    return NativeDatabase(file);
  });
}

@DriftDatabase(tables: [Events, Horses])
class AppDb extends _$AppDb {
  AppDb() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // *******************
  // Horse queries
  // *******************
  Future<void> createHorse(Insertable<Horse> h) async {
    await into(horses).insert(h);
  }

  Future<void> updateHorse(Insertable<Horse> h) async {
    await update(horses).replace(h);
  }

  Future<void> deleteHorse(String registrationName) async {
    return transaction(() async {
      await (delete(horses)
            ..where((tbl) => tbl.registrationName.equals(registrationName)))
          .go();

      await (delete(events)
            ..where((tbl) => tbl.registrationName.equals(registrationName)))
          .go();
    });
  }

  Future<List<Horse>> listHorses({
    String filter = '',
    int limit = 10,
    int offset = 0,
    DateTime? before,
    Sex? sex,
  }) async {
    return (select(horses)
          ..where((tbl) {
            final whereList = <Expression<bool?>>[
              tbl.registrationName.contains(filter) | tbl.name.contains(filter),
              if (before != null) tbl.dateOfBirth.isSmallerThanValue(before),
              if (sex != null) tbl.sex.equalsValue(sex),
            ];
            return whereList.reduce((clause, condition) => clause & condition);
          })
          ..limit(limit, offset: offset))
        .get();
  }

  Future<Horse> getHorse(String registrationName) async {
    return (select(horses)
          ..where((tbl) => tbl.registrationName.equals(registrationName)))
        .getSingle();
  }

  Future<List<Horse>> getHorseOffspring(String registrationName) async {
    return (select(horses)
          ..where((tbl) =>
              tbl.sireRegistrationName.equals(registrationName) |
              tbl.damRegistrationName.equals(registrationName)))
        .get();
  }

  // *******************
  // Event queries
  // *******************

  Future<List<EventHorse>> listEvents(
      {String filter = '',
      int limit = 10,
      int offset = 0,
      required DateTime now}) async {
    var eventQuery = (select(events)
          ..where((tbl) =>
              // past events
              (tbl.date.isSmallerOrEqualValue(now)) &
              // where the filter matches some key fields
              (tbl.registrationName.contains(filter) |
                  tbl.type.contains(filter) |
                  tbl.notes.contains(filter)))
          ..limit(limit, offset: offset)
          ..orderBy([
            (t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)
          ]))
        .join([
      leftOuterJoin(
          horses, horses.registrationName.equalsExp(events.registrationName)),
    ]);

    return eventQuery.map((row) {
      return EventHorse(
        row.readTable(horses),
        row.readTable(events),
      );
    }).get();
  }

  Future<void> createEvent(Insertable<Event> e) async {
    await into(events).insert(e);
  }
}
