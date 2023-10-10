import 'dart:async';

import 'package:almaarchives3/Entry.dart';
import 'package:almaarchives3/Sport_Screen.dart';
import 'package:almaarchives3/review.dart';
import 'package:flutter/material.dart';
import 'package:almaarchives3/rounded_button.dart';

class HomeActivity extends StatefulWidget {
  static const String id = 'HomeActivity';

  @override
  _HomeActivityState createState() => _HomeActivityState();
}

class _HomeActivityState extends State<HomeActivity> {
  int currentIndex = 0;
  List<String> imagePaths = [
    'images/image1.jpg',
    'images/image2.jpg',
    'images/image3.jpg',

  ];

  late ValueNotifier<int> notifier;

  @override
  void initState() {
    super.initState();
    notifier = ValueNotifier<int>(0);
    startImageRotation();
  }

  void startImageRotation() {
    const rotationDuration = Duration(seconds: 5); // Change images every 5 seconds
    Timer.periodic(rotationDuration, (timer) {
      currentIndex = (currentIndex + 1) % imagePaths.length;
      notifier.value = currentIndex;
    });
  }

  @override
  void dispose() {
    notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Alma Archives'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.more_vert), // Use 'Icons.more_vert' for overflow menu
              onPressed: () {
                // Navigator.pushNamed(context,EntryScreen.id);

                // Action to be performed when the IconButton is pressed
                print('Overflow menu button pressed');
              },
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ValueListenableBuilder<int>(
                valueListenable: notifier,
                builder: (context, index, child) {
                  return Image.asset(
                    imagePaths[index],
                    fit: BoxFit.cover,
                  );
                },
              ),
              RoundedButton(title:'Sport equipment',
                colour:Colors.lightBlueAccent,
                onPressed: ()async{
                Navigator.pushNamed(context, SportScreen.id);
                },

              ),
            // Add some spacing

              SizedBox(height: 16), // Add some spacing
              RoundedButton(title:'Complaint',
                colour:Colors.lightBlueAccent,
                onPressed: (){
                Navigator.pushNamed(context, ReviewScreen.id);
                },

              ),
              SizedBox(height: 16), // Add some spacing

            ],
          ),
        ),
      ),
    );
  }
}
