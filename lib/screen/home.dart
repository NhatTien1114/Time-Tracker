import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_02/model/project.dart';
import 'package:time_tracker_02/model/task.dart';
import 'package:time_tracker_02/model/time_entry.dart';
import 'package:time_tracker_02/provider/time_entry_provider.dart';
import 'package:time_tracker_02/screen/add_time_entry_screen.dart';
import 'package:collection/collection.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Time Tracker"),
        backgroundColor: Color(0xFF45907D),
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(text: "All Entries"),
            Tab(text: "Grouped by Projects"),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFF45907D)),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.folder, color: Color(0xFF45907D)),
              title: Text("Project"),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/manage_projects');
              },
            ),
            ListTile(
              leading: Icon(Icons.task, color: Color(0xFF45907D)),
              title: Text("Task"),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/manage_tasks');
              },
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [AllEntriesScreen(context), GroupedByProjectsScreen(context)],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF45907D),
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTimeEntryScreen()),
          );
        },
        tooltip: "Add Time Entry",
      ),
    );
  }

  Widget AllEntriesScreen(BuildContext context) {
    return Consumer<TimeEntryProvider>(
      builder: (context, provider, child) {
        if (provider.timeEntries.isEmpty) {
          return Center(
            child: Text(
              "Click the + button to record time entries.",
              style: TextStyle(color: Colors.grey[600], fontSize: 18),
            ),
          );
        }
        return ListView.builder(
          itemCount: provider.timeEntries.length,
          itemBuilder: (context, index) {
            var timeEntry = provider.timeEntries[index];
            final currencyFormat = NumberFormat.currency(
              locale: 'vi_VN',
              symbol: 'đ',
            );
            String formattedDate = DateFormat(
              'MMM dd, yyyy',
            ).format(timeEntry.date);
            return Dismissible(
              key: ValueKey(timeEntry.id),
              direction: DismissDirection.endToStart,
              background: Container(
                color: Colors.red,
                padding: EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.centerRight,
                child: Icon(Icons.delete, color: Colors.white),
              ),
              onDismissed: (direction) {
                provider.deleteTimeEntry(timeEntry.id);
              },
              child: Card(
                color: Colors.purple[50],
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                child: ListTile(
                  title: Text("${timeEntry.projectId} - ${timeEntry.taskId}"),
                  subtitle: Text(
                    "Total Time: ${timeEntry.totalHours} hours\nDate: $formattedDate\nNote: ${timeEntry.note}",
                  ),
                  isThreeLine: true,
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget GroupedByProjectsScreen(BuildContext context) {
    return Consumer<TimeEntryProvider>(
      builder: (context, provider, child) {
        if (provider.timeEntries.isEmpty) {
          return Center(
            child: Text(
              "Click the + button to record time entries.",
              style: TextStyle(color: Colors.grey[600], fontSize: 18),
            ),
          );
        }

        // Nhóm các TimeEntry theo projectId
        var grouped = groupBy(
          provider.timeEntries,
          (TimeEntry e) => e.projectId,
        );
        var projectIds = grouped.keys.toList();

        return ListView.builder(
          itemCount: projectIds.length,
          itemBuilder: (context, index) {
            int projectId = projectIds[index] as int;
            List<TimeEntry> entries = grouped[projectId]!;

            // Tính tổng số giờ cho project này
            double totalHours = entries.fold(
              0,
              (sum, item) => sum + item.totalHours,
            );

            // Tìm tên project từ danh sách projects trong provider (nếu có)
            String projectName = provider.projects
                .firstWhere(
                  (p) => p.id == projectId,
                  orElse: () =>
                      Project(id: projectId, projectName: "Unknown Project"),
                )
                .projectName;

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: ExpansionTile(
                leading: CircleAvatar(
                  backgroundColor: const Color(0xFF45907D),
                  child: Text(
                    entries.length.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(
                  projectName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text("Total: $totalHours hours"),
                children: entries.map((entry) {
                  // Tìm tên task
                  String taskName = provider.tasks
                      .firstWhere(
                        (t) => t.id == entry.taskId,
                        orElse: () => Task(
                          id: entry.taskId as int,
                          taskName: "Unknown Task",
                        ),
                      )
                      .taskName;

                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                    title: Text(taskName),
                    subtitle: Text(
                      DateFormat('MMM dd, yyyy').format(entry.date),
                    ),
                    trailing: Text(
                      "${entry.totalHours}h",
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  );
                }).toList(),
              ),
            );
          },
        );
      },
    );
  }
}
