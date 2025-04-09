import 'package:design_thinking/Home/Account.dart';
import 'package:design_thinking/Home/Account/Quiz.dart';
import 'package:design_thinking/Home/Homescreen.dart';
import 'package:design_thinking/Home/Play.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  String selectedFolder = ""; // Store selected module name

  @override
  Widget build(BuildContext context) {
    // Pages update dynamically when switching tabs
    final List<Widget> _pages = [
      HomeScreen(
        onModuleTap: (folder) {
          setState(() {
            selectedFolder = folder;
            _currentIndex = 1; // Switch to PlayScreen
          });
        },
      ),
      VideoPlayScreen(folder: selectedFolder),
      Quiz(), // Pass selected folder name
      Account(),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: _pages[_currentIndex], // Show selected screen
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
        child: GNav(
          tabBorderRadius: 50,
          gap: 8,
          color: Colors.black,
          activeColor: Colors.white,
          iconSize: 0,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          tabBackgroundColor: Color(0xff75DBCE),
          tabs: [
            GButton(
              leading: Image.asset(
                'assets/Nav/Home.png',
                width: 24,
                height: 24,
              ),
              icon: Icons.abc,
            ),
            GButton(
              leading: Image.asset(
                'assets/Nav/Search.png',
                width: 24,
                height: 24,
              ),
              icon: Icons.abc,
            ),
            GButton(
              leading: Image.asset(
                'assets/Nav/Vector.png',
                width: 24,
                height: 24,
              ),
              icon: Icons.abc,
            ),
            GButton(
              leading: Image.asset(
                'assets/Nav/Profile.png',
                width: 24,
                height: 24,
              ),
              icon: Icons.abc,
            ),
          ],
          selectedIndex: _currentIndex,
          onTabChange: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}
