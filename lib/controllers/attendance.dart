import '../models/attendance.dart';
import '../services/api_service.dart';

class AttendanceController {
  final AttendanceService _service = AttendanceService();

  // State variables
  List<Semester> semesters = [];
  List<AttendanceRecord> records = [];
  Semester? selectedSemester;
  bool isLoading = false;

  // 1. Initial Load: Get semesters first
  Future<void> init() async {
    isLoading = true;
    try {
      semesters = await _service.fetchSemesters();
      if (semesters.isNotEmpty) {
        // Default to the current/latest semester (like Sem 7)
        selectedSemester = semesters.last;
        await fetchAttendanceForSelected();
      }
    } catch (e) {
      print("Error initializing attendance: $e");
    } finally {
      isLoading = false;
    }
  }

  // 2. Fetch records for whichever semester is selected
  Future<void> fetchAttendanceForSelected() async {
    if (selectedSemester == null) return;
    
    isLoading = true;
    try {
      records = await _service.fetchAttendance(selectedSemester!.id);
    } catch (e) {
      print("Error fetching attendance: $e");
      records = [];
    } finally {
      isLoading = false;
    }
  }

  // 3. Change Semester
  void updateSemester(Semester newSem) {
    selectedSemester = newSem;
  }
}