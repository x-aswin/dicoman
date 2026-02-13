import 'package:flutter/material.dart';
//import '../services/api_service.dart';
import '../models/student.dart';

class profileController extends ChangeNotifier {
  Future<Student> fetchStudentProfile(int studentId) async {
    // 🔹 Simulate API call (replace with real API later)
    await Future.delayed(const Duration(seconds: 1));

    // Example response (mock data)
    return Student(
      stdId: studentId,
      name: "Sooraj S Kumar",
      regNo: "IMCA22016",
      batchId: 2022,
      currentSem: 7,
      profileImageUrl: "https://cdn-icons-png.flaticon.com/512/219/219970.png",
    );
  }
}