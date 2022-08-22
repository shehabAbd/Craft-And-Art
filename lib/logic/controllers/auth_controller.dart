import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:local_auth/local_auth.dart';
import 'package:logandsign/model/user_model.dart' as model;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logandsign/routes/routes.dart';
import 'package:logandsign/service/storage_methods.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isvisibilty = false;
  bool ischeckbox = false;
  var isSignedIn = false;
  var isLoading = false.obs;
  bool? finger;

  var displayUserName = ''.obs;
  var displayUserPhoto = ''.obs;
  var displayUserEmail = ''.obs;
  LocalAuthentication authentication = LocalAuthentication();

  Future<void> checkBiometric() async {
    try {
      finger = await authentication.canCheckBiometrics;

      print(finger);

      if (finger!) {
        _getAuth();
      }
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<void> _getAuth() async {
    bool isAuth = false;
    try {
      isAuth = await authentication.authenticate(
        localizedReason: "بصمة الاصبع",
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      if (isAuth) {
        Get.toNamed(AppRoutes.helloScreen);
      }
      print(isAuth);
    } on PlatformException catch (e) {
      print(e);
    }
  }

  void loginUser({
    required String token,
    required String email,
    required String password,
  }) async {
    String res = "Some error Occurred";
    try {
      EasyLoading.show(status: 'جاري تسجيل الدخول');
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update(
        {
          "token": token.toString(),
        },
      );
      EasyLoading.showSuccess('تم تسجيل الدخول بنجاح ',
          duration: const Duration(seconds: 1));
      Get.offNamed(Routes.fingerPrint);
      EasyLoading.dismiss();
      res = "success";
    } on FirebaseAuthException catch (error) {
      String title = error.code.replaceAll(RegExp('-'), ' ').capitalize!;
      String message = '';

      if (error.code == 'user-not-found') {
        message = 'لا يوجد لديك حساب بهذا الايميل';
      } else if (error.code == 'wrong-password') {
        message = 'كلمة المرور غير صحيحة الرجاء حاول مرة اخرى ';
      } else {
        message = "لا يوجد اتصال با الانترنت";
      }
      EasyLoading.showInfo(message);
    } catch (error) {
      EasyLoading.showError(error.toString());
    }
  }

  void signUpVisitor({
    required String name,
    required String type,
    required String photoUrl,
    required String blocked,
  }) async {
    String res = "Some error Occurred";
    try {
      EasyLoading.show(
        
        status: 'جاري تسجيل الدخول',
        
      );

      UserCredential cred = await _auth.signInAnonymously();

      model.UserModel _user = model.UserModel(
          name: name,
          photoUrl: photoUrl,
          uid: cred.user!.uid,
          type: type,
          blocked: "no");

      await _firestore.collection("users").doc(cred.user!.uid).set({
        'name': name,
        'photoUrl': photoUrl,
        'type': type,
        'uid': cred.user!.uid,
        'blocked': "no",
      });

      Get.offNamed(Routes.fingerPrint);
      EasyLoading.dismiss();
    } on FirebaseAuthException catch (error) {
      String title = error.code.replaceAll(RegExp('-'), ' ').capitalize!;
      String message = '';

      if (error.code == 'weak-password') {
        message = ' كلمة مرور ضعيفة جداً  ';
      } else if (error.code == 'email-already-in-use') {
        message = 'لا يوجد حساب لهذا الايميل ';
      } else {
        message = 'لا يوجود اتصال بالانترنت ';
      }
      EasyLoading.showInfo(message);
    } catch (error) {
      Get.snackbar(
        'Error!',
        error.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  }

  void signUpUser({
    required String email,
    required String password,
    required String name,
    required String type,
    required File file,
    required String blocked,
    required String token,
  }) async {
    String res = "Some error Occurred";
    try {
      EasyLoading.show(status: 'جاري انشاء الحساب');

      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      String photoUrl = await StorageMethods()
          .uploadImageToStorage('profileUserPhotos', file, false);

      model.UserModel _user = model.UserModel(
        name: name,
        token: token,
        photoUrl: photoUrl,
        uid: cred.user!.uid,
        email: email,
        password: password,
        type: type,
        following: [],
        blocked: "no",
      );
      EasyLoading.show(status: 'لم يتبقى سواء القليل ');

      await _firestore.collection("users").doc(cred.user!.uid).set({
        'name': name,
        'email': email,
        'password': password,
        'photoUrl': photoUrl,
        'type': type,
        "following": [],
        'uid': cred.user!.uid,
        'blocked': "no",
        'token': token,
      });

      EasyLoading.showSuccess('تم تسجيل الدخول بنجاح ');

      Get.offNamed(Routes.fingerPrint);
      EasyLoading.dismiss();
    } on FirebaseAuthException catch (error) {
      String title = error.code.replaceAll(RegExp('-'), ' ').capitalize!;
      String message = '';

      if (error.code == 'weak-password') {
        message = 'كلمة مرور ضعيفة جداً  ';
      } else if (error.code == 'email-already-in-use') {
        message = 'الحساب موجود لهذا الايميل ';
      } else {
        message = 'لا يوجود اتصال بالانترنت ';
      }
      EasyLoading.showInfo(message);
    } catch (error) {
      Get.snackbar(
        'Error!',
        error.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  }

  void resetPassword(String email) async {
    try {
      EasyLoading.show(status: ' جاري ارسال الايميل ');
      await _auth.sendPasswordResetEmail(email: email);
      EasyLoading.showSuccess(' ! تم الارسال  بنجاح ');

      update();
      Get.back();
      EasyLoading.dismiss();
    } on FirebaseAuthException catch (error) {
      String title = error.code.replaceAll(RegExp('-'), ' ').capitalize!;
      String message = '';

      if (error.code == 'user-not-found') {
        message = 'لا يوجد لديك حساب بهذا الايميل ';
      } else {
        message = error.message.toString();
      }
      EasyLoading.showInfo(message);
    } catch (error) {
      EasyLoading.showError(error.toString());
    }
  }

  final GetStorage authBox = GetStorage();

  void visibilty() {
    isvisibilty = !isvisibilty;
    update();
  }

  void checkbox() {
    ischeckbox = !ischeckbox;
    update();
  }

  void signOutFromApp() async {
    try {
      await _auth.signOut();
      displayUserName.value = '';
      displayUserPhoto.value = '';
      displayUserEmail.value = '';
      isSignedIn = false;
      authBox.remove("auth");

      Get.offAllNamed(AppRoutes.welcom);
      update();
    } catch (error) {
      EasyLoading.showError(error.toString());
    }
  }
}
