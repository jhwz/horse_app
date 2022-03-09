import 'dart:io';
import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
// import 'package:flutter/material.dart';
import 'package:horse_app/utils/utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

part 'db.g.dart';
part 'horse_ext.dart';
part 'event_ext.dart';

enum Sex { unknown, stallion, mare, gelding, filly, colt }

extension SexString on Sex {
  static const List<String> mapping = [
    "Unknown",
    "Stallion",
    "Mare",
    "Gelding",
    "Filly",
    "Colt"
  ];

  String toSexString() => mapping[index];
}

class Horses extends Table {
  // Registration name. Currently required but that restriction may
  // be removed soon.
  TextColumn get registrationName => text()();

  // Registration number as issued by a breed society.
  TextColumn get registrationNumber => text().nullable()();

  // Name of the horses sire or dam.
  TextColumn get sireRegistrationName => text().nullable()();
  TextColumn get damRegistrationName => text().nullable()();

  // The paddock name of the horse, this will be used to display
  // the horse in the application
  TextColumn get name => text()();

  // Sex of the horse, see the sex enum.
  // As a special case, we support marking horses and fillies/colts
  // which may be automatically updated later on, but for now
  // users will need to manually update that themselves
  IntColumn get sex => intEnum<Sex>()();

  // Optional date of birth. The accuracy can be from a year of birth
  // all the way down to the second
  DateTimeColumn get dateOfBirth => dateTime()();

  // Height of the horse. This is stored in millimeters, but will be
  // displayed in the application according to the users preference.
  RealColumn get height => real().nullable()();

  // Weight range of the horse, we may not always know the exact weight
  // so this allows us to store the range. If the horses weight is exact,
  // then minWeight == maxWeight
  RealColumn get minWeight => real().nullable()();
  RealColumn get maxWeight => real().nullable()();

  // Optional blob containing the profile of the horse. May extend to having
  // a gallery of images for each horse.
  IntColumn get profilePhoto =>
      integer().nullable().customConstraint("NULLABLE REFERENCES owners(id)")();

  // Time when the heatcycle starts for a mare. From this starting point we
  // can estimate whether or not a mare is in heat.
  // This field will always be null for other sexes
  DateTimeColumn get heatCycleStart => dateTime().nullable()();

  // General notes a user may want to keep on a horse regarding anything they
  // want. Might be nice to support commonmark in the future for better display
  // of their notes (not a lot of horsey people will know how to use markdown but
  // maybe a fancy editor can make that work for them)
  TextColumn get notes => text().nullable()();

  // May be null if unknown. This is the UUID of the current owner of the horse.
  TextColumn get owner =>
      text().nullable().customConstraint('NULLABLE REFERENCES owners(id)')();

  // May be null if unknown. This is the UUID of the owner who originally breed
  // the horse.
  TextColumn get breeder =>
      text().nullable().customConstraint('NULLABLE REFERENCES owners(id)')();

  @override
  Set<Column> get primaryKey => {registrationName};
}

class Events extends Table {
  // We create and manage the events internally so can use autoincrement
  IntColumn get id => integer().autoIncrement()();

  // Type of event, allows us to easily add new events later on
  TextColumn get type => text()();

  // Each event applies to exactly one horse, this references the foriegn key
  // for the horse that applies to this event. This will always be non-null.
  TextColumn get registrationName => text()
      .customConstraint('NOT NULL REFERENCES horses(registration_name)')();

  // The time this event occurred at.
  DateTimeColumn get date => dateTime().clientDefault(() => DateTime.now())();

  // Any extra notes that the user may want to write about the event.
  TextColumn get notes => text().nullable()();

  // Some events have additional metadata that only they understand and
  // know about. This metadata is stored in JSON format because there is no
  // way to generically index and use the data. If one of those events wishes
  // to filter on the metadata we will need to fetch all events (or incrementally
  // fetch them) and then filter in-memory.
  // This feels cleaner than having massive amount of nullable columns.
  TextColumn get extra => text().map(const JSONConverter()).nullable()();
}

class Owners extends Table {
  // Generated UUID
  TextColumn get id => text()();

  // Display name
  TextColumn get name => text().nullable()();

  // Email address
  TextColumn get email => text().nullable()();

  // Phone number, stored as a string to accomadate international
  // numbers
  TextColumn get phone => text().nullable()();

  // Address line 1
  TextColumn get address => text().nullable()();

  // The town/city of the address
  TextColumn get city => text().nullable()();

  // The national region they live in
  TextColumn get region => text().nullable()();

  // Their national postcode
  IntColumn get postcode => integer().nullable()();

  // The country code as a two letter ISO 3166-1 alpha-2 code
  // See https://www.iban.com/country-codes for a reference
  TextColumn get country => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class HorseGallery extends Table {
  @override
  String get tableName => "horse_gallery";

  IntColumn get id => integer().autoIncrement()();

  TextColumn get registrationName => text()
      .customConstraint('NOT NULL REFERENCES horses(registration_name)')();

  // Optional blob containing the profile of the horse. May extend to having
  // a gallery of images for each horse.
  BlobColumn get photo => blob()();
}

class EventGallery extends Table {
  @override
  String get tableName => "event_gallery";

  IntColumn get id => integer().autoIncrement()();

  IntColumn get eventID =>
      integer().customConstraint('NOT NULL REFERENCES events(id)')();

  // Optional blob containing the profile of the horse. May extend to having
  // a gallery of images for each horse.
  BlobColumn get photo => blob()();
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

@DriftDatabase(tables: [Events, Horses, Owners, HorseGallery, EventGallery])
class AppDb extends _$AppDb {
  static const uuidPrefsKey = "user_uuid";
  final SharedPreferences prefs;
  late final String uuid;

  AppDb({required this.prefs}) : super(_openConnection()) {
    final uuidFromPrefs = prefs.getString(uuidPrefsKey);
    if (uuidFromPrefs != null) {
      uuid = uuidFromPrefs;
    }
  }

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          // Create all the tables
          await m.createAll();
        },
        onUpgrade: (m, from, to) async {
          if (to != schemaVersion) {
            throw Exception('unsupported migration');
          }
          if (to < from) {
            throw Exception('downgrades not supported');
          }

          if (from < 2) {
            // Add the owners table
            await m.createTable(owners);

            // Cast the owner and breeders columns to text type now
            // we are using UUIDs
            await m.alterTable(TableMigration(
              horses,
              columnTransformer: {
                horses.owner: horses.owner.cast<String>(),
                horses.breeder: horses.breeder.cast<String>(),
              },
              newColumns: [horses.minWeight, horses.maxWeight],
            ));

            // Add an empty owner entry to the
            // database for this user.
            uuid = const Uuid().v4();
            await createOwner(Owner(id: uuid));
            await prefs.setString(uuidPrefsKey, uuid);

            // update all the horses to point at that owner
            await transaction(() async {
              await update(horses).write(HorsesCompanion(owner: Value(uuid)));
            });
          }

          await m.recreateAllViews();
        },
        beforeOpen: (details) async {
          if (details.wasCreated) {
            // Add an empty owner entry to the
            // database for this user.
            uuid = const Uuid().v4();
            await createOwner(Owner(id: uuid));
            await prefs.setString(uuidPrefsKey, uuid);
          }
        },
      );

  // *******************
  // Horse queries
  // *******************
  createHorse(Insertable<Horse> h) async {
    await into(horses).insert(h);
  }

  updateHorse(Insertable<Horse> h) async {
    await update(horses).replace(h);
  }

  deleteHorse(String registrationName) async {
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
    List<Sex>? sex,
  }) async {
    Iterable<int?>? sexIter;
    if (sex != null) {
      sexIter = List<int>.from(sex);
    }

    return (select(horses)
          ..where((tbl) {
            final whereList = <Expression<bool?>>[
              tbl.registrationName.contains(filter) | tbl.name.contains(filter),
              if (before != null) tbl.dateOfBirth.isSmallerThanValue(before),
              if (sexIter != null) tbl.sex.isIn(sexIter),
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

  createEvent(Insertable<Event> e) async {
    await into(events).insert(e);
  }

  deleteEvent(int eventID) async {
    await delete(events).delete(EventsCompanion(id: Value(eventID)));
  }

  // *******************
  // Owner queries
  // *******************
  createOwner(Insertable<Owner> owner) async {
    await into(owners).insert(owner);
  }
}
