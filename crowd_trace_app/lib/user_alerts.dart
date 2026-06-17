// import 'dart:convert';
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
//
// class UserHomeWithAlerts extends StatefulWidget {
//   const UserHomeWithAlerts({super.key});
//
//   @override
//   State<UserHomeWithAlerts> createState() => _UserHomeWithAlertsState();
// }
//
// class _UserHomeWithAlertsState extends State<UserHomeWithAlerts> {
//
//   List alerts = [];
//   bool loading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     loadAlerts();
//   }
//
//   // 🔹 FETCH ALERTS
//   Future loadAlerts() async {
//
//     SharedPreferences sh = await SharedPreferences.getInstance();
//
//     String baseUrl = sh.getString("url") ?? "";
//     String uid = sh.getString("lid") ?? "";
//
//     var uri = Uri.parse("$baseUrl/get_alerts/");
//
//     var response = await http.post(uri, body: {
//       "uid": uid
//     });
//
//     var data = jsonDecode(response.body);
//
//     if (data["status"] == "ok") {
//       setState(() {
//         alerts = data["data"];
//         loading = false;
//       });
//     } else {
//       setState(() {
//         loading = false;
//       });
//     }
//   }
//
//   // 🔹 GLASS ALERT CARD
//   Widget alertCard(Map a) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(20),
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
//         child: Container(
//           margin: const EdgeInsets.only(bottom: 12),
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(20),
//             color: Colors.white.withOpacity(0.06),
//             border: Border.all(color: Colors.white.withOpacity(0.1)),
//           ),
//           child: Row(
//             children: [
//               Icon(
//                 a["type"] == "case"
//                     ? Icons.folder
//                     : Icons.message,
//                 color: Colors.white,
//               ),
//               const SizedBox(width: 12),
//
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//
//                     Text(
//                       a["title"],
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//
//                     const SizedBox(height: 4),
//
//                     Text(
//                       a["message"],
//                       style: const TextStyle(color: Colors.white70),
//                     ),
//
//                     const SizedBox(height: 4),
//
//                     Text(
//                       a["date"],
//                       style: const TextStyle(
//                           color: Colors.white38,
//                           fontSize: 12),
//                     ),
//
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   // 🔹 MAIN UI
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//
//       backgroundColor: Colors.black,
//
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         elevation: 0,
//         title: const Text(
//           "User Home",
//           style: TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//       ),
//
//       body: loading
//
//           ? const Center(child: CircularProgressIndicator())
//
//           : Column(
//         children: [
//
//           // 🔥 ALERT SECTION
//           if (alerts.isNotEmpty)
//             Padding(
//               padding: const EdgeInsets.all(12),
//               child: Column(
//                 children: alerts.map((a) => alertCard(a)).toList(),
//               ),
//             ),
//
//           if (alerts.isEmpty)
//             const Padding(
//               padding: EdgeInsets.all(20),
//               child: Text(
//                 "No new updates",
//                 style: TextStyle(color: Colors.white70),
//               ),
//             ),
//
//           // 🔽 MAIN CONTENT (your normal home UI)
//           Expanded(
//             child: Center(
//               child: Text(
//                 "Main Content Here",
//                 style: TextStyle(color: Colors.white),
//               ),
//             ),
//           )
//
//         ],
//       ),
//     );
//   }
// }



import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// ─── Theme Constants ──────────────────────────────────────────────────────────
const kBg = Color(0xFF0A0A0F);
const kSurface = Color(0xFF13131A);
const kCard = Color(0xFF1C1C27);
const kBorder = Color(0xFF2A2A3D);
const kAccent = Color(0xFF6C63FF);
const kAccentSoft = Color(0x336C63FF);
const kSuccess = Color(0xFF22D3A5);
const kWarning = Color(0xFFFFB547);
const kDanger = Color(0xFFFF5C7A);
const kTextPrimary = Color(0xFFEEEEF5);
const kTextSecondary = Color(0xFF8888A8);
const kTextMuted = Color(0xFF44445A);

// ─── Alert Type Config ────────────────────────────────────────────────────────
class _AlertStyle {
  final IconData icon;
  final Color color;
  final String label;
  const _AlertStyle(this.icon, this.color, this.label);
}

_AlertStyle _styleFor(String? type) {
  switch (type) {
    case 'case':
      return const _AlertStyle(Icons.folder_open_rounded, kAccent, 'Case');
    case 'message':
      return const _AlertStyle(Icons.chat_bubble_outline_rounded, kSuccess, 'Message');
    case 'warning':
      return const _AlertStyle(Icons.warning_amber_rounded, kWarning, 'Warning');
    case 'error':
      return const _AlertStyle(Icons.error_outline_rounded, kDanger, 'Error');
    default:
      return const _AlertStyle(Icons.notifications_none_rounded, kAccent, 'Alert');
  }
}

// ─── Main Widget ──────────────────────────────────────────────────────────────
class UserHomeWithAlerts extends StatefulWidget {
  const UserHomeWithAlerts({super.key});

  @override
  State<UserHomeWithAlerts> createState() => _UserHomeWithAlertsState();
}

class _UserHomeWithAlertsState extends State<UserHomeWithAlerts>
    with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> _alerts = [];
  bool _loading = true;
  String? _error;
  late AnimationController _fadeCtrl;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _loadAlerts();
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    super.dispose();
  }

  // ── Fetch Alerts ─────────────────────────────────────────────────────────────
  Future<void> _loadAlerts() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final sh = await SharedPreferences.getInstance();
      final baseUrl = sh.getString('url') ?? '';
      final uid = sh.getString('lid') ?? '';

      if (baseUrl.isEmpty || uid.isEmpty) {
        setState(() {
          _error = 'Session data missing. Please log in again.';
          _loading = false;
        });
        return;
      }

      final uri = Uri.parse('$baseUrl/get_alerts/');
      final response = await http
          .post(uri, body: {'uid': uid})
          .timeout(const Duration(seconds: 15));

      if (response.statusCode != 200) {
        setState(() {
          _error = 'Server error (${response.statusCode}). Try again.';
          _loading = false;
        });
        return;
      }

      final data = jsonDecode(response.body);

      if (data['status'] == 'ok') {
        final raw = data['data'] as List? ?? [];
        setState(() {
          _alerts = raw.map((e) => Map<String, dynamic>.from(e)).toList();
          _loading = false;
        });
        _fadeCtrl.forward(from: 0);
      } else {
        setState(() {
          _error = data['message'] ?? 'Could not load notifications.';
          _loading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Network error. Check your connection.';
        _loading = false;
      });
    }
  }

  // ── Dismiss Alert ─────────────────────────────────────────────────────────────
  void _dismiss(int index) {
    setState(() => _alerts.removeAt(index));
  }

  // ── UI ────────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 16, 8),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Notifications',
                style: TextStyle(
                  color: kTextPrimary,
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                _alerts.isEmpty && !_loading && _error == null
                    ? 'All caught up'
                    : '${_alerts.length} unread',
                style: const TextStyle(color: kTextSecondary, fontSize: 13),
              ),
            ],
          ),
          const Spacer(),
          _IconBtn(icon: Icons.refresh_rounded, onTap: _loadAlerts),
          const SizedBox(width: 8),
          if (_alerts.isNotEmpty)
            _IconBtn(
              icon: Icons.done_all_rounded,
              onTap: () => setState(() => _alerts.clear()),
            ),
        ],
      ),
    );
  }

  // ── Body ──────────────────────────────────────────────────────────────────────
  Widget _buildBody() {
    if (_loading) return _buildLoading();
    if (_error != null) return _buildError();
    if (_alerts.isEmpty) return _buildEmpty();
    return _buildList();
  }

  Widget _buildLoading() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 36,
            height: 36,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation(kAccent),
            ),
          ),
          SizedBox(height: 16),
          Text('Loading notifications…',
              style: TextStyle(color: kTextSecondary, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: kDanger.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.wifi_off_rounded, color: kDanger, size: 28),
            ),
            const SizedBox(height: 16),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: kTextSecondary, fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 20),
            _PillButton(label: 'Try Again', onTap: _loadAlerts),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _EmptyIcon(),
          SizedBox(height: 16),
          Text(
            'No new notifications',
            style: TextStyle(
                color: kTextPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 6),
          Text(
            'You\'re all caught up for now',
            style: TextStyle(color: kTextSecondary, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildList() {
    return FadeTransition(
      opacity: _fadeCtrl,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        itemCount: _alerts.length,
        itemBuilder: (ctx, i) => _AlertCard(
          key: ValueKey(i),
          data: _alerts[i],
          index: i,
          onDismiss: () => _dismiss(i),
        ),
      ),
    );
  }
}

// ── Empty Icon (const-friendly) ───────────────────────────────────────────────
class _EmptyIcon extends StatelessWidget {
  const _EmptyIcon();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: kAccentSoft,
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.notifications_none_rounded,
        color: kAccent,
        size: 34,
      ),
    );
  }
}

// ─── Alert Card ───────────────────────────────────────────────────────────────
class _AlertCard extends StatefulWidget {
  final Map<String, dynamic> data;
  final int index;
  final VoidCallback onDismiss;

  const _AlertCard({
    super.key,
    required this.data,
    required this.index,
    required this.onDismiss,
  });

  @override
  State<_AlertCard> createState() => _AlertCardState();
}

class _AlertCardState extends State<_AlertCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _slide;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _slide = Tween(begin: 40.0, end: 0.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic),
    );
    _fade = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
    Future.delayed(Duration(milliseconds: widget.index * 60), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final a = widget.data;
    final style = _styleFor(a['type'] as String?);

    return AnimatedBuilder(
      animation: _ctrl,
      builder: (ctx, child) => Transform.translate(
        offset: Offset(0, _slide.value),
        child: Opacity(opacity: _fade.value, child: child),
      ),
      child: Dismissible(
        key: UniqueKey(),
        direction: DismissDirection.endToStart,
        background: _dismissBg(),
        onDismissed: (_) => widget.onDismiss(),
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: kCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: kBorder),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Colored accent bar
                  Container(width: 4, color: style.color),
                  // Content
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(14, 14, 12, 14),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Icon bubble
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: style.color.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child:
                            Icon(style.icon, color: style.color, size: 20),
                          ),
                          const SizedBox(width: 12),
                          // Text block
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        a['title'] ?? 'Notification',
                                        style: const TextStyle(
                                          color: kTextPrimary,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    // Type badge
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: style.color.withOpacity(0.12),
                                        borderRadius:
                                        BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        style.label,
                                        style: TextStyle(
                                          color: style.color,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.4,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  a['message'] ?? '',
                                  style: const TextStyle(
                                    color: kTextSecondary,
                                    fontSize: 13,
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const Icon(Icons.access_time_rounded,
                                        color: kTextMuted, size: 12),
                                    const SizedBox(width: 4),
                                    Text(
                                      a['date'] ?? '',
                                      style: const TextStyle(
                                          color: kTextMuted, fontSize: 11),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _dismissBg() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: kDanger.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kDanger.withOpacity(0.3)),
      ),
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      child: const Icon(Icons.delete_outline_rounded, color: kDanger, size: 22),
    );
  }
}

// ─── Reusable Helpers ─────────────────────────────────────────────────────────
class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _IconBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: kCard,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: kBorder),
        ),
        child: Icon(icon, color: kTextSecondary, size: 18),
      ),
    );
  }
}

class _PillButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _PillButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
        const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
        decoration: BoxDecoration(
          color: kAccent,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Text(
          label,
          style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 14),
        ),
      ),
    );
  }
}