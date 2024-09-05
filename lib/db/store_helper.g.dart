// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_helper.dart';

// ignore_for_file: type=lint
class Store extends Table with TableInfo<Store, StoreData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Store(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT');
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints: '');
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints: '');
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
      'price', aliasedName, true,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      $customConstraints: '');
  static const VerificationMeta _totalPriceMeta =
      const VerificationMeta('totalPrice');
  late final GeneratedColumn<double> totalPrice = GeneratedColumn<double>(
      'totalPrice', aliasedName, true,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      $customConstraints: '');
  static const VerificationMeta _imageMeta = const VerificationMeta('image');
  late final GeneratedColumn<String> image = GeneratedColumn<String>(
      'image', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints: '');
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
      'quantity', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: '');
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints: '');
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
      'color', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: '');
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        category,
        price,
        totalPrice,
        image,
        quantity,
        description,
        color
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'store';
  @override
  VerificationContext validateIntegrity(Insertable<StoreData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    }
    if (data.containsKey('price')) {
      context.handle(
          _priceMeta, price.isAcceptableOrUnknown(data['price']!, _priceMeta));
    }
    if (data.containsKey('totalPrice')) {
      context.handle(
          _totalPriceMeta,
          totalPrice.isAcceptableOrUnknown(
              data['totalPrice']!, _totalPriceMeta));
    }
    if (data.containsKey('image')) {
      context.handle(
          _imageMeta, image.isAcceptableOrUnknown(data['image']!, _imageMeta));
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('color')) {
      context.handle(
          _colorMeta, color.isAcceptableOrUnknown(data['color']!, _colorMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StoreData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StoreData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title']),
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category']),
      price: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}price']),
      totalPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}totalPrice']),
      image: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image']),
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quantity']),
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      color: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}color']),
    );
  }

  @override
  Store createAlias(String alias) {
    return Store(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class StoreData extends DataClass implements Insertable<StoreData> {
  final int id;
  final String? title;
  final String? category;
  final double? price;
  final double? totalPrice;
  final String? image;
  final int? quantity;
  final String? description;
  final int? color;
  const StoreData(
      {required this.id,
      this.title,
      this.category,
      this.price,
      this.totalPrice,
      this.image,
      this.quantity,
      this.description,
      this.color});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    if (!nullToAbsent || price != null) {
      map['price'] = Variable<double>(price);
    }
    if (!nullToAbsent || totalPrice != null) {
      map['totalPrice'] = Variable<double>(totalPrice);
    }
    if (!nullToAbsent || image != null) {
      map['image'] = Variable<String>(image);
    }
    if (!nullToAbsent || quantity != null) {
      map['quantity'] = Variable<int>(quantity);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<int>(color);
    }
    return map;
  }

  StoreCompanion toCompanion(bool nullToAbsent) {
    return StoreCompanion(
      id: Value(id),
      title:
          title == null && nullToAbsent ? const Value.absent() : Value(title),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      price:
          price == null && nullToAbsent ? const Value.absent() : Value(price),
      totalPrice: totalPrice == null && nullToAbsent
          ? const Value.absent()
          : Value(totalPrice),
      image:
          image == null && nullToAbsent ? const Value.absent() : Value(image),
      quantity: quantity == null && nullToAbsent
          ? const Value.absent()
          : Value(quantity),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      color:
          color == null && nullToAbsent ? const Value.absent() : Value(color),
    );
  }

  factory StoreData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StoreData(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String?>(json['title']),
      category: serializer.fromJson<String?>(json['category']),
      price: serializer.fromJson<double?>(json['price']),
      totalPrice: serializer.fromJson<double?>(json['totalPrice']),
      image: serializer.fromJson<String?>(json['image']),
      quantity: serializer.fromJson<int?>(json['quantity']),
      description: serializer.fromJson<String?>(json['description']),
      color: serializer.fromJson<int?>(json['color']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String?>(title),
      'category': serializer.toJson<String?>(category),
      'price': serializer.toJson<double?>(price),
      'totalPrice': serializer.toJson<double?>(totalPrice),
      'image': serializer.toJson<String?>(image),
      'quantity': serializer.toJson<int?>(quantity),
      'description': serializer.toJson<String?>(description),
      'color': serializer.toJson<int?>(color),
    };
  }

  StoreData copyWith(
          {int? id,
          Value<String?> title = const Value.absent(),
          Value<String?> category = const Value.absent(),
          Value<double?> price = const Value.absent(),
          Value<double?> totalPrice = const Value.absent(),
          Value<String?> image = const Value.absent(),
          Value<int?> quantity = const Value.absent(),
          Value<String?> description = const Value.absent(),
          Value<int?> color = const Value.absent()}) =>
      StoreData(
        id: id ?? this.id,
        title: title.present ? title.value : this.title,
        category: category.present ? category.value : this.category,
        price: price.present ? price.value : this.price,
        totalPrice: totalPrice.present ? totalPrice.value : this.totalPrice,
        image: image.present ? image.value : this.image,
        quantity: quantity.present ? quantity.value : this.quantity,
        description: description.present ? description.value : this.description,
        color: color.present ? color.value : this.color,
      );
  StoreData copyWithCompanion(StoreCompanion data) {
    return StoreData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      category: data.category.present ? data.category.value : this.category,
      price: data.price.present ? data.price.value : this.price,
      totalPrice:
          data.totalPrice.present ? data.totalPrice.value : this.totalPrice,
      image: data.image.present ? data.image.value : this.image,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      description:
          data.description.present ? data.description.value : this.description,
      color: data.color.present ? data.color.value : this.color,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StoreData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('category: $category, ')
          ..write('price: $price, ')
          ..write('totalPrice: $totalPrice, ')
          ..write('image: $image, ')
          ..write('quantity: $quantity, ')
          ..write('description: $description, ')
          ..write('color: $color')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, category, price, totalPrice, image,
      quantity, description, color);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StoreData &&
          other.id == this.id &&
          other.title == this.title &&
          other.category == this.category &&
          other.price == this.price &&
          other.totalPrice == this.totalPrice &&
          other.image == this.image &&
          other.quantity == this.quantity &&
          other.description == this.description &&
          other.color == this.color);
}

class StoreCompanion extends UpdateCompanion<StoreData> {
  final Value<int> id;
  final Value<String?> title;
  final Value<String?> category;
  final Value<double?> price;
  final Value<double?> totalPrice;
  final Value<String?> image;
  final Value<int?> quantity;
  final Value<String?> description;
  final Value<int?> color;
  const StoreCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.category = const Value.absent(),
    this.price = const Value.absent(),
    this.totalPrice = const Value.absent(),
    this.image = const Value.absent(),
    this.quantity = const Value.absent(),
    this.description = const Value.absent(),
    this.color = const Value.absent(),
  });
  StoreCompanion.insert({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.category = const Value.absent(),
    this.price = const Value.absent(),
    this.totalPrice = const Value.absent(),
    this.image = const Value.absent(),
    this.quantity = const Value.absent(),
    this.description = const Value.absent(),
    this.color = const Value.absent(),
  });
  static Insertable<StoreData> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? category,
    Expression<double>? price,
    Expression<double>? totalPrice,
    Expression<String>? image,
    Expression<int>? quantity,
    Expression<String>? description,
    Expression<int>? color,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (category != null) 'category': category,
      if (price != null) 'price': price,
      if (totalPrice != null) 'totalPrice': totalPrice,
      if (image != null) 'image': image,
      if (quantity != null) 'quantity': quantity,
      if (description != null) 'description': description,
      if (color != null) 'color': color,
    });
  }

  StoreCompanion copyWith(
      {Value<int>? id,
      Value<String?>? title,
      Value<String?>? category,
      Value<double?>? price,
      Value<double?>? totalPrice,
      Value<String?>? image,
      Value<int?>? quantity,
      Value<String?>? description,
      Value<int?>? color}) {
    return StoreCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      price: price ?? this.price,
      totalPrice: totalPrice ?? this.totalPrice,
      image: image ?? this.image,
      quantity: quantity ?? this.quantity,
      description: description ?? this.description,
      color: color ?? this.color,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (totalPrice.present) {
      map['totalPrice'] = Variable<double>(totalPrice.value);
    }
    if (image.present) {
      map['image'] = Variable<String>(image.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StoreCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('category: $category, ')
          ..write('price: $price, ')
          ..write('totalPrice: $totalPrice, ')
          ..write('image: $image, ')
          ..write('quantity: $quantity, ')
          ..write('description: $description, ')
          ..write('color: $color')
          ..write(')'))
        .toString();
  }
}

abstract class _$StoreHelper extends GeneratedDatabase {
  _$StoreHelper(QueryExecutor e) : super(e);
  $StoreHelperManager get managers => $StoreHelperManager(this);
  late final Store store = Store(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [store];
}

typedef $StoreCreateCompanionBuilder = StoreCompanion Function({
  Value<int> id,
  Value<String?> title,
  Value<String?> category,
  Value<double?> price,
  Value<double?> totalPrice,
  Value<String?> image,
  Value<int?> quantity,
  Value<String?> description,
  Value<int?> color,
});
typedef $StoreUpdateCompanionBuilder = StoreCompanion Function({
  Value<int> id,
  Value<String?> title,
  Value<String?> category,
  Value<double?> price,
  Value<double?> totalPrice,
  Value<String?> image,
  Value<int?> quantity,
  Value<String?> description,
  Value<int?> color,
});

class $StoreTableManager extends RootTableManager<
    _$StoreHelper,
    Store,
    StoreData,
    $StoreFilterComposer,
    $StoreOrderingComposer,
    $StoreCreateCompanionBuilder,
    $StoreUpdateCompanionBuilder> {
  $StoreTableManager(_$StoreHelper db, Store table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer: $StoreFilterComposer(ComposerState(db, table)),
          orderingComposer: $StoreOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> title = const Value.absent(),
            Value<String?> category = const Value.absent(),
            Value<double?> price = const Value.absent(),
            Value<double?> totalPrice = const Value.absent(),
            Value<String?> image = const Value.absent(),
            Value<int?> quantity = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<int?> color = const Value.absent(),
          }) =>
              StoreCompanion(
            id: id,
            title: title,
            category: category,
            price: price,
            totalPrice: totalPrice,
            image: image,
            quantity: quantity,
            description: description,
            color: color,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> title = const Value.absent(),
            Value<String?> category = const Value.absent(),
            Value<double?> price = const Value.absent(),
            Value<double?> totalPrice = const Value.absent(),
            Value<String?> image = const Value.absent(),
            Value<int?> quantity = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<int?> color = const Value.absent(),
          }) =>
              StoreCompanion.insert(
            id: id,
            title: title,
            category: category,
            price: price,
            totalPrice: totalPrice,
            image: image,
            quantity: quantity,
            description: description,
            color: color,
          ),
        ));
}

class $StoreFilterComposer extends FilterComposer<_$StoreHelper, Store> {
  $StoreFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get title => $state.composableBuilder(
      column: $state.table.title,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get category => $state.composableBuilder(
      column: $state.table.category,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get price => $state.composableBuilder(
      column: $state.table.price,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get totalPrice => $state.composableBuilder(
      column: $state.table.totalPrice,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get image => $state.composableBuilder(
      column: $state.table.image,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get quantity => $state.composableBuilder(
      column: $state.table.quantity,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get description => $state.composableBuilder(
      column: $state.table.description,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get color => $state.composableBuilder(
      column: $state.table.color,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $StoreOrderingComposer extends OrderingComposer<_$StoreHelper, Store> {
  $StoreOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get title => $state.composableBuilder(
      column: $state.table.title,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get category => $state.composableBuilder(
      column: $state.table.category,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get price => $state.composableBuilder(
      column: $state.table.price,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get totalPrice => $state.composableBuilder(
      column: $state.table.totalPrice,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get image => $state.composableBuilder(
      column: $state.table.image,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get quantity => $state.composableBuilder(
      column: $state.table.quantity,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get description => $state.composableBuilder(
      column: $state.table.description,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get color => $state.composableBuilder(
      column: $state.table.color,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class $StoreHelperManager {
  final _$StoreHelper _db;
  $StoreHelperManager(this._db);
  $StoreTableManager get store => $StoreTableManager(_db, _db.store);
}
