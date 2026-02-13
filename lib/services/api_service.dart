// lib/services/api_service.dart
import '../models/attendance.dart';
import 'dart:convert';
//import 'package:http/http.dart' as http;
import '../models/student.dart';
import '../models/notification.dart';

class ApiService {
  final String baseUrl = "https://dicoman.dist.ac.in/api";

  Future<Student?> login(String regNo, String password) async {
    //Keep the fake delay to simulate network latency
    await Future.delayed(const Duration(seconds: 2));

    //Hardcoded JSON response (matches the DiST API format)
    const String mockJsonResponse = '''
{
  "std_id": 3452,
  "std_name": "Arun Das",
  "reg_no": "IMCA22089",
  "batch_id": 208,
  "cur_sem": 7
}
''';

    //Check credentials and parse JSON
    if (regNo == "user" && password == "pass") {
      // Convert the string into a Map<String, dynamic>
      final Map<String, dynamic> data = jsonDecode(mockJsonResponse);
      
      // Use your model's factory to create the object
      return Student.fromJson(data);
    }
    
    return null;
  }



  Future<List<AppNotification>> fetchNotifications() async {
  await Future.delayed(const Duration(seconds: 2)); // Simulating network delay

  // Mock JSON data from server
  const String mockJson = '''
  [
    {"id": 1, "title": "Exam Results", "description": "Semester 7 results are out.", "time": "10:00 AM"},
    {"id": 2, "title": "Sura our Hero!", "description": "Soora is the best person in the world.", "time": "06:30 PM"},
    {"id": 3, "title": "Holiday Notice", "description": "Tomorrow is a holiday due to rain.", "time": "02:30 PM"},
    {"id": 4, "title": "Seminar", "description": "AI Seminar in the main hall at 11 AM.", "time": "Yesterday"}
  ]
  ''';

  final List<dynamic> data = jsonDecode(mockJson);
  return data.map((json) => AppNotification.fromJson(json)).toList();
}



}

class AttendanceService {
  // 1. Fetch Semester List for the dropdown
  Future<List<Semester>> fetchSemesters() async {
    // Simulate server delay
    await Future.delayed(const Duration(milliseconds: 600));

    // This represents the JSON response from your API
    final List<Map<String, dynamic>> mockSemJson = [
      {"id": 1, "name": "Semester 1"},
      {"id": 2, "name": "Semester 2"},
      {"id": 6, "name": "Semester 6"},
      {"id": 7, "name": "Semester 7"},
    ];

    return mockSemJson.map((json) => Semester.fromJson(json)).toList();
  }

  // 2. Fetch Attendance based on the selected Semester ID
  Future<List<AttendanceRecord>> fetchAttendance(int semId) async {
    // Simulate server delay
    await Future.delayed(const Duration(seconds: 1));

    // This mimics the structured data extracted from the DiCoMan snapshot
    final List<Map<String, dynamic>> mockAttendanceJson = [
      {
        "date": "2025-10-06",
        "status": "P",
        "periods": {
          "I": {"subject": "CRY", "staff": "ANJALI MENON K R", "status": 0},
          "II": {"subject": "ADA", "staff": "JACOB THALIYAN", "status": 0},
          "III": {"subject": "DMW", "staff": "VIDHYA V", "status": 0},
          "IV": {"subject": "CN", "staff": "AMAL DEV K", "status": 0},
          "V": {"subject": "REV", "staff": "ANDRIYA TINA", "status": 0},
          "VI": {"subject": "REV", "staff": "ANDRIYA TINA", "status": 0},
        }
      },
      {
        "date": "2025-10-07",
        "status": "A",
        "periods": {
          "I": {"subject": "REV", "staff": "ANDRIYA TINA", "status": 1},
          "II": {"subject": "REV", "staff": "ANDRIYA TINA", "status": 1},
          "III": {"subject": "REV", "staff": "ANDRIYA TINA", "status": 1},
        }
      }
    ];

    return mockAttendanceJson.map((json) => AttendanceRecord.fromJson(json)).toList();
  }
}