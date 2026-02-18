import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_02/provider/time_entry_provider.dart';
import 'package:time_tracker_02/screen/dialog/add_task_dialog.dart';

class TaskManagementScreen extends StatelessWidget {
  const TaskManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Task Management"),
          backgroundColor: Color(0xFF45907D),
          foregroundColor: Colors.white,
        ),
        body: Consumer<TimeEntryProvider>(
          builder: (context, provider, child) {
            return ListView.builder(
                itemCount: provider.tasks.length,
                itemBuilder: (context, index) {
                  var task = provider.tasks[index];
                  return Dismissible(
                    key: ValueKey(task.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 20),
                      child: Icon(Icons.delete),
                    ),
                    onDismissed: (direction) {
                      provider.deleteTask(task.id);
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text("Task deleted")));
                    },
                    child: ListTile(
                      title: Text(task.taskName),
                      trailing: Icon(Icons.delete),
                      onTap: () => provider.deleteTask(task.id),
                    )
                  );
                },
            );
          },
        ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          tooltip: "Add Task",
          onPressed: () => showDialog(
              context: context,
              builder: (context) => TaskDialog(onAdd: (task) {

              },),
          )
      ),
    );
  }
}
