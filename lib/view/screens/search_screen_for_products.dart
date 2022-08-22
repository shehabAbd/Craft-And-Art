import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logandsign/model/user_model.dart' as model;
import 'package:logandsign/providers/user_provider.dart';
import 'package:logandsign/utils/app_colors.dart';
import 'package:logandsign/view/screens/craft/craft_detailes_screen.dart';
import 'package:provider/provider.dart';

class Search extends StatefulWidget {
  const Search();

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final model.UserModel user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        actions: [
          IconButton(
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
                showSearch(
                    context: context, delegate: SearchScreenForProduct());
              }
            },
            icon: const Icon(Icons.search),
          ),
        ],
        leading: Container(),
        backgroundColor: Colors.orange,
        centerTitle: true,
        title: const Text(
          "البحث عن المنتجات",
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 80),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/Searchproduct.png"),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "  ابحث عن المنتجات بالإسم ",
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
      ),
    );
  }
}

class SearchScreenForProduct extends SearchDelegate {
  SearchScreenForProduct();

  final CollectionReference _FirebaseFireStore =
      FirebaseFirestore.instance.collection('product');

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      Row(
        children: [
          IconButton(
            onPressed: () {
              query = "";
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        Get.back();
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _FirebaseFireStore.snapshots().asBroadcastStream(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.orange,
            ),
          );
        } else {
          if (snapshot.data!.docs
              .where((QueryDocumentSnapshot<Object?> element) =>
                  element['postname']
                      .toString()
                      .toLowerCase()
                      .contains(query.toLowerCase()))
              .isEmpty) {
            return SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    Image.asset("assets/nothingFound.png"),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "لا يوجد نتائج لعملية البحث",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
            );
          } else {
            return GridView.count(
              crossAxisCount: 3,
              mainAxisSpacing: 1.5,
              crossAxisSpacing: 5,
              childAspectRatio: 1,
              children: [
                ...snapshot.data!.docs
                    .where(
                  (QueryDocumentSnapshot<Object?> element) =>
                      element['postname'].toString().toLowerCase().contains(
                            query.toLowerCase(),
                          ),
                )
                    .map(
                  (QueryDocumentSnapshot<Object?> data) {
                    final String postUrl = data.get("postUrl");
                    final String postId = data.get("postId");
                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: InkWell(
                        onTap: () {
                          Get.to(DetailesScreen(
                            detailes: data,
                            snap: postId,
                            snaps: data,
                          ));
                        },
                        child: CachedNetworkImage(
                          imageUrl: postUrl,
                          placeholder: (conteext, url) =>
                              const CircularProgressIndicator(
                            color: AppColors.orange,
                          ),
                          errorWidget: (context, url, error) => const Icon(
                            Icons.wifi,
                          ),
                          fit: BoxFit.cover,
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
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 80),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/Searchproduct.png"),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "  ابحث عن المنتجات بالإسم ",
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
