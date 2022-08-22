import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logandsign/model/user_model.dart';
import 'package:logandsign/providers/user_provider.dart';
import 'package:logandsign/service/firestore_methods.dart';
import 'package:logandsign/styles/special_icon.dart';
import 'package:logandsign/utils/app_colors.dart';
import 'package:logandsign/utils/image_picker.dart';
import 'package:logandsign/view/screens/profile_creative_screen.dart';
import 'package:logandsign/view/widgets/home/like_animation.dart';
import 'package:provider/provider.dart';

class FavoritesScreen extends StatefulWidget {
  final String uid;
  const FavoritesScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
    addData();
  }

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
      
      var postSnap = await FirebaseFirestore.instance
          .collection('product')
          .where('favorites', arrayContains: widget.uid)
          .get();
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

  @override
  Widget build(BuildContext context) {
    final UserModel user = Provider.of<UserProvider>(context).getUser;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.orange,
          title: const Text(
            "المفضلة",
            style: TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: AppColors.white,
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('product')
                .where('favorites', arrayContains: widget.uid)
                .snapshots(),
            initialData: const [],
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.orange,
                  ),
                );
              }

              if (snapshot.data.docs.length < 1) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 150,
                        width: 100,
                        child: Image.asset(
                          "assets/heart.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text("منتجاتك المفضلة",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 18,
                          )),
                    ],
                  ),
                );
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
              }
              return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: (snapshot.data! as dynamic).docs.length,
                  itemBuilder: (context, index) {
                    return buildFavItems(
                      snaps: snapshot.data!.docs[index],
                      userUid: user,
                    );
                  });
            }),
      ),
    );
  }

  Widget buildFavItems({
    required snaps,
    required userUid,
  }) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: SizedBox(
        width: double.infinity,
        height: 100,
        child: Row(
          children: [
            SizedBox(
              child: Card(
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                child: InkWell(
                  onTap: () {
                    Get.to(ProfileScreen(
                      
                      uid: snaps['uid'],
                    ));
                  },
                  child: CachedNetworkImage(
                    placeholder: (conteext, url) => const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => const Icon(
                      Icons.wifi,
                    ),
                    imageUrl: snaps['postUrl'],
                    height: 80,
                    width: 80,
                    fit: BoxFit.cover,
                  ),
                  
                  
                  
                  
                  
                  
                  
                ),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              flex: 10,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    snaps['name'],
                    style: const TextStyle(
                      overflow: TextOverflow.ellipsis,
                      color: AppColors.orange,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    snaps['postname'],
                    style: const TextStyle(
                      overflow: TextOverflow.ellipsis,
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'السعر : ' + snaps['price'],
                    style: const TextStyle(
                      overflow: TextOverflow.ellipsis,
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            LikeAnimation(
              isAnimating: snaps['favorites'].contains(userUid.uid),
              smallLike: true,
              child: snaps['favorites'].contains(userUid.uid)
                  ? Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: SpecialIcon(
                        
                        iconData: Icons.favorite,
                        color: const Color.fromARGB(255, 230, 12, 12),
                        doFunction: () async {
                          
                          FireStoreMethods().favoriteProduct(
                            snaps['postId'].toString(),
                            userUid.uid,
                            snaps['favorites'],
                          );
                        },
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.4),
                        shape: BoxShape.circle,
                      ),
                      child: SpecialIcon(
                        iconData: Icons.favorite_border,
                        color: Colors.black,
                        doFunction: () async {
                          FireStoreMethods().favoriteProduct(
                            snaps['postId'].toString(),
                            userUid.uid,
                            snaps['favorites'],
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
