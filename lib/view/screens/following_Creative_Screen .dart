import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logandsign/model/user_model.dart';
import 'package:logandsign/providers/user_provider.dart';
import 'package:logandsign/utils/app_colors.dart';
import 'package:logandsign/view/screens/profile_creative_screen.dart';
import 'package:provider/provider.dart';

class FollowingScreen extends StatefulWidget {
  final String uid;
  const FollowingScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<FollowingScreen> createState() => _FollowingScreenState();
}

class _FollowingScreenState extends State<FollowingScreen> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    addData();
  }

  addData() async {
    UserProvider _userProvider =
        Provider.of<UserProvider>(context, listen: false);
    await _userProvider.refreshUser();
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
            "اتابع",
            style: TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: AppColors.white,
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .where('followers', arrayContains: widget.uid)
                .snapshots(),
            initialData: const [],
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.orange,),
                );
              }

              return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: (snapshot.data! as dynamic).docs.length,
                  itemBuilder: (context, index) {
                    return buildFollowingItems(
                      snaps: snapshot.data!.docs[index],
                      userUid: user,
                    );
                  });
            }),
      ),
    );
  }

  Widget buildFollowingItems({
    required snaps,
    required userUid,
  }) {
    final UserModel user = Provider.of<UserProvider>(context).getUser;

    return Padding(
      padding: const EdgeInsets.all(10),
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: Row(
          children: [
            SizedBox(
              child: Card(
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
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
                    imageUrl: snaps['photoUrl'],
                    height: 50,
                    width: 50,
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
                      color: AppColors.blue,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
