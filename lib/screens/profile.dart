import 'package:flutter/material.dart';

import 'home.dart';
import 'view.dart';
import 'login.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class ProfileScreen extends StatefulWidget {

  final String name;
  final String email;

  const ProfileScreen({

    super.key,

    required this.name,
    required this.email,
  });

  @override
  State<ProfileScreen> createState() =>
      _ProfileScreenState();
}

class _ProfileScreenState
    extends State<ProfileScreen> {

  // CONTROLLERS

  late TextEditingController
  nameController;

  late TextEditingController
  emailController;

  // INIT STATE

  @override
  void initState() {

    super.initState();

    nameController =
        TextEditingController(
          text: widget.name,
        );

    emailController =
        TextEditingController(
          text: widget.email,
        );
  }

  // SAVE PROFILE

  Future<void> saveProfile() async {

    String name =
        nameController.text.trim();

    String email =
        emailController.text.trim();

    try {

      final response =
      await http.post(

        Uri.parse(
          "http://localhost:5000/update_profile",
        ),

        headers: {

          "Content-Type":
          "application/json",
        },

        body: jsonEncode({

          "old_email":
          widget.email,

          "new_name": name,

          "new_email": email,
        }),
      );

      final data =
      jsonDecode(response.body);

      if (data["success"] == true) {

        ScaffoldMessenger.of(context)
            .showSnackBar(

          SnackBar(
            content: Text(
              data["message"],
            ),
          ),
        );

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
            "Error : $e",
          ),
        ),
      );
    }
  }

  // LOGOUT

  void logout() {

    Navigator.pushAndRemoveUntil(

      context,

      MaterialPageRoute(

        builder: (context) =>
        const LoginScreen(),
      ),

          (route) => false,
    );
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

                horizontal: 22,
                vertical: 12,
              ),

              child: Column(

                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  // TOP ROW

                  Row(

                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,

                    children: [

                      const Text(

                        "My Profile",

                        style: TextStyle(

                          fontSize: 32,

                          fontWeight:
                          FontWeight.bold,

                          color: Colors.black,
                        ),
                      ),

                      IconButton(

                        onPressed: logout,

                        icon: const Icon(

                          Icons.logout,

                          size: 32,

                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // PROFILE IMAGE

                  Center(

                    child: Container(

                      width: 130,
                      height: 130,

                      decoration: BoxDecoration(

                        shape: BoxShape.circle,

                        color:
                        const Color(0xFFD8C2F2),

                        border: Border.all(

                          color: Colors.black,

                          width: 2,
                        ),
                      ),

                      child: const Icon(

                        Icons.person,

                        size: 70,

                        color: Colors.black87,
                      ),
                    ),
                  ),

                  const SizedBox(height: 35),

                  // NAME TITLE

                  const Text(

                    "Name",

                    style: TextStyle(

                      fontSize: 20,

                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // NAME FIELD

                  buildTextField(

                    controller:
                    nameController,

                    hint: "Enter Name",

                    icon: Icons.person,
                  ),

                  const SizedBox(height: 25),

                  // EMAIL TITLE

                  const Text(

                    "Email",

                    style: TextStyle(

                      fontSize: 20,

                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // EMAIL FIELD

                  buildTextField(

                    controller:
                    emailController,

                    hint: "Enter Email",

                    icon: Icons.email,
                  ),

                  const SizedBox(height: 35),

                  // SAVE BUTTON

                  Center(

                    child: buildButton(

                      text: "Save Changes",

                      onPressed:
                      saveProfile,
                    ),
                  ),

                  const SizedBox(height: 35),

                  // SETTINGS

                  const Text(

                    "Settings",

                    style: TextStyle(

                      fontSize: 24,

                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 18),

                  buildSettingTile(

                    icon: Icons.lock,

                    title: "Privacy",
                  ),

                  const SizedBox(height: 14),

                  buildSettingTile(

                    icon: Icons.notifications,

                    title: "Notifications",
                  ),

                  const SizedBox(height: 14),

                  buildSettingTile(

                    icon: Icons.help,

                    title: "Help & Support",
                  ),

                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      ),

      // BOTTOM NAVIGATION

      bottomNavigationBar:
      BottomNavigationBar(

        currentIndex: 2,

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

          if (index == 0) {

            Navigator.push(

              context,

              MaterialPageRoute(

                builder: (context) =>
                HomeScreen(

                  name: nameController.text,

                  email:
                  emailController.text,
                ),
              ),
            );
          }

          if (index == 1) {

            Navigator.push(

              context,

              MaterialPageRoute(

                builder: (context) =>
                ViewScreen(

                  email:
                  emailController.text,
                ),
              ),
            );
          }
        },
      ),
    );
  }

  // TEXT FIELD

  Widget buildTextField({

    required TextEditingController
    controller,

    required String hint,

    required IconData icon,

  }) {

    return Container(

      decoration: BoxDecoration(

        color:
        const Color(0xFFD8C2F2),

        borderRadius:
        BorderRadius.circular(14),

        border: Border.all(

          color: Colors.black,

          width: 1.5,
        ),
      ),

      child: TextField(

        controller: controller,

        decoration: InputDecoration(

          hintText: hint,

          prefixIcon: Icon(

            icon,

            color: Colors.black87,
          ),

          border: InputBorder.none,

          contentPadding:
          const EdgeInsets.symmetric(

            vertical: 18,
          ),
        ),
      ),
    );
  }

  // BUTTON

  Widget buildButton({

    required String text,

    required VoidCallback onPressed,

  }) {

    return SizedBox(

      width: 190,
      height: 52,

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

            fontSize: 18,

            fontWeight:
            FontWeight.bold,

            color: Colors.black,
          ),
        ),
      ),
    );
  }

  // SETTINGS TILE

  Widget buildSettingTile({

    required IconData icon,

    required String title,

  }) {

    return Container(

      padding:
      const EdgeInsets.symmetric(

        horizontal: 16,
        vertical: 16,
      ),

      decoration: BoxDecoration(

        color:
        Colors.white.withOpacity(0.7),

        borderRadius:
        BorderRadius.circular(16),

        border: Border.all(

          color: Colors.black,

          width: 1.3,
        ),
      ),

      child: Row(

        children: [

          Icon(

            icon,

            size: 28,

            color: Colors.black,
          ),

          const SizedBox(width: 15),

          Expanded(

            child: Text(

              title,

              style: const TextStyle(

                fontSize: 18,

                fontWeight:
                FontWeight.w600,
              ),
            ),
          ),

          const Icon(

            Icons.arrow_forward_ios,

            size: 18,

            color: Colors.black,
          ),
        ],
      ),
    );
  }
}