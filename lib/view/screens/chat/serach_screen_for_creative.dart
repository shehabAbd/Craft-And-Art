import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logandsign/model/user_model.dart';
import 'package:logandsign/providers/user_provider.dart';
import 'package:logandsign/utils/app_colors.dart';
import 'package:logandsign/view/screens/chat/message_screen.dart';
import 'package:provider/provider.dart';

class SearchScreenForCreative extends SearchDelegate {
  SearchScreenForCreative();

  final CollectionReference _FirebaseFireStore =
      FirebaseFirestore.instance.collection('users');

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      Directionality(
        textDirection: TextDirection.rtl,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                query = "";
              },
              icon: const Icon(Icons.close),
            ),
          ],
        ),
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: IconButton(
        onPressed: () {
          Get.back();
        },
        icon: const Icon(Icons.arrow_back),
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final UserModel user = Provider.of<UserProvider>(context).getUser;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: StreamBuilder<QuerySnapshot>(
        stream: _FirebaseFireStore.where("type", isEqualTo: "creative")
            .snapshots()
            .asBroadcastStream(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.orange,),
            );
          } else {
            if (snapshot.data!.docs
                .where((QueryDocumentSnapshot<Object?> element) =>
                    element['name']
                        .toString()
                        .toLowerCase()
                        .contains(query.toLowerCase()))
                .isEmpty) {
              return SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      Image.asset("assets/2.jpg"),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "لا يوجد نتائج لعملية البحث",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          // fontStyle: FontStyle.italic,
                        ),
                      )
                    ],
                  ),
                ),
              );
            } else {
              return ListView(
                children: [
                  ...snapshot.data!.docs
                      .where(
                    (QueryDocumentSnapshot<Object?> element) =>
                        element['name'].toString().toLowerCase().contains(
                              query.toLowerCase(),
                            ),
                  )
                      .map(
                    (QueryDocumentSnapshot<Object?> data) {
                      final String name = data.get("name");
                      final String image = data.get("photoUrl");
                      final String career = data.get("career");
                      final String uid = data.get("uid");
                      final String token = data.get("token");
                      return InkWell(
                        onTap: () {
                          Get.to(
                            MessagePage(
                              friendToken: token,
                              photo: user.photoUrl!,
                              currentUser: user,
                              friendId: uid,
                              friendName: name,
                              friendImage: image,
                            ),
                          );
                        },
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: CachedNetworkImage(
                              placeholder: (conteext, url) =>
                                  const CircularProgressIndicator(color: AppColors.orange,),
                              errorWidget: (context, url, error) => const Icon(
                                Icons.person,
                              ),
                              imageUrl: image,
                              height: 40,
                              width: 40,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(name),
                          subtitle: Text(career),
                          trailing: IconButton(
                            onPressed: () {
                              Get.to(
                                MessagePage(
                                  friendToken:token ,
                                  currentUser: user,
                                  photo: user.photoUrl!,
                                  friendId: uid,
                                  friendName: name,
                                  friendImage: image,
                                ),
                              );
                            },
                            icon: const Icon(Icons.message),
                          ),
                        ),
                      );
                    },
                  )
                ],
              );
            }
          }
        },
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/userSearch.png"),
              const SizedBox(
                height: 13,
              ),
              const Text(
                "ابحث عن الحرفيين",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
