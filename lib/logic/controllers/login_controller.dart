import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logandsign/logic/controllers/registration_controller.dart';
import 'package:logandsign/routes/routes.dart';
import 'package:logandsign/service/firebase_services.dart';

class LoginController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final phoneNumber = TextEditingController();
  final isLoading = false.obs;

  final RegistrationController controller = Get.put(RegistrationController());

  void goToRegistrationScreen() {
    Get.toNamed(Routes.registrationCreative);
  }

  void goToAuthenticationScreen() {
    Get.toNamed(Routes.authentication);
  }

  void login() async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;
      await UserServices.phoneNumberExists(phoneNumber.text.trim(),
          onError: (_) {
        isLoading.value = false;
      }).then((exist) {
        isLoading.value = false;
        if (exist) {
          Get.toNamed(
            Routes.authentication,
            parameters: {'phone': phoneNumber.text},
          );
        } else {
          Get.snackbar(
            "فشل تسجيل الدخول",
            "رقمك ليس موجود",
            backgroundColor: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      });
    }
  }
}
