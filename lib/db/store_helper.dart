

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
    return await (update(store)
      ..where((tbl) => tbl.id.equals(companion.id.value)))
        .write(StoreCompanion(
      title: companion.title,
      color: companion.color,
      category: companion.category,
      image: companion.image,
      description: companion.description,
      totalPrice: companion.totalPrice,
      quantity: companion.quantity,
    ));
  }

  Future<double> getTotalPrice() async {
    // Define the SQL query to compute the total price
    final query = customSelect(
      'SELECT COALESCE(SUM(totalPrice), 0) AS total_price FROM store',
      readsFrom: {store},
    );

    // Run the query and get the result
    final result = await query.get();
    if (result.isEmpty) {
      return 0.0;
    }

    // Extract the total price from the result
    final row = result.first;
    final totalPrice = row.readDouble('total_price') ?? 0.0;
    return totalPrice;
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
