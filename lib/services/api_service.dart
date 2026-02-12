// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/student.dart';

class ApiService {
  final String baseUrl = "https://dicoman.dist.ac.in/api";

  Future<Student?> login(String regNo, String password) async {
    //fake delay
    await Future.delayed(const Duration(seconds: 2));

    // final response = await http.post(Uri.parse('$baseUrl/login'), ...);
    
    if (regNo == "user" && password == "pass") {
      return Student(
        stdId: 3452,
        name: "Arun Das",
        regNo: "IMCA22089",
        batchId: 208,
        currentSem: 7,
        profileImageUrl: "https://thumbs.dreamstime.com/b/young-man-smiling-cartoon-profile-abstract-over-square-frame-background-vector-illustration-graphic-design-143189662.jpg",
      );
    }
    return null;
  }
}