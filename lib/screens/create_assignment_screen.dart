import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:college_application/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateAssignmentScreen extends StatefulWidget {
  const CreateAssignmentScreen({super.key});

  @override
  State<CreateAssignmentScreen> createState() => _CreateAssignmentScreen();
}

class _CreateAssignmentScreen extends State<CreateAssignmentScreen> {
  String? selectedClassId;
  String? selectedClassName;

  String? selectedCourseId;
  String? selectedCourseName;

  User? firebaseUser = FirebaseAuth.instance.currentUser;

  List<Map<String, dynamic>> classes = [];
  List<Map<String, dynamic>> courses = [];

  bool isLoadingClasses = true;
  bool isLoadingCourses = false;

  final FireStoreService fireStoreService = FireStoreService();

  final TextEditingController _assignmentNameController =
      TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();
  final TextEditingController _dueDateController = TextEditingController();
  final TextEditingController _dueTimeController = TextEditingController();
  final TextEditingController _pointsController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _assignmentNameController.dispose();
    _instructionsController.dispose();
    _dueDateController.dispose();
    _dueTimeController.dispose();
    _pointsController.dispose();
  }

  @override
  void initState() {
    super.initState();
    fetchProfessorClasses();
  }

  // Fetch classes when screen is loaded
  void fetchProfessorClasses() async {
    setState(() {
      isLoadingClasses = true;
    });

    classes = await fireStoreService.getClasses(firebaseUser!.uid);

    setState(() {
      isLoadingClasses = false;
    });
  }

  // Fetch courses for the selected class
  void fetchClassCourses(String classId) async {
    setState(() {
      isLoadingCourses = true;
      selectedCourseId = null; // Reset course selection
    });

    courses =
        await fireStoreService.getClassCourses(firebaseUser!.uid, classId);

    setState(() {
      isLoadingCourses = false;
    });
  }

  // Function to create the assignment
  void createAssignment() async {
    if (selectedClassId != null &&
        selectedCourseId != null &&
        _assignmentNameController.text.isNotEmpty &&
        _instructionsController.text.isNotEmpty &&
        _dueDateController.text.isNotEmpty &&
        _dueTimeController.text.isNotEmpty &&
        _pointsController.text.isNotEmpty) {
      // Call the Firestore service to create the assignment
      await fireStoreService.createAssignment(
        professorId: firebaseUser!.uid,
        classId: selectedClassId!,
        className: classes
            .firstWhere((c) => c['classId'] == selectedClassId)['className'],
        courseId: selectedCourseId!,
        courseName: courses
            .firstWhere((c) => c['courseId'] == selectedCourseId)['courseName'],
        assignmentName: _assignmentNameController.text,
        instructions: _instructionsController.text,
        dueDate: _dueDateController.text,
        dueTime: _dueTimeController.text,
        points: int.parse(_pointsController.text),
      );

      Get.snackbar("Success", "Assignment created successfully",
          backgroundColor: Colors.green, colorText: Colors.white);
    } else {
      Get.snackbar("Error", "Please fill out all fields",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title: const Text("Create Assignment",
            style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Class Dropdown
            isLoadingClasses
                ? const CircularProgressIndicator(
                    color: Color(0xff7F1416),
                  )
                : SizedBox(
                    width: 250,
                    height: 30,
                    child: DropdownButton<String>(
                      isExpanded: true,
                      hint: const Text("Select Class"),
                      value: selectedClassId,
                      items: classes.map((classData) {
                        return DropdownMenuItem<String>(
                          value: classData['classId'],
                          child: Text(classData['className']),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedClassId = value;

                          fetchClassCourses(selectedClassId!);
                        });
                      },
                    ),
                  ),

            // Course Dropdown
            isLoadingCourses
                ? const CircularProgressIndicator()
                : SizedBox(
                    width: 250,
                    height: 30,
                    child: DropdownButton<String>(
                      isExpanded: true,
                      hint: const Text("Select Course"),
                      value: selectedCourseId,
                      items: courses.map((courseData) {
                        return DropdownMenuItem<String>(
                          value: courseData['courseId'],
                          child: Text(courseData['courseName']),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCourseId = value!;
                        });
                      },
                    ),
                  ),

            // Assignment Name Input
            SizedBox(
              width: 300,
              height: 40,
              child: TextField(
                controller: _assignmentNameController,
                textAlignVertical: TextAlignVertical.bottom,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Assignment Name",
                ),
              ),
            ),

            // Instructions Input
            SizedBox(
              width: 300,
              height: 40,
              child: TextField(
                controller: _instructionsController,
                textAlignVertical: TextAlignVertical.bottom,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Instructions",
                ),
              ),
            ),

            // Due Date and Time Inputs
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.all(5),
                  width: 145,
                  height: 40,
                  child: TextField(
                    controller: _dueDateController,
                    textAlignVertical: TextAlignVertical.bottom,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Due Date",
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(5),
                  width: 145,
                  height: 40,
                  child: TextField(
                    controller: _dueTimeController,
                    textAlignVertical: TextAlignVertical.bottom,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Due Time",
                    ),
                  ),
                ),
              ],
            ),

            // Points Input
            SizedBox(
              width: 300,
              height: 40,
              child: TextField(
                controller: _pointsController,
                textAlignVertical: TextAlignVertical.bottom,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Points",
                ),
              ),
            ),

            // Create Assignment Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(15),
                  fixedSize: const Size(250, 40),
                  backgroundColor: const Color(0xff7F1416),
                  foregroundColor: Colors.white),
              onPressed: createAssignment,
              child: const Text(
                "Create Assignment",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
