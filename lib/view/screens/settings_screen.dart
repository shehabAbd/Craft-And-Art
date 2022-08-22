

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:logandsign/view/widgets/auth/screen_look.dart';
import 'package:logandsign/view/widgets/auth/storage_switch.dart';
import 'package:logandsign/utils/app_colors.dart';
import 'package:logandsign/utils/text_utils.dart';
import 'package:logandsign/view/widgets/setting/Craft_Search_widget.dart';
import 'package:logandsign/view/widgets/setting/logout_widget.dart';
import 'package:logandsign/view/widgets/setting/report_widget.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _secured = false;

  @override
  void initState() {
    super.initState();

    StorageSwitch().getAuthState().then((value) {
      setState(() {
        _secured = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.orange,
          title: const Text(
            "الاعدادات",
            style: TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        body: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(
              height: 20,
            ),
            TextUtils(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                text: "عام".tr,
                color: Colors.black,
                underLine: TextDecoration.none),
            const SizedBox(
              height: 20,
            ),
            GetCreativeWidget(),
            const SizedBox(
              height: 20,
            ),
            const ReportWidget(),
            const SizedBox(
              height: 20,
            ),
            LogOutWidget(),
            const SizedBox(
              height: 20,
            ),
            ListTile(
              selectedColor: AppColors.orange,
              iconColor: AppColors.orange,
              
              title: const Text(
                "تأمين حسابك",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text("التأمين بإستخدام البصمة"),
              trailing: Switch(
                  activeColor: AppColors.orange,
                  value: _secured,
                  onChanged: (value) {
                    setState(() {
                      _secured = value;
                    });
                    ScreenLook(ctx: context).authUser(
                        path: "acc",
                        value: value,
                        message: "تأكيد بصمة الأصبع");
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
