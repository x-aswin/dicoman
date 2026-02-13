import '../services/api_service.dart';
import '../models/mark.dart';
import '../models/attendance.dart';
class MarkController {
  final AttendanceService _attendservice = AttendanceService();
  final MarkService _markService = MarkService();

  List<SubjectMark> marks = [];
  List<Semester> semesters = [];
  List<String> exams = [];

  bool isLoading = false;

  Future<void> loadFilters(int studentId) async {
    semesters = await _attendservice.fetchSemesters();
    exams = await _markService.fetchExams();
  }

  Future<void> fetchMarks(
      int studentId, String semester, String exam) async {
    isLoading = true;

    marks =
        await _markService.fetchMarks(studentId, semester, exam);

    isLoading = false;
  }
}