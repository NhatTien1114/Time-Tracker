import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_02/model/task.dart';
import 'package:time_tracker_02/provider/time_entry_provider.dart';

class TaskDialog extends StatefulWidget {
  final Function(Task) onAdd;
  const TaskDialog({required this.onAdd});

  @override
  State<TaskDialog> createState() => _TaskDialogState();
}

class _TaskDialogState extends State<TaskDialog> {
  final TextEditingController _nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Add Task"),
      content: TextFormField(
        controller: _nameController,
        decoration: InputDecoration(
          labelText: "Add Task"
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: Text("Cancel")),
        TextButton(
            onPressed: () {
              var task = Task(
                id: DateTime.now().millisecondsSinceEpoch,
                taskName: _nameController.text
              );
              widget.onAdd;
              Provider.of<TimeEntryProvider>(context, listen: false).addOrUpdateTask(task);
              _nameController.clear();
              Navigator.of(context).pop();
            },
            child: Text("Add")
        )
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    // TODO: implement dispose
    super.dispose();
  }
}
