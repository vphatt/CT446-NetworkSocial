import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socialnetwork/provider/user_provider.dart';
import 'package:socialnetwork/responsive/mobile_screen.dart';
import 'package:socialnetwork/responsive/responsive_screen.dart';
import 'package:socialnetwork/responsive/web_sreen.dart';
import 'package:socialnetwork/screen/login_screen.dart';
import 'package:socialnetwork/utils/colors.dart';

import 'screen/signup_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyBiTRGQcX50MY1GfMo2jVpOTUxu2V9mJgE",
            appId: "1:38996143522:web:ad8d09680973ab2a5c16fb",
            messagingSenderId: "38996143522",
            projectId: "social-network-c5d1c",
            storageBucket: "social-network-c5d1c.appspot.com"));
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => UserProvider())],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Socical Network',
          theme: ThemeData.light().copyWith(
            scaffoldBackgroundColor: mobileBackgroundColor,
          ),
          // home: ResponsiveScreen(
          //     mobileScreenLayout: MobileScreen(), webScreenLayout: WebScreen()));
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: ((context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  return const ResponsiveScreen(
                      mobileScreenLayout: MobileScreen(),
                      webScreenLayout: WebScreen());
                } else if (snapshot.hasError) {
                  return Center(child: Text('${snapshot.error}'));
                }
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(
                  color: primaryColor,
                ));
              }
              return const LoginScreen();
            }),
          )),
    );
  }
}
