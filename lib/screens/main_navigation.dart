import 'package:flutter/material.dart';
import '../models/student.dart';
import '../models/profile.dart';
// ignore: unused_import
import '../controllers/profile_controller.dart';
import '../controllers/notification.dart';

import 'dashboard.dart';
import 'attendance.dart';
import 'marklist.dart';
import 'profile.dart';
//import '../controllers/profile_controller.dart';
// ignore: duplicate_import
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

  // ignore: unused_field
  ProfileDetails? _profile;   // ✅ Store profile separately

  @override
  void initState() {
    super.initState();

    NotificationController().fetchAllNotifications();
    currentStudent = widget.student;

    _pages = [
      DashboardScreen(
        student: currentStudent,
        onMenuTap: (index) => _onTabTapped(index),
      ),
      AttendanceScreen(student: currentStudent),
      MarklistScreen(student: currentStudent),

      // Initially profile is null
      ProfileScreen(
        student: currentStudent,
        //profile: _profile,
      ),
    ];
  }

  void _onTabTapped(int index) {
  setState(() {
    _currentIndex = index;
  });
}
  // ignore: unused_element
  void _jumpToTab(int index) {
 _onTabTapped(index); // This reuses existing logic
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      body: _pages[_currentIndex],

      bottomNavigationBar: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(40),
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

    final Color selectedColor =
        Theme.of(context).colorScheme.primary;
    final Color unselectedColor =
        Theme.of(context).colorScheme.onSurfaceVariant;
    final Color highlightColor =
        Theme.of(context).colorScheme.primaryContainer.withOpacity(0.4);

    return Expanded(
      child: GestureDetector(
        onTap: () => _onTabTapped(index),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? highlightColor : Colors.transparent,
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