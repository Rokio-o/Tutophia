import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  /// Currently selected index
  final int currentIndex;

  /// Callback when a tab is tapped
  final ValueChanged<int> onTap;

  /// Optional: list of navigation functions, one per tab
  final List<VoidCallback>? tabActions;

  const BottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    this.tabActions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      selectedItemColor: const Color(0xfff4a24c),
      unselectedItemColor: Colors.grey,
      onTap: (index) {
        // If tapped tab is the current tab, do nothing
        if (index == currentIndex) return;

        // Notify parent about the tab change
        onTap(index);

        // Execute optional navigation function if provided
        if (tabActions != null && index < tabActions!.length) {
          tabActions![index]();
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: "Notifications",
        ),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ],
    );
  }
}
