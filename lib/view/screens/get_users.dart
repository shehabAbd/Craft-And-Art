

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logandsign/utils/app_colors.dart';
import 'package:logandsign/view/screens/profile_user_screen.dart';

class GetUsers extends StatefulWidget {
  const GetUsers({
    Key? key,
  }) : super(key: key);

  @override
  State<GetUsers> createState() => _GetUsersState();
}

class _GetUsersState extends State<GetUsers> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.blue,
            title: const Text("المستخدمين"),
          ),
          body: Container(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .where("type", isEqualTo: "user")
                    .snapshots(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, i) {
                      return Card(
                        color: i % 2 == 0 ? AppColors.white : AppColors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: ListTile(
                          title: Text(
                            snapshot.data!.docs[i].data()['name'],
                            
                          ),
                          subtitle:
                              Text(snapshot.data!.docs[i].data()['phone']),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: CachedNetworkImage(
                              placeholder: (conteext, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) => const Icon(
                                Icons.person,
                              ),
                              imageUrl:
                                  snapshot.data!.docs[i].data()['photoUrl'],
                              height: 60,
                              width: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                          onTap: () {
                            Get.to(ProfileScreenUser(
                              uid: snapshot.data!.docs[i].data()['uid'],
                              
                            ));
                          },
                          onLongPress: () {},
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const Divider(
                        color: AppColors.blue,
                        thickness: 2,
                        indent: 50,
                        endIndent: 50,
                      );
                    },
                    itemCount: snapshot.data!.docs.length,
                  );
                }),
          )),
    );
  }
}
