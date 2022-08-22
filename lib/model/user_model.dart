import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? email;
  String? uid;
  String? photoUrl;
  String? name;
  String? gender;
  String? type;
  String? phone;
  String? password;
  List? followers;
  List? following;
  String? facebook;
  String? instagram;
  String? career;
  String? address;
  String? blocked;
  String? token;

  UserModel({
    this.name,
    this.uid,
    this.phone,
    this.password,
    this.photoUrl,
    this.email,
    this.gender,
    this.type,
    this.followers,
    this.following,
    this.facebook,
    this.instagram,
    this.address,
    this.career,
    this.blocked,
    this.token
    
  });

  static UserModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return UserModel(
      name: snapshot["name"],
      uid: snapshot["uid"],
      email: snapshot["email"],
      password: snapshot["password"],
      photoUrl: snapshot["photoUrl"],
      phone: snapshot["phone"],
      gender: snapshot["gender"],
      type: snapshot["type"].toString(),
      followers: snapshot["followers"],
      following: snapshot["following"],
      facebook: snapshot["facebook"],
      instagram: snapshot["instagram"],
      career: snapshot["career"],
      address: snapshot["address"],
      blocked: snapshot["blocked"],
      token: snapshot["token"],
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "uid": uid,
        "email": email,
        "password": password,
        "photoUrl": photoUrl,
        "gender": gender,
        "type": type,
        "phone": phone,
        "followers": followers,
        "following": following,
        "facebook": facebook,
        "instagram": instagram,
        "career": career,
        "address": address,
        "blocked":blocked,
        "token":token.toString(),
      };
}
