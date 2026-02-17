import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_tracker_02/model/project.dart';
import 'package:time_tracker_02/model/task.dart';
import 'package:time_tracker_02/model/time_entry.dart';

class TimeEntryProvider with ChangeNotifier{
  late SharedPreferences prefs;
  List<TimeEntry> _timeEntries = [];
  final List<Project> _projects = [
    Project(id: 1, projectName: 'Ticket Booking at Counter'),
    Project(id: 2, projectName: 'Mini Apartment Management'),
  ];
  final List<Task> _tasks = [
    Task(id: 1, taskName: 'Design'),
    Task(id: 2, taskName: 'Development'),
    Task(id: 3, taskName: 'Testing'),
    Task(id: 4, taskName: 'Deployment'),
    Task(id: 5, taskName: 'Maintenance'),
    Task(id: 6, taskName: 'Documentation'),
  ];

  List<TimeEntry> get timeEntries => _timeEntries;
  List<Project> get projects => _projects;
  List<Task> get tasks => _tasks;

  TimeEntryProvider(this.prefs) {
    _loadTimeEntriesFromStorage();
  }

  void _loadTimeEntriesFromStorage() {
    final String? timeEntriesJson = prefs.getString("timeEntries");
    if (timeEntriesJson != null) {
      _timeEntries = (jsonDecode(timeEntriesJson) as List).map((entry) => TimeEntry.fromJson(entry)).toList();
    }
    notifyListeners();
  }

  void _saveTimeEntriesToStorage() async {
    final timeEntriesJson = jsonEncode(_timeEntries.map((entry) => entry.toJson()).toList());
    await prefs.setString('timeEntries', timeEntriesJson);
  }

  void addTimeEntry(TimeEntry timeEntry) {
    _timeEntries.add(timeEntry);
    _saveTimeEntriesToStorage();
    notifyListeners();
  }

  void addOrUpdateTimeEntry(TimeEntry timeEntry) {
    int index = _timeEntries.indexWhere((e) => e.id == timeEntry.id);
    if (index != -1) {
      _timeEntries[index] = timeEntry;
    } else {
      _timeEntries.add(timeEntry);
    }
    _saveTimeEntriesToStorage();
    notifyListeners();
  }

  void deleteTimeEntry(int id) {
    _timeEntries.removeWhere((entry) => entry.id == id);
    _saveTimeEntriesToStorage();
    notifyListeners();
  }

  void addProject (Project project) {
    _projects.add(project);
    notifyListeners();
  }

  void addOrUpdateProject(Project project) {
    int index = _projects.indexWhere((e) => e.id == project.id);
    if (index != -1) {
      _projects[index] = project;
    } else {
      _projects.add(project);
    }
    _saveTimeEntriesToStorage();
    notifyListeners();
  }

  void deleteProject(int id) {
    _projects.removeWhere((entry) => entry.id == id);
    _saveTimeEntriesToStorage();
    notifyListeners();
  }

  void addTask (Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  void addOrUpdateTask(Task task) {
    int index = _tasks.indexWhere((e) => e.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
    } else {
      _tasks.add(task);
    }
    _saveTimeEntriesToStorage();
    notifyListeners();
  }

  void deleteTask(int id) {
    _tasks.removeWhere((entry) => entry.id == id);
    _saveTimeEntriesToStorage();
    notifyListeners();
  }

}