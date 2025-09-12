class WorkoutsModel {
  final String id;
  final String userId;
  final String name;
  final String duration;
  final String status;
  final DateTime dateAdded;

  WorkoutsModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.duration,
    required this.status,
    required this.dateAdded,
  });

  factory WorkoutsModel.fromJson(Map<String, dynamic> json) {
    return WorkoutsModel(
      id: json['_id'],
      userId: json['userId'],
      name: json['name'],
      duration: json['duration'],
      status: json['status'],
      dateAdded: DateTime.parse(json['dateAdded']),
    );
  }
}
