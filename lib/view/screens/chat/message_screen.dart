import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logandsign/utils/app_colors.dart';
import 'package:logandsign/view/widgets/chat/message_screen_widget.dart';
import 'package:logandsign/model/user_model.dart';
import 'package:logandsign/view/widgets/chat/single_message.dart';

class MessagePage extends StatelessWidget {
  final UserModel currentUser;
  final String friendId;
  final String photo;
  final String friendName;
  final String friendImage;
  final String friendToken;

  const MessagePage({
    required this.currentUser,
    required this.friendId,
    required this.photo,
    required this.friendName,
    required this.friendImage,
    required this.friendToken,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.orange,
        title: Row(
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
                imageUrl: friendImage,
                height: 40,
                width: 40,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              friendName,
              style: const TextStyle(fontSize: 20, color: Colors.black),
            )
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5),
                ),
              ),
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .doc(currentUser.uid)
                      .collection('messages')
                      .doc(friendId)
                      .collection('chats')
                      .orderBy("date", descending: true)
                      .snapshots(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.docs.length < 1) {
                        return const Center(
                          child: Text(
                            "say Hi",
                            style: TextStyle(fontSize: 20, color: Colors.black),
                          ),
                        );
                      }
                      return ListView.builder(
                          itemCount: snapshot.data.docs.length,
                          reverse: true,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            bool isMe = snapshot.data.docs[index]['senderId'] ==
                                currentUser.uid;
                            return SingleMessage(
                                map: snapshot.data!.docs[index].data(),
                                friendName: friendName,
                                friendImage: friendImage,
                                uid: friendId,
                                message: snapshot.data.docs[index]['message'],
                                imageUrl: friendImage,
                                isMe: isMe);
                          });
                    }
                    return const Center(
                        child: CircularProgressIndicator(
                      color: AppColors.orange,
                    ));
                  }),
            ),
          ),
          MessageTextField(
            currentUser.uid!,
            friendId,
            friendToken.toString(),
          )
        ],
      ),
    );
  }
}
