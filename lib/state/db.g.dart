// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class Event extends DataClass implements Insertable<Event> {
  final int id;
  final String type;
  final String horseID;
  final DateTime date;
  final double? cost;
  final String? notes;
  final Map<String, dynamic>? extra;
  Event(
      {required this.id,
      required this.type,
      required this.horseID,
      required this.date,
      this.cost,
      this.notes,
      this.extra});
  factory Event.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Event(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      type: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}type'])!,
      horseID: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}horse_i_d'])!,
      date: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}date'])!,
      cost: const RealType()
          .mapFromDatabaseResponse(data['${effectivePrefix}cost']),
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
    map['horse_i_d'] = Variable<String>(horseID);
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || cost != null) {
      map['cost'] = Variable<double?>(cost);
    }
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
      horseID: Value(horseID),
      date: Value(date),
      cost: cost == null && nullToAbsent ? const Value.absent() : Value(cost),
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
      horseID: serializer.fromJson<String>(json['horseID']),
      date: serializer.fromJson<DateTime>(json['date']),
      cost: serializer.fromJson<double?>(json['cost']),
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
      'horseID': serializer.toJson<String>(horseID),
      'date': serializer.toJson<DateTime>(date),
      'cost': serializer.toJson<double?>(cost),
      'notes': serializer.toJson<String?>(notes),
      'extra': serializer.toJson<Map<String, dynamic>?>(extra),
    };
  }

  Event copyWith(
          {int? id,
          String? type,
          String? horseID,
          DateTime? date,
          Value<double?> cost = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          Value<Map<String, dynamic>?> extra = const Value.absent()}) =>
      Event(
        id: id ?? this.id,
        type: type ?? this.type,
        horseID: horseID ?? this.horseID,
        date: date ?? this.date,
        cost: cost.present ? cost.value : this.cost,
        notes: notes.present ? notes.value : this.notes,
        extra: extra.present ? extra.value : this.extra,
      );
  @override
  String toString() {
    return (StringBuffer('Event(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('horseID: $horseID, ')
          ..write('date: $date, ')
          ..write('cost: $cost, ')
          ..write('notes: $notes, ')
          ..write('extra: $extra')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, type, horseID, date, cost, notes, extra);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Event &&
          other.id == this.id &&
          other.type == this.type &&
          other.horseID == this.horseID &&
          other.date == this.date &&
          other.cost == this.cost &&
          other.notes == this.notes &&
          other.extra == this.extra);
}

class EventsCompanion extends UpdateCompanion<Event> {
  final Value<int> id;
  final Value<String> type;
  final Value<String> horseID;
  final Value<DateTime> date;
  final Value<double?> cost;
  final Value<String?> notes;
  final Value<Map<String, dynamic>?> extra;
  const EventsCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.horseID = const Value.absent(),
    this.date = const Value.absent(),
    this.cost = const Value.absent(),
    this.notes = const Value.absent(),
    this.extra = const Value.absent(),
  });
  EventsCompanion.insert({
    this.id = const Value.absent(),
    required String type,
    required String horseID,
    this.date = const Value.absent(),
    this.cost = const Value.absent(),
    this.notes = const Value.absent(),
    this.extra = const Value.absent(),
  })  : type = Value(type),
        horseID = Value(horseID);
  static Insertable<Event> custom({
    Expression<int>? id,
    Expression<String>? type,
    Expression<String>? horseID,
    Expression<DateTime>? date,
    Expression<double?>? cost,
    Expression<String?>? notes,
    Expression<Map<String, dynamic>?>? extra,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (horseID != null) 'horse_i_d': horseID,
      if (date != null) 'date': date,
      if (cost != null) 'cost': cost,
      if (notes != null) 'notes': notes,
      if (extra != null) 'extra': extra,
    });
  }

  EventsCompanion copyWith(
      {Value<int>? id,
      Value<String>? type,
      Value<String>? horseID,
      Value<DateTime>? date,
      Value<double?>? cost,
      Value<String?>? notes,
      Value<Map<String, dynamic>?>? extra}) {
    return EventsCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      horseID: horseID ?? this.horseID,
      date: date ?? this.date,
      cost: cost ?? this.cost,
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
    if (horseID.present) {
      map['horse_i_d'] = Variable<String>(horseID.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (cost.present) {
      map['cost'] = Variable<double?>(cost.value);
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
          ..write('horseID: $horseID, ')
          ..write('date: $date, ')
          ..write('cost: $cost, ')
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
  final VerificationMeta _horseIDMeta = const VerificationMeta('horseID');
  @override
  late final GeneratedColumn<String?> horseID = GeneratedColumn<String?>(
      'horse_i_d', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime?> date = GeneratedColumn<DateTime?>(
      'date', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  final VerificationMeta _costMeta = const VerificationMeta('cost');
  @override
  late final GeneratedColumn<double?> cost = GeneratedColumn<double?>(
      'cost', aliasedName, true,
      type: const RealType(), requiredDuringInsert: false);
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
      [id, type, horseID, date, cost, notes, extra];
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
    if (data.containsKey('horse_i_d')) {
      context.handle(_horseIDMeta,
          horseID.isAcceptableOrUnknown(data['horse_i_d']!, _horseIDMeta));
    } else if (isInserting) {
      context.missing(_horseIDMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    }
    if (data.containsKey('cost')) {
      context.handle(
          _costMeta, cost.isAcceptableOrUnknown(data['cost']!, _costMeta));
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
  final String id;
  final String? registrationName;
  final String? registrationNumber;
  final String? sireID;
  final String? damID;
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
      {required this.id,
      this.registrationName,
      this.registrationNumber,
      this.sireID,
      this.damID,
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
      id: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      registrationName: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}registration_name']),
      registrationNumber: const StringType().mapFromDatabaseResponse(
          data['${effectivePrefix}registration_number']),
      sireID: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}sire_i_d']),
      damID: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}dam_i_d']),
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
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || registrationName != null) {
      map['registration_name'] = Variable<String?>(registrationName);
    }
    if (!nullToAbsent || registrationNumber != null) {
      map['registration_number'] = Variable<String?>(registrationNumber);
    }
    if (!nullToAbsent || sireID != null) {
      map['sire_i_d'] = Variable<String?>(sireID);
    }
    if (!nullToAbsent || damID != null) {
      map['dam_i_d'] = Variable<String?>(damID);
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
      id: Value(id),
      registrationName: registrationName == null && nullToAbsent
          ? const Value.absent()
          : Value(registrationName),
      registrationNumber: registrationNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(registrationNumber),
      sireID:
          sireID == null && nullToAbsent ? const Value.absent() : Value(sireID),
      damID:
          damID == null && nullToAbsent ? const Value.absent() : Value(damID),
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
      id: serializer.fromJson<String>(json['id']),
      registrationName: serializer.fromJson<String?>(json['registrationName']),
      registrationNumber:
          serializer.fromJson<String?>(json['registrationNumber']),
      sireID: serializer.fromJson<String?>(json['sireID']),
      damID: serializer.fromJson<String?>(json['damID']),
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
      'id': serializer.toJson<String>(id),
      'registrationName': serializer.toJson<String?>(registrationName),
      'registrationNumber': serializer.toJson<String?>(registrationNumber),
      'sireID': serializer.toJson<String?>(sireID),
      'damID': serializer.toJson<String?>(damID),
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
          {String? id,
          Value<String?> registrationName = const Value.absent(),
          Value<String?> registrationNumber = const Value.absent(),
          Value<String?> sireID = const Value.absent(),
          Value<String?> damID = const Value.absent(),
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
        id: id ?? this.id,
        registrationName: registrationName.present
            ? registrationName.value
            : this.registrationName,
        registrationNumber: registrationNumber.present
            ? registrationNumber.value
            : this.registrationNumber,
        sireID: sireID.present ? sireID.value : this.sireID,
        damID: damID.present ? damID.value : this.damID,
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
          ..write('id: $id, ')
          ..write('registrationName: $registrationName, ')
          ..write('registrationNumber: $registrationNumber, ')
          ..write('sireID: $sireID, ')
          ..write('damID: $damID, ')
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
      id,
      registrationName,
      registrationNumber,
      sireID,
      damID,
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
          other.id == this.id &&
          other.registrationName == this.registrationName &&
          other.registrationNumber == this.registrationNumber &&
          other.sireID == this.sireID &&
          other.damID == this.damID &&
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
  final Value<String> id;
  final Value<String?> registrationName;
  final Value<String?> registrationNumber;
  final Value<String?> sireID;
  final Value<String?> damID;
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
    this.id = const Value.absent(),
    this.registrationName = const Value.absent(),
    this.registrationNumber = const Value.absent(),
    this.sireID = const Value.absent(),
    this.damID = const Value.absent(),
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
    required String id,
    this.registrationName = const Value.absent(),
    this.registrationNumber = const Value.absent(),
    this.sireID = const Value.absent(),
    this.damID = const Value.absent(),
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
  })  : id = Value(id),
        name = Value(name),
        sex = Value(sex),
        dateOfBirth = Value(dateOfBirth);
  static Insertable<Horse> custom({
    Expression<String>? id,
    Expression<String?>? registrationName,
    Expression<String?>? registrationNumber,
    Expression<String?>? sireID,
    Expression<String?>? damID,
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
      if (id != null) 'id': id,
      if (registrationName != null) 'registration_name': registrationName,
      if (registrationNumber != null) 'registration_number': registrationNumber,
      if (sireID != null) 'sire_i_d': sireID,
      if (damID != null) 'dam_i_d': damID,
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
      {Value<String>? id,
      Value<String?>? registrationName,
      Value<String?>? registrationNumber,
      Value<String?>? sireID,
      Value<String?>? damID,
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
      id: id ?? this.id,
      registrationName: registrationName ?? this.registrationName,
      registrationNumber: registrationNumber ?? this.registrationNumber,
      sireID: sireID ?? this.sireID,
      damID: damID ?? this.damID,
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
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (registrationName.present) {
      map['registration_name'] = Variable<String?>(registrationName.value);
    }
    if (registrationNumber.present) {
      map['registration_number'] = Variable<String?>(registrationNumber.value);
    }
    if (sireID.present) {
      map['sire_i_d'] = Variable<String?>(sireID.value);
    }
    if (damID.present) {
      map['dam_i_d'] = Variable<String?>(damID.value);
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
          ..write('id: $id, ')
          ..write('registrationName: $registrationName, ')
          ..write('registrationNumber: $registrationNumber, ')
          ..write('sireID: $sireID, ')
          ..write('damID: $damID, ')
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
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String?> id = GeneratedColumn<String?>(
      'id', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _registrationNameMeta =
      const VerificationMeta('registrationName');
  @override
  late final GeneratedColumn<String?> registrationName =
      GeneratedColumn<String?>('registration_name', aliasedName, true,
          type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _registrationNumberMeta =
      const VerificationMeta('registrationNumber');
  @override
  late final GeneratedColumn<String?> registrationNumber =
      GeneratedColumn<String?>('registration_number', aliasedName, true,
          type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _sireIDMeta = const VerificationMeta('sireID');
  @override
  late final GeneratedColumn<String?> sireID = GeneratedColumn<String?>(
      'sire_i_d', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _damIDMeta = const VerificationMeta('damID');
  @override
  late final GeneratedColumn<String?> damID = GeneratedColumn<String?>(
      'dam_i_d', aliasedName, true,
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
        id,
        registrationName,
        registrationNumber,
        sireID,
        damID,
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
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('registration_name')) {
      context.handle(
          _registrationNameMeta,
          registrationName.isAcceptableOrUnknown(
              data['registration_name']!, _registrationNameMeta));
    }
    if (data.containsKey('registration_number')) {
      context.handle(
          _registrationNumberMeta,
          registrationNumber.isAcceptableOrUnknown(
              data['registration_number']!, _registrationNumberMeta));
    }
    if (data.containsKey('sire_i_d')) {
      context.handle(_sireIDMeta,
          sireID.isAcceptableOrUnknown(data['sire_i_d']!, _sireIDMeta));
    }
    if (data.containsKey('dam_i_d')) {
      context.handle(_damIDMeta,
          damID.isAcceptableOrUnknown(data['dam_i_d']!, _damIDMeta));
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
  Set<GeneratedColumn> get $primaryKey => {id};
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

class HorseGalleryData extends DataClass
    implements Insertable<HorseGalleryData> {
  final int id;
  final String horseID;
  final Uint8List photo;
  HorseGalleryData(
      {required this.id, required this.horseID, required this.photo});
  factory HorseGalleryData.fromData(Map<String, dynamic> data,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return HorseGalleryData(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      horseID: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}horse_i_d'])!,
      photo: const BlobType()
          .mapFromDatabaseResponse(data['${effectivePrefix}photo'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['horse_i_d'] = Variable<String>(horseID);
    map['photo'] = Variable<Uint8List>(photo);
    return map;
  }

  HorseGalleryCompanion toCompanion(bool nullToAbsent) {
    return HorseGalleryCompanion(
      id: Value(id),
      horseID: Value(horseID),
      photo: Value(photo),
    );
  }

  factory HorseGalleryData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HorseGalleryData(
      id: serializer.fromJson<int>(json['id']),
      horseID: serializer.fromJson<String>(json['horseID']),
      photo: serializer.fromJson<Uint8List>(json['photo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'horseID': serializer.toJson<String>(horseID),
      'photo': serializer.toJson<Uint8List>(photo),
    };
  }

  HorseGalleryData copyWith({int? id, String? horseID, Uint8List? photo}) =>
      HorseGalleryData(
        id: id ?? this.id,
        horseID: horseID ?? this.horseID,
        photo: photo ?? this.photo,
      );
  @override
  String toString() {
    return (StringBuffer('HorseGalleryData(')
          ..write('id: $id, ')
          ..write('horseID: $horseID, ')
          ..write('photo: $photo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, horseID, photo);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HorseGalleryData &&
          other.id == this.id &&
          other.horseID == this.horseID &&
          other.photo == this.photo);
}

class HorseGalleryCompanion extends UpdateCompanion<HorseGalleryData> {
  final Value<int> id;
  final Value<String> horseID;
  final Value<Uint8List> photo;
  const HorseGalleryCompanion({
    this.id = const Value.absent(),
    this.horseID = const Value.absent(),
    this.photo = const Value.absent(),
  });
  HorseGalleryCompanion.insert({
    this.id = const Value.absent(),
    required String horseID,
    required Uint8List photo,
  })  : horseID = Value(horseID),
        photo = Value(photo);
  static Insertable<HorseGalleryData> custom({
    Expression<int>? id,
    Expression<String>? horseID,
    Expression<Uint8List>? photo,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (horseID != null) 'horse_i_d': horseID,
      if (photo != null) 'photo': photo,
    });
  }

  HorseGalleryCompanion copyWith(
      {Value<int>? id, Value<String>? horseID, Value<Uint8List>? photo}) {
    return HorseGalleryCompanion(
      id: id ?? this.id,
      horseID: horseID ?? this.horseID,
      photo: photo ?? this.photo,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (horseID.present) {
      map['horse_i_d'] = Variable<String>(horseID.value);
    }
    if (photo.present) {
      map['photo'] = Variable<Uint8List>(photo.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HorseGalleryCompanion(')
          ..write('id: $id, ')
          ..write('horseID: $horseID, ')
          ..write('photo: $photo')
          ..write(')'))
        .toString();
  }
}

class $HorseGalleryTable extends HorseGallery
    with TableInfo<$HorseGalleryTable, HorseGalleryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HorseGalleryTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _horseIDMeta = const VerificationMeta('horseID');
  @override
  late final GeneratedColumn<String?> horseID = GeneratedColumn<String?>(
      'horse_i_d', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _photoMeta = const VerificationMeta('photo');
  @override
  late final GeneratedColumn<Uint8List?> photo = GeneratedColumn<Uint8List?>(
      'photo', aliasedName, false,
      type: const BlobType(), requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, horseID, photo];
  @override
  String get aliasedName => _alias ?? 'horseGallery';
  @override
  String get actualTableName => 'horseGallery';
  @override
  VerificationContext validateIntegrity(Insertable<HorseGalleryData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('horse_i_d')) {
      context.handle(_horseIDMeta,
          horseID.isAcceptableOrUnknown(data['horse_i_d']!, _horseIDMeta));
    } else if (isInserting) {
      context.missing(_horseIDMeta);
    }
    if (data.containsKey('photo')) {
      context.handle(
          _photoMeta, photo.isAcceptableOrUnknown(data['photo']!, _photoMeta));
    } else if (isInserting) {
      context.missing(_photoMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HorseGalleryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    return HorseGalleryData.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $HorseGalleryTable createAlias(String alias) {
    return $HorseGalleryTable(attachedDatabase, alias);
  }
}

class EventGalleryData extends DataClass
    implements Insertable<EventGalleryData> {
  final int id;
  final int eventID;
  final Uint8List photo;
  EventGalleryData(
      {required this.id, required this.eventID, required this.photo});
  factory EventGalleryData.fromData(Map<String, dynamic> data,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return EventGalleryData(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      eventID: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}event_i_d'])!,
      photo: const BlobType()
          .mapFromDatabaseResponse(data['${effectivePrefix}photo'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['event_i_d'] = Variable<int>(eventID);
    map['photo'] = Variable<Uint8List>(photo);
    return map;
  }

  EventGalleryCompanion toCompanion(bool nullToAbsent) {
    return EventGalleryCompanion(
      id: Value(id),
      eventID: Value(eventID),
      photo: Value(photo),
    );
  }

  factory EventGalleryData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EventGalleryData(
      id: serializer.fromJson<int>(json['id']),
      eventID: serializer.fromJson<int>(json['eventID']),
      photo: serializer.fromJson<Uint8List>(json['photo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'eventID': serializer.toJson<int>(eventID),
      'photo': serializer.toJson<Uint8List>(photo),
    };
  }

  EventGalleryData copyWith({int? id, int? eventID, Uint8List? photo}) =>
      EventGalleryData(
        id: id ?? this.id,
        eventID: eventID ?? this.eventID,
        photo: photo ?? this.photo,
      );
  @override
  String toString() {
    return (StringBuffer('EventGalleryData(')
          ..write('id: $id, ')
          ..write('eventID: $eventID, ')
          ..write('photo: $photo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, eventID, photo);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EventGalleryData &&
          other.id == this.id &&
          other.eventID == this.eventID &&
          other.photo == this.photo);
}

class EventGalleryCompanion extends UpdateCompanion<EventGalleryData> {
  final Value<int> id;
  final Value<int> eventID;
  final Value<Uint8List> photo;
  const EventGalleryCompanion({
    this.id = const Value.absent(),
    this.eventID = const Value.absent(),
    this.photo = const Value.absent(),
  });
  EventGalleryCompanion.insert({
    this.id = const Value.absent(),
    required int eventID,
    required Uint8List photo,
  })  : eventID = Value(eventID),
        photo = Value(photo);
  static Insertable<EventGalleryData> custom({
    Expression<int>? id,
    Expression<int>? eventID,
    Expression<Uint8List>? photo,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (eventID != null) 'event_i_d': eventID,
      if (photo != null) 'photo': photo,
    });
  }

  EventGalleryCompanion copyWith(
      {Value<int>? id, Value<int>? eventID, Value<Uint8List>? photo}) {
    return EventGalleryCompanion(
      id: id ?? this.id,
      eventID: eventID ?? this.eventID,
      photo: photo ?? this.photo,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (eventID.present) {
      map['event_i_d'] = Variable<int>(eventID.value);
    }
    if (photo.present) {
      map['photo'] = Variable<Uint8List>(photo.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EventGalleryCompanion(')
          ..write('id: $id, ')
          ..write('eventID: $eventID, ')
          ..write('photo: $photo')
          ..write(')'))
        .toString();
  }
}

class $EventGalleryTable extends EventGallery
    with TableInfo<$EventGalleryTable, EventGalleryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EventGalleryTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _eventIDMeta = const VerificationMeta('eventID');
  @override
  late final GeneratedColumn<int?> eventID = GeneratedColumn<int?>(
      'event_i_d', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL REFERENCES events(id)');
  final VerificationMeta _photoMeta = const VerificationMeta('photo');
  @override
  late final GeneratedColumn<Uint8List?> photo = GeneratedColumn<Uint8List?>(
      'photo', aliasedName, false,
      type: const BlobType(), requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, eventID, photo];
  @override
  String get aliasedName => _alias ?? 'eventGallery';
  @override
  String get actualTableName => 'eventGallery';
  @override
  VerificationContext validateIntegrity(Insertable<EventGalleryData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('event_i_d')) {
      context.handle(_eventIDMeta,
          eventID.isAcceptableOrUnknown(data['event_i_d']!, _eventIDMeta));
    } else if (isInserting) {
      context.missing(_eventIDMeta);
    }
    if (data.containsKey('photo')) {
      context.handle(
          _photoMeta, photo.isAcceptableOrUnknown(data['photo']!, _photoMeta));
    } else if (isInserting) {
      context.missing(_photoMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EventGalleryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    return EventGalleryData.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $EventGalleryTable createAlias(String alias) {
    return $EventGalleryTable(attachedDatabase, alias);
  }
}

abstract class _$AppDb extends GeneratedDatabase {
  _$AppDb(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  late final $EventsTable events = $EventsTable(this);
  late final $HorsesTable horses = $HorsesTable(this);
  late final $OwnersTable owners = $OwnersTable(this);
  late final $HorseGalleryTable horseGallery = $HorseGalleryTable(this);
  late final $EventGalleryTable eventGallery = $EventGalleryTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [events, horses, owners, horseGallery, eventGallery];
}
