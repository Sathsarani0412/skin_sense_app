import 'package:flutter/material.dart';

import 'home.dart';
import 'profile.dart';

class ViewScreen extends StatefulWidget {

  final String email;

  const ViewScreen({

    super.key,

    required this.email,
  });

  @override
  State<ViewScreen> createState() => _ViewScreenState();
}

class _ViewScreenState extends State<ViewScreen> {

  String selectedFilter = "Weekly";

  // Dummy backend progress data
  List<Map<String, dynamic>> progressData = [

    {
      "title": "BlackHeads",
      "old": 25,
      "new": 13,
    },

    {
      "title": "White Heads",
      "old": 10,
      "new": 15,
    },

    {
      "title": "Dark Spots",
      "old": 23,
      "new": 23,
    },

    {
      "title": "Wrinkles",
      "old": 20,
      "new": 5,
    },
  ];

  // Analysis Message
  String generateMessage() {

    int improved = 0;

    for (var item in progressData) {

      if (item["new"] < item["old"]) {

        improved++;

      }
    }

    if (improved >= 3) {

      return "Congratulations! Your skin condition has improved significantly.";

    }

    else if (improved >= 1) {

      return "Your skin is improving gradually. Keep following remedies.";

    }

    else {

      return "Some skin issues increased. Continue treatments regularly.";
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Container(

        width: double.infinity,
        height: double.infinity,

        decoration: const BoxDecoration(

          image: DecorationImage(

            image: AssetImage(
              "assets/background.png",
            ),

            fit: BoxFit.cover,
          ),
        ),

        child: SafeArea(

          child: SingleChildScrollView(

            child: Padding(

              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 15,
              ),

              child: Column(

                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  // TITLE
                  const Text(
                    "Skin Progress Tracker",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(height: 25),

                  // DROPDOWN
                  Row(

                    children: [

                      const Text(
                        "Track Progress : ",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(width: 15),

                      Container(

                        padding:
                        const EdgeInsets.symmetric(
                          horizontal: 12,
                        ),

                        decoration: BoxDecoration(

                          color:
                          const Color(0xFFD8C2F2),

                          borderRadius:
                          BorderRadius.circular(12),

                          border: Border.all(
                            color: Colors.black,
                            width: 1.3,
                          ),
                        ),

                        child: DropdownButton<String>(

                          value: selectedFilter,

                          underline:
                          const SizedBox(),

                          dropdownColor:
                          const Color(0xFFD8C2F2),

                          items: [

                            "Weekly",
                            "Monthly",
                            "Yearly",

                          ].map((e) {

                            return DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            );

                          }).toList(),

                          onChanged: (value) {

                            setState(() {

                              selectedFilter =
                              value!;

                            });

                            // Backend request later
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // GRAPH TITLE
                  const Text(
                    "Progress Graph",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // GRAPH CONTAINER
                  Container(

                    width: double.infinity,

                    padding: const EdgeInsets.all(18),

                    decoration: BoxDecoration(

                      color: Colors.white.withOpacity(0.7),

                      borderRadius:
                      BorderRadius.circular(20),

                      border: Border.all(
                        color: Colors.black,
                        width: 1.4,
                      ),
                    ),

                    child: Column(

                      children: progressData.map((item) {

                        int oldValue = item["old"];
                        int newValue = item["new"];

                        return Padding(

                          padding:
                          const EdgeInsets.only(
                            bottom: 28,
                          ),

                          child: Column(

                            crossAxisAlignment:
                            CrossAxisAlignment.start,

                            children: [

                              // ISSUE NAME
                              Text(
                                item["title"],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight:
                                  FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 12),

                              // OLD VALUE
                              const Text(
                                "Previous",
                                style: TextStyle(
                                  fontWeight:
                                  FontWeight.w600,
                                ),
                              ),

                              const SizedBox(height: 6),

                              Stack(

                                children: [

                                  Container(
                                    width: double.infinity,
                                    height: 28,

                                    decoration: BoxDecoration(

                                      color:
                                      Colors.grey.shade300,

                                      borderRadius:
                                      BorderRadius.circular(
                                        12,
                                      ),
                                    ),
                                  ),

                                  Container(
                                    width:
                                    oldValue * 8,

                                    height: 28,

                                    decoration: BoxDecoration(

                                      color: Colors.red,

                                      borderRadius:
                                      BorderRadius.circular(
                                        12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 15),

                              // NEW VALUE
                              const Text(
                                "Current",
                                style: TextStyle(
                                  fontWeight:
                                  FontWeight.w600,
                                ),
                              ),

                              const SizedBox(height: 6),

                              Stack(

                                children: [

                                  Container(
                                    width: double.infinity,
                                    height: 28,

                                    decoration: BoxDecoration(

                                      color:
                                      Colors.grey.shade300,

                                      borderRadius:
                                      BorderRadius.circular(
                                        12,
                                      ),
                                    ),
                                  ),

                                  Container(
                                    width:
                                    newValue * 8,

                                    height: 28,

                                    decoration: BoxDecoration(

                                      color: Colors.green,

                                      borderRadius:
                                      BorderRadius.circular(
                                        12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 12),

                              Text(
                                "$oldValue% → $newValue%",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight:
                                  FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );

                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // ANALYSIS RESULT
                  const Text(
                    "Analysis Result",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 15),

                  Container(

                    width: double.infinity,

                    padding: const EdgeInsets.all(18),

                    decoration: BoxDecoration(

                      color:
                      const Color(0xFFD8C2F2),

                      borderRadius:
                      BorderRadius.circular(18),

                      border: Border.all(
                        color: Colors.black,
                        width: 1.5,
                      ),
                    ),

                    child: Text(
                      generateMessage(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),

                  const SizedBox(height: 35),

                  // LEGEND
                  Row(

                    mainAxisAlignment:
                    MainAxisAlignment.center,

                    children: [

                      Container(
                        width: 20,
                        height: 20,
                        color: Colors.red,
                      ),

                      const SizedBox(width: 8),

                      const Text(
                        "Previous",
                        style: TextStyle(
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),

                      const SizedBox(width: 25),

                      Container(
                        width: 20,
                        height: 20,
                        color: Colors.green,
                      ),

                      const SizedBox(width: 8),

                      const Text(
                        "Current",
                        style: TextStyle(
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),

      // BOTTOM NAVIGATION
      bottomNavigationBar: BottomNavigationBar(

        currentIndex: 1,

        backgroundColor:
        const Color(0xFFE9D5F7),

        selectedItemColor: Colors.black,

        unselectedItemColor:
        Colors.black54,

        items: const [

          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: "View",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],

        onTap: (index) {

          if (index == 0) {

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                const HomeScreen(name: '', email: '',),
              ),
            );
          }

          if (index == 2) {

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                const ProfileScreen(name: '', email: '',),
              ),
            );
          }
        },
      ),
    );
  }
}