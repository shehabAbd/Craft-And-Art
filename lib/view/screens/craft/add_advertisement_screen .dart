// ignore_for_file: must_be_immutable, unused_field, unused_element, unused_local_variable
import 'dart:io';

//import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logandsign/api/messaging.dart';
import 'package:logandsign/providers/user_provider.dart';
import 'package:logandsign/service/firestore_methods.dart';
import 'package:logandsign/styles/custom_button_blue.dart';
import 'package:logandsign/utils/app_colors.dart';
import 'package:logandsign/utils/my_string.dart';
import 'package:logandsign/view/screens/main_screen.dart';
import 'package:logandsign/view/widgets/auth/custom_form_field.dart';
import 'package:provider/provider.dart';

class AddAdvertisementScreen extends StatefulWidget {
  const AddAdvertisementScreen({Key? key}) : super(key: key);

  @override
  State<AddAdvertisementScreen> createState() => _AddAdvertisementScreenState();
}

class _AddAdvertisementScreenState extends State<AddAdvertisementScreen> {
  final TextEditingController AdsNameController = TextEditingController();

  final TextEditingController AdscuttoffController = TextEditingController();

  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  File? _image;
  bool isLoading = false;

  void postAdsImage(String uid, String name, String profImage) async {
    // start the loading
    try {
      EasyLoading.show(status: "جاري الاضافة");
      // upload to storage and db
      String res = await FireStoreMethods().uploadAdvertisement(
        uid,
        AdsNameController.text,
        AdscuttoffController.text,
        _image!,

        // token,
      );

      if (res == "success") {
        clearImage();
        EasyLoading.showSuccess("تمت  اضافة الاعلان بنجاح ",
            duration: const Duration(microseconds: 500));
        await sendNotification("on", name);

        Get.to(const MainScreen());
      } else {
        String message = ' لا يوجود اتصال بالانترنت ';
        EasyLoading.showInfo(message);
      }
    } catch (e) {
      EasyLoading.showInfo(e.toString());
    }
  }

  void clearImage() {
    setState(() {
      _image = null;
      AdsNameController.clear();
      AdscuttoffController.clear();
    });
  }

  _selectImage(BuildContext parentContext) async {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: SimpleDialog(
            title: const Text('إختيار صورة الاعلان'),
            children: <Widget>[
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('التقاط من الكاميرا'),
                onPressed: () async {
                  Navigator.pop(context);
                  final pickedImage = await ImagePicker()
                      .pickImage(source: ImageSource.camera, imageQuality: 15);
                  if (pickedImage != null) {
                    CroppedFile? croppedFile = await ImageCropper().cropImage(
                      sourcePath: pickedImage.path,
                      aspectRatioPresets: [
                        CropAspectRatioPreset.square,
                      ],
                      uiSettings: [
                        AndroidUiSettings(
                            toolbarTitle: 'قص',
                            toolbarColor: Colors.deepOrange,
                            toolbarWidgetColor: Colors.white,
                            initAspectRatio: CropAspectRatioPreset.original,
                            lockAspectRatio: true),
                        IOSUiSettings(
                          title: 'قص',
                        ),
                      ],
                    );

                    if (croppedFile != null) {
                      setState(() {
                        _image = File(croppedFile.path);
                      });
                    }
                  }
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('اختر من المعرض'),
                onPressed: () async {
                  Navigator.pop(context);
                  var pickedImage = await ImagePicker()
                      .pickImage(source: ImageSource.gallery, imageQuality: 15);
                  if (pickedImage != null) {
                    CroppedFile? croppedFile = await ImageCropper().cropImage(
                      sourcePath: pickedImage.path,
                      aspectRatioPresets: [
                        CropAspectRatioPreset.square,
                      ],
                      uiSettings: [
                        AndroidUiSettings(
                            toolbarTitle: 'قص',
                            toolbarColor: Colors.deepOrange,
                            toolbarWidgetColor: Colors.white,
                            initAspectRatio: CropAspectRatioPreset.original,
                            lockAspectRatio: true),
                        IOSUiSettings(
                          title: 'قص',
                        ),
                      ],
                    );

                    if (croppedFile != null) {
                      setState(() {
                        _image = File(croppedFile.path);
                      });
                    }
                  }
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text("الغاء"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Stack(children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  isLoading
                      ? const CircularProgressIndicator(
                          color: AppColors.orange,
                        )
                      : const Center(),
                  Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.blackshade),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(7)),
                        ),
                        height: 300,
                        width: 300,
                      ),
                      _image == null
                          ? Positioned(
                              bottom: 15,
                              right: 20,
                              child: IconButton(
                                  onPressed: () {
                                    _selectImage(context);
                                  },
                                  icon: const Icon(
                                    Icons.add_a_photo,
                                    color: AppColors.blue,
                                  )),
                            )
                          : Container(
                              margin: const EdgeInsets.all(25),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.blackshade),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(7)),
                              ),
                              height: 290,
                              width: 290,
                              child: Image.file(
                                _image!,
                              ),
                            ),
                      Positioned(
                        bottom: 15,
                        right: 20,
                        child: IconButton(
                            onPressed: () {
                              _selectImage(context);
                            },
                            icon: const Icon(
                              Icons.add_a_photo,
                              color: AppColors.orange,
                            )),
                      )
                    ],
                  ),
                  Form(
                    key: formstate,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AuthTextFromField(
                            controller: AdsNameController,
                            obscureText: false,
                            validator: (Value) {
                              if (Value.toString().length <= 2) {
                                return "يجب أن لا يقل عنوان عن 2 حروف";
                              } else if (RegExp(validationName)
                                  .hasMatch(Value)) {
                                return 'يجب أن لايحتوي عنوان على رقم او رمز';
                              } else {
                                return null;
                              }
                            },
                            prefixIcon: const Icon(Icons.note),
                            suffixIcon: const Text(""),
                            hintText: " عنوان الإعلان",
                            keyboardType: TextInputType.text),
                        AuthTextFromField(
                            suffixIcon: const Text(""),
                            prefixIcon: const Icon(Icons.cut_outlined),
                            hintText: "الخصم على المنتج ",
                            controller: AdscuttoffController,
                            obscureText: false,
                            validator: (Value) {
                              if (Value!.length < 1 || Value!.length > 2) {
                                return "يرجى إدخال قيمة صحيحة";
                              }
                              return null;
                            },
                            keyboardType: TextInputType.number),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                  Blue_Button(
                      onTap: () {
                        if (formstate.currentState!.validate() &&
                            _image != null) {
                          Get.defaultDialog(
                            title: "إضافة ",
                            titleStyle: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            middleText: 'هل انت متأكد من إضافة الاعلان',
                            middleTextStyle: const TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            backgroundColor: Colors.white,
                            radius: 10,
                            textCancel: " لا ",
                            cancelTextColor: Colors.orange,
                            textConfirm: " نعم ",
                            confirmTextColor: Colors.orange,
                            onCancel: () {
                              Get.obs;
                            },
                            onConfirm: () {
                              Get.back();
                              postAdsImage(
                                userProvider.getUser.uid!,
                                userProvider.getUser.name!,
                                userProvider.getUser.photoUrl!,
                              );
                            },
                          );
                        } else if (_image == null) {
                          EasyLoading.showInfo("الرجاء اختيار صورة للاعلان");
                        }
                      },
                      text: "إضافة ")
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Future sendNotification(
    String to,
    String name,
  ) async {
    final response = await Messaging.sendTo(
        title: "تم اضافة اعلان للحرفي", body: name.toString(), fcmToken: to);
  }
}
