import 'package:flutter/material.dart';

class FAQ extends StatelessWidget {
  final List<Map<String, String>> faqList = [
    {
      "question": "What is Design Thinking?",
      "answer":
          "Design Thinking is a problem-solving approach that focuses on understanding user needs, ideating solutions, and prototyping innovative designs.",
    },
    {
      "question": "Why is Design Thinking important?",
      "answer":
          "It encourages creativity, empathy, and iterative problem-solving to create user-centric solutions.",
    },
    {
      "question": "What are the 5 phases of Design Thinking?",
      "answer":
          "The five phases are: Empathize, Define, Ideate, Prototype, and Test.",
    },
    {
      "question": "How can I apply Design Thinking?",
      "answer":
          "You can apply it in UX/UI design, business innovation, product development, and problem-solving in various domains.",
    },
    {
      "question": "Do I need special tools for Design Thinking?",
      "answer":
          "No, but tools like Figma, Miro, and paper prototyping can help visualize and test ideas quickly.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "FAQs",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: faqList.length,
          itemBuilder: (context, index) {
            return Card(
              color: Colors.white,
              elevation: 2,
              margin: EdgeInsets.symmetric(vertical: 8),
              child: ExpansionTile(
                title: Text(
                  faqList[index]["question"]!,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(faqList[index]["answer"]!),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
