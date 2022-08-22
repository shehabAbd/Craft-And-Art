import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logandsign/model/user_model.dart';
import 'package:logandsign/utils/app_colors.dart';
import 'package:logandsign/view/screens/main_screen.dart';
import 'package:uuid/uuid.dart';

class EditProfile extends StatefulWidget {
  final userId;
  
  const EditProfile({
    Key? key,
    required this.userId,
    
  }) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  CollectionReference userRef = FirebaseFirestore.instance.collection('users');
  var UserRef = FirebaseFirestore.instance.collection('users').doc().get();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? name;
  String? instagram;
  String? facebook;
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
          instagram: instagram,
          facebook: facebook,
        );

        
        

        await _firestore
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({
          'name': name,
          'facebook': facebook,
          'instagram': instagram,
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
          .child("profileCreativePhotos")
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
    instagram = widget.userId['instagram'];
    facebook = widget.userId['facebook'];
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          title: const Text(
            " تعديل بيانات الملف الشخصي",
            style: TextStyle(color: Colors.black, fontSize: 15),
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
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 30),
                        TextFormField(
                          
                          initialValue: name,
                          decoration: const InputDecoration(
                            labelText: ' الإسم واللقب ',
                            labelStyle: TextStyle(color: AppColors.blue),
                          ),
                          validator: (input) => input!.trim().length < 2
                              ? 'الرجاء ادخال الإسم'
                              : null,
                          onSaved: (value) {
                            name = value!;
                          },
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value.toString().length == null) {
                              return null;
                            }
                            return null;
                          },
                          initialValue: facebook,
                          decoration: const InputDecoration(
                            labelText: 'رابط فيسبوك ',
                            labelStyle: TextStyle(color: AppColors.blue),
                          ),
                          onSaved: (value) {
                            facebook = value!;
                          },
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value.toString().length == null) {
                              return null;
                            }
                            return null;
                          },
                          initialValue: instagram,
                          decoration: const InputDecoration(
                            labelText: 'رابط انستقرام ',
                            labelStyle: TextStyle(color: AppColors.blue),
                          ),
                          onSaved: (value) {
                            instagram = value!;
                          },
                        ),
                        const SizedBox(height: 30),
                        _isLoading
                            ? const CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation(AppColors.orange),
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
                              color: AppColors.orange,
                            ),
                            child: const Center(
                              child: Text(
                                'حفظ',
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.black,
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
                              color: AppColors.orange,
                            ),
                            child: const Center(
                              child: Text(
                                'الغاء',
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.black,
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
