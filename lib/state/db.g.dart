// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class Event extends DataClass implements Insertable<Event> {
  final int id;
  final String type;
  final String registrationName;
  final DateTime date;
  final String? notes;
  final Map<String, dynamic>? extra;
  Event(
      {required this.id,
      required this.type,
      required this.registrationName,
      required this.date,
      this.notes,
      this.extra});
  factory Event.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Event(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      type: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}type'])!,
      registrationName: const StringType().mapFromDatabaseResponse(
          data['${effectivePrefix}registration_name'])!,
      date: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}date'])!,
      notes: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}notes']),
      extra: $EventsTable.$converter0.mapToDart(const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}extra'])),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['type'] = Variable<String>(type);
    map['registration_name'] = Variable<String>(registrationName);
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String?>(notes);
    }
    if (!nullToAbsent || extra != null) {
      final converter = $EventsTable.$converter0;
      map['extra'] = Variable<String?>(converter.mapToSql(extra));
    }
    return map;
  }

  EventsCompanion toCompanion(bool nullToAbsent) {
    return EventsCompanion(
      id: Value(id),
      type: Value(type),
      registrationName: Value(registrationName),
      date: Value(date),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      extra:
          extra == null && nullToAbsent ? const Value.absent() : Value(extra),
    );
  }

  factory Event.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Event(
      id: serializer.fromJson<int>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      registrationName: serializer.fromJson<String>(json['registrationName']),
      date: serializer.fromJson<DateTime>(json['date']),
      notes: serializer.fromJson<String?>(json['notes']),
      extra: serializer.fromJson<Map<String, dynamic>?>(json['extra']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'type': serializer.toJson<String>(type),
      'registrationName': serializer.toJson<String>(registrationName),
      'date': serializer.toJson<DateTime>(date),
      'notes': serializer.toJson<String?>(notes),
      'extra': serializer.toJson<Map<String, dynamic>?>(extra),
    };
  }

  Event copyWith(
          {int? id,
          String? type,
          String? registrationName,
          DateTime? date,
          Value<String?> notes = const Value.absent(),
          Value<Map<String, dynamic>?> extra = const Value.absent()}) =>
      Event(
        id: id ?? this.id,
        type: type ?? this.type,
        registrationName: registrationName ?? this.registrationName,
        date: date ?? this.date,
        notes: notes.present ? notes.value : this.notes,
        extra: extra.present ? extra.value : this.extra,
      );
  @override
  String toString() {
    return (StringBuffer('Event(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('registrationName: $registrationName, ')
          ..write('date: $date, ')
          ..write('notes: $notes, ')
          ..write('extra: $extra')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, type, registrationName, date, notes, extra);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Event &&
          other.id == this.id &&
          other.type == this.type &&
          other.registrationName == this.registrationName &&
          other.date == this.date &&
          other.notes == this.notes &&
          other.extra == this.extra);
}

class EventsCompanion extends UpdateCompanion<Event> {
  final Value<int> id;
  final Value<String> type;
  final Value<String> registrationName;
  final Value<DateTime> date;
  final Value<String?> notes;
  final Value<Map<String, dynamic>?> extra;
  const EventsCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.registrationName = const Value.absent(),
    this.date = const Value.absent(),
    this.notes = const Value.absent(),
    this.extra = const Value.absent(),
  });
  EventsCompanion.insert({
    this.id = const Value.absent(),
    required String type,
    required String registrationName,
    this.date = const Value.absent(),
    this.notes = const Value.absent(),
    this.extra = const Value.absent(),
  })  : type = Value(type),
        registrationName = Value(registrationName);
  static Insertable<Event> custom({
    Expression<int>? id,
    Expression<String>? type,
    Expression<String>? registrationName,
    Expression<DateTime>? date,
    Expression<String?>? notes,
    Expression<Map<String, dynamic>?>? extra,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (registrationName != null) 'registration_name': registrationName,
      if (date != null) 'date': date,
      if (notes != null) 'notes': notes,
      if (extra != null) 'extra': extra,
    });
  }

  EventsCompanion copyWith(
      {Value<int>? id,
      Value<String>? type,
      Value<String>? registrationName,
      Value<DateTime>? date,
      Value<String?>? notes,
      Value<Map<String, dynamic>?>? extra}) {
    return EventsCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      registrationName: registrationName ?? this.registrationName,
      date: date ?? this.date,
      notes: notes ?? this.notes,
      extra: extra ?? this.extra,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (registrationName.present) {
      map['registration_name'] = Variable<String>(registrationName.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String?>(notes.value);
    }
    if (extra.present) {
      final converter = $EventsTable.$converter0;
      map['extra'] = Variable<String?>(converter.mapToSql(extra.value));
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EventsCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('registrationName: $registrationName, ')
          ..write('date: $date, ')
          ..write('notes: $notes, ')
          ..write('extra: $extra')
          ..write(')'))
        .toString();
  }
}

class $EventsTable extends Events with TableInfo<$EventsTable, Event> {
  final GeneratedDatabase _db;
  final String? _alias;
  $EventsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _typeMeta = const VerificationMeta('type');
  late final GeneratedColumn<String?> type = GeneratedColumn<String?>(
      'type', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _registrationNameMeta =
      const VerificationMeta('registrationName');
  late final GeneratedColumn<String?> registrationName =
      GeneratedColumn<String?>('registration_name', aliasedName, false,
          typeName: 'TEXT',
          requiredDuringInsert: true,
          $customConstraints: 'NOT NULL REFERENCES horses(registration_name)');
  final VerificationMeta _dateMeta = const VerificationMeta('date');
  late final GeneratedColumn<DateTime?> date = GeneratedColumn<DateTime?>(
      'date', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  final VerificationMeta _notesMeta = const VerificationMeta('notes');
  late final GeneratedColumn<String?> notes = GeneratedColumn<String?>(
      'notes', aliasedName, true,
      typeName: 'TEXT', requiredDuringInsert: false);
  final VerificationMeta _extraMeta = const VerificationMeta('extra');
  late final GeneratedColumnWithTypeConverter<Map<String, dynamic>, String?>
      extra = GeneratedColumn<String?>('extra', aliasedName, true,
              typeName: 'TEXT', requiredDuringInsert: false)
          .withConverter<Map<String, dynamic>>($EventsTable.$converter0);
  @override
  List<GeneratedColumn> get $columns =>
      [id, type, registrationName, date, notes, extra];
  @override
  String get aliasedName => _alias ?? 'events';
  @override
  String get actualTableName => 'events';
  @override
  VerificationContext validateIntegrity(Insertable<Event> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('registration_name')) {
      context.handle(
          _registrationNameMeta,
          registrationName.isAcceptableOrUnknown(
              data['registration_name']!, _registrationNameMeta));
    } else if (isInserting) {
      context.missing(_registrationNameMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    context.handle(_extraMeta, const VerificationResult.success());
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Event map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Event.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $EventsTable createAlias(String alias) {
    return $EventsTable(_db, alias);
  }

  static TypeConverter<Map<String, dynamic>, String> $converter0 =
      const JSONConverter();
}

class Horse extends DataClass implements Insertable<Horse> {
  final String registrationName;
  final String? registrationNumber;
  final String? sireRegistrationName;
  final String? damRegistrationName;
  final String name;
  final Sex sex;
  final DateTime dateOfBirth;
  final double height;
  final Uint8List? photo;
  final DateTime? heatCycleStart;
  final String? notes;
  final int? owner;
  final int? breeder;
  Horse(
      {required this.registrationName,
      this.registrationNumber,
      this.sireRegistrationName,
      this.damRegistrationName,
      required this.name,
      required this.sex,
      required this.dateOfBirth,
      required this.height,
      this.photo,
      this.heatCycleStart,
      this.notes,
      this.owner,
      this.breeder});
  factory Horse.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Horse(
      registrationName: const StringType().mapFromDatabaseResponse(
          data['${effectivePrefix}registration_name'])!,
      registrationNumber: const StringType().mapFromDatabaseResponse(
          data['${effectivePrefix}registration_number']),
      sireRegistrationName: const StringType().mapFromDatabaseResponse(
          data['${effectivePrefix}sire_registration_name']),
      damRegistrationName: const StringType().mapFromDatabaseResponse(
          data['${effectivePrefix}dam_registration_name']),
      name: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}name'])!,
      sex: $HorsesTable.$converter0.mapToDart(const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}sex']))!,
      dateOfBirth: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}date_of_birth'])!,
      height: const RealType()
          .mapFromDatabaseResponse(data['${effectivePrefix}height'])!,
      photo: const BlobType()
          .mapFromDatabaseResponse(data['${effectivePrefix}photo']),
      heatCycleStart: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}heat_cycle_start']),
      notes: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}notes']),
      owner: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}owner']),
      breeder: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}breeder']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['registration_name'] = Variable<String>(registrationName);
    if (!nullToAbsent || registrationNumber != null) {
      map['registration_number'] = Variable<String?>(registrationNumber);
    }
    if (!nullToAbsent || sireRegistrationName != null) {
      map['sire_registration_name'] = Variable<String?>(sireRegistrationName);
    }
    if (!nullToAbsent || damRegistrationName != null) {
      map['dam_registration_name'] = Variable<String?>(damRegistrationName);
    }
    map['name'] = Variable<String>(name);
    {
      final converter = $HorsesTable.$converter0;
      map['sex'] = Variable<int>(converter.mapToSql(sex)!);
    }
    map['date_of_birth'] = Variable<DateTime>(dateOfBirth);
    map['height'] = Variable<double>(height);
    if (!nullToAbsent || photo != null) {
      map['photo'] = Variable<Uint8List?>(photo);
    }
    if (!nullToAbsent || heatCycleStart != null) {
      map['heat_cycle_start'] = Variable<DateTime?>(heatCycleStart);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String?>(notes);
    }
    if (!nullToAbsent || owner != null) {
      map['owner'] = Variable<int?>(owner);
    }
    if (!nullToAbsent || breeder != null) {
      map['breeder'] = Variable<int?>(breeder);
    }
    return map;
  }

  HorsesCompanion toCompanion(bool nullToAbsent) {
    return HorsesCompanion(
      registrationName: Value(registrationName),
      registrationNumber: registrationNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(registrationNumber),
      sireRegistrationName: sireRegistrationName == null && nullToAbsent
          ? const Value.absent()
          : Value(sireRegistrationName),
      damRegistrationName: damRegistrationName == null && nullToAbsent
          ? const Value.absent()
          : Value(damRegistrationName),
      name: Value(name),
      sex: Value(sex),
      dateOfBirth: Value(dateOfBirth),
      height: Value(height),
      photo:
          photo == null && nullToAbsent ? const Value.absent() : Value(photo),
      heatCycleStart: heatCycleStart == null && nullToAbsent
          ? const Value.absent()
          : Value(heatCycleStart),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      owner:
          owner == null && nullToAbsent ? const Value.absent() : Value(owner),
      breeder: breeder == null && nullToAbsent
          ? const Value.absent()
          : Value(breeder),
    );
  }

  factory Horse.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Horse(
      registrationName: serializer.fromJson<String>(json['registrationName']),
      registrationNumber:
          serializer.fromJson<String?>(json['registrationNumber']),
      sireRegistrationName:
          serializer.fromJson<String?>(json['sireRegistrationName']),
      damRegistrationName:
          serializer.fromJson<String?>(json['damRegistrationName']),
      name: serializer.fromJson<String>(json['name']),
      sex: serializer.fromJson<Sex>(json['sex']),
      dateOfBirth: serializer.fromJson<DateTime>(json['dateOfBirth']),
      height: serializer.fromJson<double>(json['height']),
      photo: serializer.fromJson<Uint8List?>(json['photo']),
      heatCycleStart: serializer.fromJson<DateTime?>(json['heatCycleStart']),
      notes: serializer.fromJson<String?>(json['notes']),
      owner: serializer.fromJson<int?>(json['owner']),
      breeder: serializer.fromJson<int?>(json['breeder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'registrationName': serializer.toJson<String>(registrationName),
      'registrationNumber': serializer.toJson<String?>(registrationNumber),
      'sireRegistrationName': serializer.toJson<String?>(sireRegistrationName),
      'damRegistrationName': serializer.toJson<String?>(damRegistrationName),
      'name': serializer.toJson<String>(name),
      'sex': serializer.toJson<Sex>(sex),
      'dateOfBirth': serializer.toJson<DateTime>(dateOfBirth),
      'height': serializer.toJson<double>(height),
      'photo': serializer.toJson<Uint8List?>(photo),
      'heatCycleStart': serializer.toJson<DateTime?>(heatCycleStart),
      'notes': serializer.toJson<String?>(notes),
      'owner': serializer.toJson<int?>(owner),
      'breeder': serializer.toJson<int?>(breeder),
    };
  }

  Horse copyWith(
          {String? registrationName,
          Value<String?> registrationNumber = const Value.absent(),
          Value<String?> sireRegistrationName = const Value.absent(),
          Value<String?> damRegistrationName = const Value.absent(),
          String? name,
          Sex? sex,
          DateTime? dateOfBirth,
          double? height,
          Value<Uint8List?> photo = const Value.absent(),
          Value<DateTime?> heatCycleStart = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          Value<int?> owner = const Value.absent(),
          Value<int?> breeder = const Value.absent()}) =>
      Horse(
        registrationName: registrationName ?? this.registrationName,
        registrationNumber: registrationNumber.present
            ? registrationNumber.value
            : this.registrationNumber,
        sireRegistrationName: sireRegistrationName.present
            ? sireRegistrationName.value
            : this.sireRegistrationName,
        damRegistrationName: damRegistrationName.present
            ? damRegistrationName.value
            : this.damRegistrationName,
        name: name ?? this.name,
        sex: sex ?? this.sex,
        dateOfBirth: dateOfBirth ?? this.dateOfBirth,
        height: height ?? this.height,
        photo: photo.present ? photo.value : this.photo,
        heatCycleStart:
            heatCycleStart.present ? heatCycleStart.value : this.heatCycleStart,
        notes: notes.present ? notes.value : this.notes,
        owner: owner.present ? owner.value : this.owner,
        breeder: breeder.present ? breeder.value : this.breeder,
      );
  @override
  String toString() {
    return (StringBuffer('Horse(')
          ..write('registrationName: $registrationName, ')
          ..write('registrationNumber: $registrationNumber, ')
          ..write('sireRegistrationName: $sireRegistrationName, ')
          ..write('damRegistrationName: $damRegistrationName, ')
          ..write('name: $name, ')
          ..write('sex: $sex, ')
          ..write('dateOfBirth: $dateOfBirth, ')
          ..write('height: $height, ')
          ..write('photo: $photo, ')
          ..write('heatCycleStart: $heatCycleStart, ')
          ..write('notes: $notes, ')
          ..write('owner: $owner, ')
          ..write('breeder: $breeder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      registrationName,
      registrationNumber,
      sireRegistrationName,
      damRegistrationName,
      name,
      sex,
      dateOfBirth,
      height,
      photo,
      heatCycleStart,
      notes,
      owner,
      breeder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Horse &&
          other.registrationName == this.registrationName &&
          other.registrationNumber == this.registrationNumber &&
          other.sireRegistrationName == this.sireRegistrationName &&
          other.damRegistrationName == this.damRegistrationName &&
          other.name == this.name &&
          other.sex == this.sex &&
          other.dateOfBirth == this.dateOfBirth &&
          other.height == this.height &&
          other.photo == this.photo &&
          other.heatCycleStart == this.heatCycleStart &&
          other.notes == this.notes &&
          other.owner == this.owner &&
          other.breeder == this.breeder);
}

class HorsesCompanion extends UpdateCompanion<Horse> {
  final Value<String> registrationName;
  final Value<String?> registrationNumber;
  final Value<String?> sireRegistrationName;
  final Value<String?> damRegistrationName;
  final Value<String> name;
  final Value<Sex> sex;
  final Value<DateTime> dateOfBirth;
  final Value<double> height;
  final Value<Uint8List?> photo;
  final Value<DateTime?> heatCycleStart;
  final Value<String?> notes;
  final Value<int?> owner;
  final Value<int?> breeder;
  const HorsesCompanion({
    this.registrationName = const Value.absent(),
    this.registrationNumber = const Value.absent(),
    this.sireRegistrationName = const Value.absent(),
    this.damRegistrationName = const Value.absent(),
    this.name = const Value.absent(),
    this.sex = const Value.absent(),
    this.dateOfBirth = const Value.absent(),
    this.height = const Value.absent(),
    this.photo = const Value.absent(),
    this.heatCycleStart = const Value.absent(),
    this.notes = const Value.absent(),
    this.owner = const Value.absent(),
    this.breeder = const Value.absent(),
  });
  HorsesCompanion.insert({
    required String registrationName,
    this.registrationNumber = const Value.absent(),
    this.sireRegistrationName = const Value.absent(),
    this.damRegistrationName = const Value.absent(),
    required String name,
    required Sex sex,
    required DateTime dateOfBirth,
    required double height,
    this.photo = const Value.absent(),
    this.heatCycleStart = const Value.absent(),
    this.notes = const Value.absent(),
    this.owner = const Value.absent(),
    this.breeder = const Value.absent(),
  })  : registrationName = Value(registrationName),
        name = Value(name),
        sex = Value(sex),
        dateOfBirth = Value(dateOfBirth),
        height = Value(height);
  static Insertable<Horse> custom({
    Expression<String>? registrationName,
    Expression<String?>? registrationNumber,
    Expression<String?>? sireRegistrationName,
    Expression<String?>? damRegistrationName,
    Expression<String>? name,
    Expression<Sex>? sex,
    Expression<DateTime>? dateOfBirth,
    Expression<double>? height,
    Expression<Uint8List?>? photo,
    Expression<DateTime?>? heatCycleStart,
    Expression<String?>? notes,
    Expression<int?>? owner,
    Expression<int?>? breeder,
  }) {
    return RawValuesInsertable({
      if (registrationName != null) 'registration_name': registrationName,
      if (registrationNumber != null) 'registration_number': registrationNumber,
      if (sireRegistrationName != null)
        'sire_registration_name': sireRegistrationName,
      if (damRegistrationName != null)
        'dam_registration_name': damRegistrationName,
      if (name != null) 'name': name,
      if (sex != null) 'sex': sex,
      if (dateOfBirth != null) 'date_of_birth': dateOfBirth,
      if (height != null) 'height': height,
      if (photo != null) 'photo': photo,
      if (heatCycleStart != null) 'heat_cycle_start': heatCycleStart,
      if (notes != null) 'notes': notes,
      if (owner != null) 'owner': owner,
      if (breeder != null) 'breeder': breeder,
    });
  }

  HorsesCompanion copyWith(
      {Value<String>? registrationName,
      Value<String?>? registrationNumber,
      Value<String?>? sireRegistrationName,
      Value<String?>? damRegistrationName,
      Value<String>? name,
      Value<Sex>? sex,
      Value<DateTime>? dateOfBirth,
      Value<double>? height,
      Value<Uint8List?>? photo,
      Value<DateTime?>? heatCycleStart,
      Value<String?>? notes,
      Value<int?>? owner,
      Value<int?>? breeder}) {
    return HorsesCompanion(
      registrationName: registrationName ?? this.registrationName,
      registrationNumber: registrationNumber ?? this.registrationNumber,
      sireRegistrationName: sireRegistrationName ?? this.sireRegistrationName,
      damRegistrationName: damRegistrationName ?? this.damRegistrationName,
      name: name ?? this.name,
      sex: sex ?? this.sex,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      height: height ?? this.height,
      photo: photo ?? this.photo,
      heatCycleStart: heatCycleStart ?? this.heatCycleStart,
      notes: notes ?? this.notes,
      owner: owner ?? this.owner,
      breeder: breeder ?? this.breeder,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (registrationName.present) {
      map['registration_name'] = Variable<String>(registrationName.value);
    }
    if (registrationNumber.present) {
      map['registration_number'] = Variable<String?>(registrationNumber.value);
    }
    if (sireRegistrationName.present) {
      map['sire_registration_name'] =
          Variable<String?>(sireRegistrationName.value);
    }
    if (damRegistrationName.present) {
      map['dam_registration_name'] =
          Variable<String?>(damRegistrationName.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (sex.present) {
      final converter = $HorsesTable.$converter0;
      map['sex'] = Variable<int>(converter.mapToSql(sex.value)!);
    }
    if (dateOfBirth.present) {
      map['date_of_birth'] = Variable<DateTime>(dateOfBirth.value);
    }
    if (height.present) {
      map['height'] = Variable<double>(height.value);
    }
    if (photo.present) {
      map['photo'] = Variable<Uint8List?>(photo.value);
    }
    if (heatCycleStart.present) {
      map['heat_cycle_start'] = Variable<DateTime?>(heatCycleStart.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String?>(notes.value);
    }
    if (owner.present) {
      map['owner'] = Variable<int?>(owner.value);
    }
    if (breeder.present) {
      map['breeder'] = Variable<int?>(breeder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HorsesCompanion(')
          ..write('registrationName: $registrationName, ')
          ..write('registrationNumber: $registrationNumber, ')
          ..write('sireRegistrationName: $sireRegistrationName, ')
          ..write('damRegistrationName: $damRegistrationName, ')
          ..write('name: $name, ')
          ..write('sex: $sex, ')
          ..write('dateOfBirth: $dateOfBirth, ')
          ..write('height: $height, ')
          ..write('photo: $photo, ')
          ..write('heatCycleStart: $heatCycleStart, ')
          ..write('notes: $notes, ')
          ..write('owner: $owner, ')
          ..write('breeder: $breeder')
          ..write(')'))
        .toString();
  }
}

class $HorsesTable extends Horses with TableInfo<$HorsesTable, Horse> {
  final GeneratedDatabase _db;
  final String? _alias;
  $HorsesTable(this._db, [this._alias]);
  final VerificationMeta _registrationNameMeta =
      const VerificationMeta('registrationName');
  late final GeneratedColumn<String?> registrationName =
      GeneratedColumn<String?>('registration_name', aliasedName, false,
          typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _registrationNumberMeta =
      const VerificationMeta('registrationNumber');
  late final GeneratedColumn<String?> registrationNumber =
      GeneratedColumn<String?>('registration_number', aliasedName, true,
          typeName: 'TEXT', requiredDuringInsert: false);
  final VerificationMeta _sireRegistrationNameMeta =
      const VerificationMeta('sireRegistrationName');
  late final GeneratedColumn<String?> sireRegistrationName =
      GeneratedColumn<String?>('sire_registration_name', aliasedName, true,
          typeName: 'TEXT', requiredDuringInsert: false);
  final VerificationMeta _damRegistrationNameMeta =
      const VerificationMeta('damRegistrationName');
  late final GeneratedColumn<String?> damRegistrationName =
      GeneratedColumn<String?>('dam_registration_name', aliasedName, true,
          typeName: 'TEXT', requiredDuringInsert: false);
  final VerificationMeta _nameMeta = const VerificationMeta('name');
  late final GeneratedColumn<String?> name = GeneratedColumn<String?>(
      'name', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _sexMeta = const VerificationMeta('sex');
  late final GeneratedColumnWithTypeConverter<Sex, int?> sex =
      GeneratedColumn<int?>('sex', aliasedName, false,
              typeName: 'INTEGER', requiredDuringInsert: true)
          .withConverter<Sex>($HorsesTable.$converter0);
  final VerificationMeta _dateOfBirthMeta =
      const VerificationMeta('dateOfBirth');
  late final GeneratedColumn<DateTime?> dateOfBirth =
      GeneratedColumn<DateTime?>('date_of_birth', aliasedName, false,
          typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _heightMeta = const VerificationMeta('height');
  late final GeneratedColumn<double?> height = GeneratedColumn<double?>(
      'height', aliasedName, false,
      typeName: 'REAL', requiredDuringInsert: true);
  final VerificationMeta _photoMeta = const VerificationMeta('photo');
  late final GeneratedColumn<Uint8List?> photo = GeneratedColumn<Uint8List?>(
      'photo', aliasedName, true,
      typeName: 'BLOB', requiredDuringInsert: false);
  final VerificationMeta _heatCycleStartMeta =
      const VerificationMeta('heatCycleStart');
  late final GeneratedColumn<DateTime?> heatCycleStart =
      GeneratedColumn<DateTime?>('heat_cycle_start', aliasedName, true,
          typeName: 'INTEGER', requiredDuringInsert: false);
  final VerificationMeta _notesMeta = const VerificationMeta('notes');
  late final GeneratedColumn<String?> notes = GeneratedColumn<String?>(
      'notes', aliasedName, true,
      typeName: 'TEXT', requiredDuringInsert: false);
  final VerificationMeta _ownerMeta = const VerificationMeta('owner');
  late final GeneratedColumn<int?> owner = GeneratedColumn<int?>(
      'owner', aliasedName, true,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      $customConstraints: 'NULLABLE REFERENCES owners(id)');
  final VerificationMeta _breederMeta = const VerificationMeta('breeder');
  late final GeneratedColumn<int?> breeder = GeneratedColumn<int?>(
      'breeder', aliasedName, true,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      $customConstraints: 'NULLABLE REFERENCES owners(id)');
  @override
  List<GeneratedColumn> get $columns => [
        registrationName,
        registrationNumber,
        sireRegistrationName,
        damRegistrationName,
        name,
        sex,
        dateOfBirth,
        height,
        photo,
        heatCycleStart,
        notes,
        owner,
        breeder
      ];
  @override
  String get aliasedName => _alias ?? 'horses';
  @override
  String get actualTableName => 'horses';
  @override
  VerificationContext validateIntegrity(Insertable<Horse> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('registration_name')) {
      context.handle(
          _registrationNameMeta,
          registrationName.isAcceptableOrUnknown(
              data['registration_name']!, _registrationNameMeta));
    } else if (isInserting) {
      context.missing(_registrationNameMeta);
    }
    if (data.containsKey('registration_number')) {
      context.handle(
          _registrationNumberMeta,
          registrationNumber.isAcceptableOrUnknown(
              data['registration_number']!, _registrationNumberMeta));
    }
    if (data.containsKey('sire_registration_name')) {
      context.handle(
          _sireRegistrationNameMeta,
          sireRegistrationName.isAcceptableOrUnknown(
              data['sire_registration_name']!, _sireRegistrationNameMeta));
    }
    if (data.containsKey('dam_registration_name')) {
      context.handle(
          _damRegistrationNameMeta,
          damRegistrationName.isAcceptableOrUnknown(
              data['dam_registration_name']!, _damRegistrationNameMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    context.handle(_sexMeta, const VerificationResult.success());
    if (data.containsKey('date_of_birth')) {
      context.handle(
          _dateOfBirthMeta,
          dateOfBirth.isAcceptableOrUnknown(
              data['date_of_birth']!, _dateOfBirthMeta));
    } else if (isInserting) {
      context.missing(_dateOfBirthMeta);
    }
    if (data.containsKey('height')) {
      context.handle(_heightMeta,
          height.isAcceptableOrUnknown(data['height']!, _heightMeta));
    } else if (isInserting) {
      context.missing(_heightMeta);
    }
    if (data.containsKey('photo')) {
      context.handle(
          _photoMeta, photo.isAcceptableOrUnknown(data['photo']!, _photoMeta));
    }
    if (data.containsKey('heat_cycle_start')) {
      context.handle(
          _heatCycleStartMeta,
          heatCycleStart.isAcceptableOrUnknown(
              data['heat_cycle_start']!, _heatCycleStartMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('owner')) {
      context.handle(
          _ownerMeta, owner.isAcceptableOrUnknown(data['owner']!, _ownerMeta));
    }
    if (data.containsKey('breeder')) {
      context.handle(_breederMeta,
          breeder.isAcceptableOrUnknown(data['breeder']!, _breederMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {registrationName};
  @override
  Horse map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Horse.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $HorsesTable createAlias(String alias) {
    return $HorsesTable(_db, alias);
  }

  static TypeConverter<Sex, int> $converter0 =
      const EnumIndexConverter<Sex>(Sex.values);
}

abstract class _$AppDb extends GeneratedDatabase {
  _$AppDb(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  late final $EventsTable events = $EventsTable(this);
  late final $HorsesTable horses = $HorsesTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [events, horses];
}
