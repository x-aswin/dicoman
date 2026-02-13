class Semester {
  final int id;
  final String name;

  Semester({required this.id, required this.name});

  factory Semester.fromJson(Map<String, dynamic> json) {
    return Semester(
      id: json['id'],
      name: json['name'],
    );
  }
}

class PeriodInfo {
  final String subject;
  final String staff;
  final int status; // 0 for Present, 1 for Absent/Late

  PeriodInfo({
    required this.subject,
    required this.staff,
    required this.status,
  });

  factory PeriodInfo.fromJson(Map<String, dynamic> json) {
    return PeriodInfo(
      subject: json['subject'] ?? 'N/A',
      staff: json['staff'] ?? 'N/A',
      status: json['status'] ?? 0,
    );
  }
}

class AttendanceRecord {
  final String date;
  final String status; // "P" or "A"
  final Map<String, PeriodInfo> periods;

  AttendanceRecord({
    required this.date,
    required this.status,
    required this.periods,
  });

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    // Map the nested periods JSON into our PeriodInfo model
    var periodsMap = <String, PeriodInfo>{};
    if (json['periods'] != null) {
      json['periods'].forEach((key, value) {
        periodsMap[key] = PeriodInfo.fromJson(value);
      });
    }

    return AttendanceRecord(
      date: json['date'],
      status: json['status'],
      periods: periodsMap,
    );
  }
}