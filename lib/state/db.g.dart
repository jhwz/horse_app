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
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EventsTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String?> type = GeneratedColumn<String?>(
      'type', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _registrationNameMeta =
      const VerificationMeta('registrationName');
  @override
  late final GeneratedColumn<String?> registrationName =
      GeneratedColumn<String?>('registration_name', aliasedName, false,
          type: const StringType(),
          requiredDuringInsert: true,
          $customConstraints: 'NOT NULL REFERENCES horses(registration_name)');
  final VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime?> date = GeneratedColumn<DateTime?>(
      'date', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  final VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String?> notes = GeneratedColumn<String?>(
      'notes', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _extraMeta = const VerificationMeta('extra');
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, dynamic>, String?>
      extra = GeneratedColumn<String?>('extra', aliasedName, true,
              type: const StringType(), requiredDuringInsert: false)
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
    return $EventsTable(attachedDatabase, alias);
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
  final double? height;
  final double? minWeight;
  final double? maxWeight;
  final int? profilePhoto;
  final DateTime? heatCycleStart;
  final String? notes;
  final String? owner;
  final String? breeder;
  Horse(
      {required this.registrationName,
      this.registrationNumber,
      this.sireRegistrationName,
      this.damRegistrationName,
      required this.name,
      required this.sex,
      required this.dateOfBirth,
      this.height,
      this.minWeight,
      this.maxWeight,
      this.profilePhoto,
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
          .mapFromDatabaseResponse(data['${effectivePrefix}height']),
      minWeight: const RealType()
          .mapFromDatabaseResponse(data['${effectivePrefix}min_weight']),
      maxWeight: const RealType()
          .mapFromDatabaseResponse(data['${effectivePrefix}max_weight']),
      profilePhoto: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}profile_photo']),
      heatCycleStart: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}heat_cycle_start']),
      notes: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}notes']),
      owner: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}owner']),
      breeder: const StringType()
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
    if (!nullToAbsent || height != null) {
      map['height'] = Variable<double?>(height);
    }
    if (!nullToAbsent || minWeight != null) {
      map['min_weight'] = Variable<double?>(minWeight);
    }
    if (!nullToAbsent || maxWeight != null) {
      map['max_weight'] = Variable<double?>(maxWeight);
    }
    if (!nullToAbsent || profilePhoto != null) {
      map['profile_photo'] = Variable<int?>(profilePhoto);
    }
    if (!nullToAbsent || heatCycleStart != null) {
      map['heat_cycle_start'] = Variable<DateTime?>(heatCycleStart);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String?>(notes);
    }
    if (!nullToAbsent || owner != null) {
      map['owner'] = Variable<String?>(owner);
    }
    if (!nullToAbsent || breeder != null) {
      map['breeder'] = Variable<String?>(breeder);
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
      height:
          height == null && nullToAbsent ? const Value.absent() : Value(height),
      minWeight: minWeight == null && nullToAbsent
          ? const Value.absent()
          : Value(minWeight),
      maxWeight: maxWeight == null && nullToAbsent
          ? const Value.absent()
          : Value(maxWeight),
      profilePhoto: profilePhoto == null && nullToAbsent
          ? const Value.absent()
          : Value(profilePhoto),
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
      height: serializer.fromJson<double?>(json['height']),
      minWeight: serializer.fromJson<double?>(json['minWeight']),
      maxWeight: serializer.fromJson<double?>(json['maxWeight']),
      profilePhoto: serializer.fromJson<int?>(json['profilePhoto']),
      heatCycleStart: serializer.fromJson<DateTime?>(json['heatCycleStart']),
      notes: serializer.fromJson<String?>(json['notes']),
      owner: serializer.fromJson<String?>(json['owner']),
      breeder: serializer.fromJson<String?>(json['breeder']),
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
      'height': serializer.toJson<double?>(height),
      'minWeight': serializer.toJson<double?>(minWeight),
      'maxWeight': serializer.toJson<double?>(maxWeight),
      'profilePhoto': serializer.toJson<int?>(profilePhoto),
      'heatCycleStart': serializer.toJson<DateTime?>(heatCycleStart),
      'notes': serializer.toJson<String?>(notes),
      'owner': serializer.toJson<String?>(owner),
      'breeder': serializer.toJson<String?>(breeder),
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
          Value<double?> height = const Value.absent(),
          Value<double?> minWeight = const Value.absent(),
          Value<double?> maxWeight = const Value.absent(),
          Value<int?> profilePhoto = const Value.absent(),
          Value<DateTime?> heatCycleStart = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          Value<String?> owner = const Value.absent(),
          Value<String?> breeder = const Value.absent()}) =>
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
        height: height.present ? height.value : this.height,
        minWeight: minWeight.present ? minWeight.value : this.minWeight,
        maxWeight: maxWeight.present ? maxWeight.value : this.maxWeight,
        profilePhoto:
            profilePhoto.present ? profilePhoto.value : this.profilePhoto,
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
          ..write('minWeight: $minWeight, ')
          ..write('maxWeight: $maxWeight, ')
          ..write('profilePhoto: $profilePhoto, ')
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
      minWeight,
      maxWeight,
      profilePhoto,
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
          other.minWeight == this.minWeight &&
          other.maxWeight == this.maxWeight &&
          other.profilePhoto == this.profilePhoto &&
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
  final Value<double?> height;
  final Value<double?> minWeight;
  final Value<double?> maxWeight;
  final Value<int?> profilePhoto;
  final Value<DateTime?> heatCycleStart;
  final Value<String?> notes;
  final Value<String?> owner;
  final Value<String?> breeder;
  const HorsesCompanion({
    this.registrationName = const Value.absent(),
    this.registrationNumber = const Value.absent(),
    this.sireRegistrationName = const Value.absent(),
    this.damRegistrationName = const Value.absent(),
    this.name = const Value.absent(),
    this.sex = const Value.absent(),
    this.dateOfBirth = const Value.absent(),
    this.height = const Value.absent(),
    this.minWeight = const Value.absent(),
    this.maxWeight = const Value.absent(),
    this.profilePhoto = const Value.absent(),
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
    this.height = const Value.absent(),
    this.minWeight = const Value.absent(),
    this.maxWeight = const Value.absent(),
    this.profilePhoto = const Value.absent(),
    this.heatCycleStart = const Value.absent(),
    this.notes = const Value.absent(),
    this.owner = const Value.absent(),
    this.breeder = const Value.absent(),
  })  : registrationName = Value(registrationName),
        name = Value(name),
        sex = Value(sex),
        dateOfBirth = Value(dateOfBirth);
  static Insertable<Horse> custom({
    Expression<String>? registrationName,
    Expression<String?>? registrationNumber,
    Expression<String?>? sireRegistrationName,
    Expression<String?>? damRegistrationName,
    Expression<String>? name,
    Expression<Sex>? sex,
    Expression<DateTime>? dateOfBirth,
    Expression<double?>? height,
    Expression<double?>? minWeight,
    Expression<double?>? maxWeight,
    Expression<int?>? profilePhoto,
    Expression<DateTime?>? heatCycleStart,
    Expression<String?>? notes,
    Expression<String?>? owner,
    Expression<String?>? breeder,
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
      if (minWeight != null) 'min_weight': minWeight,
      if (maxWeight != null) 'max_weight': maxWeight,
      if (profilePhoto != null) 'profile_photo': profilePhoto,
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
      Value<double?>? height,
      Value<double?>? minWeight,
      Value<double?>? maxWeight,
      Value<int?>? profilePhoto,
      Value<DateTime?>? heatCycleStart,
      Value<String?>? notes,
      Value<String?>? owner,
      Value<String?>? breeder}) {
    return HorsesCompanion(
      registrationName: registrationName ?? this.registrationName,
      registrationNumber: registrationNumber ?? this.registrationNumber,
      sireRegistrationName: sireRegistrationName ?? this.sireRegistrationName,
      damRegistrationName: damRegistrationName ?? this.damRegistrationName,
      name: name ?? this.name,
      sex: sex ?? this.sex,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      height: height ?? this.height,
      minWeight: minWeight ?? this.minWeight,
      maxWeight: maxWeight ?? this.maxWeight,
      profilePhoto: profilePhoto ?? this.profilePhoto,
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
      map['height'] = Variable<double?>(height.value);
    }
    if (minWeight.present) {
      map['min_weight'] = Variable<double?>(minWeight.value);
    }
    if (maxWeight.present) {
      map['max_weight'] = Variable<double?>(maxWeight.value);
    }
    if (profilePhoto.present) {
      map['profile_photo'] = Variable<int?>(profilePhoto.value);
    }
    if (heatCycleStart.present) {
      map['heat_cycle_start'] = Variable<DateTime?>(heatCycleStart.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String?>(notes.value);
    }
    if (owner.present) {
      map['owner'] = Variable<String?>(owner.value);
    }
    if (breeder.present) {
      map['breeder'] = Variable<String?>(breeder.value);
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
          ..write('minWeight: $minWeight, ')
          ..write('maxWeight: $maxWeight, ')
          ..write('profilePhoto: $profilePhoto, ')
          ..write('heatCycleStart: $heatCycleStart, ')
          ..write('notes: $notes, ')
          ..write('owner: $owner, ')
          ..write('breeder: $breeder')
          ..write(')'))
        .toString();
  }
}

class $HorsesTable extends Horses with TableInfo<$HorsesTable, Horse> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HorsesTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _registrationNameMeta =
      const VerificationMeta('registrationName');
  @override
  late final GeneratedColumn<String?> registrationName =
      GeneratedColumn<String?>('registration_name', aliasedName, false,
          type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _registrationNumberMeta =
      const VerificationMeta('registrationNumber');
  @override
  late final GeneratedColumn<String?> registrationNumber =
      GeneratedColumn<String?>('registration_number', aliasedName, true,
          type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _sireRegistrationNameMeta =
      const VerificationMeta('sireRegistrationName');
  @override
  late final GeneratedColumn<String?> sireRegistrationName =
      GeneratedColumn<String?>('sire_registration_name', aliasedName, true,
          type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _damRegistrationNameMeta =
      const VerificationMeta('damRegistrationName');
  @override
  late final GeneratedColumn<String?> damRegistrationName =
      GeneratedColumn<String?>('dam_registration_name', aliasedName, true,
          type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String?> name = GeneratedColumn<String?>(
      'name', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _sexMeta = const VerificationMeta('sex');
  @override
  late final GeneratedColumnWithTypeConverter<Sex, int?> sex =
      GeneratedColumn<int?>('sex', aliasedName, false,
              type: const IntType(), requiredDuringInsert: true)
          .withConverter<Sex>($HorsesTable.$converter0);
  final VerificationMeta _dateOfBirthMeta =
      const VerificationMeta('dateOfBirth');
  @override
  late final GeneratedColumn<DateTime?> dateOfBirth =
      GeneratedColumn<DateTime?>('date_of_birth', aliasedName, false,
          type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _heightMeta = const VerificationMeta('height');
  @override
  late final GeneratedColumn<double?> height = GeneratedColumn<double?>(
      'height', aliasedName, true,
      type: const RealType(), requiredDuringInsert: false);
  final VerificationMeta _minWeightMeta = const VerificationMeta('minWeight');
  @override
  late final GeneratedColumn<double?> minWeight = GeneratedColumn<double?>(
      'min_weight', aliasedName, true,
      type: const RealType(), requiredDuringInsert: false);
  final VerificationMeta _maxWeightMeta = const VerificationMeta('maxWeight');
  @override
  late final GeneratedColumn<double?> maxWeight = GeneratedColumn<double?>(
      'max_weight', aliasedName, true,
      type: const RealType(), requiredDuringInsert: false);
  final VerificationMeta _profilePhotoMeta =
      const VerificationMeta('profilePhoto');
  @override
  late final GeneratedColumn<int?> profilePhoto = GeneratedColumn<int?>(
      'profile_photo', aliasedName, true,
      type: const IntType(),
      requiredDuringInsert: false,
      $customConstraints: 'NULLABLE REFERENCES owners(id)');
  final VerificationMeta _heatCycleStartMeta =
      const VerificationMeta('heatCycleStart');
  @override
  late final GeneratedColumn<DateTime?> heatCycleStart =
      GeneratedColumn<DateTime?>('heat_cycle_start', aliasedName, true,
          type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String?> notes = GeneratedColumn<String?>(
      'notes', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _ownerMeta = const VerificationMeta('owner');
  @override
  late final GeneratedColumn<String?> owner = GeneratedColumn<String?>(
      'owner', aliasedName, true,
      type: const StringType(),
      requiredDuringInsert: false,
      $customConstraints: 'NULLABLE REFERENCES owners(id)');
  final VerificationMeta _breederMeta = const VerificationMeta('breeder');
  @override
  late final GeneratedColumn<String?> breeder = GeneratedColumn<String?>(
      'breeder', aliasedName, true,
      type: const StringType(),
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
        minWeight,
        maxWeight,
        profilePhoto,
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
    }
    if (data.containsKey('min_weight')) {
      context.handle(_minWeightMeta,
          minWeight.isAcceptableOrUnknown(data['min_weight']!, _minWeightMeta));
    }
    if (data.containsKey('max_weight')) {
      context.handle(_maxWeightMeta,
          maxWeight.isAcceptableOrUnknown(data['max_weight']!, _maxWeightMeta));
    }
    if (data.containsKey('profile_photo')) {
      context.handle(
          _profilePhotoMeta,
          profilePhoto.isAcceptableOrUnknown(
              data['profile_photo']!, _profilePhotoMeta));
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
    return $HorsesTable(attachedDatabase, alias);
  }

  static TypeConverter<Sex, int> $converter0 =
      const EnumIndexConverter<Sex>(Sex.values);
}

class Owner extends DataClass implements Insertable<Owner> {
  final String id;
  final String? name;
  final String? email;
  final String? phone;
  final String? address;
  final String? city;
  final String? region;
  final int? postcode;
  final String? country;
  Owner(
      {required this.id,
      this.name,
      this.email,
      this.phone,
      this.address,
      this.city,
      this.region,
      this.postcode,
      this.country});
  factory Owner.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Owner(
      id: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      name: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}name']),
      email: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}email']),
      phone: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}phone']),
      address: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}address']),
      city: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}city']),
      region: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}region']),
      postcode: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}postcode']),
      country: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}country']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String?>(name);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String?>(email);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String?>(phone);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String?>(address);
    }
    if (!nullToAbsent || city != null) {
      map['city'] = Variable<String?>(city);
    }
    if (!nullToAbsent || region != null) {
      map['region'] = Variable<String?>(region);
    }
    if (!nullToAbsent || postcode != null) {
      map['postcode'] = Variable<int?>(postcode);
    }
    if (!nullToAbsent || country != null) {
      map['country'] = Variable<String?>(country);
    }
    return map;
  }

  OwnersCompanion toCompanion(bool nullToAbsent) {
    return OwnersCompanion(
      id: Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      phone:
          phone == null && nullToAbsent ? const Value.absent() : Value(phone),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      city: city == null && nullToAbsent ? const Value.absent() : Value(city),
      region:
          region == null && nullToAbsent ? const Value.absent() : Value(region),
      postcode: postcode == null && nullToAbsent
          ? const Value.absent()
          : Value(postcode),
      country: country == null && nullToAbsent
          ? const Value.absent()
          : Value(country),
    );
  }

  factory Owner.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Owner(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String?>(json['name']),
      email: serializer.fromJson<String?>(json['email']),
      phone: serializer.fromJson<String?>(json['phone']),
      address: serializer.fromJson<String?>(json['address']),
      city: serializer.fromJson<String?>(json['city']),
      region: serializer.fromJson<String?>(json['region']),
      postcode: serializer.fromJson<int?>(json['postcode']),
      country: serializer.fromJson<String?>(json['country']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String?>(name),
      'email': serializer.toJson<String?>(email),
      'phone': serializer.toJson<String?>(phone),
      'address': serializer.toJson<String?>(address),
      'city': serializer.toJson<String?>(city),
      'region': serializer.toJson<String?>(region),
      'postcode': serializer.toJson<int?>(postcode),
      'country': serializer.toJson<String?>(country),
    };
  }

  Owner copyWith(
          {String? id,
          Value<String?> name = const Value.absent(),
          Value<String?> email = const Value.absent(),
          Value<String?> phone = const Value.absent(),
          Value<String?> address = const Value.absent(),
          Value<String?> city = const Value.absent(),
          Value<String?> region = const Value.absent(),
          Value<int?> postcode = const Value.absent(),
          Value<String?> country = const Value.absent()}) =>
      Owner(
        id: id ?? this.id,
        name: name.present ? name.value : this.name,
        email: email.present ? email.value : this.email,
        phone: phone.present ? phone.value : this.phone,
        address: address.present ? address.value : this.address,
        city: city.present ? city.value : this.city,
        region: region.present ? region.value : this.region,
        postcode: postcode.present ? postcode.value : this.postcode,
        country: country.present ? country.value : this.country,
      );
  @override
  String toString() {
    return (StringBuffer('Owner(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('phone: $phone, ')
          ..write('address: $address, ')
          ..write('city: $city, ')
          ..write('region: $region, ')
          ..write('postcode: $postcode, ')
          ..write('country: $country')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, name, email, phone, address, city, region, postcode, country);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Owner &&
          other.id == this.id &&
          other.name == this.name &&
          other.email == this.email &&
          other.phone == this.phone &&
          other.address == this.address &&
          other.city == this.city &&
          other.region == this.region &&
          other.postcode == this.postcode &&
          other.country == this.country);
}

class OwnersCompanion extends UpdateCompanion<Owner> {
  final Value<String> id;
  final Value<String?> name;
  final Value<String?> email;
  final Value<String?> phone;
  final Value<String?> address;
  final Value<String?> city;
  final Value<String?> region;
  final Value<int?> postcode;
  final Value<String?> country;
  const OwnersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.email = const Value.absent(),
    this.phone = const Value.absent(),
    this.address = const Value.absent(),
    this.city = const Value.absent(),
    this.region = const Value.absent(),
    this.postcode = const Value.absent(),
    this.country = const Value.absent(),
  });
  OwnersCompanion.insert({
    required String id,
    this.name = const Value.absent(),
    this.email = const Value.absent(),
    this.phone = const Value.absent(),
    this.address = const Value.absent(),
    this.city = const Value.absent(),
    this.region = const Value.absent(),
    this.postcode = const Value.absent(),
    this.country = const Value.absent(),
  }) : id = Value(id);
  static Insertable<Owner> custom({
    Expression<String>? id,
    Expression<String?>? name,
    Expression<String?>? email,
    Expression<String?>? phone,
    Expression<String?>? address,
    Expression<String?>? city,
    Expression<String?>? region,
    Expression<int?>? postcode,
    Expression<String?>? country,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (address != null) 'address': address,
      if (city != null) 'city': city,
      if (region != null) 'region': region,
      if (postcode != null) 'postcode': postcode,
      if (country != null) 'country': country,
    });
  }

  OwnersCompanion copyWith(
      {Value<String>? id,
      Value<String?>? name,
      Value<String?>? email,
      Value<String?>? phone,
      Value<String?>? address,
      Value<String?>? city,
      Value<String?>? region,
      Value<int?>? postcode,
      Value<String?>? country}) {
    return OwnersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      city: city ?? this.city,
      region: region ?? this.region,
      postcode: postcode ?? this.postcode,
      country: country ?? this.country,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String?>(name.value);
    }
    if (email.present) {
      map['email'] = Variable<String?>(email.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String?>(phone.value);
    }
    if (address.present) {
      map['address'] = Variable<String?>(address.value);
    }
    if (city.present) {
      map['city'] = Variable<String?>(city.value);
    }
    if (region.present) {
      map['region'] = Variable<String?>(region.value);
    }
    if (postcode.present) {
      map['postcode'] = Variable<int?>(postcode.value);
    }
    if (country.present) {
      map['country'] = Variable<String?>(country.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OwnersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('phone: $phone, ')
          ..write('address: $address, ')
          ..write('city: $city, ')
          ..write('region: $region, ')
          ..write('postcode: $postcode, ')
          ..write('country: $country')
          ..write(')'))
        .toString();
  }
}

class $OwnersTable extends Owners with TableInfo<$OwnersTable, Owner> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OwnersTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String?> id = GeneratedColumn<String?>(
      'id', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String?> name = GeneratedColumn<String?>(
      'name', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String?> email = GeneratedColumn<String?>(
      'email', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String?> phone = GeneratedColumn<String?>(
      'phone', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _addressMeta = const VerificationMeta('address');
  @override
  late final GeneratedColumn<String?> address = GeneratedColumn<String?>(
      'address', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _cityMeta = const VerificationMeta('city');
  @override
  late final GeneratedColumn<String?> city = GeneratedColumn<String?>(
      'city', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _regionMeta = const VerificationMeta('region');
  @override
  late final GeneratedColumn<String?> region = GeneratedColumn<String?>(
      'region', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _postcodeMeta = const VerificationMeta('postcode');
  @override
  late final GeneratedColumn<int?> postcode = GeneratedColumn<int?>(
      'postcode', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _countryMeta = const VerificationMeta('country');
  @override
  late final GeneratedColumn<String?> country = GeneratedColumn<String?>(
      'country', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, email, phone, address, city, region, postcode, country];
  @override
  String get aliasedName => _alias ?? 'owners';
  @override
  String get actualTableName => 'owners';
  @override
  VerificationContext validateIntegrity(Insertable<Owner> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    }
    if (data.containsKey('address')) {
      context.handle(_addressMeta,
          address.isAcceptableOrUnknown(data['address']!, _addressMeta));
    }
    if (data.containsKey('city')) {
      context.handle(
          _cityMeta, city.isAcceptableOrUnknown(data['city']!, _cityMeta));
    }
    if (data.containsKey('region')) {
      context.handle(_regionMeta,
          region.isAcceptableOrUnknown(data['region']!, _regionMeta));
    }
    if (data.containsKey('postcode')) {
      context.handle(_postcodeMeta,
          postcode.isAcceptableOrUnknown(data['postcode']!, _postcodeMeta));
    }
    if (data.containsKey('country')) {
      context.handle(_countryMeta,
          country.isAcceptableOrUnknown(data['country']!, _countryMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Owner map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Owner.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $OwnersTable createAlias(String alias) {
    return $OwnersTable(attachedDatabase, alias);
  }
}

abstract class _$AppDb extends GeneratedDatabase {
  _$AppDb(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  late final $EventsTable events = $EventsTable(this);
  late final $HorsesTable horses = $HorsesTable(this);
  late final $OwnersTable owners = $OwnersTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [events, horses, owners];
}
