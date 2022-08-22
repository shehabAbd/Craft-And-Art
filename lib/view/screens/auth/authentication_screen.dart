library authentication_view;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logandsign/logic/controllers/authentication_controller.dart';
import 'package:logandsign/styles/text_header.dart';
import 'package:logandsign/utils/app_colors.dart';
import 'package:logandsign/utils/text_utils.dart';

import 'package:sms_autofill/sms_autofill.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({Key? key}) : super(key: key);

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  final AuthenticationController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
                child: Stack(children: [
      Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: AppColors.orange,
      ),
      const CustomHeader(
        text: 'كود التحقق',
      ),
      Positioned(
          top: MediaQuery.of(context).size.height * 0.1,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.9,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60))),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        RichText(
                          text: TextSpan(
                              style: Theme.of(context).textTheme.bodyText2,
                              children: [
                                const TextSpan(
                                    text: " الرجاء ادخال الكود المرسل للرقم ",
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text: controller.phoneNumber ??
                                        controller.registrant?.phone ??
                                        "-",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6!
                                        .copyWith(fontSize: 16))
                              ]),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                      width: Get.width * 0.5,
                      height: Get.width * 0.5,
                      child: Image.asset("assets/logo.png")),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Form(
                      key: controller.formKey,
                      child: Container(
                        child: Theme(
                          data: ThemeData(
                            inputDecorationTheme: InputDecorationTheme(
                                fillColor: Theme.of(context).canvasColor),
                          ),
                          child: PinFieldAutoFill(
                            controller: controller.otp,
                            codeLength: 6,
                            decoration: BoxLooseDecoration(
                              bgColorBuilder:
                                  FixedColorBuilder(Colors.grey[300]!),
                              strokeColorBuilder:
                                  FixedColorBuilder(Colors.grey[300]!),
                              gapSpace: 10,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Obx(
                      () => Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.06,
                        margin: const EdgeInsets.only(left: 20, right: 20),
                        decoration: const BoxDecoration(
                            color: AppColors.orange,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Center(
                          child: InkWell(
                            onTap: controller.isLoading.value
                                ? null
                                : () => controller.verifySmsCode(),
                            child: controller.isLoading.value
                                ? const SizedBox(
                                    width: 30,
                                    height: 30,
                                    child: CircularProgressIndicator(),
                                  )
                                : SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: const Center(
                                      child: TextUtils(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          text: "تحقق",
                                          color: Colors.black,
                                          underLine: TextDecoration.none),
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("لم يتم أستقبال كود التحقق "),
                        Obx(
                          () => TextButton(
                            onPressed: (controller.isCanResendCode.value)
                                ? () => controller.verifyPhoneNumber()
                                : null,
                            child: Text((controller.durationCountdown.value) > 0
                                ? "resend (${controller.durationCountdown.value})"
                                : "إعادة الإرسال"),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ))
    ]))));
  }
}
