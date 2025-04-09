import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  final Function(String) onModuleTap;
  const HomeScreen({super.key, required this.onModuleTap});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String userName = "User"; // Default value
  List<String> modules = [
    "What is Design Thinking",
    "Empathize",
    "Define",
    "Ideate",
    "Prototype",
    "Test",
  ];
  List<String> ongoing = [];
  List<String> completed = [];
  late bool progress = false;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    fetchUserName();
    fetchOngoingModules();
    fetchCompletedModules();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> fetchUserName() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      setState(() {
        userName = userDoc['firstName'] ?? 'User'; // Ensure proper fallback
      });
    } catch (e) {
      print("Error fetching user name: $e");
    }
  }

  Future<void> fetchOngoingModules() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .collection('ongoingModules')
              .get();

      setState(() {
        ongoing =
            querySnapshot.docs.map((doc) => doc['name'].toString()).toList();
      });
    } catch (e) {
      print("Error fetching ongoing modules: $e");
    }
  }

  Future<void> fetchCompletedModules() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .collection('completedModules')
              .get();

      setState(() {
        completed =
            querySnapshot.docs.map((doc) => doc['name'].toString()).toList();
      });
    } catch (e) {
      print("Error fetching completed modules: $e");
    }
  }

  Future<void> addToOngoing(String moduleName) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      CollectionReference ongoingCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('ongoingModules');

      // Check if the module already exists
      QuerySnapshot existingModules =
          await ongoingCollection.where('name', isEqualTo: moduleName).get();

      if (existingModules.docs.isEmpty) {
        // Add only if it doesn't already exist
        await ongoingCollection.add({'name': moduleName});
        fetchOngoingModules(); // Refresh list
      } else {
        print("Module already exists in ongoing list.");
      }
    } catch (e) {
      print("Error adding module: $e");
    }
  }

  Future<void> markAsCompleted(String moduleName) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      CollectionReference completedCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('completedModules');

      // Check if the module is already in the completed list
      QuerySnapshot existingModules =
          await completedCollection.where('name', isEqualTo: moduleName).get();

      if (existingModules.docs.isEmpty) {
        // Add to completed list
        await completedCollection.add({'name': moduleName});

        // Remove from ongoing list
        QuerySnapshot ongoingModulesSnapshot =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(uid)
                .collection('ongoingModules')
                .where('name', isEqualTo: moduleName)
                .get();

        for (var doc in ongoingModulesSnapshot.docs) {
          await doc.reference.delete();
        }

        fetchOngoingModules();
        fetchCompletedModules();
      } else {
        print("Module already exists in completed list.");
      }
    } catch (e) {
      print("Error marking module as completed: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  'assets/splashscreen_img_1.png',
                  height: 113,
                  width: 113,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                  child: Row(
                    children: [
                      Text(
                        'Hi, $userName 👋',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Image.asset(
                        'assets/HomeScreen_Profile.png',
                        height: 40,
                        width: 40,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Image.asset('assets/HomeScreen_banner.png', scale: 0.1),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Design Thinking Framework',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
            ),
            SizedBox(height: 20),
            progress
                ? Image.asset('assets/HomeScreen_img1.png')
                : Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color(0xffA8E8F9),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Overall Mastery',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Image.asset('assets/star.png'),
                          ],
                        ),
                        Text(
                          'Unlock your greatness',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 12),
                        LinearProgressIndicator(
                          minHeight: 8,
                          borderRadius: BorderRadius.circular(8),
                          value: completed.length / 6,
                          color: Color(0xff8DF13F),
                          backgroundColor: Colors.grey,
                        ),
                        SizedBox(height: 12),
                        Image.asset('assets/star.png'),
                      ],
                    ),
                  ),
                  height: 130,
                  width: 333,
                ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Let's Start",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            Theme(
              data: ThemeData(
                tabBarTheme: TabBarTheme(dividerColor: Colors.transparent),
              ),
              child: TabBar(
                onTap: (index) {
                  setState(() {
                    progress =
                        (index == 0); // Show progress only in "Modules" tab
                  });
                },

                controller: _tabController,
                indicatorColor: Color(0xffE8505B),
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                labelStyle: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
                tabs: [
                  Tab(text: "Modules"),
                  Tab(text: 'Ongoing'),
                  Tab(text: 'Completed'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  ListView.builder(
                    itemCount: modules.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          modules[index],
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        trailing: Icon(Icons.play_circle, color: Colors.grey),
                        onTap: () {
                          addToOngoing(modules[index]);
                          widget.onModuleTap(modules[index]);
                          setState(() {});
                        },
                      );
                    },
                  ),
                  ListView.builder(
                    itemCount: ongoing.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          ongoing[index],
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        trailing: Icon(Icons.play_circle, color: Colors.green),
                        onTap: () {
                          markAsCompleted(ongoing[index]);
                          widget.onModuleTap(ongoing[index]);
                          setState(() {});
                        },
                      );
                    },
                  ),
                  ListView.builder(
                    itemCount: completed.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          completed[index],
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        trailing: Icon(Icons.check_circle, color: Colors.blue),
                      );
                    },
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
