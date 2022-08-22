import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logandsign/service/storage_methods.dart';
import 'package:uuid/uuid.dart';
import 'package:logandsign/model/product_model.dart';

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<String> uploadProduct(
    String description,
    File file,
    String uid,
    String name,
    String postname,
    String profImage,
    String price,
  ) async {
    // asking uid here because we dont want to make extra calls to firebase auth when we can just get from our state management
    String res = "Some error occurred";
    try {
      String photoUrl = await StorageMethods()
          .uploadImageToStorage('productPhotos', file, true);

      String postId = const Uuid().v1(); // creates unique id based on time
      Carft post = Carft(
        price: price,
        postname: postname,
        description: description,
        uid: uid,
        name: name,
        favorites: [],
        likes: [],
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
      );
      _firestore.collection('product').doc(postId).set(post.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Add Advirtizment
  Future<String> uploadAdvertisement(
    String uid,
    String title,
    String cuttoff,
    File adsurl,
  ) async {
    // asking uid here because we dont want to make extra calls to firebase auth when we can just get from our state management
    String res = "Some error occurred";
    try {
      String photoUrl = await StorageMethods()
          .uploadImageToStorage('AdsPhotos', adsurl, true);

      String adsId = const Uuid().v1(); // creates unique id based on time

      _firestore.collection('ads').doc(adsId).set({
        "adsId": adsId,
        "cuttoff": cuttoff,
        "statues": "0",
        "title": title,
        "uid": uid,
        "url": photoUrl,
        "date": DateTime.now(),
      });
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> favoriteProduct(
      String postId, String uid, List favorites) async {
    String res = "Some error occurred";
    try {
      if (favorites.contains(uid)) {
        // if the likes list contains the user uid, we need to remove it
        _firestore.collection('product').doc(postId).update({
          'favorites': FieldValue.arrayRemove([uid])
        });
      } else {
        // else we need to add uid to the likes array
        _firestore.collection('product').doc(postId).update({
          'favorites': FieldValue.arrayUnion([uid])
        });
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> likesProduct(String postId, String uid, List likes) async {
    String res = "Some error occurred";
    try {
      if (likes.contains(uid)) {
        // if the likes list contains the user uid, we need to remove it
        _firestore.collection('product').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        // else we need to add uid to the likes array
        _firestore.collection('product').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Post comment
  Future<String> productComment(String postId, String text, String uid,
      String name, String profilePic) async {
    String res = "Some error occurred";
    try {
      if (text.isNotEmpty) {
        // if the favorite list contains the user uid, we need to remove it
        String commentId = const Uuid().v1();
        _firestore
            .collection('product')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
        res = 'success';
      } else {
        res = "الرجاء اظافة تعليق";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Delete Post
  Future<String> deleteProduct(String postId) async {
    String res = "Some error occurred";
    try {
      await _firestore.collection('product').doc(postId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> deletecommend(String postId) async {
    String res = "Some error occurred";
    try {
      await _firestore
          .collection('product')
          .doc(postId)
          .collection('comments')
          .doc()
          .delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if (following.contains(followId)) {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
