// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
//
// import 'home.dart';
//
// void main() {
//   runApp(const ComplaintScreen());
// }
//
// class ComplaintScreen extends StatelessWidget {
//   const ComplaintScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Complaints',
//       home: const ComplaintPage(title: 'My Complaints'),
//     );
//   }
// }
//
// class ComplaintPage extends StatefulWidget {
//   const ComplaintPage({super.key, required this.title});
//   final String title;
//
//   @override
//   State<ComplaintPage> createState() => _ComplaintPageState();
// }
//
// class _ComplaintPageState extends State<ComplaintPage> {
//   List<String> id_ = [];
//   List<String> description_ = [];
//   List<String> date_ = [];
//   List<String> reply_ = [];
//
//   TextEditingController complaintController = TextEditingController();
//   bool isLoading = true;
//   bool isSending = false;
//
//   @override
//   void initState() {
//     super.initState();
//     user_view_complaints();
//   }
//
//   @override
//   void dispose() {
//     complaintController.dispose();
//     super.dispose();
//   }
//
//   Future<void> user_view_complaints() async {
//     setState(() {
//       isLoading = true;
//     });
//
//     SharedPreferences sh = await SharedPreferences.getInstance();
//     String urls = sh.getString('url') ?? '';
//     String lid = sh.getString('lid') ?? '';
//
//     String url = '$urls/user_view_complaints/';
//
//     var response = await http.post(Uri.parse(url), body: {'lid': lid});
//     var jsondata = json.decode(response.body);
//
//     if (jsondata['status'] == 'ok') {
//       List<String> id = [];
//       List<String> complaint = [];
//       List<String> date = [];
//       List<String> reply = [];
//
//       var arr = jsondata["data"];
//       for (var comp in arr) {
//         id.add(comp['id'].toString());
//         complaint.add(comp['complaint'].toString());
//         date.add(comp['date'].toString());
//         reply.add(comp['reply'].toString());
//       }
//
//       setState(() {
//         id_ = id;
//         description_ = complaint;
//         date_ = date;
//         reply_ = reply;
//         isLoading = false;
//       });
//     } else {
//       Fluttertoast.showToast(msg: 'No complaints found');
//       setState(() {
//         id_ = [];
//         description_ = [];
//         date_ = [];
//         reply_ = [];
//         isLoading = false;
//       });
//     }
//   }
//
//   void _sendData() async {
//     String complaintText = complaintController.text.trim();
//     if (complaintText.isEmpty) {
//       Fluttertoast.showToast(msg: "Please enter your complaint");
//       return;
//     }
//
//     setState(() {
//       isSending = true;
//     });
//
//     SharedPreferences sh = await SharedPreferences.getInstance();
//     String? url = sh.getString('url');
//     String? lid = sh.getString('lid');
//
//     if (url == null) {
//       Fluttertoast.showToast(msg: "URL not found");
//       setState(() => isSending = false);
//       return;
//     }
//
//     Uri apiUrl = Uri.parse('$url/user_send_complaint/');
//
//     var response = await http.post(apiUrl, body: {
//       'complaint': complaintText,
//       'lid': lid,
//     });
//
//     setState(() {
//       isSending = false;
//     });
//
//     if (response.statusCode == 200) {
//       var jsonData = jsonDecode(response.body);
//       if (jsonData['status'] == 'ok') {
//         Fluttertoast.showToast(msg: 'Complaint sent');
//         complaintController.clear();
//         await user_view_complaints();
//       } else {
//         Fluttertoast.showToast(msg: 'Failed to send complaint');
//       }
//     } else {
//       Fluttertoast.showToast(msg: 'Network error');
//     }
//   }
//
//   Widget buildComplaintCard(int index) {
//     bool hasReply = reply_[index].isNotEmpty && reply_[index] != "null";
//
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(10),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//
//             SizedBox(height: 5),
//             Text("Date: ${date_[index]}"),
//             SizedBox(height: 10),
//             Text("Complaint: ${description_[index]}"),
//             SizedBox(height: 10),
//             Text(hasReply ? "Reply: ${reply_[index]}" : "No reply yet",
//                 style: TextStyle(
//                   color: hasReply ? Colors.green : Colors.grey,
//                 )),
//           ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//
//       body: Column(
//         children: [
//           Expanded(
//             child: isLoading
//                 ? Center(child: CircularProgressIndicator())
//                 : id_.isEmpty
//                 ? Center(child: Text("No Complaints Found"))
//                 : RefreshIndicator(
//               onRefresh: user_view_complaints,
//               child: ListView.builder(
//                 itemCount: id_.length,
//                 itemBuilder: (context, index) {
//                   return buildComplaintCard(index);
//                 },
//               ),
//             ),
//           ),
//
//           // Simple Bottom Section
//           Padding(
//             padding: const EdgeInsets.all(10),
//             child: Column(
//               children: [
//                 TextField(
//                   controller: complaintController,
//                   maxLines: 2,
//                   decoration: InputDecoration(
//                     hintText: "Write your complaint...",
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 ElevatedButton(
//                   onPressed: isSending ? null : _sendData,
//                   child: isSending
//                       ? CircularProgressIndicator()
//                       : Text("Send"),
//                 ),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }




import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// ═══════════════════════════════════════════════════════════════════════════════
//  THEME  — matching the app's dark-blue glassmorphic style
// ═══════════════════════════════════════════════════════════════════════════════
class _T {
  static const bgDeep       = Color(0xFF04091A);
  static const accentBlue   = Color(0xFF1D6BFF);
  static const accentCyan   = Color(0xFF00C2FF);
  static const accentPurple = Color(0xFF7B5CFF);
  static const success      = Color(0xFF00E5A0);
  static const warning      = Color(0xFFFFB347);
  static const textPrimary  = Color(0xFFEEF3FF);
  static const textSub      = Color(0xFF6E8CB8);
  static const glass        = Color(0x12FFFFFF);
  static const glassBorder  = Color(0x22FFFFFF);
}

// ═══════════════════════════════════════════════════════════════════════════════
//  ENTRY
// ═══════════════════════════════════════════════════════════════════════════════
void main() => runApp(const ComplaintScreen());

class ComplaintScreen extends StatelessWidget {
  const ComplaintScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ComplaintPage(title: 'My Complaints'),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  MAIN PAGE
// ═══════════════════════════════════════════════════════════════════════════════
class ComplaintPage extends StatefulWidget {
  const ComplaintPage({super.key, required this.title});
  final String title;

  @override
  State<ComplaintPage> createState() => _ComplaintPageState();
}

class _ComplaintPageState extends State<ComplaintPage>
    with TickerProviderStateMixin {
  // ── data (original lists preserved) ──────────────────────────
  List<String> id_          = [];
  List<String> description_ = [];
  List<String> date_        = [];
  List<String> reply_       = [];

  final TextEditingController complaintController = TextEditingController();
  final ScrollController       _scrollCtrl        = ScrollController();
  final FocusNode              _focusNode          = FocusNode();

  bool isLoading = true;
  bool isSending = false;
  bool _isExpanded = false;   // compose panel toggle

  late final AnimationController _listAnim;
  late final AnimationController _composeAnim;

  // ── filter tab: All / Pending / Replied ───────────────────────
  int _tabIndex = 0;
  static const _tabs = ['All', 'Pending', 'Replied'];

  @override
  void initState() {
    super.initState();
    _listAnim    = AnimationController(vsync: this, duration: const Duration(milliseconds: 800))..forward();
    _composeAnim = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    user_view_complaints();
  }

  @override
  void dispose() {
    complaintController.dispose();
    _scrollCtrl.dispose();
    _focusNode.dispose();
    _listAnim.dispose();
    _composeAnim.dispose();
    super.dispose();
  }

  // ── backend: view complaints (original logic preserved) ────────
  Future<void> user_view_complaints() async {
    setState(() => isLoading = true);

    SharedPreferences sh = await SharedPreferences.getInstance();
    String urls = sh.getString('url') ?? '';
    String lid  = sh.getString('lid') ?? '';

    var response = await http.post(
      Uri.parse('$urls/user_view_complaints/'),
      body: {'lid': lid},
    );
    var jsondata = json.decode(response.body);

    if (jsondata['status'] == 'ok') {
      List<String> id = [], complaint = [], date = [], reply = [];
      for (var comp in jsondata['data'] as List) {
        id.add(comp['id'].toString());
        complaint.add(comp['complaint'].toString());
        date.add(comp['date'].toString());
        reply.add(comp['reply'].toString());
      }
      setState(() {
        id_          = id;
        description_ = complaint;
        date_        = date;
        reply_       = reply;
        isLoading    = false;
      });
      _listAnim.forward(from: 0);
    } else {
      Fluttertoast.showToast(msg: 'No complaints found');
      setState(() {
        id_ = []; description_ = []; date_ = []; reply_ = [];
        isLoading = false;
      });
    }
  }

  // ── backend: send complaint (original logic preserved) ─────────
  void _sendData() async {
    final complaintText = complaintController.text.trim();
    if (complaintText.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter your complaint");
      return;
    }

    setState(() => isSending = true);
    _focusNode.unfocus();

    SharedPreferences sh = await SharedPreferences.getInstance();
    String? url = sh.getString('url');
    String? lid = sh.getString('lid');

    if (url == null) {
      Fluttertoast.showToast(msg: "URL not found");
      setState(() => isSending = false);
      return;
    }

    var response = await http.post(
      Uri.parse('$url/user_send_complaint/'),
      body: {'complaint': complaintText, 'lid': lid},
    );

    setState(() => isSending = false);

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      if (jsonData['status'] == 'ok') {
        Fluttertoast.showToast(msg: 'Complaint submitted successfully');
        complaintController.clear();
        _toggleCompose(open: false);
        await user_view_complaints();
      } else {
        Fluttertoast.showToast(msg: 'Failed to send complaint');
      }
    } else {
      Fluttertoast.showToast(msg: 'Network error. Please retry.');
    }
  }

  // ── helpers ───────────────────────────────────────────────────
  void _toggleCompose({bool? open}) {
    final shouldOpen = open ?? !_isExpanded;
    setState(() => _isExpanded = shouldOpen);
    if (shouldOpen) {
      _composeAnim.forward();
      Future.delayed(const Duration(milliseconds: 350),
              () => _focusNode.requestFocus());
    } else {
      _composeAnim.reverse();
      _focusNode.unfocus();
    }
  }

  /// True only when server sent a real reply — guards against
  /// "", "null", "None", "none", "NULL", whitespace-only values
  static bool _replyExists(String r) {
    final t = r.trim();
    if (t.isEmpty) return false;
    final l = t.toLowerCase();
    // Treat any placeholder-like value as "no reply yet"
    const placeholders = {
      'null', 'none', 'pending', 'no reply', 'no reply yet',
      'n/a', 'na', '-', '--', '...', '..', '.',
    };
    return !placeholders.contains(l);
  }

  List<int> get _filteredIndices {
    return List.generate(id_.length, (i) => i).where((i) {
      final hasReply = _replyExists(reply_[i]);
      if (_tabIndex == 1) return !hasReply; // Pending tab
      if (_tabIndex == 2) return hasReply;  // Replied tab
      return true;                           // All tab
    }).toList();
  }

  // ── stats ─────────────────────────────────────────────────────
  int get _totalCount   => id_.length;
  int get _repliedCount => reply_.where((r) => _replyExists(r)).length;
  int get _pendingCount => _totalCount - _repliedCount;

  // ═══════════════════════════════════════════════════════════════
  //  BUILD
  // ═══════════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: _T.bgDeep,
        resizeToAvoidBottomInset: true,
        body: Stack(children: [
          const _BgPainter(),
          SafeArea(
            child: Column(children: [
              _buildHeader(),
              if (!isLoading && id_.isNotEmpty) _buildStatsRow(),
              _buildTabBar(),
              Expanded(child: _buildBody()),
              _buildComposePanel(),
            ]),
          ),
        ]),
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
      child: Row(children: [
        _GlassButton(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios_new_rounded,
              color: _T.textPrimary, size: 17),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text("My Complaints",
                style: TextStyle(color: _T.textPrimary, fontSize: 21,
                    fontWeight: FontWeight.w800, letterSpacing: 0.2)),
            Text(isLoading ? "Loading…" : "$_totalCount total complaint${_totalCount == 1 ? '' : 's'}",
                style: const TextStyle(color: _T.textSub, fontSize: 12)),
          ]),
        ),
        _GlassButton(
          onTap: user_view_complaints,
          child: const Icon(Icons.refresh_rounded, color: _T.accentCyan, size: 20),
        ),
      ]),
    );
  }

  // ── Stats row ─────────────────────────────────────────────────
  Widget _buildStatsRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Row(children: [
        Expanded(child: _StatChip(
            label: "Total", value: _totalCount,
            color: _T.accentBlue, icon: Icons.list_alt_rounded)),
        const SizedBox(width: 10),
        Expanded(child: _StatChip(
            label: "Pending", value: _pendingCount,
            color: _T.warning, icon: Icons.hourglass_empty_rounded)),
        const SizedBox(width: 10),
        Expanded(child: _StatChip(
            label: "Replied", value: _repliedCount,
            color: _T.success, icon: Icons.check_circle_outline_rounded)),
      ]),
    );
  }

  // ── Tab bar ───────────────────────────────────────────────────
  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            height: 42,
            decoration: BoxDecoration(
              color: _T.glass,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _T.glassBorder),
            ),
            child: Row(
              children: List.generate(_tabs.length, (i) {
                final active = _tabIndex == i;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _tabIndex = i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: active
                            ? const LinearGradient(
                            colors: [_T.accentBlue, _T.accentPurple])
                            : null,
                      ),
                      child: Center(
                        child: Text(_tabs[i],
                            style: TextStyle(
                              color: active ? Colors.white : _T.textSub,
                              fontSize: 12,
                              fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                            )),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  // ── Body ──────────────────────────────────────────────────────
  Widget _buildBody() {
    if (isLoading) return _buildLoader();

    final indices = _filteredIndices;

    if (indices.isEmpty) {
      return _EmptyState(
        icon : _tabIndex == 1
            ? Icons.check_circle_outline_rounded
            : _tabIndex == 2
            ? Icons.hourglass_empty_rounded
            : Icons.inbox_rounded,
        label: _tabIndex == 1
            ? "No pending complaints!"
            : _tabIndex == 2
            ? "No replies received yet"
            : "No complaints found",
        sub  : _tabIndex == 0
            ? "Tap the + button below to submit one"
            : null,
      );
    }

    return RefreshIndicator(
      onRefresh: user_view_complaints,
      color: _T.accentCyan,
      backgroundColor: const Color(0xFF0D1B3E),
      child: ListView.builder(
        controller  : _scrollCtrl,
        padding     : const EdgeInsets.fromLTRB(16, 0, 16, 16),
        itemCount   : indices.length,
        itemBuilder : (_, i) {
          final idx   = indices[i];
          final double start = ((i * 70) / 800.0).clamp(0.0, 0.85);
          final double end   = (start + 0.25).clamp(0.0, 1.0);
          final double span  = (end - start).clamp(0.01, 1.0);

          return AnimatedBuilder(
            animation: _listAnim,
            builder: (_, child) {
              final raw = ((_listAnim.value - start) / span).clamp(0.0, 1.0);
              final t   = Curves.easeOutCubic.transform(raw);
              return Opacity(
                opacity: t,
                child: Transform.translate(
                    offset: Offset(0, 24 * (1 - t)), child: child),
              );
            },
            child: _ComplaintCard(
              index      : idx,
              description: description_[idx],
              date       : date_[idx],
              reply      : reply_[idx],
            ),
          );
        },
      ),
    );
  }

  // ── Loader ────────────────────────────────────────────────────
  Widget _buildLoader() {
    return Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const SizedBox(
          width: 38, height: 38,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation(_T.accentCyan),
          ),
        ),
        const SizedBox(height: 14),
        const Text("Loading complaints…",
            style: TextStyle(color: _T.textSub, fontSize: 13)),
      ]),
    );
  }

  // ── Compose panel ─────────────────────────────────────────────
  Widget _buildComposePanel() {
    return AnimatedBuilder(
      animation: _composeAnim,
      builder: (_, __) {
        final t = Curves.easeOutCubic.transform(_composeAnim.value);
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Expanded compose area
            ClipRect(
              child: Align(
                heightFactor: t,
                child: _buildComposeArea(),
              ),
            ),
            // Bottom bar with FAB
            _buildBottomBar(),
          ],
        );
      },
    );
  }

  Widget _buildComposeArea() {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: _T.glassBorder, width: 1)),
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            color: Colors.white.withOpacity(0.04),
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  const Icon(Icons.edit_note_rounded,
                      color: _T.accentCyan, size: 18),
                  const SizedBox(width: 8),
                  const Text("New Complaint",
                      style: TextStyle(color: _T.textPrimary,
                          fontSize: 14, fontWeight: FontWeight.w700)),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => _toggleCompose(open: false),
                    child: const Icon(Icons.keyboard_arrow_down_rounded,
                        color: _T.textSub, size: 22),
                  ),
                ]),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: Container(
                      decoration: BoxDecoration(
                        color: _T.glass,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: _T.glassBorder),
                      ),
                      child: TextField(
                        controller : complaintController,
                        focusNode  : _focusNode,
                        maxLines   : 4,
                        maxLength  : 500,
                        style: const TextStyle(
                            color: _T.textPrimary, fontSize: 14, height: 1.5),
                        decoration: InputDecoration(
                          hintText: "Describe your complaint in detail…",
                          hintStyle: const TextStyle(
                              color: _T.textSub, fontSize: 14),
                          border  : InputBorder.none,
                          contentPadding: const EdgeInsets.all(14),
                          counterStyle: const TextStyle(
                              color: _T.textSub, fontSize: 10),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(children: [
                  // Character hint
                  const Icon(Icons.info_outline_rounded,
                      size: 12, color: _T.textSub),
                  const SizedBox(width: 4),
                  const Expanded(
                    child: Text("Be specific — include time, location, and details.",
                        style: TextStyle(color: _T.textSub, fontSize: 11)),
                  ),
                  // Send button
                  GestureDetector(
                    onTap: isSending ? null : _sendData,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        gradient: isSending
                            ? LinearGradient(colors: [
                          _T.accentBlue.withOpacity(0.5),
                          _T.accentPurple.withOpacity(0.5),
                        ])
                            : const LinearGradient(
                            colors: [_T.accentBlue, _T.accentPurple]),
                        boxShadow: isSending ? [] : [
                          BoxShadow(
                            color: _T.accentBlue.withOpacity(0.35),
                            blurRadius: 16, spreadRadius: -4,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: isSending
                          ? const SizedBox(width: 16, height: 16,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white))
                          : const Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(Icons.send_rounded, color: Colors.white, size: 15),
                        SizedBox(width: 6),
                        Text("Submit",
                            style: TextStyle(color: Colors.white,
                                fontSize: 13, fontWeight: FontWeight.w700)),
                      ]),
                    ),
                  ),
                ]),
                const SizedBox(height: 14),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.03),
            border: Border(top: BorderSide(color: _T.glassBorder, width: 1)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Count chip
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _T.glass,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _T.glassBorder),
                ),
                child: Row(children: [
                  const Icon(Icons.inbox_rounded, size: 13, color: _T.textSub),
                  const SizedBox(width: 5),
                  Text("$_totalCount complaint${_totalCount == 1 ? '' : 's'}",
                      style: const TextStyle(color: _T.textSub, fontSize: 12)),
                ]),
              ),
              // FAB
              GestureDetector(
                onTap: () => _toggleCompose(),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 52, height: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: _isExpanded
                        ? LinearGradient(colors: [
                      Colors.white.withOpacity(0.12),
                      Colors.white.withOpacity(0.06),
                    ])
                        : const LinearGradient(
                        colors: [_T.accentBlue, _T.accentPurple],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight),
                    border: Border.all(color: _T.glassBorder),
                    boxShadow: _isExpanded ? [] : [
                      BoxShadow(
                        color: _T.accentBlue.withOpacity(0.40),
                        blurRadius: 18, spreadRadius: -4,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Center(
                    child: AnimatedRotation(
                      turns: _isExpanded ? 0.125 : 0,
                      duration: const Duration(milliseconds: 250),
                      child: Icon(
                          _isExpanded ? Icons.close_rounded : Icons.add_rounded,
                          color: Colors.white, size: 24),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  COMPLAINT CARD
// ═══════════════════════════════════════════════════════════════════════════════
class _ComplaintCard extends StatefulWidget {
  final int    index;
  final String description;
  final String date;
  final String reply;

  const _ComplaintCard({
    required this.index,
    required this.description,
    required this.date,
    required this.reply,
  });

  @override
  State<_ComplaintCard> createState() => _ComplaintCardState();
}

class _ComplaintCardState extends State<_ComplaintCard> {
  bool _expanded = false;

  bool get _hasReply {
    final t = widget.reply.trim();
    if (t.isEmpty) return false;
    final l = t.toLowerCase();
    const placeholders = {
      'null', 'none', 'pending', 'no reply', 'no reply yet',
      'n/a', 'na', '-', '--', '...', '..', '.',
    };
    return !placeholders.contains(l);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: _hasReply
                ? _T.success.withOpacity(0.30)
                : _T.glassBorder,
          ),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.06),
              Colors.white.withOpacity(0.02),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: (_hasReply ? _T.success : _T.accentBlue).withOpacity(0.07),
              blurRadius: 20, spreadRadius: -6, offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Top row ────────────────────────────────
                  Row(children: [
                    // Status dot
                    Container(
                      width: 8, height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _hasReply ? _T.success : _T.warning,
                        boxShadow: [BoxShadow(
                          color: (_hasReply ? _T.success : _T.warning).withOpacity(0.5),
                          blurRadius: 6, spreadRadius: -1,
                        )],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _hasReply ? "Replied" : "Pending",
                      style: TextStyle(
                        color: _hasReply ? _T.success : _T.warning,
                        fontSize: 11, fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const Spacer(),
                    // Date
                    Row(children: [
                      const Icon(Icons.calendar_today_rounded,
                          size: 11, color: _T.textSub),
                      const SizedBox(width: 4),
                      Text(widget.date,
                          style: const TextStyle(
                              color: _T.textSub, fontSize: 11)),
                    ]),
                    const SizedBox(width: 10),
                    // Expand toggle
                    Icon(
                      _expanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      color: _T.textSub, size: 18,
                    ),
                  ]),

                  const SizedBox(height: 12),

                  // ── Complaint text ──────────────────────────
                  Text(
                    widget.description,
                    maxLines: _expanded ? null : 2,
                    overflow: _expanded ? TextOverflow.visible : TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: _T.textPrimary, fontSize: 14, height: 1.55,
                    ),
                  ),

                  // ── Reply (shown when expanded or when has reply) ──
                  if (_hasReply) ...[
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _T.success.withOpacity(0.07),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: _T.success.withOpacity(0.25)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            const Icon(Icons.reply_rounded,
                                size: 13, color: _T.success),
                            const SizedBox(width: 5),
                            const Text("Official Reply",
                                style: TextStyle(color: _T.success,
                                    fontSize: 11, fontWeight: FontWeight.w700)),
                          ]),
                          const SizedBox(height: 6),
                          Text(
                            widget.reply,
                            maxLines: _expanded ? null : 2,
                            overflow: _expanded
                                ? TextOverflow.visible
                                : TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: _T.textPrimary, fontSize: 13, height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ] else if (_expanded) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: _T.warning.withOpacity(0.07),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: _T.warning.withOpacity(0.25)),
                      ),
                      child: const Row(children: [
                        Icon(Icons.hourglass_empty_rounded,
                            size: 13, color: _T.warning),
                        SizedBox(width: 6),
                        Text("Awaiting official response…",
                            style: TextStyle(color: _T.warning,
                                fontSize: 12, fontWeight: FontWeight.w500)),
                      ]),
                    ),
                  ],

                  // ── Tap hint ────────────────────────────────
                  if (!_expanded && widget.description.length > 80) ...[
                    const SizedBox(height: 8),
                    const Text("Tap to read more",
                        style: TextStyle(color: _T.textSub, fontSize: 11)),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  STAT CHIP
// ═══════════════════════════════════════════════════════════════════════════════
class _StatChip extends StatelessWidget {
  final String  label;
  final int     value;
  final Color   color;
  final IconData icon;

  const _StatChip({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color.withOpacity(0.25)),
          ),
          child: Row(children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 7),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('$value',
                  style: TextStyle(
                      color: color, fontSize: 16, fontWeight: FontWeight.w800)),
              Text(label,
                  style: const TextStyle(color: _T.textSub, fontSize: 10)),
            ]),
          ]),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  EMPTY STATE
// ═══════════════════════════════════════════════════════════════════════════════
class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String   label;
  final String?  sub;

  const _EmptyState({required this.icon, required this.label, this.sub});

  @override
  Widget build(BuildContext context) => Center(
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 62, color: _T.textSub.withOpacity(0.22)),
      const SizedBox(height: 14),
      Text(label,
          style: const TextStyle(color: _T.textSub, fontSize: 15,
              fontWeight: FontWeight.w600)),
      if (sub != null) ...[
        const SizedBox(height: 6),
        Text(sub!,
            style: const TextStyle(color: _T.textSub, fontSize: 12)),
      ],
    ]),
  );
}

// ═══════════════════════════════════════════════════════════════════════════════
//  GLASS BUTTON
// ═══════════════════════════════════════════════════════════════════════════════
class _GlassButton extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;
  const _GlassButton({required this.onTap, required this.child});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: 42, height: 42,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: _T.glass,
            border: Border.all(color: _T.glassBorder),
          ),
          child: Center(child: child),
        ),
      ),
    ),
  );
}

// ═══════════════════════════════════════════════════════════════════════════════
//  BACKGROUND
// ═══════════════════════════════════════════════════════════════════════════════
class _BgPainter extends StatelessWidget {
  const _BgPainter();

  @override
  Widget build(BuildContext context) =>
      SizedBox.expand(child: CustomPaint(painter: _BgCP()));
}

class _BgCP extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    canvas.drawRect(Rect.fromLTWH(0, 0, s.width, s.height),
        Paint()..color = _T.bgDeep);

    void glow(Offset c, double r, Color col, double op) {
      canvas.drawCircle(c, r, Paint()
        ..shader = RadialGradient(
          colors: [col.withOpacity(op), Colors.transparent],
        ).createShader(Rect.fromCircle(center: c, radius: r)));
    }

    glow(Offset(s.width * 0.82, s.height * 0.06), s.width * 0.52,
        _T.accentBlue, 0.22);
    glow(Offset(s.width * 0.12, s.height * 0.88), s.width * 0.44,
        _T.accentPurple, 0.16);
    glow(Offset(s.width * 0.50, s.height * 0.46), s.width * 0.28,
        _T.accentCyan, 0.05);
  }

  @override
  bool shouldRepaint(_) => false;
}