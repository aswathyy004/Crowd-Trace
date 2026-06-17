// // // import 'dart:convert';
// // // import 'package:flutter/material.dart';
// // // import 'package:shared_preferences/shared_preferences.dart';
// // // import 'package:http/http.dart' as http;
// // //
// // // void main() {
// // //   runApp(const View_Police_Station(title: 'View Police Station'));
// // // }
// // //
// // //
// // // class View_Police_Station extends StatelessWidget {
// // //   const View_Police_Station({super.key, required this.title});
// // //   final String title;
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return MaterialApp(
// // //       debugShowCheckedModeBanner: false,
// // //       home: ViewPoliceSationpage(title: title),
// // //     );
// // //   }
// // // }
// // //
// // // class ViewPoliceSationpage extends StatefulWidget {
// // //   const ViewPoliceSationpage({super.key, required this.title});
// // //   final String title;
// // //
// // //   @override
// // //   State<ViewPoliceSationpage> createState() => _ViewPoliceState();
// // // }
// // //
// // // class _ViewPoliceState extends State<ViewPoliceSationpage> {
// // //   List<String> station_name_ = [];
// // //   List<String> station_head_ = [];
// // //   List<String> place_ = [];
// // //   List<String> phone_ = [];
// // //   List<String> latitude_ = [];
// // //   List<String> longitude_ = [];
// // //
// // //
// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     View_Police_Station();
// // //   }
// // //
// // //   Future<void> View_Police_Station() async {
// // //     try {
// // //       SharedPreferences sh = await SharedPreferences.getInstance();
// // //       String urls = sh.getString('url') ?? '';
// // //       String lid = sh.getString('lid') ?? '';
// // //
// // //       String url = '$urls/View_Police_Station/';
// // //
// // //       var response = await http.post(
// // //         Uri.parse(url),
// // //         body: {'lid': lid},
// // //       );
// // //
// // //       var jsonData = json.decode(response.body);
// // //
// // //       if (jsonData['status'] == 'ok') {
// // //         var arr = jsonData["data"];
// // //
// // //         List<String> station_name = [];
// // //         List<String> station_head = [];
// // //         List<String> place = [];
// // //         List<String> phone = [];
// // //         List<String> latitude = [];
// // //         List<String> longitude = [];
// // //
// // //         for (int i = 0; i < arr.length; i++) {
// // //           station_name.add(arr[i]['station_name'].toString());
// // //           station_head.add(arr[i]['station_head'].toString());
// // //           place.add(arr[i]['place'].toString());
// // //           phone.add(arr[i]['phone'].toString());
// // //           latitude.add(arr[i]['latitude'].toString());
// // //           longitude.add(arr[i]['longitude'].toString());
// // //         }
// // //
// // //         setState(() {
// // //           station_name_ = station_name;
// // //           station_head_ = station_head;
// // //           place_ = place;
// // //           phone_ = phone;
// // //           latitude_ = latitude;
// // //           longitude_ = longitude;
// // //         });
// // //       }
// // //     } catch (e) {
// // //       ScaffoldMessenger.of(context).showSnackBar(
// // //         SnackBar(content: Text("Error: $e")),
// // //       );
// // //     }
// // //   }
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         title: Text(widget.title),
// // //       ),
// // //       body: station_name_.isEmpty
// // //           ? const Center(child: Text("No police Station found"))
// // //           : ListView.builder(
// // //         itemCount: station_name_.length,
// // //         itemBuilder: (context, index) {
// // //           return Card(
// // //             margin: const EdgeInsets.all(10),
// // //             child: Padding(
// // //               padding: const EdgeInsets.all(15),
// // //               child: Column(
// // //                 crossAxisAlignment: CrossAxisAlignment.start,
// // //                 children: [
// // //                   Text("Station Name: ${station_name_[index]}"),
// // //                   const SizedBox(height: 8),
// // //                   Text("Station Head: ${station_head_[index]}"),
// // //                   const SizedBox(height: 4),
// // //                   Text("Place: ${place_[index]}"),
// // //                   const SizedBox(height: 4),
// // //                   Text("Phone: ${phone_[index]}"),
// // //                   const SizedBox(height: 4),
// // //                   Text("latitude: ${latitude_[index]}"),
// // //                   const SizedBox(height: 4),
// // //                   Text("longitude: ${longitude_[index]}"),
// // //                 ],
// // //               ),
// // //             ),
// // //           );
// // //         },
// // //       ),
// // //       floatingActionButton: FloatingActionButton(
// // //         onPressed: () {
// // //           View_Police_Station(); // refresh
// // //         },
// // //         child: const Icon(Icons.refresh),
// // //       ),
// // //     );
// // //   }
// // // }
// //
// //
// //
// //
// //
// //
// //
// // import 'dart:convert';
// // import 'package:flutter/material.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:http/http.dart' as http;
// // import 'ViewPolice.dart';
// //
// // void main() {
// //   runApp(const View_Police_Station(title: 'View Police Station'));
// // }
// //
// // class View_Police_Station extends StatelessWidget {
// //   const View_Police_Station({super.key, required this.title});
// //   final String title;
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       debugShowCheckedModeBanner: false,
// //       home: ViewPoliceSationpage(title: title),
// //     );
// //   }
// // }
// //
// // class ViewPoliceSationpage extends StatefulWidget {
// //   const ViewPoliceSationpage({super.key, required this.title});
// //   final String title;
// //
// //   @override
// //   State<ViewPoliceSationpage> createState() => _ViewPoliceState();
// // }
// //
// // class _ViewPoliceState extends State<ViewPoliceSationpage> {
// //
// //   List<String> station_id_ = [];
// //   List<String> station_name_ = [];
// //   List<String> station_head_ = [];
// //   List<String> place_ = [];
// //   List<String> phone_ = [];
// //   List<String> latitude_ = [];
// //   List<String> longitude_ = [];
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     View_Police_Station();
// //   }
// //
// //   Future<void> View_Police_Station() async {
// //     try {
// //       SharedPreferences sh = await SharedPreferences.getInstance();
// //       String urls = sh.getString('url') ?? '';
// //       String lid = sh.getString('lid') ?? '';
// //
// //       String url = '$urls/View_Police_Station/';
// //
// //       var response = await http.post(
// //         Uri.parse(url),
// //         body: {'lid': lid},
// //       );
// //
// //       var jsonData = json.decode(response.body);
// //
// //       if (jsonData['status'] == 'ok') {
// //         var arr = jsonData["data"];
// //
// //         List<String> station_id = [];
// //         List<String> station_name = [];
// //         List<String> station_head = [];
// //         List<String> place = [];
// //         List<String> phone = [];
// //         List<String> latitude = [];
// //         List<String> longitude = [];
// //
// //         for (int i = 0; i < arr.length; i++) {
// //
// //           station_id.add(arr[i]['id'].toString());
// //           print(arr[i]['id']);
// //           station_name.add(arr[i]['station_name'].toString());
// //           station_head.add(arr[i]['station_head'].toString());
// //           place.add(arr[i]['place'].toString());
// //           phone.add(arr[i]['phone'].toString());
// //           latitude.add(arr[i]['latitude'].toString());
// //           longitude.add(arr[i]['longitude'].toString());
// //         }
// //
// //         setState(() {
// //           station_id_ = station_id;
// //           station_name_ = station_name;
// //           station_head_ = station_head;
// //           place_ = place;
// //           phone_ = phone;
// //           latitude_ = latitude;
// //           longitude_ = longitude;
// //         });
// //       }
// //     } catch (e) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text("Error: $e")),
// //       );
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text(widget.title),
// //       ),
// //       body: station_name_.isEmpty
// //           ? const Center(child: Text("No police Station found"))
// //           : ListView.builder(
// //         itemCount: station_name_.length,
// //         itemBuilder: (context, index) {
// //           return Card(
// //             margin: const EdgeInsets.all(10),
// //             child: Padding(
// //               padding: const EdgeInsets.all(15),
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Text("Station Name: ${station_name_[index]}"),
// //                   const SizedBox(height: 8),
// //                   Text("Station Head: ${station_head_[index]}"),
// //                   const SizedBox(height: 4),
// //                   Text("Place: ${place_[index]}"),
// //                   const SizedBox(height: 4),
// //                   Text("Phone: ${phone_[index]}"),
// //                   const SizedBox(height: 4),
// //                   Text("latitude: ${latitude_[index]}"),
// //                   const SizedBox(height: 4),
// //                   Text("longitude: ${longitude_[index]}"),
// //
// //                   const SizedBox(height: 10),
// //
// //                   ElevatedButton(
// //                     onPressed: () {
// //                       Navigator.push(
// //                         context,
// //                         MaterialPageRoute(
// //                           builder: (context) => ViewPolicepage(
// //                             stationId: station_id_[index],
// //                           ),
// //                         ),
// //                       );
// //                     },
// //                     child: const Text("View Police"),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           );
// //         },
// //       ),
// //       floatingActionButton: FloatingActionButton(
// //         onPressed: () {
// //           View_Police_Station();
// //         },
// //         child: const Icon(Icons.refresh),
// //       ),
// //     );
// //   }
// // }
//
//
//
// import 'dart:convert';
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'package:url_launcher/url_launcher.dart';
// import 'package:geolocator/geolocator.dart';
// import 'ViewPolice.dart';
//
// // ─────────────────────────────────────────────────────────────────────────────
// //  ENTRY
// // ─────────────────────────────────────────────────────────────────────────────
// void main() {
//   runApp(const View_Police_Station(title: 'View Police Station'));
// }
//
// class View_Police_Station extends StatelessWidget {
//   const View_Police_Station({super.key, required this.title});
//   final String title;
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         fontFamily: 'Roboto',
//         colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0A1F5C)),
//         useMaterial3: true,
//       ),
//       home: ViewPoliceSationpage(title: title),
//     );
//   }
// }
//
// // ─────────────────────────────────────────────────────────────────────────────
// //  PAGE
// // ─────────────────────────────────────────────────────────────────────────────
// class ViewPoliceSationpage extends StatefulWidget {
//   const ViewPoliceSationpage({super.key, required this.title});
//   final String title;
//
//   @override
//   State<ViewPoliceSationpage> createState() => _ViewPoliceState();
// }
//
// class _ViewPoliceState extends State<ViewPoliceSationpage>
//     with TickerProviderStateMixin {
//
//   // ── Palette ──────────────────────────────────────────────────────────────
//   static const Color navyDark   = Color(0xFF0A1F5C);
//   static const Color navyMid    = Color(0xFF1A3A8C);
//   static const Color navyLight  = Color(0xFF2756C5);
//   static const Color navyAccent = Color(0xFF4A90E2);
//   static const Color snowWhite  = Color(0xFFFFFFFF);
//   static const Color offWhite   = Color(0xFFF0F4FF);
//   static const Color hintGrey   = Color(0xFF8FA3BF);
//   static const Color cardBorder = Color(0xFFDDE8FF);
//   static const Color successGreen= Color(0xFF2E7D32);
//   static const Color callGreen  = Color(0xFF43A047);
//   static const Color dirBlue    = Color(0xFF1565C0);
//
//   // ── Data ─────────────────────────────────────────────────────────────────
//   List<String> station_id_   = [];
//   List<String> station_name_ = [];
//   List<String> station_head_ = [];
//   List<String> place_        = [];
//   List<String> phone_        = [];
//   List<String> latitude_     = [];
//   List<String> longitude_    = [];
//
//   List<int>    _filteredIndexes = [];
//   List<double> _distances       = []; // km distances per station
//
//   bool   _isLoading    = true;
//   String _searchQuery  = '';
//   String _sortOption   = 'Default';
//
//   // Nearest station index (into original list)
//   int _nearestIndex = -1;
//
//   // User location
//   Position? _userPosition;
//
//   // Expanded card set
//   final Set<int> _expandedCards = {};
//
//   // Sort options
//   final List<String> _sortOptions = [
//     'Default', 'Name A–Z', 'Name Z–A', 'Place A–Z', 'Nearest First'
//   ];
//
//   // ── Controllers ──────────────────────────────────────────────────────────
//   final TextEditingController _searchController = TextEditingController();
//   final GlobalKey<ScaffoldState> _scaffoldKey   = GlobalKey<ScaffoldState>();
//
//   late AnimationController _bgOrbController;
//   late AnimationController _pulseController;
//   late Animation<double>   _pulseAnim;
//
//   final Map<int, AnimationController> _cardControllers = {};
//   final Map<int, Animation<double>>   _cardAnims       = {};
//
//   // ── Init ─────────────────────────────────────────────────────────────────
//   @override
//   void initState() {
//     super.initState();
//
//     _bgOrbController = AnimationController(
//         vsync: this, duration: const Duration(seconds: 8))
//       ..repeat(reverse: true);
//
//     _pulseController = AnimationController(
//         vsync: this, duration: const Duration(seconds: 2))
//       ..repeat(reverse: true);
//     _pulseAnim = Tween<double>(begin: 0.25, end: 1.0).animate(
//         CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));
//
//     _searchController.addListener(_onSearchChanged);
//     _getUserLocation();
//     _fetchStations();
//   }
//
//   @override
//   void dispose() {
//     _bgOrbController.dispose();
//     _pulseController.dispose();
//     _searchController.dispose();
//     for (var c in _cardControllers.values) c.dispose();
//     super.dispose();
//   }
//
//   // ── GPS ──────────────────────────────────────────────────────────────────
//   Future<void> _getUserLocation() async {
//     try {
//       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) return;
//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//         if (permission == LocationPermission.denied) return;
//       }
//       if (permission == LocationPermission.deniedForever) return;
//       final pos = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high);
//       setState(() => _userPosition = pos);
//       _computeDistances();
//     } catch (_) {}
//   }
//
//   void _computeDistances() {
//     if (_userPosition == null) return;
//     _distances = List.generate(station_name_.length, (i) {
//       try {
//         final lat = double.parse(latitude_[i]);
//         final lon = double.parse(longitude_[i]);
//         return Geolocator.distanceBetween(
//             _userPosition!.latitude, _userPosition!.longitude,
//             lat, lon) /
//             1000; // metres → km
//       } catch (_) {
//         return double.infinity;
//       }
//     });
//
//     // Find nearest
//     if (_distances.isNotEmpty) {
//       _nearestIndex = _distances
//           .asMap()
//           .entries
//           .reduce((a, b) => a.value < b.value ? a : b)
//           .key;
//     }
//     setState(() => _applyFilterAndSort());
//   }
//
//   // ── Search ────────────────────────────────────────────────────────────────
//   void _onSearchChanged() {
//     setState(() {
//       _searchQuery = _searchController.text.toLowerCase();
//       _applyFilterAndSort();
//     });
//   }
//
//   // ── Filter + Sort ─────────────────────────────────────────────────────────
//   void _applyFilterAndSort() {
//     List<int> indexes = List.generate(station_name_.length, (i) => i);
//     if (_searchQuery.isNotEmpty) {
//       indexes = indexes.where((i) =>
//       station_name_[i].toLowerCase().contains(_searchQuery) ||
//           place_[i].toLowerCase().contains(_searchQuery) ||
//           station_head_[i].toLowerCase().contains(_searchQuery) ||
//           phone_[i].contains(_searchQuery)).toList();
//     }
//     switch (_sortOption) {
//       case 'Name A–Z':
//         indexes.sort((a, b) => station_name_[a].compareTo(station_name_[b]));
//         break;
//       case 'Name Z–A':
//         indexes.sort((a, b) => station_name_[b].compareTo(station_name_[a]));
//         break;
//       case 'Place A–Z':
//         indexes.sort((a, b) => place_[a].compareTo(place_[b]));
//         break;
//       case 'Nearest First':
//         if (_distances.length == station_name_.length) {
//           indexes.sort((a, b) => _distances[a].compareTo(_distances[b]));
//         }
//         break;
//     }
//     _filteredIndexes = indexes;
//   }
//
//   // ── Card entrance animation ───────────────────────────────────────────────
//   void _ensureCardAnim(int listPos) {
//     if (_cardControllers.containsKey(listPos)) return;
//     final ctrl = AnimationController(
//         vsync: this,
//         duration: Duration(milliseconds: 380 + listPos * 70));
//     _cardControllers[listPos] = ctrl;
//     _cardAnims[listPos] =
//         CurvedAnimation(parent: ctrl, curve: Curves.easeOut);
//     Future.delayed(Duration(milliseconds: listPos * 70),
//             () { if (mounted) ctrl.forward(); });
//   }
//
//   // ── Backend fetch (UNCHANGED) ─────────────────────────────────────────────
//   Future<void> View_Police_Station() async => _fetchStations();
//
//   Future<void> _fetchStations() async {
//     setState(() => _isLoading = true);
//     try {
//       SharedPreferences sh = await SharedPreferences.getInstance();
//       String urls = sh.getString('url') ?? '';
//       String lid  = sh.getString('lid') ?? '';
//
//       var response = await http.post(Uri.parse('$urls/View_Police_Station/'),
//           body: {'lid': lid});
//       var jsonData = json.decode(response.body);
//
//       if (jsonData['status'] == 'ok') {
//         var arr = jsonData["data"];
//         List<String> sid=[], sname=[], shead=[], splace=[],
//             sphone=[], slat=[], slon=[];
//         for (int i = 0; i < arr.length; i++) {
//           sid.add(arr[i]['id'].toString());
//           print(arr[i]['id']);
//           sname.add(arr[i]['station_name'].toString());
//           shead.add(arr[i]['station_head'].toString());
//           splace.add(arr[i]['place'].toString());
//           sphone.add(arr[i]['phone'].toString());
//           slat.add(arr[i]['latitude'].toString());
//           slon.add(arr[i]['longitude'].toString());
//         }
//         setState(() {
//           station_id_=sid; station_name_=sname; station_head_=shead;
//           place_=splace; phone_=sphone; latitude_=slat; longitude_=slon;
//           _cardControllers.clear(); _cardAnims.clear();
//           _applyFilterAndSort();
//         });
//         _computeDistances();
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text("Error: $e"),
//         backgroundColor: navyDark,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       ));
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }
//
//   // ── URL Launchers ─────────────────────────────────────────────────────────
//   Future<void> _callStation(String phone) async {
//     final uri = Uri.parse('tel:$phone');
//     if (await canLaunchUrl(uri)) await launchUrl(uri);
//   }
//
//   Future<void> _openMap(String lat, String lon, String name) async {
//     final uri = Uri.parse(
//         'https://www.google.com/maps/search/?api=1&query=$lat,$lon');
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri, mode: LaunchMode.externalApplication);
//     }
//   }
//
//   Future<void> _getDirections(String lat, String lon) async {
//     final uri = Uri.parse(
//         'https://www.google.com/maps/dir/?api=1&destination=$lat,$lon&travelmode=driving');
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri, mode: LaunchMode.externalApplication);
//     }
//   }
//
//   // ── Distance formatter ────────────────────────────────────────────────────
//   String _distanceLabel(int idx) {
//     if (_distances.isEmpty || idx >= _distances.length) return '';
//     final d = _distances[idx];
//     if (d == double.infinity) return '';
//     return d < 1 ? '${(d * 1000).toStringAsFixed(0)} m away'
//         : '${d.toStringAsFixed(1)} km away';
//   }
//
//   // ══════════════════════════════════════════════════════════════════════════
//   //  BUILD
//   // ══════════════════════════════════════════════════════════════════════════
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey,
//       backgroundColor: offWhite,
//       // ── Sidebar Drawer ──────────────────────────────────────────────────
//       drawer: _buildSidebar(),
//       appBar: _buildAppBar(),
//       body: Stack(children: [
//         _buildAnimatedBackground(),
//         Column(children: [
//           _buildHeaderStrip(),
//           _buildSearchAndSort(),
//           Expanded(child: _buildBody()),
//         ]),
//       ]),
//     );
//   }
//
//   // ── AppBar ────────────────────────────────────────────────────────────────
//   PreferredSizeWidget _buildAppBar() {
//     return AppBar(
//       elevation: 0,
//       backgroundColor: navyDark,
//       centerTitle: true,
//       // Hamburger → opens sidebar
//       leading: IconButton(
//         icon: const Icon(Icons.menu_rounded, color: snowWhite),
//         onPressed: () => _scaffoldKey.currentState?.openDrawer(),
//         tooltip: 'Menu',
//       ),
//       title: const Column(children: [
//         Text('Police Stations',
//             style: TextStyle(color: snowWhite, fontSize: 18,
//                 fontWeight: FontWeight.w700, letterSpacing: 1.0)),
//         Text('Pull down to refresh',
//             style: TextStyle(color: Color(0xFFAAC4FF),
//                 fontSize: 10, letterSpacing: 0.4)),
//       ]),
//       // Back button on right
//       actions: [
//         IconButton(
//           icon: const Icon(Icons.arrow_back_ios_new_rounded,
//               color: snowWhite, size: 20),
//           onPressed: () => Navigator.maybePop(context),
//           tooltip: 'Back',
//         ),
//       ],
//     );
//   }
//
//   // ── Sidebar ───────────────────────────────────────────────────────────────
//   Widget _buildSidebar() {
//     return Drawer(
//       backgroundColor: snowWhite,
//       child: Column(children: [
//         // Drawer header
//         Container(
//           width: double.infinity,
//           padding: const EdgeInsets.fromLTRB(20, 54, 20, 28),
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//                 colors: [navyDark, navyMid],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight),
//           ),
//           child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//             Container(
//               width: 58, height: 58,
//               decoration: BoxDecoration(
//                 color: snowWhite.withOpacity(0.15),
//                 shape: BoxShape.circle,
//                 border: Border.all(color: snowWhite.withOpacity(0.4), width: 2),
//               ),
//               child: const Icon(Icons.shield_outlined,
//                   color: snowWhite, size: 30),
//             ),
//             const SizedBox(height: 14),
//             const Text('MPIS',
//                 style: TextStyle(color: snowWhite, fontSize: 20,
//                     fontWeight: FontWeight.w800, letterSpacing: 2)),
//             Text('Missing Person Identification',
//                 style: TextStyle(
//                     color: snowWhite.withOpacity(0.7), fontSize: 11)),
//           ]),
//         ),
//
//         const SizedBox(height: 8),
//
//         // Menu items
//         _drawerItem(Icons.local_police_rounded, 'Police Stations', true, () {
//           Navigator.pop(context);
//         }),
//         _drawerItem(Icons.person_search_rounded, 'View Missing Persons', false, () {
//           Navigator.pop(context);
//           // Navigator.push(context, MaterialPageRoute(builder: (_) => ViewMissingPage()));
//         }),
//         _drawerItem(Icons.report_rounded, 'Report Missing Person', false, () {
//           Navigator.pop(context);
//           // Navigator.push(context, MaterialPageRoute(builder: (_) => ReportPage()));
//         }),
//         _drawerItem(Icons.upload_file_rounded, 'Upload Evidence', false, () {
//           Navigator.pop(context);
//           // Navigator.push(context, MaterialPageRoute(builder: (_) => UploadEvidencePage()));
//         }),
//         _drawerItem(Icons.track_changes_rounded, 'My Case Status', false, () {
//           Navigator.pop(context);
//         }),
//         _drawerItem(Icons.feedback_outlined, 'Complaints & Feedback', false, () {
//           Navigator.pop(context);
//         }),
//
//         const Divider(height: 1, thickness: 0.8, color: cardBorder,
//             indent: 20, endIndent: 20),
//         const SizedBox(height: 8),
//
//         _drawerItem(Icons.person_outline_rounded, 'My Profile', false, () {
//           Navigator.pop(context);
//         }),
//         _drawerItem(Icons.logout_rounded, 'Logout', false, () {
//           Navigator.pop(context);
//         }, isLogout: true),
//
//         const Spacer(),
//         Padding(
//           padding: const EdgeInsets.all(20),
//           child: Text('v1.0.0  •  MPIS',
//               style: TextStyle(color: hintGrey, fontSize: 11)),
//         ),
//       ]),
//     );
//   }
//
//   Widget _drawerItem(IconData icon, String label, bool active,
//       VoidCallback onTap, {bool isLogout = false}) {
//     final color = isLogout
//         ? Colors.red.shade700
//         : active ? navyDark : const Color(0xFF3D5A80);
//     return ListTile(
//       leading: Container(
//         width: 36, height: 36,
//         decoration: BoxDecoration(
//           color: active ? navyDark.withOpacity(0.1) : Colors.transparent,
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Icon(icon, color: color, size: 20),
//       ),
//       title: Text(label,
//           style: TextStyle(color: color, fontSize: 14,
//               fontWeight: active ? FontWeight.w700 : FontWeight.w500)),
//       tileColor: active ? navyDark.withOpacity(0.06) : Colors.transparent,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
//       onTap: onTap,
//     );
//   }
//
//   // ── Animated background ───────────────────────────────────────────────────
//   Widget _buildAnimatedBackground() {
//     return AnimatedBuilder(
//       animation: _bgOrbController,
//       builder: (_, __) {
//         final t = _bgOrbController.value;
//         return Stack(children: [
//           Positioned.fill(
//               child: CustomPaint(
//                   painter: _DotGridPainter(navyLight.withOpacity(0.045)))),
//           Positioned(top: -50 + 28 * sin(t * pi), right: -40 + 18 * cos(t * pi),
//               child: _orb(170, navyLight.withOpacity(0.11))),
//           Positioned(top: 240 + 32 * cos(t * pi), left: -55 + 22 * sin(t * pi),
//               child: _orb(150, navyAccent.withOpacity(0.09))),
//           Positioned(bottom: 80 + 24 * sin(t * pi), right: -25 + 18 * cos(t * pi),
//               child: _orb(130, navyMid.withOpacity(0.10))),
//           Positioned(bottom: 240 + 16 * cos(t * pi), left: 30 + 10 * sin(t * pi),
//               child: _orb(80, navyAccent.withOpacity(0.07))),
//         ]);
//       },
//     );
//   }
//
//   Widget _orb(double size, Color color) => Container(
//     width: size, height: size,
//     decoration: BoxDecoration(
//       shape: BoxShape.circle,
//       gradient: RadialGradient(colors: [color, color.withOpacity(0)]),
//     ),
//   );
//
//   // ── Header strip ──────────────────────────────────────────────────────────
//   Widget _buildHeaderStrip() {
//     return Container(
//       width: double.infinity,
//       decoration: const BoxDecoration(
//         gradient: LinearGradient(
//             colors: [navyDark, navyMid],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter),
//         borderRadius: BorderRadius.only(
//           bottomLeft: Radius.circular(28),
//           bottomRight: Radius.circular(28),
//         ),
//       ),
//       padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
//       child: Wrap(spacing: 10, runSpacing: 8, children: [
//         _chip(Icons.location_city_rounded,
//             '${_filteredIndexes.length} Station${_filteredIndexes.length == 1 ? '' : 's'}'),
//         if (_userPosition != null)
//           _chip(Icons.my_location_rounded, 'Location Active'),
//         if (_nearestIndex >= 0 && _distances.isNotEmpty)
//           _chip(Icons.star_rounded,
//               'Nearest: ${station_name_[_nearestIndex]}'),
//         if (_searchQuery.isNotEmpty)
//           _chip(Icons.filter_alt_rounded, 'Filtered'),
//       ]),
//     );
//   }
//
//   Widget _chip(IconData icon, String label) => Container(
//     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
//     decoration: BoxDecoration(
//       color: snowWhite.withOpacity(0.12),
//       borderRadius: BorderRadius.circular(20),
//       border: Border.all(color: snowWhite.withOpacity(0.22)),
//     ),
//     child: Row(mainAxisSize: MainAxisSize.min, children: [
//       Icon(icon, color: const Color(0xFFAAC4FF), size: 13),
//       const SizedBox(width: 5),
//       Text(label,
//           style: const TextStyle(color: snowWhite,
//               fontSize: 11, fontWeight: FontWeight.w600)),
//     ]),
//   );
//
//   // ── Search + Sort ─────────────────────────────────────────────────────────
//   Widget _buildSearchAndSort() {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
//       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         // Search bar
//         Container(
//           decoration: BoxDecoration(
//             color: snowWhite,
//             borderRadius: BorderRadius.circular(16),
//             boxShadow: [BoxShadow(color: navyDark.withOpacity(0.09),
//                 blurRadius: 18, offset: const Offset(0, 5))],
//           ),
//           child: TextField(
//             controller: _searchController,
//             style: const TextStyle(color: navyDark, fontSize: 14),
//             decoration: InputDecoration(
//               hintText: 'Search by name, place, head or phone…',
//               hintStyle: TextStyle(color: hintGrey, fontSize: 13),
//               prefixIcon: const Icon(Icons.search_rounded,
//                   color: navyLight, size: 22),
//               suffixIcon: _searchQuery.isNotEmpty
//                   ? IconButton(
//                   icon: const Icon(Icons.close_rounded,
//                       color: hintGrey, size: 20),
//                   onPressed: () {
//                     _searchController.clear();
//                     setState(() {
//                       _searchQuery = '';
//                       _applyFilterAndSort();
//                     });
//                   })
//                   : null,
//               filled: true,
//               fillColor: snowWhite,
//               contentPadding: const EdgeInsets.symmetric(
//                   vertical: 14, horizontal: 16),
//               border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(16),
//                   borderSide: BorderSide.none),
//               enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(16),
//                   borderSide: BorderSide(
//                       color: navyLight.withOpacity(0.15), width: 1.2)),
//               focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(16),
//                   borderSide:
//                   const BorderSide(color: navyLight, width: 2)),
//             ),
//           ),
//         ),
//
//         const SizedBox(height: 12),
//
//         // Sort chips
//         SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           child: Row(children: [
//             Padding(
//               padding: const EdgeInsets.only(right: 8),
//               child: Row(children: [
//                 const Icon(Icons.sort_rounded, color: navyLight, size: 17),
//                 const SizedBox(width: 4),
//                 Text('Sort:',
//                     style: TextStyle(color: navyMid, fontSize: 12,
//                         fontWeight: FontWeight.w600)),
//               ]),
//             ),
//             ..._sortOptions.map(_sortChip),
//           ]),
//         ),
//       ]),
//     );
//   }
//
//   Widget _sortChip(String label) {
//     final bool active = _sortOption == label;
//     final bool isNearest = label == 'Nearest First';
//     final bool nearestDisabled = isNearest && _userPosition == null;
//     return GestureDetector(
//       onTap: nearestDisabled
//           ? () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: const Text('Enable location to use Nearest First'),
//         backgroundColor: navyDark,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12)),
//       ))
//           : () => setState(() {
//         _sortOption = label;
//         _applyFilterAndSort();
//       }),
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 200),
//         margin: const EdgeInsets.only(right: 8),
//         padding:
//         const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//         decoration: BoxDecoration(
//           color: active
//               ? navyDark
//               : nearestDisabled
//               ? offWhite
//               : snowWhite,
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(
//               color: active ? navyDark : cardBorder, width: 1.4),
//           boxShadow: active
//               ? [BoxShadow(color: navyDark.withOpacity(0.28),
//               blurRadius: 10, offset: const Offset(0, 3))]
//               : [],
//         ),
//         child: Row(mainAxisSize: MainAxisSize.min, children: [
//           if (isNearest) ...[
//             Icon(Icons.near_me_rounded,
//                 size: 12,
//                 color: active
//                     ? snowWhite
//                     : nearestDisabled
//                     ? hintGrey
//                     : navyLight),
//             const SizedBox(width: 4),
//           ],
//           Text(label,
//               style: TextStyle(
//                   color: active
//                       ? snowWhite
//                       : nearestDisabled
//                       ? hintGrey
//                       : navyMid,
//                   fontSize: 12,
//                   fontWeight: FontWeight.w600)),
//         ]),
//       ),
//     );
//   }
//
//   // ── Body ──────────────────────────────────────────────────────────────────
//   Widget _buildBody() {
//     if (_isLoading) return _loadingState();
//     if (_filteredIndexes.isEmpty) return _emptyState();
//
//     return RefreshIndicator(
//       onRefresh: _fetchStations,
//       color: navyDark,
//       backgroundColor: snowWhite,
//       strokeWidth: 2.5,
//       displacement: 60,
//       child: ListView.builder(
//         physics: const AlwaysScrollableScrollPhysics(
//             parent: BouncingScrollPhysics()),
//         padding: const EdgeInsets.fromLTRB(16, 14, 16, 100),
//         itemCount: _filteredIndexes.length,
//         itemBuilder: (context, listPos) {
//           final dataIdx = _filteredIndexes[listPos];
//           _ensureCardAnim(listPos);
//           final anim = _cardAnims[listPos]!;
//           return FadeTransition(
//             opacity: anim,
//             child: SlideTransition(
//               position: Tween<Offset>(
//                   begin: const Offset(0, 0.14), end: Offset.zero)
//                   .animate(anim),
//               child: _buildStationCard(dataIdx, listPos),
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   // ── Station Card (expandable) ─────────────────────────────────────────────
//   Widget _buildStationCard(int idx, int listPos) {
//     final bool isExpanded = _expandedCards.contains(idx);
//     final bool isNearest  = idx == _nearestIndex && _userPosition != null;
//     final String distLabel = _distanceLabel(idx);
//
//     return AnimatedBuilder(
//       animation: _pulseAnim,
//       builder: (_, child) => Container(
//         margin: const EdgeInsets.only(bottom: 20),
//         decoration: BoxDecoration(
//           color: snowWhite,
//           borderRadius: BorderRadius.circular(22),
//           border: Border.all(
//               color: isNearest
//                   ? navyLight.withOpacity(0.6)
//                   : cardBorder,
//               width: isNearest ? 2.0 : 1.2),
//           boxShadow: [
//             BoxShadow(color: navyDark.withOpacity(0.09),
//                 blurRadius: 20, offset: const Offset(0, 7)),
//             BoxShadow(
//                 color: navyLight
//                     .withOpacity(0.07 * _pulseAnim.value),
//                 blurRadius: 32,
//                 spreadRadius: 3,
//                 offset: const Offset(0, 4)),
//           ],
//         ),
//         child: child,
//       ),
//       child: Column(children: [
//
//         // ── Nearest badge ───────────────────────────────────────────────
//         if (isNearest)
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.symmetric(vertical: 6),
//             decoration: const BoxDecoration(
//               color: Color(0xFF1565C0),
//               borderRadius:
//               BorderRadius.vertical(top: Radius.circular(22)),
//             ),
//             child: const Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(Icons.star_rounded, color: Colors.amber, size: 15),
//                 SizedBox(width: 6),
//                 Text('NEAREST STATION TO YOU',
//                     style: TextStyle(color: snowWhite, fontSize: 11,
//                         fontWeight: FontWeight.w700, letterSpacing: 1.2)),
//               ],
//             ),
//           ),
//
//         // ── Card Header (always visible, tap to expand) ─────────────────
//         GestureDetector(
//           onTap: () => setState(() {
//             if (isExpanded) _expandedCards.remove(idx);
//             else _expandedCards.add(idx);
//           }),
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
//             decoration: BoxDecoration(
//               gradient: const LinearGradient(
//                   colors: [navyDark, navyLight],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight),
//               borderRadius: isNearest
//                   ? BorderRadius.zero
//                   : BorderRadius.vertical(
//                   top: const Radius.circular(22),
//                   bottom: isExpanded
//                       ? Radius.zero
//                       : const Radius.circular(0)),
//             ),
//             child: Row(children: [
//               Container(
//                 width: 46, height: 46,
//                 decoration: BoxDecoration(
//                   color: snowWhite.withOpacity(0.15),
//                   shape: BoxShape.circle,
//                   border: Border.all(color: snowWhite.withOpacity(0.3)),
//                 ),
//                 child: const Icon(Icons.local_police_rounded,
//                     color: snowWhite, size: 24),
//               ),
//               const SizedBox(width: 12),
//               Expanded(child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(station_name_[idx],
//                         style: const TextStyle(color: snowWhite,
//                             fontSize: 15, fontWeight: FontWeight.w700)),
//                     const SizedBox(height: 3),
//                     Row(children: [
//                       const Icon(Icons.place_rounded,
//                           color: Color(0xFFAAC4FF), size: 13),
//                       const SizedBox(width: 4),
//                       Text(place_[idx],
//                           style: const TextStyle(
//                               color: Color(0xFFAAC4FF), fontSize: 12)),
//                       if (distLabel.isNotEmpty) ...[
//                         const SizedBox(width: 8),
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 7, vertical: 2),
//                           decoration: BoxDecoration(
//                             color: snowWhite.withOpacity(0.18),
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: Text(distLabel,
//                               style: const TextStyle(
//                                   color: snowWhite,
//                                   fontSize: 10,
//                                   fontWeight: FontWeight.w600)),
//                         ),
//                       ],
//                     ]),
//                   ])),
//               // Expand chevron
//               AnimatedRotation(
//                 turns: isExpanded ? 0.5 : 0,
//                 duration: const Duration(milliseconds: 250),
//                 child: Container(
//                   width: 32, height: 32,
//                   decoration: BoxDecoration(
//                     color: snowWhite.withOpacity(0.15),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: const Icon(Icons.keyboard_arrow_down_rounded,
//                       color: snowWhite, size: 20),
//                 ),
//               ),
//             ]),
//           ),
//         ),
//
//         // ── Expandable body ─────────────────────────────────────────────
//         AnimatedSize(
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeInOut,
//           child: isExpanded
//               ? Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(children: [
//               _infoRow(Icons.person_outline_rounded,
//                   'Station Head', station_head_[idx]),
//               const Divider(height: 18, thickness: 0.8,
//                   color: cardBorder),
//
//               // Phone row with Call button
//               Row(children: [
//                 Container(
//                   width: 34, height: 34,
//                   decoration: BoxDecoration(color: offWhite,
//                       borderRadius: BorderRadius.circular(10)),
//                   child: const Icon(Icons.phone_outlined,
//                       color: navyLight, size: 18),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text('Phone',
//                           style: TextStyle(color: hintGrey,
//                               fontSize: 11, fontWeight: FontWeight.w500)),
//                       Text(phone_[idx],
//                           style: const TextStyle(color: navyDark,
//                               fontSize: 14, fontWeight: FontWeight.w600)),
//                     ])),
//                 // Call button
//                 GestureDetector(
//                   onTap: () => _callStation(phone_[idx]),
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 12, vertical: 7),
//                     decoration: BoxDecoration(
//                       color: callGreen,
//                       borderRadius: BorderRadius.circular(10),
//                       boxShadow: [BoxShadow(
//                           color: callGreen.withOpacity(0.35),
//                           blurRadius: 8, offset: const Offset(0, 3))],
//                     ),
//                     child: const Row(children: [
//                       Icon(Icons.call_rounded,
//                           color: snowWhite, size: 15),
//                       SizedBox(width: 5),
//                       Text('Call',
//                           style: TextStyle(color: snowWhite,
//                               fontSize: 12,
//                               fontWeight: FontWeight.w700)),
//                     ]),
//                   ),
//                 ),
//               ]),
//
//               const Divider(height: 18, thickness: 0.8,
//                   color: cardBorder),
//
//               // Coordinates
//               Row(children: [
//                 Expanded(child: _coordChip(
//                     Icons.north_east_rounded, 'Latitude',
//                     latitude_[idx])),
//                 const SizedBox(width: 10),
//                 Expanded(child: _coordChip(
//                     Icons.east_rounded, 'Longitude',
//                     longitude_[idx])),
//               ]),
//
//               const SizedBox(height: 14),
//
//               // Map + Directions + View Police — action row
//               Row(children: [
//                 // View on Map
//                 Expanded(child: _actionButton(
//                   icon: Icons.map_outlined,
//                   label: 'View Map',
//                   color: dirBlue,
//                   onTap: () => _openMap(latitude_[idx],
//                       longitude_[idx], station_name_[idx]),
//                 )),
//                 const SizedBox(width: 8),
//                 // Get Directions
//                 Expanded(child: _actionButton(
//                   icon: Icons.directions_rounded,
//                   label: 'Directions',
//                   color: navyMid,
//                   onTap: () => _getDirections(
//                       latitude_[idx], longitude_[idx]),
//                 )),
//               ]),
//
//               const SizedBox(height: 10),
//
//               // View Police Officers (full width)
//               SizedBox(
//                 width: double.infinity,
//                 height: 46,
//                 child: ElevatedButton.icon(
//                   onPressed: () => Navigator.push(context,
//                       MaterialPageRoute(
//                           builder: (_) => ViewPolicepage(
//                               stationId: station_id_[idx]))),
//                   icon: const Icon(Icons.badge_outlined,
//                       size: 18, color: snowWhite),
//                   label: const Text('View Police Officers',
//                       style: TextStyle(fontSize: 14,
//                           color: snowWhite,
//                           fontWeight: FontWeight.w600,
//                           letterSpacing: 0.4)),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: navyDark,
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12)),
//                     elevation: 3,
//                     shadowColor: navyDark.withOpacity(0.4),
//                   ),
//                 ),
//               ),
//             ]),
//           )
//               : const SizedBox.shrink(),
//         ),
//       ]),
//     );
//   }
//
//   Widget _actionButton({
//     required IconData icon,
//     required String label,
//     required Color color,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         height: 42,
//         decoration: BoxDecoration(
//           color: color,
//           borderRadius: BorderRadius.circular(11),
//           boxShadow: [BoxShadow(color: color.withOpacity(0.32),
//               blurRadius: 8, offset: const Offset(0, 3))],
//         ),
//         child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//           Icon(icon, color: snowWhite, size: 16),
//           const SizedBox(width: 6),
//           Text(label,
//               style: const TextStyle(color: snowWhite, fontSize: 12,
//                   fontWeight: FontWeight.w700)),
//         ]),
//       ),
//     );
//   }
//
//   Widget _infoRow(IconData icon, String label, String value) {
//     return Row(children: [
//       Container(
//         width: 34, height: 34,
//         decoration: BoxDecoration(color: offWhite,
//             borderRadius: BorderRadius.circular(10)),
//         child: Icon(icon, color: navyLight, size: 18),
//       ),
//       const SizedBox(width: 12),
//       Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         Text(label, style: TextStyle(color: hintGrey, fontSize: 11,
//             fontWeight: FontWeight.w500)),
//         Text(value, style: const TextStyle(color: navyDark, fontSize: 14,
//             fontWeight: FontWeight.w600)),
//       ]),
//     ]);
//   }
//
//   Widget _coordChip(IconData icon, String label, String value) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//       decoration: BoxDecoration(color: offWhite,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: cardBorder)),
//       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         Row(children: [
//           Icon(icon, color: navyAccent, size: 13),
//           const SizedBox(width: 4),
//           Text(label, style: TextStyle(color: hintGrey, fontSize: 10,
//               fontWeight: FontWeight.w500)),
//         ]),
//         const SizedBox(height: 3),
//         Text(value,
//             style: const TextStyle(color: navyDark, fontSize: 12,
//                 fontWeight: FontWeight.w700),
//             overflow: TextOverflow.ellipsis),
//       ]),
//     );
//   }
//
//   Widget _loadingState() => Center(child: Column(
//       mainAxisAlignment: MainAxisAlignment.center, children: [
//     const CircularProgressIndicator(color: navyDark, strokeWidth: 3),
//     const SizedBox(height: 16),
//     Text('Loading stations…',
//         style: TextStyle(color: hintGrey, fontSize: 14)),
//   ]));
//
//   Widget _emptyState() {
//     final isSearch = _searchQuery.isNotEmpty;
//     return Center(child: Column(
//         mainAxisAlignment: MainAxisAlignment.center, children: [
//       Container(
//         width: 90, height: 90,
//         decoration: BoxDecoration(color: offWhite, shape: BoxShape.circle,
//             border: Border.all(color: cardBorder, width: 2)),
//         child: Icon(isSearch
//             ? Icons.search_off_rounded : Icons.location_off_outlined,
//             size: 44, color: hintGrey),
//       ),
//       const SizedBox(height: 20),
//       Text(isSearch ? 'No Results Found' : 'No Police Stations Found',
//           style: const TextStyle(color: navyDark, fontSize: 18,
//               fontWeight: FontWeight.w700)),
//       const SizedBox(height: 8),
//       Text(isSearch ? 'Try a different search term' : 'Pull down to refresh',
//           style: TextStyle(color: hintGrey, fontSize: 13)),
//       if (!isSearch) ...[
//         const SizedBox(height: 28),
//         ElevatedButton.icon(
//           onPressed: _fetchStations,
//           icon: const Icon(Icons.refresh_rounded, color: snowWhite),
//           label: const Text('Try Again',
//               style: TextStyle(color: snowWhite, fontWeight: FontWeight.w600)),
//           style: ElevatedButton.styleFrom(backgroundColor: navyDark,
//               padding: const EdgeInsets.symmetric(
//                   horizontal: 28, vertical: 14),
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(14))),
//         ),
//       ],
//     ]));
//   }
// }
//
// // ── Dot grid painter ──────────────────────────────────────────────────────────
// class _DotGridPainter extends CustomPainter {
//   final Color color;
//   const _DotGridPainter(this.color);
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()..color = color;
//     const spacing = 28.0;
//     for (double x = 0; x < size.width; x += spacing)
//       for (double y = 0; y < size.height; y += spacing)
//         canvas.drawCircle(Offset(x, y), 1.8, paint);
//   }
//   @override
//   bool shouldRepaint(_DotGridPainter old) => old.color != color;
// }


import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'ViewPolice.dart';

void main() {
  runApp(const View_Police_Station(title: 'View Police Station'));
}

class View_Police_Station extends StatelessWidget {
  const View_Police_Station({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0A1F5C)),
        useMaterial3: true,
      ),
      home: ViewPoliceSationpage(title: title),
    );
  }
}

class ViewPoliceSationpage extends StatefulWidget {
  const ViewPoliceSationpage({super.key, required this.title});
  final String title;

  @override
  State<ViewPoliceSationpage> createState() => _ViewPoliceState();
}

class _ViewPoliceState extends State<ViewPoliceSationpage>
    with TickerProviderStateMixin {

  // ── Palette ────────────────────────────────────────────────────────────────
  static const Color navyDark   = Color(0xFF0A1F5C);
  static const Color navyMid    = Color(0xFF1A3A8C);
  static const Color navyLight  = Color(0xFF2756C5);
  static const Color navyAccent = Color(0xFF4A90E2);
  static const Color snowWhite  = Color(0xFFFFFFFF);
  static const Color offWhite   = Color(0xFFF0F4FF);
  static const Color hintGrey   = Color(0xFF8FA3BF);
  static const Color cardBorder = Color(0xFFDDE8FF);
  static const Color successGreen = Color(0xFF2ECC71);

  // ── Data (backend unchanged) ───────────────────────────────────────────────
  List<String> station_id_   = [];
  List<String> station_name_ = [];
  List<String> station_head_ = [];
  List<String> place_        = [];
  List<String> phone_        = [];
  List<String> latitude_     = [];
  List<String> longitude_    = [];

  // ── Working filtered/sorted list ──────────────────────────────────────────
  List<int> _filteredIndexes = [];

  bool _isLoading = true;

  // ── Search ─────────────────────────────────────────────────────────────────
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // ── Sort ───────────────────────────────────────────────────────────────────
  String _sortOption = 'Default';
  final List<String> _sortOptions = ['Default', 'Name A–Z', 'Name Z–A', 'Place A–Z'];

  // ── Place filter ───────────────────────────────────────────────────────────
  String _selectedPlace = 'All';
  List<String> _placeOptions = ['All'];

  // ── Expanded card tracking ─────────────────────────────────────────────────
  final Set<int> _expandedCards = {};

  // ── Animations ────────────────────────────────────────────────────────────
  late AnimationController _bgOrbController;
  late AnimationController _pulseController;
  late Animation<double>   _pulseAnim;

  final Map<int, AnimationController> _cardControllers = {};
  final Map<int, Animation<double>>   _cardAnims       = {};

  @override
  void initState() {
    super.initState();
    _bgOrbController = AnimationController(
      vsync: this, duration: const Duration(seconds: 8),
    )..repeat(reverse: true);

    _pulseController = AnimationController(
      vsync: this, duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.25, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _searchController.addListener(_onSearchChanged);
    _fetchStations();
  }

  @override
  void dispose() {
    _bgOrbController.dispose();
    _pulseController.dispose();
    _searchController.dispose();
    for (var c in _cardControllers.values) c.dispose();
    super.dispose();
  }

  // ── Search listener ────────────────────────────────────────────────────────
  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
      _applyFilterAndSort();
    });
  }

  // ── Filter + Sort ──────────────────────────────────────────────────────────
  void _applyFilterAndSort() {
    List<int> indexes = List.generate(station_name_.length, (i) => i);

    // Place filter
    if (_selectedPlace != 'All') {
      indexes = indexes.where((i) => place_[i] == _selectedPlace).toList();
    }

    // Search query
    if (_searchQuery.isNotEmpty) {
      indexes = indexes.where((i) =>
      station_name_[i].toLowerCase().contains(_searchQuery) ||
          place_[i].toLowerCase().contains(_searchQuery) ||
          station_head_[i].toLowerCase().contains(_searchQuery) ||
          phone_[i].contains(_searchQuery)).toList();
    }

    // Sort
    switch (_sortOption) {
      case 'Name A–Z':
        indexes.sort((a, b) => station_name_[a].compareTo(station_name_[b]));
        break;
      case 'Name Z–A':
        indexes.sort((a, b) => station_name_[b].compareTo(station_name_[a]));
        break;
      case 'Place A–Z':
        indexes.sort((a, b) => place_[a].compareTo(place_[b]));
        break;
    }

    _filteredIndexes = indexes;
  }

  // ── Build unique place list for filter ─────────────────────────────────────
  void _buildPlaceOptions() {
    final places = place_.toSet().toList()..sort();
    _placeOptions = ['All', ...places];
  }

  // ── Card entrance stagger ──────────────────────────────────────────────────
  void _ensureCardAnim(int listPos) {
    if (_cardControllers.containsKey(listPos)) return;
    final ctrl = AnimationController(
      vsync: this, duration: Duration(milliseconds: 350 + listPos * 65),
    );
    _cardControllers[listPos] = ctrl;
    _cardAnims[listPos] = CurvedAnimation(parent: ctrl, curve: Curves.easeOut);
    Future.delayed(Duration(milliseconds: listPos * 65), () {
      if (mounted) ctrl.forward();
    });
  }

  // ── Backend (UNCHANGED) ────────────────────────────────────────────────────
  Future<void> View_Police_Station() async => _fetchStations();

  Future<void> _fetchStations() async {
    setState(() => _isLoading = true);
    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String urls = sh.getString('url') ?? '';
      String lid  = sh.getString('lid') ?? '';

      var response = await http.post(
        Uri.parse('$urls/View_Police_Station/'),
        body: {'lid': lid},
      );

      var jsonData = json.decode(response.body);

      if (jsonData['status'] == 'ok') {
        var arr = jsonData["data"];
        List<String> sid=[], sname=[], shead=[], splace=[], sphone=[], slat=[], slon=[];

        for (int i = 0; i < arr.length; i++) {
          sid.add(arr[i]['id'].toString());
          print(arr[i]['id']);
          sname.add(arr[i]['station_name'].toString());
          shead.add(arr[i]['station_head'].toString());
          splace.add(arr[i]['place'].toString());
          sphone.add(arr[i]['phone'].toString());
          slat.add(arr[i]['latitude'].toString());
          slon.add(arr[i]['longitude'].toString());
        }

        setState(() {
          station_id_   = sid;
          station_name_ = sname;
          station_head_ = shead;
          place_        = splace;
          phone_        = sphone;
          latitude_     = slat;
          longitude_    = slon;
          _cardControllers.clear();
          _cardAnims.clear();
          _expandedCards.clear();
          _buildPlaceOptions();
          _applyFilterAndSort();
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(children: [
          const Icon(Icons.error_outline, color: snowWhite, size: 18),
          const SizedBox(width: 8),
          Text("Error: $e"),
        ]),
        backgroundColor: navyDark,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  BUILD
  // ══════════════════════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    // WillPopScope handles the back button (hardware + AppBar)
    return WillPopScope(
      onWillPop: () async {
        // Show confirmation dialog before leaving
        final shouldPop = await _showExitConfirm();
        return shouldPop ?? false;
      },
      child: Scaffold(
        backgroundColor: offWhite,
        appBar: _buildAppBar(context),
        body: Stack(children: [
          _buildAnimatedBackground(),
          Column(children: [
            _buildHeaderStrip(),
            _buildSearchAndSort(),
            Expanded(child: _buildBody()),
          ]),
        ]),
      ),
    );
  }

  // ── Exit confirmation dialog ───────────────────────────────────────────────
  Future<bool?> _showExitConfirm() {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: snowWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(children: const [
          Icon(Icons.arrow_back_ios_new_rounded, color: navyDark, size: 20),
          SizedBox(width: 10),
          Text('Go Back?',
              style: TextStyle(color: navyDark, fontWeight: FontWeight.w700)),
        ]),
        content: Text('Return to the previous screen?',
            style: TextStyle(color: hintGrey, fontSize: 14)),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            style: OutlinedButton.styleFrom(
                side: const BorderSide(color: cardBorder),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12))),
            child: const Text('Stay', style: TextStyle(color: navyMid)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(
                backgroundColor: navyDark,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12))),
            child: const Text('Go Back',
                style: TextStyle(color: snowWhite, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  // ── AppBar ─────────────────────────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: navyDark,
      centerTitle: true,
      // ✅ Functioning back button
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded,
            color: snowWhite, size: 20),
        tooltip: 'Go Back',
        onPressed: () async {
          // Try pop — if nothing to pop, show confirm
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          } else {
            final shouldExit = await _showExitConfirm();
            if (shouldExit == true && context.mounted) {
              Navigator.of(context).pop();
            }
          }
        },
      ),
      title: Column(children: const [
        Text('Police Stations',
            style: TextStyle(color: snowWhite, fontSize: 18,
                fontWeight: FontWeight.w700, letterSpacing: 1.0)),
        Text('Tap a card to expand details',
            style: TextStyle(
                color: Color(0xFFAAC4FF), fontSize: 10, letterSpacing: 0.4)),
      ]),
      actions: [
        // Active filter indicator
        if (_selectedPlace != 'All' || _searchQuery.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: navyAccent.withOpacity(0.25),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: navyAccent.withOpacity(0.5)),
            ),
            child: Row(children: [
              const Icon(Icons.filter_alt_rounded,
                  color: Color(0xFFAAC4FF), size: 14),
              const SizedBox(width: 3),
              Text('${_filteredIndexes.length}',
                  style: const TextStyle(
                      color: snowWhite, fontSize: 12,
                      fontWeight: FontWeight.w700)),
            ]),
          ),
      ],
    );
  }

  // ── Animated background ────────────────────────────────────────────────────
  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _bgOrbController,
      builder: (_, __) {
        final t = _bgOrbController.value;
        return Stack(children: [
          Positioned.fill(
            child: CustomPaint(
                painter: _DotGridPainter(navyLight.withOpacity(0.045))),
          ),
          Positioned(top: -50 + 28 * sin(t * pi), right: -40 + 18 * cos(t * pi),
              child: _orb(170, navyLight.withOpacity(0.11))),
          Positioned(top: 240 + 32 * cos(t * pi), left: -55 + 22 * sin(t * pi),
              child: _orb(150, navyAccent.withOpacity(0.09))),
          Positioned(bottom: 80 + 24 * sin(t * pi), right: -25 + 18 * cos(t * pi),
              child: _orb(130, navyMid.withOpacity(0.10))),
          Positioned(bottom: 240 + 16 * cos(t * pi), left: 30 + 10 * sin(t * pi),
              child: _orb(80, navyAccent.withOpacity(0.07))),
        ]);
      },
    );
  }

  Widget _orb(double size, Color color) => Container(
    width: size, height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      gradient: RadialGradient(colors: [color, color.withOpacity(0)]),
    ),
  );

  // ── Header strip ───────────────────────────────────────────────────────────
  Widget _buildHeaderStrip() {
    final bool hasFilters = _selectedPlace != 'All' || _searchQuery.isNotEmpty;
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            colors: [navyDark, navyMid],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
      child: Wrap(spacing: 10, runSpacing: 8, children: [
        _chip(Icons.location_city_rounded,
            '${_filteredIndexes.length} / ${station_name_.length} Stations'),
        _chip(Icons.swipe_down_rounded, 'Pull to refresh'),
        if (hasFilters)
          GestureDetector(
            onTap: _clearAllFilters,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: Colors.redAccent.withOpacity(0.25),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.redAccent.withOpacity(0.5)),
              ),
              child: const Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.close_rounded, color: Colors.redAccent, size: 14),
                SizedBox(width: 5),
                Text('Clear Filters',
                    style: TextStyle(color: Colors.redAccent,
                        fontSize: 11, fontWeight: FontWeight.w600)),
              ]),
            ),
          ),
      ]),
    );
  }

  Widget _chip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: snowWhite.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: snowWhite.withOpacity(0.22)),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, color: const Color(0xFFAAC4FF), size: 14),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(
            color: snowWhite, fontSize: 11, fontWeight: FontWeight.w600)),
      ]),
    );
  }

  void _clearAllFilters() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
      _selectedPlace = 'All';
      _sortOption = 'Default';
      _applyFilterAndSort();
    });
  }

  // ── Search + Sort + Place Filter ───────────────────────────────────────────
  Widget _buildSearchAndSort() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

        // ── Search bar ─────────────────────────────────────────────────────
        Container(
          decoration: BoxDecoration(
            color: snowWhite,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: navyDark.withOpacity(0.09),
                blurRadius: 18, offset: const Offset(0, 5))],
          ),
          child: TextField(
            controller: _searchController,
            style: const TextStyle(color: navyDark, fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Search name, place, head or phone…',
              hintStyle: TextStyle(color: hintGrey, fontSize: 13),
              prefixIcon: const Icon(Icons.search_rounded, color: navyLight, size: 22),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                  icon: const Icon(Icons.close_rounded, color: hintGrey, size: 20),
                  onPressed: () {
                    _searchController.clear();
                    setState(() { _searchQuery = ''; _applyFilterAndSort(); });
                  })
                  : null,
              filled: true, fillColor: snowWhite,
              contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                      color: navyLight.withOpacity(0.15), width: 1.2)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: navyLight, width: 2)),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // ── Sort chips + Place filter row ──────────────────────────────────
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: [

            // Sort label
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Row(children: [
                const Icon(Icons.sort_rounded, color: navyLight, size: 17),
                const SizedBox(width: 4),
                Text('Sort:', style: TextStyle(
                    color: navyMid, fontSize: 12, fontWeight: FontWeight.w600)),
              ]),
            ),

            // Sort chips
            ..._sortOptions.map(_sortChip),

            // Divider
            Container(width: 1, height: 24, color: cardBorder,
                margin: const EdgeInsets.symmetric(horizontal: 10)),

            // Place filter label
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Row(children: [
                const Icon(Icons.place_rounded, color: navyLight, size: 17),
                const SizedBox(width: 4),
                Text('Place:', style: TextStyle(
                    color: navyMid, fontSize: 12, fontWeight: FontWeight.w600)),
              ]),
            ),

            // Place filter chips
            ..._placeOptions.map(_placeChip),
          ]),
        ),
      ]),
    );
  }

  Widget _sortChip(String label) {
    final bool active = _sortOption == label;
    return GestureDetector(
      onTap: () => setState(() { _sortOption = label; _applyFilterAndSort(); }),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: active ? navyDark : snowWhite,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: active ? navyDark : cardBorder, width: 1.4),
          boxShadow: active ? [BoxShadow(color: navyDark.withOpacity(0.28),
              blurRadius: 10, offset: const Offset(0, 3))] : [],
        ),
        child: Text(label, style: TextStyle(
            color: active ? snowWhite : navyMid,
            fontSize: 12, fontWeight: FontWeight.w600)),
      ),
    );
  }

  Widget _placeChip(String label) {
    final bool active = _selectedPlace == label;
    return GestureDetector(
      onTap: () => setState(() { _selectedPlace = label; _applyFilterAndSort(); }),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: active ? navyAccent : snowWhite,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: active ? navyAccent : cardBorder, width: 1.4),
          boxShadow: active ? [BoxShadow(
              color: navyAccent.withOpacity(0.3),
              blurRadius: 10, offset: const Offset(0, 3))] : [],
        ),
        child: Text(label, style: TextStyle(
            color: active ? snowWhite : navyMid,
            fontSize: 12, fontWeight: FontWeight.w600)),
      ),
    );
  }

  // ── Body ───────────────────────────────────────────────────────────────────
  Widget _buildBody() {
    if (_isLoading) return _loadingState();
    if (_filteredIndexes.isEmpty) return _emptyState();

    return RefreshIndicator(
      onRefresh: _fetchStations,
      color: navyDark,
      backgroundColor: snowWhite,
      strokeWidth: 2.5,
      displacement: 60,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics()),
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 100),
        itemCount: _filteredIndexes.length,
        itemBuilder: (context, listPos) {
          final dataIdx = _filteredIndexes[listPos];
          _ensureCardAnim(listPos);
          final anim = _cardAnims[listPos]!;
          return FadeTransition(
            opacity: anim,
            child: SlideTransition(
              position: Tween<Offset>(
                  begin: const Offset(0, 0.14), end: Offset.zero)
                  .animate(anim),
              child: _buildStationCard(dataIdx, listPos),
            ),
          );
        },
      ),
    );
  }

  // ── Expandable Station Card ────────────────────────────────────────────────
  Widget _buildStationCard(int idx, int listPos) {
    final bool isExpanded = _expandedCards.contains(idx);

    return AnimatedBuilder(
      animation: _pulseAnim,
      builder: (_, child) => Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: snowWhite,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isExpanded ? navyLight.withOpacity(0.5) : cardBorder,
            width: isExpanded ? 1.8 : 1.2,
          ),
          boxShadow: [
            BoxShadow(color: navyDark.withOpacity(0.09),
                blurRadius: 20, offset: const Offset(0, 7)),
            BoxShadow(
                color: navyLight.withOpacity(
                    isExpanded ? 0.12 * _pulseAnim.value : 0.05 * _pulseAnim.value),
                blurRadius: 32, spreadRadius: 3,
                offset: const Offset(0, 4)),
          ],
        ),
        child: child,
      ),
      child: Column(children: [

        // ── Tappable header (always visible) ──────────────────────────────
        GestureDetector(
          onTap: () => setState(() {
            if (isExpanded) {
              _expandedCards.remove(idx);
            } else {
              _expandedCards.add(idx);
            }
          }),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [navyDark, navyLight],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(22),
                topRight: const Radius.circular(22),
                bottomLeft: Radius.circular(isExpanded ? 0 : 22),
                bottomRight: Radius.circular(isExpanded ? 0 : 22),
              ),
            ),
            child: Row(children: [
              // Police shield icon
              Container(
                width: 46, height: 46,
                decoration: BoxDecoration(
                  color: snowWhite.withOpacity(0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: snowWhite.withOpacity(0.3)),
                ),
                child: const Icon(Icons.local_police_rounded,
                    color: snowWhite, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(station_name_[idx],
                    style: const TextStyle(color: snowWhite, fontSize: 15,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 3),
                Row(children: [
                  const Icon(Icons.place_rounded,
                      color: Color(0xFFAAC4FF), size: 13),
                  const SizedBox(width: 4),
                  Text(place_[idx],
                      style: const TextStyle(
                          color: Color(0xFFAAC4FF), fontSize: 12)),
                ]),
              ])),

              // Expand/collapse indicator
              AnimatedRotation(
                turns: isExpanded ? 0.5 : 0,
                duration: const Duration(milliseconds: 300),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: snowWhite.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.keyboard_arrow_down_rounded,
                      color: snowWhite, size: 20),
                ),
              ),
            ]),
          ),
        ),

        // ── Expandable details section ─────────────────────────────────────
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: isExpanded
              ? _buildCardDetails(idx)
              : const SizedBox.shrink(),
        ),
      ]),
    );
  }

  // ── Card details (shown when expanded) ────────────────────────────────────
  Widget _buildCardDetails(int idx) {
    return Container(
      decoration: const BoxDecoration(
        color: snowWhite,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(22),
          bottomRight: Radius.circular(22),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(children: [

        // Subtle top divider
        Container(height: 1, color: cardBorder, margin: const EdgeInsets.only(bottom: 14)),

        _infoRow(Icons.person_outline_rounded, 'Station Head', station_head_[idx]),
        const SizedBox(height: 12),

        // Phone row with Call button
        Row(children: [
          Container(
            width: 34, height: 34,
            decoration: BoxDecoration(
                color: offWhite, borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.phone_outlined, color: navyLight, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Phone', style: TextStyle(
                color: hintGrey, fontSize: 11, fontWeight: FontWeight.w500)),
            Text(phone_[idx], style: const TextStyle(
                color: navyDark, fontSize: 14, fontWeight: FontWeight.w600)),
          ])),
          // Quick call button
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Calling ${phone_[idx]}…'),
                backgroundColor: successGreen,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                duration: const Duration(seconds: 2),
              ));
              // To enable real calling: add url_launcher and call:
              // launchUrl(Uri.parse('tel:${phone_[idx]}'));
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: successGreen.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: successGreen.withOpacity(0.4)),
              ),
              child: Row(children: const [
                Icon(Icons.call_rounded, color: successGreen, size: 15),
                SizedBox(width: 5),
                Text('Call', style: TextStyle(
                    color: successGreen, fontSize: 12,
                    fontWeight: FontWeight.w700)),
              ]),
            ),
          ),
        ]),

        const SizedBox(height: 12),
        const Divider(height: 1, thickness: 0.8, color: cardBorder),
        const SizedBox(height: 12),

        // Coordinates row
        Row(children: [
          Expanded(child: _coordChip(
              Icons.north_east_rounded, 'Latitude', latitude_[idx])),
          const SizedBox(width: 10),
          Expanded(child: _coordChip(
              Icons.east_rounded, 'Longitude', longitude_[idx])),
        ]),

        const SizedBox(height: 14),

        // Action buttons row
        Row(children: [
          // View on Map button
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                      'Opening map for ${station_name_[idx]}…'),
                  backgroundColor: navyMid,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ));
                // To enable: add url_launcher and call:
                // launchUrl(Uri.parse(
                //   'https://maps.google.com/?q=${latitude_[idx]},${longitude_[idx]}'));
              },
              icon: const Icon(Icons.map_outlined, size: 16, color: navyLight),
              label: const Text('Map', style: TextStyle(
                  color: navyLight, fontSize: 13, fontWeight: FontWeight.w600)),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: navyLight.withOpacity(0.5)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(width: 10),
          // View Police Officers button
          Expanded(
            flex: 2,
            child: ElevatedButton.icon(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(
                      builder: (_) =>
                          ViewPolicepage(stationId: station_id_[idx]))),
              icon: const Icon(Icons.badge_outlined, size: 16, color: snowWhite),
              label: const Text('View Officers',
                  style: TextStyle(fontSize: 13, color: snowWhite,
                      fontWeight: FontWeight.w600)),
              style: ElevatedButton.styleFrom(
                backgroundColor: navyDark,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 3,
                shadowColor: navyDark.withOpacity(0.4),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ]),
      ]),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(children: [
      Container(
        width: 34, height: 34,
        decoration: BoxDecoration(
            color: offWhite, borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: navyLight, size: 18),
      ),
      const SizedBox(width: 12),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: TextStyle(color: hintGrey, fontSize: 11,
            fontWeight: FontWeight.w500)),
        Text(value, style: const TextStyle(color: navyDark, fontSize: 14,
            fontWeight: FontWeight.w600)),
      ]),
    ]);
  }

  Widget _coordChip(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
          color: offWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: cardBorder)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(icon, color: navyAccent, size: 13),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(color: hintGrey, fontSize: 10,
              fontWeight: FontWeight.w500)),
        ]),
        const SizedBox(height: 3),
        Text(value, style: const TextStyle(color: navyDark, fontSize: 12,
            fontWeight: FontWeight.w700),
            overflow: TextOverflow.ellipsis),
      ]),
    );
  }

  Widget _loadingState() {
    return Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center, children: [
      const CircularProgressIndicator(color: navyDark, strokeWidth: 3),
      const SizedBox(height: 16),
      Text('Loading stations…',
          style: TextStyle(color: hintGrey, fontSize: 14)),
    ]));
  }

  Widget _emptyState() {
    final isFiltered = _searchQuery.isNotEmpty || _selectedPlace != 'All';
    return Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
        width: 90, height: 90,
        decoration: BoxDecoration(
            color: offWhite, shape: BoxShape.circle,
            border: Border.all(color: cardBorder, width: 2)),
        child: Icon(
            isFiltered ? Icons.search_off_rounded : Icons.location_off_outlined,
            size: 44, color: hintGrey),
      ),
      const SizedBox(height: 20),
      Text(isFiltered ? 'No Matching Stations' : 'No Police Stations Found',
          style: const TextStyle(color: navyDark, fontSize: 18,
              fontWeight: FontWeight.w700)),
      const SizedBox(height: 8),
      Text(isFiltered
          ? 'Try adjusting your search or filters'
          : 'Pull down to refresh',
          style: TextStyle(color: hintGrey, fontSize: 13)),
      if (isFiltered) ...[
        const SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: _clearAllFilters,
          icon: const Icon(Icons.filter_alt_off_rounded, color: snowWhite, size: 16),
          label: const Text('Clear All Filters',
              style: TextStyle(color: snowWhite, fontWeight: FontWeight.w600)),
          style: ElevatedButton.styleFrom(
              backgroundColor: navyDark,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14))),
        ),
      ],
    ]));
  }
}

// ── Dot grid painter ───────────────────────────────────────────────────────
class _DotGridPainter extends CustomPainter {
  final Color color;
  const _DotGridPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    const spacing = 28.0;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1.8, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_DotGridPainter old) => old.color != color;
}