import 'package:device_shop_admin/ui/admin/category/all_categories_screen.dart';
import 'package:device_shop_admin/ui/admin/products/all_products_screen.dart';
import 'package:device_shop_admin/ui/chat/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  _printFCMTOKEN() async {
    String? token = await FirebaseMessaging.instance.getToken();
    print("FCM TOKEN:$token");
  }

  _handleFirebaseNotificationMessages() async {
    //Foregrounddan kelgan messagelarni tutib olamiz
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Foregroundda message ushladim!');
      print('Message data: ${message.data}');
      if (message.notification != null) {
        print('Notification bor: ${message.notification}');
        print(message.notification!.title);
        print(message.notification!.body);
      }
    });
  }

  _setupInteractedMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    //Terminateddan kirganda bu ishlaydi
    if (initialMessage != null) {
      if (initialMessage.data['route'] == 'chat') {
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => ChatScreen()));
      }
    }

    //Backgounddan kirganda shu ishlaydi
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.data['route'] == 'chat') {
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => ChatScreen()));
      }
    });
  }

  @override
  void initState() {
    _printFCMTOKEN();
    _handleFirebaseNotificationMessages();
    _setupInteractedMessage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(FirebaseMessaging.instance.getToken());
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Page"),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text("Products"),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AllProductsScreen()));
            },
          ),
          ListTile(
            title: Text("Categories"),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AllCategoriesScreen()));
            },
          ),
        ],
      ),
    );
  }
}
