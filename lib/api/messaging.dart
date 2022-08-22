import 'dart:convert';
import 'package:http/http.dart';

class Messaging {
  static final Client client = Client();

  // from 'https://console.firebase.google.com'
  // --> project settings --> cloud messaging --> "Server key"
  static const String serverKey =
            '	AAAAi3p2DSQ:APA91bHGxpjmyvCL-apk80_tlCGwcG4ZlLPFdG79-WvNrs4y3-N9LzxJceiDQ96aujUM_WUk7c4w7VtNxwD17ILRfU-Xz5qbafbtvPsR43zvn6mmdIkgzr_vBtcGl1dZr4wF8VsGbBs1';

  static Future<Response> sendToAll({
    required String title,
    required String body,
    required String token,
  }) =>
      sendToTopic(title: title, body: body, topic: "on");

  static Future<Response> sendToTopic(
          {required String title,
          required String body,
          required String topic}) =>
      sendTo(title: title, body: body, fcmToken: '/topics/on');

  static Future<Response> sendTo({
    required String title,
    required String body,
    required String fcmToken,
  }) =>
      client.post(
       Uri(
    scheme: 'https',
    host: 'fcm.googleapis.com',
    path: '/fcm/send',),
        body: json.encode({
          'notification': {'body': body, 'title': title},
          'priority': 'high',
          'data': {
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '87',
            'status': 'done',
          },
          'to': '/topics/on',
        }),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKey',
        },
      );
   static Future<Response> sendToChat({
    required String title,
    required String body,
    required String fcmToken,
  }) =>
      client.post(
        Uri(
          scheme: 'https',
          host: 'fcm.googleapis.com',
          path: '/fcm/send',
        ),
        body: json.encode({
          'notification': {'body': body, 'title': title},
          'priority': 'high',
          'data': {
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '87',
            'status': 'done',
          },
          'to': fcmToken,
        }),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'key=	$serverKey'
        },
      );
      
}

