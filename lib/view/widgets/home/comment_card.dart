import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:logandsign/model/user_model.dart';
import 'package:logandsign/providers/user_provider.dart';
import 'package:logandsign/styles/special_icon.dart';
import 'package:logandsign/utils/app_colors.dart';
import 'package:logandsign/view/screens/chat/message_screen.dart';
import 'package:provider/provider.dart';

class CommentCard extends StatefulWidget {
  final snap;
  final docId;
  final postId;
  const CommentCard(
      {Key? key, required this.snap, required this.docId, required this.postId})
      : super(key: key);

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  CollectionReference commendRef =
      FirebaseFirestore.instance.collection('product');
  String docsId = "";
  @override
  void initState() {
    docsId = widget.snap.data()['name'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final UserModel user = Provider.of<UserProvider>(context).getUser;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: CachedNetworkImage(
              placeholder: (conteext, url) => const CircularProgressIndicator(color: AppColors.orange,),
              errorWidget: (context, url, error) => const Icon(
                Icons.person,
              ),
              imageUrl: widget.snap.data()["profilePic"],
              height: 40,
              width: 40,
              fit: BoxFit.cover,
            ),
          ),
          
          
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: widget.snap.data()['name'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: ' ${widget.snap.data()['text']}',
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      DateFormat.yMMMd().format(
                        widget.snap.data()['datePublished'].toDate(),
                      ),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          FirebaseAuth.instance.currentUser!.uid == widget.snap['uid']
              ? SpecialIcon(
                  
                  iconData: Icons.delete,
                  color: const Color.fromARGB(255, 182, 141, 141),
                  doFunction: () async {
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
                            .doc(widget.docId)
                            .delete();
                            Get.back();
                      },
                    );
                  },
                )
              : SpecialIcon(
                  iconData: Icons.chat,
                  color: Colors.orange,
                  doFunction: () {
                    Get.to(MessagePage(
                      photo: user.photoUrl!,
                      currentUser: user,
                      friendId: "${widget.snap['uid']}",
                      friendName: "${widget.snap['name']}",
                      friendImage: widget.snap['profilePic'],
                      friendToken:"${widget.snap['token']}", 
                    ));
                  },
                ),
        ],
      ),
    );
  }
}
