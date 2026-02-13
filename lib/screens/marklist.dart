import 'package:flutter/material.dart';
import '../controllers/mark_controller.dart';
import '../models/mark.dart';
import '../models/student.dart';
import '../models/attendance.dart';

class MarklistScreen extends StatefulWidget {
  final Student student;

  const MarklistScreen({super.key, required this.student});

  @override
  State<MarklistScreen> createState() => _MarklistScreenState();
}

class _MarklistScreenState extends State<MarklistScreen> {
  final MarkController _controller = MarkController();

  String? selectedSemester;
  String? selectedExam;

  bool isFilterLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFilters();
  }

  Future<void> _loadFilters() async {
    await _controller.loadFilters(widget.student.stdId);

    setState(() {
      isFilterLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text("Mark List")),
      body: isFilterLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // 🔽 FILTER CARD
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          /// 🔹 SEMESTER DROPDOWN (FROM AttendanceService)
                          DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                                labelText: "Semester"),
                            value: selectedSemester,
                            items: _controller.semesters
                                .map((Semester sem) =>
                                    DropdownMenuItem<String>(
                                      value: sem.name,
                                      child:
                                          Text(sem.name),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedSemester = value;
                              });
                            },
                          ),

                          const SizedBox(height: 16),

                          /// 🔹 EXAM DROPDOWN (FROM MarkService)
                          DropdownButtonFormField<String>(
                            decoration:
                                const InputDecoration(labelText: "Exam"),
                            value: selectedExam,
                            items: _controller.exams
                                .map((exam) =>
                                    DropdownMenuItem<String>(
                                      value: exam,
                                      child: Text(exam),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedExam = value;
                              });
                            },
                          ),

                          const SizedBox(height: 20),

                          ElevatedButton.icon(
                            icon: const Icon(Icons.search),
                            label: const Text("Search"),
                            onPressed: _searchMarks,
                          )
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  if (_controller.isLoading)
                    const CircularProgressIndicator(),

                  if (!_controller.isLoading &&
                      _controller.marks.isNotEmpty) ...[
                    _buildSummaryCard(colorScheme),
                    const SizedBox(height: 16),
                    ..._controller.marks.map(
                        (mark) => _buildSubjectCard(mark, colorScheme))
                  ],

                  if (!_controller.isLoading &&
                      _controller.marks.isEmpty &&
                      selectedSemester != null &&
                      selectedExam != null)
                    const Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Text("No Marks Available"),
                    )
                ],
              ),
            ),
    );
  }

  void _searchMarks() async {
    if (selectedSemester == null || selectedExam == null) return;

    setState(() {
      _controller.isLoading = true;
    });

    await _controller.fetchMarks(
        widget.student.stdId, selectedSemester!, selectedExam!);

    setState(() {});
  }

  Widget _buildSummaryCard(ColorScheme colorScheme) {
    double totalPercentage = _controller.marks
            .map((e) => e.percentage)
            .reduce((a, b) => a + b) /
        _controller.marks.length;

    return Card(
      color: colorScheme.primaryContainer,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text("Overall Percentage",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onPrimaryContainer)),
            const SizedBox(height: 8),
            Text("${totalPercentage.toStringAsFixed(1)}%",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary)),
          ],
        ),
      ),
    );
  }

  Widget _buildSubjectCard(
      SubjectMark mark, ColorScheme colorScheme) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(mark.subjectName,
                style:
                    const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                Text("Mark: ${mark.mark}/${mark.maxMark}"),
                Text("${mark.percentage.toStringAsFixed(1)}%"),
              ],
            ),
            const SizedBox(height: 6),
            LinearProgressIndicator(
              value: mark.mark / mark.maxMark,
            ),
            const SizedBox(height: 6),
            Text("Status: ${mark.status}",
                style: TextStyle(
                    color: mark.status == "P"
                        ? Colors.green
                        : Colors.red)),
          ],
        ),
      ),
    );
  }
}