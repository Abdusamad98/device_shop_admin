import 'dart:convert';
import 'package:http/http.dart' as https;
import 'package:http/http.dart';

class NotificationApiService {
  static Future<int> sendNotificationToUser({required  String fcmToken, required String message}) async {
    String key =
        "key=AAAAmf9x1RY:APA91bFty27T-ESnkOtIup05S3n7w9V6t5F8qZsE2xkxZZEBysst-EBF7ntlfKhc6n1uWFCUr--Rf_nNPzLIxgJ5re-pHl-sl5_cyoYEsUNuzdFDp1UWGx6IdvPNWMqV5Q0Z5Uhw5GM8";
    var body = {
      "to": fcmToken,
      "notification": {
        "title": "Diqqat! Notification keldi",
        "body": message
      },
      "data": {
        "name": "Abdulloh",
        "age": 22,
        "job": "Programmer",
        "route": "chat"
      }
    };

    Uri uri = Uri.parse("https://fcm.googleapis.com/fcm/send");

    try {
      Response response = await https.post(
        uri,
        headers: {"Authorization": key, "Content-Type": "application/json"},
        body: json.encode(body),
      );
      if (response.statusCode == 200) {
        var t = jsonDecode(response.body);
        print("RESPONSE:$t");
        return jsonDecode(response.body)["success"] as int;
      } else {
        throw Exception();
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<String> sendNotificationToAll(String topicName) async {
    String key =
        "key=AAAAmf9x1RY:APA91bFty27T-ESnkOtIup05S3n7w9V6t5F8qZsE2xkxZZEBysst-EBF7ntlfKhc6n1uWFCUr--Rf_nNPzLIxgJ5re-pHl-sl5_cyoYEsUNuzdFDp1UWGx6IdvPNWMqV5Q0Z5Uhw5GM8";

    Map<String, dynamic> body = {
      "to": "/topics/$topicName",
      "notification": {
        "title": "Diqqat! Notification keldi",
        "body": "Bu notofication body"
      },
      "data": {
        "name": "Abdulloh",
        "age": 22,
        "job": "Programmer",
        "route": "chat"
      }
    };

    Uri uri = Uri.parse("https://fcm.googleapis.com/fcm/send");
    try {
      Response response = await https.post(
        uri,
        headers: {
          "Authorization": key,
          "Content-Type": "application/json",
        },
        body: json.encode(body),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body)["message_id"].toString();
      } else {
        throw Exception();
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
