import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logandsign/logic/controllers/auth_controller.dart';
import 'package:logandsign/utils/text_utils.dart';

class LogOutWidget extends StatelessWidget {
  LogOutWidget({Key? key}) : super(key: key);

  final controller = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (_) => Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Get.defaultDialog(
              title: "الخروج من التطبيق",
              titleStyle: const TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              middleText: 'هل انت متأكد من الخروج',
              middleTextStyle: const TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              backgroundColor: Colors.white,
              radius: 10,
              textCancel: " لا ",
              cancelTextColor: Colors.orange,
              textConfirm: " نعم ",
              confirmTextColor: Colors.orange,
              onCancel: () {
                Get.obs;
              },
              onConfirm: () {
                Get.back();
                FirebaseMessaging.instance.subscribeToTopic('exit');
                FirebaseMessaging.instance.unsubscribeFromTopic("on");

                FirebaseMessaging.instance.unsubscribeFromTopic('all');
                controller.signOutFromApp();
              },
            );
          },
          splashColor: Colors.orange,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.orange,
                ),
                child: const Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              TextUtils(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                text: "خروج".tr,
                color: Get.isDarkMode ? Colors.white : Colors.black,
                underLine: TextDecoration.none,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
