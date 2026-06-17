import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ViewMissingPersonsPage extends StatefulWidget {
  const ViewMissingPersonsPage({super.key});

  @override
  State<ViewMissingPersonsPage> createState() => _ViewMissingPersonsPageState();
}

class _ViewMissingPersonsPageState extends State<ViewMissingPersonsPage> {
  List persons = [];
  bool loading = true;
  String baseUrl = "";

  @override
  void initState() {
    super.initState();
    fetchMissingPersons();
  }

  Future<void> fetchMissingPersons() async {
    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      baseUrl = sh.getString('url').toString();

      final response = await http.post(
        Uri.parse('$baseUrl/user_view_missing_persons/'),
      );

      final data = json.decode(response.body);

      if (data['status'] == 'ok') {
        setState(() {
          persons = data['data'];
          loading = false;
        });
      } else {
        Fluttertoast.showToast(msg: "No data found");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
    }
  }

  Color getStatusColor(bool isResolved) {
    return isResolved ? Colors.green : Colors.red;
  }

  String getStatusText(bool isResolved) {
    return isResolved ? "FOUND" : "MISSING";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Missing Persons"),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : persons.isEmpty
          ? const Center(child: Text("No records found"))
          : ListView.builder(
        itemCount: persons.length,
        itemBuilder: (context, index) {
          final p = persons[index];

          return Card(
            elevation: 6,
            margin: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  /// IMAGE
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: p['photo'] != ""
                        ? Image.network(
                      p['photo'],
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    )
                        : Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.person,
                          size: 40),
                    ),
                  ),

                  const SizedBox(width: 12),

                  /// DETAILS
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          p['name'] ?? "",
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),

                        Text("Age: ${p['age']}"),
                        Text("Gender: ${p['gender']}"),
                        Text("Station: ${p['station']}"),

                        const SizedBox(height: 5),

                        Text(
                          p['details'] ?? "",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.grey.shade700),
                        ),

                        const SizedBox(height: 8),

                        // /// STATUS BADGE
                        // Container(
                        //   padding: const EdgeInsets.symmetric(
                        //       horizontal: 10, vertical: 4),
                        //   decoration: BoxDecoration(
                        //     color: getStatusColor(
                        //         p['is_resolved'])
                        //         .withOpacity(0.2),
                        //     borderRadius:
                        //     BorderRadius.circular(20),
                        //   ),
                        //   child: Text(
                        //     getStatusText(
                        //         p['is_resolved']),
                        //     style: TextStyle(
                        //       color: getStatusColor(
                        //           p['is_resolved']),
                        //       fontWeight: FontWeight.bold,
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

//
// import 'dart:convert';
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
//
// // ═══════════════════════════════════════════════════════════════════════════════
// //  THEME
// // ═══════════════════════════════════════════════════════════════════════════════
// class _T {
//   static const bgDeep       = Color(0xFF04091A);
//   static const bgCard       = Color(0xFF0A1530);
//   static const accentBlue   = Color(0xFF1D6BFF);
//   static const accentCyan   = Color(0xFF00C2FF);
//   static const accentPurple = Color(0xFF7B5CFF);
//   static const danger       = Color(0xFFFF4D6A);
//   static const success      = Color(0xFF00E5A0);
//   static const textPrimary  = Color(0xFFEEF3FF);
//   static const textSub      = Color(0xFF6E8CB8);
//   static const glass        = Color(0x14FFFFFF);
//   static const glassBorder  = Color(0x28FFFFFF);
// }
//
// // ═══════════════════════════════════════════════════════════════════════════════
// //  MAIN LIST PAGE
// // ═══════════════════════════════════════════════════════════════════════════════
// class ViewStylistsPage extends StatefulWidget {
//   final String shopId;
//   const ViewStylistsPage({super.key, required this.shopId});
//
//   @override
//   State<ViewStylistsPage> createState() => _ViewStylistsPageState();
// }
//
// class _ViewStylistsPageState extends State<ViewStylistsPage>
//     with TickerProviderStateMixin {
//   List   _all           = [];
//   List   _filtered      = [];
//   List   _resolved      = [];
//   bool   _loading       = true;
//   String _imageurl      = '';
//   String _query         = '';
//   String _filterGender  = 'All';
//   bool   _showResolved  = false;
//
//   late final AnimationController _listAnim;
//   late final AnimationController _pulseAnim;
//   final TextEditingController _searchCtrl = TextEditingController();
//   final ScrollController      _scrollCtrl = ScrollController();
//
//   @override
//   void initState() {
//     super.initState();
//     _listAnim  = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..forward();
//     _pulseAnim = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
//     _fetch();
//   }
//
//   @override
//   void dispose() {
//     _listAnim.dispose();
//     _pulseAnim.dispose();
//     _searchCtrl.dispose();
//     _scrollCtrl.dispose();
//     super.dispose();
//   }
//
//   // ── backend (original logic preserved) ───────────────────────
//   Future<void> _fetch() async {
//     setState(() => _loading = true);
//     try {
//       SharedPreferences sh = await SharedPreferences.getInstance();
//       String url = sh.getString('url').toString();
//       _imageurl  = sh.getString('Image_url').toString();
//
//       final response = await http.post(
//         Uri.parse('$url/user_view_missing_persons/'),
//         body: {'shop_id': widget.shopId},
//       );
//       final data = json.decode(response.body);
//
//       if (data['status'] == 'ok') {
//         final all = List.from(data['data'] ?? []);
//         setState(() {
//           _all      = all.where((p) => p['is_resolved'] != true).toList();
//           _resolved = all.where((p) => p['is_resolved'] == true).toList();
//           _loading  = false;
//         });
//         _applyFilter();
//         _listAnim.forward(from: 0);
//       } else {
//         setState(() => _loading = false);
//         Fluttertoast.showToast(msg: "No missing persons found");
//       }
//     } catch (_) {
//       setState(() => _loading = false);
//       Fluttertoast.showToast(msg: "Connection error. Please retry.");
//     }
//   }
//
//   void _applyFilter() {
//     setState(() {
//       _filtered = _all.where((p) {
//         final name   = (p['name'] ?? '').toString().toLowerCase();
//         final gender = (p['gender'] ?? '').toString();
//         final matchQ = _query.isEmpty || name.contains(_query.toLowerCase());
//         final matchG = _filterGender == 'All' || gender == _filterGender;
//         return matchQ && matchG;
//       }).toList();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AnnotatedRegion<SystemUiOverlayStyle>(
//       value: SystemUiOverlayStyle.light,
//       child: Scaffold(
//         backgroundColor: _T.bgDeep,
//         body: Stack(children: [
//           const _BgPainter(),
//           SafeArea(
//             child: Column(children: [
//               _Header(
//                 count    : _filtered.length,
//                 loading  : _loading,
//                 onBack   : () => Navigator.pop(context),
//                 onRefresh: _fetch,
//               ),
//               _SearchBar(
//                 controller: _searchCtrl,
//                 onChanged : (v) { _query = v; _applyFilter(); },
//               ),
//               _GenderFilter(
//                 selected: _filterGender,
//                 onSelect: (v) { _filterGender = v; _applyFilter(); },
//               ),
//               const SizedBox(height: 6),
//               Expanded(child: _loading ? _Loader(anim: _pulseAnim) : _buildList()),
//             ]),
//           ),
//           Positioned(
//             bottom: 24, right: 20,
//             child: _FabScrollTop(ctrl: _scrollCtrl),
//           ),
//         ]),
//       ),
//     );
//   }
//
//   Widget _buildList() {
//     if (_filtered.isEmpty && _resolved.isEmpty) {
//       return _EmptyState(hasQuery: _query.isNotEmpty || _filterGender != 'All');
//     }
//     return ListView.builder(
//       controller : _scrollCtrl,
//       padding    : const EdgeInsets.fromLTRB(16, 4, 16, 100),
//       itemCount  : _filtered.length + (_resolved.isEmpty ? 0 : 1),
//       itemBuilder: (ctx, i) {
//
//         // Resolved section header + cards at the end
//         if (i == _filtered.length) {
//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 10),
//               GestureDetector(
//                 onTap: () => setState(() => _showResolved = !_showResolved),
//                 child: Container(
//                   margin: const EdgeInsets.only(bottom: 8),
//                   padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//                   decoration: BoxDecoration(
//                     color: _T.success.withOpacity(0.08),
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(color: _T.success.withOpacity(0.3)),
//                   ),
//                   child: Row(children: [
//                     const Icon(Icons.check_circle_rounded, color: _T.success, size: 16),
//                     const SizedBox(width: 8),
//                     Text(
//                       "Found / Resolved  (${_resolved.length})",
//                       style: const TextStyle(color: _T.success,
//                           fontSize: 13, fontWeight: FontWeight.w700),
//                     ),
//                     const Spacer(),
//                     Icon(
//                       _showResolved
//                           ? Icons.keyboard_arrow_up_rounded
//                           : Icons.keyboard_arrow_down_rounded,
//                       color: _T.success, size: 18,
//                     ),
//                   ]),
//                 ),
//               ),
//               if (_showResolved)
//                 ..._resolved.map((p) => _PersonCard(
//                   person  : p,
//                   imageurl: _imageurl,
//                   index   : 0,
//                   onTap   : () => Navigator.push(
//                     ctx,
//                     PageRouteBuilder(
//                       transitionDuration: const Duration(milliseconds: 450),
//                       pageBuilder: (_, a, __) => FadeTransition(
//                         opacity: a,
//                         child: _DetailPage(person: p, imageurl: _imageurl),
//                       ),
//                     ),
//                   ),
//                 )).toList(),
//             ],
//           );
//         }
//
//         // Active missing persons
//         final double start = ((i * 80) / 900.0).clamp(0.0, 0.85);
//         final double end   = (start + 0.25).clamp(0.0, 1.0);
//         final double span  = (end - start).clamp(0.01, 1.0);
//
//         return AnimatedBuilder(
//           animation: _listAnim,
//           builder: (_, child) {
//             final raw = ((_listAnim.value - start) / span).clamp(0.0, 1.0);
//             final t   = Curves.easeOutCubic.transform(raw);
//             return Opacity(
//               opacity: t,
//               child: Transform.translate(offset: Offset(0, 28 * (1 - t)), child: child),
//             );
//           },
//           child: _PersonCard(
//             person  : _filtered[i],
//             imageurl: _imageurl,
//             index   : i,
//             onTap   : () => Navigator.push(
//               context,
//               PageRouteBuilder(
//                 transitionDuration: const Duration(milliseconds: 450),
//                 pageBuilder: (_, a, __) => FadeTransition(
//                   opacity: a,
//                   child: _DetailPage(person: _filtered[i], imageurl: _imageurl),
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
//
// // ═══════════════════════════════════════════════════════════════════════════════
// //  DETAIL PAGE
// // ═══════════════════════════════════════════════════════════════════════════════
// class _DetailPage extends StatefulWidget {
//   final Map    person;
//   final String imageurl;
//   const _DetailPage({required this.person, required this.imageurl});
//
//   @override
//   State<_DetailPage> createState() => _DetailPageState();
// }
//
// class _DetailPageState extends State<_DetailPage>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _anim;
//
//   @override
//   void initState() {
//     super.initState();
//     _anim = AnimationController(vsync: this, duration: const Duration(milliseconds: 700))..forward();
//   }
//
//   @override
//   void dispose() { _anim.dispose(); super.dispose(); }
//
//   bool get _hasPhoto {
//     final p = widget.person['photo'];
//     return p != null && p.toString().isNotEmpty;
//   }
//
//   String get _photoUrl => widget.person['photo'] ?? '';
//
//   Widget _slideIn({required double delay, required Widget child}) {
//     return AnimatedBuilder(
//       animation: _anim,
//       builder: (_, __) {
//         final span = (1.0 - delay).clamp(0.01, 1.0);
//         final raw  = ((_anim.value - delay) / span).clamp(0.0, 1.0);
//         final t    = Curves.easeOutCubic.transform(raw);
//         return Opacity(
//           opacity: t,
//           child: Transform.translate(offset: Offset(0, 20 * (1 - t)), child: child),
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final p = widget.person;
//     return AnnotatedRegion<SystemUiOverlayStyle>(
//       value: SystemUiOverlayStyle.light,
//       child: Scaffold(
//         backgroundColor: _T.bgDeep,
//         body: Stack(children: [
//           const _BgPainter(),
//           CustomScrollView(slivers: [
//             SliverToBoxAdapter(child: _buildHero(context)),
//             SliverPadding(
//               padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
//               sliver: SliverList(
//                 delegate: SliverChildListDelegate([
//                   const SizedBox(height: 20),
//                   _slideIn(delay: 0.10, child: const _SectionLabel(label: "PERSONAL INFORMATION")),
//                   const SizedBox(height: 10),
//                   _slideIn(delay: 0.15, child: _InfoGrid(person: p)),
//                   const SizedBox(height: 20),
//                   _slideIn(delay: 0.25, child: const _SectionLabel(label: "CASE DETAILS")),
//                   const SizedBox(height: 10),
//                   _slideIn(delay: 0.30, child: _DetailsCard(person: p)),
//                   const SizedBox(height: 20),
//                   _slideIn(delay: 0.40, child: const _SectionLabel(label: "CASE STATUS")),
//                   const SizedBox(height: 10),
//                   _slideIn(delay: 0.45, child: _StatusCard(person: p)),
//                   // Show investigation report section only when resolved
//                   if (p['is_resolved'] == true &&
//                       (p['report'] ?? '').toString().isNotEmpty) ...[
//                     const SizedBox(height: 20),
//                     _slideIn(delay: 0.50, child: const _SectionLabel(label: "INVESTIGATION REPORT")),
//                     const SizedBox(height: 10),
//                     _slideIn(delay: 0.55, child: _ReportCard(report: p['report'].toString())),
//                   ],
//                   const SizedBox(height: 24),
//                   _slideIn(delay: 0.65, child: _ShareButton(person: p)),
//                 ]),
//               ),
//             ),
//           ]),
//           // back button overlay
//           SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.all(12),
//               child: _GlassButton(
//                 onTap: () => Navigator.pop(context),
//                 child: const Icon(Icons.arrow_back_ios_new_rounded,
//                     color: _T.textPrimary, size: 17),
//               ),
//             ),
//           ),
//         ]),
//       ),
//     );
//   }
//
//   Widget _buildHero(BuildContext context) {
//     return SizedBox(
//       height: 330,
//       child: Stack(fit: StackFit.expand, children: [
//         // Photo
//         if (_hasPhoto)
//           GestureDetector(
//             onTap: () => _openFullscreen(context),
//             child: Hero(
//               tag: 'photo_${widget.person['name']}',
//               child: Image.network(
//                 _photoUrl, fit: BoxFit.cover,
//                 errorBuilder: (_, __, ___) => _gradientFallback(),
//               ),
//             ),
//           )
//         else
//           _gradientFallback(),
//
//         // Bottom fade
//         Positioned(
//           left: 0, right: 0, bottom: 0,
//           child: Container(
//             height: 180,
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topCenter, end: Alignment.bottomCenter,
//                 colors: [Colors.transparent, _T.bgDeep],
//               ),
//             ),
//           ),
//         ),
//
//         // Name + "View Photo" button
//         Positioned(
//           left: 20, right: 20, bottom: 20,
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//                       decoration: BoxDecoration(
//                         color: _T.danger.withOpacity(0.85),
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: const Row(mainAxisSize: MainAxisSize.min, children: [
//                         Icon(Icons.warning_amber_rounded, size: 11, color: Colors.white),
//                         SizedBox(width: 4),
//                         Text("MISSING", style: TextStyle(color: Colors.white,
//                             fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: 1.5)),
//                       ]),
//                     ),
//                     const SizedBox(height: 6),
//                     Text(
//                       widget.person['name'] ?? 'Unknown',
//                       style: const TextStyle(
//                         color: _T.textPrimary, fontSize: 26,
//                         fontWeight: FontWeight.w800, letterSpacing: 0.2,
//                         shadows: [Shadow(color: Colors.black87, blurRadius: 10)],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               if (_hasPhoto)
//                 GestureDetector(
//                   onTap: () => _openFullscreen(context),
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                     decoration: BoxDecoration(
//                       color: Colors.black45,
//                       borderRadius: BorderRadius.circular(20),
//                       border: Border.all(color: _T.glassBorder),
//                     ),
//                     child: const Row(children: [
//                       Icon(Icons.fullscreen_rounded, color: Colors.white70, size: 15),
//                       SizedBox(width: 5),
//                       Text("Full Photo",
//                           style: TextStyle(color: Colors.white70, fontSize: 11)),
//                     ]),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ]),
//     );
//   }
//
//   Widget _gradientFallback() => Container(
//     decoration: const BoxDecoration(
//       gradient: LinearGradient(
//         begin: Alignment.topLeft, end: Alignment.bottomRight,
//         colors: [Color(0xFF0D2060), Color(0xFF04091A)],
//       ),
//     ),
//     child: Center(
//       child: Icon(Icons.person_rounded, size: 90,
//           color: _T.accentBlue.withOpacity(0.25)),
//     ),
//   );
//
//   void _openFullscreen(BuildContext context) {
//     if (!_hasPhoto) return;
//     Navigator.push(
//       context,
//       PageRouteBuilder(
//         opaque: false,
//         transitionDuration: const Duration(milliseconds: 350),
//         pageBuilder: (_, a, __) => FadeTransition(
//           opacity: a,
//           child: _FullscreenPhoto(
//             url : _photoUrl,
//             tag : 'photo_${widget.person['name']}',
//             name: widget.person['name'] ?? '',
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // ═══════════════════════════════════════════════════════════════════════════════
// //  FULLSCREEN PHOTO VIEWER
// // ═══════════════════════════════════════════════════════════════════════════════
// class _FullscreenPhoto extends StatefulWidget {
//   final String url;
//   final String tag;
//   final String name;
//   const _FullscreenPhoto({required this.url, required this.tag, required this.name});
//
//   @override
//   State<_FullscreenPhoto> createState() => _FullscreenPhotoState();
// }
//
// class _FullscreenPhotoState extends State<_FullscreenPhoto> {
//   final TransformationController _tc = TransformationController();
//   bool   _showUI = true;
//   double _scale  = 1.0;
//
//   @override
//   void dispose() { _tc.dispose(); super.dispose(); }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: GestureDetector(
//         onTap: () => setState(() => _showUI = !_showUI),
//         child: Stack(fit: StackFit.expand, children: [
//           // Zoomable photo
//           Center(
//             child: InteractiveViewer(
//               transformationController: _tc,
//               minScale: 0.5,
//               maxScale: 6.0,
//               onInteractionUpdate: (_) =>
//                   setState(() => _scale = _tc.value.getMaxScaleOnAxis()),
//               child: Hero(
//                 tag: widget.tag,
//                 child: Image.network(
//                   widget.url, fit: BoxFit.contain,
//                   errorBuilder: (_, __, ___) =>
//                   const Icon(Icons.broken_image_rounded, size: 80, color: Colors.white24),
//                 ),
//               ),
//             ),
//           ),
//
//           // Top bar
//           AnimatedOpacity(
//             opacity: _showUI ? 1.0 : 0.0,
//             duration: const Duration(milliseconds: 200),
//             child: Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter, end: Alignment.bottomCenter,
//                   colors: [Colors.black87, Colors.transparent],
//                 ),
//               ),
//               child: SafeArea(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//                   child: Row(children: [
//                     _GlassButton(
//                       onTap: () => Navigator.pop(context),
//                       child: const Icon(Icons.close_rounded, color: Colors.white, size: 20),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: Text(widget.name,
//                           style: const TextStyle(color: Colors.white,
//                               fontSize: 16, fontWeight: FontWeight.w700),
//                           overflow: TextOverflow.ellipsis),
//                     ),
//                     if (_scale > 1.05)
//                       _GlassButton(
//                         onTap: () { _tc.value = Matrix4.identity(); setState(() => _scale = 1.0); },
//                         child: const Icon(Icons.zoom_out_map_rounded, color: Colors.white70, size: 18),
//                       ),
//                   ]),
//                 ),
//               ),
//             ),
//           ),
//
//           // Bottom hint
//           AnimatedOpacity(
//             opacity: _showUI ? 1.0 : 0.0,
//             duration: const Duration(milliseconds: 200),
//             child: Align(
//               alignment: Alignment.bottomCenter,
//               child: Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.bottomCenter, end: Alignment.topCenter,
//                     colors: [Colors.black87, Colors.transparent],
//                   ),
//                 ),
//                 child: const Row(children: [
//                   Icon(Icons.pinch_rounded, size: 13, color: Colors.white38),
//                   SizedBox(width: 6),
//                   Text("Pinch to zoom  •  Tap to toggle controls",
//                       style: TextStyle(color: Colors.white38, fontSize: 12)),
//                 ]),
//               ),
//             ),
//           ),
//         ]),
//       ),
//     );
//   }
// }
//
// // ═══════════════════════════════════════════════════════════════════════════════
// //  SHARED / REUSABLE WIDGETS
// // ═══════════════════════════════════════════════════════════════════════════════
//
// class _Header extends StatelessWidget {
//   final int count; final bool loading;
//   final VoidCallback onBack; final VoidCallback onRefresh;
//   const _Header({required this.count, required this.loading,
//     required this.onBack, required this.onRefresh});
//
//   @override
//   Widget build(BuildContext context) => Padding(
//     padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
//     child: Row(children: [
//       _GlassButton(onTap: onBack,
//           child: const Icon(Icons.arrow_back_ios_new_rounded,
//               color: _T.textPrimary, size: 17)),
//       const SizedBox(width: 14),
//       Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         const Text("Missing Persons",
//             style: TextStyle(color: _T.textPrimary, fontSize: 21,
//                 fontWeight: FontWeight.w800, letterSpacing: 0.2)),
//         Text(loading ? "Loading records…" : "$count record${count == 1 ? '' : 's'} found",
//             style: const TextStyle(color: _T.textSub, fontSize: 12)),
//       ])),
//       _GlassButton(onTap: onRefresh,
//           child: const Icon(Icons.refresh_rounded, color: _T.accentCyan, size: 20)),
//     ]),
//   );
// }
//
// class _SearchBar extends StatelessWidget {
//   final TextEditingController controller;
//   final ValueChanged<String> onChanged;
//   const _SearchBar({required this.controller, required this.onChanged});
//
//   @override
//   Widget build(BuildContext context) => Padding(
//     padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
//     child: ClipRRect(
//       borderRadius: BorderRadius.circular(14),
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//         child: Container(
//           decoration: BoxDecoration(
//             color: _T.glass, borderRadius: BorderRadius.circular(14),
//             border: Border.all(color: _T.glassBorder),
//           ),
//           child: TextField(
//             controller: controller, onChanged: onChanged,
//             style: const TextStyle(color: _T.textPrimary, fontSize: 14),
//             decoration: const InputDecoration(
//               hintText: "Search by name…",
//               hintStyle: TextStyle(color: _T.textSub, fontSize: 14),
//               prefixIcon: Icon(Icons.search_rounded, color: _T.textSub, size: 20),
//               border: InputBorder.none,
//               contentPadding: EdgeInsets.symmetric(vertical: 14),
//             ),
//           ),
//         ),
//       ),
//     ),
//   );
// }
//
// class _GenderFilter extends StatelessWidget {
//   final String selected;
//   final ValueChanged<String> onSelect;
//   const _GenderFilter({required this.selected, required this.onSelect});
//
//   @override
//   Widget build(BuildContext context) {
//     const opts = ['All', 'Male', 'Female', 'Other'];
//     return SizedBox(
//       height: 36,
//       child: ListView.separated(
//         scrollDirection: Axis.horizontal,
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         itemCount: opts.length,
//         separatorBuilder: (_, __) => const SizedBox(width: 8),
//         itemBuilder: (_, i) {
//           final active = selected == opts[i];
//           return GestureDetector(
//             onTap: () => onSelect(opts[i]),
//             child: AnimatedContainer(
//               duration: const Duration(milliseconds: 200),
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(20),
//                 color : active ? _T.accentBlue : _T.glass,
//                 border: Border.all(color: active ? _T.accentBlue : _T.glassBorder),
//               ),
//               child: Text(opts[i], style: TextStyle(
//                 color: active ? Colors.white : _T.textSub,
//                 fontSize: 12,
//                 fontWeight: active ? FontWeight.w700 : FontWeight.w400,
//               )),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
//
// class _PersonCard extends StatefulWidget {
//   final Map person; final String imageurl;
//   final int index;  final VoidCallback onTap;
//   const _PersonCard({required this.person, required this.imageurl,
//     required this.index, required this.onTap});
//
//   @override
//   State<_PersonCard> createState() => _PersonCardState();
// }
//
// class _PersonCardState extends State<_PersonCard> {
//   bool _pressed = false;
//   bool get _hasPhoto {
//     final p = widget.person['photo'];
//     return p != null && p.toString().isNotEmpty;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final p = widget.person;
//     return GestureDetector(
//       onTap      : widget.onTap,
//       onTapDown  : (_) => setState(() => _pressed = true),
//       onTapUp    : (_) => setState(() => _pressed = false),
//       onTapCancel:  () => setState(() => _pressed = false),
//       child: AnimatedScale(
//         scale: _pressed ? 0.97 : 1.0,
//         duration: const Duration(milliseconds: 120),
//         child: Container(
//           margin: const EdgeInsets.only(bottom: 14),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(22),
//             border: Border.all(color: _T.glassBorder),
//             gradient: LinearGradient(
//               begin: Alignment.topLeft, end: Alignment.bottomRight,
//               colors: [
//                 Colors.white.withOpacity(0.07),
//                 Colors.white.withOpacity(0.02),
//               ],
//             ),
//             boxShadow: [
//               BoxShadow(
//                 color: _T.accentBlue.withOpacity(0.10),
//                 blurRadius: 24, spreadRadius: -6, offset: const Offset(0, 10),
//               ),
//             ],
//           ),
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(22),
//             child: BackdropFilter(
//               filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
//               child: Row(children: [
//                 // Photo strip
//                 Container(
//                   width: 90, height: 130,
//                   decoration: BoxDecoration(
//                     borderRadius: const BorderRadius.only(
//                         topLeft: Radius.circular(22),
//                         bottomLeft: Radius.circular(22)),
//                     gradient: LinearGradient(
//                       begin: Alignment.topLeft, end: Alignment.bottomRight,
//                       colors: [_T.accentBlue.withOpacity(0.4), _T.bgCard],
//                     ),
//                   ),
//                   child: ClipRRect(
//                     borderRadius: const BorderRadius.only(
//                         topLeft: Radius.circular(22),
//                         bottomLeft: Radius.circular(22)),
//                     child: _hasPhoto
//                         ? Image.network(
//                       p['photo'], fit: BoxFit.cover,
//                       errorBuilder: (_, __, ___) => Center(
//                         child: Icon(Icons.person_rounded, size: 40,
//                             color: _T.accentCyan.withOpacity(0.4)),
//                       ),
//                     )
//                         : Center(
//                       child: Icon(Icons.person_rounded, size: 40,
//                           color: _T.accentCyan.withOpacity(0.4)),
//                     ),
//                   ),
//                 ),
//                 // Info
//                 Expanded(
//                   child: Padding(
//                     padding: const EdgeInsets.fromLTRB(14, 14, 12, 14),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(children: [
//                           Expanded(
//                             child: Text(p['name'] ?? 'Unknown',
//                                 style: const TextStyle(color: _T.textPrimary,
//                                     fontSize: 15, fontWeight: FontWeight.w700),
//                                 overflow: TextOverflow.ellipsis),
//                           ),
//                           Container(
//                             padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
//                             decoration: BoxDecoration(
//                               color: (p['is_resolved'] == true
//                                   ? _T.success
//                                   : _T.danger).withOpacity(0.12),
//                               borderRadius: BorderRadius.circular(6),
//                               border: Border.all(color: (p['is_resolved'] == true
//                                   ? _T.success
//                                   : _T.danger).withOpacity(0.4)),
//                             ),
//                             child: Text(
//                               p['is_resolved'] == true ? "FOUND" : "MISSING",
//                               style: TextStyle(
//                                 color: p['is_resolved'] == true ? _T.success : _T.danger,
//                                 fontSize: 8,
//                                 fontWeight: FontWeight.w800,
//                                 letterSpacing: 0.8,
//                               ),
//                             ),
//                           ),
//                         ]),
//                         const SizedBox(height: 8),
//                         _MiniRow(icon: Icons.wc_rounded,        value: p['gender'] ?? '-'),
//                         const SizedBox(height: 4),
//                         _MiniRow(icon: Icons.cake_outlined,     value: "Age: ${p['age'] ?? '-'}"),
//                         const SizedBox(height: 4),
//                         _MiniRow(icon: Icons.info_outline_rounded,
//                             value: p['details'] ?? '-', maxLines: 1),
//                         const SizedBox(height: 10),
//                         Align(
//                           alignment: Alignment.centerRight,
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(20),
//                               gradient: const LinearGradient(
//                                   colors: [_T.accentBlue, _T.accentPurple]),
//                             ),
//                             child: const Row(mainAxisSize: MainAxisSize.min, children: [
//                               Text("View Details",
//                                   style: TextStyle(color: Colors.white,
//                                       fontSize: 11, fontWeight: FontWeight.w700)),
//                               SizedBox(width: 4),
//                               Icon(Icons.arrow_forward_ios_rounded,
//                                   color: Colors.white, size: 10),
//                             ]),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ]),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class _MiniRow extends StatelessWidget {
//   final IconData icon; final String value; final int maxLines;
//   const _MiniRow({required this.icon, required this.value, this.maxLines = 1});
//
//   @override
//   Widget build(BuildContext context) => Row(children: [
//     Icon(icon, size: 12, color: _T.textSub),
//     const SizedBox(width: 5),
//     Expanded(child: Text(value,
//         style: const TextStyle(color: _T.textSub, fontSize: 12),
//         maxLines: maxLines, overflow: TextOverflow.ellipsis)),
//   ]);
// }
//
// class _SectionLabel extends StatelessWidget {
//   final String label;
//   const _SectionLabel({required this.label});
//
//   @override
//   Widget build(BuildContext context) => Row(children: [
//     Container(
//       width: 3, height: 16,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(2),
//         gradient: const LinearGradient(
//           colors: [_T.accentBlue, _T.accentPurple],
//           begin: Alignment.topCenter, end: Alignment.bottomCenter,
//         ),
//       ),
//     ),
//     const SizedBox(width: 8),
//     Text(label, style: const TextStyle(color: _T.textSub,
//         fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.0)),
//   ]);
// }
//
// class _InfoGrid extends StatelessWidget {
//   final Map person;
//   const _InfoGrid({required this.person});
//
//   @override
//   Widget build(BuildContext context) {
//     final items = [
//       {'icon': Icons.wc_rounded,           'label': 'Gender',   'value': person['gender']          ?? '-'},
//       {'icon': Icons.cake_outlined,         'label': 'Age',      'value': person['age']             ?? '-'},
//       {'icon': Icons.fingerprint_rounded,   'label': 'Case ID',  'value': person['id']?.toString() ?? '-'},
//       {'icon': Icons.local_police_rounded,  'label': 'Station',  'value': person['station']         ?? '-'},
//     ];
//     return GridView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2, childAspectRatio: 2.5,
//         crossAxisSpacing: 10, mainAxisSpacing: 10,
//       ),
//       itemCount: items.length,
//       itemBuilder: (_, i) => _GlassTile(
//         icon : items[i]['icon'] as IconData,
//         label: items[i]['label'] as String,
//         value: items[i]['value'] as String,
//       ),
//     );
//   }
// }
//
// class _GlassTile extends StatelessWidget {
//   final IconData icon; final String label; final String value;
//   const _GlassTile({required this.icon, required this.label, required this.value});
//
//   @override
//   Widget build(BuildContext context) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(14),
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//           decoration: BoxDecoration(
//             color: _T.glass,
//             borderRadius: BorderRadius.circular(14),
//             border: Border.all(color: _T.glassBorder),
//           ),
//           child: Row(children: [
//             Container(
//               width: 30, height: 30,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: _T.accentBlue.withOpacity(0.15),
//               ),
//               child: Icon(icon, size: 14, color: _T.accentCyan),
//             ),
//             const SizedBox(width: 10),
//             Expanded(child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(label, style: const TextStyle(color: _T.textSub, fontSize: 10)),
//                 Text(value, style: const TextStyle(color: _T.textPrimary,
//                     fontSize: 13, fontWeight: FontWeight.w700),
//                     overflow: TextOverflow.ellipsis),
//               ],
//             )),
//           ]),
//         ),
//       ),
//     );
//   }
// }
//
// class _DetailsCard extends StatelessWidget {
//   final Map person;
//   const _DetailsCard({required this.person});
//
//   @override
//   Widget build(BuildContext context) => ClipRRect(
//     borderRadius: BorderRadius.circular(16),
//     child: BackdropFilter(
//       filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//       child: Container(
//         width: double.infinity,
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: _T.glass, borderRadius: BorderRadius.circular(16),
//           border: Border.all(color: _T.glassBorder),
//         ),
//         child: Text(
//           person['details']?.toString().isNotEmpty == true
//               ? person['details'].toString()
//               : 'No additional case details provided.',
//           style: const TextStyle(color: _T.textPrimary, fontSize: 14, height: 1.65),
//         ),
//       ),
//     ),
//   );
// }
//
// class _StatusCard extends StatelessWidget {
//   final Map person;
//   const _StatusCard({required this.person});
//
//   @override
//   Widget build(BuildContext context) {
//     final isResolved = person['is_resolved'] == true;
//     final color       = isResolved ? _T.success : _T.danger;
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(16),
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//         child: Container(
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: color.withOpacity(0.07),
//             borderRadius: BorderRadius.circular(16),
//             border: Border.all(color: color.withOpacity(0.35)),
//           ),
//           child: Row(children: [
//             Container(
//               width: 44, height: 44,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: color.withOpacity(0.15),
//               ),
//               child: Icon(
//                   isResolved ? Icons.check_circle_rounded : Icons.search_rounded,
//                   color: color, size: 22),
//             ),
//             const SizedBox(width: 14),
//             Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//               Text(isResolved ? "Person Found" : "Currently Missing",
//                   style: TextStyle(color: color, fontSize: 15, fontWeight: FontWeight.w800)),
//               const SizedBox(height: 2),
//               Text(isResolved ? "Case has been resolved" : "Investigation is ongoing",
//                   style: const TextStyle(color: _T.textSub, fontSize: 12)),
//             ]),
//           ]),
//         ),
//       ),
//     );
//   }
// }
//
// // ─── Investigation Report Card ───────────────────────────────────────────────
// class _ReportCard extends StatelessWidget {
//   final String report;
//   const _ReportCard({required this.report});
//
//   @override
//   Widget build(BuildContext context) => ClipRRect(
//     borderRadius: BorderRadius.circular(16),
//     child: BackdropFilter(
//       filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//       child: Container(
//         width: double.infinity,
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: _T.success.withOpacity(0.06),
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(color: _T.success.withOpacity(0.35)),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(children: [
//               Container(
//                 width: 32, height: 32,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: _T.success.withOpacity(0.15),
//                 ),
//                 child: const Icon(Icons.assignment_turned_in_rounded,
//                     color: _T.success, size: 16),
//               ),
//               const SizedBox(width: 10),
//               const Text(
//                 "Official Police Report",
//                 style: TextStyle(
//                   color: _T.success,
//                   fontSize: 13,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//             ]),
//             const SizedBox(height: 12),
//             Container(
//               width: double.infinity,
//               height: 1,
//               color: _T.success.withOpacity(0.2),
//             ),
//             const SizedBox(height: 12),
//             Text(
//               report,
//               style: const TextStyle(
//                 color: _T.textPrimary,
//                 fontSize: 14,
//                 height: 1.7,
//               ),
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// }
//
// class _ShareButton extends StatelessWidget {
//   final Map person;
//   const _ShareButton({required this.person});
//
//   @override
//   Widget build(BuildContext context) => GestureDetector(
//     onTap: () {
//       final info =
//           "🚨 MISSING PERSON ALERT 🚨\n"
//           "Name   : ${person['name']       ?? 'Unknown'}\n"
//           "Gender : ${person['gender']     ?? '-'}\n"
//           "Age    : ${person['age']        ?? '-'}\n"
//           "Details: ${person['details']    ?? '-'}\n\n"
//           "Please help us find this person and contact the authorities.";
//       Clipboard.setData(ClipboardData(text: info));
//       Fluttertoast.showToast(msg: "Copied to clipboard!");
//     },
//     child: Container(
//       width: double.infinity,
//       padding: const EdgeInsets.symmetric(vertical: 16),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(16),
//         gradient: const LinearGradient(colors: [_T.accentBlue, _T.accentPurple]),
//         boxShadow: [
//           BoxShadow(color: _T.accentBlue.withOpacity(0.40),
//               blurRadius: 20, spreadRadius: -4, offset: const Offset(0, 8)),
//         ],
//       ),
//       child: const Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.share_rounded, color: Colors.white, size: 18),
//           SizedBox(width: 8),
//           Text("Share / Copy Info",
//               style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
//         ],
//       ),
//     ),
//   );
// }
//
// class _Loader extends StatelessWidget {
//   final AnimationController anim;
//   const _Loader({required this.anim});
//
//   @override
//   Widget build(BuildContext context) => Center(
//     child: Column(mainAxisSize: MainAxisSize.min, children: [
//       AnimatedBuilder(
//         animation: anim,
//         builder: (_, __) => Transform.scale(
//           scale: 0.9 + 0.1 * anim.value,
//           child: Container(
//             width: 64, height: 64,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               gradient: RadialGradient(colors: [
//                 _T.accentBlue.withOpacity(0.3 + 0.2 * anim.value),
//                 Colors.transparent,
//               ]),
//             ),
//             child: const Center(
//               child: SizedBox(width: 36, height: 36,
//                   child: CircularProgressIndicator(
//                     strokeWidth: 2,
//                     valueColor: AlwaysStoppedAnimation(_T.accentCyan),
//                   )),
//             ),
//           ),
//         ),
//       ),
//       const SizedBox(height: 16),
//       const Text("Fetching records…",
//           style: TextStyle(color: _T.textSub, fontSize: 13)),
//     ]),
//   );
// }
//
// class _EmptyState extends StatelessWidget {
//   final bool hasQuery;
//   const _EmptyState({required this.hasQuery});
//
//   @override
//   Widget build(BuildContext context) => Center(
//     child: Column(mainAxisSize: MainAxisSize.min, children: [
//       Icon(hasQuery ? Icons.search_off_rounded : Icons.person_off_rounded,
//           size: 64, color: _T.textSub.withOpacity(0.25)),
//       const SizedBox(height: 14),
//       Text(hasQuery ? "No results found" : "No records available",
//           style: const TextStyle(color: _T.textSub, fontSize: 15)),
//       if (hasQuery) ...[
//         const SizedBox(height: 6),
//         const Text("Try a different name or filter",
//             style: TextStyle(color: _T.textSub, fontSize: 12)),
//       ],
//     ]),
//   );
// }
//
// class _FabScrollTop extends StatefulWidget {
//   final ScrollController ctrl;
//   const _FabScrollTop({required this.ctrl});
//
//   @override
//   State<_FabScrollTop> createState() => _FabScrollTopState();
// }
//
// class _FabScrollTopState extends State<_FabScrollTop> {
//   bool _visible = false;
//
//   @override
//   void initState() {
//     super.initState();
//     widget.ctrl.addListener(() {
//       final show = widget.ctrl.hasClients && widget.ctrl.offset > 200;
//       if (show != _visible) setState(() => _visible = show);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) => AnimatedOpacity(
//     opacity: _visible ? 1.0 : 0.0,
//     duration: const Duration(milliseconds: 250),
//     child: AnimatedScale(
//       scale: _visible ? 1.0 : 0.7,
//       duration: const Duration(milliseconds: 250),
//       child: _GlassButton(
//         onTap: () => widget.ctrl.animateTo(0,
//             duration: const Duration(milliseconds: 400), curve: Curves.easeOut),
//         child: const Icon(Icons.keyboard_arrow_up_rounded,
//             color: _T.accentCyan, size: 22),
//       ),
//     ),
//   );
// }
//
// class _GlassButton extends StatelessWidget {
//   final VoidCallback onTap;
//   final Widget child;
//   const _GlassButton({required this.onTap, required this.child});
//
//   @override
//   Widget build(BuildContext context) => GestureDetector(
//     onTap: onTap,
//     child: ClipRRect(
//       borderRadius: BorderRadius.circular(12),
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//         child: Container(
//           width: 42, height: 42,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(12),
//             color: _T.glass,
//             border: Border.all(color: _T.glassBorder),
//           ),
//           child: Center(child: child),
//         ),
//       ),
//     ),
//   );
// }
//
// class _BgPainter extends StatelessWidget {
//   const _BgPainter();
//
//   @override
//   Widget build(BuildContext context) =>
//       SizedBox.expand(child: CustomPaint(painter: _BgCPainter()));
// }
//
// class _BgCPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size s) {
//     canvas.drawRect(Rect.fromLTWH(0, 0, s.width, s.height),
//         Paint()..color = _T.bgDeep);
//
//     void glow(Offset c, double r, Color col, double op) {
//       canvas.drawCircle(c, r, Paint()
//         ..shader = RadialGradient(
//           colors: [col.withOpacity(op), Colors.transparent],
//         ).createShader(Rect.fromCircle(center: c, radius: r)));
//     }
//
//     glow(Offset(s.width * 0.82, s.height * 0.05), s.width * 0.55, _T.accentBlue,   0.26);
//     glow(Offset(s.width * 0.15, s.height * 0.88), s.width * 0.45, _T.accentPurple, 0.20);
//     glow(Offset(s.width * 0.50, s.height * 0.45), s.width * 0.28, _T.accentCyan,   0.06);
//   }
//
//   @override
//   bool shouldRepaint(_) => false;
// }