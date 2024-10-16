import 'package:college_application/screens/assignment_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_application/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  User? firebaseUser =
      FirebaseAuth.instance.currentUser; // Current Firebase user
  FireStoreService fireStoreService =
      FireStoreService(); // Firestore service instance
  Map<String, dynamic>? userData; // To store user data from Firestore
  List<Map<String, dynamic>> courses = []; // To store courses
  bool isLoading = true; // Loading state

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Fetch the user data when the widget is created
    _loadCourses(); // Load courses for the professor
  }

  Future<void> _loadUserData() async {
    if (firebaseUser != null) {
      try {
        DocumentSnapshot userDoc =
            await fireStoreService.readUser(firebaseUser!.uid);
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

  Future<void> _loadCourses() async {
    if (firebaseUser != null) {
      try {
        courses = await fireStoreService.getProfessorCourses(firebaseUser!.uid);
        setState(() {
          isLoading = false; // Set loading to false once courses are fetched
        });
      } catch (e) {
        print(e.toString());
      }
    }
  }

  Widget card(String title, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          border: Border.all(),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            color: Colors.red[200],
          ),
          child: Icon(
            icon,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ]),
    );
  }

  Widget Coursecard(String title, String className, IconData icon) {
    return Container(
      width: 100,
      height: 50,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          shape: BoxShape.rectangle,
          border: Border.all()),
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            color: Colors.red[200],
          ),
          child: Icon(
            icon,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 8),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              className,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            Text(
              title,
              style: TextStyle(fontSize: 12),
            ),
          ],
        )
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff7F1416),
        title: isLoading
            ? const Center(child: CircularProgressIndicator())
            : userData == null
                ? const Center(child: Text("No User Data Available"))
                : Text(
                    userData!['name'] ?? "Professor Name",
                    style: const TextStyle(color: Color(0xffffffff)),
                  ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : userData == null
              ? const Center(child: Text("No User Data Available"))
              : Padding(
                  padding: const EdgeInsets.all(10),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Courses",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 200, // Adjust the height as necessary
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, // Number of columns
                              childAspectRatio:
                                  1, // Adjusts the aspect ratio of the items
                              crossAxisSpacing: 10, // Spacing between columns
                              mainAxisSpacing: 10, // Spacing between rows
                            ),
                            itemCount: courses.length,
                            itemBuilder: (context, index) {
                              return Coursecard(
                                  courses[index]['courseName'],
                                  courses[index]['className'],
                                  Icons.book); // Customize the icon as needed
                            },
                          ),
                        ),
                        const Text(
                          "Information",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        InkWell(
                            onTap: () => Get.to(AssignmentScreen()),
                            child: card("Assignments", Icons.book)),
                        card("Announcements", Icons.announcement),
                        card("Lessons", Icons.play_lesson),
                        card("Topics", Icons.topic),
                        card("Calendar", Icons.calendar_today),
                        card("Exams", Icons.quiz),
                        card("Add Result", Icons.note),
                        card("Manage Leaves", Icons.time_to_leave),
                      ],
                    ),
                  ),
                ),
    );
  }
}
