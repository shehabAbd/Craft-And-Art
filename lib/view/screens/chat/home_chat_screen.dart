import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logandsign/providers/user_provider.dart';
import 'package:logandsign/model/user_model.dart' as model;
import 'package:logandsign/utils/app_colors.dart';
import 'package:logandsign/view/screens/chat/serach_screen_for_creative.dart';
import 'package:logandsign/view/screens/chat/message_screen.dart';
import 'package:provider/provider.dart';

class HomeChatScreen extends StatefulWidget {
  @override
  State<HomeChatScreen> createState() => _HomeChatScreenState();
}

class _HomeChatScreenState extends State<HomeChatScreen> {
  @override
  Widget build(BuildContext context) {
    final model.UserModel user = Provider.of<UserProvider>(context).getUser;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        // appBar: AppBar(),
        backgroundColor: AppColors.orange,
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.orange,
          heroTag: "bt1",
          child: const Icon(
            Icons.search,
            color: Colors.black,
          ),
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
              if (user.type == 'creative' || user.type == 'user') {
                showSearch(
                    context: context, delegate: SearchScreenForCreative());
                // Get.to(SearchScreen(user));
              } else {
                Get.snackbar(
                  'عذراً',
                  " يجب تسجيل الدخول أولاً",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: AppColors.grayshade,
                  colorText: Colors.black,
                  duration: const Duration(seconds: 1),
                );
              }
            }
          },
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 40),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(30),
            decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(70),
                )),
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: CachedNetworkImage(
                          placeholder: (conteext, url) =>
                              const CircularProgressIndicator(
                            color: AppColors.orange,
                          ),
                          errorWidget: (context, url, error) => const Icon(
                            Icons.person,
                          ),
                          imageUrl: user.photoUrl!,
                          height: 120,
                          width: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        user.name!,
                        style: const TextStyle(
                            fontSize: 20, color: AppColors.blackshade),
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                      const Divider(
                        color: AppColors.orange,
                        // height: 10,
                        thickness: 2,
                      ),
                      StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(user.uid)
                            .collection('messages')
                            .snapshots(),
                        builder: (context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data.docs.length < 1) {
                              return const Center(
                                child: Text("لا يوجد دردشات متاحة "),
                              );
                            }
                            return ListView.separated(
                                separatorBuilder: (context, index) =>
                                    const Divider(
                                      height: 5,
                                      endIndent: 20,
                                      indent: 20,
                                      color: AppColors.blackshade,
                                    ),
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                itemCount: snapshot.data.docs.length,
                                itemBuilder: (context, index) {
                                  var friendId = snapshot.data.docs[index].id;
                                  var lastMsg =
                                      snapshot.data.docs[index]['last_msg'];
                                  return FutureBuilder(
                                    future: FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(friendId)
                                        .get(),
                                    builder:
                                        (context, AsyncSnapshot asyncSnapshot) {
                                      if (asyncSnapshot.hasData) {
                                        var friend = asyncSnapshot.data;
                                        return ListTile(
                                          leading: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            child: CachedNetworkImage(
                                              placeholder: (conteext, url) =>
                                                  const CircularProgressIndicator(
                                                color: AppColors.orange,
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(
                                                Icons.person,
                                              ),
                                              imageUrl: friend['photoUrl'],
                                              height: 40,
                                              width: 40,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          title: Text(friend['name']),
                                          subtitle: Container(
                                            child: Text(
                                              "$lastMsg",
                                              style: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 15, 4, 4)),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    MessagePage(
                                                  photo: user.photoUrl!,
                                                  currentUser: user,
                                                  friendId: friend['uid'],
                                                  friendName: friend['name'],
                                                  friendImage:
                                                      friend['photoUrl'],
                                                  friendToken: friend['token'],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      }
                                      return const LinearProgressIndicator();
                                    },
                                  );
                                });
                          }
                          return const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.orange,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
