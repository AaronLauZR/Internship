// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class BottomNavBar extends StatefulWidget {
  final void Function(int) onTabChange;

  const BottomNavBar({Key? key, required this.onTabChange}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return Container(

      //Bottom Navigation Bar Design
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),

        //Tab Design
        child: GNav(
          backgroundColor: Colors.black,
          color: Colors.white,
          activeColor: Colors.white,
          gap: 10,
            tabBackgroundColor: Colors.grey.shade600,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),

          // Tap Changing Function
          onTabChange: (value) {
            widget.onTabChange(value);
          },

          // Tab Settings
          tabs: const [
            GButton(
              icon: Icons.rate_review,
              text: 'Average',
            ),
            GButton(
              icon: Icons.calendar_view_day_rounded,
              text: 'Daily',
            ),
            GButton(
              icon: Icons.auto_graph_sharp,
              text: 'Yearly',
            ),
          ],
        ),
      ),
    );
  }
}
