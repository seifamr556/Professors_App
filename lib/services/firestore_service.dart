import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_application/classes/User.dart';

class FireStoreService {
  final _fire = FirebaseFirestore.instance;

  createUser(User user) {
    try {
      _fire.collection("users").add({
        "name": user.name,
        "email": user.email,
        "phone": user.phone,
        "Gender": user.gender,
        "DoB": user.DoB,
        "Address": user.address,
        "Qualification": user.qualification
      });
    } catch (e) {
      log(e.toString());
    }
  }

  Future<DocumentSnapshot> readUser(String uid) async {
    try {
      final userDoc = await _fire.collection("users").doc(uid).get();
      return userDoc;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getClasses(String professorId) async {
    List<Map<String, dynamic>> classesList = [];

    try {
      // Access the 'professors' collection and the specific professor's document
      DocumentSnapshot professorDoc =
          await _fire.collection('Professors').doc(professorId).get();

      if (professorDoc.exists) {
        // Access the 'classes' subcollection of the professor
        QuerySnapshot classesSnapshot = await _fire
            .collection('Professors')
            .doc(professorId)
            .collection('classes')
            .get();

        for (var classDoc in classesSnapshot.docs) {
          classesList.add({
            'classId': classDoc.id,
            'className': classDoc['name'], // Adjust field name as necessary
          });
        }
      }
    } catch (e) {
      print("Error fetching classes: $e");
    }

    return classesList;
  }

  Future<List<Map<String, dynamic>>> getProfessorCourses(
      String professorId) async {
    List<Map<String, dynamic>> courses = [];

    // Get the classes for the professor
    QuerySnapshot classSnapshot = await _fire
        .collection('Professors')
        .doc(professorId)
        .collection('classes')
        .get();

    // Loop through each class to get the courses
    for (var classDoc in classSnapshot.docs) {
      QuerySnapshot courseSnapshot =
          await classDoc.reference.collection('courses').get();
      for (var courseDoc in courseSnapshot.docs) {
        courses.add({
          'className': classDoc['name'],
          'courseName': courseDoc[
              'name'], // Adjust this field based on your actual field names
        });
      }
    }
    return courses;
  }

  Future<List<Map<String, dynamic>>> getAllAssignments(
      String professorId) async {
    try {
      QuerySnapshot querySnapshot = await _fire
          .collection('assignments')
          .where('professorId', isEqualTo: professorId)
          .get();

      // Map the documents to a list of assignment data
      return querySnapshot.docs.map((doc) {
        return {
          'className': doc['className'],
          'courseName': doc['courseName'],
          'assignmentName': doc['assignmentName'],
          'instructions': doc['instructions'],
          'dueDate': doc['dueDate'],
          'points': doc['points'],
        };
      }).toList();
    } catch (e) {
      print('Error fetching assignments: $e');
      return [];
    }
  }

  // Fetch courses for a specific class
  Future<List<Map<String, dynamic>>> getClassCourses(
      String professorId, String classId) async {
    try {
      QuerySnapshot courseSnapshot = await _fire
          .collection('Professors')
          .doc(professorId)
          .collection('classes')
          .doc(classId)
          .collection('courses')
          .get();

      // Convert the data into a list of maps (for courses)
      List<Map<String, dynamic>> courses = courseSnapshot.docs.map((doc) {
        return {"courseId": doc.id, "courseName": doc['name']};
      }).toList();
      print(classId);

      return courses;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<void> createAssignment({
    required String professorId,
    required String classId,
    required String className,
    required String courseId,
    required String courseName,
    required String assignmentName,
    required String instructions,
    required String dueDate,
    required String dueTime,
    required int points,
  }) async {
    try {
      // Automatically generate an ID for each assignment using Firestore's add() method
      await _fire.collection('assignments').add({
        'professorId': professorId,
        'classId': classId,
        'className': className,
        'courseId': courseId,
        'courseName': courseName,
        'assignmentName': assignmentName,
        'instructions': instructions,
        'dueDate': dueDate,
        'dueTime': dueTime,
        'points': points,
        'createdAt':
            FieldValue.serverTimestamp(), // Optional: Add creation timestamp
      });
      print('Assignment created successfully');
    } catch (e) {
      print('Error creating assignment: $e');
    }
  }
}
