import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/student.dart';

class AuthController extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  Student? _user;

  bool get isLoading => _isLoading;
  Student? get user => _user;

  Future<bool> login(String regNo, String password) async {
    _isLoading = true;
    notifyListeners(); // Tells the UI to show the spinner

    _user = await _apiService.login(regNo, password);

    _isLoading = false;
    notifyListeners(); // Tells the UI to hide the spinner
    return _user != null;
  }
}