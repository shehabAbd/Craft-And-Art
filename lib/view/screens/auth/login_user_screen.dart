// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:logandsign/logic/controllers/auth_controller.dart';
import 'package:logandsign/routes/routes.dart';
import 'package:logandsign/utils/app_colors.dart';
import 'package:logandsign/utils/background_user.dart';
import 'package:logandsign/utils/my_string.dart';

class LoginUser extends StatefulWidget {
  const LoginUser({Key? key}) : super(key: key);

  @override
  State<LoginUser> createState() => _LoginUserState();
}

class _LoginUserState extends State<LoginUser> {
  final formKey = GlobalKey<FormState>();

  final TextEditingController _EmailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  var controller = Get.find<AuthController>();
  final bool _isLoading = false;
  @override
  void dispose() {
    super.dispose();
    _EmailController.dispose();
    _passwordController.dispose();
  }

  var token;
  getToken() async {
    token = await FirebaseMessaging.instance.getToken();
  }

  Timer? _timer;
  @override
  void initState() {
    getToken();
    
    EasyLoading.addStatusCallback((status) {
      print('EasyLoading Status $status');
      if (status == EasyLoadingStatus.dismiss) {
        _timer?.cancel();
      }
    });
    configLoading();
    super.initState();
  }

  void configLoading() {
    EasyLoading.instance
      ..displayDuration = const Duration(
        milliseconds: 3500,
      )
      ..indicatorType = EasyLoadingIndicatorType.fadingCircle
      ..loadingStyle = EasyLoadingStyle.custom
      ..indicatorSize = 45.0
      ..radius = 15.0
      ..lineWidth = 2
      ..progressColor = Colors.orange
      ..backgroundColor = AppColors.blue
      ..indicatorColor = Colors.white
      ..textColor = Colors.orange;
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Stack(children: [
        BackgroundUser(),
        Column(children: [
          Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Container(
              margin: const EdgeInsets.only(top: 330),
            ),
            Padding(
              padding: EdgeInsets.all(30.0),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                              color: Color.fromRGBO(143, 148, 251, .2),
                              blurRadius: 20.0,
                              offset: Offset(0, 10))
                        ]),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(color: Colors.grey[300]!)),
                            ),
                            child: TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              controller: _EmailController,
                              validator: (value) {
                                if (value.toString().length <= 2) {
                                  return "يجب أن لا يقل الأيميل عن 8 أحرف";
                                } else if (!RegExp(validationEmail)
                                    .hasMatch(value!)) {
                                  return 'التنسيق غير صحيح';
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.email,
                                    color: AppColors.blue,
                                  ),
                                  border: InputBorder.none,
                                  hintText: "Email",
                                  hintStyle:
                                      TextStyle(color: Colors.grey[400])),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(8.0),
                            child: GetBuilder<AuthController>(
                              builder: (_) {
                                return TextFormField(
                                  controller: _passwordController,
                                  obscureText:
                                      controller.isvisibilty ? false : true,
                                  validator: (value) {
                                    if (value.toString().length <= 8) {
                                      return "يجب أن لا تقل كملة السر عن 8 أحرف";
                                    } else if (!RegExp(validationPassword)
                                        .hasMatch(value!)) {
                                      return ' يجب أن تحتوي على الاقل على رقم ويمنع استخدام الحروف العربية ';
                                    } else {
                                      return null;
                                    }
                                  },
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.lock,
                                        color: AppColors.blue,
                                      ),
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          controller.visibilty();
                                        },
                                        icon: controller.isvisibilty
                                            ? Icon(
                                                Icons.visibility,
                                                color: AppColors.lightblue,
                                              )
                                            : Icon(
                                                Icons.visibility_off,
                                                color: AppColors.blackshade,
                                              ),
                                      ),
                                      border: InputBorder.none,
                                      hintText: "Password",
                                      hintStyle:
                                          TextStyle(color: Colors.grey[400])),
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(colors: const [
                          AppColors.blue,
                          Color.fromARGB(153, 95, 95, 139),
                        ])),
                    child: Center(
                      child: GetBuilder<AuthController>(
                        builder: (_) {
                          return InkWell(
                            onTap: () {
                              if (formKey.currentState!.validate()) {
                                FirebaseMessaging.instance
                                    .subscribeToTopic('on');
                                FirebaseMessaging.instance
                                    .subscribeToTopic('All');
                                FirebaseMessaging.instance
                                    .unsubscribeFromTopic('exit');
                                return controller.loginUser(
                                    token: token,
                                    email: _EmailController.text,
                                    password: _passwordController.text);
                              } else {
                                return;
                              }
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: Center(
                                child: Text(
                                  "تسجيل الدخول",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            Get.toNamed(AppRoutes.forgetPassword);
                          },
                          child: Text(
                            "Forget Password ?",
                            style: TextStyle(
                              color: Color.fromARGB(255, 1, 41, 37),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  InkWell(
                    onTap: () {
                      Get.toNamed(AppRoutes.signUpUser);
                    },
                    child: Text(
                      "انشاء حساب",
                      style: TextStyle(
                          color: Color.fromARGB(255, 1, 41, 37),
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                  ),
                ],
              ),
            )
          ]),
        ]),
      ]),
    ));
  }
}

