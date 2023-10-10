import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:almaarchives3/rounded_button.dart';
import 'package:almaarchives3/constants.dart';
late String Rollno='',Roomno='',Hostel='',Quantity='',ItemName='';
class PostSport extends StatefulWidget {
  static const String id = 'postSport';


  @override
  _PostSport createState() => _PostSport();
}

class _PostSport extends State<PostSport> {


    final _auth = FirebaseAuth.instance;
    late String email;
    late String password;
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Sport'), // App bar title
          leading: IconButton(
            // Back button
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop(); // Navigate back when the button is pressed
            },
          ),
        ),
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(

            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextField(
                  onChanged: (value) {
                    Rollno=value;

                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter Roll No',
                  ),

                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextField(
                  onChanged: (value) {
                    Roomno=value;

                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter Room No',
                  ),
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextField(
                  onChanged: (value) {
                    Hostel=value;

                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter Hostel name',
                  ),
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextField(
                  onChanged: (value) {
                    ItemName=value;

                  },
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Equipment Name ',
                  ),
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextField(
                  onChanged: (value) {
                    Quantity=value;

                  },
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Quantity ',
                  ),
                ),
              ),
              SizedBox(
                height: 24.0,
              ),

              RoundedButton(
                title: 'Post',
                colour: Colors.lightBlueAccent,
                onPressed: () {
                  final rollNo = Rollno;
                  final roomno=Roomno;
                  final problemDescription =Hostel;

                  // Check if both fields are not empty before posting
                  if (rollNo.isNotEmpty && problemDescription.isNotEmpty) {
                    postComplaint(rollNo, problemDescription);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please fill out both fields.')),
                    );
                  }

                  // Additional code for button action
                },
              ),
            ],
          ),
        ),
      );
    }
    void postComplaint(String rollNo, String problemDescription) async {
      try {
        await FirebaseFirestore.instance.collection('Sport').add({
          'rollNo': rollNo,
          'RoomNO':Roomno,
          'ItemName': ItemName,
          'HostelName':Hostel,
          'Quantioty':Quantity,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Complaint successfully posted!')),
        );
      } catch (e) {
        print('Error posting complaint: $e');
      }
    }

  }

