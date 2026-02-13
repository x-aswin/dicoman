import 'package:flutter/material.dart';
import '../models/student.dart';
import '../services/api_service.dart';
import '../models/notification.dart';
import '../controllers/notification.dart'; // Ensure this matches your filename

class DashboardScreen extends StatefulWidget {
  final Student student;

  const DashboardScreen({super.key, required this.student});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final NotificationController _notifController = NotificationController();

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    await _notifController.fetchAllNotifications();
    if (mounted) setState(() {});
  }

  String get greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Stack(
        children: [
          // Background Gradient Header
          Container(
            height: size.height * 0.35,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.alphaBlend(Colors.black.withValues(alpha: 0.8),
                      Theme.of(context).colorScheme.primary),
                  Theme.of(context).colorScheme.scrim,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
          ),
          
          // Background Decorative Icons
          Positioned(
            top: -50,
            right: -50,
            child: Icon(Icons.school_outlined,
                size: 250, color: Colors.white.withOpacity(0.1)),
          ),

          SafeArea(
            child: Column(
              children: [
                SizedBox(height: size.height * 0.05),
                
                // Student Profile Header
                _buildHeader(),

                const SizedBox(height: 40),

                // White Content Sheet
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      children: [
                        // Drag Handle
                        Container(
                          width: 40,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),

                        // Notification Section Title
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "What's up DiST",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // THE NOTIFICATION SECTION
                        _buildNotificationSection(),

                        const SizedBox(height: 24),

                        // MENU GRID
                        _buildMenuGrid(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- UI COMPONENTS ---

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
            ),
            child: CircleAvatar(
              radius: 35,
              backgroundImage: NetworkImage(widget.student.profileImageUrl),
              onBackgroundImageError: (_, __) {},
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(greeting,
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.9),
                        letterSpacing: 1.1)),
                Text(widget.student.name,
                    style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.2),
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationSection() {
    if (_notifController.isLoading && _notifController.notifications.isEmpty) {
      return const SizedBox(
          height: 250, child: Center(child: CircularProgressIndicator()));
    }

    if (_notifController.notifications.isEmpty) {
      return const SizedBox(
          height: 100, child: Center(child: Text("No new updates")));
    }

    return SizedBox(
      height: 250, // Fixed height for vertical scroll within the sheet
      child: ListView.builder(
        padding: EdgeInsets.zero,
        physics: const BouncingScrollPhysics(),
        itemCount: _notifController.notifications.length,
        itemBuilder: (context, index) {
          return _buildNotificationCard(_notifController.notifications[index]);
        },
      ),
    );
  }

  Widget _buildNotificationCard(AppNotification note) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.notifications_active_outlined,
              color: Theme.of(context).colorScheme.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(note.title,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(note.time,
                        style: TextStyle(
                            fontSize: 11,
                            color: Theme.of(context).colorScheme.primary)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(note.description,
                    style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).colorScheme.onSurfaceVariant),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuGrid() {
    return Expanded(
      child: GridView.count(
        padding: EdgeInsets.zero,
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          _buildMenuCard(context, Icons.calendar_today, "Timetable", Colors.blue),
          _buildMenuCard(context, Icons.book, "Marks", Colors.orange),
          _buildMenuCard(context, Icons.people, "Attendance", Colors.purple),
          _buildMenuCard(context, Icons.notifications, "Notices", Colors.red),
        ],
      ),
    );
  }

Widget _buildMenuCard(BuildContext context, IconData icon, String title, Color color) {
  return Container(
    decoration: BoxDecoration(
      // A very subtle surface color
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(24),
      border: Border.all(
        color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5),
        width: 1,
      ),
      // Subtle "soft" shadow for depth
      boxShadow: [
        BoxShadow(
          color: color.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Stack(
        children: [
          // A decorative faint circle in the corner for flair
          Positioned(
            right: -10,
            top: -10,
            child: CircleAvatar(
              radius: 30,
              backgroundColor: color.withOpacity(0.03),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Left aligned looks more modern
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Icon Container
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    icon, 
                    color: color, 
                    size: 24, // Smaller icons look more "Pro"
                  ),
                ),
                // Text Label
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                        letterSpacing: -0.5,
                      ),
                    ),
                    Text(
                      "View details", // Subtitle makes it feel like a real portal
                      style: TextStyle(
                        fontSize: 11,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
}