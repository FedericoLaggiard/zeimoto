// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $PhotosTable extends Photos with TableInfo<$PhotosTable, Photo> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PhotosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _relativePathMeta = const VerificationMeta(
    'relativePath',
  );
  @override
  late final GeneratedColumn<String> relativePath = GeneratedColumn<String>(
    'relative_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _mimeTypeMeta = const VerificationMeta(
    'mimeType',
  );
  @override
  late final GeneratedColumn<String> mimeType = GeneratedColumn<String>(
    'mime_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _capturedAtMeta = const VerificationMeta(
    'capturedAt',
  );
  @override
  late final GeneratedColumn<DateTime> capturedAt = GeneratedColumn<DateTime>(
    'captured_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _widthMeta = const VerificationMeta('width');
  @override
  late final GeneratedColumn<int> width = GeneratedColumn<int>(
    'width',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _heightMeta = const VerificationMeta('height');
  @override
  late final GeneratedColumn<int> height = GeneratedColumn<int>(
    'height',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _byteSizeMeta = const VerificationMeta(
    'byteSize',
  );
  @override
  late final GeneratedColumn<int> byteSize = GeneratedColumn<int>(
    'byte_size',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    relativePath,
    mimeType,
    capturedAt,
    width,
    height,
    byteSize,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'photos';
  @override
  VerificationContext validateIntegrity(
    Insertable<Photo> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('relative_path')) {
      context.handle(
        _relativePathMeta,
        relativePath.isAcceptableOrUnknown(
          data['relative_path']!,
          _relativePathMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_relativePathMeta);
    }
    if (data.containsKey('mime_type')) {
      context.handle(
        _mimeTypeMeta,
        mimeType.isAcceptableOrUnknown(data['mime_type']!, _mimeTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_mimeTypeMeta);
    }
    if (data.containsKey('captured_at')) {
      context.handle(
        _capturedAtMeta,
        capturedAt.isAcceptableOrUnknown(data['captured_at']!, _capturedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_capturedAtMeta);
    }
    if (data.containsKey('width')) {
      context.handle(
        _widthMeta,
        width.isAcceptableOrUnknown(data['width']!, _widthMeta),
      );
    } else if (isInserting) {
      context.missing(_widthMeta);
    }
    if (data.containsKey('height')) {
      context.handle(
        _heightMeta,
        height.isAcceptableOrUnknown(data['height']!, _heightMeta),
      );
    } else if (isInserting) {
      context.missing(_heightMeta);
    }
    if (data.containsKey('byte_size')) {
      context.handle(
        _byteSizeMeta,
        byteSize.isAcceptableOrUnknown(data['byte_size']!, _byteSizeMeta),
      );
    } else if (isInserting) {
      context.missing(_byteSizeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Photo map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Photo(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      relativePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}relative_path'],
      )!,
      mimeType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mime_type'],
      )!,
      capturedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}captured_at'],
      )!,
      width: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}width'],
      )!,
      height: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}height'],
      )!,
      byteSize: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}byte_size'],
      )!,
    );
  }

  @override
  $PhotosTable createAlias(String alias) {
    return $PhotosTable(attachedDatabase, alias);
  }
}

class Photo extends DataClass implements Insertable<Photo> {
  /// UUID v4; also used as the filename on disk (`<id>.jpg`).
  final String id;

  /// Path relative to the application documents directory.
  /// Persisted explicitly so future path-convention changes don't break existing
  /// rows (deducible from id by convention, but not hard-coded).
  final String relativePath;
  final String mimeType;
  final DateTime capturedAt;
  final int width;
  final int height;
  final int byteSize;
  const Photo({
    required this.id,
    required this.relativePath,
    required this.mimeType,
    required this.capturedAt,
    required this.width,
    required this.height,
    required this.byteSize,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['relative_path'] = Variable<String>(relativePath);
    map['mime_type'] = Variable<String>(mimeType);
    map['captured_at'] = Variable<DateTime>(capturedAt);
    map['width'] = Variable<int>(width);
    map['height'] = Variable<int>(height);
    map['byte_size'] = Variable<int>(byteSize);
    return map;
  }

  PhotosCompanion toCompanion(bool nullToAbsent) {
    return PhotosCompanion(
      id: Value(id),
      relativePath: Value(relativePath),
      mimeType: Value(mimeType),
      capturedAt: Value(capturedAt),
      width: Value(width),
      height: Value(height),
      byteSize: Value(byteSize),
    );
  }

  factory Photo.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Photo(
      id: serializer.fromJson<String>(json['id']),
      relativePath: serializer.fromJson<String>(json['relativePath']),
      mimeType: serializer.fromJson<String>(json['mimeType']),
      capturedAt: serializer.fromJson<DateTime>(json['capturedAt']),
      width: serializer.fromJson<int>(json['width']),
      height: serializer.fromJson<int>(json['height']),
      byteSize: serializer.fromJson<int>(json['byteSize']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'relativePath': serializer.toJson<String>(relativePath),
      'mimeType': serializer.toJson<String>(mimeType),
      'capturedAt': serializer.toJson<DateTime>(capturedAt),
      'width': serializer.toJson<int>(width),
      'height': serializer.toJson<int>(height),
      'byteSize': serializer.toJson<int>(byteSize),
    };
  }

  Photo copyWith({
    String? id,
    String? relativePath,
    String? mimeType,
    DateTime? capturedAt,
    int? width,
    int? height,
    int? byteSize,
  }) => Photo(
    id: id ?? this.id,
    relativePath: relativePath ?? this.relativePath,
    mimeType: mimeType ?? this.mimeType,
    capturedAt: capturedAt ?? this.capturedAt,
    width: width ?? this.width,
    height: height ?? this.height,
    byteSize: byteSize ?? this.byteSize,
  );
  Photo copyWithCompanion(PhotosCompanion data) {
    return Photo(
      id: data.id.present ? data.id.value : this.id,
      relativePath: data.relativePath.present
          ? data.relativePath.value
          : this.relativePath,
      mimeType: data.mimeType.present ? data.mimeType.value : this.mimeType,
      capturedAt: data.capturedAt.present
          ? data.capturedAt.value
          : this.capturedAt,
      width: data.width.present ? data.width.value : this.width,
      height: data.height.present ? data.height.value : this.height,
      byteSize: data.byteSize.present ? data.byteSize.value : this.byteSize,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Photo(')
          ..write('id: $id, ')
          ..write('relativePath: $relativePath, ')
          ..write('mimeType: $mimeType, ')
          ..write('capturedAt: $capturedAt, ')
          ..write('width: $width, ')
          ..write('height: $height, ')
          ..write('byteSize: $byteSize')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    relativePath,
    mimeType,
    capturedAt,
    width,
    height,
    byteSize,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Photo &&
          other.id == this.id &&
          other.relativePath == this.relativePath &&
          other.mimeType == this.mimeType &&
          other.capturedAt == this.capturedAt &&
          other.width == this.width &&
          other.height == this.height &&
          other.byteSize == this.byteSize);
}

class PhotosCompanion extends UpdateCompanion<Photo> {
  final Value<String> id;
  final Value<String> relativePath;
  final Value<String> mimeType;
  final Value<DateTime> capturedAt;
  final Value<int> width;
  final Value<int> height;
  final Value<int> byteSize;
  final Value<int> rowid;
  const PhotosCompanion({
    this.id = const Value.absent(),
    this.relativePath = const Value.absent(),
    this.mimeType = const Value.absent(),
    this.capturedAt = const Value.absent(),
    this.width = const Value.absent(),
    this.height = const Value.absent(),
    this.byteSize = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PhotosCompanion.insert({
    required String id,
    required String relativePath,
    required String mimeType,
    required DateTime capturedAt,
    required int width,
    required int height,
    required int byteSize,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       relativePath = Value(relativePath),
       mimeType = Value(mimeType),
       capturedAt = Value(capturedAt),
       width = Value(width),
       height = Value(height),
       byteSize = Value(byteSize);
  static Insertable<Photo> custom({
    Expression<String>? id,
    Expression<String>? relativePath,
    Expression<String>? mimeType,
    Expression<DateTime>? capturedAt,
    Expression<int>? width,
    Expression<int>? height,
    Expression<int>? byteSize,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (relativePath != null) 'relative_path': relativePath,
      if (mimeType != null) 'mime_type': mimeType,
      if (capturedAt != null) 'captured_at': capturedAt,
      if (width != null) 'width': width,
      if (height != null) 'height': height,
      if (byteSize != null) 'byte_size': byteSize,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PhotosCompanion copyWith({
    Value<String>? id,
    Value<String>? relativePath,
    Value<String>? mimeType,
    Value<DateTime>? capturedAt,
    Value<int>? width,
    Value<int>? height,
    Value<int>? byteSize,
    Value<int>? rowid,
  }) {
    return PhotosCompanion(
      id: id ?? this.id,
      relativePath: relativePath ?? this.relativePath,
      mimeType: mimeType ?? this.mimeType,
      capturedAt: capturedAt ?? this.capturedAt,
      width: width ?? this.width,
      height: height ?? this.height,
      byteSize: byteSize ?? this.byteSize,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (relativePath.present) {
      map['relative_path'] = Variable<String>(relativePath.value);
    }
    if (mimeType.present) {
      map['mime_type'] = Variable<String>(mimeType.value);
    }
    if (capturedAt.present) {
      map['captured_at'] = Variable<DateTime>(capturedAt.value);
    }
    if (width.present) {
      map['width'] = Variable<int>(width.value);
    }
    if (height.present) {
      map['height'] = Variable<int>(height.value);
    }
    if (byteSize.present) {
      map['byte_size'] = Variable<int>(byteSize.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PhotosCompanion(')
          ..write('id: $id, ')
          ..write('relativePath: $relativePath, ')
          ..write('mimeType: $mimeType, ')
          ..write('capturedAt: $capturedAt, ')
          ..write('width: $width, ')
          ..write('height: $height, ')
          ..write('byteSize: $byteSize, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PlantsTable extends Plants with TableInfo<$PlantsTable, Plant> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlantsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _speciesMeta = const VerificationMeta(
    'species',
  );
  @override
  late final GeneratedColumn<String> species = GeneratedColumn<String>(
    'species',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nicknameMeta = const VerificationMeta(
    'nickname',
  );
  @override
  late final GeneratedColumn<String> nickname = GeneratedColumn<String>(
    'nickname',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (nickname <> \'\')',
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
    requiredDuringInsert: true,
  );
  static const VerificationMeta _coverPhotoIdMeta = const VerificationMeta(
    'coverPhotoId',
  );
  @override
  late final GeneratedColumn<String> coverPhotoId = GeneratedColumn<String>(
    'cover_photo_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'UNIQUE REFERENCES photos (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints:
        'CHECK (category IN (\'bonsai\', \'prebonsai\', \'yamadori\'))',
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<String> position = GeneratedColumn<String>(
    'position',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _substrateMeta = const VerificationMeta(
    'substrate',
  );
  @override
  late final GeneratedColumn<String> substrate = GeneratedColumn<String>(
    'substrate',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    species,
    nickname,
    createdAt,
    coverPhotoId,
    category,
    position,
    substrate,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'plants';
  @override
  VerificationContext validateIntegrity(
    Insertable<Plant> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('species')) {
      context.handle(
        _speciesMeta,
        species.isAcceptableOrUnknown(data['species']!, _speciesMeta),
      );
    } else if (isInserting) {
      context.missing(_speciesMeta);
    }
    if (data.containsKey('nickname')) {
      context.handle(
        _nicknameMeta,
        nickname.isAcceptableOrUnknown(data['nickname']!, _nicknameMeta),
      );
    } else if (isInserting) {
      context.missing(_nicknameMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('cover_photo_id')) {
      context.handle(
        _coverPhotoIdMeta,
        coverPhotoId.isAcceptableOrUnknown(
          data['cover_photo_id']!,
          _coverPhotoIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_coverPhotoIdMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    }
    if (data.containsKey('substrate')) {
      context.handle(
        _substrateMeta,
        substrate.isAcceptableOrUnknown(data['substrate']!, _substrateMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Plant map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Plant(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      species: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}species'],
      )!,
      nickname: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nickname'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      coverPhotoId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cover_photo_id'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      ),
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}position'],
      ),
      substrate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}substrate'],
      ),
    );
  }

  @override
  $PlantsTable createAlias(String alias) {
    return $PlantsTable(attachedDatabase, alias);
  }
}

class Plant extends DataClass implements Insertable<Plant> {
  /// UUID v4 generated client-side.
  final String id;
  final String species;

  /// Auto-generated by the repository when blank; invariant: never null or empty.
  final String nickname;
  final DateTime createdAt;

  /// 1:1 FK to Photos — the cover photo for this plant.
  /// UNIQUE enforced at DB level; ON DELETE RESTRICT keeps orphan-prevention
  /// in the repository (must delete photo record last).
  final String coverPhotoId;

  /// Optional plant category.  CHECK constraint kept at DB level as defence in
  /// depth; the repository also validates before writing.
  final String? category;
  final String? position;
  final String? substrate;
  const Plant({
    required this.id,
    required this.species,
    required this.nickname,
    required this.createdAt,
    required this.coverPhotoId,
    this.category,
    this.position,
    this.substrate,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['species'] = Variable<String>(species);
    map['nickname'] = Variable<String>(nickname);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['cover_photo_id'] = Variable<String>(coverPhotoId);
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    if (!nullToAbsent || position != null) {
      map['position'] = Variable<String>(position);
    }
    if (!nullToAbsent || substrate != null) {
      map['substrate'] = Variable<String>(substrate);
    }
    return map;
  }

  PlantsCompanion toCompanion(bool nullToAbsent) {
    return PlantsCompanion(
      id: Value(id),
      species: Value(species),
      nickname: Value(nickname),
      createdAt: Value(createdAt),
      coverPhotoId: Value(coverPhotoId),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      position: position == null && nullToAbsent
          ? const Value.absent()
          : Value(position),
      substrate: substrate == null && nullToAbsent
          ? const Value.absent()
          : Value(substrate),
    );
  }

  factory Plant.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Plant(
      id: serializer.fromJson<String>(json['id']),
      species: serializer.fromJson<String>(json['species']),
      nickname: serializer.fromJson<String>(json['nickname']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      coverPhotoId: serializer.fromJson<String>(json['coverPhotoId']),
      category: serializer.fromJson<String?>(json['category']),
      position: serializer.fromJson<String?>(json['position']),
      substrate: serializer.fromJson<String?>(json['substrate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'species': serializer.toJson<String>(species),
      'nickname': serializer.toJson<String>(nickname),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'coverPhotoId': serializer.toJson<String>(coverPhotoId),
      'category': serializer.toJson<String?>(category),
      'position': serializer.toJson<String?>(position),
      'substrate': serializer.toJson<String?>(substrate),
    };
  }

  Plant copyWith({
    String? id,
    String? species,
    String? nickname,
    DateTime? createdAt,
    String? coverPhotoId,
    Value<String?> category = const Value.absent(),
    Value<String?> position = const Value.absent(),
    Value<String?> substrate = const Value.absent(),
  }) => Plant(
    id: id ?? this.id,
    species: species ?? this.species,
    nickname: nickname ?? this.nickname,
    createdAt: createdAt ?? this.createdAt,
    coverPhotoId: coverPhotoId ?? this.coverPhotoId,
    category: category.present ? category.value : this.category,
    position: position.present ? position.value : this.position,
    substrate: substrate.present ? substrate.value : this.substrate,
  );
  Plant copyWithCompanion(PlantsCompanion data) {
    return Plant(
      id: data.id.present ? data.id.value : this.id,
      species: data.species.present ? data.species.value : this.species,
      nickname: data.nickname.present ? data.nickname.value : this.nickname,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      coverPhotoId: data.coverPhotoId.present
          ? data.coverPhotoId.value
          : this.coverPhotoId,
      category: data.category.present ? data.category.value : this.category,
      position: data.position.present ? data.position.value : this.position,
      substrate: data.substrate.present ? data.substrate.value : this.substrate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Plant(')
          ..write('id: $id, ')
          ..write('species: $species, ')
          ..write('nickname: $nickname, ')
          ..write('createdAt: $createdAt, ')
          ..write('coverPhotoId: $coverPhotoId, ')
          ..write('category: $category, ')
          ..write('position: $position, ')
          ..write('substrate: $substrate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    species,
    nickname,
    createdAt,
    coverPhotoId,
    category,
    position,
    substrate,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Plant &&
          other.id == this.id &&
          other.species == this.species &&
          other.nickname == this.nickname &&
          other.createdAt == this.createdAt &&
          other.coverPhotoId == this.coverPhotoId &&
          other.category == this.category &&
          other.position == this.position &&
          other.substrate == this.substrate);
}

class PlantsCompanion extends UpdateCompanion<Plant> {
  final Value<String> id;
  final Value<String> species;
  final Value<String> nickname;
  final Value<DateTime> createdAt;
  final Value<String> coverPhotoId;
  final Value<String?> category;
  final Value<String?> position;
  final Value<String?> substrate;
  final Value<int> rowid;
  const PlantsCompanion({
    this.id = const Value.absent(),
    this.species = const Value.absent(),
    this.nickname = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.coverPhotoId = const Value.absent(),
    this.category = const Value.absent(),
    this.position = const Value.absent(),
    this.substrate = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlantsCompanion.insert({
    required String id,
    required String species,
    required String nickname,
    required DateTime createdAt,
    required String coverPhotoId,
    this.category = const Value.absent(),
    this.position = const Value.absent(),
    this.substrate = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       species = Value(species),
       nickname = Value(nickname),
       createdAt = Value(createdAt),
       coverPhotoId = Value(coverPhotoId);
  static Insertable<Plant> custom({
    Expression<String>? id,
    Expression<String>? species,
    Expression<String>? nickname,
    Expression<DateTime>? createdAt,
    Expression<String>? coverPhotoId,
    Expression<String>? category,
    Expression<String>? position,
    Expression<String>? substrate,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (species != null) 'species': species,
      if (nickname != null) 'nickname': nickname,
      if (createdAt != null) 'created_at': createdAt,
      if (coverPhotoId != null) 'cover_photo_id': coverPhotoId,
      if (category != null) 'category': category,
      if (position != null) 'position': position,
      if (substrate != null) 'substrate': substrate,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlantsCompanion copyWith({
    Value<String>? id,
    Value<String>? species,
    Value<String>? nickname,
    Value<DateTime>? createdAt,
    Value<String>? coverPhotoId,
    Value<String?>? category,
    Value<String?>? position,
    Value<String?>? substrate,
    Value<int>? rowid,
  }) {
    return PlantsCompanion(
      id: id ?? this.id,
      species: species ?? this.species,
      nickname: nickname ?? this.nickname,
      createdAt: createdAt ?? this.createdAt,
      coverPhotoId: coverPhotoId ?? this.coverPhotoId,
      category: category ?? this.category,
      position: position ?? this.position,
      substrate: substrate ?? this.substrate,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (species.present) {
      map['species'] = Variable<String>(species.value);
    }
    if (nickname.present) {
      map['nickname'] = Variable<String>(nickname.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (coverPhotoId.present) {
      map['cover_photo_id'] = Variable<String>(coverPhotoId.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (position.present) {
      map['position'] = Variable<String>(position.value);
    }
    if (substrate.present) {
      map['substrate'] = Variable<String>(substrate.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlantsCompanion(')
          ..write('id: $id, ')
          ..write('species: $species, ')
          ..write('nickname: $nickname, ')
          ..write('createdAt: $createdAt, ')
          ..write('coverPhotoId: $coverPhotoId, ')
          ..write('category: $category, ')
          ..write('position: $position, ')
          ..write('substrate: $substrate, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EventsTable extends Events with TableInfo<$EventsTable, Event> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _plantIdMeta = const VerificationMeta(
    'plantId',
  );
  @override
  late final GeneratedColumn<String> plantId = GeneratedColumn<String>(
    'plant_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES plants (id) ON DELETE RESTRICT',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<EventType, String>
  type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints:
        'NOT NULL CHECK (type IN (\'repotting\',\'pruning\',\'wiring\',\'pinching\',\'defoliation\',\'treatment\',\'fertilizing\',\'observation\',\'styling\'))',
  ).withConverter<EventType>($EventsTable.$convertertype);
  static const VerificationMeta _happenedAtMeta = const VerificationMeta(
    'happenedAt',
  );
  @override
  late final GeneratedColumn<DateTime> happenedAt = GeneratedColumn<DateTime>(
    'happened_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
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
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    plantId,
    type,
    happenedAt,
    createdAt,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'events';
  @override
  VerificationContext validateIntegrity(
    Insertable<Event> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('plant_id')) {
      context.handle(
        _plantIdMeta,
        plantId.isAcceptableOrUnknown(data['plant_id']!, _plantIdMeta),
      );
    } else if (isInserting) {
      context.missing(_plantIdMeta);
    }
    if (data.containsKey('happened_at')) {
      context.handle(
        _happenedAtMeta,
        happenedAt.isAcceptableOrUnknown(data['happened_at']!, _happenedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_happenedAtMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Event map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Event(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      plantId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plant_id'],
      )!,
      type: $EventsTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      happenedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}happened_at'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $EventsTable createAlias(String alias) {
    return $EventsTable(attachedDatabase, alias);
  }

  static TypeConverter<EventType, String> $convertertype =
      const EventTypeConverter();
}

class Event extends DataClass implements Insertable<Event> {
  /// UUID v4 generated client-side.
  final String id;

  /// FK to Plants.  ON DELETE RESTRICT: the repository must delete events
  /// before deleting the plant (hard-delete cascade orchestrated explicitly).
  final String plantId;

  /// Canonical event type stored as an English text identifier.
  /// TypeConverter bridges DB text ↔ [EventType] enum in Dart.
  final EventType type;

  /// When the event happened according to the user (editable after creation).
  final DateTime happenedAt;

  /// When the record was created (immutable audit timestamp).
  final DateTime createdAt;

  /// Free-form notes.  In the MVP absorbs any data that may become structured
  /// metadata in a future iteration.
  final String? notes;
  const Event({
    required this.id,
    required this.plantId,
    required this.type,
    required this.happenedAt,
    required this.createdAt,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['plant_id'] = Variable<String>(plantId);
    {
      map['type'] = Variable<String>($EventsTable.$convertertype.toSql(type));
    }
    map['happened_at'] = Variable<DateTime>(happenedAt);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  EventsCompanion toCompanion(bool nullToAbsent) {
    return EventsCompanion(
      id: Value(id),
      plantId: Value(plantId),
      type: Value(type),
      happenedAt: Value(happenedAt),
      createdAt: Value(createdAt),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory Event.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Event(
      id: serializer.fromJson<String>(json['id']),
      plantId: serializer.fromJson<String>(json['plantId']),
      type: serializer.fromJson<EventType>(json['type']),
      happenedAt: serializer.fromJson<DateTime>(json['happenedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'plantId': serializer.toJson<String>(plantId),
      'type': serializer.toJson<EventType>(type),
      'happenedAt': serializer.toJson<DateTime>(happenedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  Event copyWith({
    String? id,
    String? plantId,
    EventType? type,
    DateTime? happenedAt,
    DateTime? createdAt,
    Value<String?> notes = const Value.absent(),
  }) => Event(
    id: id ?? this.id,
    plantId: plantId ?? this.plantId,
    type: type ?? this.type,
    happenedAt: happenedAt ?? this.happenedAt,
    createdAt: createdAt ?? this.createdAt,
    notes: notes.present ? notes.value : this.notes,
  );
  Event copyWithCompanion(EventsCompanion data) {
    return Event(
      id: data.id.present ? data.id.value : this.id,
      plantId: data.plantId.present ? data.plantId.value : this.plantId,
      type: data.type.present ? data.type.value : this.type,
      happenedAt: data.happenedAt.present
          ? data.happenedAt.value
          : this.happenedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Event(')
          ..write('id: $id, ')
          ..write('plantId: $plantId, ')
          ..write('type: $type, ')
          ..write('happenedAt: $happenedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, plantId, type, happenedAt, createdAt, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Event &&
          other.id == this.id &&
          other.plantId == this.plantId &&
          other.type == this.type &&
          other.happenedAt == this.happenedAt &&
          other.createdAt == this.createdAt &&
          other.notes == this.notes);
}

class EventsCompanion extends UpdateCompanion<Event> {
  final Value<String> id;
  final Value<String> plantId;
  final Value<EventType> type;
  final Value<DateTime> happenedAt;
  final Value<DateTime> createdAt;
  final Value<String?> notes;
  final Value<int> rowid;
  const EventsCompanion({
    this.id = const Value.absent(),
    this.plantId = const Value.absent(),
    this.type = const Value.absent(),
    this.happenedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EventsCompanion.insert({
    required String id,
    required String plantId,
    required EventType type,
    required DateTime happenedAt,
    required DateTime createdAt,
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       plantId = Value(plantId),
       type = Value(type),
       happenedAt = Value(happenedAt),
       createdAt = Value(createdAt);
  static Insertable<Event> custom({
    Expression<String>? id,
    Expression<String>? plantId,
    Expression<String>? type,
    Expression<DateTime>? happenedAt,
    Expression<DateTime>? createdAt,
    Expression<String>? notes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (plantId != null) 'plant_id': plantId,
      if (type != null) 'type': type,
      if (happenedAt != null) 'happened_at': happenedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (notes != null) 'notes': notes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EventsCompanion copyWith({
    Value<String>? id,
    Value<String>? plantId,
    Value<EventType>? type,
    Value<DateTime>? happenedAt,
    Value<DateTime>? createdAt,
    Value<String?>? notes,
    Value<int>? rowid,
  }) {
    return EventsCompanion(
      id: id ?? this.id,
      plantId: plantId ?? this.plantId,
      type: type ?? this.type,
      happenedAt: happenedAt ?? this.happenedAt,
      createdAt: createdAt ?? this.createdAt,
      notes: notes ?? this.notes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (plantId.present) {
      map['plant_id'] = Variable<String>(plantId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
        $EventsTable.$convertertype.toSql(type.value),
      );
    }
    if (happenedAt.present) {
      map['happened_at'] = Variable<DateTime>(happenedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EventsCompanion(')
          ..write('id: $id, ')
          ..write('plantId: $plantId, ')
          ..write('type: $type, ')
          ..write('happenedAt: $happenedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('notes: $notes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EventPhotosTable extends EventPhotos
    with TableInfo<$EventPhotosTable, EventPhoto> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EventPhotosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _eventIdMeta = const VerificationMeta(
    'eventId',
  );
  @override
  late final GeneratedColumn<String> eventId = GeneratedColumn<String>(
    'event_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES events (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _photoIdMeta = const VerificationMeta(
    'photoId',
  );
  @override
  late final GeneratedColumn<String> photoId = GeneratedColumn<String>(
    'photo_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'UNIQUE REFERENCES photos (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [eventId, photoId, sortOrder];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'event_photos';
  @override
  VerificationContext validateIntegrity(
    Insertable<EventPhoto> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('event_id')) {
      context.handle(
        _eventIdMeta,
        eventId.isAcceptableOrUnknown(data['event_id']!, _eventIdMeta),
      );
    } else if (isInserting) {
      context.missing(_eventIdMeta);
    }
    if (data.containsKey('photo_id')) {
      context.handle(
        _photoIdMeta,
        photoId.isAcceptableOrUnknown(data['photo_id']!, _photoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_photoIdMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {eventId, photoId};
  @override
  EventPhoto map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EventPhoto(
      eventId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}event_id'],
      )!,
      photoId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_id'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $EventPhotosTable createAlias(String alias) {
    return $EventPhotosTable(attachedDatabase, alias);
  }
}

class EventPhoto extends DataClass implements Insertable<EventPhoto> {
  /// FK to Events.  ON DELETE CASCADE: deleting an event removes its join rows.
  final String eventId;

  /// FK to Photos.  ON DELETE RESTRICT: cannot delete a photo still referenced
  /// by an event.  UNIQUE prevents re-use across events.
  final String photoId;

  /// 0-based display order within the event.
  final int sortOrder;
  const EventPhoto({
    required this.eventId,
    required this.photoId,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['event_id'] = Variable<String>(eventId);
    map['photo_id'] = Variable<String>(photoId);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  EventPhotosCompanion toCompanion(bool nullToAbsent) {
    return EventPhotosCompanion(
      eventId: Value(eventId),
      photoId: Value(photoId),
      sortOrder: Value(sortOrder),
    );
  }

  factory EventPhoto.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EventPhoto(
      eventId: serializer.fromJson<String>(json['eventId']),
      photoId: serializer.fromJson<String>(json['photoId']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'eventId': serializer.toJson<String>(eventId),
      'photoId': serializer.toJson<String>(photoId),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  EventPhoto copyWith({String? eventId, String? photoId, int? sortOrder}) =>
      EventPhoto(
        eventId: eventId ?? this.eventId,
        photoId: photoId ?? this.photoId,
        sortOrder: sortOrder ?? this.sortOrder,
      );
  EventPhoto copyWithCompanion(EventPhotosCompanion data) {
    return EventPhoto(
      eventId: data.eventId.present ? data.eventId.value : this.eventId,
      photoId: data.photoId.present ? data.photoId.value : this.photoId,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EventPhoto(')
          ..write('eventId: $eventId, ')
          ..write('photoId: $photoId, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(eventId, photoId, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EventPhoto &&
          other.eventId == this.eventId &&
          other.photoId == this.photoId &&
          other.sortOrder == this.sortOrder);
}

class EventPhotosCompanion extends UpdateCompanion<EventPhoto> {
  final Value<String> eventId;
  final Value<String> photoId;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const EventPhotosCompanion({
    this.eventId = const Value.absent(),
    this.photoId = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EventPhotosCompanion.insert({
    required String eventId,
    required String photoId,
    required int sortOrder,
    this.rowid = const Value.absent(),
  }) : eventId = Value(eventId),
       photoId = Value(photoId),
       sortOrder = Value(sortOrder);
  static Insertable<EventPhoto> custom({
    Expression<String>? eventId,
    Expression<String>? photoId,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (eventId != null) 'event_id': eventId,
      if (photoId != null) 'photo_id': photoId,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EventPhotosCompanion copyWith({
    Value<String>? eventId,
    Value<String>? photoId,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return EventPhotosCompanion(
      eventId: eventId ?? this.eventId,
      photoId: photoId ?? this.photoId,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (eventId.present) {
      map['event_id'] = Variable<String>(eventId.value);
    }
    if (photoId.present) {
      map['photo_id'] = Variable<String>(photoId.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EventPhotosCompanion(')
          ..write('eventId: $eventId, ')
          ..write('photoId: $photoId, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PhotosTable photos = $PhotosTable(this);
  late final $PlantsTable plants = $PlantsTable(this);
  late final $EventsTable events = $EventsTable(this);
  late final $EventPhotosTable eventPhotos = $EventPhotosTable(this);
  late final Index plantsCreatedAtIdx = Index(
    'plants_created_at_idx',
    'CREATE INDEX plants_created_at_idx ON plants (created_at)',
  );
  late final Index plantsSpeciesIdx = Index(
    'plants_species_idx',
    'CREATE INDEX plants_species_idx ON plants (species)',
  );
  late final Index eventPhotosEventSortUnique = Index(
    'event_photos_event_sort_unique',
    'CREATE UNIQUE INDEX event_photos_event_sort_unique ON event_photos (event_id, sort_order)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    photos,
    plants,
    events,
    eventPhotos,
    plantsCreatedAtIdx,
    plantsSpeciesIdx,
    eventPhotosEventSortUnique,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'events',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('event_photos', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$PhotosTableCreateCompanionBuilder =
    PhotosCompanion Function({
      required String id,
      required String relativePath,
      required String mimeType,
      required DateTime capturedAt,
      required int width,
      required int height,
      required int byteSize,
      Value<int> rowid,
    });
typedef $$PhotosTableUpdateCompanionBuilder =
    PhotosCompanion Function({
      Value<String> id,
      Value<String> relativePath,
      Value<String> mimeType,
      Value<DateTime> capturedAt,
      Value<int> width,
      Value<int> height,
      Value<int> byteSize,
      Value<int> rowid,
    });

final class $$PhotosTableReferences
    extends BaseReferences<_$AppDatabase, $PhotosTable, Photo> {
  $$PhotosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PlantsTable, List<Plant>> _plantsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.plants,
    aliasName: $_aliasNameGenerator(db.photos.id, db.plants.coverPhotoId),
  );

  $$PlantsTableProcessedTableManager get plantsRefs {
    final manager = $$PlantsTableTableManager(
      $_db,
      $_db.plants,
    ).filter((f) => f.coverPhotoId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_plantsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$EventPhotosTable, List<EventPhoto>>
  _eventPhotosRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.eventPhotos,
    aliasName: $_aliasNameGenerator(db.photos.id, db.eventPhotos.photoId),
  );

  $$EventPhotosTableProcessedTableManager get eventPhotosRefs {
    final manager = $$EventPhotosTableTableManager(
      $_db,
      $_db.eventPhotos,
    ).filter((f) => f.photoId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_eventPhotosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PhotosTableFilterComposer
    extends Composer<_$AppDatabase, $PhotosTable> {
  $$PhotosTableFilterComposer({
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

  ColumnFilters<String> get relativePath => $composableBuilder(
    column: $table.relativePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mimeType => $composableBuilder(
    column: $table.mimeType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get capturedAt => $composableBuilder(
    column: $table.capturedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get width => $composableBuilder(
    column: $table.width,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get height => $composableBuilder(
    column: $table.height,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get byteSize => $composableBuilder(
    column: $table.byteSize,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> plantsRefs(
    Expression<bool> Function($$PlantsTableFilterComposer f) f,
  ) {
    final $$PlantsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.plants,
      getReferencedColumn: (t) => t.coverPhotoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlantsTableFilterComposer(
            $db: $db,
            $table: $db.plants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> eventPhotosRefs(
    Expression<bool> Function($$EventPhotosTableFilterComposer f) f,
  ) {
    final $$EventPhotosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.eventPhotos,
      getReferencedColumn: (t) => t.photoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventPhotosTableFilterComposer(
            $db: $db,
            $table: $db.eventPhotos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PhotosTableOrderingComposer
    extends Composer<_$AppDatabase, $PhotosTable> {
  $$PhotosTableOrderingComposer({
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

  ColumnOrderings<String> get relativePath => $composableBuilder(
    column: $table.relativePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mimeType => $composableBuilder(
    column: $table.mimeType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get capturedAt => $composableBuilder(
    column: $table.capturedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get width => $composableBuilder(
    column: $table.width,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get height => $composableBuilder(
    column: $table.height,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get byteSize => $composableBuilder(
    column: $table.byteSize,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PhotosTableAnnotationComposer
    extends Composer<_$AppDatabase, $PhotosTable> {
  $$PhotosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get relativePath => $composableBuilder(
    column: $table.relativePath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get mimeType =>
      $composableBuilder(column: $table.mimeType, builder: (column) => column);

  GeneratedColumn<DateTime> get capturedAt => $composableBuilder(
    column: $table.capturedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get width =>
      $composableBuilder(column: $table.width, builder: (column) => column);

  GeneratedColumn<int> get height =>
      $composableBuilder(column: $table.height, builder: (column) => column);

  GeneratedColumn<int> get byteSize =>
      $composableBuilder(column: $table.byteSize, builder: (column) => column);

  Expression<T> plantsRefs<T extends Object>(
    Expression<T> Function($$PlantsTableAnnotationComposer a) f,
  ) {
    final $$PlantsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.plants,
      getReferencedColumn: (t) => t.coverPhotoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlantsTableAnnotationComposer(
            $db: $db,
            $table: $db.plants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> eventPhotosRefs<T extends Object>(
    Expression<T> Function($$EventPhotosTableAnnotationComposer a) f,
  ) {
    final $$EventPhotosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.eventPhotos,
      getReferencedColumn: (t) => t.photoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventPhotosTableAnnotationComposer(
            $db: $db,
            $table: $db.eventPhotos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PhotosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PhotosTable,
          Photo,
          $$PhotosTableFilterComposer,
          $$PhotosTableOrderingComposer,
          $$PhotosTableAnnotationComposer,
          $$PhotosTableCreateCompanionBuilder,
          $$PhotosTableUpdateCompanionBuilder,
          (Photo, $$PhotosTableReferences),
          Photo,
          PrefetchHooks Function({bool plantsRefs, bool eventPhotosRefs})
        > {
  $$PhotosTableTableManager(_$AppDatabase db, $PhotosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PhotosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PhotosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PhotosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> relativePath = const Value.absent(),
                Value<String> mimeType = const Value.absent(),
                Value<DateTime> capturedAt = const Value.absent(),
                Value<int> width = const Value.absent(),
                Value<int> height = const Value.absent(),
                Value<int> byteSize = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PhotosCompanion(
                id: id,
                relativePath: relativePath,
                mimeType: mimeType,
                capturedAt: capturedAt,
                width: width,
                height: height,
                byteSize: byteSize,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String relativePath,
                required String mimeType,
                required DateTime capturedAt,
                required int width,
                required int height,
                required int byteSize,
                Value<int> rowid = const Value.absent(),
              }) => PhotosCompanion.insert(
                id: id,
                relativePath: relativePath,
                mimeType: mimeType,
                capturedAt: capturedAt,
                width: width,
                height: height,
                byteSize: byteSize,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$PhotosTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({plantsRefs = false, eventPhotosRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (plantsRefs) db.plants,
                    if (eventPhotosRefs) db.eventPhotos,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (plantsRefs)
                        await $_getPrefetchedData<Photo, $PhotosTable, Plant>(
                          currentTable: table,
                          referencedTable: $$PhotosTableReferences
                              ._plantsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PhotosTableReferences(db, table, p0).plantsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.coverPhotoId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (eventPhotosRefs)
                        await $_getPrefetchedData<
                          Photo,
                          $PhotosTable,
                          EventPhoto
                        >(
                          currentTable: table,
                          referencedTable: $$PhotosTableReferences
                              ._eventPhotosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PhotosTableReferences(
                                db,
                                table,
                                p0,
                              ).eventPhotosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.photoId == item.id,
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

typedef $$PhotosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PhotosTable,
      Photo,
      $$PhotosTableFilterComposer,
      $$PhotosTableOrderingComposer,
      $$PhotosTableAnnotationComposer,
      $$PhotosTableCreateCompanionBuilder,
      $$PhotosTableUpdateCompanionBuilder,
      (Photo, $$PhotosTableReferences),
      Photo,
      PrefetchHooks Function({bool plantsRefs, bool eventPhotosRefs})
    >;
typedef $$PlantsTableCreateCompanionBuilder =
    PlantsCompanion Function({
      required String id,
      required String species,
      required String nickname,
      required DateTime createdAt,
      required String coverPhotoId,
      Value<String?> category,
      Value<String?> position,
      Value<String?> substrate,
      Value<int> rowid,
    });
typedef $$PlantsTableUpdateCompanionBuilder =
    PlantsCompanion Function({
      Value<String> id,
      Value<String> species,
      Value<String> nickname,
      Value<DateTime> createdAt,
      Value<String> coverPhotoId,
      Value<String?> category,
      Value<String?> position,
      Value<String?> substrate,
      Value<int> rowid,
    });

final class $$PlantsTableReferences
    extends BaseReferences<_$AppDatabase, $PlantsTable, Plant> {
  $$PlantsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PhotosTable _coverPhotoIdTable(_$AppDatabase db) => db.photos
      .createAlias($_aliasNameGenerator(db.plants.coverPhotoId, db.photos.id));

  $$PhotosTableProcessedTableManager get coverPhotoId {
    final $_column = $_itemColumn<String>('cover_photo_id')!;

    final manager = $$PhotosTableTableManager(
      $_db,
      $_db.photos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_coverPhotoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$EventsTable, List<Event>> _eventsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.events,
    aliasName: $_aliasNameGenerator(db.plants.id, db.events.plantId),
  );

  $$EventsTableProcessedTableManager get eventsRefs {
    final manager = $$EventsTableTableManager(
      $_db,
      $_db.events,
    ).filter((f) => f.plantId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_eventsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PlantsTableFilterComposer
    extends Composer<_$AppDatabase, $PlantsTable> {
  $$PlantsTableFilterComposer({
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

  ColumnFilters<String> get species => $composableBuilder(
    column: $table.species,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nickname => $composableBuilder(
    column: $table.nickname,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get substrate => $composableBuilder(
    column: $table.substrate,
    builder: (column) => ColumnFilters(column),
  );

  $$PhotosTableFilterComposer get coverPhotoId {
    final $$PhotosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.coverPhotoId,
      referencedTable: $db.photos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PhotosTableFilterComposer(
            $db: $db,
            $table: $db.photos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> eventsRefs(
    Expression<bool> Function($$EventsTableFilterComposer f) f,
  ) {
    final $$EventsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.events,
      getReferencedColumn: (t) => t.plantId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventsTableFilterComposer(
            $db: $db,
            $table: $db.events,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PlantsTableOrderingComposer
    extends Composer<_$AppDatabase, $PlantsTable> {
  $$PlantsTableOrderingComposer({
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

  ColumnOrderings<String> get species => $composableBuilder(
    column: $table.species,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nickname => $composableBuilder(
    column: $table.nickname,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get substrate => $composableBuilder(
    column: $table.substrate,
    builder: (column) => ColumnOrderings(column),
  );

  $$PhotosTableOrderingComposer get coverPhotoId {
    final $$PhotosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.coverPhotoId,
      referencedTable: $db.photos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PhotosTableOrderingComposer(
            $db: $db,
            $table: $db.photos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlantsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlantsTable> {
  $$PlantsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get species =>
      $composableBuilder(column: $table.species, builder: (column) => column);

  GeneratedColumn<String> get nickname =>
      $composableBuilder(column: $table.nickname, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get substrate =>
      $composableBuilder(column: $table.substrate, builder: (column) => column);

  $$PhotosTableAnnotationComposer get coverPhotoId {
    final $$PhotosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.coverPhotoId,
      referencedTable: $db.photos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PhotosTableAnnotationComposer(
            $db: $db,
            $table: $db.photos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> eventsRefs<T extends Object>(
    Expression<T> Function($$EventsTableAnnotationComposer a) f,
  ) {
    final $$EventsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.events,
      getReferencedColumn: (t) => t.plantId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventsTableAnnotationComposer(
            $db: $db,
            $table: $db.events,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PlantsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlantsTable,
          Plant,
          $$PlantsTableFilterComposer,
          $$PlantsTableOrderingComposer,
          $$PlantsTableAnnotationComposer,
          $$PlantsTableCreateCompanionBuilder,
          $$PlantsTableUpdateCompanionBuilder,
          (Plant, $$PlantsTableReferences),
          Plant,
          PrefetchHooks Function({bool coverPhotoId, bool eventsRefs})
        > {
  $$PlantsTableTableManager(_$AppDatabase db, $PlantsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlantsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlantsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlantsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> species = const Value.absent(),
                Value<String> nickname = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> coverPhotoId = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<String?> position = const Value.absent(),
                Value<String?> substrate = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlantsCompanion(
                id: id,
                species: species,
                nickname: nickname,
                createdAt: createdAt,
                coverPhotoId: coverPhotoId,
                category: category,
                position: position,
                substrate: substrate,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String species,
                required String nickname,
                required DateTime createdAt,
                required String coverPhotoId,
                Value<String?> category = const Value.absent(),
                Value<String?> position = const Value.absent(),
                Value<String?> substrate = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlantsCompanion.insert(
                id: id,
                species: species,
                nickname: nickname,
                createdAt: createdAt,
                coverPhotoId: coverPhotoId,
                category: category,
                position: position,
                substrate: substrate,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$PlantsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({coverPhotoId = false, eventsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (eventsRefs) db.events],
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
                    if (coverPhotoId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.coverPhotoId,
                                referencedTable: $$PlantsTableReferences
                                    ._coverPhotoIdTable(db),
                                referencedColumn: $$PlantsTableReferences
                                    ._coverPhotoIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (eventsRefs)
                    await $_getPrefetchedData<Plant, $PlantsTable, Event>(
                      currentTable: table,
                      referencedTable: $$PlantsTableReferences._eventsRefsTable(
                        db,
                      ),
                      managerFromTypedResult: (p0) =>
                          $$PlantsTableReferences(db, table, p0).eventsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.plantId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$PlantsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlantsTable,
      Plant,
      $$PlantsTableFilterComposer,
      $$PlantsTableOrderingComposer,
      $$PlantsTableAnnotationComposer,
      $$PlantsTableCreateCompanionBuilder,
      $$PlantsTableUpdateCompanionBuilder,
      (Plant, $$PlantsTableReferences),
      Plant,
      PrefetchHooks Function({bool coverPhotoId, bool eventsRefs})
    >;
typedef $$EventsTableCreateCompanionBuilder =
    EventsCompanion Function({
      required String id,
      required String plantId,
      required EventType type,
      required DateTime happenedAt,
      required DateTime createdAt,
      Value<String?> notes,
      Value<int> rowid,
    });
typedef $$EventsTableUpdateCompanionBuilder =
    EventsCompanion Function({
      Value<String> id,
      Value<String> plantId,
      Value<EventType> type,
      Value<DateTime> happenedAt,
      Value<DateTime> createdAt,
      Value<String?> notes,
      Value<int> rowid,
    });

final class $$EventsTableReferences
    extends BaseReferences<_$AppDatabase, $EventsTable, Event> {
  $$EventsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PlantsTable _plantIdTable(_$AppDatabase db) => db.plants.createAlias(
    $_aliasNameGenerator(db.events.plantId, db.plants.id),
  );

  $$PlantsTableProcessedTableManager get plantId {
    final $_column = $_itemColumn<String>('plant_id')!;

    final manager = $$PlantsTableTableManager(
      $_db,
      $_db.plants,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_plantIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$EventPhotosTable, List<EventPhoto>>
  _eventPhotosRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.eventPhotos,
    aliasName: $_aliasNameGenerator(db.events.id, db.eventPhotos.eventId),
  );

  $$EventPhotosTableProcessedTableManager get eventPhotosRefs {
    final manager = $$EventPhotosTableTableManager(
      $_db,
      $_db.eventPhotos,
    ).filter((f) => f.eventId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_eventPhotosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$EventsTableFilterComposer
    extends Composer<_$AppDatabase, $EventsTable> {
  $$EventsTableFilterComposer({
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

  ColumnWithTypeConverterFilters<EventType, EventType, String> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get happenedAt => $composableBuilder(
    column: $table.happenedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  $$PlantsTableFilterComposer get plantId {
    final $$PlantsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.plantId,
      referencedTable: $db.plants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlantsTableFilterComposer(
            $db: $db,
            $table: $db.plants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> eventPhotosRefs(
    Expression<bool> Function($$EventPhotosTableFilterComposer f) f,
  ) {
    final $$EventPhotosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.eventPhotos,
      getReferencedColumn: (t) => t.eventId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventPhotosTableFilterComposer(
            $db: $db,
            $table: $db.eventPhotos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EventsTableOrderingComposer
    extends Composer<_$AppDatabase, $EventsTable> {
  $$EventsTableOrderingComposer({
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

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get happenedAt => $composableBuilder(
    column: $table.happenedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  $$PlantsTableOrderingComposer get plantId {
    final $$PlantsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.plantId,
      referencedTable: $db.plants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlantsTableOrderingComposer(
            $db: $db,
            $table: $db.plants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EventsTable> {
  $$EventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<EventType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<DateTime> get happenedAt => $composableBuilder(
    column: $table.happenedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$PlantsTableAnnotationComposer get plantId {
    final $$PlantsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.plantId,
      referencedTable: $db.plants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlantsTableAnnotationComposer(
            $db: $db,
            $table: $db.plants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> eventPhotosRefs<T extends Object>(
    Expression<T> Function($$EventPhotosTableAnnotationComposer a) f,
  ) {
    final $$EventPhotosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.eventPhotos,
      getReferencedColumn: (t) => t.eventId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventPhotosTableAnnotationComposer(
            $db: $db,
            $table: $db.eventPhotos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EventsTable,
          Event,
          $$EventsTableFilterComposer,
          $$EventsTableOrderingComposer,
          $$EventsTableAnnotationComposer,
          $$EventsTableCreateCompanionBuilder,
          $$EventsTableUpdateCompanionBuilder,
          (Event, $$EventsTableReferences),
          Event,
          PrefetchHooks Function({bool plantId, bool eventPhotosRefs})
        > {
  $$EventsTableTableManager(_$AppDatabase db, $EventsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> plantId = const Value.absent(),
                Value<EventType> type = const Value.absent(),
                Value<DateTime> happenedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EventsCompanion(
                id: id,
                plantId: plantId,
                type: type,
                happenedAt: happenedAt,
                createdAt: createdAt,
                notes: notes,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String plantId,
                required EventType type,
                required DateTime happenedAt,
                required DateTime createdAt,
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EventsCompanion.insert(
                id: id,
                plantId: plantId,
                type: type,
                happenedAt: happenedAt,
                createdAt: createdAt,
                notes: notes,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$EventsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({plantId = false, eventPhotosRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (eventPhotosRefs) db.eventPhotos],
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
                    if (plantId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.plantId,
                                referencedTable: $$EventsTableReferences
                                    ._plantIdTable(db),
                                referencedColumn: $$EventsTableReferences
                                    ._plantIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (eventPhotosRefs)
                    await $_getPrefetchedData<Event, $EventsTable, EventPhoto>(
                      currentTable: table,
                      referencedTable: $$EventsTableReferences
                          ._eventPhotosRefsTable(db),
                      managerFromTypedResult: (p0) => $$EventsTableReferences(
                        db,
                        table,
                        p0,
                      ).eventPhotosRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.eventId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$EventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EventsTable,
      Event,
      $$EventsTableFilterComposer,
      $$EventsTableOrderingComposer,
      $$EventsTableAnnotationComposer,
      $$EventsTableCreateCompanionBuilder,
      $$EventsTableUpdateCompanionBuilder,
      (Event, $$EventsTableReferences),
      Event,
      PrefetchHooks Function({bool plantId, bool eventPhotosRefs})
    >;
typedef $$EventPhotosTableCreateCompanionBuilder =
    EventPhotosCompanion Function({
      required String eventId,
      required String photoId,
      required int sortOrder,
      Value<int> rowid,
    });
typedef $$EventPhotosTableUpdateCompanionBuilder =
    EventPhotosCompanion Function({
      Value<String> eventId,
      Value<String> photoId,
      Value<int> sortOrder,
      Value<int> rowid,
    });

final class $$EventPhotosTableReferences
    extends BaseReferences<_$AppDatabase, $EventPhotosTable, EventPhoto> {
  $$EventPhotosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $EventsTable _eventIdTable(_$AppDatabase db) => db.events.createAlias(
    $_aliasNameGenerator(db.eventPhotos.eventId, db.events.id),
  );

  $$EventsTableProcessedTableManager get eventId {
    final $_column = $_itemColumn<String>('event_id')!;

    final manager = $$EventsTableTableManager(
      $_db,
      $_db.events,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_eventIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PhotosTable _photoIdTable(_$AppDatabase db) => db.photos.createAlias(
    $_aliasNameGenerator(db.eventPhotos.photoId, db.photos.id),
  );

  $$PhotosTableProcessedTableManager get photoId {
    final $_column = $_itemColumn<String>('photo_id')!;

    final manager = $$PhotosTableTableManager(
      $_db,
      $_db.photos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_photoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$EventPhotosTableFilterComposer
    extends Composer<_$AppDatabase, $EventPhotosTable> {
  $$EventPhotosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  $$EventsTableFilterComposer get eventId {
    final $$EventsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.eventId,
      referencedTable: $db.events,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventsTableFilterComposer(
            $db: $db,
            $table: $db.events,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PhotosTableFilterComposer get photoId {
    final $$PhotosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.photoId,
      referencedTable: $db.photos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PhotosTableFilterComposer(
            $db: $db,
            $table: $db.photos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EventPhotosTableOrderingComposer
    extends Composer<_$AppDatabase, $EventPhotosTable> {
  $$EventPhotosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  $$EventsTableOrderingComposer get eventId {
    final $$EventsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.eventId,
      referencedTable: $db.events,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventsTableOrderingComposer(
            $db: $db,
            $table: $db.events,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PhotosTableOrderingComposer get photoId {
    final $$PhotosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.photoId,
      referencedTable: $db.photos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PhotosTableOrderingComposer(
            $db: $db,
            $table: $db.photos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EventPhotosTableAnnotationComposer
    extends Composer<_$AppDatabase, $EventPhotosTable> {
  $$EventPhotosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  $$EventsTableAnnotationComposer get eventId {
    final $$EventsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.eventId,
      referencedTable: $db.events,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventsTableAnnotationComposer(
            $db: $db,
            $table: $db.events,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PhotosTableAnnotationComposer get photoId {
    final $$PhotosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.photoId,
      referencedTable: $db.photos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PhotosTableAnnotationComposer(
            $db: $db,
            $table: $db.photos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EventPhotosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EventPhotosTable,
          EventPhoto,
          $$EventPhotosTableFilterComposer,
          $$EventPhotosTableOrderingComposer,
          $$EventPhotosTableAnnotationComposer,
          $$EventPhotosTableCreateCompanionBuilder,
          $$EventPhotosTableUpdateCompanionBuilder,
          (EventPhoto, $$EventPhotosTableReferences),
          EventPhoto,
          PrefetchHooks Function({bool eventId, bool photoId})
        > {
  $$EventPhotosTableTableManager(_$AppDatabase db, $EventPhotosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EventPhotosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EventPhotosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EventPhotosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> eventId = const Value.absent(),
                Value<String> photoId = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EventPhotosCompanion(
                eventId: eventId,
                photoId: photoId,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String eventId,
                required String photoId,
                required int sortOrder,
                Value<int> rowid = const Value.absent(),
              }) => EventPhotosCompanion.insert(
                eventId: eventId,
                photoId: photoId,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$EventPhotosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({eventId = false, photoId = false}) {
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
                    if (eventId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.eventId,
                                referencedTable: $$EventPhotosTableReferences
                                    ._eventIdTable(db),
                                referencedColumn: $$EventPhotosTableReferences
                                    ._eventIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (photoId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.photoId,
                                referencedTable: $$EventPhotosTableReferences
                                    ._photoIdTable(db),
                                referencedColumn: $$EventPhotosTableReferences
                                    ._photoIdTable(db)
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

typedef $$EventPhotosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EventPhotosTable,
      EventPhoto,
      $$EventPhotosTableFilterComposer,
      $$EventPhotosTableOrderingComposer,
      $$EventPhotosTableAnnotationComposer,
      $$EventPhotosTableCreateCompanionBuilder,
      $$EventPhotosTableUpdateCompanionBuilder,
      (EventPhoto, $$EventPhotosTableReferences),
      EventPhoto,
      PrefetchHooks Function({bool eventId, bool photoId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PhotosTableTableManager get photos =>
      $$PhotosTableTableManager(_db, _db.photos);
  $$PlantsTableTableManager get plants =>
      $$PlantsTableTableManager(_db, _db.plants);
  $$EventsTableTableManager get events =>
      $$EventsTableTableManager(_db, _db.events);
  $$EventPhotosTableTableManager get eventPhotos =>
      $$EventPhotosTableTableManager(_db, _db.eventPhotos);
}
