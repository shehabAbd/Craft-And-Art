

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logandsign/model/user_model.dart';
import 'package:logandsign/providers/user_provider.dart';
import 'package:logandsign/utils/app_colors.dart';
import 'package:logandsign/view/screens/profile_creative_screen.dart';
import 'package:provider/provider.dart';

class GetCreative extends StatefulWidget {
  const GetCreative({
    Key? key,
  }) : super(key: key);

  @override
  State<GetCreative> createState() => _GetCreativeState();
}

class _GetCreativeState extends State<GetCreative> {
  int followers = 0;

  @override
  Widget build(BuildContext context) {
    final UserModel user = Provider.of<UserProvider>(context).getUser;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.orange,
          title: const Text(
            "الحرفيين",
            style: TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        body: Container(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .orderBy('followers', descending: true)
                .snapshots(),
            builder: (context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, i) {
                  followers = snapshot.data!.docs[i].data()['followers'].length;
                  return Card(
                    color: i % 2 == 0
                        ? const Color.fromARGB(230, 255, 255, 255)
                        : const Color.fromARGB(230, 255, 255, 255),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: ListTile(
                      trailing: Text(
                        followers.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                        ),
                      ),
                      title: Text(
                        snapshot.data!.docs[i].data()['name'].toString(),
                        
                      ),
                      subtitle: Text(
                          snapshot.data!.docs[i].data()['career'].toString()),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: CachedNetworkImage(
                          placeholder: (conteext, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) => const Icon(
                            Icons.person,
                          ),
                          imageUrl: snapshot.data!.docs[i]
                              .data()['photoUrl']
                              .toString(),
                          height: 50,
                          width: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                      onTap: () {
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
                          Get.to(ProfileScreen(
                            uid:
                                snapshot.data!.docs[i].data()['uid'].toString(),
                            
                          ));
                        }
                      },
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider(
                    color: AppColors.orange,
                    thickness: 2,
                    indent: 50,
                    endIndent: 50,
                  );
                },
                itemCount: snapshot.data!.docs.length,
              );
            },
          ),
        ),
      ),
    );
  }
}
