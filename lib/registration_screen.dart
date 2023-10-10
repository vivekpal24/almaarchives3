import 'package:almaarchives3/HomeActivity.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:almaarchives3/rounded_button.dart';
import 'package:almaarchives3/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

class RegistrationScreen extends StatefulWidget{
  static const String id='registration_screen';
  @override
  _RegistrationaScreenState createState()=>_RegistrationaScreenState();
}
class _RegistrationaScreenState extends State<RegistrationScreen>{
  final _auth=FirebaseAuth.instance;
  late String email,conpassword;
  late String password,Rollno;
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor:Colors.white,
      body:Padding(
        padding: EdgeInsets.symmetric(horizontal:24.0),
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children:<Widget>[
            Container(
              height:200.0,
              child:Image.asset('images/logo.png'),
            ),
            SizedBox(
              height:48.0,
            ),
            TextField(
                obscureText: true,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  //Do something with the user input.
                  Rollno=value;
                },
                decoration:kTextFileDecoration.copyWith(hintText: 'Enter Roll No')
            ),
            SizedBox(
              height: 24.0,
            ),
            TextField(
              keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
              onChanged: (value){
                //do something with the user input
                email=value;
              },
              decoration:kTextFileDecoration.copyWith(hintText:'enter your email')
            ),
            SizedBox(
              height: 8.0,
            ),
            TextField(
                keyboardType: TextInputType.visiblePassword,
              obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value){
                //do something with the user input
                password=value;

              },

              decoration:kTextFileDecoration.copyWith(hintText:'enter password' )
            ),
            SizedBox(
              height:32.0,
            ),
            TextField(
                obscureText: true,
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  //Do something with the user input.
                  conpassword=value;
                },
                decoration:kTextFileDecoration.copyWith(hintText: 'Conform password')
            ),
            SizedBox(
              height: 24.0,
            ),
            RoundedButton(title:'Register',
              colour:Colors.blueAccent,
              onPressed:() async{
              if (password==conpassword) {
                try {
                  final newUser = await _auth.createUserWithEmailAndPassword(
                      email: email, password: password);
                  if (newUser != null) {
                    Navigator.pushNamed(context, HomeActivity.id);
                    addUserToFirestore(email, Rollno);
                  }
                }
                catch (e) {
                  print(e);
                }
              }

            },
            ),
          ],
        ),
      ),
    );
  }
  Future<void> addUserToFirestore( String email,String Rollno) async {
    try {
      await firestore.collection('users').add({

        'email': email,
        'Roll No':Rollno,
      });
      print('User data added to Firestore');
    } catch (e) {
      print('Error adding user data: $e');
    }
  }
}