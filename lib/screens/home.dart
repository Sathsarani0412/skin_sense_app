import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import 'package:fl_chart/fl_chart.dart';

import 'view.dart';
import 'profile.dart';

class HomeScreen extends StatefulWidget {
  final String name;
  final String email;

  const HomeScreen({
    super.key,
    required this.name,
    required this.email,
  });

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState
    extends State<HomeScreen> {

  File? selectedImage;

  final ImagePicker picker =
      ImagePicker();

  Map<String, double> skinIssues = {

    "BlackHeads": 0,
    "White Heads": 0,
    "Dark Spots": 0,
    "Wrinkles": 0,
  };

  String recommendation = "";

  String mostAffected = "";

  bool isLoading = false;

  // =========================================
  // GET USER NAME
  // =========================================

  String getUserName() {

    return widget.name;
  }

  // =========================================
  // PICK IMAGE FROM GALLERY
  // =========================================

  Future<void> uploadImage() async {

    final XFile? image =
    await picker.pickImage(

      source: ImageSource.gallery,

      imageQuality: 100,
    );

    if (image != null) {

      setState(() {

        selectedImage =
            File(image.path);

      });

      predictSkin();
    }
  }

  // =========================================
  // OPEN CAMERA
  // =========================================

  Future<void> openCamera() async {

    final XFile? image =
    await picker.pickImage(

      source: ImageSource.camera,

      imageQuality: 100,
    );

    if (image != null) {

      setState(() {

        selectedImage =
            File(image.path);

      });

      predictSkin();
    }
  }

  // =========================================
  // PREDICT SKIN
  // =========================================

  Future<void> predictSkin() async {

    if (selectedImage == null) return;

    setState(() {

      isLoading = true;

    });

    try {

      var request =
      http.MultipartRequest(

        "POST",

        Uri.parse(
          "http://localhost:5000/predict",
        ),
      );

      request.fields['email'] =
          widget.email;

      request.files.add(

        await http.MultipartFile.fromPath(

          'image',

          selectedImage!.path,
        ),
      );

      var response =
      await request.send();

      var responseData =
      await response.stream.bytesToString();

      var data =
      jsonDecode(responseData);

      if (data["success"] == true) {

        Map<String, dynamic> predictions =
        data["all_predictions"];

        setState(() {

          skinIssues = {

            "BlackHeads":
            (predictions["blackheads"] ?? 0)
                .toDouble(),

            "White Heads":
            (predictions["whiteheads"] ?? 0)
                .toDouble(),

            "Dark Spots":
            (predictions["dark_spots"] ?? 0)
                .toDouble(),

            "Wrinkles":
            (predictions["wrinkles"] ?? 0)
                .toDouble(),
          };

          recommendation =
          data["recommendation"];

          mostAffected =
              getMostAffectedIssue();
        });

      } else {

        ScaffoldMessenger.of(context)
            .showSnackBar(

          SnackBar(
            content: Text(
              data["message"],
            ),
          ),
        );
      }

    } catch (e) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(
          content: Text(
            "Error: $e",
          ),
        ),
      );

    }

    setState(() {

      isLoading = false;

    });
  }

  // =========================================
  // GET MOST AFFECTED ISSUE
  // =========================================

  String getMostAffectedIssue() {

    String issue = "";

    double maxValue = 0;

    skinIssues.forEach((key, value) {

      if (value > maxValue) {

        maxValue = value;

        issue = key;
      }
    });

    return issue;
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

              padding:
              const EdgeInsets.symmetric(

                horizontal: 18,
                vertical: 10,
              ),

              child: Column(

                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  // =========================================
                  // WELCOME
                  // =========================================

                  Text(

                    "Hello Welcome\n${getUserName()}",

                    style: const TextStyle(

                      fontSize: 30,

                      fontWeight:
                      FontWeight.bold,

                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // =========================================
                  // IMAGE PREVIEW
                  // =========================================

                  Center(

                    child: Container(

                      width: 230,
                      height: 230,

                      decoration: BoxDecoration(

                        color:
                        Colors.grey.shade300,

                        border: Border.all(
                          color: Colors.black,
                          width: 1.5,
                        ),
                      ),

                      child: selectedImage == null

                          ? const Icon(

                        Icons.image,

                        size: 80,

                        color: Colors.grey,
                      )

                          : Image.file(

                        selectedImage!,

                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // =========================================
                  // BUTTONS
                  // =========================================

                  Row(

                    mainAxisAlignment:
                    MainAxisAlignment.center,

                    children: [

                      buildButton(

                        text: "Upload Image",

                        onPressed:
                        uploadImage,
                      ),

                      const SizedBox(width: 15),

                      buildButton(

                        text: "Camera",

                        onPressed:
                        openCamera,
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  if (isLoading)

                    const Center(
                      child:
                      CircularProgressIndicator(),
                    ),

                  const SizedBox(height: 25),

                  // =========================================
                  // SKIN ANALYSIS TITLE
                  // =========================================

                  const Text(

                    "Skin Analysis",

                    style: TextStyle(

                      fontSize: 24,

                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // =========================================
                  // PIE CHART + PERCENTAGES
                  // =========================================

                  Row(

                    crossAxisAlignment:
                    CrossAxisAlignment.center,

                    children: [

                      // PIE CHART

                      Expanded(

                        flex: 2,

                        child: SizedBox(

                          height: 250,

                          child: PieChart(

                            PieChartData(

                              sections: [

                                PieChartSectionData(

                                  value:
                                  skinIssues["BlackHeads"],

                                  title:

                                  "${skinIssues["BlackHeads"]!.toStringAsFixed(1)}%",

                                  radius: 70,

                                  color: Colors.red,
                                ),

                                PieChartSectionData(

                                  value:
                                  skinIssues["White Heads"],

                                  title:

                                  "${skinIssues["White Heads"]!.toStringAsFixed(1)}%",

                                  radius: 70,

                                  color: Colors.blue,
                                ),

                                PieChartSectionData(

                                  value:
                                  skinIssues["Dark Spots"],

                                  title:

                                  "${skinIssues["Dark Spots"]!.toStringAsFixed(1)}%",

                                  radius: 70,

                                  color: Colors.orange,
                                ),

                                PieChartSectionData(

                                  value:
                                  skinIssues["Wrinkles"],

                                  title:

                                  "${skinIssues["Wrinkles"]!.toStringAsFixed(1)}%",

                                  radius: 70,

                                  color: Colors.green,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 15),

                      // PERCENTAGES

                      Expanded(

                        child: Column(

                          crossAxisAlignment:
                          CrossAxisAlignment.start,

                          children:
                          skinIssues.entries.map((e) {

                            return Padding(

                              padding:
                              const EdgeInsets.only(
                                bottom: 12,
                              ),

                              child: Container(

                                padding:
                                const EdgeInsets.all(10),

                                decoration: BoxDecoration(

                                  color: const Color(
                                    0xFFD8C2F2,
                                  ),

                                  borderRadius:
                                  BorderRadius.circular(
                                    12,
                                  ),

                                  border: Border.all(
                                    color: Colors.black,
                                    width: 1,
                                  ),
                                ),

                                child: Text(

                                  "${e.key}\n${e.value.toStringAsFixed(1)}%",

                                  style: const TextStyle(

                                    fontSize: 15,

                                    fontWeight:
                                    FontWeight.bold,
                                  ),
                                ),
                              ),
                            );

                          }).toList(),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  // =========================================
                  // LEGEND
                  // =========================================

                  Wrap(

                    spacing: 15,
                    runSpacing: 10,

                    children: [

                      buildLegend(
                        Colors.red,
                        "BlackHeads",
                      ),

                      buildLegend(
                        Colors.blue,
                        "White Heads",
                      ),

                      buildLegend(
                        Colors.orange,
                        "Dark Spots",
                      ),

                      buildLegend(
                        Colors.green,
                        "Wrinkles",
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  // =========================================
                  // MOST AFFECTED ISSUE
                  // =========================================

                  Container(

                    width: double.infinity,

                    padding:
                    const EdgeInsets.all(18),

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

                    child: Column(

                      crossAxisAlignment:
                      CrossAxisAlignment.start,

                      children: [

                        const Text(

                          "Most Affected Issue",

                          style: TextStyle(

                            fontSize: 20,

                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(

                          mostAffected,

                          style: const TextStyle(

                            fontSize: 24,

                            fontWeight:
                            FontWeight.bold,

                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // =========================================
                  // RECOMMENDATION
                  // =========================================

                  Container(

                    width: double.infinity,

                    padding:
                    const EdgeInsets.all(18),

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

                    child: Column(

                      crossAxisAlignment:
                      CrossAxisAlignment.start,

                      children: [

                        const Text(

                          "Recommendation",

                          style: TextStyle(

                            fontSize: 22,

                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 12),

                        Text(

                          recommendation,

                          style: const TextStyle(

                            fontSize: 18,

                            fontWeight:
                            FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),

      // =========================================
      // BOTTOM NAVIGATION
      // =========================================

      bottomNavigationBar:
      BottomNavigationBar(

        currentIndex: 0,

        backgroundColor:
        const Color(0xFFE9D5F7),

        selectedItemColor:
        Colors.black,

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

          if (index == 1) {

            Navigator.push(

              context,

              MaterialPageRoute(

                builder: (context) =>
                ViewScreen(
                  email: widget.email,
                ),
              ),
            );
          }

          if (index == 2) {

            Navigator.push(

              context,

              MaterialPageRoute(

                builder: (context) =>
                ProfileScreen(

                  name: widget.name,

                  email: widget.email,
                ),
              ),
            );
          }
        },
      ),
    );
  }

  // =========================================
  // BUTTON
  // =========================================

  Widget buildButton({

    required String text,

    required VoidCallback onPressed,

  }) {

    return SizedBox(

      width: 140,
      height: 48,

      child: ElevatedButton(

        onPressed: onPressed,

        style:
        ElevatedButton.styleFrom(

          backgroundColor:
          const Color(0xFFD8C2F2),

          shape:
          RoundedRectangleBorder(

            borderRadius:
            BorderRadius.circular(14),

            side: const BorderSide(

              color: Colors.black,

              width: 1.5,
            ),
          ),
        ),

        child: Text(

          text,

          style: const TextStyle(

            fontSize: 16,

            fontWeight:
            FontWeight.bold,

            color: Colors.black,
          ),
        ),
      ),
    );
  }

  // =========================================
  // LEGEND
  // =========================================

  Widget buildLegend(
      Color color,
      String text,
      ) {

    return Row(

      mainAxisSize:
      MainAxisSize.min,

      children: [

        Container(

          width: 18,
          height: 18,

          color: color,
        ),

        const SizedBox(width: 6),

        Text(

          text,

          style: const TextStyle(

            fontWeight:
            FontWeight.bold,
          ),
        ),
      ],
    );
  }
}