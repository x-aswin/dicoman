class AppNotification {
  final int id;
  final String title;
  final String description;
  final String time;

  AppNotification({
    required this.id,
    required this.title,
    required this.description,
    required this.time,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      time: json['time'],
    );
  }
}