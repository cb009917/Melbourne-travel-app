import "package:flutter/material.dart";
import "package:tourist/bookings.dart";
import "package:tourist/bottem_nav/bookmark.dart";
import "package:tourist/bottem_nav/bottem_nav.dart";
import "package:tourist/homepage.dart";
import "package:tourist/settings.dart";

class Component extends StatefulWidget {
  const Component({super.key});

  @override
  State<Component> createState() => _ComponentState();
}

class _ComponentState extends State<Component> {
  int _selectedIndex = 0;
  void navigationbottembar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [home_page(), BookMark(), Bookings(), Setting()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottemNav(
        onTabChange: (index) => navigationbottembar(index),
      ),
      body: _pages[_selectedIndex],
    );
  }
}
