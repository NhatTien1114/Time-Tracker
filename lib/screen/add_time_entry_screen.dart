import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_02/model/time_entry.dart';
import 'package:time_tracker_02/provider/time_entry_provider.dart';
import 'package:time_tracker_02/screen/dialog/add_project_dialog.dart';
import 'package:time_tracker_02/screen/dialog/add_task_dialog.dart';

class AddTimeEntryScreen extends StatefulWidget {
  final TimeEntry? initialTimeEntry;

  const AddTimeEntryScreen({Key? key, this.initialTimeEntry})
    : super(key: key);

  @override
  State<AddTimeEntryScreen> createState() => _AddTimeEntryScreenState();
}

class _AddTimeEntryScreenState extends State<AddTimeEntryScreen> {
  String? _selectedProjectId;
  String? _selectedTaskId;
  DateTime _selectedDate = DateTime.now();
  late TextEditingController _totalTimeController = TextEditingController();
  late TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedProjectId = widget.initialTimeEntry?.projectId;
    _selectedTaskId = widget.initialTimeEntry?.taskId;
    _selectedDate = widget.initialTimeEntry?.date ?? DateTime.now();
    _totalTimeController = TextEditingController(
      text: widget.initialTimeEntry?.totalHours.toString() ?? "",
    );
    _noteController = TextEditingController(
      text: widget.initialTimeEntry?.note ?? "",
    );
  }

  @override
  Widget build(BuildContext context) {
    final timeEntryProvider = Provider.of<TimeEntryProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.initialTimeEntry == null
              ? "Add Time Entry"
              : "Edit Time Entry",
        ),
        backgroundColor: Color(0xFF45907D).withOpacity(0.5),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: buildProjectDropdown(timeEntryProvider),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: buildTaskDropdown(timeEntryProvider),
            ),
            buildDateField(_selectedDate),
            buildTextField(
              _totalTimeController,
              "Total Time",
              TextInputType.numberWithOptions(decimal: true),
            ),
            buildTextField(_noteController, "Note", TextInputType.text),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: _saveTimeEntry,
          child: Text("Save Time Entry"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF45907D),
            foregroundColor: Colors.white,
          ),
        ),
      ),
    );
  }
  
  void _saveTimeEntry() {
    if (_selectedProjectId == null ||
        _selectedTaskId == null ||
        _selectedDate == null ||
        _totalTimeController.text.isEmpty ||
        _noteController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill in all required fields!")));
    }
    final timeEntry = TimeEntry(
        id: widget.initialTimeEntry?.id ?? DateTime.now().millisecondsSinceEpoch,
        projectId: _selectedProjectId!,
        taskId: _selectedTaskId!,
        date: _selectedDate,
        totalHours: double.parse(_totalTimeController.text,
        ),
        note: _noteController.text,
    );
    Provider.of<TimeEntryProvider>(context, listen: false).addTimeEntry(timeEntry);
    Navigator.of(context).pop();
  }

  Widget buildTextField(
    TextEditingController controller,
    String lable,
    TextInputType type,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: lable,
          border: OutlineInputBorder(),
        ),
        keyboardType: type,
      ),
    );
  }

  Widget buildDateField(DateTime selectedDate) {
    return ListTile(
      title: Text("Date ${DateFormat("yyyy-MM-dd").format(selectedDate)}"),
      trailing: Icon(Icons.calendar_today),
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
        );
        if (picked != null && picked != selectedDate) {
          setState(() {
            _selectedDate = picked;
          });
        }
      },
    );
  }

  Widget buildProjectDropdown(TimeEntryProvider provider) {
    return DropdownButtonFormField<String>(
      value: _selectedProjectId,
      onChanged: (newValue) {
        if (newValue == 'New') {
          showDialog(
            context: context,
            builder: (context) => ProjectDialog(
              onAdd: (newProject) {
                setState(() {
                  _selectedProjectId = newProject.id.toString();
                  provider.addProject(newProject);
                });
              },
            ),
          );
        } else {
          setState(() {
            _selectedProjectId = newValue;
          });
        }
      },
      items:
          provider.projects.map<DropdownMenuItem<String>>((project) {
            return DropdownMenuItem<String>(
              value: project.id.toString(),
              child: Text(project.projectName),
            );
          }).toList()..add(
            DropdownMenuItem(value: "New", child: Text("Add New Project")),
          ),
      decoration: InputDecoration(
        labelText: "Project",
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget buildTaskDropdown(TimeEntryProvider provider) {
    return DropdownButtonFormField<String>(
      value: _selectedTaskId,
      onChanged: (newValue) {
        if (newValue == 'New') {
          showDialog(
            context: context,
            builder: (context) => TaskDialog(
              onAdd: (newTask) {
                setState(() {
                  _selectedTaskId = newTask.id.toString();
                  provider.addTask(newTask);
                });
              },
            ),
          );
        } else {
          setState(() {
            _selectedTaskId = newValue;
          });
        }
      },
      items:
          provider.tasks.map<DropdownMenuItem<String>>((task) {
              return DropdownMenuItem<String>(
                value: task.id.toString(),
                child: Text(task.taskName),
              );
            }).toList()
            ..add(DropdownMenuItem(value: "New", child: Text("Add New Task"))),
      decoration: InputDecoration(
        labelText: "Task",
        border: OutlineInputBorder(),
      ),
    );
  }
}
