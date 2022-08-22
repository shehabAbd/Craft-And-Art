import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logandsign/providers/user_provider.dart';
import 'package:logandsign/utils/app_colors.dart';
import 'package:logandsign/view/screens/profile_creative_screen.dart';
import 'package:logandsign/view/screens/profile_user_screen.dart';

import 'package:logandsign/view/widgets/home/product_card.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CarouselController _carouselController = CarouselController();
  var userData = {};
  String uid = "";

  @override
  void initState() {
    super.initState();
    addData();
    getData();
  }

  addData() async {
    UserProvider _userProvider =
        Provider.of<UserProvider>(context, listen: false);
    await _userProvider.refreshUser();
  }

  Future getData() async {
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      userData = userSnap.data()!;
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(backgroundColor: AppColors.white, actions: [
          IconButton(
            onPressed: () {
              if (userData['type'] == ('creative')) {
                Get.to(ProfileScreen(
                  uid: FirebaseAuth.instance.currentUser!.uid,
                ));
              } else if (userData['type'] == ('user')) {
                Get.to(ProfileScreenUser(
                  uid: FirebaseAuth.instance.currentUser!.uid,
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
            },
            icon: const Icon(
              Icons.person,
              color: AppColors.blackshade,
            ),
            alignment: Alignment.center,
          )
        ]),
        backgroundColor: Colors.white,
        body: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            Padding(
              padding: const EdgeInsets.all(3),
              child: Column(
                children: [
                  const SizedBox(height: 5.0),
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('ads')
                          .where('statues', isEqualTo: "1")
                          .snapshots(),
                      builder: (context,
                          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                              snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.orange,
                            ),
                          );
                        }

                        return snapshot.data?.size != 0
                            ? CarouselSlider.builder(
                                options: CarouselOptions(
                                  autoPlayAnimationDuration:
                                      const Duration(milliseconds: 1500),
                                  autoPlay: true,
                                  scrollDirection: Axis.horizontal,
                                  scrollPhysics: const BouncingScrollPhysics(),
                                  viewportFraction: 0.9,
                                  aspectRatio: 1.6,
                                  disableCenter: false,
                                  initialPage: 0,
                                  enableInfiniteScroll: true,
                                  enlargeCenterPage: true,
                                  enlargeStrategy:
                                      CenterPageEnlargeStrategy.height,
                                  padEnds: false,
                                ),
                                carouselController: _carouselController,
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, i, realIndex) {
                                  return Stack(
                                    children: [
                                      Container(
                                        margin: const EdgeInsetsDirectional
                                            .fromSTEB(25, 10, 0, 24),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          child: InkWell(
                                            child: CachedNetworkImage(
                                              placeholder: (conteext, url) =>
                                                  const Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                color: AppColors.orange,
                                              )),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(
                                                Icons.wifi,
                                              ),
                                              imageUrl: snapshot.data!.docs[i]
                                                  .data()['url']
                                                  .toString(),
                                              fit: BoxFit.cover,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                            ),
                                            onTap: () {
                                              Get.to(ProfileScreen(
                                                  uid: snapshot
                                                      .data!.docs[i]['uid']
                                                      .toString()));
                                            },
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 90,
                                        margin: const EdgeInsetsDirectional
                                            .fromSTEB(230, 150, 0, 24),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              const BorderRadius.vertical(
                                                  top: Radius.circular(20)),
                                          color: Colors.black.withOpacity(0.4),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "خصم" +
                                                  snapshot.data!.docs[i]
                                                      .data()['cuttoff']
                                                      .toString() +
                                                  '%',
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  color: AppColors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: 120,
                                        margin: const EdgeInsetsDirectional
                                            .fromSTEB(25, 10, 0, 24),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              const BorderRadius.horizontal(
                                                  right: Radius.circular(25)),
                                          color: Colors.black.withOpacity(0.4),
                                        ),
                                        padding: const EdgeInsets.all(10),
                                        alignment: Alignment.center,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              snapshot.data!.docs[i]
                                                  .data()['title'],
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  color: AppColors.white,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  );
                                },
                              )
                            : Container(
                                child: Center(
                                    child:
                                        Text("لايوجد إعلانات في الوقت الحالي")),
                              );
                      }),
                  const Divider(),
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('product')
                          .orderBy("datePublished", descending: true)
                          .snapshots(),
                      builder: (context,
                          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                              snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.orange,
                            ),
                          );
                        }
                        return ListView.builder(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, i) {
                              uid = snapshot.data!.docs[i].data()['uid'];
                              return ProductCard(
                                snap: snapshot.data!.docs[i].data(),
                                snaps: snapshot.data!.docs[i],
                                detailes: snapshot.data!.docs[i].data(),
                                docId: snapshot.data!.docs[i].id,
                              );
                            });
                      })
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
