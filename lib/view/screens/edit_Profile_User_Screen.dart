import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logandsign/model/user_model.dart';
import 'package:logandsign/utils/app_colors.dart';
import 'package:logandsign/utils/my_string.dart';
import 'package:logandsign/view/screens/main_screen.dart';
import 'package:uuid/uuid.dart';

class EditUserProfileScreen extends StatefulWidget {
  final userId;
  
  const EditUserProfileScreen({
    Key? key,
    required this.userId,
    
  }) : super(key: key);

  @override
  _EditUserProfileScreenState createState() => _EditUserProfileScreenState();
}

class _EditUserProfileScreenState extends State<EditUserProfileScreen> {
  CollectionReference userRef = FirebaseFirestore.instance.collection('users');
  var UserRef = FirebaseFirestore.instance.collection('users').doc().get();

  String? name;
  String? password;
  File? Userphoto;
  String? imagePickedType;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final storageRef = FirebaseStorage.instance.ref();
  var picker = ImagePicker();
  late Reference ref;
  bool _isLoading = false;

  saveProfile() async {
    try {
      formKey.currentState!.save();
      if (formKey.currentState!.validate() && !_isLoading) {
        setState(() {
          _isLoading = true;
        });
        String profilePictureUrl = "";
        if (imageUrl == " ") {
          setState(() {
            imageUrl = widget.userId['photoUrl'].toString();
          });
        } else {
          profilePictureUrl = Image.network(imageUrl).toString();
        }
        UserModel user = UserModel(
            uid: FirebaseAuth.instance.currentUser!.uid,
            name: name.toString(),
            photoUrl: imageUrl,
            email: widget.userId['emai'].toString(),
            type: "creative",
            followers: [],
            following: [],
            password: password.toString(),
            phone: " ");

        
        

        await _firestore
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({
          'name': name,
          'password': password,
          'photoUrl': imageUrl,
          'uid': FirebaseAuth.instance.currentUser!.uid,
        });

        Get.back();
      }
    } catch (e) {
      print(e);
    }
  }

  String imageUrl = "";

  pickedUploadImageGallery() async {
    try {
      final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxHeight: 512,
        maxWidth: 512,
        imageQuality: 75,
      );
      String id = const Uuid().v1();
      Reference ref = FirebaseStorage.instance
          .ref()
          .child("profileUserPhotos")
          .child(FirebaseAuth.instance.currentUser!.uid)
          .child(id);
      await ref.putFile(File(image!.path));
      ref.getDownloadURL().then((value) {
        setState(() {
          imageUrl = value;
        });
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    imageUrl = widget.userId['photoUrl'];
    name = widget.userId['name'];
    password = widget.userId['password'];
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.blue,
          title: const Text(
            " تعديل بيانات الملف الشخصي",
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
        ),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Center(
                    child: Stack(
                      children: [
                        const SizedBox(
                          height: 100,
                        ),
                        ClipRRect(
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  pickedUploadImageGallery();
                                },
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  backgroundImage: imageUrl == ""
                                      ? NetworkImage(widget.userId['photoUrl'])
                                      : NetworkImage(imageUrl),
                                  maxRadius: 80,
                                  minRadius: 80,
                                ),
                              ),
                              Positioned(
                                bottom: -10,
                                left: 80,
                                child: IconButton(
                                  onPressed: () {
                                    pickedUploadImageGallery();
                                  },
                                  icon: const Icon(
                                    Icons.add_a_photo,
                                    color: AppColors.orange,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text(
                    "تغيير صورة الملف الشخصي",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 30),
                        TextFormField(
                          
                          initialValue: name,
                          decoration: const InputDecoration(
                            labelText: ' الإسم  ',
                            labelStyle: TextStyle(color: AppColors.blue),
                          ),
                          validator: (input) => input!.trim().length < 2
                              ? 'الرجاء ادخال الإسم'
                              : null,
                          onSaved: (value) {
                            name = value!;
                          },
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value.toString().length <= 8) {
                              return "يجب أن لا تقل كملة السر عن 8 أحرف";
                            } else if (!RegExp(validationPassword)
                                .hasMatch(value!)) {
                              return 'يجب أن تحتوي على الاقل حرف ورقم';
                            } else {
                              return null;
                            }
                          },
                          initialValue: password,
                          decoration: const InputDecoration(
                            labelText: 'كلمة المرور ',
                            labelStyle: TextStyle(color: AppColors.blue),
                          ),
                          onSaved: (value) {
                            password = value!;
                          },
                        ),
                        const SizedBox(height: 30),
                        _isLoading
                            ? const CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation(AppColors.blue),
                              )
                            : const SizedBox.shrink()
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (imageUrl.isEmpty) {
                              imageUrl = widget.userId['photoUrl'];
                            } else if (imageUrl.isNotEmpty) {
                              saveProfile();
                              
                            }
                          },
                          child: Container(
                            width: 100,
                            height: 35,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: AppColors.blue,
                            ),
                            child: const Center(
                              child: Text(
                                'حفظ',
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.off(const MainScreen());
                          },
                          child: Container(
                            width: 100,
                            height: 35,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: AppColors.blue,
                            ),
                            child: const Center(
                              child: Text(
                                'الغاء',
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
