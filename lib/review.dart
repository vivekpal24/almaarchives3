import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:almaarchives3/Complaint.dart';

class ReviewScreen extends StatefulWidget {
  static const String id = 'review';

  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final _auth = FirebaseAuth.instance;
  late User loggedInUser;
  late bool areEqual = false;

  void initState() {
    getCurrentUser();
    super.initState();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser!;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
        areEqual = (user.email == "vivekpal2407@gmail.com");
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alma Archives'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              // Action to be performed when the info icon is pressed
              print('Info button pressed');
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('complaints').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }

          // Extract the documents from the snapshot
          final complaints = snapshot.data!.docs;

          return ListView.builder(
            itemCount: complaints.length,
            itemBuilder: (context, index) {
              final data = complaints[index].data() as Map<String, dynamic>;
              String rollno = data['rollNo'];
              String roomNo = data['RoomNO'];
              String problemDescription = data['problemDescription'];
              String imageUrl = data['imageUrl'] ?? ''; // Default to an empty string if imageUrl is null

              return CustomCard(
                roomNo: roomNo,
                rollNo: rollno,
                problemDescription: problemDescription,
                imageUrl: imageUrl,
                isAdmin: areEqual, // Pass the isAdmin property
                index: index, // Pass the index to track the checkbox state
              );
            },
          );
        },
      ),
      floatingActionButton:  FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, ComplaintScreen.id);
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      )

    );
  }
}

class CustomCard extends StatefulWidget {
  final String roomNo;
  final String rollNo;
  final String problemDescription;
  final String imageUrl;
  final bool isAdmin; // Add isAdmin property to pass the admin status
  final int index; // Add index to track the checkbox state

  CustomCard({
    required this.roomNo,
    required this.rollNo,
    required this.problemDescription,
    required this.imageUrl,
    required this.isAdmin, // Initialize isAdmin
    required this.index, // Initialize index
  });

  @override
  _CustomCardState createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  late bool isReceived;

  @override
  void initState() {
    super.initState();
    // Initialize isReceived based on the provided index
    isReceived = isReceivedList.length <= widget.index ? false : isReceivedList[widget.index];
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Column(
        children: [
          // Image from assets
          Image.asset(
            'images/complaint.jpg', // Replace with your image path
            width: double.infinity,
            height: 150,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Room No: ${widget.roomNo}',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Problem Description:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('Roll No: ${widget.rollNo}', style: TextStyle(fontSize: 18)),
                  ],
                ),
                SizedBox(height: 8), // Add spacing between Roll No and Problem Description
                Text(
                  widget.problemDescription,
                  style: TextStyle(fontSize: 18),
                ),
                if (widget.isAdmin) // Show the checkbox only if the user is an admin
                  Checkbox(
                    value: isReceived,
                    onChanged: (value) {
                      setState(() {
                        isReceived = value!;
                        isReceivedList[widget.index] = isReceived;
                      });
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// List to store the checkbox state for each item
List<bool> isReceivedList = [];
