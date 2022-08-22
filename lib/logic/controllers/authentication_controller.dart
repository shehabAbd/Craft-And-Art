import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logandsign/logic/controllers/registration_controller.dart';
import 'package:logandsign/model/user_model.dart';
import 'package:logandsign/routes/routes.dart';
import 'package:logandsign/service/firebase_services.dart';

class AuthenticationController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final otp = TextEditingController();
  final _auth = FirebaseAuth.instance;

  late final UserModel? registrant;
  late final String? phoneNumber;

  String? verificationId;
  final isLoading = true.obs;

  final _durationTimeOut = const Duration(seconds: 60);
  final isCanResendCode = false.obs;
  final durationCountdown = 0.obs;

  final RegistrationController controller = Get.find();
  var token;

  getToken() async {
    token = await FirebaseMessaging.instance.getToken();
  }

  @override
  void onInit() {
    getToken();
    registrant = _getUser();
    phoneNumber = _getPhoneNumber();
    verifyPhoneNumber();
    super.onInit();
  }

  void verifyPhoneNumber() async {
    isLoading.value = true;

    isCanResendCode.value = false;
    String? _phoneNumber = phoneNumber ?? registrant?.phone;

    if (_phoneNumber != null) {
      await _auth.verifyPhoneNumber(
        phoneNumber: "+967" + _phoneNumber,
        verificationCompleted: (phoneAuthCredential) async {
          log("verify phone number : verification completed");
          await _auth.signInWithCredential(phoneAuthCredential);

          if (registrant != null) {
            _saveRegistrantAndGoToHome();
          } else {
            _goToHome();
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          isLoading.value = false;
          isCanResendCode.value = true;
          Get.snackbar(
            "فشل التحقق",
            e.code,
            backgroundColor: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
        },
        codeSent: (verificationId, forceResendingToken) async {
          log("verify phone number : code success send");
          this.verificationId = verificationId;
          isLoading.value = false;
          _validateCountdownResendCode();
        },
        codeAutoRetrievalTimeout: (verificationId) {},
        timeout: _durationTimeOut,
      );
    }
  }

  void verifySmsCode() async {
    if (formKey.currentState!.validate() && verificationId != null) {
      isLoading.value = true;

      try {
        await _auth.signInWithCredential(PhoneAuthProvider.credential(
            verificationId: verificationId!, smsCode: otp.text));
      } catch (e) {
        print("invalid code");
      } finally {
        isLoading.value = false;

        if (_auth.currentUser != null) {
          
          if (registrant != null) {
            await FirebaseMessaging.instance.subscribeToTopic('on');
            _saveRegistrantAndGoToHome();
          } else {
            _goToHome();
          }
        } else {
          
          Get.snackbar(
            "الكود خطأ",
            "يرجئ ادخال الكود الصحيح",
            backgroundColor: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      }
    }
  }

  void _saveRegistrantAndGoToHome() {
    UserServices.signUpCreative(
      name: controller.name.text,
      phone: controller.phoneNumber.text,
      file: controller.image!,
      address: controller.address.text,
      career: controller.career.text,
      gender: controller.gender.value,
      facebook: controller.facebook.text,
      instagram: controller.instagram.text,
      blocked: "no",
      token: token,
      onSuccess: () => _goToHome(),
      onError: (e) => isLoading.value = false,
    );
  }

  void _goToHome() {
    isLoading.value = false;
    Get.offAllNamed(Routes.fingerPrint);
  }

  void _validateCountdownResendCode() {
    isCanResendCode.value = false;
    var maxDurationInSecond = _durationTimeOut.inSeconds;
    var currentDurationSecond = 0;
    durationCountdown.value = maxDurationInSecond;

    Timer.periodic(const Duration(seconds: 1), (timer) {
      currentDurationSecond++;
      if (maxDurationInSecond - currentDurationSecond >= 0) {
        durationCountdown.value = maxDurationInSecond - currentDurationSecond;
      } else {
        isCanResendCode.value = true;
        timer.cancel();
      }
    });
  }

  UserModel? _getUser() {
    try {
      return Get.arguments as UserModel;
    } catch (_) {
      return null;
    }
  }

  String? _getPhoneNumber() {
    try {
      return Get.parameters['phone'];
    } catch (_) {
      return null;
    }
  }
}
