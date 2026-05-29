import 'package:flutter/material.dart';
import 'package:habit_track_app/Screens/detail_screen.dart';
import 'package:habit_track_app/Screens/signup_screen.dart';
import 'package:habit_track_app/Screens/login_screen.dart';
import 'package:habit_track_app/Screens/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:habit_track_app/local_notification.dart';
import 'Screens/profile_screen.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await LocalNotificationService.init();
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habitt Tracker App',
      home: _auth.currentUser != null ? HomeScreen() : LoginScreen(),
      //_auth.currentUser != null ? HomeScreen() : LoginScreen(),
    );
  }
}