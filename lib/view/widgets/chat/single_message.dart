import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logandsign/model/user_model.dart' as model;
import 'package:logandsign/providers/user_provider.dart';
import 'package:logandsign/utils/app_colors.dart';
import 'package:provider/provider.dart';

class SingleMessage extends StatefulWidget {
  final String message;
  final String imageUrl;
  final String friendImage;
  final String friendName;
  final String uid;
  final bool isMe;
  final map;
  const SingleMessage(
      {required this.message,
      required this.isMe,
      required this.map,
      required this.imageUrl,
      required this.friendImage,
      required this.friendName,
      required this.uid});

  @override
  State<SingleMessage> createState() => _SingleMessageState();
}

class _SingleMessageState extends State<SingleMessage> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final model.UserModel user = Provider.of<UserProvider>(context).getUser;
    return widget.map['type'] == "text"
        ? widget.isMe
            ? Row(
                mainAxisAlignment: widget.isMe
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20, right: 5),
                    child: Material(
                      elevation: 5,
                      borderRadius: widget.isMe
                          ? const BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              topLeft: Radius.circular(10),
                            )
                          : const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                      color: widget.isMe ? AppColors.blue : AppColors.orange,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        child: Column(
                          children: [
                            Text(
                              widget.message,
                              style:
                                  const TextStyle(fontSize: 17, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(right: 6, top: 10, bottom: 25),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: widget.isMe
                          ? InkWell(
                              onTap: () {
                                
                                
                                
                              },
                              child: CachedNetworkImage(
                                placeholder: (conteext, url) =>
                                    const CircularProgressIndicator(
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
                            )
                          : InkWell(
                              onTap: () {
                                
                                
                                
                              },
                              child: CachedNetworkImage(
                                placeholder: (conteext, url) => const Center(
                                    child: CircularProgressIndicator(
                                  color: AppColors.orange,
                                )),
                                errorWidget: (context, url, error) => const Icon(
                                  Icons.person,
                                ),
                                imageUrl: widget.friendImage,
                                
                                height: 40,
                                width: 40,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 6, top: 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: InkWell(
                          onTap: () {
                            
                            
                            
                          },
                          child: CachedNetworkImage(
                            placeholder: (conteext, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) => const Icon(
                              Icons.person,
                            ),
                            imageUrl: widget.friendImage,
                            
                            height: 40,
                            width: 40,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Material(
                      elevation: 5,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      color: AppColors.orange,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        child: Column(
                          children: [
                            Text(
                              widget.message,
                              style: const TextStyle(
                                fontSize: 17,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
        : InkWell(
            onTap: () {
              Get.to(ShowImages(imageUrl: widget.map["message"]));
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 30,right: 30,bottom: 8,top: 8),
              child: Container(
                  height: size.height / 2.5,
                  width: size.width / 2,
                  decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(5),
                        bottomLeft: Radius.circular(5),
                        topLeft: Radius.circular(5),
                      )),
                  alignment:
                      widget.map["message"] != "" ? null : Alignment.center,
                  child: widget.map["message"] == null
                      ? const Center(
                          child: CircularProgressIndicator(
                          color: AppColors.orange,
                        ))
                      : CachedNetworkImage(
                          placeholder: (conteext, url) => const Center(
                              child: CircularProgressIndicator(
                            color: AppColors.orange,
                          )),
                          errorWidget: (context, url, error) => const Icon(
                            Icons.person,
                          ),
                          imageUrl: widget.map['message'],
                          height: 40,
                          width: 40,
                          fit: BoxFit.cover,
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
        )
        
        
        
        
        
        
        
        
        ,
      ),
    );
  }
}