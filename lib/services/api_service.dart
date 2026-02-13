// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
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