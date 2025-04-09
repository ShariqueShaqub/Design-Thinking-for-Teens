import 'package:design_thinking/Home/Account/AboutUs.dart';
import 'package:design_thinking/Login_screens/Forgot_password.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Settings',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 30),
          element_1(context, "Reset Password", screen: ForgotPassword()),
          element_1(context, "About Us", screen: AboutUsPage()),
        ],
      ),
    );
  }
}

// Function to create settings list item
Widget element_1(BuildContext context, String name, {Widget? screen}) {
  return GestureDetector(
    onTap: () {
      if (screen != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      }
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          const Icon(Icons.arrow_right),
        ],
      ),
    ),
  );
}
