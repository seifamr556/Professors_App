import 'dart:developer';
import 'package:college_application/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:college_application/services/auth_service.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = AuthService();

  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _email.dispose();
    _password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: const Text(
                "Sign In",
                style: TextStyle(
                    color: Color(0xff7F1416),
                    fontSize: 34,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const Text(
              "Welcome Back,\nYou've been missed!",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.normal),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              height: 60,
              child: TextField(
                controller: _email,
                textAlignVertical: TextAlignVertical.bottom,
                decoration: const InputDecoration(
                    focusColor: Color(0xff7F1416),
                    suffixIconColor: Color(0xff7F1416),
                    border: OutlineInputBorder(),
                    helperText: "Demo Email : professor@demo.com",
                    hintText: "Email",
                    suffixIcon: Icon(Icons.email)),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 5),
              height: 60,
              child: TextField(
                controller: _password,
                obscureText: true,
                obscuringCharacter: '*',
                textAlignVertical: TextAlignVertical.bottom,
                decoration: const InputDecoration(
                    focusColor: Color(0xff7F1416),
                    suffixIconColor: Color(0xff7F1416),
                    border: OutlineInputBorder(),
                    hintText: "Password",
                    helperText: "Demo Password : prof1234",
                    suffixIcon: Icon(Icons.password)),
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Forgot password?",
                    style: TextStyle(color: Color(0xff7F1416)),
                  )),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              alignment: Alignment.center,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      shape: const BeveledRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      backgroundColor: const Color(0xff7F1416),
                      fixedSize: const Size(300, 50)),
                  onPressed: _login,
                  child: const Text(
                    "Sign in",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  _login() async {
    final user =
        await _auth.loginUserWithEmailAndPassword(_email.text, _password.text);
    if (user != null) {
      Get.snackbar("", "User Logged In", duration: const Duration(seconds: 1));
      Get.to(HomeScreen());
    } else {
      log("Error");
    }
  }
}
