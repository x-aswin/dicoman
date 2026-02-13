import 'package:flutter/material.dart';
import '../models/student.dart';
import '../models/profile.dart';
import '../controllers/profile_controller.dart';

class ProfileScreen extends StatefulWidget {
  final Student student;

  const ProfileScreen({super.key, required this.student});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int selectedTab = 0;
  final List<String> tabs = ["Basic", "Parents", "Contact", "Education"];

  final ProfileController _controller = ProfileController();
  ProfileDetails? profile;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      await _controller.fetchProfile(widget.student.stdId);
      setState(() {
        profile = _controller.profile;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        profile = null;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // 🔄 Loading State
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // ❌ Error / Null State
    if (profile == null) {
      return const Scaffold(
        body: Center(child: Text("Failed to load profile")),
      );
    }

    // ✅ Safe to use profile!
    final basic = profile!.basic;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: CustomScrollView(
        slivers: [
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
                        backgroundImage: NetworkImage(
                          basic.imageUrl.isNotEmpty
                              ? basic.imageUrl
                              : widget.student.profileImageUrl,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      basic.fullName,
                      style: TextStyle(
                        color: colorScheme.onPrimaryContainer,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.student.regNo,
                      style: TextStyle(
                        color: colorScheme.onPrimaryContainer.withOpacity(0.7),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Badge(
                      label: Text("Semester ${widget.student.currentSem}"),
                      backgroundColor: colorScheme.primary,
                      textColor: colorScheme.onPrimary,
                    ),
                  ],
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
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

          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverToBoxAdapter(
              child: Card(
                elevation: 0,
                color: colorScheme.surfaceContainerLow,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
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
        return _parentInfo();
      case 2:
        return _contactInfo();
      default:
        return const SizedBox();
    }
  }

  Widget _basicInfo() {
    final basic = profile!.basic;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _infoTile(Icons.person_outline, "Full Name", basic.fullName),
        _infoTile(Icons.badge_outlined, "Admission No", basic.admissionNo),
        _infoTile(Icons.school_outlined, "Batch", basic.batch),
        _infoTile(Icons.class_, "Semester", basic.semester),
        _infoTile(Icons.flag_outlined, "Nationality", basic.nationality),
      ],
    );
  }

  Widget _parentInfo() {
    final parent = profile!.parent;

    return Column(
      children: [
        _infoTile(Icons.man, "Father", parent.fatherName),
        _infoTile(Icons.work_outline, "Occupation", parent.fatherOccupation),
        const Divider(),
        _infoTile(Icons.woman, "Mother", parent.motherName),
        _infoTile(Icons.work_outline, "Occupation", parent.motherOccupation),
      ],
    );
  }

  Widget _contactInfo() {
    final contact = profile!.contact;

    return Column(
      children: [
        _infoTile(Icons.email_outlined, "Email 1", contact.email1),
        _infoTile(Icons.phone_outlined, "Mobile", contact.mobile),
        _infoTile(Icons.home_outlined, "Address", contact.permanentAddress),
      ],
    );
  }

  Widget _infoTile(IconData icon, String label, String value) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: colorScheme.primary),
      title: Text(label),
      subtitle: Text(
        value,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}