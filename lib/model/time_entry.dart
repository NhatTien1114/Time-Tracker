class TimeEntry {
  final int _id;
  final String _projectId;
  final String _taskId;
  final DateTime _date;
  final double _totalHours;
  final String _note;

  int get id => _id;

  String get projectId => _projectId;

  String get taskId => _taskId;

  DateTime get date => _date;

  double get totalHours => _totalHours;

  String get note => _note;

  TimeEntry({
    required int id,
    required String projectId,
    required String taskId,
    required DateTime date,
    required double totalHours,
    required String note,
  }) : _id = id,
        _projectId = projectId,
       _taskId = taskId,
       _date = date,
       _totalHours = totalHours,
       _note = note;

  factory TimeEntry.fromJson(Map<String, dynamic> json) {
    return TimeEntry(
      id: json['id'],
      projectId: json['projectId'],
      taskId: json['taskId'],
      date: DateTime.parse(json['date']),
      totalHours: json['totalHours'],
      note: json['note'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'projectId': _projectId,
      'taskId': _taskId,
      'date': _date.toIso8601String(),
      'totalHours': _totalHours,
      'note': _note,
    };
  }
}
