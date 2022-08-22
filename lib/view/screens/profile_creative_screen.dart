import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:logandsign/logic/controllers/auth_controller.dart';
import 'package:logandsign/providers/user_provider.dart';
import 'package:logandsign/routes/routes.dart';
import 'package:logandsign/service/firestore_methods.dart';
import 'package:logandsign/styles/follow_button.dart';
import 'package:logandsign/utils/app_colors.dart';
import 'package:logandsign/utils/image_picker.dart';
import 'package:logandsign/view/screens/craft/add_advertisement_screen%20.dart';
import 'package:logandsign/view/screens/edit_Profile_Creative_Screen.dart';
import 'package:logandsign/view/screens/following_Creative_Screen%20.dart';
import 'package:logandsign/view/screens/followers_Creative_Screen.dart';
import 'package:logandsign/view/widgets/home/product_card.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;

  const ProfileScreen({
    Key? key,
    required this.uid,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Timer? _timer;
  @override
  void initState() {
    EasyLoading.addStatusCallback((status) {
      print('EasyLoading Status $status');
      if (status == EasyLoadingStatus.dismiss) {
        _timer?.cancel();
      }
    });
    configLoading();
    getData();
    addData();
    super.initState();
  }

  void configLoading() {
    EasyLoading.instance
      ..displayDuration = const Duration(
        milliseconds: 3500,
      )
      ..indicatorType = EasyLoadingIndicatorType.fadingCircle
      ..loadingStyle = EasyLoadingStyle.custom
      ..indicatorSize = 45.0
      ..radius = 15.0
      ..lineWidth = 2
      ..progressColor = AppColors.blue
      ..backgroundColor = AppColors.orange
      ..indicatorColor = AppColors.blue
      ..textColor = Colors.black;
  }

  var userData = {};
  var productData = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;

  addData() async {
    UserProvider _userProvider =
        Provider.of<UserProvider>(context, listen: false);
    await _userProvider.refreshUser();
  }

  Future getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      var postSnap = await FirebaseFirestore.instance
          .collection('product')
          .where('uid', isEqualTo: widget.uid)
          .get();
      postLen = postSnap.docs.length;
      userData = userSnap.data()!;
      followers = userSnap.data()!['followers'].length;
      following = userSnap.data()!['following'].length;
      isFollowing = userSnap
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
      setState(() {});
    } catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  void MoveToFacebook() async {
    try {
      if (userData['facebook'].toString() == "") {
        EasyLoading.showInfo("لايوجد حساب فيس بوك للحرفي",
            maskType: EasyLoadingMaskType.black,
            duration: const Duration(seconds: 1));
      } else {
        await launch(userData['facebook'].toString());
      }
    } catch (e) {
      Get.snackbar("فيس بوك", "لايوجد حساب فيس بوك للحرفي",
          backgroundColor: Colors.white, snackPosition: SnackPosition.BOTTOM);
    }
  }

  void MoveToInstagram() async {
    try {
      if (userData['instagram'].toString() == "") {
        EasyLoading.showInfo("لايوجد حساب انستقرام للحرفي",
            maskType: EasyLoadingMaskType.black,
            duration: const Duration(seconds: 1));
      } else {
        await launch(userData['instagram'].toString());
      }
    } catch (e) {
      Get.snackbar("انستقرام", "لايوجد حساب انستقرام للحرفي",
          backgroundColor: Colors.white, snackPosition: SnackPosition.BOTTOM);
    }
  }

  void MoveToPhon() async {
    await launch("tel://${userData['phone'].toString()}");
  }

  final controller = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(
              color: AppColors.orange,
            ),
          )
        : RefreshIndicator(
            onRefresh: getData,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
                backgroundColor: Colors.white,
                floatingActionButton: FirebaseAuth.instance.currentUser!.uid ==
                        widget.uid
                    ? Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: FabCircularMenu(
                            alignment: Alignment.bottomRight,
                            ringColor: Colors.black.withOpacity(0.2),
                            ringDiameter: 250.0,
                            ringWidth: 100.0,
                            fabSize: 64.0,
                            fabElevation: 8.0,
                            fabIconBorder: const CircleBorder(),
                            fabColor: Colors.orange,
                            fabOpenIcon:
                                const Icon(Icons.menu, color: Colors.white),
                            fabCloseIcon:
                                const Icon(Icons.close, color: Colors.white),
                            fabMargin: const EdgeInsets.all(16.0),
                            animationDuration:
                                const Duration(milliseconds: 800),
                            animationCurve: Curves.easeInOutCirc,
                            onDisplayChange: (isOpen) {
                              print(isOpen);
                            },
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  if (userData["blocked"] == 'yes') {
                                    Get.snackbar(
                                      'عذراً',
                                      "تم حظر  حسابك يرجى التواصل مع الادارة",
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor: AppColors.grayshade,
                                      colorText: Colors.black,
                                      duration: const Duration(seconds: 1),
                                    );
                                  } else {
                                    Get.toNamed(AppRoutes.addCraft);
                                  }
                                },
                                child: const Text(
                                  "حرفة",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              InkWell(
                                child: const Text(
                                  "إعلان",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                onTap: () {
                                  if (userData["blocked"] == 'yes') {
                                    Get.snackbar(
                                      'عذراً',
                                      "تم حظر  حسابك يرجى التواصل مع الادارة",
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor: AppColors.grayshade,
                                      colorText: Colors.black,
                                      duration: const Duration(seconds: 1),
                                    );
                                  } else {
                                    Get.to(AddAdvertisementScreen());
                                  }
                                },
                              )
                            ]),
                      )
                    : null,
                body: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const SizedBox(height: 5.0),
                          InkWell(
                            onTap: () {
                              Get.to(ShowImages(
                                  imageUrl: userData['photoUrl'].toString()));
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(60),
                              child: CachedNetworkImage(
                                placeholder: (conteext, url) =>
                                    const CircularProgressIndicator(
                                  color: AppColors.orange,
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(
                                  Icons.person,
                                ),
                                imageUrl: userData['photoUrl'].toString(),
                                height: 120,
                                width: 120,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            userData['name'].toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 30.0,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                  iconSize: 35,
                                  onPressed: () {
                                    if (userData["blocked"] == 'yes') {
                                      Get.snackbar(
                                        'عذراً',
                                        "تم حظر  حسابك يرجى التواصل مع الادارة",
                                        snackPosition: SnackPosition.BOTTOM,
                                        backgroundColor: AppColors.grayshade,
                                        colorText: Colors.black,
                                        duration: Duration(seconds: 1),
                                      );
                                    } else {
                                      MoveToPhon();
                                    }
                                  },
                                  icon: const Icon(
                                    FontAwesomeIcons.phone,
                                    size: 27,
                                    color: AppColors.lightgreen,
                                  )),
                              const SizedBox(
                                width: 10,
                              ),
                              IconButton(
                                  iconSize: 35,
                                  onPressed: () {
                                    if (userData["blocked"] == 'yes') {
                                      Get.snackbar(
                                        'عذراً',
                                        "تم حظر  حسابك يرجى التواصل مع الادارة",
                                        snackPosition: SnackPosition.BOTTOM,
                                        backgroundColor: AppColors.grayshade,
                                        colorText: Colors.black,
                                        duration: Duration(seconds: 1),
                                      );
                                    } else {
                                      MoveToInstagram();
                                    }
                                  },
                                  icon: const Icon(
                                    FontAwesomeIcons.instagram,
                                    color: Colors.pink,
                                  )),
                              const SizedBox(
                                width: 10,
                              ),
                              IconButton(
                                  iconSize: 35,
                                  onPressed: () {
                                    if (userData["blocked"] == 'yes') {
                                      Get.snackbar(
                                        'عذراً',
                                        "تم حظر  حسابك يرجى التواصل مع الادارة",
                                        snackPosition: SnackPosition.BOTTOM,
                                        backgroundColor: AppColors.grayshade,
                                        colorText: Colors.black,
                                        duration: const Duration(seconds: 1),
                                      );
                                    } else {
                                      MoveToFacebook();
                                    }
                                  },
                                  icon: Icon(
                                    FontAwesomeIcons.facebook,
                                    color: Colors.blue[900],
                                  )),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const SizedBox(width: 20.0),
                              InkWell(
                                onTap: () {
                                  if (userData["blocked"] == 'yes') {
                                    Get.snackbar(
                                      'عذراً',
                                      "تم حظر  حسابك يرجى التواصل مع الادارة",
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor: AppColors.grayshade,
                                      colorText: Colors.black,
                                      duration: const Duration(seconds: 1),
                                    );
                                  } else {
                                    following > 0
                                        ? Get.to(FollowingScreen(
                                            uid: widget.uid,
                                          ))
                                        : null;
                                  }
                                },
                                child: Column(
                                  children: [
                                    Text(
                                      following.toString(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0,
                                      ),
                                    ),
                                    const SizedBox(height: 15.0),
                                    Text(
                                      "يتابع",
                                      style: TextStyle(
                                          color: Colors.black.withOpacity(0.3),
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.w100),
                                    ),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  if (userData["blocked"] == 'yes') {
                                    Get.snackbar(
                                      'عذراً',
                                      "تم حظر  حسابك يرجى التواصل مع الادارة",
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor: AppColors.grayshade,
                                      colorText: Colors.black,
                                      duration: const Duration(seconds: 1),
                                    );
                                  } else {
                                    followers > 0
                                        ? Get.to(
                                            FollowersScreen(
                                              uid: widget.uid,
                                            ),
                                          )
                                        : null;
                                  }
                                },
                                child: Column(
                                  children: [
                                    Text(
                                      followers.toString(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0,
                                      ),
                                    ),
                                    const SizedBox(height: 15.0),
                                    Text(
                                      "متابعين",
                                      style: TextStyle(
                                          color: Colors.black.withOpacity(0.3),
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.w300),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  Text(
                                    postLen.toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                    ),
                                  ),
                                  const SizedBox(height: 15.0),
                                  Text(
                                    "المنشورات",
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(0.3),
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 20.0),
                            ],
                          ),
                          const SizedBox(height: 10.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              FirebaseAuth.instance.currentUser!.uid ==
                                      widget.uid
                                  ? Padding(
                                      padding: const EdgeInsets.only(left: 0),
                                      child: FollowButton(
                                        text: 'تعديل البيانات',
                                        backgroundColor: AppColors.orange,
                                        textColor: Colors.black,
                                        borderColor: AppColors.orange,
                                        function: () async {
                                          if (userData["blocked"] == 'yes') {
                                            Get.snackbar(
                                              'عذراً',
                                              "تم حظر  حسابك يرجى التواصل مع الادارة",
                                              snackPosition:
                                                  SnackPosition.BOTTOM,
                                              backgroundColor:
                                                  AppColors.grayshade,
                                              colorText: Colors.black,
                                              duration:
                                                  const Duration(seconds: 1),
                                            );
                                          } else {
                                            await Get.to(EditProfile(
                                              userId: userData,
                                            ));
                                          }
                                        },
                                      ),
                                    )
                                  : isFollowing
                                      ? FollowButton(
                                          text: 'الغاء المتابعة',
                                          backgroundColor: AppColors.orange,
                                          textColor: Colors.black,
                                          borderColor: AppColors.orange,
                                          function: () async {
                                            if (userData["blocked"] == 'yes') {
                                              Get.snackbar(
                                                'عذراً',
                                                "تم حظر  حسابك يرجى التواصل مع الادارة",
                                                snackPosition:
                                                    SnackPosition.BOTTOM,
                                                backgroundColor:
                                                    AppColors.grayshade,
                                                colorText: Colors.black,
                                                duration:
                                                    const Duration(seconds: 1),
                                              );
                                            } else {
                                              await FireStoreMethods()
                                                  .followUser(
                                                FirebaseAuth
                                                    .instance.currentUser!.uid,
                                                userData['uid'],
                                              );

                                              setState(() {
                                                isFollowing = false;
                                                followers--;
                                              });
                                            }
                                          },
                                        )
                                      : FollowButton(
                                          text: 'متابعة',
                                          backgroundColor: AppColors.orange,
                                          textColor: Colors.white,
                                          borderColor: AppColors.orange,
                                          function: () async {
                                            if (userData["blocked"] == 'yes') {
                                              Get.snackbar(
                                                'عذراً',
                                                "تم حظر  حسابك يرجى التواصل مع الادارة",
                                                snackPosition:
                                                    SnackPosition.BOTTOM,
                                                backgroundColor:
                                                    AppColors.grayshade,
                                                colorText: Colors.black,
                                                duration:
                                                    const Duration(seconds: 1),
                                              );
                                            } else {
                                              if (userData['type'] ==
                                                      ('creative') ||
                                                  userData['type'] ==
                                                      ('user')) {
                                                await FireStoreMethods()
                                                    .followUser(
                                                  FirebaseAuth.instance
                                                      .currentUser!.uid,
                                                  userData['uid'],
                                                );

                                                setState(() {
                                                  isFollowing = true;
                                                  followers++;
                                                });
                                              } else {
                                                Get.snackbar(
                                                  'عذراً',
                                                  " يجب تسجيل الدخول أولاً",
                                                  snackPosition:
                                                      SnackPosition.BOTTOM,
                                                  backgroundColor:
                                                      AppColors.grayshade,
                                                  colorText: Colors.black,
                                                  duration: const Duration(
                                                      seconds: 1),
                                                );
                                              }
                                            }
                                          }),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Divider(),
                          StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('product')
                                .where('uid', isEqualTo: widget.uid)
                                .snapshots(),
                            initialData: const [],
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.orange,
                                  ),
                                );
                              }

                              return ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount:
                                    (snapshot.data! as dynamic).docs.length,
                                itemBuilder: (context, index) {
                                  return ProductCard(
                                      snaps: snapshot.data!.docs[index],
                                      docId: snapshot.data!.docs[index],
                                      detailes: snapshot.data!.docs[index],
                                      snap: snapshot.data!.docs[index]);
                                },
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}

class ShowImage extends StatelessWidget {
  final imageUrl;
  const ShowImage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: imageUrl == null
            ? Image.network(imageUrl)
            : const Center(
                child: CircularProgressIndicator(
                color: AppColors.orange,
              )),
      ),
    );
  }
}

class ShowImages extends StatelessWidget {
  final imageUrl;
  const ShowImages({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: CachedNetworkImage(
          placeholder: (conteext, url) =>
              const Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => const Icon(
            Icons.person,
          ),
          imageUrl: imageUrl,
          height: 40,
          width: 40,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
