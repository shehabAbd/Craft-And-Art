import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logandsign/styles/app_extension.dart';
import 'package:logandsign/utils/app_colors.dart';
import 'package:logandsign/model/user_model.dart' as model;
import 'package:logandsign/view/screens/chat/home_chat_screen.dart';
import 'package:logandsign/view/screens/chat/message_screen.dart';
import 'package:logandsign/view/screens/comments_screen.dart';
import 'package:logandsign/view/screens/favorites_screen.dart';
import 'package:logandsign/view/screens/profile_creative_screen.dart';
import 'package:provider/provider.dart';

import '../../../providers/user_provider.dart';

class DetailesScreen extends StatefulWidget {
  final detailes;
  final snap;
  final snaps;
  const DetailesScreen({
    Key? key,
    required this.detailes,
    required this.snap,
    required this.snaps,
  }) : super(key: key);

  @override
  State<DetailesScreen> createState() => _DetailesScreenState();
}

class _DetailesScreenState extends State<DetailesScreen> {
  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      title: const Text(
        "Food Detail Screen",
        style: TextStyle(color: Colors.black),
      ),
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.more_vert),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final model.UserModel user = Provider.of<UserProvider>(context).getUser;

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.grayshade,
        bottomNavigationBar: BottomAppBar(
          elevation: 0,
          color: AppColors.grayshade,
          child: SizedBox(
            height: height * 0.5,
            child: Padding(
              padding: const EdgeInsets.only(right: 10, left: 10),
              child: Container(
                decoration: const BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    )),
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: SingleChildScrollView(
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(width: 15),
                          Text(widget.detailes['name'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20))
                              .fadeAnimation(0.3),
                          const SizedBox(height: 5),
                          Text(widget.detailes['postname'],
                                  style: Theme.of(context).textTheme.subtitle1)
                              .fadeAnimation(0.4),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(widget.detailes['price'],
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      ?.copyWith(color: AppColors.orange)),
                            ],
                          ).fadeAnimation(0.6),
                          const SizedBox(height: 15),
                          const Text("وصف الحرفة :",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold))
                              .fadeAnimation(0.8),
                          const SizedBox(height: 8),
                          Text(
                            widget.detailes['description'],
                            style: Theme.of(context).textTheme.subtitle1,
                          ).fadeAnimation(0.8),
                          const SizedBox(height: 30),
                          SizedBox(
                            width: double.infinity,
                            height: 45,
                            child: Padding(
                              padding:
                                  EdgeInsets.symmetric(horizontal: width * 0.1),
                              child: FirebaseAuth.instance.currentUser!.uid !=
                                      widget.snaps['uid']
                                  ? FlatButton(
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(20),
                                          topLeft: Radius.circular(20),
                                          bottomLeft: Radius.circular(20),
                                          bottomRight: Radius.circular(20),
                                        ),
                                      ),
                                      color: Colors.orange,
                                      onPressed: () {
                                        if (user.blocked == 'yes') {
                                          Get.snackbar(
                                            'عذراً',
                                            "تم حظر  حسابك يرجى التواصل مع الادارة",
                                            snackPosition: SnackPosition.BOTTOM,
                                            backgroundColor:
                                                AppColors.grayshade,
                                            colorText: Colors.black,
                                            duration:
                                                const Duration(seconds: 1),
                                          );
                                        } else {
                                          if (user.type == ("creative") ||
                                              user.type == ("user")) {
                                            Get.to(MessagePage(
                                              friendToken:
                                                  "${widget.snaps['token']}",
                                              photo: user.photoUrl!,
                                              currentUser: user,
                                              friendId:
                                                  "${widget.snaps['uid']}",
                                              friendName:
                                                  "${widget.snaps['name']}",
                                              friendImage:
                                                  widget.detailes['profImage'],
                                            ));
                                          } else {
                                            Get.snackbar(
                                              'عذراً',
                                              " يجب تسجيل الدخول أولاً",
                                              snackPosition:
                                                  SnackPosition.BOTTOM,
                                              backgroundColor:
                                                  AppColors.grayshade,
                                              colorText: Colors.black,
                                              duration:
                                                  const Duration(seconds: 1),
                                            );
                                          }
                                        }
                                      },
                                      child: const Text(
                                        "تواصل مع الحرفي",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  : Container(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        body: Stack(children: [
          Center(
            child: Container(
              width: 350,
              margin: const EdgeInsets.only(
                  top: 20, left: 50, right: 8, bottom: 20),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.orange, width: 3),
                borderRadius: const BorderRadius.all(
                  Radius.circular(
                    28,
                  ),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: CachedNetworkImage(
                  placeholder: (conteext, url) => const Center(
                      child: CircularProgressIndicator(
                    color: AppColors.orange,
                  )),
                  errorWidget: (context, url, error) => const Icon(
                    Icons.person,
                  ),
                  imageUrl: widget.detailes['postUrl'],
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            width: 50,
            height: 290,
            decoration: const BoxDecoration(
                color: AppColors.orange,
                borderRadius: BorderRadius.all(Radius.circular(30))),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5, top: 23),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: InkWell(
                    onTap: () {
                      Get.to(ProfileScreen(
                        uid: widget.snaps['uid'].toString(),
                      ));
                    },
                    child: CachedNetworkImage(
                      placeholder: (conteext, url) =>
                          const CircularProgressIndicator(
                        color: AppColors.orange,
                      ),
                      errorWidget: (context, url, error) => const Icon(
                        Icons.person,
                      ),
                      imageUrl: FirebaseAuth.instance.currentUser!.uid ==
                              widget.snaps['uid'].toString()
                          ? user.photoUrl!
                          : widget.detailes['profImage'].toString(),
                      height: 40,
                      width: 40,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: InkWell(
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
                        if (user.type == ("creative") ||
                            user.type == ("user")) {
                          Get.to(FavoritesScreen(
                              uid: FirebaseAuth.instance.currentUser!.uid));
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
                    child: const Icon(
                      CupertinoIcons.heart,
                      color: Colors.black,
                      size: 25,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 60,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: InkWell(
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
                        if (user.type == ("creative") ||
                            user.type == ("user")) {
                          Get.to(CommentsScreen(
                            postId: widget.snaps['postId'],
                          ));
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
                    child: const Icon(
                      Icons.comment,
                      color: Colors.black,
                      size: 25,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 60,
                ),
                FirebaseAuth.instance.currentUser!.uid != widget.snaps['uid']
                    ? Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: InkWell(
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
                              if (user.type == ("creative") ||
                                  user.type == ("user")) {
                                Get.to(MessagePage(
                                  photo: user.photoUrl!,
                                  currentUser: user,
                                  friendId: "${widget.snaps['uid']}",
                                  friendToken: "${widget.snaps['name']}",
                                  friendName: "${widget.snaps['token']}",
                                  friendImage: widget.snaps['profImage'],
                                ));
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
                          child: const Icon(
                            CupertinoIcons.chat_bubble,
                            color: Colors.black,
                            size: 25,
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: InkWell(
                          onTap: () {
                            Get.to(HomeChatScreen());
                          },
                          child: const Icon(
                            CupertinoIcons.chat_bubble,
                            color: Colors.black,
                            size: 25,
                          ),
                        ),
                      )
              ],
            ),
          )
        ]),
      ),
    );
  }
}
