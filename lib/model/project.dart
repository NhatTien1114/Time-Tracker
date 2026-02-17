class Project {
  final int _id;
  final String _projectName;

  int get id => _id;

  String get projectName => _projectName;

  Project({required int id, required String projectName})
    : _id = id,
      _projectName = projectName;

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'],
      projectName: json['projectName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'projectName': projectName,
    };
  }
}
