

import 'package:firebase_chat/app/app.locator.dart';
import 'package:firebase_chat/ui/views/authentication/authentication_view.dart';
import 'package:firebase_chat/ui/views/home/home_view.dart';
import 'package:firebase_chat/ui/views/login/login_view.dart';
import 'package:firebase_chat/ui/views/register/register_view.dart';
import 'package:firebase_chat/ui/views/startup/startup_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app/app.router.dart';
import 'firebase_options.dart';
import 'package:get/get.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  await _initializeFirebase();
  setupLocator();
  await Supabase.initialize(
    url: 'https://odbfxpcutxelqyhrcpgr.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9kYmZ4cGN1dHhlbHF5aHJjcGdyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzgyMjM2MzksImV4cCI6MjA1Mzc5OTYzOX0.qQYekG7PxmZrVdpIlzRTXeYCfRuW1EyLYBAspnrkb2M',
  );

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((value) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FireChat',
      debugShowCheckedModeBanner: false,
      navigatorKey: StackedService.navigatorKey,
      onGenerateRoute: StackedRouter().onGenerateRoute,
      theme: ThemeData(
          useMaterial3: false,
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 1,
            iconTheme: IconThemeData(color: Colors.black),
            titleTextStyle: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.normal,
                fontSize: 19),
            backgroundColor: Colors.white,
          )),
      home: StartupView(),);
  }
}

Future<void> _initializeFirebase() async {
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,

        name: "firebase_chat",
      );
    }
  } catch (e) {
    throw Exception('Error initializing Firebase: $e');
  }
}
