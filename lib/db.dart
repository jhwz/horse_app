import 'package:horse_app/_utils.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import './models/horse.dart';
import './models/event.dart';
import 'package:csv/csv.dart' as csv;

class Tables {
  static const String events = 'events';
  static const String horses = 'horses';
}

class EventsTable {
  static const String id = 'id';
  static const String horseRegistrationName = 'horseRegistrationName';
  static const String type = 'type';
  static const String date = 'date';
  static const String notes = 'notes';
  // ignore: constant_identifier_names
  static const String drench_type = 'drench_type';
  // ignore: constant_identifier_names
  static const String miteTreatment_type = 'miteTreatment_type';
  // ignore: constant_identifier_names
  static const String foaling_foalSex = 'foaling_foalSex';
  // ignore: constant_identifier_names
  static const String foaling_foalColour = 'foaling_foalColour';
  // ignore: constant_identifier_names
  static const String pregnancy_inFoal = 'pregnancy_inFoal';
  // ignore: constant_identifier_names
  static const String pregnancy_numDays = 'pregnancy_numDays';

  // used by Foaling and Pregnancy scan events
  // ignore: constant_identifier_names
  static const String sireRegistrationName = 'sireRegistrationName';

  static List<String> order = [
    id,
    horseRegistrationName,
    type,
    date,
    notes,
    drench_type,
    miteTreatment_type,
    foaling_foalSex,
    foaling_foalColour,
    sireRegistrationName,
  ];
}

String createEventsTable = '''
CREATE TABLE ${Tables.events} (
  ${EventsTable.id} INTEGER PRIMARY KEY AUTOINCREMENT,
  ${EventsTable.horseRegistrationName} TEXT,
  ${EventsTable.type} TEXT,
  ${EventsTable.date} INTEGER,
  ${EventsTable.notes} TEXT,
  ${EventsTable.drench_type} TEXT,
  ${EventsTable.miteTreatment_type} TEXT,
  ${EventsTable.foaling_foalSex} INTEGER,
  ${EventsTable.foaling_foalColour} TEXT,
  ${EventsTable.pregnancy_inFoal} INTEGER,
  ${EventsTable.pregnancy_numDays} INTEGER,
  ${EventsTable.sireRegistrationName} TEXT
);
''';

class HorsesTable {
  static const String registrationName = 'registrationName';
  static const String registrationNumber = 'registrationNumber';
  static const String name = 'name';
  static const String sex = 'sex';
  static const String height = 'height';
  static const String dateOfBirth = 'dateOfBirth';
  static const String photo = 'photo';

  static List<String> order = [
    registrationNumber,
    registrationName,
    name,
    sex,
    height,
    dateOfBirth
  ];
}

String createHorsesTable = '''
CREATE TABLE ${Tables.horses} (
  ${HorsesTable.registrationName} TEXT PRIMARY KEY,
  ${HorsesTable.registrationNumber} TEXT,
  ${HorsesTable.name} TEXT,
  ${HorsesTable.sex} INTEGER,
  ${HorsesTable.height} REAL,
  ${HorsesTable.dateOfBirth} INTEGER,
  ${HorsesTable.photo} BLOB
);
''';

class DB {
  DB._();
  static final DB db = DB._();

  late Database _database;

  static Future<void> init() async {
    String path = join(await getDatabasesPath(), 'app.db');

    deleteDatabase(path);
    db._database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(createHorsesTable);
      await db.execute(createEventsTable);
    });
  }

  static Future<void> createHorse(Horse h) async {
    await db._database.insert(Tables.horses, h.toMap(),
        conflictAlgorithm: ConflictAlgorithm.fail);
  }

  static Future<void> updateHorse(Horse h) async {
    await db._database.insert(
      Tables.horses,
      h.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> deleteHorse(Horse h) async {
    await db._database.delete(
      Tables.horses,
      where: '${HorsesTable.registrationName} LIKE ?',
      whereArgs: [h.registrationName],
    );
    await db._database.delete(
      Tables.events,
      where: '${EventsTable.horseRegistrationName} LIKE ?',
      whereArgs: [h.registrationName],
    );
  }

  static Future<List<Horse>> listHorses(
      {String filter = '', int page = 1, int? pageSize}) async {
    var l = await db._database.query(Tables.horses,
        where:
            '${HorsesTable.registrationName} LIKE ? OR ${HorsesTable.name} LIKE ?',
        whereArgs: ['%$filter%', '%$filter%'],
        orderBy: HorsesTable.registrationName,
        limit: pageSize,
        offset: pageSize != null ? (page - 1) * pageSize : null);
    return l.map((h) => Horse.fromMap(h)).toList();
  }

  static Future<Horse> getHorse(String regoName) async {
    var l = await db._database.query(
      Tables.horses,
      where: '${HorsesTable.registrationName} LIKE ?',
      whereArgs: [regoName],
      limit: 1,
    );
    if (l.isEmpty) throw Exception('Horse not found');
    return Horse.fromMap(l[0]);
  }

  // when searching for an event against text we will match on any of these fields.
  // the 'notes' field will be the most resource intensive
  static const eventSearchKeys = [
    EventsTable.notes,
    EventsTable.horseRegistrationName,
    EventsTable.type,
  ];

  static Future<List<Event>> listEvents(
      {String filter = '', int offset = 0, int? limit}) async {
    var l = await db._database.rawQuery('''
SELECT * FROM ${Tables.events}
WHERE ${eventSearchKeys.map((k) => '$k LIKE ?').join(' OR ')}
ORDER BY ${EventsTable.date} DESC
LIMIT ${limit ?? 10}
OFFSET $offset
''', eventSearchKeys.map((_) => '%$filter%').toList());

    List<String> horses = l
        .map((e) => e[EventsTable.horseRegistrationName] as String)
        .toSet()
        .toList();

    var l2 = await db._database.query(Tables.horses,
        where:
            '${HorsesTable.registrationName} IN (${horses.map((e) => '?').join(',')})',
        whereArgs: horses);

    Map<String, Horse> horsesMap = Map.fromIterable(
      l2.map((m) => Horse.fromMap(m)),
      key: (h) => h.registrationName,
    );

    return l
        .map((e) => createEventFromMap(
            e, horsesMap[e[EventsTable.horseRegistrationName]]!))
        .toList();
  }

  static Future<void> createEvent(Event e) async {
    await db._database.insert(Tables.events.toString(), e.toMap(),
        conflictAlgorithm: ConflictAlgorithm.fail);
  }

  static Future<Map<String, String>> exportToCSV() async {
    var horses = await db._database.query(Tables.horses);
    var events = await db._database.query(Tables.events);

    var horsesList =
        horses.map((h) => HorsesTable.order.map((e) => h[e]).toList()).toList();
    horsesList.insert(0, HorsesTable.order.map(formatStr).toList());
    var horsesCsv = const csv.ListToCsvConverter().convert(horsesList);

    var eventsList =
        events.map((h) => EventsTable.order.map((e) => h[e]).toList()).toList();
    eventsList.insert(0, EventsTable.order.map(formatStr).toList());
    var eventsCsv = const csv.ListToCsvConverter().convert(eventsList);

    return {
      Tables.horses: horsesCsv,
      Tables.events: eventsCsv,
    };
  }
}
