import 'package:flutter/material.dart';
import 'home.dart';
import 'reset.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState
    extends State<LoginScreen> {

  final TextEditingController
  emailController =
      TextEditingController();

  final TextEditingController
  passwordController =
      TextEditingController();

  bool obscurePassword = true;

  // -----------------------------------------
  // LOGIN FUNCTION
  // -----------------------------------------

  Future<void> loginUser() async {

    String email =
        emailController.text.trim();

    String password =
        passwordController.text.trim();

    // EMPTY CHECK

    if (email.isEmpty ||
        password.isEmpty) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(
          content: Text(
            "Please fill all fields",
          ),
        ),
      );

      return;
    }

    try {

      final response =
      await http.post(

        Uri.parse(
          "http://10.0.2.2:5000/login",
        ),

        headers: {

          "Content-Type":
          "application/json",
        },

        body: jsonEncode({

          "email": email,

          "password": password,
        }),
      );

      final data =
      jsonDecode(response.body);

      if (data["success"] == true) {

        ScaffoldMessenger.of(context)
            .showSnackBar(

          const SnackBar(
            content: Text(
              "Login Successful",
            ),
          ),
        );

        Navigator.push(

          context,

          MaterialPageRoute(

            builder: (context) =>
                HomeScreen(

              name: data["name"],

              email: data["email"],
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
            "Error: $e",
          ),
        ),
      );
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

              padding:
              const EdgeInsets.symmetric(
                horizontal: 28,
              ),

              child: Column(

                children: [

                  const SizedBox(height: 55),

                  // LOGO

                  Image.asset(
                    "assets/logo.png",
                    height: 220,
                  ),

                  const SizedBox(height: 25),

                  // TITLE

                  const Text(

                    "Log In",

                    style: TextStyle(

                      fontSize: 32,

                      fontWeight:
                      FontWeight.bold,

                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // EMAIL FIELD

                  buildTextField(

                    controller:
                    emailController,

                    hint: "Email",

                    icon: Icons.email,
                  ),

                  const SizedBox(height: 20),

                  // PASSWORD FIELD

                  buildPasswordField(),

                  const SizedBox(height: 30),

                  // LOGIN BUTTON

                  buildButton(

                    text: "Log In",

                    onPressed:
                    loginUser,
                  ),

                  const SizedBox(height: 28),

                  // FORGOT PASSWORD

                  Row(

                    mainAxisAlignment:
                    MainAxisAlignment.center,

                    children: [

                      const Text(

                        "Forgot Password?",

                        style: TextStyle(

                          fontWeight:
                          FontWeight.w600,

                          color: Colors.black87,
                        ),
                      ),

                      const SizedBox(width: 8),

                      GestureDetector(

                        onTap: () {

                          Navigator.push(

                            context,

                            MaterialPageRoute(

                              builder: (context) =>
                                  ResetScreen(

                                email:
                                emailController
                                    .text
                                    .trim(),
                              ),
                            ),
                          );
                        },

                        child: const Text(

                          "Reset",

                          style: TextStyle(

                            fontWeight:
                            FontWeight.bold,

                            color: Colors.black,

                            fontSize: 16,
                          ),
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
    );
  }

  // -----------------------------------------
  // EMAIL FIELD
  // -----------------------------------------

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
        BorderRadius.circular(12),

        border: Border.all(

          color: Colors.black,

          width: 1.3,
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

  // -----------------------------------------
  // PASSWORD FIELD
  // -----------------------------------------

  Widget buildPasswordField() {

    return Container(

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

      child: TextField(

        controller:
        passwordController,

        obscureText:
        obscurePassword,

        decoration: InputDecoration(

          hintText: "Password",

          prefixIcon: const Icon(

            Icons.lock,

            color: Colors.black87,
          ),

          suffixIcon: IconButton(

            onPressed: () {

              setState(() {

                obscurePassword =
                !obscurePassword;

              });

            },

            icon: Icon(

              obscurePassword

                  ? Icons.visibility_off
                  : Icons.visibility,

              color: Colors.black87,
            ),
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

  // -----------------------------------------
  // BUTTON
  // -----------------------------------------

  Widget buildButton({

    required String text,

    required VoidCallback
    onPressed,

  }) {

    return SizedBox(

      width: 180,
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

            fontSize: 20,

            fontWeight:
            FontWeight.bold,

            color: Colors.black,
          ),
        ),
      ),
    );
  }
}