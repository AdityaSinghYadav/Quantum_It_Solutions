import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quantumit/Screens/welcome_screen.dart';

import 'News/home.dart';






void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      //options: FirebaseOptions(appId: "com.example.e_commerce1", apiKey: 'AIzaSyB0p1hsBbpEphZe_odD-rQbA7boDAAg8I8', messagingSenderId: '', projectId: 'e-commerce1-610f5')
    options: FirebaseOptions(appId: "com.example.quantumit",apiKey: 'AIzaSyA4kKrlXaRCoq8CDeIFrbRtnt2cTHgPBU8', messagingSenderId: '',projectId: 'quantum-2edf6')
  );
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(375, 812), builder: (BuildContext context, Widget? child) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return HomePage();
            } else {
              return WelcomeScreen();
            }
          },
        ),
      );
    },

    );
  }
}