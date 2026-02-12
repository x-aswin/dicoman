// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/student.dart';

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
}