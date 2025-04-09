import 'package:design_thinking/Quiz/quizquestionpage.dart';
import 'package:flutter/material.dart';

class Quizsplash extends StatefulWidget {
  final String lessonTitle;
  final int lessonIndex;
  final VoidCallback onComplete;

  const Quizsplash({
    super.key,
    required this.lessonTitle,
    required this.lessonIndex,
    required this.onComplete,
  });

  @override
  _QuizsplashState createState() => _QuizsplashState();
}

class _QuizsplashState extends State<Quizsplash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: Colors.black),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Let's get Started!\n${widget.lessonTitle}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Color(0xffE8505B),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Text(
                "Time to shine, rock this assessment!\n"
                "Your brilliance is unstoppable.\n"
                "Believe in yourself, take on each\n"
                "question with confidence, and let\n"
                "success be your story.",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: 250,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => QuizQuestionPage(
                              lessonTitle: widget.lessonTitle,
                              lessonIndex: widget.lessonIndex,
                              onQuizComplete: (bool isCompleted) {
                                if (isCompleted) {
                                  widget
                                      .onComplete(); // ✅ Update module page only when all questions are done
                                }
                              },
                            ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff75DBCE),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                    "Let's go",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
