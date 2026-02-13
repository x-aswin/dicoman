import '../services/api_service.dart';
import '../models/profile.dart';

class ProfileController {
  final ProfileService _service = ProfileService();

  ProfileDetails? profile;
  bool isLoading = false;

  Future<void> fetchProfile(int studentId) async {
    isLoading = true;

    profile = await _service.fetchProfileDetailsserv(studentId);

    print("Inside controller after fetch: $profile");

    isLoading = false;
  }
}