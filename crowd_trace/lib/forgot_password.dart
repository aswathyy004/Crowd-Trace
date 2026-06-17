import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage>
    with SingleTickerProviderStateMixin {

  // Navy theme (same as login page)
  static const Color navyDark = Color(0xFF0A1F5C);
  static const Color navyMid = Color(0xFF1A3A8C);
  static const Color navyLight = Color(0xFF2756C5);
  static const Color snowWhite = Color(0xFFFFFFFF);
  static const Color offWhite = Color(0xFFF0F4FF);
  static const Color hintGrey = Color(0xFF8FA3BF);

  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmController = TextEditingController();

  bool loading = false;

  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);

    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));

    _animController.forward();
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmController.dispose();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: offWhite,
      body: Stack(
        children: [

          /// Top gradient background
          Container(
            height: MediaQuery.of(context).size.height * 0.35,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [navyDark, navyMid],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [

                  const SizedBox(height: 30),

                  /// Title
                  FadeTransition(
                    opacity: _fadeAnim,
                    child: Column(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: snowWhite.withOpacity(0.15),
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: snowWhite.withOpacity(0.4), width: 2),
                          ),
                          child: const Icon(Icons.lock_reset,
                              size: 40, color: snowWhite),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          "RESET PASSWORD",
                          style: TextStyle(
                            color: snowWhite,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 3,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Verify your account to continue",
                          style: TextStyle(
                            color: snowWhite.withOpacity(0.75),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  /// Card
                  SlideTransition(
                    position: _slideAnim,
                    child: FadeTransition(
                      opacity: _fadeAnim,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 28, vertical: 36),
                        decoration: BoxDecoration(
                          color: snowWhite,
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: navyDark.withOpacity(0.12),
                              blurRadius: 30,
                              offset: const Offset(0, 10),
                            )
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            const Text(
                              "Forgot Password",
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  color: navyDark),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              "Enter your account details",
                              style: TextStyle(color: hintGrey),
                            ),

                            const SizedBox(height: 28),

                            _buildLabel("Username"),
                            const SizedBox(height: 8),
                            _buildTextField(
                                usernameController,
                                "Enter your username",
                                Icons.person_outline),

                            const SizedBox(height: 20),

                            _buildLabel("Email"),
                            const SizedBox(height: 8),
                            _buildTextField(
                                emailController,
                                "Enter your email",
                                Icons.email_outlined),

                            const SizedBox(height: 20),

                            _buildLabel("New Password"),
                            const SizedBox(height: 8),
                            _buildTextField(
                                passwordController,
                                "Enter new password",
                                Icons.lock_outline,
                                true),

                            const SizedBox(height: 20),

                            _buildLabel("Confirm Password"),
                            const SizedBox(height: 8),
                            _buildTextField(
                                confirmController,
                                "Confirm password",
                                Icons.lock_outline,
                                true),

                            const SizedBox(height: 30),

                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ElevatedButton(
                                onPressed: loading ? null : send_data,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: navyDark,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                child: loading
                                    ? const CircularProgressIndicator(
                                    color: snowWhite)
                                    : const Text(
                                  "UPDATE PASSWORD",
                                  style: TextStyle(
                                      color: snowWhite,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.2),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  Text(
                    "Helping communities find their loved ones",
                    style: TextStyle(
                        color: navyMid.withOpacity(0.6),
                        fontStyle: FontStyle.italic,
                        fontSize: 12),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 13,
          letterSpacing: 0.5,
          color: navyDark),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String hint, IconData icon,
      [bool password = false]) {
    return TextField(
      controller: controller,
      obscureText: password,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: navyLight),
        filled: true,
        fillColor: offWhite,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: navyLight.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: navyLight, width: 2),
        ),
      ),
    );
  }

  void send_data() async {

    String username = usernameController.text;
    String email = emailController.text;
    String password = passwordController.text;
    String confirm = confirmController.text;

    if (password != confirm) {
      Fluttertoast.showToast(msg: "Password mismatch");
      return;
    }

    setState(() {
      loading = true;
    });

    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString("url").toString();

    var uri = Uri.parse("$url/user_forgot_password/");

    try {

      var response = await http.post(uri, body: {
        "username": username,
        "email": email,
        "password": password,
        "confirm_password": confirm
      });

      var data = jsonDecode(response.body);

      if (data['status'] == "ok") {
        Fluttertoast.showToast(msg: "Password Updated");
        Navigator.pop(context);
      } else {
        Fluttertoast.showToast(msg: data['message']);
      }

    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }

    setState(() {
      loading = false;
    });
  }
}