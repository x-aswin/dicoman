import '../models/notification.dart';
import '../services/api_service.dart';

class NotificationController {
  // Singleton pattern to keep the data alive in the app memory
  static final NotificationController _instance = NotificationController._internal();
  factory NotificationController() => _instance;
  NotificationController._internal();

  final ApiService _apiService = ApiService();
  
  List<AppNotification> notifications = [];
  bool isLoading = false;
  String? errorMessage;

  Future<void> fetchAllNotifications() async {
    // Only fetch if the list is empty to save data/prevent flickering
    if (notifications.isNotEmpty) return;

    isLoading = true;
    errorMessage = null;

    try {
      notifications = await _apiService.fetchNotifications();
    } catch (e) {
      errorMessage = "Failed to load updates";
    } finally {
      isLoading = false;
    }
  }
}