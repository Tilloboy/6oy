import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:oltinchi_oy_imtihon_oddiygina/kirish/registratsiya/login.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import Login page

final TextEditingController familiyaController = TextEditingController();
final TextEditingController ismController = TextEditingController();
final TextEditingController loginController = TextEditingController();
final TextEditingController parolController = TextEditingController();

class RegistratsiyaPage extends StatefulWidget {
  const RegistratsiyaPage({super.key});

  @override
  State<RegistratsiyaPage> createState() => _RegistratsiyaPageState();
}

class _RegistratsiyaPageState extends State<RegistratsiyaPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false; // To track password visibility

  // Formani tasdiqlash va ma'lumotlarni SharedPreferencesga saqlash
  Future<void> saveUserData() async {
    final prefs = await SharedPreferences.getInstance();

    final String savedFamiliya = familiyaController.text;
    final String savedIsm = ismController.text;
    final String savedLogin = loginController.text;
    final String savedPassword = parolController.text;

    // Saqlash
    await prefs.setString('familiya', savedFamiliya);
    await prefs.setString('ism', savedIsm);
    await prefs.setString('login', savedLogin);
    await prefs.setString('parol', savedPassword);

    // Keyin Login sahifasiga o'tish
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Login(
          savedLogin: savedLogin,
          savedPassword: savedPassword,
        ),
      ),
    ).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Malumotlar muvaffaqiyatli saqlandi"),
          duration: Duration(seconds: 2),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF008FFF),
                  Color(0xFFDF1AFA),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          title: const Center(
            child: Text(
              "Ro'yxatdan o'tish",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 153, 0, 255),
              Color(0xFFDF1AFA),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            stops: [0.1, 0.8],
          ),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 200),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                child: Center(
                  child: Lottie.asset(
                    'lottifor/2.json',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      _buildTextField("Familiya", familiyaController),
                      const SizedBox(height: 20),
                      _buildTextField("Ism", ismController),
                      const SizedBox(height: 20),
                      _buildTextField("Login", loginController),
                      const SizedBox(height: 20),
                      _buildTextField("Parol", parolController,
                          isPassword: true),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            // Ma'lumotlarni saqlash
                            await saveUserData();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF912CC8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        child: const Text(
                          "Saqlash",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // TextFormFieldni yaratish
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
              child: TextFormField(
                controller: controller,
                obscureText: isPassword &&
                    !_isPasswordVisible, // Toggle visibility based on the variable
                decoration: InputDecoration(
                  labelText: label,
                  labelStyle: const TextStyle(color: Colors.black),
                  filled: false,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  suffixIcon: isPassword
                      ? GestureDetector(
                          onTap: () {
                            setState(() {
                              _isPasswordVisible =
                                  !_isPasswordVisible; // Toggle password visibility
                            });
                          },
                          child: Text(
                            _isPasswordVisible ? "🙉" : "🙈",
                            style: TextStyle(fontSize: 35),
                          ),
                        )
                      : null,
                ),
                style: const TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '$label maydoni bo\'sh bo\'lmasligi kerak';
                  }
                  return null;
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
