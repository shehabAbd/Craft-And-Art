// ignore_for_file: unnecessary_null_comparison, prefer_const_constructors

library registration_view;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:logandsign/utils/acceptOrange.dart';
import 'package:logandsign/logic/controllers/registration_controller.dart';
import 'package:logandsign/styles/text_header.dart';
import 'package:logandsign/utils/app_colors.dart';
import 'package:logandsign/utils/my_string.dart';
import 'package:logandsign/utils/text_utils.dart';
import 'package:logandsign/view/widgets/auth/custom_form_field.dart';

class RegistrationScreen extends GetView<RegistrationController> {
  RegistrationScreen({Key? key}) : super(key: key);
  var token;
  Future getToken() async {
    token = await FirebaseMessaging.instance.getToken();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          body: SafeArea(
              child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: AppColors.white,
              ),
              const CustomHeader(
                text: 'حرفي',
              ),
              Positioned(
                  // top: MediaQuery.of(context).size.height * 0.1,
                  child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60))),
                child: SingleChildScrollView(
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        GetBuilder<RegistrationController>(
                          builder: (_) => Stack(
                            children: [
                              controller.image != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(70),
                                      child: SizedBox(
                                          width: 140,
                                          height: 140,
                                          child: Image.file(
                                            controller.image!,
                                            fit: BoxFit.cover,
                                          )))
                                  // backgroundColor: Colors.red,

                                  : const CircleAvatar(
                                      radius: 70,
                                      backgroundImage: AssetImage(
                                        "assets/profile.jpg",
                                      ),
                                      backgroundColor: AppColors.orange,
                                    ),
                              Positioned(
                                bottom: -10,
                                left: 80,
                                child: IconButton(
                                  onPressed: () {
                                    controller.selectImage();
                                  },
                                  icon: const Icon(
                                    Icons.add_a_photo,
                                    color: AppColors.orange,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          child: AuthTextFromField(
                              controller: controller.name,
                              obscureText: false,
                              validator: (value) {
                                if (value.toString().length <= 2) {
                                  return "يجب أن لا يقل الإسم عن 2 أحرف";
                                } else if (RegExp(validationName)
                                    .hasMatch(value)) {
                                  return 'يجب أن لايحتوي الإسم على رقم او رمز';
                                } else {
                                  return null;
                                }
                              },
                              prefixIcon: const Icon(FontAwesomeIcons.person),
                              suffixIcon: const Text(""),
                              hintText: "الإسم واللقب",
                              keyboardType: TextInputType.text),
                        ),
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 0),
                            child: Obx(
                              () => Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("ذكر"),
                                  Radio(
                                      value: "ذكر",
                                      groupValue: controller.gender.value,
                                      onChanged: (val) {
                                        controller.onChangeGender(val);
                                      }),
                                  const Text("انثى"),
                                  Radio(
                                    value: "انثى",
                                    groupValue: controller.gender.value,
                                    onChanged: (val) {
                                      controller.onChangeGender(val);
                                    },
                                  ),
                                ],
                              ),
                            )),
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 0),
                            child: Container(
                              padding: const EdgeInsets.only(
                                  right: 20, left: 20, top: 10, bottom: 10),
                              child: TextFormField(
                                controller: controller.phoneNumber,
                                cursorColor: Colors.black,
                                keyboardType: TextInputType.phone,
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
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                                decoration: InputDecoration(
                                  fillColor: Colors.grey.shade200,
                                  prefixIcon: const Icon(Icons.phone),
                                  hintText: "رقم الهاتف",
                                  hintStyle: const TextStyle(
                                    color: Colors.black45,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  filled: true,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            )),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          child: AuthTextFromField(
                              controller: controller.address,
                              obscureText: false,
                              validator: (value) {
                                if (value.toString().length <= 2) {
                                  return "يجب أن لا يقل الإسم عن 2 أحرف";
                                } else if (RegExp(validationName)
                                    .hasMatch(value)) {
                                  return 'يجب أن لايحتوي الإسم على رقم او رمز';
                                } else {
                                  return null;
                                }
                              },
                              prefixIcon:
                                  const Icon(FontAwesomeIcons.mapLocation),
                              suffixIcon: const Text(""),
                              hintText: "المنطقة",
                              keyboardType: TextInputType.text),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          child: AuthTextFromField(
                              controller: controller.career,
                              obscureText: false,
                              validator: (value) {
                                if (value.toString().length <= 2) {
                                  return "يجب أن لا يقل الإسم عن 2 أحرف";
                                } else if (RegExp(validationName)
                                    .hasMatch(value)) {
                                  return 'يجب أن لايحتوي الإسم على رقم او رمز';
                                } else {
                                  return null;
                                }
                              },
                              prefixIcon:
                                  const Icon(FontAwesomeIcons.alignRight),
                              suffixIcon: const Text(""),
                              hintText: "المهنة",
                              keyboardType: TextInputType.text),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          child: AuthTextFromField(
                              controller: controller.facebook,
                              obscureText: false,
                              validator: (value) {
                                if (value.toString().length == null) {
                                  return null;
                                }
                              },
                              prefixIcon: Icon(
                                FontAwesomeIcons.facebook,
                                color: Colors.blue[900],
                              ),
                              suffixIcon: const Text(""),
                              hintText: " رابط حسابك في فيس بوك (اختياري)",
                              keyboardType: TextInputType.text),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          child: AuthTextFromField(
                              controller: controller.instagram,
                              obscureText: false,
                              validator: (value) {
                                if (value.toString().length == null) {
                                  return null;
                                }
                              },
                              prefixIcon: const Icon(
                                FontAwesomeIcons.instagram,
                                color: Colors.pink,
                              ),
                              suffixIcon: const Text(""),
                              hintText: " رابط حسابك في الأنستقرام (اختياري)",
                              keyboardType: TextInputType.text),
                        ),
                        GetBuilder<RegistrationController>(
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
                                          Get.to(acceptOrange());
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
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Obx(
                            () => Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.06,
                              margin:
                                  const EdgeInsets.only(left: 20, right: 20),
                              decoration: const BoxDecoration(
                                  color: AppColors.orange,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: Center(
                                child: InkWell(
                                  onTap: controller.isLoading.value
                                      ? null
                                      : () {
                                          getToken();
                                          FirebaseMessaging.instance
                                              .subscribeToTopic('AllCreative');
                                          FirebaseMessaging.instance
                                              .subscribeToTopic('All');
                                          controller.register();
                                        },
                                  child: controller.isLoading.value
                                      ? const SizedBox(
                                          width: 30,
                                          height: 30,
                                          child: CircularProgressIndicator(),
                                        )
                                      : const SizedBox(
                                          width: double.infinity,
                                          child: Center(
                                            child: TextUtils(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                text: "انشاء حساب",
                                                color: Colors.black,
                                                underLine: TextDecoration.none),
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ))
            ],
          )),
        ));
  }
}
