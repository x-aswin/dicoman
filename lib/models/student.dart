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
  try {
    return Student(
      // int.parse ensures it works even if the JSON is "3452"
      stdId: int.parse(json['std_id'].toString()), 
      name: json['std_name'] ?? 'Unknown',
      regNo: json['reg_no'] ?? '',
      batchId: int.parse(json['batch_id'].toString()),
      currentSem: int.parse(json['cur_sem'].toString()),
      profileImageUrl: "https://cdn-icons-png.flaticon.com/512/219/219970.png",
    );
  } catch (e) {
    print("Error parsing Student JSON: $e");
    rethrow;
  }
}
}