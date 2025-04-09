import 'package:design_thinking/Login_screens/signup.dart';
import 'package:design_thinking/onboard_screens/s3.dart';
import 'package:flutter/material.dart';

class S2 extends StatelessWidget {
  const S2({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.05),
            Image.asset(
              'assets/ob_img3.png',
              height: screenHeight * 0.30,
              width: screenWidth * 0.8,
              fit: BoxFit.contain,
            ),
            SizedBox(height: screenHeight * 0.02),
            Text(
              'Learn from \nInspiring Modules',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: screenWidth * 0.07,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: screenHeight * 0.02),
            SizedBox(
              height: screenHeight * 0.18,
              width: screenWidth * 0.85,
              child: Text(
                'Draw inspiration from amazing inventors, artists, and innovators who have changed the world with their ideas. Dive into their modules, learn from their failures and successes, and discover how you can make your mark.',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: screenWidth * 0.04,
                  color: Color(0xff95969D),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            Image.asset(
              'assets/ob_img4.png',
              height: screenHeight * 0.02,
              width: screenWidth * 0.06,
              fit: BoxFit.contain,
            ),
            SizedBox(height: screenHeight * 0.05),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Signup()),
                      );
                    },
                    style: TextButton.styleFrom(foregroundColor: Colors.grey),
                    child: Text('Skip'),
                  ),
                  SizedBox(
                    height: screenHeight * 0.07,
                    width: screenWidth * 0.4,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => S3()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff75DBCE),
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Next',
                        style: TextStyle(fontSize: screenWidth * 0.05),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
