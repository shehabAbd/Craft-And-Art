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
import 'package:logandsign/styles/custom_button_orange.dart';
import 'package:logandsign/utils/app_colors.dart';
import 'package:logandsign/utils/my_string.dart';
import 'package:logandsign/view/screens/main_screen.dart';
import 'package:logandsign/view/widgets/auth/custom_form_field.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AddCraftScreen extends StatefulWidget {
  const AddCraftScreen({Key? key}) : super(key: key);

  @override
  State<AddCraftScreen> createState() => _AddCraftScreenState();
}

class _AddCraftScreenState extends State<AddCraftScreen> {
  final TextEditingController prodctNameController = TextEditingController();

  final TextEditingController productDescriptionController =
      TextEditingController();

  final TextEditingController productPriceController = TextEditingController();

  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  File? _image;
  bool isLoading = false;

  void MoveToWhatsapp() async {
    // ignore: deprecated_member_use
    await launch('https://wa.me/+967772132475?text=أريد إضافة إعلان');
  }

  void postImage(String uid, String name, String profImage) async {
    // start the loading
    try {
      EasyLoading.show(status: "جاري الاضافة");
      // upload to storage and db
      String res = await FireStoreMethods().uploadProduct(
        productDescriptionController.text,
        _image!,
        uid,
        name,
        prodctNameController.text,
        profImage,
        productPriceController.text,
      );

      if (res == "success") {
       
        clearImage();
        EasyLoading.showSuccess("تمت  الاضافة بنجاح ",
            duration: const Duration(seconds: 1));
        await sendNotification("on", name);

        Get.to(const MainScreen());
      } else {
        String message = ' لا يوجود اتصال بالانترنت ';
        EasyLoading.showInfo(message);
      }
    } catch (e) {
      String message = 'لا يوجود اتصال بالانترنت ';
      EasyLoading.showInfo(message.toString());
    }
  }

  void clearImage() {
    setState(() {
      _image = null;
      prodctNameController.clear();
      productDescriptionController.clear();
      productPriceController.clear();
    });
  }

 
  _selectImage(BuildContext parentContext) async {
    return 
    showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: SimpleDialog(
            title: const Text('إختيار حرفة'),
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
                          borderRadius: const BorderRadius.all(Radius.circular(7)),
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
                                    color: AppColors.orange,
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
                            controller: prodctNameController,
                            obscureText: false,
                            validator: (Value) {
                              if (Value.toString().length <= 3) {
                                return "يجب أن لا يقل الإسم عن 3 حروف";
                              } else if (RegExp(validationName)
                                  .hasMatch(Value)) {
                                return 'يجب أن لايحتوي الإسم على رقم او رمز';
                              } else {
                                return null;
                              }
                            },
                            prefixIcon: const Icon(Icons.note),
                            suffixIcon: const Text(""),
                            hintText: " إسم المنتج",
                            keyboardType: TextInputType.text),
                        TextFormField(
                            maxLines: 6,
                            minLines: 1,
                            controller: productDescriptionController,
                            obscureText: false,
                            validator: (Value) {
                              if (Value!.length <= 1) {
                                return "الوصف  لايمكن ان يكون اصغر من حرف";
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.description),
                              hintText: "وصف المنتج ",
                            ),
                            keyboardType: TextInputType.text),
                        AuthTextFromField(
                            controller: productPriceController,
                            obscureText: false,
                            validator: (Value) {
                              if (Value.length == 0) {
                                return 'الرجاء ادخال السعر  ';
                              } else {
                                return null;
                              }
                            },
                            prefixIcon: const Icon(Icons.price_change),
                            suffixIcon: const Text(""),
                            hintText: "السعر ",
                            keyboardType: TextInputType.number),
                        const SizedBox(
                          height: 10,
                        ),
                        orange_Button(
                            onTap: () {
                              if (formstate.currentState!.validate() &&
                                  _image != null) {
                                {
                                  postImage(
                                    userProvider.getUser.uid!,
                                    userProvider.getUser.name!,
                                    userProvider.getUser.photoUrl!,
                                  );
                                  // Get.to(MainScreen());
                                }
                              } else if (_image == null) {
                                EasyLoading.showInfo(
                                    "الرجاء اختيار صورة للحرفة");
                              }
                            },
                            text: "حفظ")
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
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
        title: "تم اضافة منتج بواسطة", body: name.toString(), fcmToken: to);
  }
}
