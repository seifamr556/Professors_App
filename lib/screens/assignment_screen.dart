import 'package:college_application/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:college_application/screens/create_assignment_screen.dart';

class AssignmentScreen extends StatefulWidget {
  const AssignmentScreen({super.key});

  @override
  State<AssignmentScreen> createState() => _AssignmentScreenState();
}

class _AssignmentScreenState extends State<AssignmentScreen> {
  User? firebaseUser = FirebaseAuth.instance.currentUser;
  final FireStoreService fireStoreService = FireStoreService();
  List<Map<String, dynamic>> assignments = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    setState(() {
      fetchAssignments();
    });
  }

  // Fetch assignments from Firestore
  void fetchAssignments() async {
    setState(() {
      isLoading = true;
    });

    assignments = await fireStoreService.getAllAssignments(firebaseUser!.uid);
    print(assignments.length);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff7F1416),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () => Get.to(() => const CreateAssignmentScreen()),
      ),
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Get.back();
            },
          ),
        ),
        backgroundColor: const Color(0xff7F1416),
        centerTitle: true,
        title: const Text(
          "Assignments",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : assignments.isEmpty
                ? const Center(child: Text("No assignments available."))
                : ListView.builder(
                    itemCount: assignments.length,
                    itemBuilder: (context, index) {
                      final assignment = assignments[index];
                      return Card(
                        elevation: 5,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Class: ${assignment['className']}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text("Course: ${assignment['courseName']}"),
                              const SizedBox(height: 5),
                              Text(
                                  "Assignment: ${assignment['assignmentName']}"),
                              const SizedBox(height: 5),
                              Text(
                                  "Instructions: ${assignment['instructions']}"),
                              const SizedBox(height: 5),
                              Text("Due Date: ${assignment['dueDate']}"),
                              const SizedBox(height: 5),
                              Text("Points: ${assignment['points']}"),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
