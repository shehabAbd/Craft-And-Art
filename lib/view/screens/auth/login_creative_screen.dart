import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logandsign/logic/controllers/login_controller.dart';
import 'package:logandsign/utils/app_colors.dart';
import 'package:logandsign/utils/background_creative.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LoginController controller = Get.find();

    return Scaffold(
        body: SingleChildScrollView(
      child: Stack(children: [
        BackgroundCreative(),
        Column(children: [
          Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Container(
              margin: const EdgeInsets.only(top: 350),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                              color: Color.fromARGB(51, 56, 56, 58),
                              blurRadius: 20.0,
                              offset: Offset(0, 10))
                        ]),
                    child: Form(
                      key: controller.formKey,
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.only(top: 8, right: 8, left: 8),
                            child: GetBuilder<LoginController>(
                              builder: (_) {
                                return TextFormField(
                                  keyboardType: TextInputType.phone,
                                  controller: controller.phoneNumber,
                                  maxLength: 9,
                                  validator: (value) {
                                    if (value.toString().length < 9) {
                                      return "يجب أن لا يقل الرقم عن 9 أرقام";
                                    } else if (value!.isEmpty) {
                                      return 'الرجاء ادخال رقم الهاتف';
                                    } else {
                                      return null;
                                    }
                                  },
                                  decoration: InputDecoration(
                                      prefixIcon: const Icon(
                                        Icons.phone,
                                        color: AppColors.orange,
                                      ),
                                      border: InputBorder.none,
                                      hintText: "phone",
                                      hintStyle:
                                          TextStyle(color: Colors.grey[400])),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: const LinearGradient(colors: [
                          AppColors.orange,
                          AppColors.orange,
                        ])),
                    child: Center(
                      child: GetBuilder<LoginController>(
                        builder: (_) {
                          return InkWell(
                            onTap: () {
                              controller.login();
                              FirebaseMessaging.instance.subscribeToTopic('on');
                              FirebaseMessaging.instance
                                  .unsubscribeFromTopic('exit');
                            },
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: const Center(
                                child: Text(
                                  "تسجيل الدخول",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  GetBuilder<LoginController>(
                    builder: (_) {
                      return InkWell(
                        onTap: () {
                          controller.goToRegistrationScreen();
                        },
                        child: const Text(
                          "انشاء حساب",
                          style: TextStyle(
                              color: Color.fromARGB(255, 44, 41, 32),
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                      );
                    },
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
