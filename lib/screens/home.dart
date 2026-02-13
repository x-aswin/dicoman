import 'package:flutter/material.dart';
import '../models/student.dart';
import '../controllers/profile_controller.dart';
import 'dashboard.dart';
import 'attendance.dart';
import 'marklist.dart';
import 'profile.dart';
import '../controllers/profile_controller.dart';
import '../controllers/notification.dart';

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
    NotificationController().fetchAllNotifications();
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

      // --- In your build method ---
bottomNavigationBar: SafeArea(
  child: Container(
    // height: 63, <-- REMOVE THIS to stop the overflow
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8), // Padding defines height now
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceContainer,
      borderRadius: BorderRadius.circular(40), // Main bar arc
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 15,
          offset: const Offset(0, 5),
        )
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
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

  final Color selectedColor = Theme.of(context).colorScheme.primary; // Or .secondary
  final Color unselectedColor = Theme.of(context).colorScheme.onSurfaceVariant;
  final Color highlightColor = Theme.of(context).colorScheme.primaryContainer.withOpacity(0.4);

  return Expanded(
    child: GestureDetector(
      onTap: () => _onTabTapped(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        // Vertical padding here creates the "pill" height
        padding: const EdgeInsets.symmetric(vertical: 10), 
        decoration: BoxDecoration(
          color: isSelected ? highlightColor : Colors.transparent,
          // Use 100 to perfectly match the outer bar's roundness
          borderRadius: BorderRadius.circular(100), 
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? selectedColor : unselectedColor,
              size: 22,
            ),
            if(true) //if (isSelected) Optional: Only show text for selected item to save space
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? selectedColor : unselectedColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    ),
  );
}
}
