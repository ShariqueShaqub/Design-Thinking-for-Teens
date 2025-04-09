import 'package:design_thinking/Home/Account.dart';
import 'package:design_thinking/Home/Homescreen.dart';
import 'package:design_thinking/Home/Play.dart';
import 'package:design_thinking/Quiz/quizsplash.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class Quiz extends StatefulWidget {
  const Quiz({super.key});

  @override
  State<Quiz> createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  int _currentIndex = 2; // Set default index to Quiz tab

  List<Map<String, dynamic>> quizzes = [
    {
      "title": "What is Design Thinking",
      "color": const Color(0xffE1627D),
      "image": "assets/quiz/q1.jpg",
      "completed": false,
    },
    {
      "title": "Empathize",
      "color": Colors.lightBlue,
      "image": "assets/quiz/q2.jpg",
      "completed": false,
    },
    {
      "title": "Define",
      "color": const Color(0xffE8505B),
      "image": "assets/quiz/q3.jpg",
      "completed": false,
    },
    {
      "title": "Ideate",
      "color": const Color(0xffFE654C),
      "image": "assets/quiz/q4.jpg",
      "completed": false,
    },
    {
      "title": "Prototype",
      "color": const Color(0xff9533AA),
      "image": "assets/quiz/q5.jpg",
      "completed": false,
    },
    {
      "title": "Test",
      "color": const Color(0xff19A983),
      "image": "assets/quiz/q6.jpg",
      "completed": false,
    },
  ];

  double progress = 0.0;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < quizzes.length; i++) {
      quizzes[i]["completed"] = prefs.getBool("quiz_$i") ?? false;
    }
    _updateProgress();
  }

  Future<void> _saveProgress(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("quiz_$index", quizzes[index]["completed"]);
  }

  void _updateProgress() {
    int completedCount = quizzes.where((quiz) => quiz["completed"]).length;
    setState(() {
      progress = completedCount / quizzes.length;
    });
  }

  void _markQuizComplete(int index) {
    setState(() {
      quizzes[index]["completed"] = true;
      _saveProgress(index);
      _updateProgress();
    });
  }

  void _navigateToQuiz(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => Quizsplash(
              lessonTitle: quizzes[index]["title"],
              lessonIndex: index,
              onComplete: () => _markQuizComplete(index),
            ),
      ),
    );
  }

  void _onTabChange(int index) {
    setState(() {
      _currentIndex = index;
    });

    // Navigation to corresponding pages
    Widget nextPage;
    switch (index) {
      case 0:
        nextPage = HomeScreen(onModuleTap: (folder) {});
        break;
      case 1:
        nextPage = const VideoPlayScreen(folder: ""); // Adjust as needed
        break;
      case 2:
        return; // Already in Quiz page, do nothing
      case 3:
        nextPage = const Account();
        break;
      default:
        return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => nextPage),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Quiz",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_sharp),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Completed",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              LinearProgressIndicator(value: progress, minHeight: 10),
              const SizedBox(height: 20),
              Column(
                children:
                    quizzes.asMap().entries.map((entry) {
                      int index = entry.key;
                      var quiz = entry.value;
                      return GestureDetector(
                        onTap: () => _navigateToQuiz(index),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 15),
                          padding: const EdgeInsets.all(15),
                          width: double.infinity,
                          height: 120,
                          decoration: BoxDecoration(
                            color: quiz["color"],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Checkbox(
                                value: quiz["completed"],
                                onChanged: null, // Disable manual checking
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Quiz ${index + 1}:",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    Text(
                                      quiz['title'],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (quiz["image"] != null)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    quiz["image"],
                                    height: 80,
                                    width: 80,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
