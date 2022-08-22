
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:logandsign/routes/routes.dart';
import 'package:logandsign/view/widgets/auth/storage_switch.dart';
class ScreenLook {
  BuildContext? ctx;
  ScreenLook({this.ctx});

  LocalAuthentication localAuth = LocalAuthentication();

  Future<void> authUser({String? path, bool? value, String? message}) async {
    try {
       bool didAuthenticate =
        await localAuth.authenticate(localizedReason: message = message!);

    if (path == 'splash') {
      if (didAuthenticate == true) {
        
        Get.toNamed(AppRoutes.main);
        
      } else {
        SystemNavigator.pop();
      }
    } else {
      if (didAuthenticate == true) {
        
        StorageSwitch().saveAuthState(value!);
      }
    }
  
    }on PlatformException {

      EasyLoading.showError("جهازك لا يدعم نمط البصمة");
      
    }
  }
}
