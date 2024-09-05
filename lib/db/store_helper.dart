

import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
part 'store_helper.g.dart';

@DriftDatabase(include: {'store.drift'})
class StoreHelper extends _$StoreHelper {
  // Private constructor
  StoreHelper._internal() : super(_openConnection());

  // Singleton instance
  static final StoreHelper _instance = StoreHelper._internal();

  // Factory constructor that returns the singleton instance
  factory StoreHelper() {
    return _instance;
  }

  @override
  int get schemaVersion => 1;

  Future<List<StoreData>> getCartItems() async {
    return await select(store).get();
  }

  Future<int> saveCart(StoreCompanion companion) async {
    return await into(store).insert(companion);
  }

  Future<int> deleteCartItem(int id) async {
    return (delete(store)..where((val) => store.id.equals(id))).go();
  }

  Future<int> deleteCart() async {
    return await delete(store).go();
  }

  Future<int> updateCart(StoreCompanion companion) async {
    return await update(store).write(StoreCompanion(
      id: companion.id,
    ));
  }
}

// LazyDatabase connection function
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'store.db'));
    return NativeDatabase(file);
  });
}
