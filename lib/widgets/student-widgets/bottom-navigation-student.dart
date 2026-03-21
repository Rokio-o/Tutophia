import 'package:flutter/material.dart';

class BottomNavStudent extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavStudent({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      selectedItemColor: const Color(0xfff4a24c),
      unselectedItemColor: Colors.grey,
      onTap: (index) {
        if (index == currentIndex) return;
        onTap(index);
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
