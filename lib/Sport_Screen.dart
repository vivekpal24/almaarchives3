import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:almaarchives3/postSport.dart';

class SportScreen extends StatefulWidget {
  static const String id = 'Sport_Screen';

  @override
  _SportScreenState createState() => _SportScreenState();
}

class _SportScreenState extends State<SportScreen> {
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

  // Create a list to track the state of each checkbox
  List<bool> isReceivedList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sport Screen'), // App bar title
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Sport').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator(); // Loading indicator
          }

          // Extract the documents from the snapshot
          final sports = snapshot.data!.docs;

          // Create a list of Card widgets based on the data
          final sportCards = sports.asMap().entries.map((entry) {
            final index = entry.key;
            final sport = entry.value;
            final data = sport.data() as Map<String, dynamic>;

            // Check if the fields are null or empty before using them
            final productName = data['ItemName'] ?? '';
            final rollNo = data['rollNo'] ?? '';
            final issuanceTime = data['RoomNO'] ?? '';
            final quantity = data['Quantioty'] ?? '';
            final hostelName = data['HostelName'] ?? '';

            final imageUrl = data['imageUrl'] ?? ''; // Assuming you have an 'imageUrl' field

            // Initialize the state for the current checkbox
            if (isReceivedList.length <= index) {
              isReceivedList.add(false);
            }

            return Card(
              // Add elevation to give the card a shadow
              elevation: 4,
              child: Column(
                children: [
                  // Image from assets
                  Image.asset(
                    'images/sport.jpg', // Replace with your image path
                    width: double.infinity, // Make the image full width
                    height: 150, // Set the desired height
                    fit: BoxFit.cover, // Adjust the image fit
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Issued Product: $productName',
                          style: TextStyle(
                            fontSize: 18, // Increase font size for "Issued Product"
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Roll No: $rollNo'),
                                Text('Issued Time: $issuanceTime'),
                              ],
                            ),
                            // Add the checkbox that toggles color based on 'isReceived' state
                            areEqual
                                ? Checkbox(
                              value: isReceivedList[index],
                              onChanged: (value) {
                                // Toggle the checkbox state for this specific card
                                setState(() {
                                  isReceivedList[index] = value!;
                                });
                              },
                            )
                                : SizedBox(), // Empty SizedBox when not admin
                          ],
                        ),
                        SizedBox(height: 8), // Add spacing
                        Text('Quantity: $quantity'),
                        Text('Hostel Name: $hostelName'),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList();

          return ListView(
            children: sportCards,
          );
        },
      ),
      floatingActionButton: areEqual
          ? FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, PostSport.id);
          // Add List Tiles
          // Navigator.pushNamed(context, ComplaintScreen.id);
        },
        child: const Icon(Icons.add),
      )
          : null,
    );
  }
}
