import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logandsign/logic/controllers/auth_controller.dart';
import 'package:logandsign/providers/user_provider.dart';
import 'package:logandsign/utils/app_colors.dart';
import 'package:logandsign/utils/background_user.dart';
import 'package:logandsign/view/screens/edit_Profile_User_Screen.dart';
import 'package:provider/provider.dart';

class ProfileScreenUser extends StatefulWidget {
  final String uid;

  const ProfileScreenUser({
    Key? key,
    required this.uid,
  }) : super(key: key);

  @override
  State<ProfileScreenUser> createState() => _ProfileScreenUserState();
}

class _ProfileScreenUserState extends State<ProfileScreenUser> {
  var userData = {};
  var productData = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
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
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      userData = userSnap.data()!;

      following = userSnap.data()!['following'].length;
      isFollowing = userSnap
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);

      setState(() {});
    } catch (e) {
      print(e);
    }
    setState(() {
      isLoading = false;
    });
  }

  final controller = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : RefreshIndicator(
            onRefresh: getData,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
                backgroundColor: Colors.white,
                body: Stack(children: [
                  BackgroundUser(),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 5.0),
                        InkWell(
                          onTap: () {
                            Get.to(ShowImage(
                                imageUrl: userData['photoUrl'].toString()));
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(70),
                            child: CachedNetworkImage(
                              placeholder: (conteext, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) => const Icon(
                                Icons.person,
                              ),
                              imageUrl: userData['photoUrl'].toString(),
                              height: 140,
                              width: 140,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "المستخدم : ",
                              style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 20.0,
                                  color: AppColors.blue),
                            ),
                            const SizedBox(
                              width: 14,
                            ),
                            Text(
                              userData['name'].toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "الايميل : ",
                              style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 20.0,
                                  color: AppColors.blue),
                            ),
                            const SizedBox(
                              width: 14,
                            ),
                            Text(
                              userData['email'].toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 20.0,
                                fontStyle: FontStyle.italic,
                                color: AppColors.blue,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: const [
                            SizedBox(width: 20.0),
                            SizedBox(width: 20.0),
                          ],
                        ),
                        const SizedBox(height: 50.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Text(
                                  following.toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                  ),
                                ),
                                Text(
                                  "يتابع",
                                  style: TextStyle(
                                      color: const Color.fromARGB(255, 0, 0, 0)
                                          .withOpacity(0.3),
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w100),
                                ),
                              ],
                            ),
                            Padding(
                                padding: const EdgeInsets.only(left: 0),
                                child: Container(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      Get.to(EditUserProfileScreen(
                                        userId: userData,
                                      ));
                                    },
                                    child: const Text(
                                      'تعديل البيانات',
                                      style: TextStyle(
                                        fontSize: 18.0,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      fixedSize: const Size(250.0, 45.0),
                                      primary: AppColors.blue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                    ),
                                  ),
                                ))
                          ],
                        ),
                      ],
                    ),
                  ),
                ]),
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
        child: Image.network(imageUrl),
      ),
    );
  }
}
