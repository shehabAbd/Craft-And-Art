import 'dart:async';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logandsign/logic/controllers/auth_controller.dart';
import 'package:logandsign/routes/routes.dart';
import 'package:logandsign/styles/custom_button_blue.dart';
import 'package:logandsign/utils/app_colors.dart';
import 'package:logandsign/styles/text_header.dart';
import 'package:logandsign/utils/my_string.dart';
import 'package:logandsign/view/widgets/auth/check_widget.dart';
import 'package:logandsign/view/widgets/auth/custom_form_field.dart';
import 'package:logandsign/view/widgets/auth/custom_richtext.dart';

class SignUpUser extends StatefulWidget {
  const SignUpUser({Key? key}) : super(key: key);

  @override
  State<SignUpUser> createState() => _SignUpUserState();
}

class _SignUpUserState extends State<SignUpUser> {
  final formKey = GlobalKey<FormState>();
  var confirmPass;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  File? image;

  var token;
  getToken() async {
    token = await FirebaseMessaging.instance.getToken();
  }

  final controller = Get.find<AuthController>();
  void selectImage() async {
    var pickedImage = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 15);
    if (pickedImage != null) {
      setState(() {
        image = File(pickedImage.path);
      });
    }
    setState(() {});
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
      ..backgroundColor = Color.fromARGB(255, 8, 22, 87)
      ..indicatorColor = Colors.white
      ..textColor = Colors.orange;
   
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: AppColors.blue,
                ),
                CustomHeader(
                  text: 'مشتري',
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.1,
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(60),
                            topRight: Radius.circular(60))),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Stack(
                            children: [
                              image != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(70),
                                      child: Container(
                                          width: 140,
                                          height: 140,
                                          child: Image.file(
                                            image!,
                                            fit: BoxFit.cover,
                                          )))
                                  : CircleAvatar(
                                      radius: 70,
                                      backgroundImage: AssetImage(
                                        "assets/profile.jpg",
                                      ),
                                      backgroundColor: AppColors.blue,
                                    ),
                              Positioned(
                                bottom: -10,
                                left: 80,
                                child: IconButton(
                                  onPressed: () {
                                    selectImage();
                                  },
                                  icon: const Icon(
                                    Icons.add_a_photo,
                                    color: AppColors.blue,
                                  ),
                                ),
                              )
                            ],
                          ),
                          AuthTextFromField(
                              controller: nameController,
                              obscureText: false,
                              validator: (value) {
                                confirmPass = value;
                                if (value.toString().length <= 2) {
                                  return "يجب أن لا يقل الإسم عن 2 أحرف";
                                } else if (RegExp(validationName)
                                    .hasMatch(value)) {
                                  return 'يجب أن لايحتوي الإسم على رقم او رمز';
                                } else {
                                  return null;
                                }
                              },
                              prefixIcon: Icon(Icons.person),
                              suffixIcon: Text(""),
                              hintText: "الإسم",
                              keyboardType: TextInputType.text),
                          AuthTextFromField(
                              controller: emailController,
                              obscureText: false,
                              validator: (value) {
                                if (value.toString().length <= 2) {
                                  return "يجب أن لا يقل الأيميل عن 8 أحرف";
                                } else if (!RegExp(validationEmail)
                                    .hasMatch(value)) {
                                  return 'التنسيق غير صحيح';
                                } else {
                                  return null;
                                }
                              },
                              prefixIcon: Icon(Icons.email),
                              suffixIcon: Text(""),
                              hintText: "الايميل ",
                              keyboardType: TextInputType.emailAddress),
                          GetBuilder<AuthController>(
                            builder: (_) {
                              return AuthTextFromField(
                                  controller: passwordController,
                                  obscureText:
                                      controller.isvisibilty ? false : true,
                                  validator: (value) {
                                    confirmPass = value;
                                    if (value.toString().length <= 8) {
                                      return "يجب أن لا تقل كملة السر عن 8 أحرف";
                                    } else if (!RegExp(validationPassword)
                                        .hasMatch(value)) {
                                      return 'يجب أن تحتوي على الاقل حرف ورقم';
                                    } else {
                                      return null;
                                    }
                                  },
                                  prefixIcon: Icon(Icons.lock),
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
                                  hintText: "كلمةالمرور",
                                  keyboardType: TextInputType.text);
                            },
                          ),
                          GetBuilder<AuthController>(
                            builder: (_) {
                              return AuthTextFromField(
                                  controller: confirmPasswordController,
                                  obscureText:
                                      controller.isvisibilty ? false : true,
                                  validator: (Value) {
                                    if (Value != confirmPass) {
                                      return "كلمة السر لا تتطابق";
                                    } else {
                                      return null;
                                    }
                                  },
                                  prefixIcon: Icon(Icons.lock),
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
                                  hintText: "تأكيد كلمةالمرور",
                                  keyboardType: TextInputType.text);
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          CheckWidget(),
                          const SizedBox(
                            height: 10,
                          ),
                          GetBuilder<AuthController>(
                              builder: (_) => Blue_Button(
                                  onTap: () {
                                    if (controller.ischeckbox == false) {
                                      EasyLoading.showInfo(
                                          "الرجاء قبول سياسة الخصوصية");
                                    } else if (formKey.currentState!
                                            .validate() &&
                                        image != null) {
                                      FirebaseMessaging.instance
                                          .subscribeToTopic('All');
                                      FirebaseMessaging.instance
                                          .subscribeToTopic('on');
                                      controller.signUpUser(
                                          token: token,
                                          email: emailController.text,
                                          file: image!,
                                          name: nameController.text,
                                          password: passwordController.text,
                                          type: "user",
                                          blocked: "no");
                                      controller.ischeckbox = true;
                                    } else if (image == null) {
                                      EasyLoading.showInfo(
                                          'الرجاء اختيار صورة');
                                    }
                                  },
                                  text: "انشاء حساب")),
                          const SizedBox(
                            height: 10,
                          ),
                          CustomRichText(
                            color: Get.isDarkMode
                                ? AppColors.lightblue
                                : AppColors.lightblue,
                            discription: 'إذا كنت تملك حساب ',
                            text: 'إضغط هنا ',
                            onTap: () {
                              Get.toNamed(AppRoutes.loginUser);
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
