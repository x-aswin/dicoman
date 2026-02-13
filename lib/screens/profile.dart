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
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          // 🔹 M3 Styled Sliver App Bar
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: colorScheme.primary,
                      child: CircleAvatar(
                        radius: 47,
                        backgroundImage: NetworkImage(widget.student.profileImageUrl),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.student.name,
                      style: TextStyle(
                        color: colorScheme.onPrimaryContainer,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.student.regNo,
                      style: TextStyle(
                        color: colorScheme.onPrimaryContainer.withValues(alpha: 0.7),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Badge(
                      label: Text("Semester ${widget.student.currentSem}"),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      largeSize: 24,
                      backgroundColor: colorScheme.primary,
                      textColor: colorScheme.onPrimary,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 🔹 M3 Segmented Tabs
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SegmentedButton<int>(
                  segments: List.generate(tabs.length, (index) {
                    return ButtonSegment<int>(
                      value: index,
                      label: Text(tabs[index]),
                    );
                  }),
                  selected: {selectedTab},
                  onSelectionChanged: (newSelection) {
                    setState(() {
                      selectedTab = newSelection.first;
                    });
                  },
                  showSelectedIcon: false,
                ),
              ),
            ),
          ),

          // 🔹 Content Section
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverToBoxAdapter(
              child: Card(
                elevation: 0,
                color: colorScheme.surfaceContainerLow,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                  side: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: _buildTabContent(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    switch (selectedTab) {
      case 0:
        return _basicInfo();
      case 1:
        return _placeholderInfo("Parents Info", Icons.family_restroom);
      case 2:
        return _placeholderInfo("Contact Info", Icons.contact_phone);
      case 3:
        return _placeholderInfo("Education Info", Icons.history_edu);
      default:
        return const SizedBox();
    }
  }

  Widget _basicInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Basic Details",
          style: TextStyle(
            fontSize: 18, 
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 16),
        _infoTile(Icons.person_outline, "Full Name", widget.student.name),
        _infoTile(Icons.badge_outlined, "Registration Number", widget.student.regNo),
        _infoTile(Icons.groups_outlined, "Batch Reference", widget.student.batchId.toString()),
        _infoTile(Icons.school_outlined, "Academic Stage", "Semester ${widget.student.currentSem}"),
      ],
    );
  }

  Widget _infoTile(IconData icon, String label, String value) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: colorScheme.primary, size: 20),
      ),
      title: Text(
        label,
        style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _placeholderInfo(String title, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 48, color: Theme.of(context).colorScheme.outline),
        const SizedBox(height: 12),
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const Text("Information will be fetched from DiCoMan servers."),
      ],
    );
  }
}