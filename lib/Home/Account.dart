import 'package:design_thinking/Home/Account/Certificate.dart';
import 'package:design_thinking/Home/Account/FAQ.dart';
import 'package:design_thinking/Home/Account/Logout.dart';
import 'package:design_thinking/Home/Account/Profile.dart';
import 'package:design_thinking/Home/Account/Settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

String username = "";

class _AccountState extends State<Account> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Account',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Colors.black,
          ),
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                SizedBox(
                  height: constraints.maxHeight * 0.05,
                ), // 5% of screen height
                Center(
                  child: CircleAvatar(
                    radius: constraints.maxWidth * 0.2, // 20% of screen width
                    backgroundImage: const AssetImage(
                      "assets/HomeScreen_Profile.png",
                    ),
                  ),
                ),
                SizedBox(height: constraints.maxHeight * 0.05),
                Text(username),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.symmetric(
                      horizontal: constraints.maxWidth * 0.05,
                    ),
                    children: [
                      element_1("Edit Account", Profile(), constraints),
                      element_1(
                        "Settings And Privacy",
                        Settings(),
                        constraints,
                      ),
                      element_1(
                        "Download Certificate",
                        CertificateGenerator(),
                        constraints,
                      ),
                      element_1("FAQ’s", FAQ(), constraints),
                      element_1("Logout", LogoutScreen(), constraints),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget element_1(String title, Widget screen, BoxConstraints constraints) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: constraints.maxHeight * 0.015),
        child: Container(
          padding: EdgeInsets.all(constraints.minWidth),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize:
                      constraints.maxWidth * 0.045, // 4.5% of screen width
                  fontWeight: FontWeight.w500,
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: constraints.maxWidth * 0.05, // 5% of screen width
              ),
            ],
          ),
        ),
      ),
    );
  }
}
