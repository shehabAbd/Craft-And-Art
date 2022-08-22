import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logandsign/api/messaging.dart';
import 'package:logandsign/model/user_model.dart';
import 'package:logandsign/providers/user_provider.dart';
import 'package:logandsign/service/storage_methods.dart';
import 'package:logandsign/utils/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class MessageTextField extends StatefulWidget {
  final String currentId;
  final String friendId;
  final String friendToken;

  const MessageTextField(this.currentId, this.friendId, this.friendToken);

  @override
  State<MessageTextField> createState() => _MessageTextFieldState();
}

class _MessageTextFieldState extends State<MessageTextField> {
  final TextEditingController _controller = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _Storage = FirebaseStorage.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  File? imageFile;
  
  

  
  
  
  
  
  
  
  

  
  

  
  
  
  
  
  
  
  
  selectImage(BuildContext parentContext) async {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: SimpleDialog(
            title: const Text(
              "  الرجاء اختيار صورة",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            children: <Widget>[
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text(
                  " التقط من الكاميرا",
                  style: TextStyle(fontSize: 15),
                ),
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
                        imageFile = File(croppedFile.path);
                      });
                      uploadImage();
                    }
                  }
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text(
                  'اختر من المعرض',
                  style: TextStyle(fontSize: 15),
                ),
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
                        imageFile = File(croppedFile.path);
                      });
                      uploadImage();
                    }
                  }
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text(
                  "الغاء",
                  style: TextStyle(fontSize: 15),
                ),
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

  
  
  
  
  

  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  

  Future uploadImage() async {
    String fileName = const Uuid().v1();
    String photoUrl = await StorageMethods()
        .uploadImageToStorage('chatImage', imageFile!, false);

    await _firestore
        .collection('users')
        .doc(widget.currentId)
        .collection('messages')
        .doc(widget.friendId)
        .collection('chats')
        .doc(fileName)
        .set({
      "senderId": widget.currentId,
      "receiverId": widget.friendId,
      "message": photoUrl,
      "type": "img",
      "date": DateTime.now(),
    }).then((value) {
      _firestore
          .collection('users')
          .doc(widget.currentId)
          .collection('messages')
          .doc(widget.friendId)
          .set({'last_msg': "صورة"});
    });
    await _firestore
        .collection('users')
        .doc(widget.friendId)
        .collection('messages')
        .doc(widget.currentId)
        .collection('chats')
        .doc(fileName)
        .set({
      "senderId": widget.friendId,
      "receiverId": widget.currentId,
      "message": photoUrl,
      "type": "img",
      "date": DateTime.now(),
    }).then((value) {
      _firestore
          .collection('users')
          .doc(widget.friendId)
          .collection('messages')
          .doc(widget.currentId)
          .set({'last_msg': "صورة"});
    });
    
  }

  @override
  Widget build(BuildContext context) {
    final UserModel user = Provider.of<UserProvider>(context).getUser;

    return Container(
      child: Row(
        children: [
          Expanded(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: TextField(
                cursorColor: AppColors.orange,
                controller: _controller,
                decoration: InputDecoration(
                  prefixIcon: IconButton(
                    onPressed: () {
                      if (user.blocked == 'yes') {
                        Get.snackbar(
                          'عذراً',
                          "تم حظر  حسابك يرجى التواصل مع الادارة",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: AppColors.grayshade,
                          colorText: Colors.black,
                          duration: const Duration(seconds: 1),
                        );
                      } else {
                        selectImage(context);
                      }
                    },
                    icon: const Icon(
                      Icons.photo,
                    ),
                  ),
                  labelText: "اكتب رسالتك",
                  fillColor: AppColors.white,
                  filled: true,
                  border: OutlineInputBorder(
                      borderSide: const BorderSide(width: 0),
                      gapPadding: 10,
                      borderRadius: BorderRadius.circular(25)),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          GestureDetector(
            onTap: () async {
              if (user.blocked == 'yes') {
                Get.snackbar(
                  'عذراً',
                  "تم حظر  حسابك يرجى التواصل مع الادارة",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: AppColors.grayshade,
                  colorText: Colors.black,
                  duration: const Duration(seconds: 1),
                );
              } else {
                String textMessage = _controller.text;

                if (_controller.text.isNotEmpty) {
                  Map<String, dynamic> messages = {
                    "senderId": widget.currentId,
                    "receiverId": widget.friendId,
                    "message": textMessage,
                    "type": "text",
                    "date": DateTime.now(),
                  };
                  String fileName = const Uuid().v1();
                  _controller.clear();
                  await Messaging.sendToChat(
                      title: user.name.toString(),
                      body: textMessage.toString(),
                      fcmToken: widget.friendToken);
                  _controller.clear();
                  await _firestore
                      .collection('users')
                      .doc(widget.currentId)
                      .collection('messages')
                      .doc(widget.friendId)
                      .collection('chats')
                      .doc(fileName)
                      .set(messages)
                      .then((value) {
                    _firestore
                        .collection('users')
                        .doc(widget.currentId)
                        .collection('messages')
                        .doc(widget.friendId)
                        .set({'last_msg': textMessage});
                  });

                  await _firestore
                      .collection('users')
                      .doc(widget.friendId)
                      .collection('messages')
                      .doc(widget.currentId)
                      .collection('chats')
                      .doc(fileName)
                      .set(messages)
                      .then((value) {
                    _firestore
                        .collection('users')
                        .doc(widget.friendId)
                        .collection('messages')
                        .doc(widget.currentId)
                        .set({'last_msg': textMessage});
                    _controller.clear();
                  });
                } else {}
              }
            },
            child: Container(
              padding: const EdgeInsets.all(13),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.blue,
              ),
              child: const Icon(
                Icons.send,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
