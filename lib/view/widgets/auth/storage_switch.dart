import 'package:shared_preferences/shared_preferences.dart';

class StorageSwitch {
  final Future<SharedPreferences> _pref = SharedPreferences.getInstance();

  void saveAuthState(bool status) async {
    final instance = await _pref;

    instance.setBool("status", status);
  }

  Future<bool> getAuthState() async {
    final instance = await _pref;

    if (instance.containsKey("status")) {
      final value = instance.getBool("status");
      return value!;

    } 
    else {
      return false;
    }
  }
}
