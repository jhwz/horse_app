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
  // generated id
  TextColumn get id => text()();

  // Registration name. Currently required but that restriction may
  // be removed soon.
  TextColumn get registrationName => text().nullable()();

  // Registration number as issued by a breed society.
  TextColumn get registrationNumber => text().nullable()();

  // Name of the horses sire or dam.
  TextColumn get sireID => text().nullable()();
  TextColumn get damID => text().nullable()();

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
  Set<Column> get primaryKey => {id};
}

class Events extends Table {
  // We create and manage the events internally so can use autoincrement
  IntColumn get id => integer().autoIncrement()();

  // Type of event, allows us to easily add new events later on
  TextColumn get type => text()();

  // Each event applies to exactly one horse, this references the foriegn key
  // for the horse that applies to this event. This will always be non-null.
  TextColumn get horseID => text()();

  // The time this event occurred at.
  DateTimeColumn get date => dateTime().clientDefault(() => DateTime.now())();

  // Allows us to associate a cost with an event so we are able to
  // give estimates for the costs of looking after different horses.
  RealColumn get cost => real().nullable()();

  // Any extra notes that the user may want to write about the event.
  TextColumn get notes => text().nullable()();

  // references a list of images associated with this event.
  TextColumn get images => text().map(const IntArrayConverter()).nullable()();

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
  String get tableName => "horseGallery";

  IntColumn get id => integer().autoIncrement()();

  TextColumn get horseID => text()();

  // Optional blob containing the profile of the horse. May extend to having
  // a gallery of images for each horse.
  BlobColumn get photo => blob()();
}

class EventGallery extends Table {
  @override
  String get tableName => "eventGallery";

  IntColumn get id => integer().autoIncrement()();

  // Optional blob containing the profile of the horse. May extend to having
  // a gallery of images for each horse.
  BlobColumn get photo => blob()();
}

// composed rows on joins
class EventHorse {
  final Horse horse;
  final Event meta;
  EventHorse(this.horse, this.meta);
}

class JSONConverter extends TypeConverter<Map<String, dynamic>, String> {
  const JSONConverter();
  @override
  Map<String, dynamic>? mapToDart(String? fromDb) =>
      fromDb != null ? json.decode(fromDb) : null;

  @override
  String mapToSql(Map<String, dynamic>? value) => json.encode(value);
}

class IntArrayConverter extends TypeConverter<List<int>, String> {
  const IntArrayConverter();
  @override
  List<int>? mapToDart(String? fromDb) =>
      fromDb?.split(",").map(int.parse).toList();

  @override
  String mapToSql(List<int>? value) => value?.join(",") ?? "";
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
        // This is the default onCreate logic, better to add data in beforeOpen
        onCreate: (m) async => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (to != schemaVersion) {
            throw Exception('unsupported migration');
          }
          if (to < from) {
            throw Exception('downgrades not supported');
          }
          print("running migration from $from to $to");

          if (from < 2) {
            await v1tov2(m);
          }

          await m.recreateAllViews();
        },
        beforeOpen: (details) async {
          if (details.wasCreated) {
            await safeSetOwner();
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
    await (update(horses)..whereSamePrimaryKey(h)).write(h);
  }

  deleteHorse(String id) async {
    return transaction(() async {
      // remove the horse
      await (delete(horses)..where((tbl) => tbl.id.equals(id))).go();

      // remove any images we have stored
      await (delete(horseGallery)..where((tbl) => tbl.horseID.equals(id))).go();

      // delete the events
      await (delete(events)..where((tbl) => tbl.horseID.equals(id))).go();
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
      sexIter = sex.map((s) => s.index);
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

  Future<Horse> getHorse(String id) async {
    return (select(horses)..where((tbl) => tbl.id.equals(id))).getSingle();
  }

  Future<List<Horse>> getHorseOffspring(String id) async {
    return (select(horses)
          ..where((tbl) => tbl.sireID.equals(id) | tbl.damID.equals(id)))
        .get();
  }

  Future<List<HorseGalleryData>> getHorseImages({
    required String horseID,
    int offset = 0,
    int limit = 10,
  }) async {
    final vals = await (select(horseGallery)
          ..where((tbl) => tbl.horseID.equals(horseID))
          ..limit(limit, offset: offset))
        .get();
    return vals;
  }

  Future<HorseGalleryData> addHorseImage({
    required String horseID,
    required Uint8List photo,
  }) async {
    final val = await into(horseGallery).insertReturning(HorseGalleryCompanion(
      horseID: Value(horseID),
      photo: Value(photo),
    ));
    return val;
  }

  removeHorseImage({
    required int id,
  }) async {
    await delete(horseGallery).delete(HorseGalleryCompanion(id: Value(id)));
  }

  Future<Uint8List?> getHorseProfilePicture(Horse h) async {
    if (h.profilePhoto == null) {
      return null;
    }

    final data = await (select(horseGallery)
          ..whereSamePrimaryKey(
              HorseGalleryCompanion(id: Value(h.profilePhoto!))))
        .getSingleOrNull();
    return data?.photo;
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
          ..where((tbl) => tbl.date.isSmallerOrEqualValue(now))
          ..orderBy([
            (t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)
          ]))
        .join([
      leftOuterJoin(horses, horses.id.equalsExp(events.horseID)),
    ]);

    eventQuery
      ..where(horses.name.contains(filter) |
          horses.registrationName.contains(filter) |
          events.type.contains(filter))
      ..limit(limit, offset: offset);

    return eventQuery.map((row) {
      return EventHorse(
        row.readTable(horses),
        row.readTable(events),
      );
    }).get();
  }

  Future<List<EventHorse>> fetchEvents(List<int> eventIDs) async {
    var eventQuery =
        (select(events)..where((tbl) => tbl.id.isIn(eventIDs))).join([
      leftOuterJoin(horses, horses.id.equalsExp(events.horseID)),
    ]);
    return eventQuery.map((row) {
      return EventHorse(
        row.readTable(horses),
        row.readTable(events),
      );
    }).get();
  }

  Future<int> createEvent(Insertable<Event> e) async {
    return await into(events).insert(e);
  }

  updateEvent(Insertable<Event> e) async {
    await (update(events)..whereSamePrimaryKey(e)).write(e);
  }

  deleteEvent(int eventID) async {
    await transaction(() async {
      await delete(events).delete(EventsCompanion(id: Value(eventID)));
    });
  }

  Future<Event?> lastEventOfTypeForHorse(
      String eventType, String horseID) async {
    final now = DateTime.now();

    return (select(events)
          ..where((tbl) =>
              // past events
              (tbl.date.isSmallerOrEqualValue(now)) &
              // where the filter matches some key fields
              (tbl.type.equals(eventType) & tbl.horseID.equals(horseID)))
          ..limit(1)
          ..orderBy([
            (t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)
          ]))
        .getSingleOrNull();
  }

  Future<EventGalleryData> addEventPhoto({required Uint8List photo}) {
    return into(eventGallery)
        .insertReturning(EventGalleryCompanion(photo: Value(photo)));
  }

  Future<List<EventGalleryData>> getEventPhotos({required List<int> ids}) {
    return (select(eventGallery)..where((tbl) => tbl.id.isIn(ids))).get();
  }

  // *******************
  // Owner queries
  // *******************
  createOwner(Insertable<Owner> owner) async {
    await into(owners).insert(owner);
  }

  Future<Owner?> getOwner(String uuid) async {
    await (select(owners)
          ..whereSamePrimaryKey(OwnersCompanion(id: Value(uuid))))
        .getSingleOrNull();
  }

  // *******************
  // MIGRATIONS
  // *******************

  safeSetOwner() async {
    // Add an empty owner entry to the
    // database for this user.
    if (!prefs.containsKey(uuidPrefsKey)) {
      uuid = const Uuid().v4();
      await prefs.setString(uuidPrefsKey, uuid);
    }
    if ((await getOwner(uuid)) == null) {
      await createOwner(Owner(id: uuid));
    }
  }

  v1tov2(Migrator m) async {
    await transaction(() async {
      // Add the new tables
      await m.createTable(owners);
      await m.createTable(eventGallery);
      await m.createTable(horseGallery);

      print("selecting existing data");
      // Get the existing photo from each horse and add it to
      // the horse gallery. Then get the id for each of those photos
      // and set them as the horse's photo.
      final rows = await customSelect(
              "SELECT photo, registration_name, sire_registration_name, dam_registration_name FROM horses")
          .get();

      List<HorseGalleryData> horseGalleryData = [];
      Map<String, String> registrationToUUID = {};
      Map<String, String?> uuidToSireRegistration = {};
      Map<String, String?> uuidToDamRegistration = {};

      print("creating mapping");
      for (var row in rows) {
        final newID = const Uuid().v4();
        final registrationName = row.read<String>("registration_name");
        registrationToUUID[registrationName] = newID;
        uuidToSireRegistration[newID] =
            row.read<String?>("sire_registration_name");
        uuidToDamRegistration[newID] =
            row.read<String?>("dam_registration_name");
        final photo = row.read<Uint8List?>("photo");
        if (photo == null) {
          continue;
        }
        horseGalleryData.add(
          HorseGalleryData(
            id: horseGalleryData.length,
            horseID: newID,
            photo: photo,
          ),
        );
        await into(horseGallery).insert(horseGalleryData.last);
      }

      print("fetching existing events");
      final eventRows =
          await customSelect("SELECT id, registration_name FROM events").get();
      Map<int, String> eventToRegistration = {};
      for (var row in eventRows) {
        final eventID = row.read<int>("id");
        final registrationName = row.read<String>("registration_name");
        eventToRegistration[eventID] = registrationName;
      }

      print("altering horse table");
      // Cast the owner and breeders columns to text type now
      // we are using UUIDs
      await m.alterTable(TableMigration(
        horses,
        columnTransformer: {
          horses.owner: horses.owner.cast<String>(),
          horses.breeder: horses.breeder.cast<String>(),
          horses.id: horses.registrationName
        },
        newColumns: [
          horses.id,
          horses.minWeight,
          horses.maxWeight,
          horses.profilePhoto,
          horses.sireID,
          horses.damID,
        ],
      ));

      print("altering event table");
      // update the events table to use UUIDs
      await m.alterTable(TableMigration(
        events,
        newColumns: [
          events.horseID,
          events.cost,
          events.images,
        ],
        columnTransformer: {
          events.horseID: const CustomExpression("registration_name")
        },
      ));

      print("creating new owner");
      await safeSetOwner();

      print("inserting existing data into new tables");
      // update the horses table and the events table
      for (final e in registrationToUUID.entries) {
        Value<int> profilePhotoValue = const Value.absent();
        final galleryData =
            horseGalleryData.where((data) => data.horseID == e.value).toList();
        if (galleryData.isNotEmpty) {
          profilePhotoValue = Value(galleryData.first.id);
        }

        await (update(horses)
              ..where((tbl) => tbl.registrationName.equals(e.key)))
            .write(HorsesCompanion(
                id: Value(e.value),
                minWeight: const Value(0),
                maxWeight: const Value(0),
                sireID: uuidToSireRegistration[e.value] != null
                    ? Value(
                        registrationToUUID[uuidToSireRegistration[e.value]!])
                    : const Value.absent(),
                damID: uuidToDamRegistration[e.value] != null
                    ? Value(registrationToUUID[uuidToDamRegistration[e.value]!])
                    : const Value.absent(),
                profilePhoto: profilePhotoValue,
                owner: Value(uuid)));
      }

      // update the events table
      for (final e in eventToRegistration.entries) {
        await (update(events)..where((tbl) => tbl.id.equals(e.key))).write(
            EventsCompanion(
                id: Value(e.key),
                horseID: Value(registrationToUUID[e.value]!)));
      }
    });
  }
}
