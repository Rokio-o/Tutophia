import 'package:flutter/material.dart';

// ---------- SECTION CARD ----------
Widget sectionCard(String title, String text, Function onEdit) {
  List<String> lines = text.split("\n");

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF386FA4),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit, size: 18),
              onPressed: () => onEdit(),
            ),
          ],
        ),

        const SizedBox(height: 10),

        ...lines.map((line) {
          if (!line.contains(":")) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                line,
                style: const TextStyle(fontSize: 14, height: 1.5),
              ),
            );
          }

          final parts = line.split(":");
          final label = parts[0];
          final value = parts.sublist(1).join(":").trim();

          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF386FA4),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    value,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ),
              ],
            ),
          );
        }),

        const Divider(height: 25, thickness: 1, color: Colors.black12),
      ],
    ),
  );
}

// ---------- BUILD BOX (labeled text field) ----------
Widget buildBox(TextEditingController controller, String label) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          color: Color(0xFF386FA4),
          fontWeight: FontWeight.w500,
        ),
      ),

      const SizedBox(height: 5),

      Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: TextField(
          controller: controller,
          decoration: const InputDecoration(border: InputBorder.none),
        ),
      ),
    ],
  );
}

// ---------- BOTTOM NAV BAR ----------
class BottomNav extends StatelessWidget {
  const BottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
      ),
      child: const Row(
        children: [
          NavItem(icon: Icons.home_outlined, label: 'Home', isActive: false),
          NavItem(
            icon: Icons.notifications,
            label: 'Notification',
            isActive: false,
          ),
          NavItem(icon: Icons.person_outline, label: 'Profile', isActive: true),
        ],
      ),
    );
  }
}

// ---------- NAV ITEM ----------
class NavItem extends StatelessWidget {
  const NavItem({
    super.key,
    required this.icon,
    required this.label,
    required this.isActive,
  });

  final IconData icon;
  final String label;
  final bool isActive;

  static const Color kOrange = Color(0xFFE8A838);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: isActive ? kOrange : Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isActive ? Colors.white : Colors.grey),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: isActive ? Colors.white : Colors.grey,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
