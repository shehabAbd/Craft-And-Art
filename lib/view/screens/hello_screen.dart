import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logandsign/providers/user_provider.dart';
import 'package:logandsign/routes/routes.dart';
import 'package:provider/provider.dart';

class HelloScreen extends StatefulWidget {
  const HelloScreen({Key? key}) : super(key: key);

  @override
  _HelloScreenState createState() => _HelloScreenState();
}

class _HelloScreenState extends State<HelloScreen> {
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
    Future.delayed(const Duration(seconds: 1), () {
      Get.toNamed(AppRoutes.main);
    });

    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          body: SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: InkWell(
              child: Image.asset(
                "assets/welcome.jpg",
                fit: BoxFit.fill,
              ),
            ),
          )),
    );
  }
}
