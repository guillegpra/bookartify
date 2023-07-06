import 'package:bookartify/login_page.dart';
import 'package:bookartify/signup_page.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) => isLogin
    ? LoginPage(onClickedCreate: toggle)
    : SignUpPage(onClickedBack: toggle);

  void toggle() => setState(() {
    isLogin = !isLogin;
  });

}
