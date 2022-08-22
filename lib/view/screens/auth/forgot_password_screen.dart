import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:logandsign/logic/controllers/auth_controller.dart';
import 'package:logandsign/utils/app_colors.dart';
import 'package:logandsign/styles/custom_button_blue.dart';
import 'package:logandsign/utils/my_string.dart';
import 'package:logandsign/view/widgets/auth/custom_form_field.dart';
import 'package:logandsign/utils/text_utils.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();

  final controller = Get.find<AuthController>();
  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
  }

  Timer? _timer;
  @override
  void initState() {
    // controller.loginUser(
    //     email: _EmailController.text, password: _passwordController.text);
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
      ..progressColor = Colors.white
      ..backgroundColor = AppColors.blue
      ..indicatorColor = AppColors.orange
      ..textColor = Colors.orange;
    // ..maskColor = Colors.blue.withOpacity(0.5)
    // ..userInteractions = true
    // ..dismissOnTap = false;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            centerTitle: true,
            elevation: 0,
            title: const TextUtils(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                text: "",
                color: Colors.white,
                underLine: TextDecoration.none),
            leading: InkWell(
              onTap: () {},
              child: CircleAvatar(
                //radius: 20,
                backgroundColor: AppColors.white,
                child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: AppColors.blue,
                    ),
                    onPressed: () {
                      Get.back();
                    }),
              ),
            ),
          ),
          body: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    const TextUtils(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        text: "لتغيير كلمة السر يرجى ادخال بريدك الألكتروني",
                        color: AppColors.blue,
                        underLine: TextDecoration.none),
                    const SizedBox(
                      height: 50,
                    ),
                    Image.asset(
                      'assets/fogetPassw.png',
                      width: 400,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    AuthTextFromField(
                        controller: emailController,
                        obscureText: false,
                        validator: (value) {
                          if (value.toString().length <= 2) {
                            return "يجب أن لا يقل الأيميل عن 8 أحرف";
                          } else if (!RegExp(validationEmail).hasMatch(value)) {
                            return 'التنسيق غير صحيح';
                          } else {
                            return null;
                          }
                        },
                        prefixIcon: const Icon(Icons.email),
                        suffixIcon: const Text(""),
                        hintText: "الأيميل",
                        keyboardType: TextInputType.emailAddress),
                    const SizedBox(
                      height: 20,
                    ),
                    GetBuilder<AuthController>(
                      builder: (_) => Blue_Button(
                          onTap: () {
                            AwesomeDialog(
                              btnOkColor: AppColors.blue,

                              //width: 300,
                              context: context,
                              dialogType: DialogType.INFO,
                              animType: AnimType.SCALE,
                              title: 'إعادة تعيين كلمة السر',
                              desc:
                                  'سوف يتم إرسال إعادة تعيين كلمة السر الي حسابك الألكتروني',
                              btnCancelOnPress: () {
                                Navigator.push;
                              },
                              btnOkOnPress: () {
                                if (formKey.currentState!.validate()) {
                                  String email = emailController.text.trim();
                                  controller.resetPassword(email);
                                }
                              },
                            ).show();
                          },
                          text: "إرسال"),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
