import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_application/services/firestore_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? firebaseUser =
      FirebaseAuth.instance.currentUser; // Current Firebase user
  FireStoreService fireStoreService =
      FireStoreService(); // Firestore service instance
  Map<String, dynamic>? userData; // To store user data from Firestore
  bool isLoading = true; // Loading state

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Fetch the user data when the widget is created
  }

  Future<void> _loadUserData() async {
    if (firebaseUser != null) {
      try {
        DocumentSnapshot userDoc =
            await fireStoreService.readUser(firebaseUser!.uid);
        print(firebaseUser!.uid.toString());

        setState(() {
          userData = userDoc.data() as Map<String, dynamic>?;
          isLoading = false; // Set loading to false once data is fetched
        });
      } catch (e) {
        print(e.toString());
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Widget card(String title, String content, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
                color: Color(0xff7F1416),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Icon(
              icon,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 12),
              ),
              Text(
                content,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xff7F1416),
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: isLoading
          ? const Center(
              child:
                  CircularProgressIndicator()) // Show loading indicator while data is fetched
          : userData == null
              ? const Center(child: Text("No User Data Available"))
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        children: [
                          Text(
                            userData!['name'] ??
                                "Professor Name", // Fetch name from Firestore
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            height: 1,
                            width: 250,
                            decoration:
                                const BoxDecoration(color: Colors.black),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            alignment: Alignment.centerLeft,
                            child: const Text(
                              "Personal Info",
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                    card("Email", userData!['email'] ?? "-", Icons.email),
                    card(
                        "Phone Number", userData!['phone'] ?? "-", Icons.phone),
                    card("Date of Birth", userData!['DoB'] ?? "-",
                        Icons.calendar_month),
                    card("Gender", userData!['Gender'] ?? "-", Icons.person),
                    card("Qualification", userData!['Qualification'] ?? "-",
                        Icons.school),
                    card("Address", userData!['Address'] ?? "-",
                        Icons.location_on),
                  ],
                ),
    );
  }
}
