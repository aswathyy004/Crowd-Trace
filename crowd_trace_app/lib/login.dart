// import 'dart:convert';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'home.dart';
// import 'register.dart';
// import 'forgot_password.dart';
// import 'guesthome.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Missing Person Identification System',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0A1F5C)),
//         useMaterial3: true,
//         fontFamily: 'Roboto',
//       ),
//       home: const LoginPage(title: ''),
//     );
//   }
// }
//
// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key, required this.title});
//   final String title;
//
//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }
//
// class _LoginPageState extends State<LoginPage>
//     with SingleTickerProviderStateMixin {
//
//   static const Color navyDark = Color(0xFF0A1F5C);
//   static const Color navyMid = Color(0xFF1A3A8C);
//   static const Color navyLight = Color(0xFF2756C5);
//   static const Color snowWhite = Color(0xFFFFFFFF);
//   static const Color offWhite = Color(0xFFF0F4FF);
//   static const Color hintGrey = Color(0xFF8FA3BF);
//
//   final TextEditingController usernamecontroller = TextEditingController();
//   final TextEditingController passwordcontroller = TextEditingController();
//
//   bool _obscurePassword = true;
//   bool _isLoading = false;
//
//   late AnimationController _animController;
//   late Animation<double> _fadeAnim;
//   late Animation<Offset> _slideAnim;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _animController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 900),
//     );
//
//     _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
//
//     _slideAnim = Tween<Offset>(
//       begin: const Offset(0, 0.12),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
//
//     _animController.forward();
//   }
//
//   @override
//   void dispose() {
//     _animController.dispose();
//     usernamecontroller.dispose();
//     passwordcontroller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: offWhite,
//       body: Stack(
//         children: [
//
//           Container(
//             height: MediaQuery.of(context).size.height * 0.40,
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [navyDark, navyMid],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//               borderRadius: BorderRadius.only(
//                 bottomLeft: Radius.circular(40),
//                 bottomRight: Radius.circular(40),
//               ),
//             ),
//           ),
//
//           SafeArea(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.symmetric(horizontal: 24),
//               child: Column(
//                 children: [
//
//                   const SizedBox(height: 30),
//
//                   FadeTransition(
//                     opacity: _fadeAnim,
//                     child: Column(
//                       children: [
//
//                         Container(
//                           width: 80,
//                           height: 80,
//                           decoration: BoxDecoration(
//                             color: snowWhite.withOpacity(0.15),
//                             shape: BoxShape.circle,
//                             border: Border.all(
//                                 color: snowWhite.withOpacity(0.4), width: 2),
//                           ),
//                           child: const Icon(Icons.shield_outlined,
//                               size: 42, color: snowWhite),
//                         ),
//
//                         const SizedBox(height: 14),
//
//                         const Text(
//                           'MISSING PERSON',
//                           style: TextStyle(
//                             color: snowWhite,
//                             fontSize: 20,
//                             fontWeight: FontWeight.w800,
//                             letterSpacing: 3,
//                           ),
//                         ),
//
//                         const SizedBox(height: 4),
//
//                         Text(
//                           'Identification System',
//                           style: TextStyle(
//                             color: snowWhite.withOpacity(0.75),
//                             fontSize: 13,
//                             letterSpacing: 1.2,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//
//                   const SizedBox(height: 36),
//
//                   SlideTransition(
//                     position: _slideAnim,
//                     child: FadeTransition(
//                       opacity: _fadeAnim,
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 28, vertical: 36),
//                         decoration: BoxDecoration(
//                           color: snowWhite,
//                           borderRadius: BorderRadius.circular(28),
//                           boxShadow: [
//                             BoxShadow(
//                               color: navyDark.withOpacity(0.12),
//                               blurRadius: 30,
//                               offset: const Offset(0, 10),
//                             ),
//                           ],
//                         ),
//
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//
//                             const Text(
//                               'Welcome Back',
//                               style: TextStyle(
//                                 color: navyDark,
//                                 fontSize: 24,
//                                 fontWeight: FontWeight.w800,
//                               ),
//                             ),
//
//                             const SizedBox(height: 4),
//
//                             Text(
//                               'Sign in to your account to continue',
//                               style: TextStyle(color: hintGrey, fontSize: 13),
//                             ),
//
//                             const SizedBox(height: 28),
//
//                             _buildLabel('Username'),
//
//                             const SizedBox(height: 8),
//
//                             _buildTextField(
//                               controller: usernamecontroller,
//                               hint: 'Enter your username',
//                               icon: Icons.person_outline,
//                             ),
//
//                             const SizedBox(height: 20),
//
//                             _buildLabel('Password'),
//
//                             const SizedBox(height: 8),
//
//                             _buildTextField(
//                               controller: passwordcontroller,
//                               hint: 'Enter your password',
//                               icon: Icons.lock_outline,
//                               isPassword: true,
//                             ),
//
//                             Align(
//                               alignment: Alignment.centerRight,
//                               child: TextButton(
//                                 onPressed: () {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) =>
//                                       const ForgotPasswordPage(),
//                                     ),
//                                   );
//                                 },
//                                 child: const Text(
//                                   "Forgot Password?",
//                                   style: TextStyle(
//                                     color: navyLight,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                               ),
//                             ),
//
//                             const SizedBox(height: 10),
//
//                             SizedBox(
//                               width: double.infinity,
//                               height: 52,
//                               child: ElevatedButton(
//                                 onPressed: _isLoading ? null : send_data,
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: navyDark,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(14),
//                                   ),
//                                 ),
//                                 child: const Text('LOGIN'),
//                               ),
//                             ),
//
//                             const SizedBox(height: 16),
//
//                             SizedBox(
//                               width: double.infinity,
//                               height: 52,
//                               child: OutlinedButton(
//                                 onPressed: () {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (context) => RegisterPage()),
//                                   );
//                                 },
//                                 style: OutlinedButton.styleFrom(
//                                   side: const BorderSide(
//                                       color: navyDark, width: 1.8),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(14),
//                                   ),
//                                 ),
//                                 child: const Text('CREATE ACCOUNT'),
//                               ),
//                             ),
//
//                             const SizedBox(height: 16),
//
//                             SizedBox(
//                               width: double.infinity,
//                               height: 52,
//                               child: OutlinedButton(
//                                 onPressed: () {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) =>
//                                       const GuestHomePage(),
//                                     ),
//                                   );
//                                 },
//                                 style: OutlinedButton.styleFrom(
//                                   side: const BorderSide(
//                                       color: navyDark, width: 1.8),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(14),
//                                   ),
//                                 ),
//                                 child: const Text('ENTER AS GUEST'),
//                               ),
//                             ),
//
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildLabel(String text) {
//     return Text(
//       text,
//       style: const TextStyle(
//         color: navyDark,
//         fontSize: 13,
//         fontWeight: FontWeight.w600,
//       ),
//     );
//   }
//
//   /// UPDATED TEXTFIELD WITH PASSWORD SHOW/HIDE ICON
//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String hint,
//     required IconData icon,
//     bool isPassword = false,
//   }) {
//     return TextFormField(
//       controller: controller,
//       obscureText: isPassword ? _obscurePassword : false,
//       decoration: InputDecoration(
//         hintText: hint,
//         prefixIcon: Icon(icon),
//         suffixIcon: isPassword
//             ? IconButton(
//           icon: Icon(
//             _obscurePassword
//                 ? Icons.visibility_off
//                 : Icons.visibility,
//           ),
//           onPressed: () {
//             setState(() {
//               _obscurePassword = !_obscurePassword;
//             });
//           },
//         )
//             : null,
//       ),
//     );
//   }
//
//   void send_data() async {
//
//     String username = usernamecontroller.text;
//     String password = passwordcontroller.text;
//
//     setState(() => _isLoading = true);
//
//     SharedPreferences sh = await SharedPreferences.getInstance();
//     String url = sh.getString('url').toString();
//
//     final urls = Uri.parse('$url/user_login/');
//
//     final response = await http.post(urls, body: {
//       'username': username,
//       'password': password,
//     });
//
//     if (response.statusCode == 200) {
//
//       String status = jsonDecode(response.body)['status'];
//
//       if (status == 'ok') {
//
//         String lid = jsonDecode(response.body)['lid'];
//         sh.setString("lid", lid);
//
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => Home_page()),
//         );
//
//       } else {
//
//         Fluttertoast.showToast(msg: 'Not Found');
//
//       }
//
//     }
//
//     setState(() => _isLoading = false);
//
//   }
// }


import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'home.dart';
import 'register.dart';
import 'forgot_password.dart';
import 'guesthome.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Missing Person Identification System',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0A1F5C)),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const LoginPage(title: ''),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});
  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {

  static const Color navyDark = Color(0xFF0A1F5C);
  static const Color navyMid = Color(0xFF1A3A8C);
  static const Color navyLight = Color(0xFF2756C5);
  static const Color snowWhite = Color(0xFFFFFFFF);
  static const Color offWhite = Color(0xFFF0F4FF);
  static const Color hintGrey = Color(0xFF8FA3BF);

  final TextEditingController usernamecontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

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
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    usernamecontroller.dispose();
    passwordcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: offWhite,
      body: Stack(
        children: [

          Container(
            height: MediaQuery.of(context).size.height * 0.40,
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
                          child: const Icon(Icons.shield_outlined,
                              size: 42, color: snowWhite),
                        ),

                        const SizedBox(height: 14),

                        const Text(
                          'MISSING PERSON',
                          style: TextStyle(
                            color: snowWhite,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 3,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          'Identification System',
                          style: TextStyle(
                            color: snowWhite.withOpacity(0.75),
                            fontSize: 13,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 36),

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
                            ),
                          ],
                        ),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            const Text(
                              'Welcome Back',
                              style: TextStyle(
                                color: navyDark,
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              'Sign in to your account to continue',
                              style: TextStyle(color: hintGrey, fontSize: 13),
                            ),

                            const SizedBox(height: 28),

                            _buildLabel('Username'),

                            const SizedBox(height: 8),

                            _buildTextField(
                              controller: usernamecontroller,
                              hint: 'Enter your username',
                              icon: Icons.person_outline,
                            ),

                            const SizedBox(height: 20),

                            _buildLabel('Password'),

                            const SizedBox(height: 8),

                            _buildTextField(
                              controller: passwordcontroller,
                              hint: 'Enter your password',
                              icon: Icons.lock_outline,
                              isPassword: true,
                            ),

                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                      const ForgotPasswordPage(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  "Forgot Password?",
                                  style: TextStyle(
                                    color: navyLight,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 10),

                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : send_data,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: navyDark,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                child: const Text('LOGIN'),
                              ),
                            ),

                            const SizedBox(height: 16),

                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => RegisterPage()),
                                  );
                                },
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                      color: navyDark, width: 1.8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                child: const Text('CREATE ACCOUNT'),
                              ),
                            ),

                            const SizedBox(height: 16),

                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                      const GuestHomePage(),
                                    ),
                                  );
                                },
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                      color: navyDark, width: 1.8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                child: const Text('ENTER AS GUEST'),
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
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: navyDark,
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  /// UPDATED TEXTFIELD WITH PASSWORD SHOW/HIDE ICON
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ? _obscurePassword : false,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon),
        suffixIcon: isPassword
            ? IconButton(
          icon: Icon(
            _obscurePassword
                ? Icons.visibility_off
                : Icons.visibility,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        )
            : null,
      ),
    );
  }

  void send_data() async {

    String username = usernamecontroller.text;
    String password = passwordcontroller.text;

    setState(() => _isLoading = true);

    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url').toString();

    final urls = Uri.parse('$url/user_login/');

    final response = await http.post(urls, body: {
      'username': username,
      'password': password,
    });

    if (response.statusCode == 200) {

      String status = jsonDecode(response.body)['status'];

      if (status == 'ok') {

        String lid = jsonDecode(response.body)['lid'];
        sh.setString("lid", lid);
        sh.setString("user_name", username);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Home_page()),
        );

      } else {

        Fluttertoast.showToast(msg: 'Not Found');

      }

    }

    setState(() => _isLoading = false);

  }
}