// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CoursesTableTable extends CoursesTable
    with TableInfo<$CoursesTableTable, CoursesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CoursesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _slugMeta = const VerificationMeta('slug');
  @override
  late final GeneratedColumn<String> slug = GeneratedColumn<String>(
    'slug',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<String> level = GeneratedColumn<String>(
    'level',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _trackTypeMeta = const VerificationMeta(
    'trackType',
  );
  @override
  late final GeneratedColumn<String> trackType = GeneratedColumn<String>(
    'track_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _thumbnailUrlMeta = const VerificationMeta(
    'thumbnailUrl',
  );
  @override
  late final GeneratedColumn<String> thumbnailUrl = GeneratedColumn<String>(
    'thumbnail_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _completedLessonsCountMeta =
      const VerificationMeta('completedLessonsCount');
  @override
  late final GeneratedColumn<int> completedLessonsCount = GeneratedColumn<int>(
    'completed_lessons_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalLessonsCountMeta = const VerificationMeta(
    'totalLessonsCount',
  );
  @override
  late final GeneratedColumn<int> totalLessonsCount = GeneratedColumn<int>(
    'total_lessons_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    slug,
    title,
    description,
    level,
    trackType,
    thumbnailUrl,
    version,
    completedLessonsCount,
    totalLessonsCount,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'courses_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<CoursesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('slug')) {
      context.handle(
        _slugMeta,
        slug.isAcceptableOrUnknown(data['slug']!, _slugMeta),
      );
    } else if (isInserting) {
      context.missing(_slugMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('level')) {
      context.handle(
        _levelMeta,
        level.isAcceptableOrUnknown(data['level']!, _levelMeta),
      );
    } else if (isInserting) {
      context.missing(_levelMeta);
    }
    if (data.containsKey('track_type')) {
      context.handle(
        _trackTypeMeta,
        trackType.isAcceptableOrUnknown(data['track_type']!, _trackTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_trackTypeMeta);
    }
    if (data.containsKey('thumbnail_url')) {
      context.handle(
        _thumbnailUrlMeta,
        thumbnailUrl.isAcceptableOrUnknown(
          data['thumbnail_url']!,
          _thumbnailUrlMeta,
        ),
      );
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('completed_lessons_count')) {
      context.handle(
        _completedLessonsCountMeta,
        completedLessonsCount.isAcceptableOrUnknown(
          data['completed_lessons_count']!,
          _completedLessonsCountMeta,
        ),
      );
    }
    if (data.containsKey('total_lessons_count')) {
      context.handle(
        _totalLessonsCountMeta,
        totalLessonsCount.isAcceptableOrUnknown(
          data['total_lessons_count']!,
          _totalLessonsCountMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CoursesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CoursesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      slug: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}slug'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      level: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}level'],
      )!,
      trackType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}track_type'],
      )!,
      thumbnailUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}thumbnail_url'],
      ),
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      completedLessonsCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}completed_lessons_count'],
      )!,
      totalLessonsCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_lessons_count'],
      )!,
    );
  }

  @override
  $CoursesTableTable createAlias(String alias) {
    return $CoursesTableTable(attachedDatabase, alias);
  }
}

class CoursesTableData extends DataClass
    implements Insertable<CoursesTableData> {
  final String id;
  final String slug;
  final String title;
  final String? description;
  final String level;
  final String trackType;
  final String? thumbnailUrl;
  final int version;
  final int completedLessonsCount;
  final int totalLessonsCount;
  const CoursesTableData({
    required this.id,
    required this.slug,
    required this.title,
    this.description,
    required this.level,
    required this.trackType,
    this.thumbnailUrl,
    required this.version,
    required this.completedLessonsCount,
    required this.totalLessonsCount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['slug'] = Variable<String>(slug);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['level'] = Variable<String>(level);
    map['track_type'] = Variable<String>(trackType);
    if (!nullToAbsent || thumbnailUrl != null) {
      map['thumbnail_url'] = Variable<String>(thumbnailUrl);
    }
    map['version'] = Variable<int>(version);
    map['completed_lessons_count'] = Variable<int>(completedLessonsCount);
    map['total_lessons_count'] = Variable<int>(totalLessonsCount);
    return map;
  }

  CoursesTableCompanion toCompanion(bool nullToAbsent) {
    return CoursesTableCompanion(
      id: Value(id),
      slug: Value(slug),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      level: Value(level),
      trackType: Value(trackType),
      thumbnailUrl: thumbnailUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(thumbnailUrl),
      version: Value(version),
      completedLessonsCount: Value(completedLessonsCount),
      totalLessonsCount: Value(totalLessonsCount),
    );
  }

  factory CoursesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CoursesTableData(
      id: serializer.fromJson<String>(json['id']),
      slug: serializer.fromJson<String>(json['slug']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      level: serializer.fromJson<String>(json['level']),
      trackType: serializer.fromJson<String>(json['trackType']),
      thumbnailUrl: serializer.fromJson<String?>(json['thumbnailUrl']),
      version: serializer.fromJson<int>(json['version']),
      completedLessonsCount: serializer.fromJson<int>(
        json['completedLessonsCount'],
      ),
      totalLessonsCount: serializer.fromJson<int>(json['totalLessonsCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'slug': serializer.toJson<String>(slug),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'level': serializer.toJson<String>(level),
      'trackType': serializer.toJson<String>(trackType),
      'thumbnailUrl': serializer.toJson<String?>(thumbnailUrl),
      'version': serializer.toJson<int>(version),
      'completedLessonsCount': serializer.toJson<int>(completedLessonsCount),
      'totalLessonsCount': serializer.toJson<int>(totalLessonsCount),
    };
  }

  CoursesTableData copyWith({
    String? id,
    String? slug,
    String? title,
    Value<String?> description = const Value.absent(),
    String? level,
    String? trackType,
    Value<String?> thumbnailUrl = const Value.absent(),
    int? version,
    int? completedLessonsCount,
    int? totalLessonsCount,
  }) => CoursesTableData(
    id: id ?? this.id,
    slug: slug ?? this.slug,
    title: title ?? this.title,
    description: description.present ? description.value : this.description,
    level: level ?? this.level,
    trackType: trackType ?? this.trackType,
    thumbnailUrl: thumbnailUrl.present ? thumbnailUrl.value : this.thumbnailUrl,
    version: version ?? this.version,
    completedLessonsCount: completedLessonsCount ?? this.completedLessonsCount,
    totalLessonsCount: totalLessonsCount ?? this.totalLessonsCount,
  );
  CoursesTableData copyWithCompanion(CoursesTableCompanion data) {
    return CoursesTableData(
      id: data.id.present ? data.id.value : this.id,
      slug: data.slug.present ? data.slug.value : this.slug,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      level: data.level.present ? data.level.value : this.level,
      trackType: data.trackType.present ? data.trackType.value : this.trackType,
      thumbnailUrl: data.thumbnailUrl.present
          ? data.thumbnailUrl.value
          : this.thumbnailUrl,
      version: data.version.present ? data.version.value : this.version,
      completedLessonsCount: data.completedLessonsCount.present
          ? data.completedLessonsCount.value
          : this.completedLessonsCount,
      totalLessonsCount: data.totalLessonsCount.present
          ? data.totalLessonsCount.value
          : this.totalLessonsCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CoursesTableData(')
          ..write('id: $id, ')
          ..write('slug: $slug, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('level: $level, ')
          ..write('trackType: $trackType, ')
          ..write('thumbnailUrl: $thumbnailUrl, ')
          ..write('version: $version, ')
          ..write('completedLessonsCount: $completedLessonsCount, ')
          ..write('totalLessonsCount: $totalLessonsCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    slug,
    title,
    description,
    level,
    trackType,
    thumbnailUrl,
    version,
    completedLessonsCount,
    totalLessonsCount,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CoursesTableData &&
          other.id == this.id &&
          other.slug == this.slug &&
          other.title == this.title &&
          other.description == this.description &&
          other.level == this.level &&
          other.trackType == this.trackType &&
          other.thumbnailUrl == this.thumbnailUrl &&
          other.version == this.version &&
          other.completedLessonsCount == this.completedLessonsCount &&
          other.totalLessonsCount == this.totalLessonsCount);
}

class CoursesTableCompanion extends UpdateCompanion<CoursesTableData> {
  final Value<String> id;
  final Value<String> slug;
  final Value<String> title;
  final Value<String?> description;
  final Value<String> level;
  final Value<String> trackType;
  final Value<String?> thumbnailUrl;
  final Value<int> version;
  final Value<int> completedLessonsCount;
  final Value<int> totalLessonsCount;
  final Value<int> rowid;
  const CoursesTableCompanion({
    this.id = const Value.absent(),
    this.slug = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.level = const Value.absent(),
    this.trackType = const Value.absent(),
    this.thumbnailUrl = const Value.absent(),
    this.version = const Value.absent(),
    this.completedLessonsCount = const Value.absent(),
    this.totalLessonsCount = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CoursesTableCompanion.insert({
    required String id,
    required String slug,
    required String title,
    this.description = const Value.absent(),
    required String level,
    required String trackType,
    this.thumbnailUrl = const Value.absent(),
    this.version = const Value.absent(),
    this.completedLessonsCount = const Value.absent(),
    this.totalLessonsCount = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       slug = Value(slug),
       title = Value(title),
       level = Value(level),
       trackType = Value(trackType);
  static Insertable<CoursesTableData> custom({
    Expression<String>? id,
    Expression<String>? slug,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? level,
    Expression<String>? trackType,
    Expression<String>? thumbnailUrl,
    Expression<int>? version,
    Expression<int>? completedLessonsCount,
    Expression<int>? totalLessonsCount,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (slug != null) 'slug': slug,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (level != null) 'level': level,
      if (trackType != null) 'track_type': trackType,
      if (thumbnailUrl != null) 'thumbnail_url': thumbnailUrl,
      if (version != null) 'version': version,
      if (completedLessonsCount != null)
        'completed_lessons_count': completedLessonsCount,
      if (totalLessonsCount != null) 'total_lessons_count': totalLessonsCount,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CoursesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? slug,
    Value<String>? title,
    Value<String?>? description,
    Value<String>? level,
    Value<String>? trackType,
    Value<String?>? thumbnailUrl,
    Value<int>? version,
    Value<int>? completedLessonsCount,
    Value<int>? totalLessonsCount,
    Value<int>? rowid,
  }) {
    return CoursesTableCompanion(
      id: id ?? this.id,
      slug: slug ?? this.slug,
      title: title ?? this.title,
      description: description ?? this.description,
      level: level ?? this.level,
      trackType: trackType ?? this.trackType,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      version: version ?? this.version,
      completedLessonsCount:
          completedLessonsCount ?? this.completedLessonsCount,
      totalLessonsCount: totalLessonsCount ?? this.totalLessonsCount,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (slug.present) {
      map['slug'] = Variable<String>(slug.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (level.present) {
      map['level'] = Variable<String>(level.value);
    }
    if (trackType.present) {
      map['track_type'] = Variable<String>(trackType.value);
    }
    if (thumbnailUrl.present) {
      map['thumbnail_url'] = Variable<String>(thumbnailUrl.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (completedLessonsCount.present) {
      map['completed_lessons_count'] = Variable<int>(
        completedLessonsCount.value,
      );
    }
    if (totalLessonsCount.present) {
      map['total_lessons_count'] = Variable<int>(totalLessonsCount.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CoursesTableCompanion(')
          ..write('id: $id, ')
          ..write('slug: $slug, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('level: $level, ')
          ..write('trackType: $trackType, ')
          ..write('thumbnailUrl: $thumbnailUrl, ')
          ..write('version: $version, ')
          ..write('completedLessonsCount: $completedLessonsCount, ')
          ..write('totalLessonsCount: $totalLessonsCount, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UnitsTableTable extends UnitsTable
    with TableInfo<$UnitsTableTable, UnitsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UnitsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _courseIdMeta = const VerificationMeta(
    'courseId',
  );
  @override
  late final GeneratedColumn<String> courseId = GeneratedColumn<String>(
    'course_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES courses_table (id)',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orderIndexMeta = const VerificationMeta(
    'orderIndex',
  );
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
    'order_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, courseId, title, orderIndex];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'units_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<UnitsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('course_id')) {
      context.handle(
        _courseIdMeta,
        courseId.isAcceptableOrUnknown(data['course_id']!, _courseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_courseIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('order_index')) {
      context.handle(
        _orderIndexMeta,
        orderIndex.isAcceptableOrUnknown(data['order_index']!, _orderIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIndexMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UnitsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UnitsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      courseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}course_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      orderIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_index'],
      )!,
    );
  }

  @override
  $UnitsTableTable createAlias(String alias) {
    return $UnitsTableTable(attachedDatabase, alias);
  }
}

class UnitsTableData extends DataClass implements Insertable<UnitsTableData> {
  final String id;
  final String courseId;
  final String title;
  final int orderIndex;
  const UnitsTableData({
    required this.id,
    required this.courseId,
    required this.title,
    required this.orderIndex,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['course_id'] = Variable<String>(courseId);
    map['title'] = Variable<String>(title);
    map['order_index'] = Variable<int>(orderIndex);
    return map;
  }

  UnitsTableCompanion toCompanion(bool nullToAbsent) {
    return UnitsTableCompanion(
      id: Value(id),
      courseId: Value(courseId),
      title: Value(title),
      orderIndex: Value(orderIndex),
    );
  }

  factory UnitsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UnitsTableData(
      id: serializer.fromJson<String>(json['id']),
      courseId: serializer.fromJson<String>(json['courseId']),
      title: serializer.fromJson<String>(json['title']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'courseId': serializer.toJson<String>(courseId),
      'title': serializer.toJson<String>(title),
      'orderIndex': serializer.toJson<int>(orderIndex),
    };
  }

  UnitsTableData copyWith({
    String? id,
    String? courseId,
    String? title,
    int? orderIndex,
  }) => UnitsTableData(
    id: id ?? this.id,
    courseId: courseId ?? this.courseId,
    title: title ?? this.title,
    orderIndex: orderIndex ?? this.orderIndex,
  );
  UnitsTableData copyWithCompanion(UnitsTableCompanion data) {
    return UnitsTableData(
      id: data.id.present ? data.id.value : this.id,
      courseId: data.courseId.present ? data.courseId.value : this.courseId,
      title: data.title.present ? data.title.value : this.title,
      orderIndex: data.orderIndex.present
          ? data.orderIndex.value
          : this.orderIndex,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UnitsTableData(')
          ..write('id: $id, ')
          ..write('courseId: $courseId, ')
          ..write('title: $title, ')
          ..write('orderIndex: $orderIndex')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, courseId, title, orderIndex);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UnitsTableData &&
          other.id == this.id &&
          other.courseId == this.courseId &&
          other.title == this.title &&
          other.orderIndex == this.orderIndex);
}

class UnitsTableCompanion extends UpdateCompanion<UnitsTableData> {
  final Value<String> id;
  final Value<String> courseId;
  final Value<String> title;
  final Value<int> orderIndex;
  final Value<int> rowid;
  const UnitsTableCompanion({
    this.id = const Value.absent(),
    this.courseId = const Value.absent(),
    this.title = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UnitsTableCompanion.insert({
    required String id,
    required String courseId,
    required String title,
    required int orderIndex,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       courseId = Value(courseId),
       title = Value(title),
       orderIndex = Value(orderIndex);
  static Insertable<UnitsTableData> custom({
    Expression<String>? id,
    Expression<String>? courseId,
    Expression<String>? title,
    Expression<int>? orderIndex,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (courseId != null) 'course_id': courseId,
      if (title != null) 'title': title,
      if (orderIndex != null) 'order_index': orderIndex,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UnitsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? courseId,
    Value<String>? title,
    Value<int>? orderIndex,
    Value<int>? rowid,
  }) {
    return UnitsTableCompanion(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      title: title ?? this.title,
      orderIndex: orderIndex ?? this.orderIndex,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (courseId.present) {
      map['course_id'] = Variable<String>(courseId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UnitsTableCompanion(')
          ..write('id: $id, ')
          ..write('courseId: $courseId, ')
          ..write('title: $title, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LessonsTableTable extends LessonsTable
    with TableInfo<$LessonsTableTable, LessonsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LessonsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitIdMeta = const VerificationMeta('unitId');
  @override
  late final GeneratedColumn<String> unitId = GeneratedColumn<String>(
    'unit_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES units_table (id)',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentTypeMeta = const VerificationMeta(
    'contentType',
  );
  @override
  late final GeneratedColumn<String> contentType = GeneratedColumn<String>(
    'content_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentJsonMeta = const VerificationMeta(
    'contentJson',
  );
  @override
  late final GeneratedColumn<String> contentJson = GeneratedColumn<String>(
    'content_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _orderIndexMeta = const VerificationMeta(
    'orderIndex',
  );
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
    'order_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    unitId,
    title,
    contentType,
    contentJson,
    orderIndex,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lessons_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<LessonsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('unit_id')) {
      context.handle(
        _unitIdMeta,
        unitId.isAcceptableOrUnknown(data['unit_id']!, _unitIdMeta),
      );
    } else if (isInserting) {
      context.missing(_unitIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('content_type')) {
      context.handle(
        _contentTypeMeta,
        contentType.isAcceptableOrUnknown(
          data['content_type']!,
          _contentTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_contentTypeMeta);
    }
    if (data.containsKey('content_json')) {
      context.handle(
        _contentJsonMeta,
        contentJson.isAcceptableOrUnknown(
          data['content_json']!,
          _contentJsonMeta,
        ),
      );
    }
    if (data.containsKey('order_index')) {
      context.handle(
        _orderIndexMeta,
        orderIndex.isAcceptableOrUnknown(data['order_index']!, _orderIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIndexMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LessonsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LessonsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      unitId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      contentType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content_type'],
      )!,
      contentJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content_json'],
      ),
      orderIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_index'],
      )!,
    );
  }

  @override
  $LessonsTableTable createAlias(String alias) {
    return $LessonsTableTable(attachedDatabase, alias);
  }
}

class LessonsTableData extends DataClass
    implements Insertable<LessonsTableData> {
  final String id;
  final String unitId;
  final String title;
  final String contentType;
  final String? contentJson;
  final int orderIndex;
  const LessonsTableData({
    required this.id,
    required this.unitId,
    required this.title,
    required this.contentType,
    this.contentJson,
    required this.orderIndex,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['unit_id'] = Variable<String>(unitId);
    map['title'] = Variable<String>(title);
    map['content_type'] = Variable<String>(contentType);
    if (!nullToAbsent || contentJson != null) {
      map['content_json'] = Variable<String>(contentJson);
    }
    map['order_index'] = Variable<int>(orderIndex);
    return map;
  }

  LessonsTableCompanion toCompanion(bool nullToAbsent) {
    return LessonsTableCompanion(
      id: Value(id),
      unitId: Value(unitId),
      title: Value(title),
      contentType: Value(contentType),
      contentJson: contentJson == null && nullToAbsent
          ? const Value.absent()
          : Value(contentJson),
      orderIndex: Value(orderIndex),
    );
  }

  factory LessonsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LessonsTableData(
      id: serializer.fromJson<String>(json['id']),
      unitId: serializer.fromJson<String>(json['unitId']),
      title: serializer.fromJson<String>(json['title']),
      contentType: serializer.fromJson<String>(json['contentType']),
      contentJson: serializer.fromJson<String?>(json['contentJson']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'unitId': serializer.toJson<String>(unitId),
      'title': serializer.toJson<String>(title),
      'contentType': serializer.toJson<String>(contentType),
      'contentJson': serializer.toJson<String?>(contentJson),
      'orderIndex': serializer.toJson<int>(orderIndex),
    };
  }

  LessonsTableData copyWith({
    String? id,
    String? unitId,
    String? title,
    String? contentType,
    Value<String?> contentJson = const Value.absent(),
    int? orderIndex,
  }) => LessonsTableData(
    id: id ?? this.id,
    unitId: unitId ?? this.unitId,
    title: title ?? this.title,
    contentType: contentType ?? this.contentType,
    contentJson: contentJson.present ? contentJson.value : this.contentJson,
    orderIndex: orderIndex ?? this.orderIndex,
  );
  LessonsTableData copyWithCompanion(LessonsTableCompanion data) {
    return LessonsTableData(
      id: data.id.present ? data.id.value : this.id,
      unitId: data.unitId.present ? data.unitId.value : this.unitId,
      title: data.title.present ? data.title.value : this.title,
      contentType: data.contentType.present
          ? data.contentType.value
          : this.contentType,
      contentJson: data.contentJson.present
          ? data.contentJson.value
          : this.contentJson,
      orderIndex: data.orderIndex.present
          ? data.orderIndex.value
          : this.orderIndex,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LessonsTableData(')
          ..write('id: $id, ')
          ..write('unitId: $unitId, ')
          ..write('title: $title, ')
          ..write('contentType: $contentType, ')
          ..write('contentJson: $contentJson, ')
          ..write('orderIndex: $orderIndex')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, unitId, title, contentType, contentJson, orderIndex);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LessonsTableData &&
          other.id == this.id &&
          other.unitId == this.unitId &&
          other.title == this.title &&
          other.contentType == this.contentType &&
          other.contentJson == this.contentJson &&
          other.orderIndex == this.orderIndex);
}

class LessonsTableCompanion extends UpdateCompanion<LessonsTableData> {
  final Value<String> id;
  final Value<String> unitId;
  final Value<String> title;
  final Value<String> contentType;
  final Value<String?> contentJson;
  final Value<int> orderIndex;
  final Value<int> rowid;
  const LessonsTableCompanion({
    this.id = const Value.absent(),
    this.unitId = const Value.absent(),
    this.title = const Value.absent(),
    this.contentType = const Value.absent(),
    this.contentJson = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LessonsTableCompanion.insert({
    required String id,
    required String unitId,
    required String title,
    required String contentType,
    this.contentJson = const Value.absent(),
    required int orderIndex,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       unitId = Value(unitId),
       title = Value(title),
       contentType = Value(contentType),
       orderIndex = Value(orderIndex);
  static Insertable<LessonsTableData> custom({
    Expression<String>? id,
    Expression<String>? unitId,
    Expression<String>? title,
    Expression<String>? contentType,
    Expression<String>? contentJson,
    Expression<int>? orderIndex,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (unitId != null) 'unit_id': unitId,
      if (title != null) 'title': title,
      if (contentType != null) 'content_type': contentType,
      if (contentJson != null) 'content_json': contentJson,
      if (orderIndex != null) 'order_index': orderIndex,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LessonsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? unitId,
    Value<String>? title,
    Value<String>? contentType,
    Value<String?>? contentJson,
    Value<int>? orderIndex,
    Value<int>? rowid,
  }) {
    return LessonsTableCompanion(
      id: id ?? this.id,
      unitId: unitId ?? this.unitId,
      title: title ?? this.title,
      contentType: contentType ?? this.contentType,
      contentJson: contentJson ?? this.contentJson,
      orderIndex: orderIndex ?? this.orderIndex,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (unitId.present) {
      map['unit_id'] = Variable<String>(unitId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (contentType.present) {
      map['content_type'] = Variable<String>(contentType.value);
    }
    if (contentJson.present) {
      map['content_json'] = Variable<String>(contentJson.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LessonsTableCompanion(')
          ..write('id: $id, ')
          ..write('unitId: $unitId, ')
          ..write('title: $title, ')
          ..write('contentType: $contentType, ')
          ..write('contentJson: $contentJson, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalProgressTableTable extends LocalProgressTable
    with TableInfo<$LocalProgressTableTable, LocalProgressTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalProgressTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _lessonIdMeta = const VerificationMeta(
    'lessonId',
  );
  @override
  late final GeneratedColumn<String> lessonId = GeneratedColumn<String>(
    'lesson_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES lessons_table (id)',
    ),
  );
  static const VerificationMeta _isCompletedMeta = const VerificationMeta(
    'isCompleted',
  );
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
    'is_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<int> score = GeneratedColumn<int>(
    'score',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastUpdatedMeta = const VerificationMeta(
    'lastUpdated',
  );
  @override
  late final GeneratedColumn<DateTime> lastUpdated = GeneratedColumn<DateTime>(
    'last_updated',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    lessonId,
    isCompleted,
    score,
    lastUpdated,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_progress_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalProgressTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('lesson_id')) {
      context.handle(
        _lessonIdMeta,
        lessonId.isAcceptableOrUnknown(data['lesson_id']!, _lessonIdMeta),
      );
    } else if (isInserting) {
      context.missing(_lessonIdMeta);
    }
    if (data.containsKey('is_completed')) {
      context.handle(
        _isCompletedMeta,
        isCompleted.isAcceptableOrUnknown(
          data['is_completed']!,
          _isCompletedMeta,
        ),
      );
    }
    if (data.containsKey('score')) {
      context.handle(
        _scoreMeta,
        score.isAcceptableOrUnknown(data['score']!, _scoreMeta),
      );
    }
    if (data.containsKey('last_updated')) {
      context.handle(
        _lastUpdatedMeta,
        lastUpdated.isAcceptableOrUnknown(
          data['last_updated']!,
          _lastUpdatedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {lessonId};
  @override
  LocalProgressTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalProgressTableData(
      lessonId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lesson_id'],
      )!,
      isCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_completed'],
      )!,
      score: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}score'],
      ),
      lastUpdated: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_updated'],
      )!,
    );
  }

  @override
  $LocalProgressTableTable createAlias(String alias) {
    return $LocalProgressTableTable(attachedDatabase, alias);
  }
}

class LocalProgressTableData extends DataClass
    implements Insertable<LocalProgressTableData> {
  final String lessonId;
  final bool isCompleted;
  final int? score;
  final DateTime lastUpdated;
  const LocalProgressTableData({
    required this.lessonId,
    required this.isCompleted,
    this.score,
    required this.lastUpdated,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['lesson_id'] = Variable<String>(lessonId);
    map['is_completed'] = Variable<bool>(isCompleted);
    if (!nullToAbsent || score != null) {
      map['score'] = Variable<int>(score);
    }
    map['last_updated'] = Variable<DateTime>(lastUpdated);
    return map;
  }

  LocalProgressTableCompanion toCompanion(bool nullToAbsent) {
    return LocalProgressTableCompanion(
      lessonId: Value(lessonId),
      isCompleted: Value(isCompleted),
      score: score == null && nullToAbsent
          ? const Value.absent()
          : Value(score),
      lastUpdated: Value(lastUpdated),
    );
  }

  factory LocalProgressTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalProgressTableData(
      lessonId: serializer.fromJson<String>(json['lessonId']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      score: serializer.fromJson<int?>(json['score']),
      lastUpdated: serializer.fromJson<DateTime>(json['lastUpdated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'lessonId': serializer.toJson<String>(lessonId),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'score': serializer.toJson<int?>(score),
      'lastUpdated': serializer.toJson<DateTime>(lastUpdated),
    };
  }

  LocalProgressTableData copyWith({
    String? lessonId,
    bool? isCompleted,
    Value<int?> score = const Value.absent(),
    DateTime? lastUpdated,
  }) => LocalProgressTableData(
    lessonId: lessonId ?? this.lessonId,
    isCompleted: isCompleted ?? this.isCompleted,
    score: score.present ? score.value : this.score,
    lastUpdated: lastUpdated ?? this.lastUpdated,
  );
  LocalProgressTableData copyWithCompanion(LocalProgressTableCompanion data) {
    return LocalProgressTableData(
      lessonId: data.lessonId.present ? data.lessonId.value : this.lessonId,
      isCompleted: data.isCompleted.present
          ? data.isCompleted.value
          : this.isCompleted,
      score: data.score.present ? data.score.value : this.score,
      lastUpdated: data.lastUpdated.present
          ? data.lastUpdated.value
          : this.lastUpdated,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalProgressTableData(')
          ..write('lessonId: $lessonId, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('score: $score, ')
          ..write('lastUpdated: $lastUpdated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(lessonId, isCompleted, score, lastUpdated);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalProgressTableData &&
          other.lessonId == this.lessonId &&
          other.isCompleted == this.isCompleted &&
          other.score == this.score &&
          other.lastUpdated == this.lastUpdated);
}

class LocalProgressTableCompanion
    extends UpdateCompanion<LocalProgressTableData> {
  final Value<String> lessonId;
  final Value<bool> isCompleted;
  final Value<int?> score;
  final Value<DateTime> lastUpdated;
  final Value<int> rowid;
  const LocalProgressTableCompanion({
    this.lessonId = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.score = const Value.absent(),
    this.lastUpdated = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalProgressTableCompanion.insert({
    required String lessonId,
    this.isCompleted = const Value.absent(),
    this.score = const Value.absent(),
    this.lastUpdated = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : lessonId = Value(lessonId);
  static Insertable<LocalProgressTableData> custom({
    Expression<String>? lessonId,
    Expression<bool>? isCompleted,
    Expression<int>? score,
    Expression<DateTime>? lastUpdated,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (lessonId != null) 'lesson_id': lessonId,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (score != null) 'score': score,
      if (lastUpdated != null) 'last_updated': lastUpdated,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalProgressTableCompanion copyWith({
    Value<String>? lessonId,
    Value<bool>? isCompleted,
    Value<int?>? score,
    Value<DateTime>? lastUpdated,
    Value<int>? rowid,
  }) {
    return LocalProgressTableCompanion(
      lessonId: lessonId ?? this.lessonId,
      isCompleted: isCompleted ?? this.isCompleted,
      score: score ?? this.score,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (lessonId.present) {
      map['lesson_id'] = Variable<String>(lessonId.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (score.present) {
      map['score'] = Variable<int>(score.value);
    }
    if (lastUpdated.present) {
      map['last_updated'] = Variable<DateTime>(lastUpdated.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalProgressTableCompanion(')
          ..write('lessonId: $lessonId, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('score: $score, ')
          ..write('lastUpdated: $lastUpdated, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PendingRequestsTableTable extends PendingRequestsTable
    with TableInfo<$PendingRequestsTableTable, PendingRequestsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PendingRequestsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
    'url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _methodMeta = const VerificationMeta('method');
  @override
  late final GeneratedColumn<String> method = GeneratedColumn<String>(
    'method',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dataJsonMeta = const VerificationMeta(
    'dataJson',
  );
  @override
  late final GeneratedColumn<String> dataJson = GeneratedColumn<String>(
    'data_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, url, method, dataJson, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pending_requests_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<PendingRequestsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('url')) {
      context.handle(
        _urlMeta,
        url.isAcceptableOrUnknown(data['url']!, _urlMeta),
      );
    } else if (isInserting) {
      context.missing(_urlMeta);
    }
    if (data.containsKey('method')) {
      context.handle(
        _methodMeta,
        method.isAcceptableOrUnknown(data['method']!, _methodMeta),
      );
    } else if (isInserting) {
      context.missing(_methodMeta);
    }
    if (data.containsKey('data_json')) {
      context.handle(
        _dataJsonMeta,
        dataJson.isAcceptableOrUnknown(data['data_json']!, _dataJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_dataJsonMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PendingRequestsTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PendingRequestsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      url: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}url'],
      )!,
      method: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}method'],
      )!,
      dataJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}data_json'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $PendingRequestsTableTable createAlias(String alias) {
    return $PendingRequestsTableTable(attachedDatabase, alias);
  }
}

class PendingRequestsTableData extends DataClass
    implements Insertable<PendingRequestsTableData> {
  final int id;
  final String url;
  final String method;
  final String dataJson;
  final DateTime createdAt;
  const PendingRequestsTableData({
    required this.id,
    required this.url,
    required this.method,
    required this.dataJson,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['url'] = Variable<String>(url);
    map['method'] = Variable<String>(method);
    map['data_json'] = Variable<String>(dataJson);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PendingRequestsTableCompanion toCompanion(bool nullToAbsent) {
    return PendingRequestsTableCompanion(
      id: Value(id),
      url: Value(url),
      method: Value(method),
      dataJson: Value(dataJson),
      createdAt: Value(createdAt),
    );
  }

  factory PendingRequestsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PendingRequestsTableData(
      id: serializer.fromJson<int>(json['id']),
      url: serializer.fromJson<String>(json['url']),
      method: serializer.fromJson<String>(json['method']),
      dataJson: serializer.fromJson<String>(json['dataJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'url': serializer.toJson<String>(url),
      'method': serializer.toJson<String>(method),
      'dataJson': serializer.toJson<String>(dataJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  PendingRequestsTableData copyWith({
    int? id,
    String? url,
    String? method,
    String? dataJson,
    DateTime? createdAt,
  }) => PendingRequestsTableData(
    id: id ?? this.id,
    url: url ?? this.url,
    method: method ?? this.method,
    dataJson: dataJson ?? this.dataJson,
    createdAt: createdAt ?? this.createdAt,
  );
  PendingRequestsTableData copyWithCompanion(
    PendingRequestsTableCompanion data,
  ) {
    return PendingRequestsTableData(
      id: data.id.present ? data.id.value : this.id,
      url: data.url.present ? data.url.value : this.url,
      method: data.method.present ? data.method.value : this.method,
      dataJson: data.dataJson.present ? data.dataJson.value : this.dataJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PendingRequestsTableData(')
          ..write('id: $id, ')
          ..write('url: $url, ')
          ..write('method: $method, ')
          ..write('dataJson: $dataJson, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, url, method, dataJson, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PendingRequestsTableData &&
          other.id == this.id &&
          other.url == this.url &&
          other.method == this.method &&
          other.dataJson == this.dataJson &&
          other.createdAt == this.createdAt);
}

class PendingRequestsTableCompanion
    extends UpdateCompanion<PendingRequestsTableData> {
  final Value<int> id;
  final Value<String> url;
  final Value<String> method;
  final Value<String> dataJson;
  final Value<DateTime> createdAt;
  const PendingRequestsTableCompanion({
    this.id = const Value.absent(),
    this.url = const Value.absent(),
    this.method = const Value.absent(),
    this.dataJson = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  PendingRequestsTableCompanion.insert({
    this.id = const Value.absent(),
    required String url,
    required String method,
    required String dataJson,
    this.createdAt = const Value.absent(),
  }) : url = Value(url),
       method = Value(method),
       dataJson = Value(dataJson);
  static Insertable<PendingRequestsTableData> custom({
    Expression<int>? id,
    Expression<String>? url,
    Expression<String>? method,
    Expression<String>? dataJson,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (url != null) 'url': url,
      if (method != null) 'method': method,
      if (dataJson != null) 'data_json': dataJson,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  PendingRequestsTableCompanion copyWith({
    Value<int>? id,
    Value<String>? url,
    Value<String>? method,
    Value<String>? dataJson,
    Value<DateTime>? createdAt,
  }) {
    return PendingRequestsTableCompanion(
      id: id ?? this.id,
      url: url ?? this.url,
      method: method ?? this.method,
      dataJson: dataJson ?? this.dataJson,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (method.present) {
      map['method'] = Variable<String>(method.value);
    }
    if (dataJson.present) {
      map['data_json'] = Variable<String>(dataJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PendingRequestsTableCompanion(')
          ..write('id: $id, ')
          ..write('url: $url, ')
          ..write('method: $method, ')
          ..write('dataJson: $dataJson, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CoursesTableTable coursesTable = $CoursesTableTable(this);
  late final $UnitsTableTable unitsTable = $UnitsTableTable(this);
  late final $LessonsTableTable lessonsTable = $LessonsTableTable(this);
  late final $LocalProgressTableTable localProgressTable =
      $LocalProgressTableTable(this);
  late final $PendingRequestsTableTable pendingRequestsTable =
      $PendingRequestsTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    coursesTable,
    unitsTable,
    lessonsTable,
    localProgressTable,
    pendingRequestsTable,
  ];
}

typedef $$CoursesTableTableCreateCompanionBuilder =
    CoursesTableCompanion Function({
      required String id,
      required String slug,
      required String title,
      Value<String?> description,
      required String level,
      required String trackType,
      Value<String?> thumbnailUrl,
      Value<int> version,
      Value<int> completedLessonsCount,
      Value<int> totalLessonsCount,
      Value<int> rowid,
    });
typedef $$CoursesTableTableUpdateCompanionBuilder =
    CoursesTableCompanion Function({
      Value<String> id,
      Value<String> slug,
      Value<String> title,
      Value<String?> description,
      Value<String> level,
      Value<String> trackType,
      Value<String?> thumbnailUrl,
      Value<int> version,
      Value<int> completedLessonsCount,
      Value<int> totalLessonsCount,
      Value<int> rowid,
    });

final class $$CoursesTableTableReferences
    extends
        BaseReferences<_$AppDatabase, $CoursesTableTable, CoursesTableData> {
  $$CoursesTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$UnitsTableTable, List<UnitsTableData>>
  _unitsTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.unitsTable,
    aliasName: $_aliasNameGenerator(db.coursesTable.id, db.unitsTable.courseId),
  );

  $$UnitsTableTableProcessedTableManager get unitsTableRefs {
    final manager = $$UnitsTableTableTableManager(
      $_db,
      $_db.unitsTable,
    ).filter((f) => f.courseId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_unitsTableRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CoursesTableTableFilterComposer
    extends Composer<_$AppDatabase, $CoursesTableTable> {
  $$CoursesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get slug => $composableBuilder(
    column: $table.slug,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get trackType => $composableBuilder(
    column: $table.trackType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get thumbnailUrl => $composableBuilder(
    column: $table.thumbnailUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get completedLessonsCount => $composableBuilder(
    column: $table.completedLessonsCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalLessonsCount => $composableBuilder(
    column: $table.totalLessonsCount,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> unitsTableRefs(
    Expression<bool> Function($$UnitsTableTableFilterComposer f) f,
  ) {
    final $$UnitsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.unitsTable,
      getReferencedColumn: (t) => t.courseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UnitsTableTableFilterComposer(
            $db: $db,
            $table: $db.unitsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CoursesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CoursesTableTable> {
  $$CoursesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get slug => $composableBuilder(
    column: $table.slug,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get trackType => $composableBuilder(
    column: $table.trackType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get thumbnailUrl => $composableBuilder(
    column: $table.thumbnailUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get completedLessonsCount => $composableBuilder(
    column: $table.completedLessonsCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalLessonsCount => $composableBuilder(
    column: $table.totalLessonsCount,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CoursesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CoursesTableTable> {
  $$CoursesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get slug =>
      $composableBuilder(column: $table.slug, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<String> get trackType =>
      $composableBuilder(column: $table.trackType, builder: (column) => column);

  GeneratedColumn<String> get thumbnailUrl => $composableBuilder(
    column: $table.thumbnailUrl,
    builder: (column) => column,
  );

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<int> get completedLessonsCount => $composableBuilder(
    column: $table.completedLessonsCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalLessonsCount => $composableBuilder(
    column: $table.totalLessonsCount,
    builder: (column) => column,
  );

  Expression<T> unitsTableRefs<T extends Object>(
    Expression<T> Function($$UnitsTableTableAnnotationComposer a) f,
  ) {
    final $$UnitsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.unitsTable,
      getReferencedColumn: (t) => t.courseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UnitsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.unitsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CoursesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CoursesTableTable,
          CoursesTableData,
          $$CoursesTableTableFilterComposer,
          $$CoursesTableTableOrderingComposer,
          $$CoursesTableTableAnnotationComposer,
          $$CoursesTableTableCreateCompanionBuilder,
          $$CoursesTableTableUpdateCompanionBuilder,
          (CoursesTableData, $$CoursesTableTableReferences),
          CoursesTableData,
          PrefetchHooks Function({bool unitsTableRefs})
        > {
  $$CoursesTableTableTableManager(_$AppDatabase db, $CoursesTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CoursesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CoursesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CoursesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> slug = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String> level = const Value.absent(),
                Value<String> trackType = const Value.absent(),
                Value<String?> thumbnailUrl = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int> completedLessonsCount = const Value.absent(),
                Value<int> totalLessonsCount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CoursesTableCompanion(
                id: id,
                slug: slug,
                title: title,
                description: description,
                level: level,
                trackType: trackType,
                thumbnailUrl: thumbnailUrl,
                version: version,
                completedLessonsCount: completedLessonsCount,
                totalLessonsCount: totalLessonsCount,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String slug,
                required String title,
                Value<String?> description = const Value.absent(),
                required String level,
                required String trackType,
                Value<String?> thumbnailUrl = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int> completedLessonsCount = const Value.absent(),
                Value<int> totalLessonsCount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CoursesTableCompanion.insert(
                id: id,
                slug: slug,
                title: title,
                description: description,
                level: level,
                trackType: trackType,
                thumbnailUrl: thumbnailUrl,
                version: version,
                completedLessonsCount: completedLessonsCount,
                totalLessonsCount: totalLessonsCount,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CoursesTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({unitsTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (unitsTableRefs) db.unitsTable],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (unitsTableRefs)
                    await $_getPrefetchedData<
                      CoursesTableData,
                      $CoursesTableTable,
                      UnitsTableData
                    >(
                      currentTable: table,
                      referencedTable: $$CoursesTableTableReferences
                          ._unitsTableRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$CoursesTableTableReferences(
                            db,
                            table,
                            p0,
                          ).unitsTableRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.courseId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CoursesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CoursesTableTable,
      CoursesTableData,
      $$CoursesTableTableFilterComposer,
      $$CoursesTableTableOrderingComposer,
      $$CoursesTableTableAnnotationComposer,
      $$CoursesTableTableCreateCompanionBuilder,
      $$CoursesTableTableUpdateCompanionBuilder,
      (CoursesTableData, $$CoursesTableTableReferences),
      CoursesTableData,
      PrefetchHooks Function({bool unitsTableRefs})
    >;
typedef $$UnitsTableTableCreateCompanionBuilder =
    UnitsTableCompanion Function({
      required String id,
      required String courseId,
      required String title,
      required int orderIndex,
      Value<int> rowid,
    });
typedef $$UnitsTableTableUpdateCompanionBuilder =
    UnitsTableCompanion Function({
      Value<String> id,
      Value<String> courseId,
      Value<String> title,
      Value<int> orderIndex,
      Value<int> rowid,
    });

final class $$UnitsTableTableReferences
    extends BaseReferences<_$AppDatabase, $UnitsTableTable, UnitsTableData> {
  $$UnitsTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CoursesTableTable _courseIdTable(_$AppDatabase db) =>
      db.coursesTable.createAlias(
        $_aliasNameGenerator(db.unitsTable.courseId, db.coursesTable.id),
      );

  $$CoursesTableTableProcessedTableManager get courseId {
    final $_column = $_itemColumn<String>('course_id')!;

    final manager = $$CoursesTableTableTableManager(
      $_db,
      $_db.coursesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_courseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$LessonsTableTable, List<LessonsTableData>>
  _lessonsTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.lessonsTable,
    aliasName: $_aliasNameGenerator(db.unitsTable.id, db.lessonsTable.unitId),
  );

  $$LessonsTableTableProcessedTableManager get lessonsTableRefs {
    final manager = $$LessonsTableTableTableManager(
      $_db,
      $_db.lessonsTable,
    ).filter((f) => f.unitId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_lessonsTableRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$UnitsTableTableFilterComposer
    extends Composer<_$AppDatabase, $UnitsTableTable> {
  $$UnitsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnFilters(column),
  );

  $$CoursesTableTableFilterComposer get courseId {
    final $$CoursesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.courseId,
      referencedTable: $db.coursesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CoursesTableTableFilterComposer(
            $db: $db,
            $table: $db.coursesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> lessonsTableRefs(
    Expression<bool> Function($$LessonsTableTableFilterComposer f) f,
  ) {
    final $$LessonsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.lessonsTable,
      getReferencedColumn: (t) => t.unitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LessonsTableTableFilterComposer(
            $db: $db,
            $table: $db.lessonsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UnitsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $UnitsTableTable> {
  $$UnitsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnOrderings(column),
  );

  $$CoursesTableTableOrderingComposer get courseId {
    final $$CoursesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.courseId,
      referencedTable: $db.coursesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CoursesTableTableOrderingComposer(
            $db: $db,
            $table: $db.coursesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UnitsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $UnitsTableTable> {
  $$UnitsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => column,
  );

  $$CoursesTableTableAnnotationComposer get courseId {
    final $$CoursesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.courseId,
      referencedTable: $db.coursesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CoursesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.coursesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> lessonsTableRefs<T extends Object>(
    Expression<T> Function($$LessonsTableTableAnnotationComposer a) f,
  ) {
    final $$LessonsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.lessonsTable,
      getReferencedColumn: (t) => t.unitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LessonsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.lessonsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UnitsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UnitsTableTable,
          UnitsTableData,
          $$UnitsTableTableFilterComposer,
          $$UnitsTableTableOrderingComposer,
          $$UnitsTableTableAnnotationComposer,
          $$UnitsTableTableCreateCompanionBuilder,
          $$UnitsTableTableUpdateCompanionBuilder,
          (UnitsTableData, $$UnitsTableTableReferences),
          UnitsTableData,
          PrefetchHooks Function({bool courseId, bool lessonsTableRefs})
        > {
  $$UnitsTableTableTableManager(_$AppDatabase db, $UnitsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UnitsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UnitsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UnitsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> courseId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UnitsTableCompanion(
                id: id,
                courseId: courseId,
                title: title,
                orderIndex: orderIndex,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String courseId,
                required String title,
                required int orderIndex,
                Value<int> rowid = const Value.absent(),
              }) => UnitsTableCompanion.insert(
                id: id,
                courseId: courseId,
                title: title,
                orderIndex: orderIndex,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$UnitsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({courseId = false, lessonsTableRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (lessonsTableRefs) db.lessonsTable,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (courseId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.courseId,
                                    referencedTable: $$UnitsTableTableReferences
                                        ._courseIdTable(db),
                                    referencedColumn:
                                        $$UnitsTableTableReferences
                                            ._courseIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (lessonsTableRefs)
                        await $_getPrefetchedData<
                          UnitsTableData,
                          $UnitsTableTable,
                          LessonsTableData
                        >(
                          currentTable: table,
                          referencedTable: $$UnitsTableTableReferences
                              ._lessonsTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UnitsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).lessonsTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.unitId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$UnitsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UnitsTableTable,
      UnitsTableData,
      $$UnitsTableTableFilterComposer,
      $$UnitsTableTableOrderingComposer,
      $$UnitsTableTableAnnotationComposer,
      $$UnitsTableTableCreateCompanionBuilder,
      $$UnitsTableTableUpdateCompanionBuilder,
      (UnitsTableData, $$UnitsTableTableReferences),
      UnitsTableData,
      PrefetchHooks Function({bool courseId, bool lessonsTableRefs})
    >;
typedef $$LessonsTableTableCreateCompanionBuilder =
    LessonsTableCompanion Function({
      required String id,
      required String unitId,
      required String title,
      required String contentType,
      Value<String?> contentJson,
      required int orderIndex,
      Value<int> rowid,
    });
typedef $$LessonsTableTableUpdateCompanionBuilder =
    LessonsTableCompanion Function({
      Value<String> id,
      Value<String> unitId,
      Value<String> title,
      Value<String> contentType,
      Value<String?> contentJson,
      Value<int> orderIndex,
      Value<int> rowid,
    });

final class $$LessonsTableTableReferences
    extends
        BaseReferences<_$AppDatabase, $LessonsTableTable, LessonsTableData> {
  $$LessonsTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UnitsTableTable _unitIdTable(_$AppDatabase db) =>
      db.unitsTable.createAlias(
        $_aliasNameGenerator(db.lessonsTable.unitId, db.unitsTable.id),
      );

  $$UnitsTableTableProcessedTableManager get unitId {
    final $_column = $_itemColumn<String>('unit_id')!;

    final manager = $$UnitsTableTableTableManager(
      $_db,
      $_db.unitsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_unitIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $LocalProgressTableTable,
    List<LocalProgressTableData>
  >
  _localProgressTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.localProgressTable,
        aliasName: $_aliasNameGenerator(
          db.lessonsTable.id,
          db.localProgressTable.lessonId,
        ),
      );

  $$LocalProgressTableTableProcessedTableManager get localProgressTableRefs {
    final manager = $$LocalProgressTableTableTableManager(
      $_db,
      $_db.localProgressTable,
    ).filter((f) => f.lessonId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _localProgressTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$LessonsTableTableFilterComposer
    extends Composer<_$AppDatabase, $LessonsTableTable> {
  $$LessonsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contentType => $composableBuilder(
    column: $table.contentType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contentJson => $composableBuilder(
    column: $table.contentJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnFilters(column),
  );

  $$UnitsTableTableFilterComposer get unitId {
    final $$UnitsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.unitId,
      referencedTable: $db.unitsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UnitsTableTableFilterComposer(
            $db: $db,
            $table: $db.unitsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> localProgressTableRefs(
    Expression<bool> Function($$LocalProgressTableTableFilterComposer f) f,
  ) {
    final $$LocalProgressTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.localProgressTable,
      getReferencedColumn: (t) => t.lessonId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocalProgressTableTableFilterComposer(
            $db: $db,
            $table: $db.localProgressTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LessonsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $LessonsTableTable> {
  $$LessonsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contentType => $composableBuilder(
    column: $table.contentType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contentJson => $composableBuilder(
    column: $table.contentJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnOrderings(column),
  );

  $$UnitsTableTableOrderingComposer get unitId {
    final $$UnitsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.unitId,
      referencedTable: $db.unitsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UnitsTableTableOrderingComposer(
            $db: $db,
            $table: $db.unitsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LessonsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $LessonsTableTable> {
  $$LessonsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get contentType => $composableBuilder(
    column: $table.contentType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get contentJson => $composableBuilder(
    column: $table.contentJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => column,
  );

  $$UnitsTableTableAnnotationComposer get unitId {
    final $$UnitsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.unitId,
      referencedTable: $db.unitsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UnitsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.unitsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> localProgressTableRefs<T extends Object>(
    Expression<T> Function($$LocalProgressTableTableAnnotationComposer a) f,
  ) {
    final $$LocalProgressTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.localProgressTable,
          getReferencedColumn: (t) => t.lessonId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$LocalProgressTableTableAnnotationComposer(
                $db: $db,
                $table: $db.localProgressTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$LessonsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LessonsTableTable,
          LessonsTableData,
          $$LessonsTableTableFilterComposer,
          $$LessonsTableTableOrderingComposer,
          $$LessonsTableTableAnnotationComposer,
          $$LessonsTableTableCreateCompanionBuilder,
          $$LessonsTableTableUpdateCompanionBuilder,
          (LessonsTableData, $$LessonsTableTableReferences),
          LessonsTableData,
          PrefetchHooks Function({bool unitId, bool localProgressTableRefs})
        > {
  $$LessonsTableTableTableManager(_$AppDatabase db, $LessonsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LessonsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LessonsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LessonsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> unitId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> contentType = const Value.absent(),
                Value<String?> contentJson = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LessonsTableCompanion(
                id: id,
                unitId: unitId,
                title: title,
                contentType: contentType,
                contentJson: contentJson,
                orderIndex: orderIndex,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String unitId,
                required String title,
                required String contentType,
                Value<String?> contentJson = const Value.absent(),
                required int orderIndex,
                Value<int> rowid = const Value.absent(),
              }) => LessonsTableCompanion.insert(
                id: id,
                unitId: unitId,
                title: title,
                contentType: contentType,
                contentJson: contentJson,
                orderIndex: orderIndex,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$LessonsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({unitId = false, localProgressTableRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (localProgressTableRefs) db.localProgressTable,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (unitId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.unitId,
                                    referencedTable:
                                        $$LessonsTableTableReferences
                                            ._unitIdTable(db),
                                    referencedColumn:
                                        $$LessonsTableTableReferences
                                            ._unitIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (localProgressTableRefs)
                        await $_getPrefetchedData<
                          LessonsTableData,
                          $LessonsTableTable,
                          LocalProgressTableData
                        >(
                          currentTable: table,
                          referencedTable: $$LessonsTableTableReferences
                              ._localProgressTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LessonsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).localProgressTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.lessonId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$LessonsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LessonsTableTable,
      LessonsTableData,
      $$LessonsTableTableFilterComposer,
      $$LessonsTableTableOrderingComposer,
      $$LessonsTableTableAnnotationComposer,
      $$LessonsTableTableCreateCompanionBuilder,
      $$LessonsTableTableUpdateCompanionBuilder,
      (LessonsTableData, $$LessonsTableTableReferences),
      LessonsTableData,
      PrefetchHooks Function({bool unitId, bool localProgressTableRefs})
    >;
typedef $$LocalProgressTableTableCreateCompanionBuilder =
    LocalProgressTableCompanion Function({
      required String lessonId,
      Value<bool> isCompleted,
      Value<int?> score,
      Value<DateTime> lastUpdated,
      Value<int> rowid,
    });
typedef $$LocalProgressTableTableUpdateCompanionBuilder =
    LocalProgressTableCompanion Function({
      Value<String> lessonId,
      Value<bool> isCompleted,
      Value<int?> score,
      Value<DateTime> lastUpdated,
      Value<int> rowid,
    });

final class $$LocalProgressTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $LocalProgressTableTable,
          LocalProgressTableData
        > {
  $$LocalProgressTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $LessonsTableTable _lessonIdTable(_$AppDatabase db) =>
      db.lessonsTable.createAlias(
        $_aliasNameGenerator(
          db.localProgressTable.lessonId,
          db.lessonsTable.id,
        ),
      );

  $$LessonsTableTableProcessedTableManager get lessonId {
    final $_column = $_itemColumn<String>('lesson_id')!;

    final manager = $$LessonsTableTableTableManager(
      $_db,
      $_db.lessonsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_lessonIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$LocalProgressTableTableFilterComposer
    extends Composer<_$AppDatabase, $LocalProgressTableTable> {
  $$LocalProgressTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => ColumnFilters(column),
  );

  $$LessonsTableTableFilterComposer get lessonId {
    final $$LessonsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lessonId,
      referencedTable: $db.lessonsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LessonsTableTableFilterComposer(
            $db: $db,
            $table: $db.lessonsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LocalProgressTableTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalProgressTableTable> {
  $$LocalProgressTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => ColumnOrderings(column),
  );

  $$LessonsTableTableOrderingComposer get lessonId {
    final $$LessonsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lessonId,
      referencedTable: $db.lessonsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LessonsTableTableOrderingComposer(
            $db: $db,
            $table: $db.lessonsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LocalProgressTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalProgressTableTable> {
  $$LocalProgressTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<int> get score =>
      $composableBuilder(column: $table.score, builder: (column) => column);

  GeneratedColumn<DateTime> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => column,
  );

  $$LessonsTableTableAnnotationComposer get lessonId {
    final $$LessonsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lessonId,
      referencedTable: $db.lessonsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LessonsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.lessonsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LocalProgressTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalProgressTableTable,
          LocalProgressTableData,
          $$LocalProgressTableTableFilterComposer,
          $$LocalProgressTableTableOrderingComposer,
          $$LocalProgressTableTableAnnotationComposer,
          $$LocalProgressTableTableCreateCompanionBuilder,
          $$LocalProgressTableTableUpdateCompanionBuilder,
          (LocalProgressTableData, $$LocalProgressTableTableReferences),
          LocalProgressTableData,
          PrefetchHooks Function({bool lessonId})
        > {
  $$LocalProgressTableTableTableManager(
    _$AppDatabase db,
    $LocalProgressTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalProgressTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalProgressTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalProgressTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> lessonId = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<int?> score = const Value.absent(),
                Value<DateTime> lastUpdated = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalProgressTableCompanion(
                lessonId: lessonId,
                isCompleted: isCompleted,
                score: score,
                lastUpdated: lastUpdated,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String lessonId,
                Value<bool> isCompleted = const Value.absent(),
                Value<int?> score = const Value.absent(),
                Value<DateTime> lastUpdated = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalProgressTableCompanion.insert(
                lessonId: lessonId,
                isCompleted: isCompleted,
                score: score,
                lastUpdated: lastUpdated,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$LocalProgressTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({lessonId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (lessonId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.lessonId,
                                referencedTable:
                                    $$LocalProgressTableTableReferences
                                        ._lessonIdTable(db),
                                referencedColumn:
                                    $$LocalProgressTableTableReferences
                                        ._lessonIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$LocalProgressTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalProgressTableTable,
      LocalProgressTableData,
      $$LocalProgressTableTableFilterComposer,
      $$LocalProgressTableTableOrderingComposer,
      $$LocalProgressTableTableAnnotationComposer,
      $$LocalProgressTableTableCreateCompanionBuilder,
      $$LocalProgressTableTableUpdateCompanionBuilder,
      (LocalProgressTableData, $$LocalProgressTableTableReferences),
      LocalProgressTableData,
      PrefetchHooks Function({bool lessonId})
    >;
typedef $$PendingRequestsTableTableCreateCompanionBuilder =
    PendingRequestsTableCompanion Function({
      Value<int> id,
      required String url,
      required String method,
      required String dataJson,
      Value<DateTime> createdAt,
    });
typedef $$PendingRequestsTableTableUpdateCompanionBuilder =
    PendingRequestsTableCompanion Function({
      Value<int> id,
      Value<String> url,
      Value<String> method,
      Value<String> dataJson,
      Value<DateTime> createdAt,
    });

class $$PendingRequestsTableTableFilterComposer
    extends Composer<_$AppDatabase, $PendingRequestsTableTable> {
  $$PendingRequestsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dataJson => $composableBuilder(
    column: $table.dataJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PendingRequestsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PendingRequestsTableTable> {
  $$PendingRequestsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dataJson => $composableBuilder(
    column: $table.dataJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PendingRequestsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PendingRequestsTableTable> {
  $$PendingRequestsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get url =>
      $composableBuilder(column: $table.url, builder: (column) => column);

  GeneratedColumn<String> get method =>
      $composableBuilder(column: $table.method, builder: (column) => column);

  GeneratedColumn<String> get dataJson =>
      $composableBuilder(column: $table.dataJson, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$PendingRequestsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PendingRequestsTableTable,
          PendingRequestsTableData,
          $$PendingRequestsTableTableFilterComposer,
          $$PendingRequestsTableTableOrderingComposer,
          $$PendingRequestsTableTableAnnotationComposer,
          $$PendingRequestsTableTableCreateCompanionBuilder,
          $$PendingRequestsTableTableUpdateCompanionBuilder,
          (
            PendingRequestsTableData,
            BaseReferences<
              _$AppDatabase,
              $PendingRequestsTableTable,
              PendingRequestsTableData
            >,
          ),
          PendingRequestsTableData,
          PrefetchHooks Function()
        > {
  $$PendingRequestsTableTableTableManager(
    _$AppDatabase db,
    $PendingRequestsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PendingRequestsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PendingRequestsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$PendingRequestsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> url = const Value.absent(),
                Value<String> method = const Value.absent(),
                Value<String> dataJson = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => PendingRequestsTableCompanion(
                id: id,
                url: url,
                method: method,
                dataJson: dataJson,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String url,
                required String method,
                required String dataJson,
                Value<DateTime> createdAt = const Value.absent(),
              }) => PendingRequestsTableCompanion.insert(
                id: id,
                url: url,
                method: method,
                dataJson: dataJson,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PendingRequestsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PendingRequestsTableTable,
      PendingRequestsTableData,
      $$PendingRequestsTableTableFilterComposer,
      $$PendingRequestsTableTableOrderingComposer,
      $$PendingRequestsTableTableAnnotationComposer,
      $$PendingRequestsTableTableCreateCompanionBuilder,
      $$PendingRequestsTableTableUpdateCompanionBuilder,
      (
        PendingRequestsTableData,
        BaseReferences<
          _$AppDatabase,
          $PendingRequestsTableTable,
          PendingRequestsTableData
        >,
      ),
      PendingRequestsTableData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CoursesTableTableTableManager get coursesTable =>
      $$CoursesTableTableTableManager(_db, _db.coursesTable);
  $$UnitsTableTableTableManager get unitsTable =>
      $$UnitsTableTableTableManager(_db, _db.unitsTable);
  $$LessonsTableTableTableManager get lessonsTable =>
      $$LessonsTableTableTableManager(_db, _db.lessonsTable);
  $$LocalProgressTableTableTableManager get localProgressTable =>
      $$LocalProgressTableTableTableManager(_db, _db.localProgressTable);
  $$PendingRequestsTableTableTableManager get pendingRequestsTable =>
      $$PendingRequestsTableTableTableManager(_db, _db.pendingRequestsTable);
}
