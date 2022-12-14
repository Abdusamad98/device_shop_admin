import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_shop_admin/data/repositories/auth_repository.dart';
import 'package:device_shop_admin/data/repositories/categories_repository.dart';
import 'package:device_shop_admin/data/repositories/orders_repository.dart';
import 'package:device_shop_admin/data/repositories/product_repository.dart';
import 'package:device_shop_admin/data/repositories/profile_repository.dart';
import 'package:device_shop_admin/data/repositories/users_repository.dart';
import 'package:device_shop_admin/ui/admin/admin_screen.dart';
import 'package:device_shop_admin/ui/auth/auth_page.dart';
import 'package:device_shop_admin/view_models/auth_view_model.dart';
import 'package:device_shop_admin/view_models/categories_view_model.dart';
import 'package:device_shop_admin/view_models/orders_view_model.dart';
import 'package:device_shop_admin/view_models/products_view_model.dart';
import 'package:device_shop_admin/view_models/profile_view_model.dart';
import 'package:device_shop_admin/view_models/tab_view_model.dart';
import 'package:device_shop_admin/view_models/users_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  // await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}


void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await Firebase.initializeApp();
  var fireStore = FirebaseFirestore.instance;
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TabViewModel()),
        ChangeNotifierProvider(
          create: (context) => CategoriesViewModel(
            categoryRepository: CategoryRepository(
              firebaseFirestore: fireStore,
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => UsersViewModel(
            usersRepository: UsersRepository(
              firebaseFirestore: fireStore,
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => ProductViewModel(
            productRepository: ProductRepository(
              firebaseFirestore: fireStore,
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => OrdersViewModel(
            ordersRepository: OrdersRepository(
              firebaseFirestore: fireStore,
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => ProfileViewModel(
            firebaseAuth: FirebaseAuth.instance,
            profileRepository: ProfileRepository(firebaseFirestore: fireStore)
          ),
        ),
        Provider(
          create: (context) => AuthViewModel(
            authRepository: AuthRepository(firebaseAuth: FirebaseAuth.instance),
          ),
        )
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.hasData) {
            return AdminScreen();
          } else {
            return AuthPage();
          }
        });
  }
}
