import 'package:device_shop_admin/data/models/user_model.dart';
import 'package:device_shop_admin/utils/color.dart';
import 'package:device_shop_admin/utils/my_utils.dart';
import 'package:device_shop_admin/utils/style.dart';
import 'package:device_shop_admin/view_models/auth_view_model.dart';
import 'package:device_shop_admin/view_models/profile_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, required this.onClickSignUp}) : super(key: key);

  final VoidCallback onClickSignUp;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.black,
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextFormField(
                controller: emailController,
                textInputAction: TextInputAction.next,
                style: MyTextStyle.sfProRegular.copyWith(
                  color: MyColors.white,
                  fontSize: 17,
                ),
                decoration: getInputDecoration(label: "Email"),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextFormField(
                controller: passwordController,
                obscureText: true,
                textInputAction: TextInputAction.done,
                style: MyTextStyle.sfProRegular.copyWith(
                  color: MyColors.white,
                  fontSize: 17,
                ),
                decoration: getInputDecoration(label: "Password"),
              ),
            ),
            SizedBox(height: 100),
            TextButton(onPressed: signIn, child: Text("Sign In")),
            SizedBox(height: 20),
            RichText(
              text: TextSpan(
                style: MyTextStyle.sfProRegular
                    .copyWith(color: const Color(0xFFFBDF00), fontSize: 18),
                text: "Don't have an account?  ",
                children: [
                  TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = widget.onClickSignUp,
                    text: "Sign Up",
                    style: MyTextStyle.sfProBold.copyWith(
                      color: const Color(0xFFFBDF00),
                      fontSize: 18,
                    ),
                  )
                ],
              ),
            ),
            IconButton(
                onPressed: () async {
                  UserCredential? userCredential =
                      await Provider.of<AuthViewModel>(
                    context,
                    listen: false,
                  ).signInWithGoogle();
                  if (userCredential != null) {
                    print("PHOTO URL:${userCredential.user!.photoURL}");
                    Provider.of<ProfileViewModel>(context,listen: false).addUser(
                      UserModel(
                        fcmToken: "",
                        docId: "",
                        age: 0,
                        userId: FirebaseAuth.instance.currentUser!.uid,
                        fullName: userCredential.user!.displayName!,
                        email: userCredential.user!.email!,
                        createdAt: DateTime.now().toString(),
                        imageUrl: userCredential.user!.photoURL!,
                      ),
                    );
                  }
                },
                icon: const Icon(
                  Icons.golf_course_outlined,
                  color: Colors.white,
                ))
          ],
        ),
      ),
    );
  }

  //" Hello World  "

  Future<void> signIn() async {
    Provider.of<AuthViewModel>(context, listen: false).signIn(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
