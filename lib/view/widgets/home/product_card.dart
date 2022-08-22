import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:logandsign/view/screens/craft/craft_detailes_screen.dart';
import 'package:logandsign/model/user_model.dart' as model;
import 'package:logandsign/providers/user_provider.dart';
import 'package:logandsign/service/firestore_methods.dart';
import 'package:logandsign/styles/special_icon.dart';
import 'package:logandsign/utils/app_colors.dart';
import 'package:logandsign/utils/image_picker.dart';
import 'package:logandsign/view/screens/edit_Product_Screen.dart';
import 'package:logandsign/view/screens/comments_screen.dart';

import 'package:logandsign/view/screens/profile_creative_screen.dart';
import 'package:logandsign/view/widgets/home/like_animation.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as UI;

class ProductCard extends StatefulWidget {
  final snap;
  final detailes;
  final docId;
  final snaps;
  const ProductCard(
      {Key? key,
      required this.snap,
      required this.detailes,
      required this.docId,
      required this.snaps})
      : super(key: key);

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  UI.TextDirection direction = UI.TextDirection.rtl;
  int commentLen = 0;
  var userData = {};
  var productData = {};
  final user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    super.initState();
    fetchCommentLen();
    fetchProduct();
    getProductData();
    addData();
  }

  addData() async {
    UserProvider _userProvider =
        Provider.of<UserProvider>(context, listen: false);
    await _userProvider.refreshUser();
  }

  fetchCommentLen() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('product')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();
      commentLen = snap.docs.length;
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
    if (mounted) {
      setState(() {});
    }
  }

  Future getProductData() async {
    try {
      var productSnap = await FirebaseFirestore.instance
          .collection('product')
          .doc(widget.snap['postId'])
          .get();

      productData = productSnap.data()!;

      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  Future fetchProduct() async {
    try {
      var snap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.snap['uid'])
          .get();
      userData = snap.data()!;
      setState(() {});
    } catch (err) {
      print(err);
    }
    if (mounted) {
      setState(() {});
    }
  }

  deleteProduct(String postId) async {
    try {
      await FireStoreMethods().deleteProduct(postId);
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final model.UserModel user = Provider.of<UserProvider>(context).getUser;
    return RefreshIndicator(
      onRefresh: fetchProduct,
      child: Directionality(
        textDirection: direction,
        child: InkWell(
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: AppColors.blue.withOpacity(0.25),
                  blurRadius: 20,
                  spreadRadius: 1,
                ),
              ],
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
            ),
            margin: const EdgeInsets.only(left: 15, right: 15, top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 16,
                  ).copyWith(right: 0),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 6, top: 4),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: InkWell(
                            onTap: () {
                              if (widget.snap['uid'] == user.uid) {
                                Get.to(ProfileScreen(
                                  uid: widget.snap['uid'].toString(),
                                ));
                              } else {
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
                                    uid: widget.snap['uid'].toString(),
                                  ));
                                }
                              }
                            },
                            child: CachedNetworkImage(
                              placeholder: (conteext, url) =>
                                  const CircularProgressIndicator(
                                color: AppColors.orange,
                              ),
                              errorWidget: (context, url, error) => const Icon(
                                Icons.person,
                              ),
                              imageUrl:
                                  FirebaseAuth.instance.currentUser!.uid ==
                                          widget.snap['uid'].toString()
                                      ? user.photoUrl!
                                      : widget.snap['profImage'].toString(),
                              height: 40,
                              width: 40,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10.0, top: 5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(FirebaseAuth.instance.currentUser!.uid ==
                                      widget.snap['uid'].toString()
                                  ? user.name!
                                  : userData["name"].toString()),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.access_time,
                                    color: AppColors.blackshade,
                                    size: 18,
                                  ),
                                  const SizedBox(
                                    width: 2,
                                  ),
                                  Container(
                                    child: Text(
                                      DateFormat.yMMMd().format(widget
                                          .snap['datePublished']
                                          .toDate()),
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      FirebaseAuth.instance.currentUser!.uid ==
                              widget.snap['uid']
                          ? IconButton(
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
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Directionality(
                                        textDirection: direction,
                                        child: SimpleDialog(
                                          children: <Widget>[
                                            SimpleDialogOption(
                                              padding: const EdgeInsets.all(20),
                                              child: const Text(
                                                "تعديل تفاصيل الحرفة",
                                              ),
                                              onPressed: () async {
                                                Get.to(
                                                  EditProductScreen(
                                                    detailes: productData,
                                                    postId:
                                                        widget.snap['postId'],
                                                  ),
                                                );
                                              },
                                            ),
                                            SimpleDialogOption(
                                              padding: const EdgeInsets.all(20),
                                              child: const Text("حذف الحرفة"),
                                              onPressed: () async {
                                                Get.defaultDialog(
                                                  title: "حذف الحرفة",
                                                  titleStyle: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  middleText:
                                                      ' هل انت متاكد من عملية الحذف',
                                                  middleTextStyle:
                                                      const TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  backgroundColor: Colors.white,
                                                  radius: 10,
                                                  textCancel: " لا ",
                                                  cancelTextColor:
                                                      Colors.orange,
                                                  textConfirm: " نعم ",
                                                  confirmTextColor:
                                                      Colors.orange,
                                                  onCancel: () {
                                                    Get.obs;
                                                  },
                                                  onConfirm: () {
                                                    deleteProduct(
                                                      widget.snap['postId'],
                                                    );
                                                    Navigator.pop(context);
                                                  },
                                                );
                                              },
                                            ),
                                            SimpleDialogOption(
                                              padding: const EdgeInsets.all(20),
                                              child: const Text("الغاء"),
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
                              },
                              icon: const Icon(
                                Icons.more_vert,
                              ),
                            )
                          : LikeAnimation(
                              isAnimating:
                                  widget.snap['favorites'].contains(user.uid),
                              smallLike: true,
                              child: widget.snap['favorites'].contains(user.uid)
                                  ? SpecialIcon(
                                      iconData: Icons.favorite,
                                      color: Colors.red,
                                      doFunction: () async {
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
                                          FireStoreMethods().favoriteProduct(
                                            widget.snap['postId'].toString(),
                                            user.uid!,
                                            widget.snap['favorites'],
                                          );
                                        }
                                      })
                                  : SpecialIcon(
                                      iconData: Icons.favorite_border_outlined,
                                      color: Colors.black,
                                      doFunction: () async {
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
                                          FireStoreMethods().favoriteProduct(
                                            widget.snap['postId'].toString(),
                                            user.uid!,
                                            widget.snap['favorites'],
                                          );
                                        }
                                      },
                                    ),
                            ),
                    ],
                  ),
                ),
                const SizedBox(
                  child: Divider(
                    color: Colors.black38,
                  ),
                  height: 10,
                ),
                SizedBox(
                  width: double.infinity,
                  child: InkWell(
                    onTap: () {
                      Get.to(DetailesScreen(
                        detailes: widget.detailes,
                        snap: widget.docId,
                        snaps: widget.snap,
                      ));
                    },
                    child: CachedNetworkImage(
                      imageUrl: widget.snap["postUrl"],
                      placeholder: (conteext, url) => const Center(
                          child: CircularProgressIndicator(
                        color: AppColors.orange,
                      )),
                      errorWidget: (context, url, error) => const Icon(
                        Icons.wifi,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(
                  child: Divider(
                    color: Colors.black38,
                  ),
                  height: 10,
                ),
                FirebaseAuth.instance.currentUser!.uid == widget.snaps['uid']
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          LikeAnimation(
                            isAnimating:
                                widget.snap['likes'].contains(user.uid),
                            smallLike: true,
                            child: widget.snap['likes'].contains(user.uid)
                                ? SpecialIcon(
                                    iconData: Icons.thumb_up,
                                    color: AppColors.blue,
                                    doFunction: () async {
                                      if (user.blocked == ('yes')) {
                                        Get.snackbar(
                                          'عذراً',
                                          "تم حظر  حسابك يرجى التواصل مع الادارة",
                                          snackPosition: SnackPosition.BOTTOM,
                                          backgroundColor: AppColors.grayshade,
                                          colorText: Colors.black,
                                          duration: const Duration(seconds: 1),
                                        );
                                      } else {
                                        FireStoreMethods().likesProduct(
                                          widget.snap['postId'].toString(),
                                          user.uid!,
                                          widget.snap['likes'],
                                        );
                                      }
                                    },
                                  )
                                : SpecialIcon(
                                    iconData: Icons.thumb_up_off_alt_outlined,
                                    color: Colors.black,
                                    doFunction: () async {
                                      if (user.blocked == ('yes')) {
                                        Get.snackbar(
                                          'عذراً',
                                          "تم حظر  حسابك يرجى التواصل مع الادارة",
                                          snackPosition: SnackPosition.BOTTOM,
                                          backgroundColor: AppColors.grayshade,
                                          colorText: Colors.black,
                                          duration: const Duration(seconds: 1),
                                        );
                                      } else {
                                        FireStoreMethods().likesProduct(
                                          widget.snap['postId'].toString(),
                                          user.uid!,
                                          widget.snap['likes'],
                                        );
                                      }
                                    },
                                  ),
                          ),
                          SpecialIcon(
                            iconData: Icons.comment,
                            color: AppColors.blue,
                            doFunction: () {
                              if (user.blocked == ('yes')) {
                                Get.snackbar(
                                  'عذراً',
                                  "تم حظر  حسابك يرجى التواصل مع الادارة",
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: AppColors.grayshade,
                                  colorText: Colors.black,
                                  duration: const Duration(seconds: 1),
                                );
                              } else {
                                if (user.type == ('creative') ||
                                    user.type == ('user')) {
                                  Get.to(CommentsScreen(
                                      postId:
                                          widget.snap['postId'].toString()));
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
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          LikeAnimation(
                            isAnimating:
                                widget.snap['likes'].contains(user.uid),
                            smallLike: true,
                            child: widget.snap['likes'].contains(user.uid)
                                ? SpecialIcon(
                                    iconData: Icons.thumb_up,
                                    color: Colors.blue,
                                    doFunction: () async {
                                      if (user.blocked == ('yes')) {
                                        Get.snackbar(
                                          'عذراً',
                                          "تم حظر  حسابك يرجى التواصل مع الادارة",
                                          snackPosition: SnackPosition.BOTTOM,
                                          backgroundColor: AppColors.grayshade,
                                          colorText: Colors.black,
                                          duration: const Duration(seconds: 1),
                                        );
                                      } else {
                                        FireStoreMethods().likesProduct(
                                          widget.snap['postId'].toString(),
                                          user.uid!,
                                          widget.snap['likes'],
                                        );
                                      }
                                    },
                                  )
                                : SpecialIcon(
                                    iconData: Icons.thumb_up_off_alt_outlined,
                                    color: Colors.black,
                                    doFunction: () async {
                                      if (user.blocked == ('yes')) {
                                        Get.snackbar(
                                          'عذراً',
                                          "تم حظر  حسابك يرجى التواصل مع الادارة",
                                          snackPosition: SnackPosition.BOTTOM,
                                          backgroundColor: AppColors.grayshade,
                                          colorText: Colors.black,
                                          duration: const Duration(seconds: 1),
                                        );
                                      } else {
                                        FireStoreMethods().likesProduct(
                                          widget.snap['postId'].toString(),
                                          user.uid!,
                                          widget.snap['likes'],
                                        );
                                      }
                                    },
                                  ),
                          ),
                          SpecialIcon(
                            iconData: Icons.comment,
                            color: AppColors.blue,
                            doFunction: () {
                              if (user.blocked == ('yes')) {
                                Get.snackbar(
                                  'عذراً',
                                  "تم حظر  حسابك يرجى التواصل مع الادارة",
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: AppColors.grayshade,
                                  colorText: Colors.black,
                                  duration: const Duration(seconds: 1),
                                );
                              } else {
                                if (user.type == ('creative') ||
                                    user.type == ('user')) {
                                  Get.to(CommentsScreen(
                                      postId:
                                          widget.snap['postId'].toString()));
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
                        ],
                      ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      DefaultTextStyle(
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2!
                            .copyWith(fontWeight: FontWeight.w800),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${widget.snap['likes'].length} اعجاب',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: Colors.black,
                              ),
                            ),
                            InkWell(
                              child: Container(
                                child: Text(
                                  ' عرض  $commentLen من التعليقات ',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                              ),
                              onTap: () {
                                if (user.blocked == ('yes')) {
                                  Get.snackbar(
                                    'عذراً',
                                    "تم حظر  حسابك يرجى التواصل مع الادارة",
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: AppColors.grayshade,
                                    colorText: Colors.black,
                                    duration: const Duration(seconds: 1),
                                  );
                                } else {
                                  Get.to(
                                    CommentsScreen(
                                      postId: widget.snap['postId'].toString(),
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(
                          top: 2,
                        ),
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(color: Colors.black),
                            children: [
                              TextSpan(
                                text: 'الإسم:  ${widget.snap['postname']}\n',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: 'السعر: ${widget.snap['price']}\n',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.blue,
                                ),
                              ),
                            ],
                          ),
                        ),
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
