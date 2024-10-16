import 'package:college_application/screens/create_assignment_screen.dart';
import 'package:college_application/services/intialize_screens.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyCk3m8K1MaYRzRXpZ33vU1u1yGyx_3Xa_g",
            authDomain: "college-application-39357.firebaseapp.com",
            projectId: "college-application-39357",
            storageBucket: "college-application-39357.appspot.com",
            messagingSenderId: "1029101325693",
            appId: "1:1029101325693:web:283381c1f54eab17455014"));
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'College App',
      debugShowCheckedModeBanner: false,
      home: InitialScreen(),
    );
  }
}
