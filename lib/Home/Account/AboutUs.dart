import 'package:design_thinking/Home/Home.dart';
import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "About Us",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Center(
                child: Image.asset("assets/splashscreen_img_1.png"),
              ),
            ),
            _buildSectionTitle("Welcome to Design Thinking"),
            _buildSectionText(
              "Where creativity meets problem-solving for the next generation of thinkers!",
            ),

            const SizedBox(height: 20),
            _buildSectionTitle("Our Mission"),
            _buildSectionText(
              "At Your Design Thinking, our mission is to empower teenagers with the skills and mindset they need to tackle real-world challenges through design thinking. We believe that every young mind has the potential to be a creative problem solver, and we're here to nurture that potential.",
            ),

            const SizedBox(height: 20),
            _buildSectionTitle("Who We Are"),
            _buildSectionText(
              "We are a passionate team of educators, designers, and innovators who are dedicated to making learning fun and impactful. With years of experience in both education and design thinking, we understand the unique needs and interests of teenagers, and we're committed to providing them with the best learning experience possible.",
            ),

            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Home()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff75DBCE),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                child: const Text(
                  "Join Us !!",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget _buildSectionText(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black54,
          height: 1.5,
        ),
      ),
    );
  }
}
