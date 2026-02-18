import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_02/model/project.dart';
import 'package:time_tracker_02/provider/time_entry_provider.dart';

class ProjectDialog extends StatefulWidget {
  final Function(Project) onAdd;
  const ProjectDialog({required this.onAdd});

  @override
  State<ProjectDialog> createState() => _ProjectDialogState();
}

class _ProjectDialogState extends State<ProjectDialog> {
  final TextEditingController _nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Add Project"),
      content: TextFormField(
        controller: _nameController,
        decoration: InputDecoration(
          labelText: "Project Name"
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancel")
        ),
        TextButton(
            onPressed: () {
              var project = Project(
                id: DateTime.now().millisecondsSinceEpoch,
                projectName: _nameController.text,
              );
              widget.onAdd(project);
              Provider.of<TimeEntryProvider>(context, listen: false).addOrUpdateProject(project);
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
