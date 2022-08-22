import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logandsign/logic/controllers/settings_controller.dart';
import 'package:logandsign/utils/text_utils.dart';
import 'package:logandsign/view/screens/get_creative.dart';

class GetCreativeWidget extends StatelessWidget {
  GetCreativeWidget({Key? key}) : super(key: key);

  final controller = Get.put(SettingController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingController>(
        builder: (_) =>
            InkWell(
              onTap: () {
                Get.to(const GetCreative());
              },
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.orange,
                      ),
                      child: const Icon(Icons.person,color: Colors.white),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    TextUtils(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      text: " عرض الحرفيين".tr,
                      color: Colors.black,
                      underLine: TextDecoration.none,
                    ),
                  ],
                ),
              ]),
            ));
  }
}
