import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logandsign/model/user_model.dart';
import 'package:logandsign/service/storage_methods.dart';

abstract class UserServices {
  static final _auth = FirebaseAuth.instance;
  static final _firestore = FirebaseFirestore.instance;

  /// return true if phone number already exists
  static Future<bool> phoneNumberExists(String phoneNumber,
      {Function(Object)? onError}) async {
    var isValidUser = false;

    await _firestore
        .collection('users')
        .where('phone', isEqualTo: phoneNumber)
        .get()
        .then((result) {
      if (result.docs.isNotEmpty) {
        isValidUser = true;
      }
    }).catchError(
      onError ??
          (_) {
            log("checking phone number : failed");
          },
    );

    return isValidUser;
  }

  static void signUpCreative({
    required String name,
    required String phone,
    required String gender,
    required String facebook,
    required String instagram,
    required String career,
    required String address,
    required String blocked,
    required String token,
    required File file,
    Function()? onSuccess,
    Function(Object)? onError,
  }) async {
    String photoUrl = await StorageMethods()
        .uploadImageToStorage('profileUserPhotos', file, true);

    UserModel _user = UserModel(
        type: "creative",
        name: name,
        phone: phone,
        followers: [],
        following: [],
        uid: _auth.currentUser!.uid,
        photoUrl: photoUrl,
        facebook: facebook,
        gender: gender,
        instagram: instagram,
        address: address,
        career: career,
        blocked: "no",
        token: token);

    await _firestore.collection('users').doc(_auth.currentUser!.uid).set({
      "type": "creative",
      "name": name,
      "phone": phone,
      "followers": [],
      "following": [],
      "uid": _auth.currentUser!.uid,
      "photoUrl": photoUrl,
      "facebook": facebook,
      "gender": gender,
      "instagram": instagram,
      "address": address,
      "career": career,
      "blocked": "no",
      "token": token.toString()
    }, SetOptions(merge: true)).then((value) {
      if (onSuccess != null) onSuccess();
    }).catchError(
      onError ??
          (_) {
            log("add user : failed");
          },
    );
  }

  static Future<UserModel?> getUserLogin() async {
    UserModel? registrant;
    if (_auth.currentUser != null) {
      var phoneNumber = _auth.currentUser!.phoneNumber!;
      await _firestore
          .collection('users')
          .where('phone', isEqualTo: phoneNumber)
          .get()
          .then((result) {
        if (result.docs.isNotEmpty) {
          registrant = UserModel(
              type: result.docs[0].data()['type'],
              name: result.docs[0].data()['name'],
              phone: phoneNumber,
              followers: result.docs[0].data()['followers'],
              following: result.docs[0].data()['following'],
              uid: result.docs[0].data()['uid'],
              photoUrl: result.docs[0].data()['photoUrl'],
              facebook: result.docs[0].data()['facebook'],
              gender: result.docs[0].data()['gender'],
              instagram: result.docs[0].data()['instagram'],
              address: result.docs[0].data()['address'],
              career: result.docs[0].data()['career'],
              blocked: result.docs[0].data()['blocked'],
              token: result.docs[0].data()['token']);
        }
      }).catchError((_) {});
    }
    return registrant;
  }
}

