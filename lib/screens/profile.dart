import 'package:flutter/material.dart';
import '../models/student.dart';

class ProfileScreen extends StatefulWidget {
  final Student student;

  const ProfileScreen({super.key, required this.student});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int selectedTab = 0;

  final List<String> tabs = ["Basic", "Parents", "Contact", "Education"];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 🔹 Header Section
            Container(
              height: size.height * 0.32,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1E4F8A), Color(0xFF2E6FB7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(widget.student.profileImageUrl),
                    backgroundColor:  Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.5),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.student.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.student.regNo,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                   const SizedBox(height: 4),
                  Text(
                    widget.student.regNo,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "Semester ${widget.student.currentSem}",
                      style: const TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 12),

            // 🔹 Tabs Section
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(tabs.length, (index) {
                  final isSelected = selectedTab == index;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedTab = index;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        tabs[index],
                        style: TextStyle(
                          color: isSelected ? Theme.of(context).colorScheme.primary.withOpacity(0.5) : Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.5),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(height: 12),

            // 🔹 Content Card (Basic Info Example)
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: _buildTabContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (selectedTab) {
      case 0:
        return _basicInfo();
      case 1:
        return const Text("Parents Info (Coming Soon)");
      case 2:
        return const Text("Contact Info (Coming Soon)");
      case 3:
        return const Text("Education Info (Coming Soon)");
      default:
        return const SizedBox();
    }
  }

  Widget _basicInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Basic Details",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        _infoRow(Icons.person, "Name", widget.student.name),
        _infoRow(Icons.confirmation_number, "Register No", widget.student.regNo),
        _infoRow(Icons.school, "Batch ID", widget.student.batchId.toString()),
        _infoRow(Icons.timeline, "Current Semester",
            widget.student.currentSem.toString()),
      ],
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue, size: 20),
          const SizedBox(width: 10),
          Text(
            "$label: ",
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.5)),
            ),
          ),
        ],
      ),
    );
  }
}
