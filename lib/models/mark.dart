
class SubjectMark {
  final String subjectName;
  final int maxMark;
  final int passMark;
  final int mark;

  SubjectMark({
    required this.subjectName,
    required this.maxMark,
    required this.passMark,
    required this.mark,
  });
  

  double get percentage => (mark / maxMark) * 100;

  String get status => mark >= passMark ? "P" : "F";

  factory SubjectMark.fromJson(Map<String, dynamic> json) {
    return SubjectMark(
      subjectName: json['subjectName'] ?? '',
      maxMark: json['maxMark'] ?? 0,
      passMark: json['passMark'] ?? 0,
      mark: json['mark'] ?? 0,
    );
  }
}