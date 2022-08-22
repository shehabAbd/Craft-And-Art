// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logandsign/utils/acceptGreen.dart';
import 'package:logandsign/utils/acceptOrange.dart';
import 'package:logandsign/logic/controllers/auth_controller.dart';
import 'package:logandsign/utils/app_colors.dart';
import 'package:logandsign/utils/text_utils.dart';

class CheckWidget extends StatelessWidget {
  final controller = Get.find<AuthController>();

  CheckWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (_) {
        return Container(
          padding: const EdgeInsets.only(right: 20),
          child: Row(
            children: [
              InkWell(
                onTap: () {},
                child: Container(
                  height: 35,
                  width: 35,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                    onPressed: () {
                      controller.checkbox();
                    },
                    icon: controller.ischeckbox
                        ? const Icon(
                            Icons.check,
                            color: AppColors.lightblue,
                          )
                        : Container(),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Row(
                children: [
                  TextUtils(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    text: "قبول ",
                    color: AppColors.lightblue,
                    underLine: TextDecoration.none,
                  ),
                  InkWell(
                    onTap: () {
                      Get.to(acceptGreen());
                    },
                    child: TextUtils(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      text: "السياسة و الخصوصية",
                      color: AppColors.lightblue,
                      underLine: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
