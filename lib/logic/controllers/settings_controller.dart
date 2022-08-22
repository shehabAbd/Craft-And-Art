import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logandsign/utils/my_string.dart';

class SettingController extends GetxController {
  var storage = GetStorage();
  var langLocal = ara;

  String capitalize(String profileName) {
    return profileName.split(" ").map((name) => name.capitalize).join(" ");
  }

  void saveLanguage(String lang) async {
    await storage.write("lang", lang);
  }

  void changeLanguage(String typeLang) {
    saveLanguage(typeLang);
    if (langLocal == typeLang) {
      return;
    }

    if (typeLang == frf) {
      langLocal = frf;
      saveLanguage(frf);
    } else if (typeLang == ara) {
      langLocal = ara;
      saveLanguage(ara);
    } else {
      langLocal = ene;
      saveLanguage(ene);
    }
    update();
  }
}
