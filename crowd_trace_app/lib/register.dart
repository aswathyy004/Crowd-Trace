import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController placeController = TextEditingController();
  final TextEditingController aadharController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    emailController.dispose();
    phoneController.dispose();
    placeController.dispose();
    aadharController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> sendData() async {

    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        phoneController.text.isEmpty ||
        usernameController.text.isEmpty ||
        passwordController.text.isEmpty) {

      Fluttertoast.showToast(msg: "Please fill all required fields");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String? url = sh.getString('url');

      if (url == null) {
        Fluttertoast.showToast(msg: "Server IP not set");
        return;
      }

      final uri = Uri.parse("$url/user_register/");

      final response = await http.post(
        uri,
        body: {
          "name": nameController.text,
          "address": addressController.text,
          "email": emailController.text,
          "place": placeController.text,
          "phone": phoneController.text,
          "aadhar": aadharController.text,
          "username": usernameController.text,
          "password": passwordController.text,
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        String status = jsonData['status'];

        if (status == "ok") {

          Fluttertoast.showToast(msg: "Registration Successful");

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage(title: 'heelooo',)),
          );

        } else {
          Fluttertoast.showToast(msg: jsonData['message'] ?? "Registration Failed");
        }
      } else {
        Fluttertoast.showToast(msg: "Server Error");
      }

    } catch (e) {
      Fluttertoast.showToast(msg: "Error: ${e.toString()}");
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            buildTextField(nameController, "Name"),
            buildTextField(addressController, "Address"),
            buildTextField(emailController, "Email", TextInputType.emailAddress),
            buildTextField(placeController, "Place"),
            buildTextField(aadharController, "Aadhar Number", TextInputType.number),
            buildTextField(phoneController, "Phone Number", TextInputType.phone),
            buildTextField(usernameController, "Username"),
            buildTextField(passwordController, "Password", TextInputType.text, true),

            const SizedBox(height: 20),

            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: sendData,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text("Sign Up"),
            ),

            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage(title: 'helooo',)),
                );
              },
              child: const Text("Already have an account? Login"),
            )

          ],
        ),
      ),
    );
  }

  Widget buildTextField(
      TextEditingController controller,
      String label,
      [TextInputType type = TextInputType.text,
        bool obscure = false]) {

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        keyboardType: type,
        obscureText: obscure,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
