import 'package:flutter/material.dart';
import '../models/attendance.dart';
import '../controllers/attendance.dart';
import '../models/student.dart';

class AttendanceScreen extends StatefulWidget {
  final Student student;
  const AttendanceScreen({super.key, required this.student});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final AttendanceController _controller = AttendanceController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _controller.init();
    if (mounted) setState(() {});
  }

  // Improved date: "2025-10-06" -> "Oct 06, 2025 (Mon)"
  String _formatDate(String rawDate) {
    try {
      DateTime dt = DateTime.parse(rawDate);
      List<String> months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return "${months[dt.month - 1]} ${dt.day.toString().padLeft(2, '0')}, ${dt.year} (${days[dt.weekday - 1]})";
    } catch (e) {
      return rawDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Attendance Logs", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: _controller.isLoading && _controller.semesters.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildSummarySection(colorScheme),
                _buildModernDropdown(colorScheme), // New Styled Dropdown
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Align(
                    alignment: Alignment.centerLeft, 
                    child: Text("Recent Logs", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))
                  ),
                ),
                Expanded(
                  child: _controller.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _buildAttendanceList(colorScheme),
                ),
              ],
            ),
    );
  }

  // Modern Styled Dropdown
  Widget _buildModernDropdown(ColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [colorScheme.primary.withValues(alpha: 0.1), colorScheme.primary.withValues(alpha: 0.02)]),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.2)),
      ),
      child: ListTile(
        dense: true,
        leading: Icon(Icons.school_outlined, color: colorScheme.primary),
        title: Text(
          _controller.selectedSemester?.name ?? "Select Semester",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: Icon(Icons.swap_vert_rounded, color: colorScheme.primary),
        onTap: () => _showSemesterPicker(context),
      ),
    );
  }

  // Bottom Sheet Picker instead of a floating menu
  void _showSemesterPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Select Semester", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              ..._controller.semesters.map((sem) => ListTile(
                title: Text(sem.name, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w500)),
                selected: _controller.selectedSemester == sem,
                selectedTileColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                onTap: () async {
  //Update the selected semester in the controller
  _controller.updateSemester(sem);
  
  //Close the bottom sheet immediately
  Navigator.pop(context);
  
  //Trigger a rebuild to show the loading spinner
  setState(() {}); 

  //AWAIT the actual data fetching
  await _controller.fetchAttendanceForSelected();
  
  //Trigger another rebuild to hide the spinner and show the data
  if (mounted) {
    setState(() {});
  }
},
              )),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSummarySection(ColorScheme colorScheme) {
    int total = _controller.records.length;
    int present = _controller.records.where((r) => r.status == "P").length;
    double percentage = total > 0 ? (present / total) * 100 : 0.0;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          _buildStatCard("Attendance", "${percentage.toStringAsFixed(1)}%", Icons.offline_pin_rounded, Colors.teal, colorScheme),
          const SizedBox(width: 15),
          _buildStatCard("Total Days", "$total", Icons.event_available_rounded, Colors.indigo, colorScheme),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color accent, ColorScheme colorScheme) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.4)),
          boxShadow: [BoxShadow(color: accent.withValues(alpha: 0.05), blurRadius: 15, offset: const Offset(0, 8))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: accent, size: 28),
            const SizedBox(height: 12),
            Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: -1)),
            Text(title, style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceList(ColorScheme colorScheme) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: _controller.records.length,
      itemBuilder: (context, index) {
        final record = _controller.records[index];
        bool isPresent = record.status == "P";

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.3)),
          ),
          child: ExpansionTile(
            leading: _buildStatusIcon(isPresent),
            title: Text(_formatDate(record.date), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            subtitle: Text(isPresent ? "Marked Present" : "Marked Absent", 
              style: TextStyle(color: isPresent ? Colors.teal : Colors.redAccent, fontSize: 12, fontWeight: FontWeight.w500)),
            children: record.periods.entries.map((p) => _buildPeriodTile(p.key, p.value, colorScheme)).toList(),
          ),
        );
      },
    );
  }

  Widget _buildStatusIcon(bool isPresent) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isPresent ? Colors.teal.withValues(alpha: 0.1) : Colors.red.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        isPresent ? Icons.done_all_rounded : Icons.close_rounded, // Ticks and Crosses
        color: isPresent ? Colors.teal : Colors.redAccent,
        size: 20,
      ),
    );
  }

  Widget _buildPeriodTile(String label, PeriodInfo info, ColorScheme colorScheme) {
    bool pPresent = info.status == 0;
    return ListTile(
      dense: true,
      leading: Container(
        width: 28, height: 28,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: colorScheme.primary.withValues(alpha: 0.1), shape: BoxShape.circle),
        child: Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: colorScheme.primary)),
      ),
      title: Text(info.subject, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
      subtitle: Text(info.staff, style: const TextStyle(fontSize: 11)),
      trailing: Icon(
        pPresent ? Icons.check_rounded : Icons.close_rounded, // Ticks and Crosses in detail
        size: 18, 
        color: pPresent ? Colors.teal : Colors.redAccent
      ),
    );
  }
}