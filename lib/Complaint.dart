import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:almaarchives3/constants.dart';
import 'package:almaarchives3/rounded_button.dart';

late String Rollno='',Roomno='',Problem='';
class ComplaintScreen extends StatefulWidget {
  static const String id = 'Complaint';


  @override
  _ComplaintScreenState createState() => _ComplaintScreenState();
}

class _ComplaintScreenState extends State<ComplaintScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Complaint'), // App bar title
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
                  Problem=value;

                },
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Problem Description',
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
                final problemDescription =Problem;

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
      await FirebaseFirestore.instance.collection('complaints').add({
        'rollNo': rollNo,
        'RoomNO':Roomno,
        'problemDescription': problemDescription,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Complaint successfully posted!')),
      );
    } catch (e) {
      print('Error posting complaint: $e');
    }
  }
}
