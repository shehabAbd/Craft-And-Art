import 'package:get/get.dart';
import 'package:logandsign/logic/controllers/main_controller.dart';
import 'package:logandsign/logic/controllers/settings_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MainController());
    Get.put(SettingController());
  }
}
