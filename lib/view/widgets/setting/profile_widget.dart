import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logandsign/logic/controllers/auth_controller.dart';
import 'package:logandsign/utils/app_colors.dart';
import 'package:logandsign/utils/text_utils.dart';

class ProfileWidget extends StatelessWidget {
  ProfileWidget({Key? key}) : super(key: key);

  final controller = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.hintText.withOpacity(0.5),
                    spreadRadius: 10,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 30,
                backgroundImage:
                    NetworkImage(controller.displayUserPhoto.value),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                TextUtils(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  text: "Name:${controller.displayUserName}",
                  color: Colors.black,
                  underLine: TextDecoration.none,
                ),
                const SizedBox(height: 10),
                TextUtils(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  text: "Email:${controller.displayUserEmail}",
                  color: Colors.black,
                  underLine: TextDecoration.none,
                ),
              ],
            ),
          ],
        )
      ],
    );
  }
}
