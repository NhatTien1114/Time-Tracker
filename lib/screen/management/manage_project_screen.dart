import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_02/provider/time_entry_provider.dart';
import 'package:time_tracker_02/screen/dialog/add_project_dialog.dart';

class ProjectManagementScreen extends StatelessWidget {
  const ProjectManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Project Management"),
          backgroundColor: Color(0xFF45907D),
          foregroundColor: Colors.white,
        ),
        body: Consumer<TimeEntryProvider>(
          builder: (context, provider, child) {
            return ListView.builder(
              itemCount: provider.projects.length,
              itemBuilder: (context, index) {
                var project = provider.projects[index];
                return Dismissible(
                  key: ValueKey(project.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 20),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    provider.deleteProject(project.id);
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text("Project deleted")));
                  },
                  child: ListTile(
                    title: Text(project.projectName),
                    trailing: Icon(Icons.delete),
                    onTap: () => provider.deleteProject(project.id),
                  ),
                );
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => showDialog(
            context: context,
            builder: (context) => ProjectDialog(
              onAdd: (project) {

              },
            ),
          ),
            child: Icon(Icons.add),
            tooltip: "Add Project",
        )
    );
  }
}
