import 'package:flutter/material.dart';
import '../models/student.dart';
import '../controllers/profile_controller.dart';
import 'dashboard.dart';
import 'attendance.dart';
import 'marklist.dart';
import 'profile.dart';
import '../controllers/profile_controller.dart';

class MainNavigation extends StatefulWidget {
  final Student student;
  const MainNavigation({super.key, required this.student});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  late List<Widget> _pages;
  late Student currentStudent;

  @override
  void initState() {
    super.initState();
    currentStudent = widget.student;

    _pages = [
      DashboardScreen(student: currentStudent),
      AttendanceScreen(student: currentStudent),
      MarklistScreen(student: currentStudent),
      ProfileScreen(student: currentStudent),
    ];
  }

  Future<void> _onTabTapped(int index) async {
    if (index == 3) {
      // ✅ Profile tab clicked → call controller
      final controller = profileController();
      final updatedStudent =
          await controller.fetchStudentProfile(currentStudent.stdId);

      setState(() {
        currentStudent = updatedStudent;
        _pages[3] = ProfileScreen(student: currentStudent);
        _currentIndex = index;
      });
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true, // ✅ transparency behind navbar
      body: _pages[_currentIndex],

      bottomNavigationBar: SafeArea(
        child: Container(
          height: 63,
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 12,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Row(
            children: [
              _navItem(Icons.home, "Home", 0),
              _navItem(Icons.checklist, "Attendance", 1),
              _navItem(Icons.bar_chart, "Marklist", 2),
              _navItem(Icons.person, "Profile", 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int index) {
    bool isSelected = _currentIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => _onTabTapped(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 2),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).colorScheme.secondary.withOpacity(0.25)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(32),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.green : Colors.grey,
                size: 20,
              ),
              const SizedBox(height: 3),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.green : Colors.grey,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
