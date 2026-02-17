class Task {
  final int _id;
  final String _taskName;

  int get id => _id;

  String get taskName => _taskName;

  Task({required int id, required String taskName})
      : _id = id,
        _taskName = taskName;

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      taskName: json['taskName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'taskName': taskName,
    };
  }
}
