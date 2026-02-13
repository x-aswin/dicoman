import 'package:flutter/material.dart';
import '../models/student.dart';
import '../services/api_service.dart';
import '../models/notification.dart';
import '../controllers/notification.dart';

class DashboardScreen extends StatefulWidget {
  final Student student;
  final Function(int) onMenuTap;

  const DashboardScreen({
    super.key, 
    required this.student, 
    required this.onMenuTap, 
  });

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

  // --- POPUP HELPER ---
  void _showUnavailablePop(BuildContext context, String title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text("$title Not Available"),
        content: Text("The $title feature is currently under development. Please check back later!"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
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
    final colorScheme = Theme.of(context).colorScheme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Stack(
        children: [
          Container(
            height: size.height * 0.35,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDarkMode 
                  ? [
                      Color.alphaBlend(Colors.black.withValues(alpha: 0.8), colorScheme.primary),
                      colorScheme.scrim,
                    ]
                  : [
                      colorScheme.primary,
                      colorScheme.primary.withValues(alpha: 0.7),
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
          
          Positioned(
            top: -50,
            right: -50,
            child: Icon(
              Icons.school_outlined,
              size: 250, 
              color: Colors.white.withValues(alpha: 0.1),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                SizedBox(height: size.height * 0.05),
                _buildHeader(colorScheme),
                const SizedBox(height: 40),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 40,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "What's up DiST",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildNotificationSection(colorScheme),
                        const SizedBox(height: 24),
                        _buildMenuGrid(context),
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

  Widget _buildHeader(ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: 0.5), width: 2),
            ),
            child: CircleAvatar(
              radius: 35,
              backgroundColor: colorScheme.primaryContainer,
              backgroundImage: NetworkImage(widget.student.profileImageUrl),
              onBackgroundImageError: (_, __) {},
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  greeting,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withValues(alpha: 0.8),
                    letterSpacing: 1.1
                  ),
                ),
                Text(
                  widget.student.name,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.2
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationSection(ColorScheme colorScheme) {
    if (_notifController.isLoading && _notifController.notifications.isEmpty) {
      return const SizedBox(height: 250, child: Center(child: CircularProgressIndicator()));
    }
    if (_notifController.notifications.isEmpty) {
      return const SizedBox(height: 100, child: Center(child: Text("No new updates")));
    }
    return SizedBox(
      height: 250,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        physics: const BouncingScrollPhysics(),
        itemCount: _notifController.notifications.length,
        itemBuilder: (context, index) {
          return _buildNotificationCard(_notifController.notifications[index], colorScheme);
        },
      ),
    );
  }

  Widget _buildNotificationCard(AppNotification note, ColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.notifications_active_outlined, color: colorScheme.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(note.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(note.time, style: TextStyle(fontSize: 11, color: colorScheme.primary)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  note.description,
                  style: TextStyle(fontSize: 13, color: colorScheme.onSurfaceVariant),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuGrid(BuildContext context) {
    return Expanded(
      child: GridView.count(
        padding: const EdgeInsets.only(bottom: 100),
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.1, 
        children: [
          _buildMenuCard(context, Icons.calendar_today_rounded, "Timetable", Colors.blueAccent, () {
            _showUnavailablePop(context, "Timetable");
          }),
          _buildMenuCard(context, Icons.analytics_rounded, "Marks", Colors.orangeAccent, () {
            widget.onMenuTap(2);
          }),
          _buildMenuCard(context, Icons.assignment_turned_in_rounded, "Attendance", Colors.deepPurpleAccent, () {
            widget.onMenuTap(1); 
          }),
          _buildMenuCard(context, Icons.campaign_rounded, "Notices", Colors.redAccent, () {
            _showUnavailablePop(context, "Notices");
          }),
        ],
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, IconData icon, String title, Color color, VoidCallback onTap) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.3), width: 1),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.08), 
              blurRadius: 12, 
              offset: const Offset(0, 4)
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              Positioned(
                right: -10,
                top: -10,
                child: CircleAvatar(radius: 30, backgroundColor: color.withValues(alpha: 0.04)),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.12), 
                        borderRadius: BorderRadius.circular(15)
                      ),
                      child: Icon(icon, color: color, size: 24),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 15, 
                            fontWeight: FontWeight.bold, 
                            color: colorScheme.onSurface, 
                            letterSpacing: -0.5
                          ),
                        ),
                        Text(
                          "View details",
                          style: TextStyle(
                            fontSize: 11, 
                            color: colorScheme.onSurfaceVariant
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
      ),
    );
  }
}