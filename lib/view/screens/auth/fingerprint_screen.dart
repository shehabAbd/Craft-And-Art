import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logandsign/routes/routes.dart';
import 'package:logandsign/view/widgets/auth/screen_look.dart';
import 'package:logandsign/view/widgets/auth/storage_switch.dart';
import 'package:logandsign/utils/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:logandsign/providers/user_provider.dart';

class Fingerprint extends StatefulWidget {
  const Fingerprint({Key? key}) : super(key: key);

  @override
  _FingerprintState createState() => _FingerprintState();
}

class _FingerprintState extends State<Fingerprint> {
  @override
  void initState() {
    addData();
    super.initState();
  }

  addData() async {
    UserProvider _userProvider =
        Provider.of<UserProvider>(context, listen: false);
    await _userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      StorageSwitch().getAuthState().then((value) {
        if (value == false) {
          Get.offNamed(AppRoutes.main);
        } else {
          ScreenLook(ctx: context).authUser(
              path: 'splash', message: "ضع بصمة الاصبع للدخول للتطبيق");
        }
      });
    });
    return const Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: InkWell(
            child: Center(
          child: CircularProgressIndicator(
            color: AppColors.orange,
          ),
        )),
      ),
    );
  }
}
