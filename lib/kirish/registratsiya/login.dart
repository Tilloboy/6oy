import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:oltinchi_oy_imtihon_oddiygina/Home_page/Home.dart';
import 'package:oltinchi_oy_imtihon_oddiygina/kirish/registratsiya/register.dart';

class Login extends StatefulWidget {
  final String savedLogin;
  final String savedPassword;

  const Login(
      {super.key, required this.savedLogin, required this.savedPassword});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController loginController = TextEditingController();
  final TextEditingController parolController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Sahifaga kirganda Snackbar ko'rsatish
    Future.delayed(Duration.zero, () {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Malumotlar muvaffiyatli saqlandi"),
          duration: Duration(seconds: 2),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 0, 106, 255),
              Color.fromARGB(255, 222, 36, 191)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.1, 0.8],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    _buildTextField("Login", loginController),
                    const SizedBox(height: 20),
                    _buildTextField("Parol", parolController, isPassword: true),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        print("Login: ${loginController.text}");
                        print("Parol: ${parolController.text}");

                        // Check if the login and password match the registration info
                        if (loginController.text == widget.savedLogin &&
                            parolController.text == widget.savedPassword) {
                          // Successfully logged in, navigate to the next page (e.g., Home)
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Homepage(
                                familiya: familiyaController.text,
                                ism: ismController.text,
                              ),
                            ), // NextPage is just a placeholder
                          );
                        } else {
                          // If credentials are incorrect, navigate to the registration page
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                     RegistratsiyaPage()), // Registration page
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding:  EdgeInsets.symmetric(
                            horizontal: 23, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      child: const Text(
                        "Kirish",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool isPassword = false}) {
    return Container(
      width: double.infinity,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white, width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 10),
          child: Container(
            color: Colors.white.withOpacity(0.2),
            child: Center(
              child: TextField(
                controller: controller,
                obscureText: isPassword,
                decoration: InputDecoration(
                  labelText: label,
                  labelStyle: const TextStyle(color: Colors.black),
                  filled: false,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
