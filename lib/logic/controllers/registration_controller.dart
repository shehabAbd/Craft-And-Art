import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:logandsign/model/user_model.dart';
import 'package:logandsign/routes/routes.dart';
import 'package:logandsign/service/firebase_services.dart';

import 'package:image_picker/image_picker.dart';

class RegistrationController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final name = TextEditingController();
  final phoneNumber = TextEditingController();
  final facebook = TextEditingController();
  final instagram = TextEditingController();
  final career = TextEditingController();
  final address = TextEditingController();
  final blocked = TextEditingController();

  var gender = 'ذكر'.obs;

  final isLoading = false.obs;
  bool ischeckbox = false;

  File? image;

  onChangeGender(var selectGender) {
    gender.value = selectGender;
  }

  void goToLoginScreen() {
    Get.offNamed(Routes.loginCreativeScreen);
  }

  void checkbox() {
    ischeckbox = !ischeckbox;
    update();
  }

  void selectImage() async {
    var pickedImage = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 15);
    if (pickedImage != null) {
      image = File(pickedImage.path);
      update();
    }
    update();
  }

  void register() async {
    if (ischeckbox == false) {
      EasyLoading.showInfo("الرجاء قبول سياسة الخصوصية");
    }
    if (formKey.currentState!.validate() &&
        image != null &&
        ischeckbox == true) {
      isLoading.value = true;

      UserServices.phoneNumberExists(phoneNumber.text.trim(), onError: (_) {})
          .then((exist) {
        isLoading.value = false;

        if (exist) {
          Get.snackbar(
            "فشل انشاء حساب",
            "الرقم موجود مسبقاً",
            backgroundColor: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
        } else {
          Get.snackbar(
            " تم إرسال كود التحقق",
            "تحقق من رسائلك",
            backgroundColor: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
          Get.toNamed(
            Routes.authentication,
            arguments: UserModel(
              type: "",
              name: name.text,
              phone: phoneNumber.text,
              followers: [],
              following: [],
              uid: "",
              photoUrl: image!.toString(),
              facebook: facebook.text,
              gender: gender.value,
              instagram: instagram.text,
              address: address.text,
              career: career.text,
              blocked: "no",
            ),
          );
        }
      });
    } else if (image == null) {
      EasyLoading.showInfo('الرجاء اختيار صورة');
    }
  }
}
