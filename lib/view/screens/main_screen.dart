

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logandsign/logic/controllers/main_controller.dart';
import 'package:logandsign/providers/user_provider.dart';
import 'package:logandsign/utils/app_colors.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {   
    super.initState();
    addData();
  }

  addData() async {
    UserProvider _userProvider =
        Provider.of<UserProvider>(context, listen: false);
    await _userProvider.refreshUser();
  }

  final controller = Get.put(MainController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(
        () {
          return Scaffold(
            bottomNavigationBar: CurvedNavigationBar(
              items: const <Widget>[
                Icon(
                  Icons.settings,
                  size: 30,
                ),
                Icon(
                  Icons.message,
                  size: 30,
                ),
                Icon(
                  Icons.home,
                  size: 30,
                ),
                Icon(
                  Icons.favorite,
                  size: 30,
                ),
                Icon(
                  Icons.search,
                  size: 30,
                ),
              ],
              color: AppColors.grayshade,
              buttonBackgroundColor: AppColors.orange,
              backgroundColor: AppColors.white,
              animationCurve: Curves.easeInOut,
              animationDuration: const Duration(milliseconds: 500),
              onTap: (index) {
                controller.curentindex.value = index;
              },
              
              index: controller.curentindex.value,
              height: 50.5,
            ),
            body: IndexedStack(
              index: controller.curentindex.value,
              children: controller.tabs.value,
            ),
          );
        },
      ),
    );
  }
}
