import 'package:shared_preferences/shared_preferences.dart';

enum PrefKeys { host }

class Prefs {
  static Future<SharedPreferences> get pref => SharedPreferences.getInstance();

  static Future<String> get host async =>
      (await pref).getString(PrefKeys.host.toString()) ?? 'localhost';

  static Future<void> setHost(String? host) async => host == null
      ? (await pref).remove(PrefKeys.host.toString())
      : (await pref).setString(PrefKeys.host.toString(), host);
}
