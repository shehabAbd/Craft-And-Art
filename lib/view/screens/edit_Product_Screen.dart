import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logandsign/providers/user_provider.dart';
import 'package:logandsign/utils/app_colors.dart';
import 'package:logandsign/view/screens/main_screen.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class EditProductScreen extends StatefulWidget {
  final detailes;
  final postId;
  const EditProductScreen({
    Key? key,
    required this.detailes,
    required this.postId,
  }) : super(key: key);

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  CollectionReference userRef =
      FirebaseFirestore.instance.collection('product');
  var UserRef = FirebaseFirestore.instance.collection('product').doc().get();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? postname;
  String? description;
  String? price;
  String? postUrl;

  File? Userphoto;
  String? imagePickedType;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final storageRef = FirebaseStorage.instance.ref();
  var picker = ImagePicker();
  late Reference ref;
  bool _isLoading = false;

  saveProduct(
    String uid,
    String firstnam,
    String profImage,
  ) async {
    try {
      formKey.currentState!.save();
      if (formKey.currentState!.validate() && !_isLoading) {
        setState(() {
          _isLoading = true;
        });
        String profilePictureUrl = "";
        if (imageUrl == " ") {
          setState(() {
            imageUrl = widget.detailes['photoUrl'].toString();
          });
        } else {
          profilePictureUrl = Image.network(imageUrl).toString();
        }
        await _firestore
            .collection("product")
            .doc(widget.detailes['postId'])
            .update({
          'postname': postname,
          'description': description,
          'price': price,
          'postUrl': imageUrl,
          "datePublished": DateTime.now(),
          'uid': FirebaseAuth.instance.currentUser!.uid,
        });

        
        Get.off(const MainScreen());
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
        imageQuality: 15,
      );
      String id = const Uuid().v1();
      Reference ref = FirebaseStorage.instance
          .ref()
          .child("productPhotos")
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
    postUrl = widget.detailes['postUrl'];
    postname = widget.detailes['postname'];
    description = widget.detailes['description'];
    price = widget.detailes['price'];
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
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
                      Positioned(
                        bottom: 15,
                        right: 20,
                        child: IconButton(
                            onPressed: () {
                              pickedUploadImageGallery();
                            },
                            icon: const Icon(
                              Icons.add_a_photo,
                              color: AppColors.orange,
                            )),
                      ),
                      Container(
                        margin: const EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.blackshade),
                          borderRadius: const BorderRadius.all(Radius.circular(7)),
                          
                        ),
                        
                        height: 290,
                        width: 290,
                        child: imageUrl == ""
                            ? Image.network(
                                widget.detailes['postUrl'].toString())
                            : Image.network(imageUrl),
                      ),

                      Positioned(
                        bottom: 15,
                        right: 20,
                        child: IconButton(
                            onPressed: () {
                              pickedUploadImageGallery();
                            },
                            icon: const Icon(
                              Icons.add_a_photo,
                              color: AppColors.orange,
                            )),
                      )
                      
                      
                      
                      
                      
                      
                      
                      
                      
                      
                      
                      
                      
                      
                      
                      
                      
                      
                      
                      
                      
                      
                      
                      
                      
                      
                      
                      
                      
                      
                      
                      
                      
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  
                  
                  
                  
                  
                  
                  
                  
                  
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 30),
                        TextFormField(
                          
                          initialValue: postname,
                          decoration: const InputDecoration(
                            labelText: ' إسم المنتج ',
                            labelStyle: TextStyle(color: AppColors.blue),
                          ),
                          validator: (input) => input!.trim().length < 2
                              ? 'الرجاء ادخال إسم المنتج '
                              : null,
                          onSaved: (value) {
                            postname = value!;
                          },
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value.toString().length <= 1) {
                              return "الوصف  لايمكن ان يكون اصغر من حرف";
                            }
                            return null;
                          },
                          initialValue: description,
                          decoration: const InputDecoration(
                            labelText: 'وصف المنتج',
                            labelStyle: TextStyle(color: AppColors.blue),
                          ),
                          onSaved: (value) {
                            description = value!;
                          },
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value.toString().isEmpty) {
                              return 'الرجاء ادخال السعر  ';
                            } else {
                              return null;
                            }
                          },
                          initialValue: price,
                          decoration: const InputDecoration(
                            labelText: 'سعر المنتج',
                            labelStyle: TextStyle(color: AppColors.blue),
                          ),
                          onSaved: (value) {
                            price = value!;
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
                              imageUrl = widget.detailes['postUrl'];
                            } else if (imageUrl.isNotEmpty) {
                              saveProduct(
                                  userProvider.getUser.uid!,
                                  userProvider.getUser.name!,
                                  userProvider.getUser.photoUrl!);
                              
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
