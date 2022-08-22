import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logandsign/model/user_model.dart';
import 'package:logandsign/providers/user_provider.dart';
import 'package:logandsign/service/firestore_methods.dart';
import 'package:logandsign/utils/app_colors.dart';
import 'package:logandsign/utils/image_picker.dart';
import 'package:logandsign/view/widgets/home/comment_card.dart';
import 'package:provider/provider.dart';

class CommentsScreen extends StatefulWidget {
  final postId;
  const CommentsScreen({
    Key? key,
    required this.postId,
  }) : super(key: key);

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController commentEditingController =
      TextEditingController();
  CollectionReference commendRef =
      FirebaseFirestore.instance.collection('product');

  void postComment(String uid, String name, String profilePic) async {
    try {
      String res = await FireStoreMethods().productComment(
        widget.postId,
        commentEditingController.text,
        uid,
        name,
        profilePic,
      );

      if (res != 'success') {
        showSnackBar(context, res);
      }
      setState(() {
        commentEditingController.text = "";
      });
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
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
            "التعليقات",
            style: TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('product')
                .doc(widget.postId)
                .collection('comments')
                .snapshots(),
            builder: (context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.orange,
                  ),
                );
              }
              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (ctx, index) =>
                    FirebaseAuth.instance.currentUser!.uid ==
                            snapshot.data!.docs[index]['uid']
                        ? Dismissible(
                            onDismissed: (direction) {
                              Get.defaultDialog(
                                title: "حذف التعليق",
                                titleStyle: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                                middleText: ' هل انت متاكد من عملية الحذف',
                                middleTextStyle: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                                backgroundColor: Colors.white,
                                radius: 10,
                                textCancel: " لا ",
                                cancelTextColor: Colors.orange,
                                textConfirm: " نعم ",
                                confirmTextColor: Colors.orange,
                                onCancel: () {
                                  Get.obs;
                                },
                                onConfirm: () {
                                  commendRef
                                      .doc(widget.postId)
                                      .collection('comments')
                                      .doc(snapshot.data!.docs[index].id)
                                      .delete();
                                  Get.back();
                                },
                              );
                            },
                            key: UniqueKey(),
                            child: CommentCard(
                              postId: widget.postId,
                              snap: snapshot.data!.docs[index],
                              docId: snapshot.data!.docs[index].id,
                            ),
                          )
                        : CommentCard(
                            postId: widget.postId,
                            snap: snapshot.data!.docs[index],
                            docId: snapshot.data!.docs[index].id,
                          ),
              );
            },
          ),
        ),
        
        bottomNavigationBar: SafeArea(
          child: Container(
            height: kToolbarHeight,
            margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            padding: const EdgeInsets.only(left: 16, right: 8),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: CachedNetworkImage(
                    placeholder: (conteext, url) => const CircularProgressIndicator(
                      color: AppColors.orange,
                    ),
                    errorWidget: (context, url, error) => const Icon(
                      Icons.person,
                    ),
                    imageUrl: user.photoUrl!,
                    height: 40,
                    width: 40,
                    fit: BoxFit.cover,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 8),
                    child: TextField(
                      controller: commentEditingController,
                      decoration: InputDecoration(
                        hintText: ' تعليق ك ${user.name!}',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => postComment(
                    user.uid!,
                    user.name!,
                    user.photoUrl!,
                  ),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    child: const Text(
                      'اضافة',
                      style: TextStyle(color: AppColors.blue, fontSize: 17),
                    ),
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
