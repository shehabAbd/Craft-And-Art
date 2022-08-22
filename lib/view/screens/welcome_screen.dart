import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:logandsign/logic/controllers/auth_controller.dart';
import 'package:logandsign/model/user_model.dart';
import 'package:logandsign/routes/routes.dart';
import 'package:logandsign/service/storage_methods.dart';
import 'package:logandsign/utils/app_colors.dart';
import 'package:logandsign/styles/custom_button_blue.dart';
import 'package:logandsign/styles/custom_button_orange.dart';
import 'package:logandsign/view/screens/auth/login_user_screen.dart';
import 'package:logandsign/utils/text_utils.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final controller = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.white,
          body: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.3,
                child: Image.asset("assets/logo.png"),
              ),
              orange_Button(
                  onTap: () {
                    Get.toNamed(Routes.loginCreativeScreen);
                  },
                  text: "حرفي"),
              SizedBox(
                height: 20,
              ),
              Blue_Button(
                  onTap: () {
                    Get.toNamed(Routes.loginUserScreen);
                  },
                  text: "مشتري"),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  InkWell(
                    onTap: () {
                      controller.signUpVisitor(
                          name: " زائر",
                          type: "visitor",
                          photoUrl:
                              "https://firebasestorage.googleapis.com/v0/b/iam-creative.appspot.com/o/profileUserPhotos%2FpH7dmYvPDcf5PSHQTKHT0ljDH3u1?alt=media&token=c42c2ff0-9d3d-407a-9d28-6ae93fdedb1c",
                          blocked: "no");
                    },
                    child: const Text(
                      "زائر",
                      style: TextStyle(
                          decoration: TextDecoration.underline, fontSize: 20),
                    ),
                  ),
                ]),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
