class Student {
  final int stdId;
  final String name;
  final String regNo;
  final int batchId;
  final int currentSem;
  final String profileImageUrl;

  Student({
    required this.stdId,
    required this.name,
    required this.regNo,
    required this.batchId,
    required this.currentSem,
    required this.profileImageUrl,
  });

  // A helper to create a Student object from JSON data
  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      stdId: json['std_id'] ?? 0,
      name: json['std_name'] ?? 'Unknown',
      regNo: json['reg_no'] ?? '',
      batchId: json['batch_id'] ?? 0,
      currentSem: json['cur_sem'] ?? 1,
      profileImageUrl: "https://dicoman.dist.ac.in/dicoman/std/${json['std_id']}.jpg",
    );
  }
}