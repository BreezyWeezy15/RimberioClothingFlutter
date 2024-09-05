

import 'package:get_storage/get_storage.dart';

class StorageHelper {

  static var storage = GetStorage();

  static void setStatus() => storage.write("status", true);
  static bool isDone() => storage.read("status") ?? false;

}
