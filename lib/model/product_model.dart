import 'package:cloud_firestore/cloud_firestore.dart';

class Carft {
  final String description;
  final String price;

  final String postname;
  final String uid;
  final String name;
  final favorites;
  final String postId;
  final DateTime datePublished;
  final String postUrl;
  final String profImage;
  final likes;

  const Carft({
    required this.price,
    required this.description,
    required this.postname,
    required this.uid,
    required this.name,
    required this.favorites,
    required this.postId,
    required this.datePublished,
    required this.postUrl,
    required this.profImage,
    required this.likes,
  });

  static Carft fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Carft(
        price: snapshot["price"],
        description: snapshot["description"],
        postname: snapshot["postname"],
        uid: snapshot["uid"],
        favorites: snapshot["favorites"],
        likes: snapshot["likes"],
        postId: snapshot["postId"],
        datePublished: snapshot["datePublished"],
        name: snapshot["name"],
        postUrl: snapshot['postUrl'],
        profImage: snapshot['profImage']);
  }

  Map<String, dynamic> toJson() => {
        "description": description,
        "price": price,
        "postname": postname,
        "uid": uid,
        "favorites": favorites,
        "likes": likes,
        "name": name,
        "postId": postId,
        "datePublished": datePublished,
        'postUrl': postUrl,
        'profImage': profImage
      };
}
