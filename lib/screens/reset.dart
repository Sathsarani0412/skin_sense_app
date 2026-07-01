import 'package:flutter/material.dart';
import 'home.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ResetScreen extends StatefulWidget {

  final String email;

  const ResetScreen({
    super.key,
    required this.email,
  });

  @override
  State<ResetScreen> createState() =>
      _ResetScreenState();
}

class _ResetScreenState
    extends State<ResetScreen> {

  final TextEditingController
  newPasswordController =
      TextEditingController();

  final TextEditingController
  confirmPasswordController =
      TextEditingController();

  bool obscureNewPassword = true;

  bool obscureConfirmPassword = true;



  Future<void> resetPassword() async {

    String newPassword =
        newPasswordController.text.trim();

    String confirmPassword =
        confirmPasswordController.text.trim();

    // EMPTY CHECK

    if (newPassword.isEmpty ||
        confirmPassword.isEmpty) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(
          content:
          Text("Please fill all fields"),
        ),
      );

      return;
    }

    // PASSWORD MATCH CHECK

    if (newPassword != confirmPassword) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(
          content:
          Text("Passwords do not match"),
        ),
      );

      return;
    }

    try {

      final response = await http.post(

        Uri.parse(
          "http://10.0.2.2:5000/reset_password",
        ),

        headers: {
          "Content-Type":
          "application/json",
        },

        body: jsonEncode({

          "email": widget.email,

          "new_password":
          newPassword,

        }),
      );

      final data =
      jsonDecode(response.body);

      if (data["success"] == true) {

        ScaffoldMessenger.of(context)
            .showSnackBar(

          SnackBar(
            content:
            Text(data["message"]),
          ),
        );

        Navigator.push(

          context,

          MaterialPageRoute(

            builder: (context) => HomeScreen(

              name: data["name"] ?? "",

              email:
              data["email"] ?? widget.email,
            ),
          ),
        );

      } else {

        ScaffoldMessenger.of(context)
            .showSnackBar(

          SnackBar(
            content:
            Text(data["message"]),
          ),
        );
      }

    } catch (e) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(
          content:
          Text("Error: $e"),
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

                  const SizedBox(height: 20),

                  // TITLE

                  const Text(

                    "Reset Password",

                    textAlign: TextAlign.center,

                    style: TextStyle(

                      fontSize: 30,

                      fontWeight:
                      FontWeight.bold,

                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 35),

                  // NEW PASSWORD

                  buildPasswordField(

                    controller:
                    newPasswordController,

                    hint: "New Password",

                    obscureText:
                    obscureNewPassword,

                    toggle: () {

                      setState(() {

                        obscureNewPassword =
                        !obscureNewPassword;

                      });

                    },
                  ),

                  const SizedBox(height: 22),

                  // CONFIRM PASSWORD

                  buildPasswordField(

                    controller:
                    confirmPasswordController,

                    hint:
                    "Confirm Password",

                    obscureText:
                    obscureConfirmPassword,

                    toggle: () {

                      setState(() {

                        obscureConfirmPassword =
                        !obscureConfirmPassword;

                      });

                    },
                  ),

                  const SizedBox(height: 35),

                  // RESET BUTTON

                  buildButton(

                    text: "Reset",

                    onPressed:
                    resetPassword,
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


  Widget buildPasswordField({

    required TextEditingController
    controller,

    required String hint,

    required bool obscureText,

    required VoidCallback toggle,

  }) {

    return Container(

      decoration: BoxDecoration(

        color: const Color(0xFFD8C2F2),

        borderRadius:
        BorderRadius.circular(12),

        border: Border.all(
          color: Colors.black,
          width: 1.3,
        ),
      ),

      child: TextField(

        controller: controller,

        obscureText: obscureText,

        decoration: InputDecoration(

          hintText: hint,

          prefixIcon: const Icon(
            Icons.lock,
            color: Colors.black87,
          ),

          suffixIcon: IconButton(

            onPressed: toggle,

            icon: Icon(

              obscureText
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

  
  Widget buildButton({

    required String text,

    required VoidCallback onPressed,

  }) {

    return SizedBox(

      width: 180,
      height: 52,

      child: ElevatedButton(

        onPressed: onPressed,

        style: ElevatedButton.styleFrom(

          backgroundColor:
          const Color(0xFFD8C2F2),

          shape: RoundedRectangleBorder(

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
