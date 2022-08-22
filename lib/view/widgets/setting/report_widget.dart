import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:logandsign/model/user_model.dart';
import 'package:logandsign/providers/user_provider.dart';
import 'package:logandsign/utils/app_colors.dart';
import 'package:logandsign/utils/text_utils.dart';
import 'package:provider/provider.dart';

class ReportWidget extends StatefulWidget {
  const ReportWidget({Key? key}) : super(key: key);

  @override
  State<ReportWidget> createState() => _ReportWidgetState();
}

class _ReportWidgetState extends State<ReportWidget> {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Get.defaultDialog(
            title: "الأخطاء والمشاكل",
            titleStyle: const TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            middleText: 'هل تريد الأبلاغ عن مشكلة',
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
              Get.back();

              showDialog(
                  context: context,
                  builder: (context) => const FeedbackDialog());
            },
          );
        },
        splashColor: Colors.orange,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.orange,
              ),
              child: const Icon(
                FontAwesomeIcons.bell,
                color: AppColors.white,
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            TextUtils(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              text: "الأبلاغ عن مشكلة".tr,
              color: Get.isDarkMode ? Colors.white : Colors.black,
              underLine: TextDecoration.none,
            ),
          ],
        ),
      ),
    );
  }
}

class FeedbackDialog extends StatefulWidget {
  const FeedbackDialog({Key? key}) : super(key: key);

  @override
  State<FeedbackDialog> createState() => _FeedbackDialogState();
}

class _FeedbackDialogState extends State<FeedbackDialog> {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserModel user = Provider.of<UserProvider>(context).getUser;

    return AlertDialog(
      content: Form(
        key: _formKey,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: TextFormField(
            controller: _controller,
            keyboardType: TextInputType.multiline,
            decoration: const InputDecoration(
              hintText: "أدخل مشكلتك هنا يرجى اضافة رقمك او ايميلك للتواصل معك",
              filled: true,
            ),
            maxLines: 5,
            maxLength: 4096,
            textInputAction: TextInputAction.done,
            validator: (String? text) {
              if (text == null || text.isEmpty) {
                return 'الرجاء ذكر المشكلة';
              }
              return null;
            },
          ),
        ),
      ),
      actions: [
        TextButton(
          child: const Text('الغاء'),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: const Text('أرسال'),
          onPressed: () async {
            
            if (_formKey.currentState!.validate()) {
              
              
              String message;

              try {
                
                final collection =
                    FirebaseFirestore.instance.collection('feedback');

                
                await collection
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .set({
                  'date': DateTime.now(),
                  'feedback': _controller.text,
                  'uid': user.uid,
                  'photoUrl': user.photoUrl,
                  'name': user.name,
                  'type': user.type,
                });

                message = 'تم أرسال المشكلة بنجاح';
              } catch (e) {
                message = 'Error when sending feedback';
              }

              
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(message)));
              Navigator.pop(context);
            }
          },
        )
      ],
    );
  }
}
