import 'package:flutter/material.dart';
import '../models/student.dart';

class AttendanceScreen extends StatelessWidget {
  final Student student;

  const AttendanceScreen({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    // We get the screen size to calculate percentages
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Stack(
        children: [
          Container(
           
    ) 
        ]
      ),
    );  
  }
}