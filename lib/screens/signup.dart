import 'package:flutter/material.dart';
import 'home.dart';
import 'login.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  final TextEditingController nameController =
      TextEditingController();

  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

 

  Future<void> signupUser() async {

    String name =
        nameController.text.trim();

    String email =
        emailController.text.trim();

    String password =
        passwordController.text.trim();

    String confirmPassword =
        confirmPasswordController.text.trim();

    // CHECK EMPTY FIELDS

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(

        const SnackBar(
          content: Text(
            "Please fill all fields",
          ),
        ),
      );

      return;
    }

    // CHECK PASSWORD MATCH

    if (password != confirmPassword) {

      ScaffoldMessenger.of(context).showSnackBar(

        const SnackBar(
          content: Text(
            "Passwords do not match",
          ),
        ),
      );

      return;
    }

    try {

      final response = await http.post(

        Uri.parse(
          "http://10.0.2.2:5000/signup",
        ),

        headers: {

          "Content-Type":
          "application/json",
        },

        body: jsonEncode({

          "name": name,

          "email": email,

          "password": password,
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

        Navigator.push(

          context,

          MaterialPageRoute(

            builder: (context) => HomeScreen(

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

                  const SizedBox(height: 40),

                  // LOGO

                  Image.asset(
                    "assets/logo.png",
                    height: 220,
                  ),

                  const SizedBox(height: 20),

                  // TITLE

                  const Text(

                    "Sign Up",

                    style: TextStyle(

                      fontSize: 32,

                      fontWeight:
                      FontWeight.bold,

                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 25),

                  // NAME FIELD

                  buildTextField(

                    controller:
                    nameController,

                    hint: "Name",

                    icon: Icons.person,
                  ),

                  const SizedBox(height: 18),

                  // EMAIL FIELD

                  buildTextField(

                    controller:
                    emailController,

                    hint: "Email",

                    icon: Icons.email,
                  ),

                  const SizedBox(height: 18),

                  // PASSWORD FIELD

                  buildPasswordField(

                    controller:
                    passwordController,

                    hint: "Password",

                    obscureText:
                    obscurePassword,

                    toggle: () {

                      setState(() {

                        obscurePassword =
                        !obscurePassword;

                      });

                    },
                  ),

                  const SizedBox(height: 18),

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

                  const SizedBox(height: 28),

                  // SIGNUP BUTTON

                  buildButton(

                    text: "Sign Up",

                    onPressed:
                    signupUser,
                  ),

                  const SizedBox(height: 18),

                  const Text(

                    "Already Have an Account?",

                    style: TextStyle(
                      fontWeight:
                      FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // LOGIN BUTTON

                  buildButton(

                    text: "Log In",

                    onPressed: () {

                      Navigator.push(

                        context,

                        MaterialPageRoute(

                          builder: (context) =>
                          const LoginScreen(),
                        ),
                      );

                    },
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  

  Widget buildTextField({

    required TextEditingController controller,

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

  

  Widget buildPasswordField({

    required TextEditingController controller,

    required String hint,

    required bool obscureText,

    required VoidCallback toggle,

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
