import "package:flutter/material.dart";
import "package:google_nav_bar/google_nav_bar.dart";

class BottemNav extends StatelessWidget {
  void Function(int)? onTabChange;
  BottemNav({super.key, required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    return GNav(
        onTabChange: (value) => onTabChange!(value),
        color: Colors.grey[600],
        activeColor: Colors.grey[800],
        tabs: [
          GButton(
            icon: Icons.home_outlined,
            iconSize: 32,
            text: "Home",
          ),
          GButton(
            icon: Icons.bookmark_outline,
            iconSize: 32,
            text: "Bookmark",
          ),
          GButton(
            icon: Icons.calendar_month,
            iconSize: 32,
            text: "Bookings",
          ),
          GButton(
            icon: Icons.settings,
            iconSize: 32,
            text: "Settings",
          ),
        ]);
  }
}
