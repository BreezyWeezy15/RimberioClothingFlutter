import 'package:get_storage/get_storage.dart';

class StorageHelper {

  static var storage = GetStorage();

  static void setStatus() => storage.write("status", true);
  static bool isDone() => storage.read("status") ?? false;

  // app theme
  static void setMode(bool isDark) => storage.write("isDark", isDark);
  static bool getMode() => storage.read("isDark") ?? false;

  // language
  static void setLanguage(String language) => storage.write("language", language);
  static String getLanguage() => storage.read("language") ?? "en-US";


  // payment methods
  static void setPaymentMethod(String value) => storage.write("payment", value);
  static String getPaymentMethod() => storage.read("payment") ?? "Stripe";

}
