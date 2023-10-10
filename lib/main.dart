import 'package:almaarchives3/Complaint.dart';
import 'package:almaarchives3/Entry.dart';
import 'package:almaarchives3/HomeActivity.dart';
import 'package:almaarchives3/Sport_Screen.dart';
import 'package:almaarchives3/postSport.dart';
import 'package:almaarchives3/review.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:almaarchives3/registration_screen.dart';
import 'package:almaarchives3/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();


  runApp( alma());
}

class alma extends StatefulWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  _almaState createState() => _almaState();
}

class _almaState extends State<alma> {
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final bool loggedIn = prefs.getBool('loggedIn') ?? false;

    setState(() {
      isLoggedIn = loggedIn;
    });
  }

  void login() async {
    // You can implement your login logic here.
    // After successful login, set isLoggedIn to true and update SharedPreferences.
    // Example:
    // isLoggedIn = true;
    // setLoggedIn(true);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('loggedIn', true);

    setState(() {
      isLoggedIn = true;
    });
  }

  void logout() async {
    // Implement your logout logic here.
    // Set isLoggedIn to false and update SharedPreferences.
    // Example:
    // isLoggedIn = false;
    // setLoggedIn(false);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('loggedIn', false);

    setState(() {
      isLoggedIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget._initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print("Something went wrong");
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            initialRoute: isLoggedIn ? HomeActivity.id : LoginScreen.id,
            routes: {
              LoginScreen.id: (context) => LoginScreen(),
              RegistrationScreen.id: (context) => RegistrationScreen(),
              HomeActivity.id: (context) => HomeActivity(),
              ReviewScreen.id: (context) => ReviewScreen(),
              ComplaintScreen.id: (context) => ComplaintScreen(),
              SportScreen.id: (context) => SportScreen(),
              EntryScreen.id: (context) => EntryScreen(),
              PostSport.id:(context)=>PostSport(),
            },
          );
        }
        return CircularProgressIndicator();
      },
    );
  }
}
