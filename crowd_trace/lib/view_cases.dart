// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
//
// class ViewCasesPage extends StatefulWidget {
//   const ViewCasesPage({super.key});
//
//   @override
//   State<ViewCasesPage> createState() => _ViewCasesPageState();
// }
//
// class _ViewCasesPageState extends State<ViewCasesPage>
//     with SingleTickerProviderStateMixin {
//
//   static const Color navyDark = Color(0xFF0A1F5C);
//   static const Color navyMid = Color(0xFF1A3A8C);
//   static const Color navyLight = Color(0xFF2756C5);
//   static const Color offWhite = Color(0xFFF0F4FF);
//   static const Color hintGrey = Color(0xFF8FA3BF);
//
//   List cases = [];
//   bool loading = true;
//
//   late AnimationController _animController;
//   late Animation<double> _fadeAnim;
//
//   String fullscreenImage = "";
//
//   @override
//   void initState() {
//     super.initState();
//
//     _animController =
//         AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
//
//     _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
//
//     _animController.forward();
//
//     loadCases();
//   }
//
//   Future loadCases() async {
//
//     SharedPreferences sh = await SharedPreferences.getInstance();
//     String url = sh.getString("url").toString();
//     String lid = sh.getString("lid").toString();
//
//     var uri = Uri.parse("$url/user_view_cases/");
//
//     var response = await http.post(uri, body: {
//       "lid": lid
//     });
//
//     var data = jsonDecode(response.body);
//
//     if (data['status'] == "ok") {
//
//       setState(() {
//         cases = data['data'];
//         loading = false;
//       });
//
//     }
//   }
//
//   Color statusColor(String status) {
//
//     status = status.toLowerCase();
//
//     if (status == "pending") return Colors.orange;
//
//     if (status == "processing") return Colors.blue;
//
//     if (status == "resolved") return Colors.green;
//
//     return Colors.grey;
//   }
//
//   void openImage(String url) {
//     setState(() {
//       fullscreenImage = url;
//     });
//   }
//
//   void closeImage() {
//     setState(() {
//       fullscreenImage = "";
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//
//       backgroundColor: offWhite,
//
//       body: Stack(
//
//         children: [
//
//           /// HEADER
//           Container(
//             height: MediaQuery.of(context).size.height * 0.28,
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
//             child: Column(
//               children: [
//
//                 const SizedBox(height: 20),
//
//                 FadeTransition(
//                   opacity: _fadeAnim,
//                   child: const Column(
//                     children: [
//
//                       Icon(Icons.folder_copy_outlined,
//                           size: 45, color: Colors.white),
//
//                       SizedBox(height: 10),
//
//                       Text(
//                         "My Filed Cases",
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 22,
//                           fontWeight: FontWeight.w800,
//                           letterSpacing: 1.2,
//                         ),
//                       ),
//
//                     ],
//                   ),
//                 ),
//
//                 const SizedBox(height: 20),
//
//                 Expanded(
//                   child: loading
//                       ? const Center(child: CircularProgressIndicator())
//                       : cases.isEmpty
//                       ? const Center(child: Text("No cases filed"))
//                       : FadeTransition(
//                     opacity: _fadeAnim,
//                     child: ListView.builder(
//
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 16, vertical: 10),
//
//                       itemCount: cases.length,
//
//                       itemBuilder: (context, index) {
//
//                         var c = cases[index];
//
//                         return Container(
//
//                           margin: const EdgeInsets.only(bottom: 18),
//
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(22),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: navyDark.withOpacity(0.08),
//                                 blurRadius: 20,
//                                 offset: const Offset(0, 10),
//                               )
//                             ],
//                           ),
//
//                           child: Padding(
//                             padding: const EdgeInsets.all(14),
//
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//
//                               children: [
//
//                                 /// IMAGE
//                                 if (c['photo'] != "")
//                                   GestureDetector(
//                                     onTap: () => openImage(c['photo']),
//                                     child: ClipRRect(
//                                       borderRadius: BorderRadius.circular(16),
//                                       child: Image.network(
//                                         c['photo'],
//                                         height: 160,
//                                         width: double.infinity,
//                                         fit: BoxFit.cover,
//                                       ),
//                                     ),
//                                   ),
//
//                                 const SizedBox(height: 10),
//
//                                 Text(
//                                   c['description'],
//                                   style: const TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w700,
//                                   ),
//                                 ),
//
//                                 const SizedBox(height: 10),
//
//                                 Row(
//                                   children: [
//
//                                     const Icon(Icons.local_police,
//                                         size: 18, color: navyLight),
//
//                                     const SizedBox(width: 6),
//
//                                     Expanded(
//                                       child: Text(
//                                         c['station'],
//                                         style: const TextStyle(fontSize: 14),
//                                       ),
//                                     )
//                                   ],
//                                 ),
//
//                                 const SizedBox(height: 8),
//
//                                 Row(
//                                   children: [
//
//                                     const Icon(Icons.calendar_today,
//                                         size: 16, color: hintGrey),
//
//                                     const SizedBox(width: 6),
//
//                                     Text(
//                                       c['date'],
//                                       style: const TextStyle(fontSize: 13),
//                                     )
//                                   ],
//                                 ),
//
//                                 const SizedBox(height: 12),
//
//                                 Row(
//                                   children: [
//
//                                     Container(
//                                       padding: const EdgeInsets.symmetric(
//                                           horizontal: 12, vertical: 6),
//
//                                       decoration: BoxDecoration(
//                                         color: statusColor(c['status'])
//                                             .withOpacity(0.15),
//                                         borderRadius: BorderRadius.circular(20),
//                                       ),
//
//                                       child: Text(
//                                         c['status'].toUpperCase(),
//                                         style: TextStyle(
//                                           color: statusColor(c['status']),
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                     ),
//
//                                     const SizedBox(width: 10),
//
//                                     Container(
//                                       padding: const EdgeInsets.symmetric(
//                                           horizontal: 12, vertical: 6),
//
//                                       decoration: BoxDecoration(
//                                         color: Colors.purple.withOpacity(0.15),
//                                         borderRadius: BorderRadius.circular(20),
//                                       ),
//
//                                       child: Text(
//                                         c['progress'],
//                                         style: const TextStyle(
//                                           color: Colors.purple,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                     )
//
//                                   ],
//                                 )
//
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//
//           /// FULLSCREEN IMAGE VIEWER
//           if (fullscreenImage != "")
//             GestureDetector(
//
//               onTap: closeImage,
//
//               child: Container(
//
//                 color: Colors.black.withOpacity(0.95),
//
//                 alignment: Alignment.center,
//
//                 child: InteractiveViewer(
//
//                   child: Image.network(
//                     fullscreenImage,
//                     fit: BoxFit.contain,
//                   ),
//
//                 ),
//
//               ),
//
//             )
//
//         ],
//       ),
//     );
//   }
// }


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ViewCasesPage extends StatefulWidget {
  const ViewCasesPage({super.key});

  @override
  State<ViewCasesPage> createState() => _ViewCasesPageState();
}

class _ViewCasesPageState extends State<ViewCasesPage>
    with SingleTickerProviderStateMixin {

  static const Color navyDark = Color(0xFF0A1F5C);
  static const Color navyMid = Color(0xFF1A3A8C);
  static const Color navyLight = Color(0xFF2756C5);
  static const Color offWhite = Color(0xFFF0F4FF);
  static const Color hintGrey = Color(0xFF8FA3BF);

  List cases = [];
  bool loading = true;

  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  String fullscreenImage = "";

  @override
  void initState() {
    super.initState();

    _animController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 800));

    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);

    _animController.forward();

    loadCases();
  }

  Future loadCases() async {

    SharedPreferences sh = await SharedPreferences.getInstance();

    String url = sh.getString("url").toString();
    String lid = sh.getString("lid").toString();

    var uri = Uri.parse("$url/user_view_cases/");

    var response = await http.post(uri, body: {
      "lid": lid
    });

    var data = jsonDecode(response.body);

    if (data['status'] == "ok") {

      setState(() {
        cases = data['data'];
        loading = false;
      });

    }
  }

  Color statusColor(String status) {
    status = status.toLowerCase();
    if (status == "pending")    return Colors.orange;
    if (status == "processing") return Colors.blue;
    if (status == "approved")   return Colors.blue;
    if (status == "resolved")   return Colors.green;
    if (status == "closed")     return Colors.green;
    if (status == "rejected")   return Colors.red;
    return Colors.grey;
  }

  void openImage(String url) {
    setState(() {
      fullscreenImage = url;
    });
  }

  void closeImage() {
    setState(() {
      fullscreenImage = "";
    });
  }

  Widget field(String title, String? value) {

    if (value == null || value.isEmpty) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        "$title : $value",
        style: const TextStyle(fontSize: 13),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: offWhite,

      body: Stack(

        children: [

          /// HEADER
          Container(
            height: MediaQuery.of(context).size.height * 0.28,
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
            child: Column(
              children: [

                const SizedBox(height: 20),

                FadeTransition(
                  opacity: _fadeAnim,
                  child: const Column(
                    children: [

                      Icon(Icons.folder_copy_outlined,
                          size: 45, color: Colors.white),

                      SizedBox(height: 10),

                      Text(
                        "My Filed Cases",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                        ),
                      ),

                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Expanded(
                  child: loading
                      ? const Center(child: CircularProgressIndicator())
                      : cases.isEmpty
                      ? const Center(child: Text("No cases filed"))
                      : FadeTransition(
                    opacity: _fadeAnim,
                    child: ListView.builder(

                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),

                      itemCount: cases.length,

                      itemBuilder: (context, index) {

                        var c = cases[index];

                        return Container(

                          margin: const EdgeInsets.only(bottom: 18),

                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: [
                              BoxShadow(
                                color: navyDark.withOpacity(0.08),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              )
                            ],
                          ),

                          child: Padding(
                            padding: const EdgeInsets.all(14),

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [

                                /// IMAGE
                                if (c['photo'] != "")
                                  GestureDetector(
                                    onTap: () => openImage(c['photo']),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Image.network(
                                        c['photo'],
                                        height: 160,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),

                                const SizedBox(height: 10),

                                Text(
                                  c['description'] ?? "",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),

                                const SizedBox(height: 10),

                                /// PERSON DETAILS
                                field("Name", c['name']),
                                field("Phone", c['phone']),
                                field("Email", c['email']),
                                field("Address", c['address']),

                                const SizedBox(height: 6),

                                /// MISSING DETAILS
                                field("Missing Place", c['missing_place']),
                                field("Age", c['age']),
                                field("DOB", c['date_of_birth']),
                                field("Gender", c['gender']),
                                field("Parent", c['parent_name']),

                                const SizedBox(height: 6),

                                /// IDENTIFICATION
                                field("Items Carried", c['items_carried']),
                                field("Height", c['height']),
                                field("Identification Marks", c['identification_marks']),
                                field("Clothes / Ornaments", c['clothes_ornaments']),

                                const SizedBox(height: 10),

                                Row(
                                  children: [

                                    const Icon(Icons.local_police,
                                        size: 18, color: navyLight),

                                    const SizedBox(width: 6),

                                    Expanded(
                                      child: Text(
                                        c['station'] ?? "",
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    )
                                  ],
                                ),

                                const SizedBox(height: 8),

                                Row(
                                  children: [

                                    const Icon(Icons.calendar_today,
                                        size: 16, color: hintGrey),

                                    const SizedBox(width: 6),

                                    Text(
                                      c['date'] ?? "",
                                      style: const TextStyle(fontSize: 13),
                                    )
                                  ],
                                ),

                                const SizedBox(height: 12),

                                Row(
                                  children: [

                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),

                                      decoration: BoxDecoration(
                                        color: statusColor(c['status'] ?? "")
                                            .withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(20),
                                      ),

                                      child: Text(
                                        (c['status'] ?? "").toUpperCase(),
                                        style: TextStyle(
                                          color: statusColor(c['status'] ?? ""),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),

                                    const SizedBox(width: 10),

                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),

                                      decoration: BoxDecoration(
                                        color: Colors.purple.withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(20),
                                      ),

                                      child: Text(
                                        c['progress'] ?? "",
                                        style: const TextStyle(
                                          color: Colors.purple,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )

                                  ],
                                ),

                                /// FINAL REPORT (shown only when case is closed/found)
                                if ((c['report'] ?? '').toString().isNotEmpty) ...
                                  [
                                    const SizedBox(height: 12),
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.green.withOpacity(0.08),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                            color: Colors.green.withOpacity(0.4)),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Row(
                                            children: [
                                              Icon(Icons.check_circle,
                                                  size: 14,
                                                  color: Colors.green),
                                              SizedBox(width: 5),
                                              Text(
                                                "Investigation Report",
                                                style: TextStyle(
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            c['report'],
                                            style: const TextStyle(
                                                fontSize: 13,
                                                color: Colors.black87),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          ),

          /// FULLSCREEN IMAGE VIEWER
          if (fullscreenImage != "")
            GestureDetector(

              onTap: closeImage,

              child: Container(

                color: Colors.black.withOpacity(0.95),

                alignment: Alignment.center,

                child: InteractiveViewer(

                  child: Image.network(
                    fullscreenImage,
                    fit: BoxFit.contain,
                  ),

                ),

              ),

            )

        ],
      ),
    );
  }
}
