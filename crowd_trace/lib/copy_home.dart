// // //
// // //
// // // import 'dart:convert';
// // // import 'dart:math' as math;
// // // import 'dart:ui';
// // // import 'package:crowd_trace/report_case.dart';
// // // import 'package:crowd_trace/upload_page.dart';
// // // import 'package:crowd_trace/view_cases.dart';
// // // import 'package:crowd_trace/view_uploads.dart';
// // // import 'package:flutter/material.dart';
// // // import 'package:flutter/services.dart';
// // // import 'package:http/http.dart' as http;
// // // import 'package:shared_preferences/shared_preferences.dart';
// // // import 'package:crowd_trace/complaint.dart';
// // // import 'package:crowd_trace/view_criminals.dart';
// // // import 'package:crowd_trace/view_missing_persons.dart';
// // // import 'package:crowd_trace/feedback.dart';
// // // import 'login.dart';
// // // import 'View_Police_Station.dart';
// // //
// // // // ═══════════════════════════════════════════════════════════════════════════════
// // // //  DESIGN TOKENS
// // // // ═══════════════════════════════════════════════════════════════════════════════
// // // class _T {
// // //   static const bg           = Color(0xFF04091A);
// // //   static const surface      = Color(0xFF080F26);
// // //   static const accentBlue   = Color(0xFF1D6BFF);
// // //   static const accentCyan   = Color(0xFF00C2FF);
// // //   static const accentPurple = Color(0xFF7B5CFF);
// // //   static const accentGold   = Color(0xFFFFB547);
// // //   static const accentRed    = Color(0xFFFF4057);
// // //   static const accentGreen  = Color(0xFF00E676);
// // //   static const textPrimary  = Color(0xFFEEF3FF);
// // //   static const textSub      = Color(0xFF5A7299);
// // //   static const textMid      = Color(0xFF8AAAD4);
// // //   static const glass        = Color(0x0FFFFFFF);
// // //   static const glassBorder  = Color(0x1AFFFFFF);
// // //   static const navBg        = Color(0xFF0A1428);
// // // }
// // //
// // // // ═══════════════════════════════════════════════════════════════════════════════
// // // //  TICKER MESSAGES
// // // // ═══════════════════════════════════════════════════════════════════════════════
// // // const _tickers = [
// // //   '🔴  CrowdTrace — Community-powered missing person identification system',
// // //   '📷  Upload a clear photo to help identify a missing person near you',
// // //   '🚨  Every report you submit can bring a family back together',
// // //   '🤝  Your single sighting can reunite a family — every second counts',
// // //   '📍  Real-time alerts for missing persons spotted in your area',
// // //   '👮  Trusted by police stations and citizens across the region',
// // //   '🔔  Register now and get priority access to new missing person alerts',
// // // ];
// // //
// // // // ═══════════════════════════════════════════════════════════════════════════════
// // // //  NAV CONFIG  — index 2 = centre Upload FAB
// // // // ═══════════════════════════════════════════════════════════════════════════════
// // // class _NavItem {
// // //   final String   label;
// // //   final IconData icon, activeIcon;
// // //   const _NavItem(this.label, this.icon, this.activeIcon);
// // // }
// // //
// // // const _navItems = [
// // //   _NavItem('Home',    Icons.home_outlined,          Icons.home_rounded),
// // //   _NavItem('Police',  Icons.local_police_outlined,  Icons.local_police_rounded),
// // //   _NavItem('',        Icons.add,                    Icons.add),       // FAB slot
// // //   _NavItem('Missing', Icons.person_search_outlined, Icons.manage_search_rounded),
// // //   _NavItem('Reports', Icons.assignment_outlined,    Icons.assignment_rounded),
// // // ];
// // //
// // // // ═══════════════════════════════════════════════════════════════════════════════
// // // //  ROOT WIDGET
// // // // ═══════════════════════════════════════════════════════════════════════════════
// // // class Home_page extends StatefulWidget {
// // //   const Home_page({super.key});
// // //   @override State<Home_page> createState() => _HomePageState();
// // // }
// // //
// // // class _HomePageState extends State<Home_page> with TickerProviderStateMixin {
// // //   int  _idx = 0;
// // //   late final AnimationController _fabPulse;
// // //
// // //   int  _stPolice  = 0;
// // //   int  _stMissing = 0;
// // //   int  _stCases   = 0;
// // //   bool _stLoaded  = false;
// // //
// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _fabPulse = AnimationController(
// // //         vsync: this, duration: const Duration(seconds: 2))
// // //       ..repeat(reverse: true);
// // //     _loadStats();
// // //   }
// // //
// // //   @override void dispose() { _fabPulse.dispose(); super.dispose(); }
// // //
// // //   Future<void> _loadStats() async {
// // //     try {
// // //       final sh   = await SharedPreferences.getInstance();
// // //       final base = sh.getString('url') ?? '';
// // //       final lid  = sh.getString('lid') ?? '';
// // //       final res  = await http.post(Uri.parse('$base/dashboard_stats/'),
// // //           body: {'lid': lid}).timeout(const Duration(seconds: 8));
// // //       if (res.statusCode == 200) {
// // //         final d = jsonDecode(res.body);
// // //         if (d['status'] == 'ok' && mounted) {
// // //           setState(() {
// // //             _stPolice  = int.tryParse(d['police_stations'].toString()) ?? 0;
// // //             _stMissing = int.tryParse(d['missing_persons'].toString()) ?? 0;
// // //             _stCases   = int.tryParse(d['resolved_cases'].toString())  ?? 0;
// // //             _stLoaded  = true;
// // //           });
// // //         }
// // //       }
// // //     } catch (_) {}
// // //   }
// // //
// // //   Widget _page(int i) {
// // //     switch (i) {
// // //       case 0: return _HomeTab(
// // //           onLogout: _confirmLogout,
// // //           stPolice: _stPolice, stMissing: _stMissing,
// // //           stCases: _stCases, stLoaded: _stLoaded);
// // //       case 1: return const View_Police_Station(title: 'Police Stations');
// // //       case 3: return const UploadPage();
// // //       case 4: return const _ReportsTab();
// // //       default: return _HomeTab(
// // //           onLogout: _confirmLogout,
// // //           stPolice: _stPolice, stMissing: _stMissing,
// // //           stCases: _stCases, stLoaded: _stLoaded);
// // //     }
// // //   }
// // //
// // //   void _onTap(int i) {
// // //     HapticFeedback.lightImpact();
// // //     if (i == 2) {
// // //       Navigator.push(context, _slideRoute(const UploadPage()));
// // //       return;
// // //     }
// // //     if (i == 3) { _missingDialog(); return; }
// // //     setState(() => _idx = i);
// // //   }
// // //
// // //   void _missingDialog() {
// // //     showGeneralDialog(
// // //       context: context,
// // //       barrierDismissible: true, barrierLabel: '',
// // //       barrierColor: Colors.black.withOpacity(0.65),
// // //       transitionDuration: const Duration(milliseconds: 380),
// // //       transitionBuilder: (_, a, __, child) => ScaleTransition(
// // //         scale: CurvedAnimation(parent: a, curve: Curves.easeOutBack),
// // //         child: FadeTransition(opacity: a, child: child),
// // //       ),
// // //       pageBuilder: (ctx, _, __) => _MissingDialog(
// // //         onMissing: () {
// // //           Navigator.pop(ctx);
// // //           Navigator.push(context, _slideRoute(const ViewStylistsPage(shopId: '')));
// // //         },
// // //         onCriminal: () {
// // //           Navigator.pop(ctx);
// // //           Navigator.push(context, _slideRoute(const ViewCriminalsPage(shopId: '')));
// // //         },
// // //       ),
// // //     );
// // //   }
// // //
// // //   void _confirmLogout() {
// // //     showDialog(
// // //       context: context,
// // //       builder: (_) => AlertDialog(
// // //         backgroundColor: const Color(0xFF0A1428),
// // //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
// // //         icon: const Icon(Icons.logout_rounded, color: _T.accentRed, size: 30),
// // //         title: const Text('Sign Out',
// // //             style: TextStyle(color: _T.textPrimary, fontWeight: FontWeight.w800)),
// // //         content: const Text('Are you sure you want to sign out?',
// // //             style: TextStyle(color: _T.textSub, fontSize: 13)),
// // //         actions: [
// // //           TextButton(onPressed: () => Navigator.pop(context),
// // //               child: const Text('Cancel',
// // //                   style: TextStyle(color: _T.textSub))),
// // //           TextButton(
// // //             onPressed: () async {
// // //               Navigator.pop(context);
// // //               final sh = await SharedPreferences.getInstance();
// // //               await sh.remove('lid');
// // //               if (mounted) Navigator.pushReplacement(context,
// // //                   MaterialPageRoute(builder: (_) => const LoginPage(title: 'Login')));
// // //             },
// // //             child: const Text('Sign Out',
// // //                 style: TextStyle(color: _T.accentRed, fontWeight: FontWeight.w800)),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     final bottom = MediaQuery.of(context).padding.bottom;
// // //     return AnnotatedRegion<SystemUiOverlayStyle>(
// // //       value: SystemUiOverlayStyle.light,
// // //       child: Scaffold(
// // //         backgroundColor: _T.bg,
// // //         extendBody: true,
// // //         body: Stack(children: [
// // //           const _AnimatedBg(),
// // //           SafeArea(
// // //             bottom: false,
// // //             child: AnimatedSwitcher(
// // //               duration: const Duration(milliseconds: 340),
// // //               transitionBuilder: (child, anim) => FadeTransition(
// // //                 opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut),
// // //                 child: SlideTransition(
// // //                   position: Tween<Offset>(
// // //                       begin: const Offset(0, 0.03), end: Offset.zero)
// // //                       .animate(anim),
// // //                   child: child,
// // //                 ),
// // //               ),
// // //               child: KeyedSubtree(key: ValueKey(_idx), child: _page(_idx)),
// // //             ),
// // //           ),
// // //         ]),
// // //         bottomNavigationBar: _FloatingNavBar(
// // //           selectedIndex: _idx,
// // //           fabPulse:      _fabPulse,
// // //           onTap:         _onTap,
// // //           bottomPad:     bottom,
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }
// // //
// // // // ═══════════════════════════════════════════════════════════════════════════════
// // // //  FLOATING NAV BAR  — pill with oversized centre Upload FAB
// // // // ═══════════════════════════════════════════════════════════════════════════════
// // // class _FloatingNavBar extends StatefulWidget {
// // //   final int selectedIndex;
// // //   final AnimationController fabPulse;
// // //   final ValueChanged<int> onTap;
// // //   final double bottomPad;
// // //   const _FloatingNavBar({
// // //     required this.selectedIndex, required this.fabPulse,
// // //     required this.onTap, required this.bottomPad,
// // //   });
// // //   @override State<_FloatingNavBar> createState() => _FloatingNavBarState();
// // // }
// // //
// // // class _FloatingNavBarState extends State<_FloatingNavBar>
// // //     with SingleTickerProviderStateMixin {
// // //   late final AnimationController _pillAnim;
// // //   int _prev = 0;
// // //
// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _pillAnim = AnimationController(
// // //         vsync: this, duration: const Duration(milliseconds: 340), value: 1);
// // //   }
// // //
// // //   @override
// // //   void didUpdateWidget(_FloatingNavBar old) {
// // //     super.didUpdateWidget(old);
// // //     if (old.selectedIndex != widget.selectedIndex) {
// // //       _prev = old.selectedIndex;
// // //       _pillAnim.forward(from: 0);
// // //     }
// // //   }
// // //
// // //   @override void dispose() { _pillAnim.dispose(); super.dispose(); }
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Container(
// // //       color: Colors.transparent,
// // //       padding: EdgeInsets.fromLTRB(18, 8, 18, widget.bottomPad + 14),
// // //       child: ClipRRect(
// // //         borderRadius: BorderRadius.circular(40),
// // //         child: BackdropFilter(
// // //           filter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
// // //           child: Container(
// // //             height: 72,
// // //             decoration: BoxDecoration(
// // //               color: _T.navBg.withOpacity(0.93),
// // //               borderRadius: BorderRadius.circular(40),
// // //               border: Border.all(color: _T.glassBorder),
// // //               boxShadow: [
// // //                 BoxShadow(color: _T.accentBlue.withOpacity(0.12),
// // //                     blurRadius: 28, offset: const Offset(0, 8)),
// // //                 BoxShadow(color: Colors.black.withOpacity(0.40),
// // //                     blurRadius: 32, offset: const Offset(0, 12)),
// // //               ],
// // //             ),
// // //             child: Row(
// // //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// // //               children: List.generate(_navItems.length, (i) {
// // //                 if (i == 2) {
// // //                   // ✅ Centre Upload FAB — significantly larger than other icons
// // //                   return _UploadFab(
// // //                       pulse: widget.fabPulse, onTap: () => widget.onTap(2));
// // //                 }
// // //                 return _NavPill(
// // //                   item:     _navItems[i],
// // //                   selected: widget.selectedIndex == i,
// // //                   onTap:    () => widget.onTap(i),
// // //                   anim:     _pillAnim,
// // //                 );
// // //               }),
// // //             ),
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }
// // //
// // // // ── Centre Upload FAB ─────────────────────────────────────────────────────────
// // // class _UploadFab extends StatefulWidget {
// // //   final AnimationController pulse;
// // //   final VoidCallback onTap;
// // //   const _UploadFab({required this.pulse, required this.onTap});
// // //   @override State<_UploadFab> createState() => _UploadFabState();
// // // }
// // //
// // // class _UploadFabState extends State<_UploadFab>
// // //     with SingleTickerProviderStateMixin {
// // //   bool _pressed = false;
// // //   late final AnimationController _spin;
// // //
// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _spin = AnimationController(
// // //         vsync: this, duration: const Duration(seconds: 6))..repeat();
// // //   }
// // //
// // //   @override void dispose() { _spin.dispose(); super.dispose(); }
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return GestureDetector(
// // //       onTap: () { HapticFeedback.mediumImpact(); widget.onTap(); },
// // //       onTapDown: (_) => setState(() => _pressed = true),
// // //       onTapUp:   (_) => setState(() => _pressed = false),
// // //       onTapCancel:() => setState(() => _pressed = false),
// // //       child: AnimatedBuilder(
// // //         animation: Listenable.merge([widget.pulse, _spin]),
// // //         builder: (_, __) {
// // //           final g = widget.pulse.value;
// // //           final angle = _spin.value * 2 * math.pi;
// // //           return AnimatedScale(
// // //             scale: _pressed ? 0.88 : 1.0,
// // //             duration: const Duration(milliseconds: 120),
// // //             child: SizedBox(
// // //               width: 72, height: 72,
// // //               child: Stack(alignment: Alignment.center, children: [
// // //                 // Pulsing outer glow
// // //                 Container(
// // //                   width: 72, height: 72,
// // //                   decoration: BoxDecoration(
// // //                     shape: BoxShape.circle,
// // //                     boxShadow: [
// // //                       BoxShadow(
// // //                           color: _T.accentCyan.withOpacity(0.18 + g * 0.18),
// // //                           blurRadius: 18 + g * 18, spreadRadius: g * 5),
// // //                       BoxShadow(
// // //                           color: _T.accentBlue.withOpacity(0.28 + g * 0.20),
// // //                           blurRadius: 10 + g * 10),
// // //                     ],
// // //                   ),
// // //                 ),
// // //                 // Spinning arc
// // //                 CustomPaint(
// // //                     size: const Size(72, 72),
// // //                     painter: _ArcRingPainter(angle, _T.accentCyan)),
// // //                 // Gradient core
// // //                 Container(
// // //                   width: 58, height: 58,
// // //                   decoration: BoxDecoration(
// // //                     shape: BoxShape.circle,
// // //                     gradient: SweepGradient(
// // //                       colors: const [
// // //                         _T.accentCyan, _T.accentBlue,
// // //                         _T.accentPurple, _T.accentCyan,
// // //                       ],
// // //                       transform: GradientRotation(angle),
// // //                     ),
// // //                     boxShadow: [
// // //                       BoxShadow(
// // //                           color: _T.accentBlue.withOpacity(0.50 + g * 0.22),
// // //                           blurRadius: 18, spreadRadius: 1),
// // //                     ],
// // //                   ),
// // //                   child: const Icon(Icons.add_photo_alternate_rounded,
// // //                       color: Colors.white, size: 26),
// // //                 ),
// // //               ]),
// // //             ),
// // //           );
// // //         },
// // //       ),
// // //     );
// // //   }
// // // }
// // //
// // // // ── Regular expanding pill nav item ──────────────────────────────────────────
// // // class _NavPill extends StatefulWidget {
// // //   final _NavItem item;
// // //   final bool     selected;
// // //   final VoidCallback onTap;
// // //   final AnimationController anim;
// // //   const _NavPill({
// // //     required this.item, required this.selected,
// // //     required this.onTap, required this.anim,
// // //   });
// // //   @override State<_NavPill> createState() => _NavPillState();
// // // }
// // //
// // // class _NavPillState extends State<_NavPill>
// // //     with SingleTickerProviderStateMixin {
// // //   late final AnimationController _c;
// // //   late final Animation<double>   _v;
// // //
// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _c = AnimationController(vsync: this,
// // //         duration: const Duration(milliseconds: 320));
// // //     _v = CurvedAnimation(parent: _c, curve: Curves.easeOutCubic);
// // //     if (widget.selected) _c.value = 1;
// // //   }
// // //
// // //   @override
// // //   void didUpdateWidget(_NavPill o) {
// // //     super.didUpdateWidget(o);
// // //     widget.selected ? _c.forward() : _c.reverse();
// // //   }
// // //
// // //   @override void dispose() { _c.dispose(); super.dispose(); }
// // //
// // //   @override
// // //   Widget build(BuildContext context) => GestureDetector(
// // //     onTap: () { HapticFeedback.selectionClick(); widget.onTap(); },
// // //     behavior: HitTestBehavior.opaque,
// // //     child: AnimatedBuilder(
// // //       animation: _v,
// // //       builder: (_, __) {
// // //         final v = _v.value;
// // //         return Container(
// // //           height: 46,
// // //           padding: EdgeInsets.symmetric(horizontal: 10 + 4 * v),
// // //           decoration: BoxDecoration(
// // //             color: v > 0.05
// // //                 ? _T.accentBlue.withOpacity(0.15 * v)
// // //                 : Colors.transparent,
// // //             borderRadius: BorderRadius.circular(23),
// // //             border: v > 0.5
// // //                 ? Border.all(color: _T.accentBlue.withOpacity(0.28 * v))
// // //                 : null,
// // //           ),
// // //           child: Row(mainAxisSize: MainAxisSize.min, children: [
// // //             Icon(
// // //               widget.selected ? widget.item.activeIcon : widget.item.icon,
// // //               color: Color.lerp(_T.textSub, _T.accentCyan, v),
// // //               size: 22,
// // //             ),
// // //             if (v > 0.3) ...[
// // //               SizedBox(width: 5 * v),
// // //               Opacity(
// // //                 opacity: ((v - 0.3) / 0.7).clamp(0, 1),
// // //                 child: Text(widget.item.label,
// // //                     style: const TextStyle(color: _T.accentCyan,
// // //                         fontSize: 12, fontWeight: FontWeight.w700)),
// // //               ),
// // //             ],
// // //           ]),
// // //         );
// // //       },
// // //     ),
// // //   );
// // // }
// // //
// // // // ═══════════════════════════════════════════════════════════════════════════════
// // // //  HOME TAB  — the premium dashboard
// // // // ═══════════════════════════════════════════════════════════════════════════════
// // // class _HomeTab extends StatefulWidget {
// // //   final VoidCallback? onLogout;
// // //   final int stPolice, stMissing, stCases;
// // //   final bool stLoaded;
// // //   const _HomeTab({
// // //     this.onLogout,
// // //     this.stPolice = 0, this.stMissing = 0,
// // //     this.stCases  = 0, this.stLoaded  = false,
// // //   });
// // //   @override State<_HomeTab> createState() => _HomeTabState();
// // // }
// // //
// // // class _HomeTabState extends State<_HomeTab> with TickerProviderStateMixin {
// // //   late final AnimationController _enter;
// // //
// // //   Animation<double> _af(double a, double b) =>
// // //       Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
// // //           parent: _enter, curve: Interval(a, b, curve: Curves.easeOutCubic)));
// // //
// // //   Animation<Offset> _as(double a, double b) =>
// // //       Tween<Offset>(begin: const Offset(0, 0.07), end: Offset.zero)
// // //           .animate(CurvedAnimation(
// // //           parent: _enter, curve: Interval(a, b, curve: Curves.easeOutCubic)));
// // //
// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _enter = AnimationController(
// // //         vsync: this, duration: const Duration(milliseconds: 1100))
// // //       ..forward();
// // //   }
// // //
// // //   @override void dispose() { _enter.dispose(); super.dispose(); }
// // //
// // //   void _push(Widget page) =>
// // //       Navigator.push(context, _slideRoute(page));
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return CustomScrollView(
// // //       physics: const BouncingScrollPhysics(),
// // //       slivers: [
// // //
// // //         // ── Top bar + logout top-right ────────────────────────────────────
// // //         SliverToBoxAdapter(child: FadeTransition(opacity: _af(0, 0.35),
// // //             child: _TopBar(onLogout: widget.onLogout))),
// // //
// // //         // ── Ticker banner ─────────────────────────────────────────────────
// // //         SliverToBoxAdapter(child: FadeTransition(opacity: _af(0.05, 0.42),
// // //             child: const Padding(
// // //                 padding: EdgeInsets.fromLTRB(20, 12, 20, 0),
// // //                 child: _TickerBanner()))),
// // //
// // //         // ── Hero card ─────────────────────────────────────────────────────
// // //         SliverToBoxAdapter(child: FadeTransition(opacity: _af(0.12, 0.52),
// // //             child: SlideTransition(position: _as(0.12, 0.52),
// // //                 child: const _HeroCard()))),
// // //
// // //         const SliverToBoxAdapter(child: SizedBox(height: 24)),
// // //
// // //         // ── Live stats ────────────────────────────────────────────────────
// // //         SliverToBoxAdapter(child: FadeTransition(opacity: _af(0.24, 0.60),
// // //             child: _LiveStatStrip(
// // //               police:  widget.stPolice,
// // //               missing: widget.stMissing,
// // //               cases:   widget.stCases,
// // //               loaded:  widget.stLoaded,
// // //             ))),
// // //
// // //         const SliverToBoxAdapter(child: SizedBox(height: 28)),
// // //
// // //         // ── Quick actions ─────────────────────────────────────────────────
// // //         SliverToBoxAdapter(child: FadeTransition(opacity: _af(0.36, 0.70),
// // //             child: SlideTransition(position: _as(0.36, 0.70),
// // //                 child: _QuickActions(onPush: _push)))),
// // //
// // //         const SliverToBoxAdapter(child: SizedBox(height: 28)),
// // //
// // //         // ── How it works ──────────────────────────────────────────────────
// // //         SliverToBoxAdapter(child: FadeTransition(opacity: _af(0.52, 0.82),
// // //             child: const _HowItWorks())),
// // //
// // //         const SliverToBoxAdapter(child: SizedBox(height: 28)),
// // //
// // //         // ── Currently missing — auto-rotating carousel ────────────────────
// // //         SliverToBoxAdapter(child: FadeTransition(opacity: _af(0.66, 1.0),
// // //             child: const _MissingCarousel())),
// // //
// // //         const SliverToBoxAdapter(child: SizedBox(height: 120)),
// // //       ],
// // //     );
// // //   }
// // // }
// // //
// // // // ─────────────────────────────────────────────────────────────────────────────
// // // //  TOP BAR  — logout lives here now (✅ removed from nav bar)
// // // // ─────────────────────────────────────────────────────────────────────────────
// // // class _TopBar extends StatelessWidget {
// // //   final VoidCallback? onLogout;
// // //   const _TopBar({this.onLogout});
// // //
// // //   @override
// // //   Widget build(BuildContext context) => Padding(
// // //     padding: const EdgeInsets.fromLTRB(20, 18, 16, 0),
// // //     child: Row(children: [
// // //       Container(
// // //         width: 40, height: 40,
// // //         decoration: BoxDecoration(
// // //           gradient: const LinearGradient(
// // //               colors: [_T.accentBlue, _T.accentCyan],
// // //               begin: Alignment.topLeft, end: Alignment.bottomRight),
// // //           borderRadius: BorderRadius.circular(13),
// // //           boxShadow: [BoxShadow(
// // //               color: _T.accentBlue.withOpacity(0.45), blurRadius: 14)],
// // //         ),
// // //         child: const Icon(Icons.shield_outlined, color: Colors.white, size: 22),
// // //       ),
// // //       const SizedBox(width: 11),
// // //       Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
// // //         ShaderMask(
// // //           shaderCallback: (r) => const LinearGradient(
// // //               colors: [_T.textPrimary, _T.accentCyan]).createShader(r),
// // //           child: const Text('CrowdTrace',
// // //               style: TextStyle(color: Colors.white, fontSize: 20,
// // //                   fontWeight: FontWeight.w800, letterSpacing: 0.2)),
// // //         ),
// // //         const Text('Missing Person System',
// // //             style: TextStyle(color: _T.textSub, fontSize: 9.5)),
// // //       ]),
// // //       const Spacer(),
// // //       _GlassBtn(
// // //         icon: Icons.notifications_outlined,
// // //         onTap: () {
// // //           Navigator.push(
// // //             context,
// // //             _slideRoute(const ViewCasesPage()),
// // //           );
// // //         },
// // //       ),
// // //       const SizedBox(width: 8),
// // //       // ✅ Logout button — top-right of home page
// // //       _GlassBtn(
// // //         icon: Icons.logout_rounded,
// // //         iconColor: _T.accentRed.withOpacity(0.85),
// // //         onTap: onLogout ?? () {},
// // //       ),
// // //       const SizedBox(width: 4),
// // //     ]),
// // //   );
// // // }
// // //
// // // class _GlassBtn extends StatelessWidget {
// // //   final IconData icon;
// // //   final Color    iconColor;
// // //   final VoidCallback onTap;
// // //   const _GlassBtn({required this.icon, required this.onTap,
// // //     this.iconColor = _T.textMid});
// // //
// // //   @override
// // //   Widget build(BuildContext context) => GestureDetector(
// // //     onTap: onTap,
// // //     child: ClipRRect(
// // //       borderRadius: BorderRadius.circular(13),
// // //       child: BackdropFilter(
// // //         filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
// // //         child: Container(
// // //           width: 40, height: 40,
// // //           decoration: BoxDecoration(
// // //             color: _T.glass,
// // //             borderRadius: BorderRadius.circular(13),
// // //             border: Border.all(color: _T.glassBorder),
// // //           ),
// // //           child: Icon(icon, color: iconColor, size: 19),
// // //         ),
// // //       ),
// // //     ),
// // //   );
// // // }
// // //
// // // // ─────────────────────────────────────────────────────────────────────────────
// // // //  TICKER BANNER
// // // // ─────────────────────────────────────────────────────────────────────────────
// // // class _TickerBanner extends StatefulWidget {
// // //   const _TickerBanner();
// // //   @override State<_TickerBanner> createState() => _TickerBannerState();
// // // }
// // //
// // // class _TickerBannerState extends State<_TickerBanner>
// // //     with SingleTickerProviderStateMixin {
// // //   late final AnimationController _ctrl;
// // //   int _i = 0;
// // //
// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _ctrl = AnimationController(vsync: this,
// // //         duration: const Duration(milliseconds: 500))..value = 1;
// // //     _cycle();
// // //   }
// // //
// // //   void _cycle() async {
// // //     while (mounted) {
// // //       await Future.delayed(const Duration(seconds: 4));
// // //       if (!mounted) return;
// // //       await _ctrl.reverse();
// // //       if (!mounted) return;
// // //       setState(() => _i = (_i + 1) % _tickers.length);
// // //       _ctrl.forward();
// // //     }
// // //   }
// // //
// // //   @override void dispose() { _ctrl.dispose(); super.dispose(); }
// // //
// // //   @override
// // //   Widget build(BuildContext context) => Container(
// // //     height: 40,
// // //     decoration: BoxDecoration(
// // //       gradient: LinearGradient(colors: [
// // //         _T.accentBlue.withOpacity(0.12),
// // //         _T.accentPurple.withOpacity(0.10),
// // //       ]),
// // //       borderRadius: BorderRadius.circular(12),
// // //       border: Border.all(color: _T.accentBlue.withOpacity(0.20)),
// // //     ),
// // //     child: Row(children: [
// // //       Container(
// // //         width: 40, height: 40,
// // //         decoration: BoxDecoration(
// // //           gradient: const LinearGradient(colors: [_T.accentBlue, _T.accentPurple]),
// // //           borderRadius: BorderRadius.circular(11),
// // //         ),
// // //         child: const Icon(Icons.campaign_rounded, color: Colors.white, size: 18),
// // //       ),
// // //       const SizedBox(width: 10),
// // //       Expanded(
// // //         child: AnimatedBuilder(
// // //           animation: _ctrl,
// // //           builder: (_, __) => FadeTransition(
// // //             opacity: _ctrl,
// // //             child: SlideTransition(
// // //               position: Tween<Offset>(
// // //                   begin: const Offset(0.05, 0), end: Offset.zero)
// // //                   .animate(_ctrl),
// // //               child: Text(_tickers[_i],
// // //                   style: const TextStyle(color: _T.textPrimary,
// // //                       fontSize: 11.5, fontWeight: FontWeight.w500),
// // //                   overflow: TextOverflow.ellipsis),
// // //             ),
// // //           ),
// // //         ),
// // //       ),
// // //       const SizedBox(width: 10),
// // //     ]),
// // //   );
// // // }
// // //
// // // // ─────────────────────────────────────────────────────────────────────────────
// // // //  HERO CARD
// // // // ─────────────────────────────────────────────────────────────────────────────
// // // class _HeroCard extends StatefulWidget {
// // //   const _HeroCard();
// // //   @override State<_HeroCard> createState() => _HeroCardState();
// // // }
// // //
// // // class _HeroCardState extends State<_HeroCard>
// // //     with SingleTickerProviderStateMixin {
// // //   late final AnimationController _orb;
// // //
// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _orb = AnimationController(vsync: this,
// // //         duration: const Duration(seconds: 7))..repeat();
// // //   }
// // //
// // //   @override void dispose() { _orb.dispose(); super.dispose(); }
// // //
// // //   @override
// // //   Widget build(BuildContext context) => Container(
// // //     margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
// // //     height: 192,
// // //     clipBehavior: Clip.hardEdge,
// // //     decoration: BoxDecoration(
// // //       borderRadius: BorderRadius.circular(28),
// // //       gradient: const LinearGradient(
// // //         begin: Alignment.topLeft, end: Alignment.bottomRight,
// // //         colors: [Color(0xFF0D2462), Color(0xFF0A1540)],
// // //       ),
// // //       border: Border.all(color: _T.accentBlue.withOpacity(0.22)),
// // //       boxShadow: [BoxShadow(color: _T.accentBlue.withOpacity(0.16),
// // //           blurRadius: 36, spreadRadius: -6, offset: const Offset(0, 14))],
// // //     ),
// // //     child: Stack(children: [
// // //       CustomPaint(painter: _GridPainter(), size: Size.infinite),
// // //       AnimatedBuilder(animation: _orb, builder: (_, __) =>
// // //           CustomPaint(painter: _HeroBgOrb(_orb.value), size: Size.infinite)),
// // //       Padding(
// // //         padding: const EdgeInsets.fromLTRB(22, 20, 16, 20),
// // //         child: Row(children: [
// // //           Expanded(child: Column(
// // //             crossAxisAlignment: CrossAxisAlignment.start,
// // //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // //             children: [
// // //               Container(
// // //                 padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
// // //                 decoration: BoxDecoration(
// // //                   color: _T.accentGreen.withOpacity(0.12),
// // //                   borderRadius: BorderRadius.circular(20),
// // //                   border: Border.all(color: _T.accentGreen.withOpacity(0.38)),
// // //                 ),
// // //                 child: Row(mainAxisSize: MainAxisSize.min, children: const [
// // //                   Icon(Icons.circle, color: _T.accentGreen, size: 7),
// // //                   SizedBox(width: 5),
// // //                   Text('System Active', style: TextStyle(color: _T.accentGreen,
// // //                       fontSize: 10.5, fontWeight: FontWeight.w700)),
// // //                 ]),
// // //               ),
// // //               Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
// // //                 ShaderMask(
// // //                   shaderCallback: (r) => const LinearGradient(
// // //                       colors: [_T.textPrimary, _T.accentCyan]).createShader(r),
// // //                   child: const Text('Find the Missing.\nProtect the Community.',
// // //                       style: TextStyle(color: Colors.white, fontSize: 19,
// // //                           fontWeight: FontWeight.w800, height: 1.30)),
// // //                 ),
// // //                 const SizedBox(height: 9),
// // //                 const Text('CrowdTrace uses crowd intelligence\nto locate missing persons faster.',
// // //                     style: TextStyle(color: _T.textSub,
// // //                         fontSize: 11.5, height: 1.55)),
// // //               ]),
// // //             ],
// // //           )),
// // //           const SizedBox(width: 8),
// // //           SizedBox(
// // //             width: 90, height: 148,
// // //             child: AnimatedBuilder(animation: _orb,
// // //                 builder: (_, __) => CustomPaint(painter: _RadarOrb(_orb.value))),
// // //           ),
// // //         ]),
// // //       ),
// // //     ]),
// // //   );
// // // }
// // //
// // // // ─────────────────────────────────────────────────────────────────────────────
// // // //  LIVE STAT STRIP
// // // // ─────────────────────────────────────────────────────────────────────────────
// // // class _LiveStatStrip extends StatelessWidget {
// // //   final int police, missing, cases;
// // //   final bool loaded;
// // //   const _LiveStatStrip({required this.police, required this.missing,
// // //     required this.cases, required this.loaded});
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     final items = [
// // //       (loaded ? police.toString()  : '—', 'Police Stations',
// // //       _T.accentCyan,  Icons.local_police_rounded),
// // //       (loaded ? missing.toString() : '—', 'Missing Persons',
// // //       _T.accentGold,  Icons.person_search_rounded),
// // //       (loaded ? cases.toString()   : '—', 'Cases Resolved',
// // //       _T.accentGreen, Icons.check_circle_outline_rounded),
// // //     ];
// // //     return SizedBox(
// // //       height: 90,
// // //       child: ListView.separated(
// // //         scrollDirection: Axis.horizontal,
// // //         padding: const EdgeInsets.symmetric(horizontal: 20),
// // //         itemCount: items.length,
// // //         separatorBuilder: (_, __) => const SizedBox(width: 12),
// // //         itemBuilder: (_, i) {
// // //           final it = items[i];
// // //           return ClipRRect(
// // //             borderRadius: BorderRadius.circular(20),
// // //             child: BackdropFilter(
// // //               filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
// // //               child: Container(
// // //                 width: 144,
// // //                 padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
// // //                 decoration: BoxDecoration(
// // //                   borderRadius: BorderRadius.circular(20),
// // //                   gradient: LinearGradient(colors: [
// // //                     it.$3.withOpacity(0.12), Colors.white.withOpacity(0.02),
// // //                   ], begin: Alignment.topLeft, end: Alignment.bottomRight),
// // //                   border: Border.all(color: it.$3.withOpacity(0.22)),
// // //                 ),
// // //                 child: Row(children: [
// // //                   Icon(it.$4, color: it.$3, size: 22),
// // //                   const SizedBox(width: 10),
// // //                   Expanded(child: Column(
// // //                     crossAxisAlignment: CrossAxisAlignment.start,
// // //                     mainAxisAlignment: MainAxisAlignment.center,
// // //                     children: [
// // //                       loaded
// // //                           ? Text(it.$1, style: TextStyle(color: it.$3,
// // //                           fontSize: 22, fontWeight: FontWeight.w800))
// // //                           : SizedBox(width: 36, height: 14,
// // //                           child: LinearProgressIndicator(
// // //                               color: it.$3.withOpacity(0.5),
// // //                               backgroundColor: it.$3.withOpacity(0.10))),
// // //                       const SizedBox(height: 2),
// // //                       Text(it.$2, style: const TextStyle(
// // //                           color: _T.textSub, fontSize: 10.5, height: 1.3)),
// // //                     ],
// // //                   )),
// // //                 ]),
// // //               ),
// // //             ),
// // //           );
// // //         },
// // //       ),
// // //     );
// // //   }
// // // }
// // //
// // // // ─────────────────────────────────────────────────────────────────────────────
// // // //  QUICK ACTIONS GRID
// // // // ─────────────────────────────────────────────────────────────────────────────
// // // class _QuickActions extends StatelessWidget {
// // //   final void Function(Widget) onPush;
// // //   const _QuickActions({required this.onPush});
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     final cards = [
// // //       _QD('Police Stations', Icons.local_police_rounded,
// // //           _T.accentBlue,   'Find nearby',
// // //               () => onPush(const View_Police_Station(title: 'Police Stations'))),
// // //       _QD('Missing Persons', Icons.person_search_rounded,
// // //           _T.accentPurple, 'View records',
// // //               () => onPush(const ViewStylistsPage(shopId: ''))),
// // //       _QD('Criminals', Icons.gavel_rounded,
// // //           const Color(0xFFB22234), 'Wanted list',
// // //               () => onPush(const ViewCriminalsPage(shopId: ''))),
// // //       _QD('Complaint', Icons.assignment_rounded,
// // //           _T.accentCyan,   'Send / view',
// // //               () => onPush(const ComplaintPage(title: 'My Complaints'))),
// // //       _QD('Feedback', Icons.rate_review_rounded,
// // //           const Color(0xFF00BFA5), 'Share thoughts',
// // //               () => onPush(const FeedbackPage(title: 'My Feedbacks'))),
// // //       _QD('View Upload', Icons.add_photo_alternate_rounded,
// // //           _T.accentPurple, 'View detections',
// // //               () => onPush(const ViewUploads())),
// // //     ];
// // //
// // //     return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
// // //       const Padding(padding: EdgeInsets.symmetric(horizontal: 20),
// // //           child: _SecTitle('Quick Actions', 'Tap to navigate')),
// // //       const SizedBox(height: 14),
// // //       Padding(
// // //         padding: const EdgeInsets.symmetric(horizontal: 20),
// // //         child: GridView.builder(
// // //           shrinkWrap: true,
// // //           physics: const NeverScrollableScrollPhysics(),
// // //           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
// // //             crossAxisCount: 2,
// // //             childAspectRatio: 1.55,
// // //             crossAxisSpacing: 12,
// // //             mainAxisSpacing: 12,
// // //           ),
// // //           itemCount: cards.length,
// // //           itemBuilder: (_, i) => _QCard(d: cards[i]),
// // //         ),
// // //       ),
// // //     ]);
// // //   }
// // // }
// // //
// // // class _QD {
// // //   final String label, sub;
// // //   final IconData icon;
// // //   final Color    color;
// // //   final VoidCallback onTap;
// // //   const _QD(this.label, this.icon, this.color, this.sub, this.onTap);
// // // }
// // //
// // // class _QCard extends StatefulWidget {
// // //   final _QD d;
// // //   const _QCard({required this.d});
// // //   @override State<_QCard> createState() => _QCardState();
// // // }
// // //
// // // class _QCardState extends State<_QCard> {
// // //   bool _p = false;
// // //   @override
// // //   Widget build(BuildContext context) => GestureDetector(
// // //     onTap: widget.d.onTap,
// // //     onTapDown: (_) => setState(() => _p = true),
// // //     onTapUp:   (_) => setState(() => _p = false),
// // //     onTapCancel:() => setState(() => _p = false),
// // //     child: AnimatedScale(
// // //       scale: _p ? 0.94 : 1.0,
// // //       duration: const Duration(milliseconds: 110),
// // //       child: ClipRRect(
// // //         borderRadius: BorderRadius.circular(18),
// // //         child: BackdropFilter(
// // //           filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
// // //           child: Container(
// // //             decoration: BoxDecoration(
// // //               borderRadius: BorderRadius.circular(18),
// // //               gradient: LinearGradient(
// // //                 begin: Alignment.topLeft, end: Alignment.bottomRight,
// // //                 colors: [
// // //                   widget.d.color.withOpacity(0.15),
// // //                   Colors.white.withOpacity(0.03),
// // //                 ],
// // //               ),
// // //               border: Border.all(color: widget.d.color.withOpacity(0.26)),
// // //               boxShadow: [BoxShadow(color: widget.d.color.withOpacity(0.08),
// // //                   blurRadius: 14, offset: const Offset(0, 5))],
// // //             ),
// // //             padding: const EdgeInsets.all(14),
// // //             child: Column(
// // //               crossAxisAlignment: CrossAxisAlignment.start,
// // //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // //               children: [
// // //                 Container(
// // //                   width: 36, height: 36,
// // //                   decoration: BoxDecoration(
// // //                     shape: BoxShape.circle,
// // //                     gradient: LinearGradient(colors: [
// // //                       widget.d.color, widget.d.color.withOpacity(0.55),
// // //                     ]),
// // //                   ),
// // //                   child: Icon(widget.d.icon, color: Colors.white, size: 18),
// // //                 ),
// // //                 Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
// // //                   Text(widget.d.label,
// // //                       style: const TextStyle(color: _T.textPrimary,
// // //                           fontSize: 13, fontWeight: FontWeight.w700)),
// // //                   Text(widget.d.sub,
// // //                       style: const TextStyle(color: _T.textSub, fontSize: 10)),
// // //                 ]),
// // //               ],
// // //             ),
// // //           ),
// // //         ),
// // //       ),
// // //     ),
// // //   );
// // // }
// // //
// // // // ─────────────────────────────────────────────────────────────────────────────
// // // //  HOW IT WORKS
// // // // ─────────────────────────────────────────────────────────────────────────────
// // // class _HowItWorks extends StatelessWidget {
// // //   const _HowItWorks();
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     final steps = [
// // //       ('01','Spot & Snap',   'See someone? Capture a clear photo.',
// // //       Icons.camera_alt_rounded,              _T.accentCyan),
// // //       ('02','Upload & Tag',  'Upload via + with location details.',
// // //       Icons.upload_rounded,                  _T.accentBlue),
// // //       ('03','Alert Sent',    'Police & citizens get instant alerts.',
// // //       Icons.notifications_active_rounded,    _T.accentPurple),
// // //       ('04','Reunited',      'Leads converge — families reunited.',
// // //       Icons.favorite_rounded,                _T.accentGold),
// // //     ];
// // //     return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
// // //       const Padding(padding: EdgeInsets.symmetric(horizontal: 20),
// // //           child: _SecTitle('How It Works', 'Simple steps, real impact')),
// // //       const SizedBox(height: 14),
// // //       SizedBox(
// // //         height: 155,
// // //         child: ListView.separated(
// // //           scrollDirection: Axis.horizontal,
// // //           padding: const EdgeInsets.symmetric(horizontal: 20),
// // //           itemCount: steps.length,
// // //           separatorBuilder: (_, __) => const SizedBox(width: 12),
// // //           itemBuilder: (_, i) {
// // //             final s = steps[i];
// // //             return ClipRRect(
// // //               borderRadius: BorderRadius.circular(20),
// // //               child: BackdropFilter(
// // //                 filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
// // //                 child: Container(
// // //                   width: 148,
// // //                   padding: const EdgeInsets.all(14),
// // //                   decoration: BoxDecoration(
// // //                     borderRadius: BorderRadius.circular(20),
// // //                     gradient: LinearGradient(colors: [
// // //                       s.$5.withOpacity(0.11), Colors.white.withOpacity(0.02),
// // //                     ], begin: Alignment.topLeft, end: Alignment.bottomRight),
// // //                     border: Border.all(color: s.$5.withOpacity(0.20)),
// // //                   ),
// // //                   child: Column(
// // //                     crossAxisAlignment: CrossAxisAlignment.start,
// // //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // //                     children: [
// // //                       Row(children: [
// // //                         Container(width: 32, height: 32,
// // //                             decoration: BoxDecoration(shape: BoxShape.circle,
// // //                                 color: s.$5.withOpacity(0.14)),
// // //                             child: Icon(s.$4, color: s.$5, size: 15)),
// // //                         const Spacer(),
// // //                         Text(s.$1, style: TextStyle(
// // //                             color: s.$5.withOpacity(0.28), fontSize: 22,
// // //                             fontWeight: FontWeight.w900)),
// // //                       ]),
// // //                       Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
// // //                         Text(s.$2, style: const TextStyle(color: _T.textPrimary,
// // //                             fontSize: 12.5, fontWeight: FontWeight.w700)),
// // //                         const SizedBox(height: 4),
// // //                         Text(s.$3, style: const TextStyle(color: _T.textSub,
// // //                             fontSize: 10.5, height: 1.45)),
// // //                       ]),
// // //                     ],
// // //                   ),
// // //                 ),
// // //               ),
// // //             );
// // //           },
// // //         ),
// // //       ),
// // //     ]);
// // //   }
// // // }
// // //
// // // // ─────────────────────────────────────────────────────────────────────────────
// // // //  MISSING PERSONS CAROUSEL  — Django backend + auto-rotate
// // // // ─────────────────────────────────────────────────────────────────────────────
// // // class _MissingCarousel extends StatefulWidget {
// // //   const _MissingCarousel();
// // //   @override State<_MissingCarousel> createState() => _MissingCarouselState();
// // // }
// // //
// // // class _MissingCarouselState extends State<_MissingCarousel>
// // //     with SingleTickerProviderStateMixin {
// // //   late final PageController         _pc;
// // //   late final AnimationController    _auto;
// // //   int  _cur     = 0;
// // //   List<Map<String, String>> _data   = [];
// // //   bool _loading = true;
// // //
// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _pc   = PageController(viewportFraction: 0.56);
// // //     _auto = AnimationController(vsync: this,
// // //         duration: const Duration(seconds: 3))
// // //       ..addStatusListener((s) {
// // //         if (s == AnimationStatus.completed && _data.isNotEmpty) {
// // //           _cur = (_cur + 1) % _data.length;
// // //           _pc.animateToPage(_cur,
// // //               duration: const Duration(milliseconds: 680),
// // //               curve: Curves.easeInOutCubic);
// // //           _auto.forward(from: 0);
// // //         }
// // //       })
// // //       ..forward();
// // //     _fetch();
// // //   }
// // //
// // //   Future<void> _fetch() async {
// // //     try {
// // //       final sh   = await SharedPreferences.getInstance();
// // //       final base = sh.getString('url') ?? '';
// // //       final lid  = sh.getString('lid') ?? '';
// // //       final res  = await http.post(
// // //         Uri.parse('$base/user_view_missing_persons/'),
// // //         body: {'lid': lid},
// // //       ).timeout(const Duration(seconds: 10));
// // //
// // //       if (res.statusCode == 200) {
// // //         final d = jsonDecode(res.body);
// // //         if (d['status'] == 'ok' && mounted) {
// // //           final arr = d['data'] as List;
// // //           setState(() {
// // //             _data = arr.take(12).map((p) => {
// // //               'name':     (p['name'] ?? p['full_name'] ?? 'Unknown').toString(),
// // //               'age':      (p['age']  ?? '—').toString(),
// // //               'lastSeen': (p['last_seen'] ?? p['place'] ?? '').toString(),
// // //               'imageUrl': (p['image']     ?? p['photo'] ?? '').toString(),
// // //             }).toList();
// // //             _loading = false;
// // //           });
// // //         }
// // //       }
// // //     } catch (_) {
// // //       if (mounted) setState(() => _loading = false);
// // //     }
// // //   }
// // //
// // //   @override
// // //   void dispose() { _pc.dispose(); _auto.dispose(); super.dispose(); }
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
// // //       Padding(
// // //         padding: const EdgeInsets.symmetric(horizontal: 20),
// // //         child: Row(children: [
// // //           const _SecTitle('Currently Missing', 'Help bring them home'),
// // //           const Spacer(),
// // //           if (!_loading && _data.isNotEmpty)
// // //             Container(
// // //               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
// // //               decoration: BoxDecoration(
// // //                 color: _T.accentRed.withOpacity(0.12),
// // //                 borderRadius: BorderRadius.circular(20),
// // //                 border: Border.all(color: _T.accentRed.withOpacity(0.30)),
// // //               ),
// // //               child: Row(mainAxisSize: MainAxisSize.min, children: [
// // //                 const Icon(Icons.circle, color: _T.accentRed, size: 6),
// // //                 const SizedBox(width: 4),
// // //                 Text('${_data.length} Active',
// // //                     style: const TextStyle(color: _T.accentRed,
// // //                         fontSize: 10.5, fontWeight: FontWeight.w700)),
// // //               ]),
// // //             ),
// // //         ]),
// // //       ),
// // //       const SizedBox(height: 14),
// // //
// // //       if (_loading)
// // //         const SizedBox(height: 220, child: Center(
// // //             child: CircularProgressIndicator(
// // //                 strokeWidth: 2.5, color: _T.accentCyan)))
// // //
// // //       else if (_data.isEmpty)
// // //         const SizedBox(height: 80, child: Center(
// // //             child: Text('No records found.',
// // //                 style: TextStyle(color: _T.textSub))))
// // //
// // //       else ...[
// // //           SizedBox(
// // //             height: 225,
// // //             child: PageView.builder(
// // //               controller: _pc,
// // //               onPageChanged: (i) => setState(() => _cur = i),
// // //               itemCount: _data.length,
// // //               itemBuilder: (_, i) => AnimatedScale(
// // //                 scale: i == _cur ? 1.0 : 0.86,
// // //                 duration: const Duration(milliseconds: 420),
// // //                 curve: Curves.easeOutCubic,
// // //                 child: _MCard(p: _data[i], active: i == _cur),
// // //               ),
// // //             ),
// // //           ),
// // //           const SizedBox(height: 14),
// // //           Row(
// // //             mainAxisAlignment: MainAxisAlignment.center,
// // //             children: List.generate(_data.length, (i) => AnimatedContainer(
// // //               duration: const Duration(milliseconds: 300),
// // //               margin: const EdgeInsets.symmetric(horizontal: 3),
// // //               width: i == _cur ? 22 : 6, height: 6,
// // //               decoration: BoxDecoration(
// // //                 borderRadius: BorderRadius.circular(3),
// // //                 gradient: i == _cur ? const LinearGradient(
// // //                     colors: [_T.accentCyan, _T.accentBlue]) : null,
// // //                 color: i == _cur ? null : _T.textSub.withOpacity(0.22),
// // //               ),
// // //             )),
// // //           ),
// // //         ],
// // //     ]);
// // //   }
// // // }
// // //
// // // class _MCard extends StatelessWidget {
// // //   final Map<String, String> p;
// // //   final bool active;
// // //   const _MCard({required this.p, required this.active});
// // //
// // //   @override
// // //   Widget build(BuildContext context) => Container(
// // //     margin: const EdgeInsets.symmetric(horizontal: 5),
// // //     decoration: BoxDecoration(
// // //       borderRadius: BorderRadius.circular(26),
// // //       gradient: LinearGradient(
// // //         begin: Alignment.topLeft, end: Alignment.bottomRight,
// // //         colors: [
// // //           _T.accentRed.withOpacity(active ? 0.15 : 0.05),
// // //           _T.accentPurple.withOpacity(active ? 0.08 : 0.02),
// // //         ],
// // //       ),
// // //       border: Border.all(
// // //         color: active ? _T.accentRed.withOpacity(0.40) : _T.glassBorder,
// // //         width: active ? 1.6 : 0.8,
// // //       ),
// // //       boxShadow: active
// // //           ? [BoxShadow(color: _T.accentRed.withOpacity(0.18),
// // //           blurRadius: 22, offset: const Offset(0, 8))]
// // //           : [],
// // //     ),
// // //     child: ClipRRect(
// // //       borderRadius: BorderRadius.circular(26),
// // //       child: BackdropFilter(
// // //         filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
// // //         child: Padding(
// // //           padding: const EdgeInsets.all(14),
// // //           child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
// // //             _SpinPhoto(url: p['imageUrl'] ?? '', active: active),
// // //             const SizedBox(height: 10),
// // //             if (active) Container(
// // //               padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
// // //               decoration: BoxDecoration(
// // //                 color: _T.accentRed.withOpacity(0.12),
// // //                 borderRadius: BorderRadius.circular(20),
// // //                 border: Border.all(color: _T.accentRed.withOpacity(0.34)),
// // //               ),
// // //               child: const Row(mainAxisSize: MainAxisSize.min, children: [
// // //                 Icon(Icons.circle, color: _T.accentRed, size: 5),
// // //                 SizedBox(width: 4),
// // //                 Text('MISSING', style: TextStyle(color: _T.accentRed,
// // //                     fontSize: 9, fontWeight: FontWeight.w800,
// // //                     letterSpacing: 1.3)),
// // //               ]),
// // //             ),
// // //             const SizedBox(height: 8),
// // //             Text(p['name']!, style: const TextStyle(color: _T.textPrimary,
// // //                 fontSize: 13.5, fontWeight: FontWeight.w700),
// // //                 textAlign: TextAlign.center,
// // //                 overflow: TextOverflow.ellipsis),
// // //             const SizedBox(height: 2),
// // //             Text('Age: ${p['age']}',
// // //                 style: const TextStyle(color: _T.textMid, fontSize: 11)),
// // //             const SizedBox(height: 2),
// // //             Text(p['lastSeen']!,
// // //                 style: const TextStyle(color: _T.textSub, fontSize: 10),
// // //                 textAlign: TextAlign.center,
// // //                 overflow: TextOverflow.ellipsis, maxLines: 1),
// // //           ]),
// // //         ),
// // //       ),
// // //     ),
// // //   );
// // // }
// // //
// // // class _SpinPhoto extends StatefulWidget {
// // //   final String url;
// // //   final bool   active;
// // //   const _SpinPhoto({required this.url, required this.active});
// // //   @override State<_SpinPhoto> createState() => _SpinPhotoState();
// // // }
// // //
// // // class _SpinPhotoState extends State<_SpinPhoto>
// // //     with SingleTickerProviderStateMixin {
// // //   late final AnimationController _c;
// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _c = AnimationController(vsync: this,
// // //         duration: const Duration(seconds: 2))..repeat();
// // //   }
// // //   @override void dispose() { _c.dispose(); super.dispose(); }
// // //
// // //   @override
// // //   Widget build(BuildContext context) => AnimatedBuilder(
// // //     animation: _c,
// // //     builder: (_, child) => CustomPaint(
// // //         painter: _SpinArc(_c.value, widget.active), child: child),
// // //     child: Container(
// // //       width: 82, height: 82,
// // //       margin: const EdgeInsets.all(5),
// // //       decoration: BoxDecoration(
// // //         shape: BoxShape.circle,
// // //         border: Border.all(
// // //             color: widget.active
// // //                 ? _T.accentRed.withOpacity(0.50) : _T.glassBorder,
// // //             width: 2),
// // //       ),
// // //       child: ClipOval(
// // //         child: widget.url.isEmpty
// // //             ? Container(color: _T.glass,
// // //             child: const Icon(Icons.person, color: _T.textSub, size: 36))
// // //             : Image.network(widget.url, fit: BoxFit.cover,
// // //             errorBuilder: (_, __, ___) =>
// // //                 Container(color: _T.glass,
// // //                     child: const Icon(Icons.person,
// // //                         color: _T.textSub, size: 36))),
// // //       ),
// // //     ),
// // //   );
// // // }
// // //
// // // // ═══════════════════════════════════════════════════════════════════════════════
// // // //  REPORTS TAB
// // // // ═══════════════════════════════════════════════════════════════════════════════
// // // class _ReportsTab extends StatelessWidget {
// // //   const _ReportsTab();
// // //
// // //   @override
// // //   Widget build(BuildContext context) => SingleChildScrollView(
// // //     physics: const BouncingScrollPhysics(),
// // //     padding: const EdgeInsets.fromLTRB(20, 28, 20, 120),
// // //     child: Column(
// // //       crossAxisAlignment: CrossAxisAlignment.start,
// // //       children: [
// // //
// // //         const _SecTitle('Reports', 'Submit & track your reports'),
// // //
// // //         const SizedBox(height: 28),
// // //
// // //         // ───── Complaints ─────
// // //         _RTile(
// // //           icon: Icons.assignment_rounded,
// // //           title: 'My Complaints',
// // //           sub: 'Submit a complaint or track its status',
// // //           color: _T.accentBlue,
// // //           onTap: () => Navigator.push(
// // //             context,
// // //             _slideRoute(const ComplaintPage(title: 'My Complaints')),
// // //           ),
// // //         ),
// // //
// // //         const SizedBox(height: 14),
// // //
// // //         // ───── Report Case (NEW) ─────
// // //         _RTile(
// // //           icon: Icons.report_problem_rounded,
// // //           title: 'Report Case',
// // //           sub: 'Report a missing person or suspicious case',
// // //           color: _T.accentRed,
// // //           onTap: () => Navigator.push(
// // //             context,
// // //             _slideRoute(const ReportCasePage()),
// // //           ),
// // //         ),
// // //
// // //         const SizedBox(height: 14),
// // //
// // //         // ───── Feedback ─────
// // //         _RTile(
// // //           icon: Icons.rate_review_rounded,
// // //           title: 'My Feedback',
// // //           sub: 'Share your experience or suggestions',
// // //           color: _T.accentPurple,
// // //           onTap: () => Navigator.push(
// // //             context,
// // //             _slideRoute(const FeedbackPage(title: 'My Feedbacks')),
// // //           ),
// // //         ),
// // //
// // //       ],
// // //     ),
// // //   );
// // // }
// // //
// // // class _RTile extends StatefulWidget {
// // //   final IconData icon;
// // //   final String   title, sub;
// // //   final Color    color;
// // //   final VoidCallback onTap;
// // //   const _RTile({required this.icon, required this.title, required this.sub,
// // //     required this.color, required this.onTap});
// // //   @override State<_RTile> createState() => _RTileState();
// // // }
// // //
// // // class _RTileState extends State<_RTile> {
// // //   bool _p = false;
// // //   @override
// // //   Widget build(BuildContext context) => GestureDetector(
// // //     onTap: widget.onTap,
// // //     onTapDown: (_) => setState(() => _p = true),
// // //     onTapUp:   (_) => setState(() => _p = false),
// // //     onTapCancel:() => setState(() => _p = false),
// // //     child: AnimatedScale(
// // //       scale: _p ? 0.97 : 1.0,
// // //       duration: const Duration(milliseconds: 100),
// // //       child: ClipRRect(
// // //         borderRadius: BorderRadius.circular(18),
// // //         child: BackdropFilter(
// // //           filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
// // //           child: Container(
// // //             padding: const EdgeInsets.all(18),
// // //             decoration: BoxDecoration(
// // //               gradient: LinearGradient(colors: [
// // //                 widget.color.withOpacity(0.12), Colors.white.withOpacity(0.03),
// // //               ], begin: Alignment.topLeft, end: Alignment.bottomRight),
// // //               borderRadius: BorderRadius.circular(18),
// // //               border: Border.all(color: widget.color.withOpacity(0.28)),
// // //             ),
// // //             child: Row(children: [
// // //               Container(width: 46, height: 46,
// // //                   decoration: BoxDecoration(shape: BoxShape.circle,
// // //                       gradient: LinearGradient(colors: [
// // //                         widget.color, widget.color.withOpacity(0.6),
// // //                       ])),
// // //                   child: Icon(widget.icon, color: Colors.white, size: 22)),
// // //               const SizedBox(width: 16),
// // //               Expanded(child: Column(
// // //                   crossAxisAlignment: CrossAxisAlignment.start, children: [
// // //                 Text(widget.title, style: const TextStyle(color: _T.textPrimary,
// // //                     fontSize: 15, fontWeight: FontWeight.w700)),
// // //                 const SizedBox(height: 3),
// // //                 Text(widget.sub, style: const TextStyle(
// // //                     color: _T.textSub, fontSize: 12)),
// // //               ])),
// // //               Icon(Icons.arrow_forward_ios_rounded,
// // //                   color: widget.color.withOpacity(0.6), size: 15),
// // //             ]),
// // //           ),
// // //         ),
// // //       ),
// // //     ),
// // //   );
// // // }
// // //
// // // // ═══════════════════════════════════════════════════════════════════════════════
// // // //  MISSING DIALOG
// // // // ═══════════════════════════════════════════════════════════════════════════════
// // // class _MissingDialog extends StatelessWidget {
// // //   final VoidCallback onMissing, onCriminal;
// // //   const _MissingDialog({required this.onMissing, required this.onCriminal});
// // //
// // //   @override
// // //   Widget build(BuildContext context) => Center(
// // //     child: Material(
// // //       color: Colors.transparent,
// // //       child: ClipRRect(
// // //         borderRadius: BorderRadius.circular(30),
// // //         child: BackdropFilter(
// // //           filter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
// // //           child: Container(
// // //             width: MediaQuery.of(context).size.width * 0.85,
// // //             padding: const EdgeInsets.all(26),
// // //             decoration: BoxDecoration(
// // //               color: const Color(0xFF080F26).withOpacity(0.97),
// // //               borderRadius: BorderRadius.circular(30),
// // //               border: Border.all(color: _T.glassBorder),
// // //               boxShadow: [BoxShadow(color: _T.accentBlue.withOpacity(0.18),
// // //                   blurRadius: 44, spreadRadius: -8)],
// // //             ),
// // //             child: Column(mainAxisSize: MainAxisSize.min, children: [
// // //               Container(width: 38, height: 4,
// // //                   decoration: BoxDecoration(
// // //                       color: _T.textSub.withOpacity(0.4),
// // //                       borderRadius: BorderRadius.circular(2))),
// // //               const SizedBox(height: 20),
// // //               ShaderMask(
// // //                 shaderCallback: (r) => const LinearGradient(
// // //                     colors: [_T.textPrimary, _T.accentCyan]).createShader(r),
// // //                 child: const Text('Browse Records', style: TextStyle(
// // //                     color: Colors.white, fontSize: 21,
// // //                     fontWeight: FontWeight.w800)),
// // //               ),
// // //               const SizedBox(height: 5),
// // //               const Text('Select a category', style: TextStyle(
// // //                   color: _T.textSub, fontSize: 13)),
// // //               const SizedBox(height: 22),
// // //               _DlgTile(icon: Icons.person_search_rounded,
// // //                   title: 'Missing Persons',
// // //                   sub: 'Browse active missing persons database',
// // //                   color: _T.accentBlue, onTap: onMissing),
// // //               const SizedBox(height: 12),
// // //               _DlgTile(icon: Icons.gavel_rounded,
// // //                   title: 'Criminal Cases',
// // //                   sub: 'View criminal records & case files',
// // //                   color: _T.accentPurple, onTap: onCriminal),
// // //             ]),
// // //           ),
// // //         ),
// // //       ),
// // //     ),
// // //   );
// // // }
// // //
// // // class _DlgTile extends StatefulWidget {
// // //   final IconData icon;
// // //   final String   title, sub;
// // //   final Color    color;
// // //   final VoidCallback onTap;
// // //   const _DlgTile({required this.icon, required this.title, required this.sub,
// // //     required this.color, required this.onTap});
// // //   @override State<_DlgTile> createState() => _DlgTileState();
// // // }
// // //
// // // class _DlgTileState extends State<_DlgTile> {
// // //   bool _p = false;
// // //   @override
// // //   Widget build(BuildContext context) => GestureDetector(
// // //     onTap: widget.onTap,
// // //     onTapDown: (_) => setState(() => _p = true),
// // //     onTapUp:   (_) => setState(() => _p = false),
// // //     onTapCancel:() => setState(() => _p = false),
// // //     child: AnimatedScale(
// // //       scale: _p ? 0.97 : 1.0,
// // //       duration: const Duration(milliseconds: 110),
// // //       child: Container(
// // //         padding: const EdgeInsets.all(15),
// // //         decoration: BoxDecoration(
// // //           borderRadius: BorderRadius.circular(16),
// // //           color: widget.color.withOpacity(0.10),
// // //           border: Border.all(color: widget.color.withOpacity(0.28)),
// // //         ),
// // //         child: Row(children: [
// // //           Container(width: 44, height: 44,
// // //               decoration: BoxDecoration(shape: BoxShape.circle,
// // //                   gradient: LinearGradient(colors: [
// // //                     widget.color, widget.color.withOpacity(0.55),
// // //                   ])),
// // //               child: Icon(widget.icon, color: Colors.white, size: 20)),
// // //           const SizedBox(width: 14),
// // //           Expanded(child: Column(
// // //               crossAxisAlignment: CrossAxisAlignment.start, children: [
// // //             Text(widget.title, style: const TextStyle(color: _T.textPrimary,
// // //                 fontSize: 14, fontWeight: FontWeight.w700)),
// // //             const SizedBox(height: 2),
// // //             Text(widget.sub, style: const TextStyle(
// // //                 color: _T.textSub, fontSize: 11)),
// // //           ])),
// // //           Icon(Icons.arrow_forward_ios_rounded,
// // //               color: widget.color, size: 13),
// // //         ]),
// // //       ),
// // //     ),
// // //   );
// // // }
// // //
// // // // ═══════════════════════════════════════════════════════════════════════════════
// // // //  SHARED WIDGETS
// // // // ═══════════════════════════════════════════════════════════════════════════════
// // // class _SecTitle extends StatelessWidget {
// // //   final String title, sub;
// // //   const _SecTitle(this.title, this.sub);
// // //   @override
// // //   Widget build(BuildContext context) => Column(
// // //       crossAxisAlignment: CrossAxisAlignment.start, children: [
// // //     ShaderMask(
// // //       shaderCallback: (r) => const LinearGradient(
// // //           colors: [_T.textPrimary, _T.accentCyan]).createShader(r),
// // //       child: Text(title, style: const TextStyle(color: Colors.white,
// // //           fontSize: 18, fontWeight: FontWeight.w800)),
// // //     ),
// // //     Text(sub, style: const TextStyle(color: _T.textSub, fontSize: 12)),
// // //   ]);
// // // }
// // //
// // // // ═══════════════════════════════════════════════════════════════════════════════
// // // //  ANIMATED BACKGROUND
// // // // ═══════════════════════════════════════════════════════════════════════════════
// // // class _AnimatedBg extends StatefulWidget {
// // //   const _AnimatedBg();
// // //   @override State<_AnimatedBg> createState() => _AnimatedBgState();
// // // }
// // //
// // // class _AnimatedBgState extends State<_AnimatedBg>
// // //     with SingleTickerProviderStateMixin {
// // //   late final AnimationController _c;
// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _c = AnimationController(vsync: this,
// // //         duration: const Duration(seconds: 10))..repeat();
// // //   }
// // //   @override void dispose() { _c.dispose(); super.dispose(); }
// // //
// // //   @override
// // //   Widget build(BuildContext context) => AnimatedBuilder(
// // //     animation: _c,
// // //     builder: (_, __) => CustomPaint(
// // //         painter: _BgCP(_c.value),
// // //         size: Size.infinite,
// // //         child: const SizedBox.expand()),
// // //   );
// // // }
// // //
// // // // ═══════════════════════════════════════════════════════════════════════════════
// // // //  CUSTOM PAINTERS
// // // // ═══════════════════════════════════════════════════════════════════════════════
// // // class _GridPainter extends CustomPainter {
// // //   @override
// // //   void paint(Canvas c, Size s) {
// // //     final p = Paint()..color = _T.accentBlue.withOpacity(0.055)..strokeWidth = 0.5;
// // //     for (double x = 0; x < s.width;  x += 26) c.drawLine(Offset(x,0),Offset(x,s.height),p);
// // //     for (double y = 0; y < s.height; y += 26) c.drawLine(Offset(0,y),Offset(s.width,y),  p);
// // //   }
// // //   @override bool shouldRepaint(_) => false;
// // // }
// // //
// // // class _HeroBgOrb extends CustomPainter {
// // //   final double t;
// // //   _HeroBgOrb(this.t);
// // //   @override
// // //   void paint(Canvas c, Size s) {
// // //     final a = t * 2 * math.pi;
// // //     void orb(double fx, double fy, double r, Color col, double op) {
// // //       final x = s.width  * (fx + 0.09 * math.sin(a + fy));
// // //       final y = s.height * (fy + 0.14 * math.cos(a + fx));
// // //       c.drawCircle(Offset(x,y), s.width*r, Paint()
// // //         ..shader = RadialGradient(colors: [col.withOpacity(op), Colors.transparent])
// // //             .createShader(Rect.fromCircle(center: Offset(x,y), radius: s.width*r)));
// // //     }
// // //     orb(0.78, 0.28, 0.44, _T.accentBlue,   0.26);
// // //     orb(0.18, 0.70, 0.28, _T.accentPurple, 0.20);
// // //   }
// // //   @override bool shouldRepaint(_HeroBgOrb o) => o.t != t;
// // // }
// // //
// // // class _RadarOrb extends CustomPainter {
// // //   final double t;
// // //   _RadarOrb(this.t);
// // //   @override
// // //   void paint(Canvas c, Size s) {
// // //     final cx = s.width/2, cy = s.height/2;
// // //     final center = Offset(cx, cy);
// // //     for (int i = 1; i <= 3; i++) {
// // //       c.drawCircle(center, s.width/2*i/3, Paint()
// // //         ..color = _T.accentCyan.withOpacity(0.10)
// // //         ..style = PaintingStyle.stroke..strokeWidth = 0.8);
// // //     }
// // //     final pr = s.width/2*(0.35 + 0.65*t);
// // //     c.drawCircle(center, pr, Paint()
// // //       ..color = _T.accentCyan.withOpacity((1-t)*0.22)
// // //       ..style = PaintingStyle.stroke..strokeWidth = 1.8);
// // //     c.drawCircle(center, 14, Paint()
// // //       ..shader = RadialGradient(colors: [_T.accentCyan.withOpacity(0.80), Colors.transparent])
// // //           .createShader(Rect.fromCircle(center: center, radius: 14)));
// // //     c.drawCircle(center, 6, Paint()..color = Colors.white);
// // //     for (int i = 0; i < 3; i++) {
// // //       final angle = t * 2 * math.pi + i * (2 * math.pi / 3);
// // //       final r = s.width/2*0.65;
// // //       final pos = Offset(cx + math.cos(angle)*r, cy + math.sin(angle)*r);
// // //       final col = [_T.accentCyan, _T.accentPurple, _T.accentGold][i];
// // //       c.drawCircle(pos, 3.5, Paint()..color = col
// // //         ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.5));
// // //       c.drawCircle(pos, 2.0, Paint()..color = Colors.white.withOpacity(0.92));
// // //     }
// // //   }
// // //   @override bool shouldRepaint(_RadarOrb o) => o.t != t;
// // // }
// // //
// // // class _ArcRingPainter extends CustomPainter {
// // //   final double angle;
// // //   final Color  color;
// // //   _ArcRingPainter(this.angle, this.color);
// // //   @override
// // //   void paint(Canvas c, Size s) {
// // //     final rect = Rect.fromCircle(
// // //         center: Offset(s.width/2, s.height/2), radius: s.width/2 - 1.5);
// // //     c.drawArc(rect, angle, math.pi * 1.55, false, Paint()
// // //       ..shader = SweepGradient(
// // //         colors: [color.withOpacity(0.65), Colors.transparent],
// // //         transform: GradientRotation(angle),
// // //       ).createShader(rect)
// // //       ..style = PaintingStyle.stroke..strokeWidth = 2.5
// // //       ..strokeCap = StrokeCap.round);
// // //   }
// // //   @override bool shouldRepaint(_ArcRingPainter o) => o.angle != angle;
// // // }
// // //
// // // class _SpinArc extends CustomPainter {
// // //   final double t;
// // //   final bool   active;
// // //   _SpinArc(this.t, this.active);
// // //   @override
// // //   void paint(Canvas c, Size s) {
// // //     if (!active) return;
// // //     final center = Offset(s.width/2, s.height/2);
// // //     final r = s.width/2;
// // //     final a = t * 2 * math.pi;
// // //     c.drawArc(Rect.fromCircle(center: center, radius: r),
// // //         a, math.pi * 1.4, false, Paint()
// // //           ..color = _T.accentRed.withOpacity(0.52)
// // //           ..style = PaintingStyle.stroke..strokeWidth = 2.8
// // //           ..strokeCap = StrokeCap.round);
// // //     c.drawArc(Rect.fromCircle(center: center, radius: r),
// // //         a + math.pi, math.pi * 0.5, false, Paint()
// // //           ..color = _T.accentRed.withOpacity(0.18)
// // //           ..style = PaintingStyle.stroke..strokeWidth = 1.6
// // //           ..strokeCap = StrokeCap.round);
// // //   }
// // //   @override bool shouldRepaint(_SpinArc o) => o.t != t || o.active != active;
// // // }
// // //
// // // class _BgCP extends CustomPainter {
// // //   final double t;
// // //   _BgCP(this.t);
// // //   @override
// // //   void paint(Canvas c, Size s) {
// // //     c.drawRect(Rect.fromLTWH(0,0,s.width,s.height), Paint()..color = _T.bg);
// // //     void glow(double fx, double fy, double r, Color col, double op) {
// // //       final a = t * 2 * math.pi;
// // //       final x = s.width  * (fx + 0.07 * math.sin(a + fy*3));
// // //       final y = s.height * (fy + 0.06 * math.cos(a + fx*2));
// // //       c.drawCircle(Offset(x,y), s.width*r, Paint()
// // //         ..shader = RadialGradient(colors: [col.withOpacity(op), Colors.transparent])
// // //             .createShader(Rect.fromCircle(center: Offset(x,y), radius: s.width*r)));
// // //     }
// // //     glow(0.82, 0.06, 0.46, _T.accentBlue,   0.17);
// // //     glow(0.12, 0.88, 0.40, _T.accentPurple, 0.12);
// // //     glow(0.50, 0.44, 0.22, _T.accentCyan,   0.06);
// // //   }
// // //   @override bool shouldRepaint(_BgCP o) => o.t != t;
// // // }
// // //
// // // // ═══════════════════════════════════════════════════════════════════════════════
// // // //  SLIDE ROUTE
// // // // ═══════════════════════════════════════════════════════════════════════════════
// // // PageRoute _slideRoute(Widget page) => PageRouteBuilder(
// // //   pageBuilder: (_, __, ___) => page,
// // //   transitionsBuilder: (_, a, __, child) => SlideTransition(
// // //     position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
// // //         .animate(CurvedAnimation(parent: a, curve: Curves.easeOutCubic)),
// // //     child: child,
// // //   ),
// // //   transitionDuration: const Duration(milliseconds: 360),
// // // );
// //
// //
// // import 'dart:convert';
// // import 'dart:math' as math;
// // import 'dart:ui';
// // import 'package:crowd_trace/report_case.dart';
// // import 'package:crowd_trace/upload_page.dart';
// // import 'package:crowd_trace/view_cases.dart';
// // import 'package:crowd_trace/view_uploads.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter/services.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:crowd_trace/complaint.dart';
// // import 'package:crowd_trace/view_criminals.dart';
// // import 'package:crowd_trace/view_missing_persons.dart';
// // import 'package:crowd_trace/feedback.dart';
// // import 'login.dart';
// // import 'View_Police_Station.dart';
// //
// // // ═══════════════════════════════════════════════════════════════════════════════
// // //  DESIGN TOKENS
// // // ═══════════════════════════════════════════════════════════════════════════════
// // class _T {
// //   static const bg           = Color(0xFF04091A);
// //   static const surface      = Color(0xFF080F26);
// //   static const card         = Color(0xFF0C1535);
// //   static const accentBlue   = Color(0xFF1D6BFF);
// //   static const accentCyan   = Color(0xFF00C2FF);
// //   static const accentPurple = Color(0xFF7B5CFF);
// //   static const accentGold   = Color(0xFFFFB547);
// //   static const accentRed    = Color(0xFFFF4057);
// //   static const accentGreen  = Color(0xFF00E676);
// //   static const textPrimary  = Color(0xFFEEF3FF);
// //   static const textSub      = Color(0xFF5A7299);
// //   static const textMid      = Color(0xFF8AAAD4);
// //   static const glass        = Color(0x0FFFFFFF);
// //   static const glassBorder  = Color(0x14FFFFFF);
// // }
// //
// // // ═══════════════════════════════════════════════════════════════════════════════
// // //  DATA MODELS
// // // ═══════════════════════════════════════════════════════════════════════════════
// // class _PersonRecord {
// //   final int    id;
// //   final String name, age, gender, details, photoUrl;
// //   const _PersonRecord({
// //     required this.id,   required this.name,
// //     required this.age,  required this.gender,
// //     required this.details, required this.photoUrl,
// //   });
// //
// //   factory _PersonRecord.fromMissing(Map<String, dynamic> j, String base) {
// //     String raw = (j['photo'] ?? '').toString();
// //     String url = raw.isEmpty ? '' : (raw.startsWith('http') ? raw : '$base$raw');
// //     return _PersonRecord(
// //       id:       int.tryParse(j['id'].toString()) ?? 0,
// //       name:     j['name']?.toString() ?? 'Unknown',
// //       age:      j['phone']?.toString() ?? '—',   // backend maps age→phone key
// //       gender:   j['gender']?.toString() ?? '',
// //       details:  j['experience']?.toString() ?? '',
// //       photoUrl: url,
// //     );
// //   }
// //
// //   factory _PersonRecord.fromCriminal(Map<String, dynamic> j, String base) {
// //     String raw = (j['photo'] ?? '').toString();
// //     String url = raw.isEmpty ? '' : (raw.startsWith('http') ? raw : '$base$raw');
// //     return _PersonRecord(
// //       id:       int.tryParse(j['id'].toString()) ?? 0,
// //       name:     j['name']?.toString() ?? 'Unknown',
// //       age:      j['phone']?.toString() ?? '—',
// //       gender:   j['gender']?.toString() ?? '',
// //       details:  j['experience']?.toString() ?? '',
// //       photoUrl: url,
// //     );
// //   }
// // }
// //
// // class _CaseRecord {
// //   final int    id;
// //   final String description, progress, status, date, station, photoUrl;
// //   const _CaseRecord({
// //     required this.id,          required this.description,
// //     required this.progress,    required this.status,
// //     required this.date,        required this.station,
// //     required this.photoUrl,
// //   });
// //   factory _CaseRecord.fromJson(Map<String, dynamic> j) => _CaseRecord(
// //     id:          int.tryParse(j['id'].toString()) ?? 0,
// //     description: j['description']?.toString() ?? '',
// //     progress:    j['progress']?.toString() ?? 'pending',
// //     status:      j['status']?.toString() ?? 'Not Viewed',
// //     date:        j['date']?.toString() ?? '',
// //     station:     j['station']?.toString() ?? 'Not Assigned',
// //     photoUrl:    j['photo']?.toString() ?? '',
// //   );
// // }
// //
// // class _Detection {
// //   final int    id;
// //   final String name, category, date, latitude, longitude, photoUrl;
// //   const _Detection({
// //     required this.id,         required this.name,
// //     required this.category,   required this.date,
// //     required this.latitude,   required this.longitude,
// //     required this.photoUrl,
// //   });
// //   factory _Detection.fromJson(Map<String, dynamic> j) => _Detection(
// //     id:        int.tryParse(j['id'].toString()) ?? 0,
// //     name:      j['name']?.toString() ?? '',
// //     category:  j['category']?.toString() ?? '',
// //     date:      j['date']?.toString() ?? '',
// //     latitude:  j['latitude']?.toString() ?? '',
// //     longitude: j['longitude']?.toString() ?? '',
// //     photoUrl:  j['photo']?.toString() ?? '',
// //   );
// // }
// //
// // class _ComplaintRecord {
// //   final int    id;
// //   final String description, date, reply;
// //   const _ComplaintRecord({required this.id, required this.description, required this.date, required this.reply});
// //   factory _ComplaintRecord.fromJson(Map<String, dynamic> j) => _ComplaintRecord(
// //     id:          int.tryParse(j['id'].toString()) ?? 0,
// //     description: j['complaint']?.toString() ?? '',
// //     date:        j['date']?.toString() ?? '',
// //     reply:       j['reply']?.toString() ?? 'pending',
// //   );
// // }
// //
// // // ═══════════════════════════════════════════════════════════════════════════════
// // //  NAV ITEMS  (index 2 = FAB)
// // // ═══════════════════════════════════════════════════════════════════════════════
// // class _NavItem {
// //   final String   label;
// //   final IconData icon, activeIcon;
// //   const _NavItem(this.label, this.icon, this.activeIcon);
// // }
// //
// // const _navItems = [
// //   _NavItem('Home',    Icons.home_outlined,          Icons.home_rounded),
// //   _NavItem('Police',  Icons.local_police_outlined,  Icons.local_police_rounded),
// //   _NavItem('',        Icons.add,                    Icons.add),
// //   _NavItem('Missing', Icons.person_search_outlined, Icons.manage_search_rounded),
// //   _NavItem('Reports', Icons.assignment_outlined,    Icons.assignment_rounded),
// // ];
// //
// // // ═══════════════════════════════════════════════════════════════════════════════
// // //  ROOT WIDGET
// // // ═══════════════════════════════════════════════════════════════════════════════
// // class Home_page extends StatefulWidget {
// //   const Home_page({super.key});
// //   @override State<Home_page> createState() => _HomePageState();
// // }
// //
// // class _HomePageState extends State<Home_page> with TickerProviderStateMixin {
// //   int  _idx = 0;
// //   late final AnimationController _fabPulse;
// //
// //   // Stats
// //   int  _stPolice  = 0;
// //   int  _stMissing = 0;
// //   int  _stCases   = 0;
// //   bool _stLoaded  = false;
// //
// //   // Full data sets (loaded once, passed down)
// //   List<_PersonRecord> _missingList    = [];
// //   List<_PersonRecord> _criminalList   = [];
// //   List<_CaseRecord>   _casesList      = [];
// //   List<_Detection>    _detectionsList = [];
// //   List<_ComplaintRecord> _complaintsList = [];
// //   bool _dataLoaded = false;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _fabPulse = AnimationController(vsync: this, duration: const Duration(seconds: 2))
// //       ..repeat(reverse: true);
// //     _loadAll();
// //   }
// //
// //   @override void dispose() { _fabPulse.dispose(); super.dispose(); }
// //
// //   // ── LOAD ALL DATA IN PARALLEL ──────────────────────────────────────────────
// //   Future<void> _loadAll() async {
// //     try {
// //       final sh   = await SharedPreferences.getInstance();
// //       final base = sh.getString('url') ?? '';
// //       final lid  = sh.getString('lid') ?? '';
// //
// //       await Future.wait([
// //         _loadStats(base, lid),
// //         _loadMissing(base, lid),
// //         _loadCriminals(base, lid),
// //         _loadCases(base, lid),
// //         _loadDetections(base, lid),
// //         _loadComplaints(base, lid),
// //       ]);
// //
// //       if (mounted) setState(() => _dataLoaded = true);
// //     } catch (_) {
// //       if (mounted) setState(() => _dataLoaded = true);
// //     }
// //   }
// //
// //   Future<void> _loadStats(String base, String lid) async {
// //     try {
// //       final res = await http.post(
// //         Uri.parse('$base/dashboard_stats/'),
// //         body: {'lid': lid},
// //       ).timeout(const Duration(seconds: 8));
// //       if (res.statusCode == 200) {
// //         final d = jsonDecode(res.body);
// //         if (d['status'] == 'ok' && mounted) {
// //           setState(() {
// //             _stPolice  = int.tryParse(d['police_stations'].toString()) ?? 0;
// //             _stMissing = int.tryParse(d['missing_persons'].toString())  ?? 0;
// //             _stCases   = int.tryParse(d['resolved_cases'].toString())   ?? 0;
// //             _stLoaded  = true;
// //           });
// //         }
// //       }
// //     } catch (_) {}
// //   }
// //
// //   Future<void> _loadMissing(String base, String lid) async {
// //     try {
// //       final res = await http.post(
// //         Uri.parse('$base/user_view_missing_persons/'),
// //         body: {'lid': lid},
// //       ).timeout(const Duration(seconds: 10));
// //       if (res.statusCode == 200) {
// //         final d = jsonDecode(res.body);
// //         if (d['status'] == 'ok' && mounted) {
// //           final arr = d['data'] as List;
// //           setState(() {
// //             _missingList = arr.map((p) => _PersonRecord.fromMissing(
// //                 p as Map<String, dynamic>, base)).toList();
// //           });
// //         }
// //       }
// //     } catch (_) {}
// //   }
// //
// //   Future<void> _loadCriminals(String base, String lid) async {
// //     try {
// //       final res = await http.post(
// //         Uri.parse('$base/user_view_criminals/'),
// //         body: {'lid': lid},
// //       ).timeout(const Duration(seconds: 10));
// //       if (res.statusCode == 200) {
// //         final d = jsonDecode(res.body);
// //         if (d['status'] == 'ok' && mounted) {
// //           final arr = d['data'] as List;
// //           setState(() {
// //             _criminalList = arr.map((p) => _PersonRecord.fromCriminal(
// //                 p as Map<String, dynamic>, base)).toList();
// //           });
// //         }
// //       }
// //     } catch (_) {}
// //   }
// //
// //   Future<void> _loadCases(String base, String lid) async {
// //     try {
// //       final res = await http.post(
// //         Uri.parse('$base/user_view_cases/'),
// //         body: {'lid': lid},
// //       ).timeout(const Duration(seconds: 10));
// //       if (res.statusCode == 200) {
// //         final d = jsonDecode(res.body);
// //         if (d['status'] == 'ok' && mounted) {
// //           final arr = d['data'] as List;
// //           setState(() {
// //             _casesList = arr.map((c) =>
// //                 _CaseRecord.fromJson(c as Map<String, dynamic>)).toList();
// //           });
// //         }
// //       }
// //     } catch (_) {}
// //   }
// //
// //   Future<void> _loadDetections(String base, String lid) async {
// //     try {
// //       final res = await http.post(
// //         Uri.parse('$base/user_view_detections/'),
// //         body: {'uid': lid},
// //       ).timeout(const Duration(seconds: 10));
// //       if (res.statusCode == 200) {
// //         final d = jsonDecode(res.body);
// //         if (d['status'] == 'ok' && mounted) {
// //           final arr = d['data'] as List;
// //           setState(() {
// //             _detectionsList = arr.map((c) =>
// //                 _Detection.fromJson(c as Map<String, dynamic>)).toList();
// //           });
// //         }
// //       }
// //     } catch (_) {}
// //   }
// //
// //   Future<void> _loadComplaints(String base, String lid) async {
// //     try {
// //       final res = await http.post(
// //         Uri.parse('$base/user_view_complaints/'),
// //         body: {'lid': lid},
// //       ).timeout(const Duration(seconds: 10));
// //       if (res.statusCode == 200) {
// //         final d = jsonDecode(res.body);
// //         if (d['status'] == 'ok' && mounted) {
// //           final arr = d['data'] as List;
// //           setState(() {
// //             _complaintsList = arr.map((c) =>
// //                 _ComplaintRecord.fromJson(c as Map<String, dynamic>)).toList();
// //           });
// //         }
// //       }
// //     } catch (_) {}
// //   }
// //
// //   Widget _page(int i) {
// //     switch (i) {
// //       case 0: return _HomeTab(
// //         onLogout:     _confirmLogout,
// //         onRefresh:    _loadAll,
// //         stPolice:     _stPolice,
// //         stMissing:    _stMissing,
// //         stCases:      _stCases,
// //         stLoaded:     _stLoaded,
// //         missingList:  _missingList,
// //         criminalList: _criminalList,
// //         casesList:    _casesList,
// //         detections:   _detectionsList,
// //         complaints:   _complaintsList,
// //         dataLoaded:   _dataLoaded,
// //       );
// //       case 1: return const View_Police_Station(title: 'Police Stations');
// //       case 3: return const UploadPage();
// //       case 4: return const _ReportsTab();
// //       default: return _HomeTab(
// //         onLogout:     _confirmLogout,
// //         onRefresh:    _loadAll,
// //         stPolice:     _stPolice,
// //         stMissing:    _stMissing,
// //         stCases:      _stCases,
// //         stLoaded:     _stLoaded,
// //         missingList:  _missingList,
// //         criminalList: _criminalList,
// //         casesList:    _casesList,
// //         detections:   _detectionsList,
// //         complaints:   _complaintsList,
// //         dataLoaded:   _dataLoaded,
// //       );
// //     }
// //   }
// //
// //   void _onTap(int i) {
// //     HapticFeedback.lightImpact();
// //     if (i == 2) {
// //       Navigator.push(context, _slideRoute(const UploadPage()));
// //       return;
// //     }
// //     if (i == 3) { _missingDialog(); return; }
// //     setState(() => _idx = i);
// //   }
// //
// //   void _missingDialog() {
// //     showGeneralDialog(
// //       context: context,
// //       barrierDismissible: true, barrierLabel: '',
// //       barrierColor: Colors.black.withOpacity(0.65),
// //       transitionDuration: const Duration(milliseconds: 380),
// //       transitionBuilder: (_, a, __, child) => ScaleTransition(
// //         scale: CurvedAnimation(parent: a, curve: Curves.easeOutBack),
// //         child: FadeTransition(opacity: a, child: child),
// //       ),
// //       pageBuilder: (ctx, _, __) => _MissingDialog(
// //         onMissing: () {
// //           Navigator.pop(ctx);
// //           Navigator.push(context, _slideRoute(const ViewStylistsPage(shopId: '')));
// //         },
// //         onCriminal: () {
// //           Navigator.pop(ctx);
// //           Navigator.push(context, _slideRoute(const ViewCriminalsPage(shopId: '')));
// //         },
// //       ),
// //     );
// //   }
// //
// //   void _confirmLogout() {
// //     showDialog(
// //       context: context,
// //       builder: (_) => AlertDialog(
// //         backgroundColor: const Color(0xFF0A1428),
// //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
// //         icon: const Icon(Icons.logout_rounded, color: _T.accentRed, size: 30),
// //         title: const Text('Sign Out',
// //             style: TextStyle(color: _T.textPrimary, fontWeight: FontWeight.w800)),
// //         content: const Text('Are you sure you want to sign out?',
// //             style: TextStyle(color: _T.textSub, fontSize: 13)),
// //         actions: [
// //           TextButton(onPressed: () => Navigator.pop(context),
// //               child: const Text('Cancel', style: TextStyle(color: _T.textSub))),
// //           TextButton(
// //             onPressed: () async {
// //               Navigator.pop(context);
// //               final sh = await SharedPreferences.getInstance();
// //               await sh.remove('lid');
// //               if (mounted) Navigator.pushReplacement(context,
// //                   MaterialPageRoute(builder: (_) => const LoginPage(title: 'Login')));
// //             },
// //             child: const Text('Sign Out',
// //                 style: TextStyle(color: _T.accentRed, fontWeight: FontWeight.w800)),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final bottom = MediaQuery.of(context).padding.bottom;
// //     return AnnotatedRegion<SystemUiOverlayStyle>(
// //       value: SystemUiOverlayStyle.light,
// //       child: Scaffold(
// //         backgroundColor: _T.bg,
// //         extendBody: true,
// //         body: Stack(children: [
// //           const _AnimatedBg(),
// //           SafeArea(
// //             bottom: false,
// //             child: AnimatedSwitcher(
// //               duration: const Duration(milliseconds: 340),
// //               transitionBuilder: (child, anim) => FadeTransition(
// //                 opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut),
// //                 child: SlideTransition(
// //                   position: Tween<Offset>(
// //                       begin: const Offset(0, 0.03), end: Offset.zero).animate(anim),
// //                   child: child,
// //                 ),
// //               ),
// //               child: KeyedSubtree(key: ValueKey(_idx), child: _page(_idx)),
// //             ),
// //           ),
// //         ]),
// //         bottomNavigationBar: _FloatingNavBar(
// //           selectedIndex: _idx,
// //           fabPulse:      _fabPulse,
// //           onTap:         _onTap,
// //           bottomPad:     bottom,
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
// // // ═══════════════════════════════════════════════════════════════════════════════
// // //  FLOATING NAV BAR
// // // ═══════════════════════════════════════════════════════════════════════════════
// // class _FloatingNavBar extends StatefulWidget {
// //   final int selectedIndex;
// //   final AnimationController fabPulse;
// //   final ValueChanged<int> onTap;
// //   final double bottomPad;
// //   const _FloatingNavBar({
// //     required this.selectedIndex, required this.fabPulse,
// //     required this.onTap,         required this.bottomPad,
// //   });
// //   @override State<_FloatingNavBar> createState() => _FloatingNavBarState();
// // }
// //
// // class _FloatingNavBarState extends State<_FloatingNavBar>
// //     with SingleTickerProviderStateMixin {
// //   late final AnimationController _pillAnim;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _pillAnim = AnimationController(
// //         vsync: this, duration: const Duration(milliseconds: 340), value: 1);
// //   }
// //
// //   @override
// //   void didUpdateWidget(_FloatingNavBar old) {
// //     super.didUpdateWidget(old);
// //     if (old.selectedIndex != widget.selectedIndex) _pillAnim.forward(from: 0);
// //   }
// //
// //   @override void dispose() { _pillAnim.dispose(); super.dispose(); }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       color: Colors.transparent,
// //       padding: EdgeInsets.fromLTRB(18, 8, 18, widget.bottomPad + 14),
// //       child: ClipRRect(
// //         borderRadius: BorderRadius.circular(40),
// //         child: BackdropFilter(
// //           filter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
// //           child: Container(
// //             height: 72,
// //             decoration: BoxDecoration(
// //               color: const Color(0xFF0A1428).withOpacity(0.93),
// //               borderRadius: BorderRadius.circular(40),
// //               border: Border.all(color: _T.glassBorder),
// //               boxShadow: [
// //                 BoxShadow(color: _T.accentBlue.withOpacity(0.12),
// //                     blurRadius: 28, offset: const Offset(0, 8)),
// //                 BoxShadow(color: Colors.black.withOpacity(0.40),
// //                     blurRadius: 32, offset: const Offset(0, 12)),
// //               ],
// //             ),
// //             child: Row(
// //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //               children: List.generate(_navItems.length, (i) {
// //                 if (i == 2) return _UploadFab(
// //                     pulse: widget.fabPulse, onTap: () => widget.onTap(2));
// //                 return _NavPill(
// //                   item:     _navItems[i],
// //                   selected: widget.selectedIndex == i,
// //                   onTap:    () => widget.onTap(i),
// //                 );
// //               }),
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
// // // ── Upload FAB ────────────────────────────────────────────────────────────────
// // class _UploadFab extends StatefulWidget {
// //   final AnimationController pulse;
// //   final VoidCallback onTap;
// //   const _UploadFab({required this.pulse, required this.onTap});
// //   @override State<_UploadFab> createState() => _UploadFabState();
// // }
// //
// // class _UploadFabState extends State<_UploadFab>
// //     with SingleTickerProviderStateMixin {
// //   bool _pressed = false;
// //   late final AnimationController _spin;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _spin = AnimationController(vsync: this, duration: const Duration(seconds: 6))
// //       ..repeat();
// //   }
// //
// //   @override void dispose() { _spin.dispose(); super.dispose(); }
// //
// //   @override
// //   Widget build(BuildContext context) => GestureDetector(
// //     onTap: () { HapticFeedback.mediumImpact(); widget.onTap(); },
// //     onTapDown: (_) => setState(() => _pressed = true),
// //     onTapUp:   (_) => setState(() => _pressed = false),
// //     onTapCancel:() => setState(() => _pressed = false),
// //     child: AnimatedBuilder(
// //       animation: Listenable.merge([widget.pulse, _spin]),
// //       builder: (_, __) {
// //         final g = widget.pulse.value;
// //         final angle = _spin.value * 2 * math.pi;
// //         return AnimatedScale(
// //           scale: _pressed ? 0.88 : 1.0,
// //           duration: const Duration(milliseconds: 120),
// //           child: SizedBox(
// //             width: 72, height: 72,
// //             child: Stack(alignment: Alignment.center, children: [
// //               Container(width: 72, height: 72,
// //                   decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
// //                     BoxShadow(color: _T.accentCyan.withOpacity(0.18 + g * 0.18),
// //                         blurRadius: 18 + g * 18, spreadRadius: g * 5),
// //                     BoxShadow(color: _T.accentBlue.withOpacity(0.28 + g * 0.20),
// //                         blurRadius: 10 + g * 10),
// //                   ])),
// //               CustomPaint(size: const Size(72, 72),
// //                   painter: _ArcRingPainter(angle, _T.accentCyan)),
// //               Container(
// //                 width: 58, height: 58,
// //                 decoration: BoxDecoration(
// //                   shape: BoxShape.circle,
// //                   gradient: SweepGradient(
// //                     colors: const [_T.accentCyan, _T.accentBlue, _T.accentPurple, _T.accentCyan],
// //                     transform: GradientRotation(angle),
// //                   ),
// //                   boxShadow: [BoxShadow(
// //                       color: _T.accentBlue.withOpacity(0.50 + g * 0.22),
// //                       blurRadius: 18, spreadRadius: 1)],
// //                 ),
// //                 child: const Icon(Icons.add_photo_alternate_rounded,
// //                     color: Colors.white, size: 26),
// //               ),
// //             ]),
// //           ),
// //         );
// //       },
// //     ),
// //   );
// // }
// //
// // // ── Nav Pill ──────────────────────────────────────────────────────────────────
// // class _NavPill extends StatefulWidget {
// //   final _NavItem item;
// //   final bool     selected;
// //   final VoidCallback onTap;
// //   const _NavPill({required this.item, required this.selected, required this.onTap});
// //   @override State<_NavPill> createState() => _NavPillState();
// // }
// //
// // class _NavPillState extends State<_NavPill> with SingleTickerProviderStateMixin {
// //   late final AnimationController _c;
// //   late final Animation<double>   _v;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 320));
// //     _v = CurvedAnimation(parent: _c, curve: Curves.easeOutCubic);
// //     if (widget.selected) _c.value = 1;
// //   }
// //
// //   @override
// //   void didUpdateWidget(_NavPill o) {
// //     super.didUpdateWidget(o);
// //     widget.selected ? _c.forward() : _c.reverse();
// //   }
// //
// //   @override void dispose() { _c.dispose(); super.dispose(); }
// //
// //   @override
// //   Widget build(BuildContext context) => GestureDetector(
// //     onTap: () { HapticFeedback.selectionClick(); widget.onTap(); },
// //     behavior: HitTestBehavior.opaque,
// //     child: AnimatedBuilder(
// //       animation: _v,
// //       builder: (_, __) {
// //         final v = _v.value;
// //         return Container(
// //           height: 46,
// //           padding: EdgeInsets.symmetric(horizontal: 10 + 4 * v),
// //           decoration: BoxDecoration(
// //             color: v > 0.05 ? _T.accentBlue.withOpacity(0.15 * v) : Colors.transparent,
// //             borderRadius: BorderRadius.circular(23),
// //             border: v > 0.5 ? Border.all(color: _T.accentBlue.withOpacity(0.28 * v)) : null,
// //           ),
// //           child: Row(mainAxisSize: MainAxisSize.min, children: [
// //             Icon(widget.selected ? widget.item.activeIcon : widget.item.icon,
// //                 color: Color.lerp(_T.textSub, _T.accentCyan, v), size: 22),
// //             if (v > 0.3) ...[
// //               SizedBox(width: 5 * v),
// //               Opacity(
// //                 opacity: ((v - 0.3) / 0.7).clamp(0, 1),
// //                 child: Text(widget.item.label,
// //                     style: const TextStyle(color: _T.accentCyan,
// //                         fontSize: 12, fontWeight: FontWeight.w700)),
// //               ),
// //             ],
// //           ]),
// //         );
// //       },
// //     ),
// //   );
// // }
// //
// // // ═══════════════════════════════════════════════════════════════════════════════
// // //  HOME TAB — FULLY CONNECTED
// // // ═══════════════════════════════════════════════════════════════════════════════
// // class _HomeTab extends StatefulWidget {
// //   final VoidCallback? onLogout;
// //   final Future<void> Function()? onRefresh;
// //   final int  stPolice, stMissing, stCases;
// //   final bool stLoaded, dataLoaded;
// //   final List<_PersonRecord>    missingList, criminalList;
// //   final List<_CaseRecord>      casesList;
// //   final List<_Detection>       detections;
// //   final List<_ComplaintRecord> complaints;
// //
// //   const _HomeTab({
// //     this.onLogout,
// //     this.onRefresh,
// //     this.stPolice = 0, this.stMissing = 0, this.stCases = 0,
// //     this.stLoaded = false, this.dataLoaded = false,
// //     this.missingList = const [],  this.criminalList = const [],
// //     this.casesList   = const [],  this.detections   = const [],
// //     this.complaints  = const [],
// //   });
// //
// //   @override State<_HomeTab> createState() => _HomeTabState();
// // }
// //
// // class _HomeTabState extends State<_HomeTab> with TickerProviderStateMixin {
// //   late final AnimationController _enter;
// //   bool _isRefreshing = false;
// //
// //   Animation<double> _af(double a, double b) =>
// //       Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
// //           parent: _enter, curve: Interval(a, b, curve: Curves.easeOutCubic)));
// //
// //   Animation<Offset> _as(double a, double b) =>
// //       Tween<Offset>(begin: const Offset(0, 0.07), end: Offset.zero)
// //           .animate(CurvedAnimation(
// //           parent: _enter, curve: Interval(a, b, curve: Curves.easeOutCubic)));
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _enter = AnimationController(
// //         vsync: this, duration: const Duration(milliseconds: 1000))..forward();
// //   }
// //
// //   @override void dispose() { _enter.dispose(); super.dispose(); }
// //
// //   Future<void> _doRefresh() async {
// //     setState(() => _isRefreshing = true);
// //     await widget.onRefresh?.call();
// //     if (mounted) setState(() => _isRefreshing = false);
// //   }
// //
// //   void _push(Widget page) => Navigator.push(context, _slideRoute(page));
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return RefreshIndicator(
// //       onRefresh: _doRefresh,
// //       color: _T.accentCyan,
// //       backgroundColor: _T.card,
// //       child: CustomScrollView(
// //         physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
// //         slivers: [
// //
// //           // ── Top Bar ─────────────────────────────────────────────────────
// //           SliverToBoxAdapter(child: FadeTransition(opacity: _af(0, 0.35),
// //               child: _TopBar(onLogout: widget.onLogout, isRefreshing: _isRefreshing))),
// //
// //           // ── Ticker ──────────────────────────────────────────────────────
// //           SliverToBoxAdapter(child: FadeTransition(opacity: _af(0.05, 0.4),
// //               child: const Padding(
// //                   padding: EdgeInsets.fromLTRB(20, 12, 20, 0),
// //                   child: _TickerBanner()))),
// //
// //           // ── Hero ─────────────────────────────────────────────────────────
// //           SliverToBoxAdapter(child: FadeTransition(opacity: _af(0.10, 0.45),
// //               child: SlideTransition(position: _as(0.10, 0.45),
// //                   child: const _HeroCard()))),
// //
// //           const SliverToBoxAdapter(child: SizedBox(height: 24)),
// //
// //           // ── Live Stats ───────────────────────────────────────────────────
// //           SliverToBoxAdapter(child: FadeTransition(opacity: _af(0.20, 0.55),
// //               child: _LiveStatStrip(
// //                 police:  widget.stPolice,
// //                 missing: widget.stMissing,
// //                 cases:   widget.stCases,
// //                 loaded:  widget.stLoaded,
// //               ))),
// //
// //           const SliverToBoxAdapter(child: SizedBox(height: 24)),
// //
// //           // ── Quick Actions ────────────────────────────────────────────────
// //           SliverToBoxAdapter(child: FadeTransition(opacity: _af(0.30, 0.62),
// //               child: SlideTransition(position: _as(0.30, 0.62),
// //                   child: _QuickActions(onPush: _push)))),
// //
// //           const SliverToBoxAdapter(child: SizedBox(height: 24)),
// //
// //           // ── Missing + Criminal Carousel ──────────────────────────────────
// //           SliverToBoxAdapter(child: FadeTransition(opacity: _af(0.40, 0.72),
// //               child: SlideTransition(position: _as(0.40, 0.72),
// //                   child: _PersonCarouselSection(
// //                     missingList:  widget.missingList,
// //                     criminalList: widget.criminalList,
// //                     dataLoaded:   widget.dataLoaded,
// //                   )))),
// //
// //           const SliverToBoxAdapter(child: SizedBox(height: 24)),
// //
// //           // ── My Cases ────────────────────────────────────────────────────
// //           SliverToBoxAdapter(child: FadeTransition(opacity: _af(0.50, 0.80),
// //               child: SlideTransition(position: _as(0.50, 0.80),
// //                   child: _MyCasesSection(
// //                     cases:      widget.casesList,
// //                     dataLoaded: widget.dataLoaded,
// //                     onPush:     _push,
// //                   )))),
// //
// //           const SliverToBoxAdapter(child: SizedBox(height: 24)),
// //
// //           // ── My Detections ────────────────────────────────────────────────
// //           SliverToBoxAdapter(child: FadeTransition(opacity: _af(0.58, 0.86),
// //               child: SlideTransition(position: _as(0.58, 0.86),
// //                   child: _MyDetectionsSection(
// //                     detections: widget.detections,
// //                     dataLoaded: widget.dataLoaded,
// //                     onPush:     _push,
// //                   )))),
// //
// //           const SliverToBoxAdapter(child: SizedBox(height: 24)),
// //
// //           // ── My Complaints ────────────────────────────────────────────────
// //           SliverToBoxAdapter(child: FadeTransition(opacity: _af(0.66, 0.92),
// //               child: SlideTransition(position: _as(0.66, 0.92),
// //                   child: _MyComplaintsSection(
// //                     complaints: widget.complaints,
// //                     dataLoaded: widget.dataLoaded,
// //                     onPush:     _push,
// //                   )))),
// //
// //           const SliverToBoxAdapter(child: SizedBox(height: 24)),
// //
// //           // ── How It Works ─────────────────────────────────────────────────
// //           SliverToBoxAdapter(child: FadeTransition(opacity: _af(0.74, 1.0),
// //               child: const _HowItWorks())),
// //
// //           const SliverToBoxAdapter(child: SizedBox(height: 120)),
// //         ],
// //       ),
// //     );
// //   }
// // }
// //
// // // ─────────────────────────────────────────────────────────────────────────────
// // //  TOP BAR
// // // ─────────────────────────────────────────────────────────────────────────────
// // class _TopBar extends StatelessWidget {
// //   final VoidCallback? onLogout;
// //   final bool isRefreshing;
// //   const _TopBar({this.onLogout, this.isRefreshing = false});
// //
// //   @override
// //   Widget build(BuildContext context) => Padding(
// //     padding: const EdgeInsets.fromLTRB(20, 18, 16, 0),
// //     child: Row(children: [
// //       Container(
// //         width: 40, height: 40,
// //         decoration: BoxDecoration(
// //           gradient: const LinearGradient(
// //               colors: [_T.accentBlue, _T.accentCyan],
// //               begin: Alignment.topLeft, end: Alignment.bottomRight),
// //           borderRadius: BorderRadius.circular(13),
// //           boxShadow: [BoxShadow(color: _T.accentBlue.withOpacity(0.45), blurRadius: 14)],
// //         ),
// //         child: const Icon(Icons.shield_outlined, color: Colors.white, size: 22),
// //       ),
// //       const SizedBox(width: 11),
// //       Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
// //         ShaderMask(
// //           shaderCallback: (r) => const LinearGradient(
// //               colors: [_T.textPrimary, _T.accentCyan]).createShader(r),
// //           child: const Text('CrowdTrace',
// //               style: TextStyle(color: Colors.white, fontSize: 20,
// //                   fontWeight: FontWeight.w800, letterSpacing: 0.2)),
// //         ),
// //         const Text('Missing Person System',
// //             style: TextStyle(color: _T.textSub, fontSize: 9.5)),
// //       ]),
// //       const Spacer(),
// //       // Notifications → ViewCasesPage
// //       _GlassBtn(
// //         icon: Icons.notifications_outlined,
// //         onTap: () => Navigator.push(
// //             context, _slideRoute(const ViewCasesPage())),
// //       ),
// //       const SizedBox(width: 8),
// //       if (isRefreshing)
// //         const SizedBox(width: 40, height: 40,
// //             child: Center(child: SizedBox(width: 18, height: 18,
// //                 child: CircularProgressIndicator(strokeWidth: 2, color: _T.accentCyan))))
// //       else
// //         _GlassBtn(
// //           icon: Icons.logout_rounded,
// //           iconColor: _T.accentRed.withOpacity(0.85),
// //           onTap: onLogout ?? () {},
// //         ),
// //       const SizedBox(width: 4),
// //     ]),
// //   );
// // }
// //
// // class _GlassBtn extends StatelessWidget {
// //   final IconData icon;
// //   final Color    iconColor;
// //   final VoidCallback onTap;
// //   const _GlassBtn({required this.icon, required this.onTap,
// //     this.iconColor = _T.textMid});
// //
// //   @override
// //   Widget build(BuildContext context) => GestureDetector(
// //     onTap: onTap,
// //     child: ClipRRect(
// //       borderRadius: BorderRadius.circular(13),
// //       child: BackdropFilter(
// //         filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
// //         child: Container(
// //           width: 40, height: 40,
// //           decoration: BoxDecoration(
// //             color: _T.glass,
// //             borderRadius: BorderRadius.circular(13),
// //             border: Border.all(color: _T.glassBorder),
// //           ),
// //           child: Icon(icon, color: iconColor, size: 19),
// //         ),
// //       ),
// //     ),
// //   );
// // }
// //
// // // ─────────────────────────────────────────────────────────────────────────────
// // //  TICKER BANNER
// // // ─────────────────────────────────────────────────────────────────────────────
// // const _tickers = [
// //   '🔴  CrowdTrace — Community-powered missing person identification system',
// //   '📷  Upload a clear photo to help identify a missing person near you',
// //   '🚨  Every report you submit can bring a family back together',
// //   '🤝  Your single sighting can reunite a family — every second counts',
// //   '📍  Real-time alerts for missing persons spotted in your area',
// //   '👮  Trusted by police stations and citizens across the region',
// // ];
// //
// // class _TickerBanner extends StatefulWidget {
// //   const _TickerBanner();
// //   @override State<_TickerBanner> createState() => _TickerBannerState();
// // }
// //
// // class _TickerBannerState extends State<_TickerBanner>
// //     with SingleTickerProviderStateMixin {
// //   late final AnimationController _ctrl;
// //   int _i = 0;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _ctrl = AnimationController(vsync: this,
// //         duration: const Duration(milliseconds: 500))..value = 1;
// //     _cycle();
// //   }
// //
// //   void _cycle() async {
// //     while (mounted) {
// //       await Future.delayed(const Duration(seconds: 4));
// //       if (!mounted) return;
// //       await _ctrl.reverse();
// //       if (!mounted) return;
// //       setState(() => _i = (_i + 1) % _tickers.length);
// //       _ctrl.forward();
// //     }
// //   }
// //
// //   @override void dispose() { _ctrl.dispose(); super.dispose(); }
// //
// //   @override
// //   Widget build(BuildContext context) => Container(
// //     height: 40,
// //     decoration: BoxDecoration(
// //       gradient: LinearGradient(colors: [
// //         _T.accentBlue.withOpacity(0.12), _T.accentPurple.withOpacity(0.10),
// //       ]),
// //       borderRadius: BorderRadius.circular(12),
// //       border: Border.all(color: _T.accentBlue.withOpacity(0.20)),
// //     ),
// //     child: Row(children: [
// //       Container(
// //         width: 40, height: 40,
// //         decoration: BoxDecoration(
// //           gradient: const LinearGradient(colors: [_T.accentBlue, _T.accentPurple]),
// //           borderRadius: BorderRadius.circular(11),
// //         ),
// //         child: const Icon(Icons.campaign_rounded, color: Colors.white, size: 18),
// //       ),
// //       const SizedBox(width: 10),
// //       Expanded(
// //         child: AnimatedBuilder(
// //           animation: _ctrl,
// //           builder: (_, __) => FadeTransition(
// //             opacity: _ctrl,
// //             child: SlideTransition(
// //               position: Tween<Offset>(
// //                   begin: const Offset(0.05, 0), end: Offset.zero).animate(_ctrl),
// //               child: Text(_tickers[_i],
// //                   style: const TextStyle(color: _T.textPrimary,
// //                       fontSize: 11.5, fontWeight: FontWeight.w500),
// //                   overflow: TextOverflow.ellipsis),
// //             ),
// //           ),
// //         ),
// //       ),
// //       const SizedBox(width: 10),
// //     ]),
// //   );
// // }
// //
// // // ─────────────────────────────────────────────────────────────────────────────
// // //  HERO CARD
// // // ─────────────────────────────────────────────────────────────────────────────
// // class _HeroCard extends StatefulWidget {
// //   const _HeroCard();
// //   @override State<_HeroCard> createState() => _HeroCardState();
// // }
// //
// // class _HeroCardState extends State<_HeroCard> with SingleTickerProviderStateMixin {
// //   late final AnimationController _orb;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _orb = AnimationController(vsync: this, duration: const Duration(seconds: 7))
// //       ..repeat();
// //   }
// //
// //   @override void dispose() { _orb.dispose(); super.dispose(); }
// //
// //   @override
// //   Widget build(BuildContext context) => Container(
// //     margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
// //     height: 192,
// //     clipBehavior: Clip.hardEdge,
// //     decoration: BoxDecoration(
// //       borderRadius: BorderRadius.circular(28),
// //       gradient: const LinearGradient(
// //         begin: Alignment.topLeft, end: Alignment.bottomRight,
// //         colors: [Color(0xFF0D2462), Color(0xFF0A1540)],
// //       ),
// //       border: Border.all(color: _T.accentBlue.withOpacity(0.22)),
// //       boxShadow: [BoxShadow(color: _T.accentBlue.withOpacity(0.16),
// //           blurRadius: 36, spreadRadius: -6, offset: const Offset(0, 14))],
// //     ),
// //     child: Stack(children: [
// //       CustomPaint(painter: _GridPainter(), size: Size.infinite),
// //       AnimatedBuilder(animation: _orb,
// //           builder: (_, __) => CustomPaint(painter: _HeroBgOrb(_orb.value), size: Size.infinite)),
// //       Padding(
// //         padding: const EdgeInsets.fromLTRB(22, 20, 16, 20),
// //         child: Row(children: [
// //           Expanded(child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //             children: [
// //               Container(
// //                 padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
// //                 decoration: BoxDecoration(
// //                   color: _T.accentGreen.withOpacity(0.12),
// //                   borderRadius: BorderRadius.circular(20),
// //                   border: Border.all(color: _T.accentGreen.withOpacity(0.38)),
// //                 ),
// //                 child: Row(mainAxisSize: MainAxisSize.min, children: const [
// //                   Icon(Icons.circle, color: _T.accentGreen, size: 7),
// //                   SizedBox(width: 5),
// //                   Text('System Active', style: TextStyle(color: _T.accentGreen,
// //                       fontSize: 10.5, fontWeight: FontWeight.w700)),
// //                 ]),
// //               ),
// //               Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
// //                 ShaderMask(
// //                   shaderCallback: (r) => const LinearGradient(
// //                       colors: [_T.textPrimary, _T.accentCyan]).createShader(r),
// //                   child: const Text('Find the Missing.\nProtect the Community.',
// //                       style: TextStyle(color: Colors.white, fontSize: 19,
// //                           fontWeight: FontWeight.w800, height: 1.30)),
// //                 ),
// //                 const SizedBox(height: 9),
// //                 const Text('CrowdTrace uses crowd intelligence\nto locate missing persons faster.',
// //                     style: TextStyle(color: _T.textSub, fontSize: 11.5, height: 1.55)),
// //               ]),
// //             ],
// //           )),
// //           const SizedBox(width: 8),
// //           SizedBox(
// //             width: 90, height: 148,
// //             child: AnimatedBuilder(animation: _orb,
// //                 builder: (_, __) => CustomPaint(painter: _RadarOrb(_orb.value))),
// //           ),
// //         ]),
// //       ),
// //     ]),
// //   );
// // }
// //
// // // ─────────────────────────────────────────────────────────────────────────────
// // //  LIVE STAT STRIP  — data from dashboard_stats API
// // // ─────────────────────────────────────────────────────────────────────────────
// // class _LiveStatStrip extends StatelessWidget {
// //   final int police, missing, cases;
// //   final bool loaded;
// //   const _LiveStatStrip({required this.police, required this.missing,
// //     required this.cases, required this.loaded});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final items = [
// //       (loaded ? police.toString()  : '—', 'Police Stations',
// //       _T.accentCyan,  Icons.local_police_rounded),
// //       (loaded ? missing.toString() : '—', 'Missing Persons',
// //       _T.accentGold,  Icons.person_search_rounded),
// //       (loaded ? cases.toString()   : '—', 'Cases Resolved',
// //       _T.accentGreen, Icons.check_circle_outline_rounded),
// //     ];
// //     return SizedBox(
// //       height: 90,
// //       child: ListView.separated(
// //         scrollDirection: Axis.horizontal,
// //         padding: const EdgeInsets.symmetric(horizontal: 20),
// //         itemCount: items.length,
// //         separatorBuilder: (_, __) => const SizedBox(width: 12),
// //         itemBuilder: (_, i) {
// //           final it = items[i];
// //           return ClipRRect(
// //             borderRadius: BorderRadius.circular(20),
// //             child: BackdropFilter(
// //               filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
// //               child: Container(
// //                 width: 144,
// //                 padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
// //                 decoration: BoxDecoration(
// //                   borderRadius: BorderRadius.circular(20),
// //                   gradient: LinearGradient(colors: [
// //                     it.$3.withOpacity(0.12), Colors.white.withOpacity(0.02),
// //                   ], begin: Alignment.topLeft, end: Alignment.bottomRight),
// //                   border: Border.all(color: it.$3.withOpacity(0.22)),
// //                 ),
// //                 child: Row(children: [
// //                   Icon(it.$4, color: it.$3, size: 22),
// //                   const SizedBox(width: 10),
// //                   Expanded(child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     mainAxisAlignment: MainAxisAlignment.center,
// //                     children: [
// //                       loaded
// //                           ? Text(it.$1, style: TextStyle(color: it.$3,
// //                           fontSize: 22, fontWeight: FontWeight.w800))
// //                           : SizedBox(width: 36, height: 14,
// //                           child: LinearProgressIndicator(
// //                               color: it.$3.withOpacity(0.5),
// //                               backgroundColor: it.$3.withOpacity(0.10))),
// //                       const SizedBox(height: 2),
// //                       Text(it.$2, style: const TextStyle(
// //                           color: _T.textSub, fontSize: 10.5, height: 1.3)),
// //                     ],
// //                   )),
// //                 ]),
// //               ),
// //             ),
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }
// //
// // // ─────────────────────────────────────────────────────────────────────────────
// // //  QUICK ACTIONS — navigate to correct pages
// // // ─────────────────────────────────────────────────────────────────────────────
// // class _QuickActions extends StatelessWidget {
// //   final void Function(Widget) onPush;
// //   const _QuickActions({required this.onPush});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final cards = [
// //       _QD('Police Stations', Icons.local_police_rounded,
// //           _T.accentBlue, 'Find nearby',
// //               () => onPush(const View_Police_Station(title: 'Police Stations'))),
// //       _QD('Missing Persons', Icons.person_search_rounded,
// //           _T.accentPurple, 'View records',
// //               () => onPush(const ViewStylistsPage(shopId: ''))),
// //       _QD('Criminals', Icons.gavel_rounded,
// //           const Color(0xFFB22234), 'Wanted list',
// //               () => onPush(const ViewCriminalsPage(shopId: ''))),
// //       _QD('Complaint', Icons.assignment_rounded,
// //           _T.accentCyan, 'Send / view',
// //               () => onPush(const ComplaintPage(title: 'My Complaints'))),
// //       _QD('Feedback', Icons.rate_review_rounded,
// //           const Color(0xFF00BFA5), 'Share thoughts',
// //               () => onPush(const FeedbackPage(title: 'My Feedbacks'))),
// //       _QD('My Uploads', Icons.add_photo_alternate_rounded,
// //           _T.accentPurple, 'View detections',
// //               () => onPush(const ViewUploads())),
// //     ];
// //
// //     return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
// //       const Padding(padding: EdgeInsets.symmetric(horizontal: 20),
// //           child: _SecTitle('Quick Actions', 'Tap to navigate')),
// //       const SizedBox(height: 14),
// //       Padding(
// //         padding: const EdgeInsets.symmetric(horizontal: 20),
// //         child: GridView.builder(
// //           shrinkWrap: true,
// //           physics: const NeverScrollableScrollPhysics(),
// //           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
// //             crossAxisCount: 2, childAspectRatio: 1.55,
// //             crossAxisSpacing: 12, mainAxisSpacing: 12,
// //           ),
// //           itemCount: cards.length,
// //           itemBuilder: (_, i) => _QCard(d: cards[i]),
// //         ),
// //       ),
// //     ]);
// //   }
// // }
// //
// // class _QD {
// //   final String label, sub;
// //   final IconData icon;
// //   final Color    color;
// //   final VoidCallback onTap;
// //   const _QD(this.label, this.icon, this.color, this.sub, this.onTap);
// // }
// //
// // class _QCard extends StatefulWidget {
// //   final _QD d;
// //   const _QCard({required this.d});
// //   @override State<_QCard> createState() => _QCardState();
// // }
// //
// // class _QCardState extends State<_QCard> {
// //   bool _p = false;
// //   @override
// //   Widget build(BuildContext context) => GestureDetector(
// //     onTap: widget.d.onTap,
// //     onTapDown: (_) => setState(() => _p = true),
// //     onTapUp:   (_) => setState(() => _p = false),
// //     onTapCancel:() => setState(() => _p = false),
// //     child: AnimatedScale(
// //       scale: _p ? 0.94 : 1.0,
// //       duration: const Duration(milliseconds: 110),
// //       child: ClipRRect(
// //         borderRadius: BorderRadius.circular(18),
// //         child: BackdropFilter(
// //           filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
// //           child: Container(
// //             decoration: BoxDecoration(
// //               borderRadius: BorderRadius.circular(18),
// //               gradient: LinearGradient(
// //                 begin: Alignment.topLeft, end: Alignment.bottomRight,
// //                 colors: [widget.d.color.withOpacity(0.15), Colors.white.withOpacity(0.03)],
// //               ),
// //               border: Border.all(color: widget.d.color.withOpacity(0.26)),
// //               boxShadow: [BoxShadow(color: widget.d.color.withOpacity(0.08),
// //                   blurRadius: 14, offset: const Offset(0, 5))],
// //             ),
// //             padding: const EdgeInsets.all(14),
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //               children: [
// //                 Container(
// //                   width: 36, height: 36,
// //                   decoration: BoxDecoration(
// //                     shape: BoxShape.circle,
// //                     gradient: LinearGradient(
// //                         colors: [widget.d.color, widget.d.color.withOpacity(0.55)]),
// //                   ),
// //                   child: Icon(widget.d.icon, color: Colors.white, size: 18),
// //                 ),
// //                 Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
// //                   Text(widget.d.label, style: const TextStyle(
// //                       color: _T.textPrimary, fontSize: 13, fontWeight: FontWeight.w700)),
// //                   Text(widget.d.sub, style: const TextStyle(color: _T.textSub, fontSize: 10)),
// //                 ]),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     ),
// //   );
// // }
// //
// // // ═══════════════════════════════════════════════════════════════════════════════
// // //  PERSON CAROUSEL SECTION — Missing + Criminals with REAL images
// // // ═══════════════════════════════════════════════════════════════════════════════
// // class _PersonCarouselSection extends StatefulWidget {
// //   final List<_PersonRecord> missingList, criminalList;
// //   final bool dataLoaded;
// //   const _PersonCarouselSection({
// //     required this.missingList, required this.criminalList,
// //     required this.dataLoaded,
// //   });
// //   @override State<_PersonCarouselSection> createState() => _PersonCarouselSectionState();
// // }
// //
// // class _PersonCarouselSectionState extends State<_PersonCarouselSection>
// //     with SingleTickerProviderStateMixin {
// //   bool _showMissing = true;
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final list    = _showMissing ? widget.missingList : widget.criminalList;
// //     final accent  = _showMissing ? _T.accentGold      : _T.accentRed;
// //     final label   = _showMissing ? 'Currently Missing' : 'Wanted Criminals';
// //     final sublabel = _showMissing ? 'Help bring them home' : 'Reported active cases';
// //
// //     return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
// //       // Toggle
// //       Padding(
// //         padding: const EdgeInsets.symmetric(horizontal: 20),
// //         child: Container(
// //           decoration: BoxDecoration(
// //             color: _T.surface,
// //             borderRadius: BorderRadius.circular(16),
// //             border: Border.all(color: _T.glassBorder),
// //           ),
// //           child: Row(children: [
// //             _TabBtn(label: 'Missing', count: widget.missingList.length,
// //                 active: _showMissing, color: _T.accentGold,
// //                 onTap: () => setState(() => _showMissing = true)),
// //             _TabBtn(label: 'Wanted', count: widget.criminalList.length,
// //                 active: !_showMissing, color: _T.accentRed,
// //                 onTap: () => setState(() => _showMissing = false)),
// //           ]),
// //         ),
// //       ),
// //       const SizedBox(height: 16),
// //
// //       // Header
// //       Padding(
// //         padding: const EdgeInsets.symmetric(horizontal: 20),
// //         child: Row(children: [
// //           _SecTitle(label, sublabel),
// //           const Spacer(),
// //           if (!widget.dataLoaded)
// //             const SizedBox(width: 16, height: 16,
// //                 child: CircularProgressIndicator(strokeWidth: 2, color: _T.accentCyan))
// //           else if (list.isNotEmpty)
// //             Container(
// //               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
// //               decoration: BoxDecoration(
// //                 color: accent.withOpacity(0.12),
// //                 borderRadius: BorderRadius.circular(20),
// //                 border: Border.all(color: accent.withOpacity(0.30)),
// //               ),
// //               child: Row(mainAxisSize: MainAxisSize.min, children: [
// //                 Icon(Icons.circle, color: accent, size: 6),
// //                 const SizedBox(width: 4),
// //                 Text('${list.length} Active',
// //                     style: TextStyle(color: accent,
// //                         fontSize: 10.5, fontWeight: FontWeight.w700)),
// //               ]),
// //             ),
// //         ]),
// //       ),
// //       const SizedBox(height: 12),
// //
// //       // Carousel
// //       AnimatedSwitcher(
// //         duration: const Duration(milliseconds: 300),
// //         child: KeyedSubtree(
// //           key: ValueKey(_showMissing),
// //           child: !widget.dataLoaded
// //               ? const SizedBox(height: 230, child: Center(
// //               child: CircularProgressIndicator(strokeWidth: 2.5, color: _T.accentCyan)))
// //               : list.isEmpty
// //               ? const SizedBox(height: 80, child: Center(
// //               child: Text('No records found.',
// //                   style: TextStyle(color: _T.textSub))))
// //               : _PersonPageView(list: list, accent: accent,
// //               isMissing: _showMissing),
// //         ),
// //       ),
// //     ]);
// //   }
// // }
// //
// // class _TabBtn extends StatelessWidget {
// //   final String label;
// //   final int    count;
// //   final bool   active;
// //   final Color  color;
// //   final VoidCallback onTap;
// //   const _TabBtn({required this.label, required this.count, required this.active,
// //     required this.color, required this.onTap});
// //
// //   @override
// //   Widget build(BuildContext context) => Expanded(
// //     child: GestureDetector(
// //       onTap: onTap,
// //       child: AnimatedContainer(
// //         duration: const Duration(milliseconds: 200),
// //         padding: const EdgeInsets.symmetric(vertical: 10),
// //         decoration: BoxDecoration(
// //           gradient: active ? LinearGradient(colors: [color.withOpacity(0.20), color.withOpacity(0.08)]) : null,
// //           borderRadius: BorderRadius.circular(14),
// //           border: active ? Border.all(color: color.withOpacity(0.35)) : null,
// //         ),
// //         child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
// //           Text(label, style: TextStyle(
// //               color: active ? color : _T.textSub,
// //               fontSize: 13, fontWeight: FontWeight.w700)),
// //           const SizedBox(width: 6),
// //           Container(
// //             padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
// //             decoration: BoxDecoration(
// //               color: active ? color.withOpacity(0.20) : _T.glassBorder,
// //               borderRadius: BorderRadius.circular(8),
// //             ),
// //             child: Text('$count', style: TextStyle(
// //                 color: active ? color : _T.textSub,
// //                 fontSize: 10, fontWeight: FontWeight.w800)),
// //           ),
// //         ]),
// //       ),
// //     ),
// //   );
// // }
// //
// // // ── PageView with properly loaded network images ──────────────────────────────
// // class _PersonPageView extends StatefulWidget {
// //   final List<_PersonRecord> list;
// //   final Color  accent;
// //   final bool   isMissing;
// //   const _PersonPageView({required this.list, required this.accent, required this.isMissing});
// //   @override State<_PersonPageView> createState() => _PersonPageViewState();
// // }
// //
// // class _PersonPageViewState extends State<_PersonPageView> {
// //   late final PageController _pc;
// //   int _cur = 0;
// //   bool _running = true;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _pc = PageController(viewportFraction: 0.58);
// //     _startAuto();
// //   }
// //
// //   @override
// //   void dispose() {
// //     _running = false;
// //     _pc.dispose();
// //     super.dispose();
// //   }
// //
// //   Future<void> _startAuto() async {
// //     while (_running) {
// //       await Future.delayed(const Duration(seconds: 3));
// //       if (!mounted || !_running || widget.list.isEmpty) { break; }
// //       final next = (_cur + 1) % widget.list.length;
// //       if (mounted) {
// //         setState(() => _cur = next);
// //         if (_pc.hasClients) {
// //           _pc.animateToPage(
// //             next,
// //             duration: const Duration(milliseconds: 600),
// //             curve: Curves.easeInOutCubic,
// //           );
// //         }
// //       }
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Column(children: [
// //       SizedBox(
// //         height: 240,
// //         child: PageView.builder(
// //           controller: _pc,
// //           onPageChanged: (i) => setState(() => _cur = i),
// //           itemCount: widget.list.length,
// //           itemBuilder: (_, i) => AnimatedScale(
// //             scale: i == _cur ? 1.0 : 0.86,
// //             duration: const Duration(milliseconds: 400),
// //             curve: Curves.easeOutCubic,
// //             child: _PersonCard(
// //                 person: widget.list[i],
// //                 isActive: i == _cur,
// //                 accent: widget.accent,
// //                 isMissing: widget.isMissing),
// //           ),
// //         ),
// //       ),
// //       const SizedBox(height: 12),
// //       // Dot indicator
// //       Row(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: List.generate(widget.list.length, (i) => GestureDetector(
// //           onTap: () {
// //             setState(() => _cur = i);
// //             _pc.animateToPage(i,
// //                 duration: const Duration(milliseconds: 400),
// //                 curve: Curves.easeInOutCubic);
// //           },
// //           child: AnimatedContainer(
// //             duration: const Duration(milliseconds: 300),
// //             margin: const EdgeInsets.symmetric(horizontal: 3),
// //             width: i == _cur ? 22 : 6, height: 6,
// //             decoration: BoxDecoration(
// //               borderRadius: BorderRadius.circular(3),
// //               gradient: i == _cur ? LinearGradient(
// //                   colors: [widget.accent, _T.accentBlue]) : null,
// //               color: i == _cur ? null : _T.textSub.withOpacity(0.22),
// //             ),
// //           ),
// //         )),
// //       ),
// //     ]);
// //   }
// // }
// //
// // // ── Person Card — REAL network image with proper loading ───────────────────
// // class _PersonCard extends StatefulWidget {
// //   final _PersonRecord person;
// //   final bool   isActive, isMissing;
// //   final Color  accent;
// //   const _PersonCard({required this.person, required this.isActive,
// //     required this.accent, required this.isMissing});
// //   @override State<_PersonCard> createState() => _PersonCardState();
// // }
// //
// // class _PersonCardState extends State<_PersonCard>
// //     with SingleTickerProviderStateMixin {
// //   late final AnimationController _spin;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _spin = AnimationController(vsync: this,
// //         duration: const Duration(seconds: 3))..repeat();
// //   }
// //   @override void dispose() { _spin.dispose(); super.dispose(); }
// //
// //   @override
// //   Widget build(BuildContext context) => Container(
// //     margin: const EdgeInsets.symmetric(horizontal: 6),
// //     decoration: BoxDecoration(
// //       borderRadius: BorderRadius.circular(26),
// //       gradient: LinearGradient(
// //         begin: Alignment.topLeft, end: Alignment.bottomRight,
// //         colors: [
// //           widget.accent.withOpacity(widget.isActive ? 0.16 : 0.05),
// //           _T.card.withOpacity(widget.isActive ? 1.0 : 0.6),
// //         ],
// //       ),
// //       border: Border.all(
// //         color: widget.isActive ? widget.accent.withOpacity(0.42) : _T.glassBorder,
// //         width: widget.isActive ? 1.6 : 0.8,
// //       ),
// //       boxShadow: widget.isActive ? [BoxShadow(color: widget.accent.withOpacity(0.20),
// //           blurRadius: 24, offset: const Offset(0, 8))] : [],
// //     ),
// //     child: ClipRRect(
// //       borderRadius: BorderRadius.circular(26),
// //       child: BackdropFilter(
// //         filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
// //         child: Padding(
// //           padding: const EdgeInsets.all(16),
// //           child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
// //             // Photo with spinning arc
// //             AnimatedBuilder(
// //               animation: _spin,
// //               builder: (_, child) => CustomPaint(
// //                 painter: _SpinArc(_spin.value, widget.isActive, widget.accent),
// //                 child: child,
// //               ),
// //               child: Container(
// //                 width: 90, height: 90,
// //                 margin: const EdgeInsets.all(5),
// //                 decoration: BoxDecoration(
// //                   shape: BoxShape.circle,
// //                   border: Border.all(
// //                       color: widget.isActive
// //                           ? widget.accent.withOpacity(0.50) : _T.glassBorder,
// //                       width: 2),
// //                 ),
// //                 child: ClipOval(
// //                   child: _NetImage(url: widget.person.photoUrl, size: 90),
// //                 ),
// //               ),
// //             ),
// //
// //             const SizedBox(height: 10),
// //
// //             // Status badge
// //             if (widget.isActive)
// //               Container(
// //                 padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
// //                 decoration: BoxDecoration(
// //                   color: widget.accent.withOpacity(0.12),
// //                   borderRadius: BorderRadius.circular(20),
// //                   border: Border.all(color: widget.accent.withOpacity(0.34)),
// //                 ),
// //                 child: Row(mainAxisSize: MainAxisSize.min, children: [
// //                   Icon(Icons.circle, color: widget.accent, size: 5),
// //                   const SizedBox(width: 4),
// //                   Text(widget.isMissing ? 'MISSING' : 'WANTED',
// //                       style: TextStyle(color: widget.accent,
// //                           fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: 1.3)),
// //                 ]),
// //               ),
// //
// //             const SizedBox(height: 8),
// //             Text(widget.person.name,
// //                 style: const TextStyle(color: _T.textPrimary,
// //                     fontSize: 13.5, fontWeight: FontWeight.w700),
// //                 textAlign: TextAlign.center, overflow: TextOverflow.ellipsis),
// //             const SizedBox(height: 2),
// //             Text('Age: ${widget.person.age}',
// //                 style: const TextStyle(color: _T.textMid, fontSize: 11)),
// //             const SizedBox(height: 2),
// //             Text(widget.person.gender,
// //                 style: const TextStyle(color: _T.textSub, fontSize: 10),
// //                 textAlign: TextAlign.center, overflow: TextOverflow.ellipsis),
// //           ]),
// //         ),
// //       ),
// //     ),
// //   );
// // }
// //
// // // ── Network image widget — handles loading, error, placeholder properly ──────
// // class _NetImage extends StatelessWidget {
// //   final String url;
// //   final double size;
// //   const _NetImage({required this.url, required this.size});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     if (url.isEmpty) {
// //       return _placeholder();
// //     }
// //     return Image.network(
// //       url,
// //       width: size, height: size,
// //       fit: BoxFit.cover,
// //       loadingBuilder: (_, child, progress) {
// //         if (progress == null) return child; // fully loaded
// //         return Container(
// //           width: size, height: size,
// //           color: _T.glass,
// //           child: Center(
// //             child: SizedBox(
// //               width: 22, height: 22,
// //               child: CircularProgressIndicator(
// //                 strokeWidth: 2,
// //                 color: _T.accentCyan,
// //                 value: progress.expectedTotalBytes != null
// //                     ? progress.cumulativeBytesLoaded / progress.expectedTotalBytes!
// //                     : null,
// //               ),
// //             ),
// //           ),
// //         );
// //       },
// //       errorBuilder: (_, __, ___) => _placeholder(),
// //     );
// //   }
// //
// //   Widget _placeholder() => Container(
// //     width: size, height: size, color: _T.glass,
// //     child: const Icon(Icons.person_rounded, color: _T.textSub, size: 36),
// //   );
// // }
// //
// // // ═══════════════════════════════════════════════════════════════════════════════
// // //  MY CASES SECTION — from user_view_cases API
// // // ═══════════════════════════════════════════════════════════════════════════════
// // class _MyCasesSection extends StatelessWidget {
// //   final List<_CaseRecord>    cases;
// //   final bool                 dataLoaded;
// //   final void Function(Widget) onPush;
// //   const _MyCasesSection({required this.cases, required this.dataLoaded, required this.onPush});
// //
// //   Color _progressColor(String p) {
// //     final lp = p.toLowerCase();
// //     if (lp == 'resolved' || lp == 'completed') return _T.accentGreen;
// //     if (lp == 'investigating' || lp == 'in progress') return _T.accentGold;
// //     return _T.accentBlue;
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Padding(
// //       padding: const EdgeInsets.symmetric(horizontal: 20),
// //       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
// //         Row(children: [
// //           const _SecTitle('My Reported Cases', 'Track your submissions'),
// //           const Spacer(),
// //           GestureDetector(
// //             onTap: () => onPush(const ViewCasesPage()),
// //             child: Container(
// //               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
// //               decoration: BoxDecoration(
// //                 color: _T.accentBlue.withOpacity(0.10),
// //                 borderRadius: BorderRadius.circular(10),
// //                 border: Border.all(color: _T.accentBlue.withOpacity(0.25)),
// //               ),
// //               child: const Text('View All', style: TextStyle(
// //                   color: _T.accentCyan, fontSize: 11, fontWeight: FontWeight.w700)),
// //             ),
// //           ),
// //         ]),
// //         const SizedBox(height: 14),
// //
// //         if (!dataLoaded)
// //           const _ShimmerList()
// //         else if (cases.isEmpty)
// //           _EmptyState(
// //             icon: Icons.assignment_outlined,
// //             message: 'No cases filed yet',
// //             sub: 'Use Report Case to submit a new case',
// //             accent: _T.accentBlue,
// //           )
// //         else
// //           ...cases.take(3).map((c) {
// //             final col = _progressColor(c.progress);
// //             return Container(
// //               margin: const EdgeInsets.only(bottom: 10),
// //               padding: const EdgeInsets.all(14),
// //               decoration: BoxDecoration(
// //                 borderRadius: BorderRadius.circular(16),
// //                 gradient: LinearGradient(colors: [
// //                   col.withOpacity(0.08), _T.card,
// //                 ], begin: Alignment.topLeft, end: Alignment.bottomRight),
// //                 border: Border.all(color: col.withOpacity(0.22)),
// //               ),
// //               child: Row(children: [
// //                 // Photo thumbnail
// //                 ClipRRect(
// //                   borderRadius: BorderRadius.circular(10),
// //                   child: SizedBox(
// //                     width: 44, height: 44,
// //                     child: c.photoUrl.isNotEmpty
// //                         ? _NetImage(url: c.photoUrl, size: 44)
// //                         : Container(color: col.withOpacity(0.15),
// //                         child: Icon(Icons.report_problem_outlined, color: col, size: 22)),
// //                   ),
// //                 ),
// //                 const SizedBox(width: 12),
// //                 Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
// //                   Row(children: [
// //                     Expanded(child: Text(c.description,
// //                         style: const TextStyle(color: _T.textPrimary,
// //                             fontSize: 12.5, fontWeight: FontWeight.w600),
// //                         overflow: TextOverflow.ellipsis, maxLines: 1)),
// //                     Container(
// //                       padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
// //                       decoration: BoxDecoration(
// //                         color: col.withOpacity(0.12),
// //                         borderRadius: BorderRadius.circular(6),
// //                         border: Border.all(color: col.withOpacity(0.28)),
// //                       ),
// //                       child: Text(c.status,
// //                           style: TextStyle(color: col, fontSize: 9, fontWeight: FontWeight.w800)),
// //                     ),
// //                   ]),
// //                   const SizedBox(height: 4),
// //                   Text('${c.station}  ·  ${c.date}',
// //                       style: const TextStyle(color: _T.textSub, fontSize: 10)),
// //                   const SizedBox(height: 6),
// //                   Row(children: [
// //                     Expanded(child: ClipRRect(
// //                       borderRadius: BorderRadius.circular(4),
// //                       child: LinearProgressIndicator(
// //                         value: c.progress.toLowerCase() == 'resolved' ? 1.0
// //                             : c.progress.toLowerCase() == 'investigating' ? 0.55
// //                             : 0.20,
// //                         minHeight: 4,
// //                         backgroundColor: col.withOpacity(0.12),
// //                         valueColor: AlwaysStoppedAnimation<Color>(col),
// //                       ),
// //                     )),
// //                     const SizedBox(width: 8),
// //                     Text(c.progress,
// //                         style: TextStyle(color: col, fontSize: 9, fontWeight: FontWeight.w700)),
// //                   ]),
// //                 ])),
// //               ]),
// //             );
// //           }),
// //       ]),
// //     );
// //   }
// // }
// //
// // // ═══════════════════════════════════════════════════════════════════════════════
// // //  MY DETECTIONS SECTION — from user_view_detections API
// // // ═══════════════════════════════════════════════════════════════════════════════
// // class _MyDetectionsSection extends StatelessWidget {
// //   final List<_Detection>     detections;
// //   final bool                 dataLoaded;
// //   final void Function(Widget) onPush;
// //   const _MyDetectionsSection({required this.detections, required this.dataLoaded, required this.onPush});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Padding(
// //       padding: const EdgeInsets.symmetric(horizontal: 20),
// //       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
// //         Row(children: [
// //           const _SecTitle('My Detections', 'Matches from your uploads'),
// //           const Spacer(),
// //           GestureDetector(
// //             onTap: () => onPush(const ViewUploads()),
// //             child: Container(
// //               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
// //               decoration: BoxDecoration(
// //                 color: _T.accentPurple.withOpacity(0.10),
// //                 borderRadius: BorderRadius.circular(10),
// //                 border: Border.all(color: _T.accentPurple.withOpacity(0.25)),
// //               ),
// //               child: const Text('View All', style: TextStyle(
// //                   color: _T.accentPurple, fontSize: 11, fontWeight: FontWeight.w700)),
// //             ),
// //           ),
// //         ]),
// //         const SizedBox(height: 14),
// //
// //         if (!dataLoaded)
// //           const _ShimmerList()
// //         else if (detections.isEmpty)
// //           _EmptyState(
// //             icon: Icons.image_search_outlined,
// //             message: 'No detections yet',
// //             sub: 'Upload a photo to check for matches',
// //             accent: _T.accentPurple,
// //           )
// //         else
// //           SizedBox(
// //             height: 120,
// //             child: ListView.separated(
// //               scrollDirection: Axis.horizontal,
// //               itemCount: detections.take(6).length,
// //               separatorBuilder: (_, __) => const SizedBox(width: 10),
// //               itemBuilder: (_, i) {
// //                 final d = detections[i];
// //                 final isMissing = d.category.toLowerCase().contains('missing');
// //                 final accent = isMissing ? _T.accentGold : _T.accentRed;
// //                 return Container(
// //                   width: 130,
// //                   padding: const EdgeInsets.all(10),
// //                   decoration: BoxDecoration(
// //                     borderRadius: BorderRadius.circular(16),
// //                     gradient: LinearGradient(colors: [
// //                       accent.withOpacity(0.12), _T.card,
// //                     ]),
// //                     border: Border.all(color: accent.withOpacity(0.25)),
// //                   ),
// //                   child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
// //                     Row(children: [
// //                       ClipRRect(
// //                         borderRadius: BorderRadius.circular(8),
// //                         child: SizedBox(
// //                             width: 36, height: 36,
// //                             child: _NetImage(url: d.photoUrl, size: 36)),
// //                       ),
// //                       const Spacer(),
// //                       Container(
// //                         padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
// //                         decoration: BoxDecoration(
// //                           color: accent.withOpacity(0.12),
// //                           borderRadius: BorderRadius.circular(6),
// //                         ),
// //                         child: Icon(
// //                           isMissing ? Icons.person_search_rounded : Icons.gavel_rounded,
// //                           color: accent, size: 12,
// //                         ),
// //                       ),
// //                     ]),
// //                     const SizedBox(height: 8),
// //                     Text(d.name.isEmpty ? 'Unknown' : d.name,
// //                         style: const TextStyle(color: _T.textPrimary,
// //                             fontSize: 11.5, fontWeight: FontWeight.w700),
// //                         overflow: TextOverflow.ellipsis),
// //                     const SizedBox(height: 2),
// //                     Text(d.category,
// //                         style: TextStyle(color: accent, fontSize: 9.5, fontWeight: FontWeight.w600)),
// //                     const SizedBox(height: 2),
// //                     Text(d.date,
// //                         style: const TextStyle(color: _T.textSub, fontSize: 9)),
// //                   ]),
// //                 );
// //               },
// //             ),
// //           ),
// //       ]),
// //     );
// //   }
// // }
// //
// // // ═══════════════════════════════════════════════════════════════════════════════
// // //  MY COMPLAINTS SECTION — from user_view_complaints API
// // // ═══════════════════════════════════════════════════════════════════════════════
// // class _MyComplaintsSection extends StatelessWidget {
// //   final List<_ComplaintRecord> complaints;
// //   final bool                   dataLoaded;
// //   final void Function(Widget)  onPush;
// //   const _MyComplaintsSection({required this.complaints, required this.dataLoaded, required this.onPush});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Padding(
// //       padding: const EdgeInsets.symmetric(horizontal: 20),
// //       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
// //         Row(children: [
// //           const _SecTitle('My Complaints', 'Status of your submissions'),
// //           const Spacer(),
// //           GestureDetector(
// //             onTap: () => onPush(const ComplaintPage(title: 'My Complaints')),
// //             child: Container(
// //               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
// //               decoration: BoxDecoration(
// //                 color: _T.accentCyan.withOpacity(0.10),
// //                 borderRadius: BorderRadius.circular(10),
// //                 border: Border.all(color: _T.accentCyan.withOpacity(0.25)),
// //               ),
// //               child: const Text('View All', style: TextStyle(
// //                   color: _T.accentCyan, fontSize: 11, fontWeight: FontWeight.w700)),
// //             ),
// //           ),
// //         ]),
// //         const SizedBox(height: 14),
// //
// //         if (!dataLoaded)
// //           const _ShimmerList()
// //         else if (complaints.isEmpty)
// //           _EmptyState(
// //             icon: Icons.assignment_outlined,
// //             message: 'No complaints filed',
// //             sub: 'Tap "Complaint" in Quick Actions to send one',
// //             accent: _T.accentCyan,
// //           )
// //         else
// //           ...complaints.take(3).map((c) {
// //             final replied  = c.reply.toLowerCase() != 'pending';
// //             final accent   = replied ? _T.accentGreen : _T.accentGold;
// //             return Container(
// //               margin: const EdgeInsets.only(bottom: 10),
// //               padding: const EdgeInsets.all(14),
// //               decoration: BoxDecoration(
// //                 borderRadius: BorderRadius.circular(16),
// //                 color: _T.card,
// //                 border: Border.all(color: accent.withOpacity(0.20)),
// //               ),
// //               child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
// //                 Row(children: [
// //                   Expanded(child: Text(c.description,
// //                       style: const TextStyle(color: _T.textPrimary,
// //                           fontSize: 12.5, fontWeight: FontWeight.w600),
// //                       overflow: TextOverflow.ellipsis, maxLines: 1)),
// //                   const SizedBox(width: 8),
// //                   Container(
// //                     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
// //                     decoration: BoxDecoration(
// //                       color: accent.withOpacity(0.12),
// //                       borderRadius: BorderRadius.circular(8),
// //                       border: Border.all(color: accent.withOpacity(0.28)),
// //                     ),
// //                     child: Row(mainAxisSize: MainAxisSize.min, children: [
// //                       Icon(replied ? Icons.check_circle_outline_rounded : Icons.hourglass_empty_rounded,
// //                           color: accent, size: 10),
// //                       const SizedBox(width: 3),
// //                       Text(replied ? 'Replied' : 'Pending',
// //                           style: TextStyle(color: accent,
// //                               fontSize: 9, fontWeight: FontWeight.w800)),
// //                     ]),
// //                   ),
// //                 ]),
// //                 if (replied) ...[
// //                   const SizedBox(height: 8),
// //                   Container(
// //                     padding: const EdgeInsets.all(10),
// //                     decoration: BoxDecoration(
// //                       color: _T.accentGreen.withOpacity(0.06),
// //                       borderRadius: BorderRadius.circular(10),
// //                       border: Border.all(color: _T.accentGreen.withOpacity(0.15)),
// //                     ),
// //                     child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
// //                       const Icon(Icons.reply_rounded, color: _T.accentGreen, size: 14),
// //                       const SizedBox(width: 6),
// //                       Expanded(child: Text(c.reply,
// //                           style: const TextStyle(color: _T.textMid,
// //                               fontSize: 11.5, height: 1.4))),
// //                     ]),
// //                   ),
// //                 ],
// //                 const SizedBox(height: 6),
// //                 Text(c.date, style: const TextStyle(color: _T.textSub, fontSize: 10)),
// //               ]),
// //             );
// //           }),
// //       ]),
// //     );
// //   }
// // }
// //
// // // ─────────────────────────────────────────────────────────────────────────────
// // //  HOW IT WORKS
// // // ─────────────────────────────────────────────────────────────────────────────
// // class _HowItWorks extends StatelessWidget {
// //   const _HowItWorks();
// //   @override
// //   Widget build(BuildContext context) {
// //     final steps = [
// //       ('01', 'Spot & Snap',  'See someone? Capture a clear photo.',
// //       Icons.camera_alt_rounded,              _T.accentCyan),
// //       ('02', 'Upload & Tag', 'Upload via + with location details.',
// //       Icons.upload_rounded,                  _T.accentBlue),
// //       ('03', 'Alert Sent',   'Police & citizens get instant alerts.',
// //       Icons.notifications_active_rounded,    _T.accentPurple),
// //       ('04', 'Reunited',     'Leads converge — families reunited.',
// //       Icons.favorite_rounded,                _T.accentGold),
// //     ];
// //     return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
// //       const Padding(padding: EdgeInsets.symmetric(horizontal: 20),
// //           child: _SecTitle('How It Works', 'Simple steps, real impact')),
// //       const SizedBox(height: 14),
// //       SizedBox(
// //         height: 155,
// //         child: ListView.separated(
// //           scrollDirection: Axis.horizontal,
// //           padding: const EdgeInsets.symmetric(horizontal: 20),
// //           itemCount: steps.length,
// //           separatorBuilder: (_, __) => const SizedBox(width: 12),
// //           itemBuilder: (_, i) {
// //             final s = steps[i];
// //             return ClipRRect(
// //               borderRadius: BorderRadius.circular(20),
// //               child: BackdropFilter(
// //                 filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
// //                 child: Container(
// //                   width: 148,
// //                   padding: const EdgeInsets.all(14),
// //                   decoration: BoxDecoration(
// //                     borderRadius: BorderRadius.circular(20),
// //                     gradient: LinearGradient(colors: [
// //                       s.$5.withOpacity(0.11), Colors.white.withOpacity(0.02),
// //                     ], begin: Alignment.topLeft, end: Alignment.bottomRight),
// //                     border: Border.all(color: s.$5.withOpacity(0.20)),
// //                   ),
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                     children: [
// //                       Row(children: [
// //                         Container(width: 32, height: 32,
// //                             decoration: BoxDecoration(shape: BoxShape.circle,
// //                                 color: s.$5.withOpacity(0.14)),
// //                             child: Icon(s.$4, color: s.$5, size: 15)),
// //                         const Spacer(),
// //                         Text(s.$1, style: TextStyle(color: s.$5.withOpacity(0.28),
// //                             fontSize: 22, fontWeight: FontWeight.w900)),
// //                       ]),
// //                       Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
// //                         Text(s.$2, style: const TextStyle(color: _T.textPrimary,
// //                             fontSize: 12.5, fontWeight: FontWeight.w700)),
// //                         const SizedBox(height: 4),
// //                         Text(s.$3, style: const TextStyle(color: _T.textSub,
// //                             fontSize: 10.5, height: 1.45)),
// //                       ]),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //             );
// //           },
// //         ),
// //       ),
// //     ]);
// //   }
// // }
// //
// // // ═══════════════════════════════════════════════════════════════════════════════
// // //  REPORTS TAB
// // // ═══════════════════════════════════════════════════════════════════════════════
// // class _ReportsTab extends StatelessWidget {
// //   const _ReportsTab();
// //
// //   @override
// //   Widget build(BuildContext context) => SingleChildScrollView(
// //     physics: const BouncingScrollPhysics(),
// //     padding: const EdgeInsets.fromLTRB(20, 28, 20, 120),
// //     child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
// //       const _SecTitle('Reports', 'Submit & track your reports'),
// //       const SizedBox(height: 28),
// //       _RTile(
// //         icon: Icons.assignment_rounded,
// //         title: 'My Complaints',
// //         sub: 'Submit a complaint or track its status',
// //         color: _T.accentBlue,
// //         onTap: () => Navigator.push(context,
// //             _slideRoute(const ComplaintPage(title: 'My Complaints'))),
// //       ),
// //       const SizedBox(height: 14),
// //       _RTile(
// //         icon: Icons.report_problem_rounded,
// //         title: 'Report Case',
// //         sub: 'Report a missing person or suspicious case',
// //         color: _T.accentRed,
// //         onTap: () => Navigator.push(context, _slideRoute(const ReportCasePage())),
// //       ),
// //       const SizedBox(height: 14),
// //       _RTile(
// //         icon: Icons.rate_review_rounded,
// //         title: 'My Feedback',
// //         sub: 'Share your experience or suggestions',
// //         color: _T.accentPurple,
// //         onTap: () => Navigator.push(context,
// //             _slideRoute(const FeedbackPage(title: 'My Feedbacks'))),
// //       ),
// //       const SizedBox(height: 14),
// //       _RTile(
// //         icon: Icons.image_search_rounded,
// //         title: 'My Uploads',
// //         sub: 'View all your submitted detections',
// //         color: _T.accentCyan,
// //         onTap: () => Navigator.push(context, _slideRoute(const ViewUploads())),
// //       ),
// //     ]),
// //   );
// // }
// //
// // class _RTile extends StatefulWidget {
// //   final IconData icon;
// //   final String   title, sub;
// //   final Color    color;
// //   final VoidCallback onTap;
// //   const _RTile({required this.icon, required this.title, required this.sub,
// //     required this.color, required this.onTap});
// //   @override State<_RTile> createState() => _RTileState();
// // }
// //
// // class _RTileState extends State<_RTile> {
// //   bool _p = false;
// //   @override
// //   Widget build(BuildContext context) => GestureDetector(
// //     onTap: widget.onTap,
// //     onTapDown: (_) => setState(() => _p = true),
// //     onTapUp:   (_) => setState(() => _p = false),
// //     onTapCancel:() => setState(() => _p = false),
// //     child: AnimatedScale(
// //       scale: _p ? 0.97 : 1.0,
// //       duration: const Duration(milliseconds: 100),
// //       child: ClipRRect(
// //         borderRadius: BorderRadius.circular(18),
// //         child: BackdropFilter(
// //           filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
// //           child: Container(
// //             padding: const EdgeInsets.all(18),
// //             decoration: BoxDecoration(
// //               gradient: LinearGradient(colors: [
// //                 widget.color.withOpacity(0.12), Colors.white.withOpacity(0.03),
// //               ], begin: Alignment.topLeft, end: Alignment.bottomRight),
// //               borderRadius: BorderRadius.circular(18),
// //               border: Border.all(color: widget.color.withOpacity(0.28)),
// //             ),
// //             child: Row(children: [
// //               Container(width: 46, height: 46,
// //                   decoration: BoxDecoration(shape: BoxShape.circle,
// //                       gradient: LinearGradient(
// //                           colors: [widget.color, widget.color.withOpacity(0.6)])),
// //                   child: Icon(widget.icon, color: Colors.white, size: 22)),
// //               const SizedBox(width: 16),
// //               Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
// //                 Text(widget.title, style: const TextStyle(color: _T.textPrimary,
// //                     fontSize: 15, fontWeight: FontWeight.w700)),
// //                 const SizedBox(height: 3),
// //                 Text(widget.sub, style: const TextStyle(color: _T.textSub, fontSize: 12)),
// //               ])),
// //               Icon(Icons.arrow_forward_ios_rounded,
// //                   color: widget.color.withOpacity(0.6), size: 15),
// //             ]),
// //           ),
// //         ),
// //       ),
// //     ),
// //   );
// // }
// //
// // // ═══════════════════════════════════════════════════════════════════════════════
// // //  MISSING DIALOG
// // // ═══════════════════════════════════════════════════════════════════════════════
// // class _MissingDialog extends StatelessWidget {
// //   final VoidCallback onMissing, onCriminal;
// //   const _MissingDialog({required this.onMissing, required this.onCriminal});
// //
// //   @override
// //   Widget build(BuildContext context) => Center(
// //     child: Material(
// //       color: Colors.transparent,
// //       child: ClipRRect(
// //         borderRadius: BorderRadius.circular(30),
// //         child: BackdropFilter(
// //           filter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
// //           child: Container(
// //             width: MediaQuery.of(context).size.width * 0.85,
// //             padding: const EdgeInsets.all(26),
// //             decoration: BoxDecoration(
// //               color: const Color(0xFF080F26).withOpacity(0.97),
// //               borderRadius: BorderRadius.circular(30),
// //               border: Border.all(color: _T.glassBorder),
// //               boxShadow: [BoxShadow(color: _T.accentBlue.withOpacity(0.18),
// //                   blurRadius: 44, spreadRadius: -8)],
// //             ),
// //             child: Column(mainAxisSize: MainAxisSize.min, children: [
// //               Container(width: 38, height: 4,
// //                   decoration: BoxDecoration(
// //                       color: _T.textSub.withOpacity(0.4),
// //                       borderRadius: BorderRadius.circular(2))),
// //               const SizedBox(height: 20),
// //               ShaderMask(
// //                 shaderCallback: (r) => const LinearGradient(
// //                     colors: [_T.textPrimary, _T.accentCyan]).createShader(r),
// //                 child: const Text('Browse Records', style: TextStyle(
// //                     color: Colors.white, fontSize: 21, fontWeight: FontWeight.w800)),
// //               ),
// //               const SizedBox(height: 5),
// //               const Text('Select a category',
// //                   style: TextStyle(color: _T.textSub, fontSize: 13)),
// //               const SizedBox(height: 22),
// //               _DlgTile(icon: Icons.person_search_rounded,
// //                   title: 'Missing Persons',
// //                   sub: 'Browse active missing persons database',
// //                   color: _T.accentBlue, onTap: onMissing),
// //               const SizedBox(height: 12),
// //               _DlgTile(icon: Icons.gavel_rounded,
// //                   title: 'Criminal Cases',
// //                   sub: 'View criminal records & case files',
// //                   color: _T.accentPurple, onTap: onCriminal),
// //             ]),
// //           ),
// //         ),
// //       ),
// //     ),
// //   );
// // }
// //
// // class _DlgTile extends StatefulWidget {
// //   final IconData icon;
// //   final String   title, sub;
// //   final Color    color;
// //   final VoidCallback onTap;
// //   const _DlgTile({required this.icon, required this.title, required this.sub,
// //     required this.color, required this.onTap});
// //   @override State<_DlgTile> createState() => _DlgTileState();
// // }
// //
// // class _DlgTileState extends State<_DlgTile> {
// //   bool _p = false;
// //   @override
// //   Widget build(BuildContext context) => GestureDetector(
// //     onTap: widget.onTap,
// //     onTapDown: (_) => setState(() => _p = true),
// //     onTapUp:   (_) => setState(() => _p = false),
// //     onTapCancel:() => setState(() => _p = false),
// //     child: AnimatedScale(
// //       scale: _p ? 0.97 : 1.0,
// //       duration: const Duration(milliseconds: 110),
// //       child: Container(
// //         padding: const EdgeInsets.all(15),
// //         decoration: BoxDecoration(
// //           borderRadius: BorderRadius.circular(16),
// //           color: widget.color.withOpacity(0.10),
// //           border: Border.all(color: widget.color.withOpacity(0.28)),
// //         ),
// //         child: Row(children: [
// //           Container(width: 44, height: 44,
// //               decoration: BoxDecoration(shape: BoxShape.circle,
// //                   gradient: LinearGradient(
// //                       colors: [widget.color, widget.color.withOpacity(0.55)])),
// //               child: Icon(widget.icon, color: Colors.white, size: 20)),
// //           const SizedBox(width: 14),
// //           Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
// //             Text(widget.title, style: const TextStyle(color: _T.textPrimary,
// //                 fontSize: 14, fontWeight: FontWeight.w700)),
// //             const SizedBox(height: 2),
// //             Text(widget.sub, style: const TextStyle(color: _T.textSub, fontSize: 11)),
// //           ])),
// //           Icon(Icons.arrow_forward_ios_rounded, color: widget.color, size: 13),
// //         ]),
// //       ),
// //     ),
// //   );
// // }
// //
// // // ═══════════════════════════════════════════════════════════════════════════════
// // //  SHARED WIDGETS
// // // ═══════════════════════════════════════════════════════════════════════════════
// // class _SecTitle extends StatelessWidget {
// //   final String title, sub;
// //   const _SecTitle(this.title, this.sub);
// //   @override
// //   Widget build(BuildContext context) => Column(
// //       crossAxisAlignment: CrossAxisAlignment.start, children: [
// //     ShaderMask(
// //       shaderCallback: (r) => const LinearGradient(
// //           colors: [_T.textPrimary, _T.accentCyan]).createShader(r),
// //       child: Text(title, style: const TextStyle(color: Colors.white,
// //           fontSize: 18, fontWeight: FontWeight.w800)),
// //     ),
// //     Text(sub, style: const TextStyle(color: _T.textSub, fontSize: 12)),
// //   ]);
// // }
// //
// // class _EmptyState extends StatelessWidget {
// //   final IconData icon;
// //   final String   message, sub;
// //   final Color    accent;
// //   const _EmptyState({required this.icon, required this.message,
// //     required this.sub, required this.accent});
// //
// //   @override
// //   Widget build(BuildContext context) => Container(
// //     padding: const EdgeInsets.all(22),
// //     decoration: BoxDecoration(
// //       color: accent.withOpacity(0.05),
// //       borderRadius: BorderRadius.circular(16),
// //       border: Border.all(color: accent.withOpacity(0.15)),
// //     ),
// //     child: Column(children: [
// //       Icon(icon, color: accent.withOpacity(0.4), size: 34),
// //       const SizedBox(height: 10),
// //       Text(message, style: TextStyle(color: accent.withOpacity(0.7),
// //           fontSize: 13, fontWeight: FontWeight.w600)),
// //       const SizedBox(height: 4),
// //       Text(sub, style: const TextStyle(color: _T.textSub, fontSize: 11),
// //           textAlign: TextAlign.center),
// //     ]),
// //   );
// // }
// //
// // // Shimmer loading placeholder
// // class _ShimmerList extends StatefulWidget {
// //   const _ShimmerList();
// //   @override State<_ShimmerList> createState() => _ShimmerListState();
// // }
// //
// // class _ShimmerListState extends State<_ShimmerList>
// //     with SingleTickerProviderStateMixin {
// //   late final AnimationController _c;
// //   @override
// //   void initState() {
// //     super.initState();
// //     _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat();
// //   }
// //   @override void dispose() { _c.dispose(); super.dispose(); }
// //
// //   @override
// //   Widget build(BuildContext context) => AnimatedBuilder(
// //     animation: _c,
// //     builder: (_, __) => Column(
// //       children: List.generate(2, (i) => Container(
// //         margin: const EdgeInsets.only(bottom: 10),
// //         height: 64,
// //         decoration: BoxDecoration(
// //           borderRadius: BorderRadius.circular(14),
// //           gradient: LinearGradient(
// //             begin: Alignment((_c.value * 2) - 1, 0),
// //             end:   Alignment((_c.value * 2) + 1, 0),
// //             colors: [_T.card, _T.surface, _T.card],
// //           ),
// //         ),
// //       )),
// //     ),
// //   );
// // }
// //
// // // ═══════════════════════════════════════════════════════════════════════════════
// // //  ANIMATED BACKGROUND
// // // ═══════════════════════════════════════════════════════════════════════════════
// // class _AnimatedBg extends StatefulWidget {
// //   const _AnimatedBg();
// //   @override State<_AnimatedBg> createState() => _AnimatedBgState();
// // }
// //
// // class _AnimatedBgState extends State<_AnimatedBg>
// //     with SingleTickerProviderStateMixin {
// //   late final AnimationController _c;
// //   @override
// //   void initState() {
// //     super.initState();
// //     _c = AnimationController(vsync: this, duration: const Duration(seconds: 10))..repeat();
// //   }
// //   @override void dispose() { _c.dispose(); super.dispose(); }
// //
// //   @override
// //   Widget build(BuildContext context) => AnimatedBuilder(
// //     animation: _c,
// //     builder: (_, __) => CustomPaint(
// //         painter: _BgCP(_c.value), size: Size.infinite,
// //         child: const SizedBox.expand()),
// //   );
// // }
// //
// // // ═══════════════════════════════════════════════════════════════════════════════
// // //  CUSTOM PAINTERS
// // // ═══════════════════════════════════════════════════════════════════════════════
// // class _GridPainter extends CustomPainter {
// //   @override
// //   void paint(Canvas c, Size s) {
// //     final p = Paint()..color = _T.accentBlue.withOpacity(0.055)..strokeWidth = 0.5;
// //     for (double x = 0; x < s.width;  x += 26) c.drawLine(Offset(x,0),Offset(x,s.height),p);
// //     for (double y = 0; y < s.height; y += 26) c.drawLine(Offset(0,y),Offset(s.width,y),  p);
// //   }
// //   @override bool shouldRepaint(_) => false;
// // }
// //
// // class _HeroBgOrb extends CustomPainter {
// //   final double t;
// //   _HeroBgOrb(this.t);
// //   @override
// //   void paint(Canvas c, Size s) {
// //     final a = t * 2 * math.pi;
// //     void orb(double fx, double fy, double r, Color col, double op) {
// //       final x = s.width  * (fx + 0.09 * math.sin(a + fy));
// //       final y = s.height * (fy + 0.14 * math.cos(a + fx));
// //       c.drawCircle(Offset(x,y), s.width*r, Paint()
// //         ..shader = RadialGradient(colors: [col.withOpacity(op), Colors.transparent])
// //             .createShader(Rect.fromCircle(center: Offset(x,y), radius: s.width*r)));
// //     }
// //     orb(0.78, 0.28, 0.44, _T.accentBlue,   0.26);
// //     orb(0.18, 0.70, 0.28, _T.accentPurple, 0.20);
// //   }
// //   @override bool shouldRepaint(_HeroBgOrb o) => o.t != t;
// // }
// //
// // class _RadarOrb extends CustomPainter {
// //   final double t;
// //   _RadarOrb(this.t);
// //   @override
// //   void paint(Canvas c, Size s) {
// //     final cx = s.width/2, cy = s.height/2;
// //     final center = Offset(cx, cy);
// //     for (int i = 1; i <= 3; i++) {
// //       c.drawCircle(center, s.width/2*i/3, Paint()
// //         ..color = _T.accentCyan.withOpacity(0.10)
// //         ..style = PaintingStyle.stroke..strokeWidth = 0.8);
// //     }
// //     final pr = s.width/2*(0.35 + 0.65*t);
// //     c.drawCircle(center, pr, Paint()
// //       ..color = _T.accentCyan.withOpacity((1-t)*0.22)
// //       ..style = PaintingStyle.stroke..strokeWidth = 1.8);
// //     c.drawCircle(center, 14, Paint()
// //       ..shader = RadialGradient(colors: [_T.accentCyan.withOpacity(0.80), Colors.transparent])
// //           .createShader(Rect.fromCircle(center: center, radius: 14)));
// //     c.drawCircle(center, 6, Paint()..color = Colors.white);
// //     for (int i = 0; i < 3; i++) {
// //       final angle = t * 2 * math.pi + i * (2 * math.pi / 3);
// //       final r = s.width/2*0.65;
// //       final pos = Offset(cx + math.cos(angle)*r, cy + math.sin(angle)*r);
// //       final col = [_T.accentCyan, _T.accentPurple, _T.accentGold][i];
// //       c.drawCircle(pos, 3.5, Paint()..color = col
// //         ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.5));
// //       c.drawCircle(pos, 2.0, Paint()..color = Colors.white.withOpacity(0.92));
// //     }
// //   }
// //   @override bool shouldRepaint(_RadarOrb o) => o.t != t;
// // }
// //
// // class _ArcRingPainter extends CustomPainter {
// //   final double angle;
// //   final Color  color;
// //   _ArcRingPainter(this.angle, this.color);
// //   @override
// //   void paint(Canvas c, Size s) {
// //     final rect = Rect.fromCircle(
// //         center: Offset(s.width/2, s.height/2), radius: s.width/2 - 1.5);
// //     c.drawArc(rect, angle, math.pi * 1.55, false, Paint()
// //       ..shader = SweepGradient(
// //         colors: [color.withOpacity(0.65), Colors.transparent],
// //         transform: GradientRotation(angle),
// //       ).createShader(rect)
// //       ..style = PaintingStyle.stroke..strokeWidth = 2.5
// //       ..strokeCap = StrokeCap.round);
// //   }
// //   @override bool shouldRepaint(_ArcRingPainter o) => o.angle != angle;
// // }
// //
// // class _SpinArc extends CustomPainter {
// //   final double t;
// //   final bool   active;
// //   final Color  color;
// //   _SpinArc(this.t, this.active, this.color);
// //   @override
// //   void paint(Canvas c, Size s) {
// //     if (!active) return;
// //     final center = Offset(s.width/2, s.height/2);
// //     final r = s.width/2;
// //     final a = t * 2 * math.pi;
// //     c.drawArc(Rect.fromCircle(center: center, radius: r),
// //         a, math.pi * 1.4, false, Paint()
// //           ..color = color.withOpacity(0.52)
// //           ..style = PaintingStyle.stroke..strokeWidth = 2.8
// //           ..strokeCap = StrokeCap.round);
// //     c.drawArc(Rect.fromCircle(center: center, radius: r),
// //         a + math.pi, math.pi * 0.5, false, Paint()
// //           ..color = color.withOpacity(0.18)
// //           ..style = PaintingStyle.stroke..strokeWidth = 1.6
// //           ..strokeCap = StrokeCap.round);
// //   }
// //   @override bool shouldRepaint(_SpinArc o) => o.t != t || o.active != active;
// // }
// //
// // class _BgCP extends CustomPainter {
// //   final double t;
// //   _BgCP(this.t);
// //   @override
// //   void paint(Canvas c, Size s) {
// //     c.drawRect(Rect.fromLTWH(0,0,s.width,s.height), Paint()..color = _T.bg);
// //     void glow(double fx, double fy, double r, Color col, double op) {
// //       final a = t * 2 * math.pi;
// //       final x = s.width  * (fx + 0.07 * math.sin(a + fy*3));
// //       final y = s.height * (fy + 0.06 * math.cos(a + fx*2));
// //       c.drawCircle(Offset(x,y), s.width*r, Paint()
// //         ..shader = RadialGradient(colors: [col.withOpacity(op), Colors.transparent])
// //             .createShader(Rect.fromCircle(center: Offset(x,y), radius: s.width*r)));
// //     }
// //     glow(0.82, 0.06, 0.46, _T.accentBlue,   0.17);
// //     glow(0.12, 0.88, 0.40, _T.accentPurple, 0.12);
// //     glow(0.50, 0.44, 0.22, _T.accentCyan,   0.06);
// //   }
// //   @override bool shouldRepaint(_BgCP o) => o.t != t;
// // }
// //
// // // ═══════════════════════════════════════════════════════════════════════════════
// // //  SLIDE ROUTE
// // // ═══════════════════════════════════════════════════════════════════════════════
// // PageRoute _slideRoute(Widget page) => PageRouteBuilder(
// //   pageBuilder: (_, __, ___) => page,
// //   transitionsBuilder: (_, a, __, child) => SlideTransition(
// //     position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
// //         .animate(CurvedAnimation(parent: a, curve: Curves.easeOutCubic)),
// //     child: child,
// //   ),
// //   transitionDuration: const Duration(milliseconds: 360),
// // );
//
// import 'dart:convert';
// import 'dart:math' as math;
// import 'dart:ui';
// import 'package:crowd_trace/report_case.dart';
// import 'package:crowd_trace/upload_page.dart';
// import 'package:crowd_trace/user_alerts.dart';
// import 'package:crowd_trace/view_cases.dart';
// import 'package:crowd_trace/view_uploads.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:crowd_trace/complaint.dart';
// import 'package:crowd_trace/view_criminals.dart';
// import 'package:crowd_trace/view_missing_persons.dart';
// import 'package:crowd_trace/feedback.dart';
// import 'login.dart';
// import 'View_Police_Station.dart';
//
// // ─────────────────────────────────────────────────────────────────────────────
// //  TOKENS
// // ─────────────────────────────────────────────────────────────────────────────
// class _T {
//   static const bg           = Color(0xFF04091A);
//   static const surface      = Color(0xFF080F26);
//   static const card         = Color(0xFF0C1535);
//   static const accentBlue   = Color(0xFF1D6BFF);
//   static const accentCyan   = Color(0xFF00C2FF);
//   static const accentPurple = Color(0xFF7B5CFF);
//   static const accentGold   = Color(0xFFFFB547);
//   static const accentRed    = Color(0xFFFF4057);
//   static const accentGreen  = Color(0xFF00E676);
//   static const textPrimary  = Color(0xFFEEF3FF);
//   static const textSub      = Color(0xFF5A7299);
//   static const textMid      = Color(0xFF8AAAD4);
//   static const glass        = Color(0x0FFFFFFF);
//   static const glassBorder  = Color(0x14FFFFFF);
// }
//
// // ─────────────────────────────────────────────────────────────────────────────
// //  MODELS
// // ─────────────────────────────────────────────────────────────────────────────
// class _PersonRecord {
//   final int    id;
//   final String name, age, gender, details, photoUrl;
//   const _PersonRecord({required this.id, required this.name, required this.age,
//     required this.gender, required this.details, required this.photoUrl});
//
//   factory _PersonRecord.fromMissing(Map<String, dynamic> j, String base) {
//     final raw = (j['photo'] ?? '').toString();
//     return _PersonRecord(
//       id: int.tryParse(j['id'].toString()) ?? 0,
//       name: j['name']?.toString() ?? 'Unknown',
//       age: j['phone']?.toString() ?? '--',
//       gender: j['gender']?.toString() ?? '',
//       details: j['experience']?.toString() ?? '',
//       photoUrl: raw.isEmpty ? '' : raw.startsWith('http') ? raw : '$base$raw',
//     );
//   }
//
//   factory _PersonRecord.fromCriminal(Map<String, dynamic> j, String base) {
//     final raw = (j['photo'] ?? '').toString();
//     return _PersonRecord(
//       id: int.tryParse(j['id'].toString()) ?? 0,
//       name: j['name']?.toString() ?? 'Unknown',
//       age: j['phone']?.toString() ?? '--',
//       gender: j['gender']?.toString() ?? '',
//       details: j['experience']?.toString() ?? '',
//       photoUrl: raw.isEmpty ? '' : raw.startsWith('http') ? raw : '$base$raw',
//     );
//   }
// }
//
// class _CaseRecord {
//   final int    id;
//   final String description, progress, status, date, station, photoUrl;
//   const _CaseRecord({required this.id, required this.description,
//     required this.progress, required this.status,
//     required this.date, required this.station, required this.photoUrl});
//   factory _CaseRecord.fromJson(Map<String, dynamic> j) => _CaseRecord(
//     id: int.tryParse(j['id'].toString()) ?? 0,
//     description: j['description']?.toString() ?? '',
//     progress: j['progress']?.toString() ?? 'pending',
//     status: j['status']?.toString() ?? 'Not Viewed',
//     date: j['date']?.toString() ?? '',
//     station: j['station']?.toString() ?? 'Not Assigned',
//     photoUrl: j['photo']?.toString() ?? '',
//   );
// }
//
// class _Detection {
//   final int    id;
//   final String name, category, date, latitude, longitude, photoUrl;
//   const _Detection({required this.id, required this.name, required this.category,
//     required this.date, required this.latitude,
//     required this.longitude, required this.photoUrl});
//   factory _Detection.fromJson(Map<String, dynamic> j) => _Detection(
//     id: int.tryParse(j['id'].toString()) ?? 0,
//     name: j['name']?.toString() ?? '',
//     category: j['category']?.toString() ?? '',
//     date: j['date']?.toString() ?? '',
//     latitude: j['latitude']?.toString() ?? '',
//     longitude: j['longitude']?.toString() ?? '',
//     photoUrl: j['photo']?.toString() ?? '',
//   );
// }
//
// class _ComplaintRecord {
//   final int    id;
//   final String description, date, reply;
//   const _ComplaintRecord({required this.id, required this.description,
//     required this.date, required this.reply});
//   factory _ComplaintRecord.fromJson(Map<String, dynamic> j) => _ComplaintRecord(
//     id: int.tryParse(j['id'].toString()) ?? 0,
//     description: j['complaint']?.toString() ?? '',
//     date: j['date']?.toString() ?? '',
//     reply: j['reply']?.toString() ?? 'pending',
//   );
// }
//
// // ─────────────────────────────────────────────────────────────────────────────
// //  NAV
// // ─────────────────────────────────────────────────────────────────────────────
// class _NI {
//   final String label; final IconData icon, active;
//   const _NI(this.label, this.icon, this.active);
// }
// const _nav = [
//   _NI('Home',    Icons.home_outlined,          Icons.home_rounded),
//   _NI('Police',  Icons.local_police_outlined,  Icons.local_police_rounded),
//   _NI('',        Icons.add,                    Icons.add),
//   _NI('Missing', Icons.person_search_outlined, Icons.manage_search_rounded),
//   _NI('Reports', Icons.assignment_outlined,    Icons.assignment_rounded),
// ];
//
// // ─────────────────────────────────────────────────────────────────────────────
// //  ROOT
// // ─────────────────────────────────────────────────────────────────────────────
// class Home_page extends StatefulWidget {
//   const Home_page({super.key});
//   @override State<Home_page> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<Home_page> with TickerProviderStateMixin {
//   int _idx = 0;
//   late final AnimationController _fabPulse;
//
//   // stats
//   int _stPolice = 0, _stMissing = 0, _stCases = 0;
//   bool _stLoaded = false;
//
//   // data
//   String _userName = '';
//   List<_PersonRecord>    _missing    = [];
//   List<_PersonRecord>    _criminals  = [];
//   List<_CaseRecord>      _cases      = [];
//   List<_Detection>       _detections = [];
//   List<_ComplaintRecord> _complaints = [];
//   bool _loaded = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _fabPulse = AnimationController(vsync: this, duration: const Duration(seconds: 2))
//       ..repeat(reverse: true);
//     _loadAll();
//   }
//
//   @override void dispose() { _fabPulse.dispose(); super.dispose(); }
//
//   Future<void> _loadAll() async {
//     try {
//       final sh   = await SharedPreferences.getInstance();
//       final base = sh.getString('url') ?? '';
//       final lid  = sh.getString('lid') ?? '';
//       if (mounted) setState(() => _userName = sh.getString('user_name') ?? '');
//       await Future.wait([
//         _fetchStats(base, lid), _fetchMissing(base, lid), _fetchCriminals(base, lid),
//         _fetchCases(base, lid), _fetchDetections(base, lid), _fetchComplaints(base, lid),
//       ]);
//     } catch (_) {}
//     if (mounted) setState(() => _loaded = true);
//   }
//
//   Future<void> _fetchStats(String base, String lid) async {
//     try {
//       final r = await http.post(Uri.parse('$base/dashboard_stats/'),
//           body: {'lid': lid}).timeout(const Duration(seconds: 8));
//       if (r.statusCode == 200) {
//         final d = jsonDecode(r.body);
//         if (d['status'] == 'ok' && mounted) setState(() {
//           _stPolice  = int.tryParse(d['police_stations'].toString()) ?? 0;
//           _stMissing = int.tryParse(d['missing_persons'].toString())  ?? 0;
//           _stCases   = int.tryParse(d['resolved_cases'].toString())   ?? 0;
//           _stLoaded  = true;
//         });
//       }
//     } catch (_) {}
//   }
//
//   Future<void> _fetchMissing(String base, String lid) async {
//     try {
//       final r = await http.post(Uri.parse('$base/user_view_missing_persons/'),
//           body: {'lid': lid}).timeout(const Duration(seconds: 10));
//       if (r.statusCode == 200) {
//         final d = jsonDecode(r.body);
//         if (d['status'] == 'ok' && mounted) setState(() =>
//         _missing = (d['data'] as List)
//             .map((p) => _PersonRecord.fromMissing(p as Map<String,dynamic>, base)).toList());
//       }
//     } catch (_) {}
//   }
//
//   Future<void> _fetchCriminals(String base, String lid) async {
//     try {
//       final r = await http.post(Uri.parse('$base/user_view_criminals/'),
//           body: {'lid': lid}).timeout(const Duration(seconds: 10));
//       if (r.statusCode == 200) {
//         final d = jsonDecode(r.body);
//         if (d['status'] == 'ok' && mounted) setState(() =>
//         _criminals = (d['data'] as List)
//             .map((p) => _PersonRecord.fromCriminal(p as Map<String,dynamic>, base)).toList());
//       }
//     } catch (_) {}
//   }
//
//   Future<void> _fetchCases(String base, String lid) async {
//     try {
//       final r = await http.post(Uri.parse('$base/user_view_cases/'),
//           body: {'lid': lid}).timeout(const Duration(seconds: 10));
//       if (r.statusCode == 200) {
//         final d = jsonDecode(r.body);
//         if (d['status'] == 'ok' && mounted) setState(() =>
//         _cases = (d['data'] as List)
//             .map((c) => _CaseRecord.fromJson(c as Map<String,dynamic>)).toList());
//       }
//     } catch (_) {}
//   }
//
//   Future<void> _fetchDetections(String base, String lid) async {
//     try {
//       final r = await http.post(Uri.parse('$base/user_view_detections/'),
//           body: {'uid': lid}).timeout(const Duration(seconds: 10));
//       if (r.statusCode == 200) {
//         final d = jsonDecode(r.body);
//         if (d['status'] == 'ok' && mounted) setState(() =>
//         _detections = (d['data'] as List)
//             .map((c) => _Detection.fromJson(c as Map<String,dynamic>)).toList());
//       }
//     } catch (_) {}
//   }
//
//   Future<void> _fetchComplaints(String base, String lid) async {
//     try {
//       final r = await http.post(Uri.parse('$base/user_view_complaints/'),
//           body: {'lid': lid}).timeout(const Duration(seconds: 10));
//       if (r.statusCode == 200) {
//         final d = jsonDecode(r.body);
//         if (d['status'] == 'ok' && mounted) setState(() =>
//         _complaints = (d['data'] as List)
//             .map((c) => _ComplaintRecord.fromJson(c as Map<String,dynamic>)).toList());
//       }
//     } catch (_) {}
//   }
//
//   Widget _buildPage(int i) {
//     if (i == 1) return const View_Police_Station(title: 'Police Stations');
//     if (i == 4) return const _ReportsTab();
//     return _HomeTab(
//       onLogout: _doLogout, onRefresh: _loadAll,
//       stPolice: _stPolice, stMissing: _stMissing, stCases: _stCases,
//       stLoaded: _stLoaded, dataLoaded: _loaded, userName: _userName,
//       missingList: _missing, criminalList: _criminals,
//       casesList: _cases, detections: _detections, complaints: _complaints,
//     );
//   }
//
//   void _onNavTap(int i) {
//     HapticFeedback.lightImpact();
//     if (i == 2) { Navigator.push(context, _slide(const UploadPage())); return; }
//     if (i == 3) { _showMissingDialog(); return; }
//     setState(() => _idx = i);
//   }
//
//   void _showMissingDialog() {
//     showGeneralDialog(
//       context: context,
//       barrierDismissible: true, barrierLabel: '',
//       barrierColor: Colors.black54,
//       transitionDuration: const Duration(milliseconds: 340),
//       transitionBuilder: (_, a, __, child) => ScaleTransition(
//           scale: CurvedAnimation(parent: a, curve: Curves.easeOutBack),
//           child: FadeTransition(opacity: a, child: child)),
//       pageBuilder: (ctx, _, __) => _PickDialog(
//         onMissing: () { Navigator.pop(ctx);
//         Navigator.push(context, _slide(const ViewMissingPersonsPage())); },
//         onCriminal: () { Navigator.pop(ctx);
//         Navigator.push(context, _slide(const ViewCriminalsPage(shopId: ''))); },
//       ),
//     );
//   }
//
//   void _doLogout() {
//     showDialog(context: context, builder: (_) => AlertDialog(
//       backgroundColor: _T.card,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       icon: const Icon(Icons.logout_rounded, color: _T.accentRed, size: 28),
//       title: const Text('Sign Out', style: TextStyle(color: _T.textPrimary, fontWeight: FontWeight.w800)),
//       content: const Text('Are you sure?', style: TextStyle(color: _T.textSub, fontSize: 13)),
//       actions: [
//         TextButton(onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel', style: TextStyle(color: _T.textSub))),
//         TextButton(onPressed: () async {
//           Navigator.pop(context);
//           final sh = await SharedPreferences.getInstance();
//           await sh.remove('lid');
//           if (mounted) Navigator.pushReplacement(context,
//               MaterialPageRoute(builder: (_) => const LoginPage(title: 'Login')));
//         }, child: const Text('Sign Out', style: TextStyle(color: _T.accentRed, fontWeight: FontWeight.w800))),
//       ],
//     ));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final bot = MediaQuery.of(context).padding.bottom;
//     return AnnotatedRegion<SystemUiOverlayStyle>(
//       value: SystemUiOverlayStyle.light,
//       child: Scaffold(
//         backgroundColor: _T.bg,
//         extendBody: true,
//         body: Stack(children: [
//           const _Bg(),
//           SafeArea(bottom: false,
//             child: AnimatedSwitcher(
//               duration: const Duration(milliseconds: 300),
//               transitionBuilder: (child, a) => FadeTransition(opacity: a, child: child),
//               child: KeyedSubtree(key: ValueKey(_idx), child: _buildPage(_idx)),
//             ),
//           ),
//         ]),
//         bottomNavigationBar: _NavBar(
//             idx: _idx, pulse: _fabPulse, onTap: _onNavTap, bot: bot),
//       ),
//     );
//   }
// }
//
// // ─────────────────────────────────────────────────────────────────────────────
// //  NAV BAR
// // ─────────────────────────────────────────────────────────────────────────────
// class _NavBar extends StatelessWidget {
//   final int idx; final AnimationController pulse;
//   final ValueChanged<int> onTap; final double bot;
//   const _NavBar({required this.idx, required this.pulse,
//     required this.onTap, required this.bot});
//
//   @override
//   Widget build(BuildContext context) => Container(
//     color: Colors.transparent,
//     padding: EdgeInsets.fromLTRB(16, 8, 16, bot + 12),
//     child: ClipRRect(borderRadius: BorderRadius.circular(36),
//       child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
//         child: Container(height: 68,
//           decoration: BoxDecoration(
//             color: const Color(0xFF0A1428).withOpacity(0.94),
//             borderRadius: BorderRadius.circular(36),
//             border: Border.all(color: _T.glassBorder),
//             boxShadow: [BoxShadow(color: Colors.black45, blurRadius: 28, offset: const Offset(0,10))],
//           ),
//           child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: List.generate(5, (i) {
//               if (i == 2) return _FabBtn(pulse: pulse, onTap: () => onTap(2));
//               return _Pill(ni: _nav[i], sel: idx == i, onTap: () => onTap(i));
//             }),
//           ),
//         ),
//       ),
//     ),
//   );
// }
//
// class _FabBtn extends StatefulWidget {
//   final AnimationController pulse; final VoidCallback onTap;
//   const _FabBtn({required this.pulse, required this.onTap});
//   @override State<_FabBtn> createState() => _FabBtnState();
// }
// class _FabBtnState extends State<_FabBtn> with SingleTickerProviderStateMixin {
//   late final AnimationController _spin;
//   bool _p = false;
//   @override void initState() { super.initState();
//   _spin = AnimationController(vsync: this, duration: const Duration(seconds: 5))..repeat(); }
//   @override void dispose() { _spin.dispose(); super.dispose(); }
//   @override
//   Widget build(BuildContext context) => GestureDetector(
//     onTap: () { HapticFeedback.mediumImpact(); widget.onTap(); },
//     onTapDown: (_) => setState(() => _p = true),
//     onTapUp: (_) => setState(() => _p = false),
//     onTapCancel: () => setState(() => _p = false),
//     child: AnimatedBuilder(animation: Listenable.merge([widget.pulse, _spin]),
//         builder: (_, __) {
//           final g = widget.pulse.value;
//           final ang = _spin.value * 2 * math.pi;
//           return AnimatedScale(scale: _p ? 0.88 : 1.0, duration: const Duration(milliseconds: 100),
//               child: SizedBox(width: 68, height: 68, child: Stack(alignment: Alignment.center, children: [
//                 Container(width: 68, height: 68, decoration: BoxDecoration(shape: BoxShape.circle,
//                     boxShadow: [BoxShadow(color: _T.accentCyan.withOpacity(0.15+g*0.18),
//                         blurRadius: 18+g*14, spreadRadius: g*4)])),
//                 CustomPaint(size: const Size(68,68), painter: _ArcP(ang, _T.accentCyan)),
//                 Container(width: 54, height: 54,
//                     decoration: BoxDecoration(shape: BoxShape.circle,
//                         gradient: SweepGradient(colors: const [_T.accentCyan,_T.accentBlue,_T.accentPurple,_T.accentCyan],
//                             transform: GradientRotation(ang)),
//                         boxShadow: [BoxShadow(color: _T.accentBlue.withOpacity(0.45+g*0.2), blurRadius: 14)]),
//                     child: const Icon(Icons.add_photo_alternate_rounded, color: Colors.white, size: 24)),
//               ])));
//         }),
//   );
// }
//
// class _Pill extends StatefulWidget {
//   final _NI ni; final bool sel; final VoidCallback onTap;
//   const _Pill({required this.ni, required this.sel, required this.onTap});
//   @override State<_Pill> createState() => _PillState();
// }
// class _PillState extends State<_Pill> with SingleTickerProviderStateMixin {
//   late final AnimationController _c;
//   late final Animation<double> _v;
//   @override void initState() { super.initState();
//   _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
//   _v = CurvedAnimation(parent: _c, curve: Curves.easeOutCubic);
//   if (widget.sel) _c.value = 1; }
//   @override void didUpdateWidget(_Pill o) { super.didUpdateWidget(o);
//   widget.sel ? _c.forward() : _c.reverse(); }
//   @override void dispose() { _c.dispose(); super.dispose(); }
//   @override
//   Widget build(BuildContext context) => GestureDetector(
//     onTap: () { HapticFeedback.selectionClick(); widget.onTap(); },
//     behavior: HitTestBehavior.opaque,
//     child: AnimatedBuilder(animation: _v, builder: (_, __) {
//       final v = _v.value;
//       return Container(height: 44,
//           padding: EdgeInsets.symmetric(horizontal: 10 + 4*v),
//           decoration: BoxDecoration(
//               color: v > 0.05 ? _T.accentBlue.withOpacity(0.14*v) : Colors.transparent,
//               borderRadius: BorderRadius.circular(22),
//               border: v > 0.5 ? Border.all(color: _T.accentBlue.withOpacity(0.25*v)) : null),
//           child: Row(mainAxisSize: MainAxisSize.min, children: [
//             Icon(widget.sel ? widget.ni.active : widget.ni.icon,
//                 color: Color.lerp(_T.textSub, _T.accentCyan, v), size: 21),
//             if (v > 0.3) ...[SizedBox(width: 5*v),
//               Opacity(opacity: ((v-0.3)/0.7).clamp(0,1),
//                   child: Text(widget.ni.label, style: const TextStyle(
//                       color: _T.accentCyan, fontSize: 11.5, fontWeight: FontWeight.w700)))],
//           ]));
//     }),
//   );
// }
//
// // ─────────────────────────────────────────────────────────────────────────────
// //  HOME TAB
// // ─────────────────────────────────────────────────────────────────────────────
// class _HomeTab extends StatefulWidget {
//   final VoidCallback?            onLogout;
//   final Future<void> Function()? onRefresh;
//   final int    stPolice, stMissing, stCases;
//   final bool   stLoaded, dataLoaded;
//   final String userName;
//   final List<_PersonRecord>    missingList, criminalList;
//   final List<_CaseRecord>      casesList;
//   final List<_Detection>       detections;
//   final List<_ComplaintRecord> complaints;
//   const _HomeTab({this.onLogout, this.onRefresh,
//     this.stPolice=0, this.stMissing=0, this.stCases=0,
//     this.stLoaded=false, this.dataLoaded=false, this.userName='',
//     this.missingList=const[], this.criminalList=const[],
//     this.casesList=const[], this.detections=const[], this.complaints=const[]});
//   @override State<_HomeTab> createState() => _HomeTabState();
// }
//
// class _HomeTabState extends State<_HomeTab> with TickerProviderStateMixin {
//   late final AnimationController _enter;
//   bool _refreshing = false;
//
//   Animation<double> _af(double a, double b) => Tween<double>(begin:0,end:1).animate(
//       CurvedAnimation(parent:_enter, curve: Interval(a,b, curve: Curves.easeOutCubic)));
//   Animation<Offset> _as(double a, double b) => Tween<Offset>(
//       begin:const Offset(0,0.05), end:Offset.zero).animate(
//       CurvedAnimation(parent:_enter, curve: Interval(a,b, curve: Curves.easeOutCubic)));
//
//   @override void initState() { super.initState();
//   _enter = AnimationController(vsync:this, duration:const Duration(milliseconds:900))..forward(); }
//   @override void dispose() { _enter.dispose(); super.dispose(); }
//
//   Future<void> _doRefresh() async {
//     setState(() => _refreshing = true);
//     await widget.onRefresh?.call();
//     if (mounted) setState(() => _refreshing = false);
//   }
//
//   void _push(Widget p) => Navigator.push(context, _slide(p));
//
//   @override
//   Widget build(BuildContext context) => RefreshIndicator(
//     onRefresh: _doRefresh, color: _T.accentCyan, backgroundColor: _T.card,
//     child: CustomScrollView(
//       physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
//       slivers: [
//         // APP BAR + WELCOME CARD
//         SliverToBoxAdapter(child: FadeTransition(opacity: _af(0,.38),
//             child: SlideTransition(position: _as(0,.38),
//                 child: _DashTop(
//                   userName: widget.userName,
//                   onLogout: widget.onLogout,
//                   isRefreshing: _refreshing,
//                   onCases: () => _push(const UserHomeWithAlerts()),
//                   onMissing: () => _push(const ViewMissingPersonsPage()),
//                 )))),
//
//         // ACTIVITY OVERVIEW
//         SliverToBoxAdapter(child: FadeTransition(opacity: _af(.10,.45),
//             child: SlideTransition(position: _as(.10,.45),
//                 child: _ActivityOverview(
//                   missingCount: widget.missingList.length,
//                   detectionCount: widget.detections.length,
//                   caseCount: widget.casesList.length,
//                   loaded: widget.dataLoaded,
//                   onPush: _push,
//                 )))),
//
//         const SliverToBoxAdapter(child: SizedBox(height: 8)),
//
//         // QUICK ACTIONS
//         SliverToBoxAdapter(child: FadeTransition(opacity: _af(.22,.58),
//             child: SlideTransition(position: _as(.22,.58),
//                 child: _QuickGrid(onPush: _push)))),
//
//         const SliverToBoxAdapter(child: SizedBox(height: 24)),
//
//         // PERSON CAROUSEL
//         SliverToBoxAdapter(child: FadeTransition(opacity: _af(.32,.68),
//             child: SlideTransition(position: _as(.32,.68),
//                 child: _CarouselSection(missing: widget.missingList,
//                     criminals: widget.criminalList, loaded: widget.dataLoaded,
//                     onPush: _push)))),
//
//         const SliverToBoxAdapter(child: SizedBox(height: 24)),
//
//         // MY CASES
//         SliverToBoxAdapter(child: FadeTransition(opacity: _af(.42,.76),
//             child: SlideTransition(position: _as(.42,.76),
//                 child: _CasesSection(cases: widget.casesList,
//                     loaded: widget.dataLoaded, onPush: _push)))),
//
//         const SliverToBoxAdapter(child: SizedBox(height: 24)),
//
//         // MY DETECTIONS
//         SliverToBoxAdapter(child: FadeTransition(opacity: _af(.52,.84),
//             child: SlideTransition(position: _as(.52,.84),
//                 child: _DetectionsSection(detections: widget.detections,
//                     loaded: widget.dataLoaded, onPush: _push)))),
//
//         const SliverToBoxAdapter(child: SizedBox(height: 24)),
//
//         // COMPLAINTS ACCORDION
//         SliverToBoxAdapter(child: FadeTransition(opacity: _af(.62,.92),
//             child: SlideTransition(position: _as(.62,.92),
//                 child: _ComplaintsAccordion(complaints: widget.complaints,
//                     loaded: widget.dataLoaded, onPush: _push)))),
//
//         const SliverToBoxAdapter(child: SizedBox(height: 110)),
//       ],
//     ),
//   );
// }
//
// // ─────────────────────────────────────────────────────────────────────────────
// //  DASHBOARD TOP  — full-width gradient header, no floating card
// // ─────────────────────────────────────────────────────────────────────────────
// class _DashTop extends StatefulWidget {
//   final String userName;
//   final VoidCallback? onLogout, onCases, onMissing;
//   final bool isRefreshing;
//   const _DashTop({required this.userName, this.onLogout, this.onCases,
//     this.onMissing, this.isRefreshing = false});
//   @override State<_DashTop> createState() => _DashTopState();
// }
//
// class _DashTopState extends State<_DashTop> with SingleTickerProviderStateMixin {
//   late final AnimationController _pulse;
//
//   @override
//   void initState() {
//     super.initState();
//     _pulse = AnimationController(vsync: this,
//         duration: const Duration(seconds: 2))..repeat(reverse: true);
//   }
//
//   @override void dispose() { _pulse.dispose(); super.dispose(); }
//
//   static String _greet() {
//     final h = DateTime.now().hour;
//     if (h < 5)  return 'Up late?';
//     if (h < 12) return 'Good morning';
//     if (h < 17) return 'Good afternoon';
//     return 'Good evening';
//   }
//
//   static String _date() {
//     const mo = ['Jan','Feb','Mar','Apr','May','Jun',
//       'Jul','Aug','Sep','Oct','Nov','Dec'];
//     const dy = ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'];
//     final n = DateTime.now();
//     return '${dy[n.weekday - 1]}, ${n.day} ${mo[n.month - 1]}';
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final name     = widget.userName.isNotEmpty ? widget.userName : 'there';
//     final initials = name.trim().split(' ').map((w) => w[0].toUpperCase()).take(2).join();
//     final sw       = MediaQuery.of(context).size.width;
//
//     return SafeArea(bottom: false,
//       child: Padding(
//         padding: const EdgeInsets.fromLTRB(18, 14, 18, 0),
//         child: Column(crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//
//             // ── top bar ───────────────────────────────────────────────
//             Row(children: [
//               Container(width: 34, height: 34,
//                   decoration: BoxDecoration(
//                       gradient: const LinearGradient(
//                           colors: [_T.accentBlue, _T.accentCyan],
//                           begin: Alignment.topLeft, end: Alignment.bottomRight),
//                       borderRadius: BorderRadius.circular(10),
//                       boxShadow: [BoxShadow(color: _T.accentBlue.withOpacity(0.40),
//                           blurRadius: 10)]),
//                   child: const Icon(Icons.shield_outlined, color: Colors.white, size: 16)),
//               const SizedBox(width: 8),
//               Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//                 ShaderMask(
//                     shaderCallback: (r) => const LinearGradient(
//                         colors: [_T.textPrimary, _T.accentCyan]).createShader(r),
//                     child: const Text('CrowdTrace', style: TextStyle(
//                         color: Colors.white, fontSize: 15, fontWeight: FontWeight.w800))),
//                 const Text('Community Safety',
//                     style: TextStyle(color: _T.textSub, fontSize: 8.5)),
//               ]),
//               const Spacer(),
//               _IBtn(icon: Icons.notifications_outlined, onTap: widget.onCases ?? () {}),
//               const SizedBox(width: 8),
//               widget.isRefreshing
//                   ? const SizedBox(width: 36, height: 36, child: Center(
//                   child: SizedBox(width: 15, height: 15,
//                       child: CircularProgressIndicator(strokeWidth: 2, color: _T.accentCyan))))
//                   : _IBtn(icon: Icons.logout_rounded,
//                   color: _T.accentRed.withOpacity(0.80), onTap: widget.onLogout ?? () {}),
//             ]),
//
//             const SizedBox(height: 20),
//
//             // ── HERO BENTO CARD ───────────────────────────────────────
//             // A single wide card split into two visual zones
//             ClipRRect(
//               borderRadius: BorderRadius.circular(26),
//               child: AnimatedBuilder(animation: _pulse, builder: (_, __) {
//                 final p = _pulse.value;
//                 return Container(
//                   width: double.infinity,
//                   height: 178,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(26),
//                     gradient: LinearGradient(
//                         begin: Alignment.topLeft, end: Alignment.bottomRight,
//                         colors: const [Color(0xFF112268), Color(0xFF070E30)]),
//                     border: Border.all(
//                         color: _T.accentBlue.withOpacity(0.20 + p * 0.08), width: 1.2),
//                   ),
//                   child: Stack(children: [
//                     // Animated aurora blob top-right
//                     Positioned(top: -40, right: -40,
//                         child: Container(width: 200, height: 200,
//                             decoration: BoxDecoration(shape: BoxShape.circle,
//                                 gradient: RadialGradient(colors: [
//                                   _T.accentCyan.withOpacity(0.14 + p * 0.08),
//                                   Colors.transparent])))),
//                     // Purple blob bottom-left
//                     Positioned(bottom: -30, left: 40,
//                         child: Container(width: 120, height: 120,
//                             decoration: BoxDecoration(shape: BoxShape.circle,
//                                 gradient: RadialGradient(colors: [
//                                   _T.accentPurple.withOpacity(0.10 + p * 0.06),
//                                   Colors.transparent])))),
//
//                     // Diagonal divider line (decorative)
//                     Positioned.fill(child: CustomPaint(
//                         painter: _DiagLinePainter(p))),
//
//                     // Content
//                     Padding(
//                       padding: const EdgeInsets.fromLTRB(22, 20, 22, 18),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           // Top row: greeting + avatar
//                           Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
//                             Expanded(child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 // Greeting badge pill
//                                 Container(
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 10, vertical: 4),
//                                   decoration: BoxDecoration(
//                                     color: _T.accentCyan.withOpacity(0.10),
//                                     borderRadius: BorderRadius.circular(20),
//                                     border: Border.all(
//                                         color: _T.accentCyan.withOpacity(0.22)),
//                                   ),
//                                   child: Row(mainAxisSize: MainAxisSize.min, children: [
//                                     Container(width: 5, height: 5,
//                                       decoration: BoxDecoration(
//                                           shape: BoxShape.circle,
//                                           color: _T.accentCyan,
//                                           boxShadow: [BoxShadow(
//                                               color: _T.accentCyan.withOpacity(0.7),
//                                               blurRadius: 4 + p * 3)]),
//                                     ),
//                                     const SizedBox(width: 6),
//                                     Text(_greet(), style: const TextStyle(
//                                         color: _T.accentCyan, fontSize: 11,
//                                         fontWeight: FontWeight.w600)),
//                                   ]),
//                                 ),
//                                 const SizedBox(height: 10),
//                                 // Name
//                                 Row(children: [
//                                   const Text('Hi, ', style: TextStyle(
//                                       color: _T.textPrimary, fontSize: 26,
//                                       fontWeight: FontWeight.w700, height: 1)),
//                                   Flexible(child: ShaderMask(
//                                     shaderCallback: (r) => const LinearGradient(
//                                         colors: [Color(0xFF00C2FF), Color(0xFF7B5CFF)])
//                                         .createShader(r),
//                                     child: Text(name, overflow: TextOverflow.ellipsis,
//                                         style: const TextStyle(color: Colors.white,
//                                             fontSize: 26, fontWeight: FontWeight.w800,
//                                             height: 1)),
//                                   )),
//                                 ]),
//                                 const SizedBox(height: 6),
//                                 Text(_date(), style: const TextStyle(
//                                     color: _T.textSub, fontSize: 11)),
//                               ],
//                             )),
//                             const SizedBox(width: 12),
//                             // Avatar
//                             Container(width: 52, height: 52,
//                                 decoration: BoxDecoration(
//                                     shape: BoxShape.circle,
//                                     gradient: const LinearGradient(
//                                         colors: [Color(0xFF1D6BFF), Color(0xFF7B5CFF)],
//                                         begin: Alignment.topLeft,
//                                         end: Alignment.bottomRight),
//                                     boxShadow: [BoxShadow(
//                                         color: _T.accentBlue.withOpacity(0.40 + p * 0.20),
//                                         blurRadius: 16 + p * 8)]),
//                                 child: Center(child: Text(initials,
//                                     style: const TextStyle(color: Colors.white,
//                                         fontSize: 17, fontWeight: FontWeight.w800)))),
//                           ]),
//
//                           // Bottom row: two pill action buttons
//                           Row(children: [
//                             _HeroPill(
//                               label: 'My Cases',
//                               icon: Icons.folder_open_rounded,
//                               onTap: widget.onCases ?? () {},
//                             ),
//                             const SizedBox(width: 10),
//                             _HeroPill(
//                               label: 'View Missing',
//                               icon: Icons.person_search_rounded,
//                               onTap: widget.onMissing ?? () {},
//                               secondary: true,
//                             ),
//                           ]),
//                         ],
//                       ),
//                     ),
//                   ]),
//                 );
//               }),
//             ),
//
//             const SizedBox(height: 18),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // Diagonal decorative line painter inside the hero card
// class _DiagLinePainter extends CustomPainter {
//   final double p;
//   _DiagLinePainter(this.p);
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = _T.accentCyan.withOpacity(0.04 + p * 0.03)
//       ..strokeWidth = 1.0
//       ..style = PaintingStyle.stroke;
//     canvas.drawLine(
//       Offset(size.width * 0.55, 0),
//       Offset(size.width * 0.85, size.height),
//       paint,
//     );
//     canvas.drawLine(
//       Offset(size.width * 0.65, 0),
//       Offset(size.width * 0.95, size.height),
//       paint,
//     );
//   }
//   @override bool shouldRepaint(_DiagLinePainter o) => o.p != p;
// }
//
// // Pill button inside the hero card
// class _HeroPill extends StatefulWidget {
//   final String label; final IconData icon;
//   final VoidCallback onTap; final bool secondary;
//   const _HeroPill({required this.label, required this.icon,
//     required this.onTap, this.secondary = false});
//   @override State<_HeroPill> createState() => _HeroPillState();
// }
// class _HeroPillState extends State<_HeroPill> {
//   bool _p = false;
//   @override
//   Widget build(BuildContext context) => GestureDetector(
//     onTap: widget.onTap,
//     onTapDown: (_) => setState(() => _p = true),
//     onTapUp: (_) => setState(() => _p = false),
//     onTapCancel: () => setState(() => _p = false),
//     child: AnimatedScale(scale: _p ? 0.93 : 1.0,
//       duration: const Duration(milliseconds: 100),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
//         decoration: BoxDecoration(
//           gradient: widget.secondary
//               ? null
//               : const LinearGradient(colors: [Color(0xFF1D6BFF), Color(0xFF00C2FF)]),
//           color: widget.secondary ? Colors.white.withOpacity(0.07) : null,
//           borderRadius: BorderRadius.circular(22),
//           border: Border.all(
//               color: widget.secondary
//                   ? Colors.white.withOpacity(0.15)
//                   : Colors.transparent),
//           boxShadow: widget.secondary ? [] : [
//             BoxShadow(color: _T.accentBlue.withOpacity(0.40),
//                 blurRadius: 10, offset: const Offset(0, 3))],
//         ),
//         child: Row(mainAxisSize: MainAxisSize.min, children: [
//           Icon(widget.icon, color: Colors.white, size: 13),
//           const SizedBox(width: 6),
//           Text(widget.label, style: const TextStyle(color: Colors.white,
//               fontSize: 12, fontWeight: FontWeight.w700)),
//         ]),
//       ),
//     ),
//   );
// }
//
// class _IBtn extends StatelessWidget {
//   final IconData icon; final Color color; final VoidCallback onTap;
//   const _IBtn({required this.icon, required this.onTap, this.color = _T.textMid});
//   @override
//   Widget build(BuildContext context) => GestureDetector(
//       onTap: onTap,
//       child: ClipRRect(borderRadius: BorderRadius.circular(11),
//           child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//               child: Container(width: 36, height: 36,
//                   decoration: BoxDecoration(color: _T.glass,
//                       borderRadius: BorderRadius.circular(11),
//                       border: Border.all(color: _T.glassBorder)),
//                   child: Icon(icon, color: color, size: 17)))));
// }
//
// // ─────────────────────────────────────────────────────────────────────────────
// //  ACTIVITY OVERVIEW  — 3 live stat chips + quick insight, above quick access
// // ─────────────────────────────────────────────────────────────────────────────
// class _ActivityOverview extends StatelessWidget {
//   final int missingCount, detectionCount, caseCount;
//   final bool loaded;
//   final void Function(Widget) onPush;
//   const _ActivityOverview({required this.missingCount, required this.detectionCount,
//     required this.caseCount, required this.loaded, required this.onPush});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(18, 4, 18, 0),
//       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         // Three stat tiles in a row
//         Row(children: [
//           _StatTile(
//             value: missingCount, label: 'Missing\nActive',
//             icon: Icons.person_search_rounded, color: _T.accentGold,
//             loaded: loaded,
//             onTap: () => onPush(const ViewMissingPersonsPage()),
//           ),
//           const SizedBox(width: 10),
//           _StatTile(
//             value: detectionCount, label: 'My\nDetections',
//             icon: Icons.image_search_rounded, color: _T.accentPurple,
//             loaded: loaded,
//             onTap: () => onPush(const ViewUploads()),
//           ),
//           const SizedBox(width: 10),
//           _StatTile(
//             value: caseCount, label: 'My\nCases',
//             icon: Icons.folder_open_rounded, color: _T.accentCyan,
//             loaded: loaded,
//             onTap: () => onPush(const ViewCasesPage()),
//           ),
//         ]),
//
//         const SizedBox(height: 12),
//
//         // Banner tip card
//         GestureDetector(
//           onTap: () => onPush(const ViewUploads()),
//           child: Container(
//             width: double.infinity,
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(16),
//               gradient: LinearGradient(
//                   colors: [_T.accentPurple.withOpacity(0.18), _T.card],
//                   begin: Alignment.topLeft, end: Alignment.bottomRight),
//               border: Border.all(color: _T.accentPurple.withOpacity(0.22)),
//             ),
//             child: Row(children: [
//               Container(width: 38, height: 38,
//                   decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       gradient: LinearGradient(colors: [
//                         _T.accentPurple, _T.accentBlue.withOpacity(0.7)]),
//                       boxShadow: [BoxShadow(color: _T.accentPurple.withOpacity(0.35),
//                           blurRadius: 10)]),
//                   child: const Icon(Icons.camera_alt_rounded,
//                       color: Colors.white, size: 18)),
//               const SizedBox(width: 12),
//               const Expanded(child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text('Spotted someone?', style: TextStyle(
//                       color: _T.textPrimary, fontSize: 13,
//                       fontWeight: FontWeight.w700)),
//                   SizedBox(height: 2),
//                   Text('Upload a photo — your tip could reunite a family.',
//                       style: TextStyle(color: _T.textSub, fontSize: 10.5),
//                       maxLines: 1, overflow: TextOverflow.ellipsis),
//                 ],
//               )),
//               const Icon(Icons.arrow_forward_ios_rounded,
//                   color: _T.accentPurple, size: 13),
//             ]),
//           ),
//         ),
//
//         const SizedBox(height: 20),
//       ]),
//     );
//   }
// }
//
// class _StatTile extends StatefulWidget {
//   final int value; final String label; final IconData icon;
//   final Color color; final bool loaded; final VoidCallback onTap;
//   const _StatTile({required this.value, required this.label,
//     required this.icon, required this.color,
//     required this.loaded, required this.onTap});
//   @override State<_StatTile> createState() => _StatTileState();
// }
// class _StatTileState extends State<_StatTile> with SingleTickerProviderStateMixin {
//   late final AnimationController _c;
//   late final Animation<double> _a;
//   bool _p = false;
//   @override void initState() { super.initState();
//   _c = AnimationController(vsync: this,
//       duration: const Duration(milliseconds: 900));
//   _a = CurvedAnimation(parent: _c, curve: Curves.easeOutCubic);
//   if (widget.loaded) _c.forward(); }
//   @override void didUpdateWidget(_StatTile old) { super.didUpdateWidget(old);
//   if (widget.loaded && !old.loaded) _c.forward(); }
//   @override void dispose() { _c.dispose(); super.dispose(); }
//
//   @override
//   Widget build(BuildContext context) => Expanded(child: GestureDetector(
//     onTap: widget.onTap,
//     onTapDown: (_) => setState(() => _p = true),
//     onTapUp: (_) => setState(() => _p = false),
//     onTapCancel: () => setState(() => _p = false),
//     child: AnimatedScale(scale: _p ? 0.94 : 1.0,
//         duration: const Duration(milliseconds: 110),
//         child: Container(
//           padding: const EdgeInsets.fromLTRB(12, 14, 12, 12),
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(18),
//               gradient: LinearGradient(
//                   colors: [widget.color.withOpacity(0.14), _T.card],
//                   begin: Alignment.topLeft, end: Alignment.bottomRight),
//               border: Border.all(color: widget.color.withOpacity(0.24))),
//           child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//             Icon(widget.icon, color: widget.color, size: 20),
//             const SizedBox(height: 10),
//             widget.loaded
//                 ? AnimatedBuilder(animation: _a, builder: (_, __) =>
//                 Text('${(_a.value * widget.value).round()}',
//                     style: TextStyle(color: widget.color,
//                         fontSize: 22, fontWeight: FontWeight.w800, height: 1)))
//                 : SizedBox(height: 22, width: 28,
//                 child: LinearProgressIndicator(minHeight: 3,
//                     color: widget.color.withOpacity(0.5),
//                     backgroundColor: widget.color.withOpacity(0.1))),
//             const SizedBox(height: 4),
//             Text(widget.label, style: const TextStyle(color: _T.textSub,
//                 fontSize: 9.5, height: 1.3),
//                 maxLines: 2, overflow: TextOverflow.ellipsis),
//           ]),
//         )),
//   ));
// }
//
// // ─────────────────────────────────────────────────────────────────────────────
// //  QUICK ACTIONS  — 2-column card grid (restored style)
// // ─────────────────────────────────────────────────────────────────────────────
// class _QItem {
//   final String label, sub; final IconData icon; final Color color;
//   final VoidCallback onTap;
//   const _QItem(this.label, this.sub, this.icon, this.color, this.onTap);
// }
//
// class _QuickGrid extends StatelessWidget {
//   final void Function(Widget) onPush;
//   const _QuickGrid({required this.onPush});
//
//   @override
//   Widget build(BuildContext context) {
//     final items = [
//       _QItem('Police Stations', 'Find nearby',      Icons.local_police_rounded,        _T.accentBlue,
//               () => onPush(const View_Police_Station(title: 'Police Stations'))),
//       _QItem('Missing Persons', 'View records',     Icons.person_search_rounded,        _T.accentPurple,
//               () => onPush(const ViewMissingPersonsPage())),
//       _QItem('Criminals',       'Wanted list',      Icons.gavel_rounded,                _T.accentRed,
//               () => onPush(const ViewCriminalsPage(shopId: ''))),
//       _QItem('Complaint',       'Send / track',     Icons.assignment_rounded,           _T.accentCyan,
//               () => onPush(const ComplaintPage(title: 'My Complaints'))),
//       _QItem('Feedback',        'Share thoughts',   Icons.rate_review_rounded,          const Color(0xFF00BFA5),
//               () => onPush(const FeedbackPage(title: 'My Feedbacks'))),
//       _QItem('My Uploads',      'View detections',  Icons.add_photo_alternate_rounded,  _T.accentGold,
//               () => onPush(const ViewUploads())),
//     ];
//
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 18),
//       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         Row(children: [
//           Container(width: 3, height: 18,
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(2),
//                   gradient: const LinearGradient(
//                       colors: [_T.accentCyan, _T.accentPurple],
//                       begin: Alignment.topCenter, end: Alignment.bottomCenter))),
//           const SizedBox(width: 8),
//           const Text('Quick Access', style: TextStyle(
//               color: _T.textPrimary, fontSize: 15, fontWeight: FontWeight.w800)),
//         ]),
//         const SizedBox(height: 14),
//         Column(children: [
//           Row(children: [
//             Expanded(child: _QCard(item: items[0])),
//             const SizedBox(width: 10),
//             Expanded(child: _QCard(item: items[1])),
//           ]),
//           const SizedBox(height: 10),
//           Row(children: [
//             Expanded(child: _QCard(item: items[2])),
//             const SizedBox(width: 10),
//             Expanded(child: _QCard(item: items[3])),
//           ]),
//           const SizedBox(height: 10),
//           Row(children: [
//             Expanded(child: _QCard(item: items[4])),
//             const SizedBox(width: 10),
//             Expanded(child: _QCard(item: items[5])),
//           ]),
//         ]),
//       ]),
//     );
//   }
// }
//
// class _QCard extends StatefulWidget {
//   final _QItem item;
//   const _QCard({required this.item});
//   @override State<_QCard> createState() => _QCardState();
// }
// class _QCardState extends State<_QCard> {
//   bool _p = false;
//   @override
//   Widget build(BuildContext context) => GestureDetector(
//     onTap: widget.item.onTap,
//     onTapDown: (_) => setState(() => _p = true),
//     onTapUp: (_) => setState(() => _p = false),
//     onTapCancel: () => setState(() => _p = false),
//     child: AnimatedScale(scale: _p ? 0.94 : 1.0,
//         duration: const Duration(milliseconds: 110),
//         child: Container(
//           height: 80,
//           padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(16),
//               gradient: LinearGradient(
//                   begin: Alignment.topLeft, end: Alignment.bottomRight,
//                   colors: [widget.item.color.withOpacity(0.14), _T.card]),
//               border: Border.all(color: widget.item.color.withOpacity(0.22))),
//           child: Row(children: [
//             Container(width: 38, height: 38,
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(12),
//                     gradient: LinearGradient(colors: [
//                       widget.item.color, widget.item.color.withOpacity(0.60)]),
//                     boxShadow: [BoxShadow(color: widget.item.color.withOpacity(0.30),
//                         blurRadius: 8, offset: const Offset(0, 2))]),
//                 child: Icon(widget.item.icon, color: Colors.white, size: 18)),
//             const SizedBox(width: 10),
//             Expanded(child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(widget.item.label, style: const TextStyle(
//                       color: _T.textPrimary, fontSize: 12.5,
//                       fontWeight: FontWeight.w700),
//                       overflow: TextOverflow.ellipsis, maxLines: 1),
//                   const SizedBox(height: 2),
//                   Text(widget.item.sub, style: const TextStyle(
//                       color: _T.textSub, fontSize: 10.5),
//                       overflow: TextOverflow.ellipsis, maxLines: 1),
//                 ])),
//             Icon(Icons.chevron_right_rounded,
//                 color: widget.item.color.withOpacity(0.45), size: 15),
//           ]),
//         )),
//   );
// }
//
// // ─────────────────────────────────────────────────────────────────────────────
// //  PERSON CAROUSEL — tapping a card navigates to that list page
// // ─────────────────────────────────────────────────────────────────────────────
// class _CarouselSection extends StatefulWidget {
//   final List<_PersonRecord> missing, criminals;
//   final bool loaded;
//   final void Function(Widget) onPush;
//   const _CarouselSection({required this.missing, required this.criminals,
//     required this.loaded, required this.onPush});
//   @override State<_CarouselSection> createState() => _CarouselSectionState();
// }
// class _CarouselSectionState extends State<_CarouselSection> {
//   bool _showMissing = true;
//
//   @override
//   Widget build(BuildContext context) {
//     final list   = _showMissing ? widget.missing   : widget.criminals;
//     final accent = _showMissing ? _T.accentGold    : _T.accentRed;
//     final title  = _showMissing ? 'Currently Missing' : 'Wanted Criminals';
//     final sub    = _showMissing ? 'Help bring them home' : 'Reported active cases';
//     final page   = _showMissing
//         ? const ViewMissingPersonsPage()
//         : const ViewCriminalsPage(shopId: '');
//
//     return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//       // Toggle
//       Padding(padding: const EdgeInsets.symmetric(horizontal: 20),
//           child: Container(height: 44,
//               decoration: BoxDecoration(color: _T.surface,
//                   borderRadius: BorderRadius.circular(14),
//                   border: Border.all(color: _T.glassBorder)),
//               child: Row(children: [
//                 _Tab('Missing', widget.missing.length, _showMissing, _T.accentGold,
//                         () => setState(() => _showMissing = true)),
//                 _Tab('Wanted',  widget.criminals.length, !_showMissing, _T.accentRed,
//                         () => setState(() => _showMissing = false)),
//               ]))),
//       const SizedBox(height: 14),
//
//       // Header
//       Padding(padding: const EdgeInsets.symmetric(horizontal: 20),
//           child: Row(children: [
//             _Hdr(title, sub),
//             const Spacer(),
//             if (!widget.loaded)
//               const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(
//                   strokeWidth: 2, color: _T.accentCyan))
//             else if (list.isNotEmpty)
//               GestureDetector(
//                 onTap: () => widget.onPush(page),
//                 child: Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//                     decoration: BoxDecoration(color: accent.withOpacity(0.10),
//                         borderRadius: BorderRadius.circular(20),
//                         border: Border.all(color: accent.withOpacity(0.28))),
//                     child: Row(mainAxisSize: MainAxisSize.min, children: [
//                       Text('${list.length} Active', style: TextStyle(
//                           color: accent, fontSize: 10, fontWeight: FontWeight.w700)),
//                       const SizedBox(width: 3),
//                       Icon(Icons.arrow_forward_ios_rounded, color: accent, size: 9),
//                     ])),
//               ),
//           ])),
//       const SizedBox(height: 10),
//
//       // Carousel
//       AnimatedSwitcher(duration: const Duration(milliseconds: 280),
//           child: KeyedSubtree(key: ValueKey(_showMissing),
//               child: !widget.loaded
//                   ? const SizedBox(height: 210, child: Center(
//                   child: CircularProgressIndicator(strokeWidth: 2, color: _T.accentCyan)))
//                   : list.isEmpty
//                   ? const SizedBox(height: 70, child: Center(
//                   child: Text('No records found.', style: TextStyle(color: _T.textSub))))
//                   : _PageView(list: list, accent: accent, isMissing: _showMissing,
//                   onPush: widget.onPush))),
//     ]);
//   }
// }
//
// class _Tab extends StatelessWidget {
//   final String label; final int count; final bool active;
//   final Color color; final VoidCallback onTap;
//   const _Tab(this.label, this.count, this.active, this.color, this.onTap);
//   @override
//   Widget build(BuildContext context) => Expanded(child: GestureDetector(
//     onTap: onTap,
//     child: AnimatedContainer(duration: const Duration(milliseconds: 200),
//         margin: const EdgeInsets.all(3),
//         decoration: BoxDecoration(
//             gradient: active ? LinearGradient(colors: [color.withOpacity(0.20), color.withOpacity(0.07)]) : null,
//             borderRadius: BorderRadius.circular(11),
//             border: active ? Border.all(color: color.withOpacity(0.32)) : null),
//         child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//           Text(label, style: TextStyle(color: active ? color : _T.textSub,
//               fontSize: 12.5, fontWeight: FontWeight.w700)),
//           const SizedBox(width: 5),
//           Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
//               decoration: BoxDecoration(color: active ? color.withOpacity(0.18) : _T.glassBorder,
//                   borderRadius: BorderRadius.circular(7)),
//               child: Text('$count', style: TextStyle(color: active ? color : _T.textSub,
//                   fontSize: 9.5, fontWeight: FontWeight.w800))),
//         ])),
//   ));
// }
//
// class _PageView extends StatefulWidget {
//   final List<_PersonRecord> list; final Color accent;
//   final bool isMissing; final void Function(Widget) onPush;
//   const _PageView({required this.list, required this.accent,
//     required this.isMissing, required this.onPush});
//   @override State<_PageView> createState() => _PageViewState();
// }
// class _PageViewState extends State<_PageView> {
//   late final PageController _pc;
//   int _cur = 0; bool _run = true;
//
//   @override void initState() { super.initState();
//   _pc = PageController(viewportFraction: 0.56); _auto(); }
//   @override void dispose() { _run = false; _pc.dispose(); super.dispose(); }
//
//   Future<void> _auto() async {
//     while (_run) {
//       await Future.delayed(const Duration(seconds: 3));
//       if (!mounted || !_run || widget.list.isEmpty) break;
//       final n = (_cur + 1) % widget.list.length;
//       if (mounted) {
//         setState(() => _cur = n);
//         if (_pc.hasClients) _pc.animateToPage(n,
//             duration: const Duration(milliseconds: 550), curve: Curves.easeInOutCubic);
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) => Column(children: [
//     SizedBox(height: 240,
//       child: PageView.builder(controller: _pc,
//           onPageChanged: (i) => setState(() => _cur = i),
//           itemCount: widget.list.length,
//           itemBuilder: (_, i) {
//             final p = widget.list[i];
//             return GestureDetector(
//               // - tapping a card navigates to the full list page
//               onTap: () => widget.onPush(widget.isMissing
//                   ? const ViewMissingPersonsPage()
//                   : const ViewCriminalsPage(shopId: '')),
//               child: AnimatedScale(scale: i == _cur ? 1.0 : 0.85,
//                   duration: const Duration(milliseconds: 380), curve: Curves.easeOutCubic,
//                   child: _PCard(p: p, active: i == _cur, accent: widget.accent,
//                       missing: widget.isMissing)),
//             );
//           }),
//     ),
//     const SizedBox(height: 10),
//     Row(mainAxisAlignment: MainAxisAlignment.center,
//         children: List.generate(widget.list.length, (i) => GestureDetector(
//             onTap: () { setState(() => _cur = i);
//             _pc.animateToPage(i, duration: const Duration(milliseconds: 380),
//                 curve: Curves.easeInOutCubic); },
//             child: AnimatedContainer(duration: const Duration(milliseconds: 280),
//                 margin: const EdgeInsets.symmetric(horizontal: 2.5),
//                 width: i == _cur ? 20 : 5, height: 5,
//                 decoration: BoxDecoration(borderRadius: BorderRadius.circular(3),
//                     gradient: i == _cur ? LinearGradient(colors: [widget.accent, _T.accentBlue]) : null,
//                     color: i == _cur ? null : _T.textSub.withOpacity(0.20)))))),
//   ]);
// }
//
// class _PCard extends StatefulWidget {
//   final _PersonRecord p; final bool active, missing; final Color accent;
//   const _PCard({required this.p, required this.active,
//     required this.accent, required this.missing});
//   @override State<_PCard> createState() => _PCardState();
// }
// class _PCardState extends State<_PCard> with SingleTickerProviderStateMixin {
//   late final AnimationController _s;
//   @override void initState() { super.initState();
//   _s = AnimationController(vsync:this, duration:const Duration(seconds:3))..repeat(); }
//   @override void dispose() { _s.dispose(); super.dispose(); }
//
//   @override
//   Widget build(BuildContext context) => Container(
//     margin: const EdgeInsets.symmetric(horizontal: 6),
//     decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(24),
//         gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
//             colors: [widget.accent.withOpacity(widget.active ? 0.15 : 0.04),
//               _T.card.withOpacity(widget.active ? 1 : 0.55)]),
//         border: Border.all(
//             color: widget.active ? widget.accent.withOpacity(0.40) : _T.glassBorder,
//             width: widget.active ? 1.5 : 0.8),
//         boxShadow: widget.active ? [BoxShadow(color: widget.accent.withOpacity(0.18),
//             blurRadius: 22, offset: const Offset(0, 6))] : []),
//     child: ClipRRect(borderRadius: BorderRadius.circular(24),
//         child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//             child: Padding(padding: const EdgeInsets.fromLTRB(12,14,12,12),
//                 child: Column(mainAxisSize: MainAxisSize.min, children: [
//                   // spinning arc + photo
//                   AnimatedBuilder(animation: _s,
//                       builder: (_, child) => CustomPaint(
//                           painter: _SpinP(_s.value, widget.active, widget.accent), child: child),
//                       child: Container(width: 82, height: 82, margin: const EdgeInsets.all(5),
//                           decoration: BoxDecoration(shape: BoxShape.circle,
//                               border: Border.all(color: widget.active
//                                   ? widget.accent.withOpacity(0.45) : _T.glassBorder, width: 1.8)),
//                           child: ClipOval(child: _Img(url: widget.p.photoUrl, size: 82)))),
//                   const SizedBox(height: 8),
//                   // badge
//                   if (widget.active)
//                     Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//                         decoration: BoxDecoration(color: widget.accent.withOpacity(0.12),
//                             borderRadius: BorderRadius.circular(18),
//                             border: Border.all(color: widget.accent.withOpacity(0.32))),
//                         child: Row(mainAxisSize: MainAxisSize.min, children: [
//                           Icon(Icons.circle, color: widget.accent, size: 4),
//                           const SizedBox(width: 3),
//                           Text(widget.missing ? 'MISSING' : 'WANTED',
//                               style: TextStyle(color: widget.accent, fontSize: 8,
//                                   fontWeight: FontWeight.w800, letterSpacing: 1.2)),
//                         ])),
//                   const SizedBox(height: 7),
//                   Text(widget.p.name, style: const TextStyle(color: _T.textPrimary,
//                       fontSize: 13, fontWeight: FontWeight.w700),
//                       textAlign: TextAlign.center, overflow: TextOverflow.ellipsis, maxLines: 1),
//                   const SizedBox(height: 2),
//                   Text('Age ${widget.p.age}  -  ${widget.p.gender}',
//                       style: const TextStyle(color: _T.textSub, fontSize: 9.5),
//                       textAlign: TextAlign.center, overflow: TextOverflow.ellipsis, maxLines: 1),
//                   const SizedBox(height: 6),
//                   // tap hint
//                   if (widget.active)
//                     Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//                       Icon(Icons.touch_app_rounded, color: widget.accent.withOpacity(0.5), size: 11),
//                       const SizedBox(width: 3),
//                       Text('Tap to view all', style: TextStyle(color: widget.accent.withOpacity(0.5),
//                           fontSize: 9, fontWeight: FontWeight.w600)),
//                     ]),
//                 ])))),
//   );
// }
//
// // ─────────────────────────────────────────────────────────────────────────────
// //  NETWORK IMAGE
// // ─────────────────────────────────────────────────────────────────────────────
// class _Img extends StatelessWidget {
//   final String url; final double size;
//   const _Img({required this.url, required this.size});
//   @override
//   Widget build(BuildContext context) {
//     if (url.isEmpty) return _ph();
//     return Image.network(url, width: size, height: size, fit: BoxFit.cover,
//       loadingBuilder: (_, child, prog) {
//         if (prog == null) return child;
//         return Container(color: _T.glass,
//             child: Center(child: SizedBox(width: 20, height: 20,
//                 child: CircularProgressIndicator(strokeWidth: 2, color: _T.accentCyan,
//                     value: prog.expectedTotalBytes != null
//                         ? prog.cumulativeBytesLoaded / prog.expectedTotalBytes! : null))));
//       },
//       errorBuilder: (_, __, ___) => _ph(),
//     );
//   }
//   Widget _ph() => Container(color: _T.glass,
//       child: const Icon(Icons.person_rounded, color: _T.textSub, size: 34));
// }
//
// // ─────────────────────────────────────────────────────────────────────────────
// //  MY CASES
// // ─────────────────────────────────────────────────────────────────────────────
// class _CasesSection extends StatelessWidget {
//   final List<_CaseRecord> cases; final bool loaded;
//   final void Function(Widget) onPush;
//   const _CasesSection({required this.cases, required this.loaded, required this.onPush});
//
//   Color _c(String p) { final l=p.toLowerCase();
//   if (l=='resolved'||l=='completed') return _T.accentGreen;
//   if (l=='investigating'||l=='in progress') return _T.accentGold;
//   return _T.accentBlue; }
//   double _pct(String p) { final l=p.toLowerCase();
//   if (l=='resolved'||l=='completed') return 1.0;
//   if (l=='investigating'||l=='in progress') return 0.55;
//   return 0.20; }
//
//   @override
//   Widget build(BuildContext context) => Padding(
//     padding: const EdgeInsets.symmetric(horizontal: 20),
//     child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//       Row(children: [
//         const _Hdr('My Reported Cases', 'Track your submissions'),
//         const Spacer(),
//         _ViewAll('View All', _T.accentBlue, () => onPush(const ViewCasesPage())),
//       ]),
//       const SizedBox(height: 12),
//       if (!loaded) const _Shimmer()
//       else if (cases.isEmpty)
//         _Empty(Icons.assignment_outlined, 'No cases filed yet',
//             'Use Report Case to submit one', _T.accentBlue)
//       else ...cases.take(3).map((c) {
//           final col = _c(c.progress);
//           return Container(margin: const EdgeInsets.only(bottom: 10),
//               padding: const EdgeInsets.all(13),
//               decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),
//                   gradient: LinearGradient(colors: [col.withOpacity(0.07), _T.card],
//                       begin: Alignment.topLeft, end: Alignment.bottomRight),
//                   border: Border.all(color: col.withOpacity(0.20))),
//               child: Row(children: [
//                 ClipRRect(borderRadius: BorderRadius.circular(9),
//                     child: SizedBox(width: 42, height: 42,
//                         child: c.photoUrl.isNotEmpty ? _Img(url: c.photoUrl, size: 42)
//                             : Container(color: col.withOpacity(0.14),
//                             child: Icon(Icons.report_problem_outlined, color: col, size: 20)))),
//                 const SizedBox(width: 11),
//                 Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//                   Row(children: [
//                     Expanded(child: Text(c.description,
//                         style: const TextStyle(color: _T.textPrimary, fontSize: 12,
//                             fontWeight: FontWeight.w600),
//                         overflow: TextOverflow.ellipsis, maxLines: 1)),
//                     const SizedBox(width: 6),
//                     Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                         decoration: BoxDecoration(color: col.withOpacity(0.12),
//                             borderRadius: BorderRadius.circular(6),
//                             border: Border.all(color: col.withOpacity(0.25))),
//                         child: Text(c.status, style: TextStyle(color: col,
//                             fontSize: 8.5, fontWeight: FontWeight.w800))),
//                   ]),
//                   const SizedBox(height: 3),
//                   Text('${c.station}  -  ${c.date}',
//                       style: const TextStyle(color: _T.textSub, fontSize: 9.5)),
//                   const SizedBox(height: 6),
//                   Row(children: [
//                     Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(3),
//                         child: LinearProgressIndicator(value: _pct(c.progress), minHeight: 3,
//                             backgroundColor: col.withOpacity(0.10),
//                             valueColor: AlwaysStoppedAnimation(col)))),
//                     const SizedBox(width: 8),
//                     Text(c.progress, style: TextStyle(color: col, fontSize: 9,
//                         fontWeight: FontWeight.w600)),
//                   ]),
//                 ])),
//               ]));
//         }),
//     ]),
//   );
// }
//
// // ─────────────────────────────────────────────────────────────────────────────
// //  MY DETECTIONS — tap navigates to ViewUploads
// // ─────────────────────────────────────────────────────────────────────────────
// class _DetectionsSection extends StatelessWidget {
//   final List<_Detection> detections; final bool loaded;
//   final void Function(Widget) onPush;
//   const _DetectionsSection({required this.detections,
//     required this.loaded, required this.onPush});
//
//   @override
//   Widget build(BuildContext context) => Padding(
//     padding: const EdgeInsets.symmetric(horizontal: 20),
//     child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//       Row(children: [
//         const _Hdr('My Detections', 'Matches from your uploads'),
//         const Spacer(),
//         _ViewAll('View All', _T.accentPurple, () => onPush(const ViewUploads())),
//       ]),
//       const SizedBox(height: 12),
//       if (!loaded) const _Shimmer()
//       else if (detections.isEmpty)
//         _Empty(Icons.image_search_outlined, 'No detections yet',
//             'Upload a photo to check for matches', _T.accentPurple)
//       else SizedBox(height: 124,
//             child: ListView.separated(scrollDirection: Axis.horizontal,
//                 itemCount: detections.take(8).length,
//                 separatorBuilder: (_, __) => const SizedBox(width: 10),
//                 itemBuilder: (_, i) {
//                   final d = detections[i];
//                   final miss = d.category.toLowerCase().contains('missing');
//                   final ac = miss ? _T.accentGold : _T.accentRed;
//                   return GestureDetector(
//                     onTap: () => onPush(const ViewUploads()),  // navigate to uploads page
//                     child: Container(width: 124,
//                         padding: const EdgeInsets.all(10),
//                         decoration: BoxDecoration(borderRadius: BorderRadius.circular(14),
//                             gradient: LinearGradient(colors: [ac.withOpacity(0.11), _T.card]),
//                             border: Border.all(color: ac.withOpacity(0.22))),
//                         child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//                           Row(children: [
//                             ClipRRect(borderRadius: BorderRadius.circular(7),
//                                 child: SizedBox(width: 34, height: 34,
//                                     child: _Img(url: d.photoUrl, size: 34))),
//                             const Spacer(),
//                             Icon(miss ? Icons.person_search_rounded : Icons.gavel_rounded,
//                                 color: ac, size: 14),
//                           ]),
//                           const SizedBox(height: 7),
//                           Text(d.name.isEmpty ? 'Unknown' : d.name,
//                               style: const TextStyle(color: _T.textPrimary,
//                                   fontSize: 11, fontWeight: FontWeight.w700),
//                               overflow: TextOverflow.ellipsis, maxLines: 1),
//                           const SizedBox(height: 1),
//                           Text(d.category, style: TextStyle(color: ac,
//                               fontSize: 9, fontWeight: FontWeight.w600)),
//                           const SizedBox(height: 1),
//                           Text(d.date, style: const TextStyle(color: _T.textSub, fontSize: 8.5)),
//                         ])),
//                   );
//                 })),
//     ]),
//   );
// }
//
// // ─────────────────────────────────────────────────────────────────────────────
// //  COMPLAINTS ACCORDION
// // ─────────────────────────────────────────────────────────────────────────────
// class _ComplaintsAccordion extends StatefulWidget {
//   final List<_ComplaintRecord> complaints; final bool loaded;
//   final void Function(Widget) onPush;
//   const _ComplaintsAccordion({required this.complaints,
//     required this.loaded, required this.onPush});
//   @override State<_ComplaintsAccordion> createState() => _ComplaintsAccordionState();
// }
// class _ComplaintsAccordionState extends State<_ComplaintsAccordion> {
//   bool _open = false; int? _idx;
//
//   @override
//   Widget build(BuildContext context) {
//     final pending = widget.complaints.where((c) => c.reply.toLowerCase()=='pending').length;
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         // Header
//         GestureDetector(
//           onTap: () => setState(() { _open = !_open; _idx = null; }),
//           child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
//               decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),
//                   gradient: LinearGradient(colors: [_T.accentCyan.withOpacity(0.09), _T.card]),
//                   border: Border.all(color: _T.accentCyan.withOpacity(0.20))),
//               child: Row(children: [
//                 Container(width: 34, height: 34,
//                     decoration: BoxDecoration(shape: BoxShape.circle,
//                         gradient: LinearGradient(colors: [_T.accentCyan, _T.accentBlue.withOpacity(0.7)])),
//                     child: const Icon(Icons.assignment_rounded, color: Colors.white, size: 17)),
//                 const SizedBox(width: 11),
//                 Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//                   const Text('My Complaints', style: TextStyle(color: _T.textPrimary,
//                       fontSize: 14, fontWeight: FontWeight.w700)),
//                   Text(widget.loaded
//                       ? '${widget.complaints.length} submission${widget.complaints.length==1?'':'s'}'
//                       : 'Loading...', style: const TextStyle(color: _T.textSub, fontSize: 10.5)),
//                 ])),
//                 if (widget.loaded && pending > 0)
//                   Container(margin: const EdgeInsets.only(right: 8),
//                       padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
//                       decoration: BoxDecoration(color: _T.accentGold.withOpacity(0.14),
//                           borderRadius: BorderRadius.circular(9),
//                           border: Border.all(color: _T.accentGold.withOpacity(0.32))),
//                       child: Text('$pending pending', style: const TextStyle(
//                           color: _T.accentGold, fontSize: 9, fontWeight: FontWeight.w700))),
//                 AnimatedRotation(turns: _open ? 0.5 : 0,
//                     duration: const Duration(milliseconds: 240),
//                     child: const Icon(Icons.keyboard_arrow_down_rounded,
//                         color: _T.accentCyan, size: 20)),
//               ])),
//         ),
//         // Body
//         AnimatedCrossFade(
//           duration: const Duration(milliseconds: 320),
//           crossFadeState: _open ? CrossFadeState.showSecond : CrossFadeState.showFirst,
//           firstChild: const SizedBox.shrink(),
//           secondChild: Padding(padding: const EdgeInsets.only(top: 9),
//               child: Column(children: [
//                 if (!widget.loaded) const _Shimmer()
//                 else if (widget.complaints.isEmpty)
//                   _Empty(Icons.assignment_outlined, 'No complaints filed',
//                       'Tap Complaint in Quick Actions', _T.accentCyan)
//                 else ...[
//                     ...widget.complaints.asMap().entries.map((e) {
//                       final i = e.key; final c = e.value;
//                       final rep = c.reply.toLowerCase() != 'pending';
//                       final ac  = rep ? _T.accentGreen : _T.accentGold;
//                       final isOpen = _idx == i;
//                       return GestureDetector(
//                         onTap: () => setState(() => _idx = isOpen ? null : i),
//                         child: Container(margin: const EdgeInsets.only(bottom: 7),
//                           decoration: BoxDecoration(borderRadius: BorderRadius.circular(13),
//                               color: _T.card,
//                               border: Border.all(color: ac.withOpacity(isOpen ? 0.32 : 0.16))),
//                           child: Column(children: [
//                             Padding(padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
//                                 child: Row(children: [
//                                   Container(width: 7, height: 7, decoration: BoxDecoration(
//                                       shape: BoxShape.circle, color: ac,
//                                       boxShadow: [BoxShadow(color: ac.withOpacity(0.45), blurRadius: 4)])),
//                                   const SizedBox(width: 9),
//                                   Expanded(child: Text(c.description,
//                                       style: const TextStyle(color: _T.textPrimary,
//                                           fontSize: 12, fontWeight: FontWeight.w600),
//                                       overflow: TextOverflow.ellipsis, maxLines: 1)),
//                                   const SizedBox(width: 7),
//                                   Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                                       decoration: BoxDecoration(color: ac.withOpacity(0.11),
//                                           borderRadius: BorderRadius.circular(7),
//                                           border: Border.all(color: ac.withOpacity(0.25))),
//                                       child: Row(mainAxisSize: MainAxisSize.min, children: [
//                                         Icon(rep ? Icons.check_circle_outline_rounded
//                                             : Icons.hourglass_empty_rounded, color: ac, size: 9),
//                                         const SizedBox(width: 2),
//                                         Text(rep ? 'Replied' : 'Pending',
//                                             style: TextStyle(color: ac, fontSize: 8.5,
//                                                 fontWeight: FontWeight.w700)),
//                                       ])),
//                                   const SizedBox(width: 5),
//                                   AnimatedRotation(turns: isOpen ? 0.5 : 0,
//                                       duration: const Duration(milliseconds: 180),
//                                       child: const Icon(Icons.expand_more_rounded,
//                                           color: _T.textSub, size: 16)),
//                                 ])),
//                             AnimatedCrossFade(
//                               duration: const Duration(milliseconds: 220),
//                               crossFadeState: isOpen ? CrossFadeState.showSecond : CrossFadeState.showFirst,
//                               firstChild: const SizedBox.shrink(),
//                               secondChild: Padding(
//                                 padding: const EdgeInsets.fromLTRB(13, 0, 13, 11),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Divider(color: _T.glassBorder, height: 14),
//                                     Text(c.description, style: const TextStyle(
//                                         color: _T.textMid, fontSize: 11.5, height: 1.5)),
//                                     if (rep) ...[
//                                       const SizedBox(height: 8),
//                                       Container(
//                                         padding: const EdgeInsets.all(9),
//                                         decoration: BoxDecoration(
//                                           color: _T.accentGreen.withOpacity(0.05),
//                                           borderRadius: BorderRadius.circular(9),
//                                           border: Border.all(color: _T.accentGreen.withOpacity(0.13)),
//                                         ),
//                                         child: Row(
//                                           crossAxisAlignment: CrossAxisAlignment.start,
//                                           children: [
//                                             const Icon(Icons.reply_rounded, color: _T.accentGreen, size: 13),
//                                             const SizedBox(width: 5),
//                                             Expanded(child: Text(c.reply, style: const TextStyle(
//                                                 color: _T.textMid, fontSize: 11, height: 1.4))),
//                                           ],
//                                         ),
//                                       ),
//                                     ],
//                                     const SizedBox(height: 5),
//                                     Text(c.date, style: const TextStyle(
//                                         color: _T.textSub, fontSize: 9.5)),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ]),   // Column children
//                         ),       // Container
//                       );         // GestureDetector
//                     }),           // map
//                     const SizedBox(height: 3),
//                     GestureDetector(
//                       onTap: () => widget.onPush(const ComplaintPage(title: 'My Complaints')),
//                       child: Container(width: double.infinity,
//                           padding: const EdgeInsets.symmetric(vertical: 10),
//                           decoration: BoxDecoration(borderRadius: BorderRadius.circular(11),
//                               color: _T.accentCyan.withOpacity(0.07),
//                               border: Border.all(color: _T.accentCyan.withOpacity(0.18))),
//                           child: const Center(child: Text('Manage All Complaints',
//                               style: TextStyle(color: _T.accentCyan,
//                                   fontSize: 11.5, fontWeight: FontWeight.w700)))),
//                     ),
//                   ],
//               ])),
//         ),
//       ]),
//     );
//   }
// }
//
// // ─────────────────────────────────────────────────────────────────────────────
// //  REPORTS TAB
// // ─────────────────────────────────────────────────────────────────────────────
// class _ReportsTab extends StatelessWidget {
//   const _ReportsTab();
//   @override
//   Widget build(BuildContext context) => SingleChildScrollView(
//     physics: const BouncingScrollPhysics(),
//     padding: const EdgeInsets.fromLTRB(20, 28, 20, 120),
//     child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//       const _Hdr('Reports', 'Submit & track your activity'),
//       const SizedBox(height: 24),
//       _RRow(Icons.assignment_rounded, 'My Complaints', 'View and manage your complaints',
//           _T.accentBlue, () => Navigator.push(context,
//               _slide(const ComplaintPage(title: 'My Complaints')))),
//       const SizedBox(height: 12),
//       _RRow(Icons.report_problem_rounded, 'Report Case', 'Report a missing person',
//           _T.accentRed, () => Navigator.push(context, _slide(const ReportCasePage()))),
//       const SizedBox(height: 12),
//       _RRow(Icons.rate_review_rounded, 'My Feedback', 'Share your experience',
//           _T.accentPurple, () => Navigator.push(context,
//               _slide(const FeedbackPage(title: 'My Feedbacks')))),
//       const SizedBox(height: 12),
//       _RRow(Icons.image_search_rounded, 'My Uploads', 'View submitted detections',
//           _T.accentCyan, () => Navigator.push(context, _slide(const ViewUploads()))),
//     ]),
//   );
// }
//
// class _RRow extends StatefulWidget {
//   final IconData i; final String t, s; final Color c; final VoidCallback onTap;
//   const _RRow(this.i, this.t, this.s, this.c, this.onTap);
//   @override State<_RRow> createState() => _RRowState();
// }
// class _RRowState extends State<_RRow> {
//   bool _p = false;
//   @override
//   Widget build(BuildContext context) => GestureDetector(
//       onTap: widget.onTap,
//       onTapDown: (_) => setState(() => _p = true),
//       onTapUp: (_) => setState(() => _p = false),
//       onTapCancel: () => setState(() => _p = false),
//       child: AnimatedScale(scale: _p ? 0.97 : 1.0, duration: const Duration(milliseconds: 100),
//           child: Container(padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(borderRadius: BorderRadius.circular(16),
//                   gradient: LinearGradient(colors: [widget.c.withOpacity(0.11), _T.card],
//                       begin: Alignment.topLeft, end: Alignment.bottomRight),
//                   border: Border.all(color: widget.c.withOpacity(0.25))),
//               child: Row(children: [
//                 Container(width: 44, height: 44,
//                     decoration: BoxDecoration(shape: BoxShape.circle,
//                         gradient: LinearGradient(colors: [widget.c, widget.c.withOpacity(0.6)])),
//                     child: Icon(widget.i, color: Colors.white, size: 21)),
//                 const SizedBox(width: 14),
//                 Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//                   Text(widget.t, style: const TextStyle(color: _T.textPrimary,
//                       fontSize: 14, fontWeight: FontWeight.w700)),
//                   const SizedBox(height: 2),
//                   Text(widget.s, style: const TextStyle(color: _T.textSub, fontSize: 11.5)),
//                 ])),
//                 Icon(Icons.arrow_forward_ios_rounded, color: widget.c.withOpacity(0.55), size: 14),
//               ]))));
// }
//
// // ─────────────────────────────────────────────────────────────────────────────
// //  PICK DIALOG (nav index 3)
// // ─────────────────────────────────────────────────────────────────────────────
// class _PickDialog extends StatelessWidget {
//   final VoidCallback onMissing, onCriminal;
//   const _PickDialog({required this.onMissing, required this.onCriminal});
//   @override
//   Widget build(BuildContext context) => Center(child: Material(color: Colors.transparent,
//       child: ClipRRect(borderRadius: BorderRadius.circular(28),
//           child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 26, sigmaY: 26),
//               child: Container(width: MediaQuery.of(context).size.width * 0.84,
//                   padding: const EdgeInsets.all(24),
//                   decoration: BoxDecoration(color: const Color(0xFF080F26).withOpacity(0.97),
//                       borderRadius: BorderRadius.circular(28),
//                       border: Border.all(color: _T.glassBorder),
//                       boxShadow: [BoxShadow(color: _T.accentBlue.withOpacity(0.18), blurRadius: 40)]),
//                   child: Column(mainAxisSize: MainAxisSize.min, children: [
//                     Container(width: 36, height: 4,
//                         decoration: BoxDecoration(color: _T.textSub.withOpacity(0.35),
//                             borderRadius: BorderRadius.circular(2))),
//                     const SizedBox(height: 18),
//                     ShaderMask(shaderCallback: (r) => const LinearGradient(
//                         colors: [_T.textPrimary, _T.accentCyan]).createShader(r),
//                         child: const Text('Browse Records', style: TextStyle(color: Colors.white,
//                             fontSize: 19, fontWeight: FontWeight.w800))),
//                     const SizedBox(height: 4),
//                     const Text('Select a category', style: TextStyle(color: _T.textSub, fontSize: 12)),
//                     const SizedBox(height: 20),
//                     _DRow(Icons.person_search_rounded, 'Missing Persons',
//                         'Browse active missing persons', _T.accentBlue, onMissing),
//                     const SizedBox(height: 10),
//                     _DRow(Icons.gavel_rounded, 'Criminal Records',
//                         'View criminal cases & files', _T.accentPurple, onCriminal),
//                   ]))))));
// }
//
// class _DRow extends StatefulWidget {
//   final IconData i; final String t, s; final Color c; final VoidCallback onTap;
//   const _DRow(this.i, this.t, this.s, this.c, this.onTap);
//   @override State<_DRow> createState() => _DRowState();
// }
// class _DRowState extends State<_DRow> {
//   bool _p = false;
//   @override
//   Widget build(BuildContext context) => GestureDetector(
//       onTap: widget.onTap,
//       onTapDown: (_) => setState(() => _p = true),
//       onTapUp: (_) => setState(() => _p = false),
//       onTapCancel: () => setState(() => _p = false),
//       child: AnimatedScale(scale: _p ? 0.97 : 1.0, duration: const Duration(milliseconds: 100),
//           child: Container(padding: const EdgeInsets.all(13),
//               decoration: BoxDecoration(borderRadius: BorderRadius.circular(14),
//                   color: widget.c.withOpacity(0.09),
//                   border: Border.all(color: widget.c.withOpacity(0.25))),
//               child: Row(children: [
//                 Container(width: 42, height: 42,
//                     decoration: BoxDecoration(shape: BoxShape.circle,
//                         gradient: LinearGradient(colors: [widget.c, widget.c.withOpacity(0.55)])),
//                     child: Icon(widget.i, color: Colors.white, size: 19)),
//                 const SizedBox(width: 12),
//                 Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//                   Text(widget.t, style: const TextStyle(color: _T.textPrimary,
//                       fontSize: 13.5, fontWeight: FontWeight.w700)),
//                   const SizedBox(height: 2),
//                   Text(widget.s, style: const TextStyle(color: _T.textSub, fontSize: 10.5)),
//                 ])),
//                 Icon(Icons.arrow_forward_ios_rounded, color: widget.c, size: 12),
//               ]))));
// }
//
// // ─────────────────────────────────────────────────────────────────────────────
// //  SHARED SMALL WIDGETS
// // ─────────────────────────────────────────────────────────────────────────────
// class _Hdr extends StatelessWidget {
//   final String t, s; const _Hdr(this.t, this.s);
//   @override
//   Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//     ShaderMask(shaderCallback: (r) => const LinearGradient(
//         colors: [_T.textPrimary, _T.accentCyan]).createShader(r),
//         child: Text(t, style: const TextStyle(color: Colors.white,
//             fontSize: 17, fontWeight: FontWeight.w800))),
//     Text(s, style: const TextStyle(color: _T.textSub, fontSize: 11.5)),
//   ]);
// }
//
// class _ViewAll extends StatelessWidget {
//   final String label; final Color color; final VoidCallback onTap;
//   const _ViewAll(this.label, this.color, this.onTap);
//   @override
//   Widget build(BuildContext context) => GestureDetector(
//       onTap: onTap,
//       child: Container(padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
//           decoration: BoxDecoration(color: color.withOpacity(0.09),
//               borderRadius: BorderRadius.circular(9),
//               border: Border.all(color: color.withOpacity(0.22))),
//           child: Text(label, style: TextStyle(color: color, fontSize: 11,
//               fontWeight: FontWeight.w700))));
// }
//
// class _Empty extends StatelessWidget {
//   final IconData icon; final String msg, sub; final Color color;
//   const _Empty(this.icon, this.msg, this.sub, this.color);
//   @override
//   Widget build(BuildContext context) => Container(width: double.infinity,
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(color: color.withOpacity(0.04),
//           borderRadius: BorderRadius.circular(14),
//           border: Border.all(color: color.withOpacity(0.13))),
//       child: Column(children: [
//         Icon(icon, color: color.withOpacity(0.35), size: 30),
//         const SizedBox(height: 8),
//         Text(msg, style: TextStyle(color: color.withOpacity(0.65),
//             fontSize: 12.5, fontWeight: FontWeight.w600)),
//         const SizedBox(height: 3),
//         Text(sub, style: const TextStyle(color: _T.textSub, fontSize: 10.5),
//             textAlign: TextAlign.center),
//       ]));
// }
//
// class _Shimmer extends StatefulWidget {
//   const _Shimmer();
//   @override State<_Shimmer> createState() => _ShimmerState();
// }
// class _ShimmerState extends State<_Shimmer> with SingleTickerProviderStateMixin {
//   late final AnimationController _c;
//   @override void initState() { super.initState();
//   _c = AnimationController(vsync:this, duration:const Duration(milliseconds:1100))..repeat(); }
//   @override void dispose() { _c.dispose(); super.dispose(); }
//   @override
//   Widget build(BuildContext context) => AnimatedBuilder(animation: _c,
//       builder: (_, __) => Column(children: List.generate(2, (_) => Container(
//           margin: const EdgeInsets.only(bottom: 9), height: 60,
//           decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),
//               gradient: LinearGradient(begin: Alignment(_c.value*2-1, 0),
//                   end: Alignment(_c.value*2+1, 0),
//                   colors: [_T.card, _T.surface, _T.card]))))));
// }
//
// // ─────────────────────────────────────────────────────────────────────────────
// //  ANIMATED BACKGROUND
// // ─────────────────────────────────────────────────────────────────────────────
// class _Bg extends StatefulWidget {
//   const _Bg();
//   @override State<_Bg> createState() => _BgState();
// }
// class _BgState extends State<_Bg> with SingleTickerProviderStateMixin {
//   late final AnimationController _c;
//   @override void initState() { super.initState();
//   _c = AnimationController(vsync:this, duration:const Duration(seconds:12))..repeat(); }
//   @override void dispose() { _c.dispose(); super.dispose(); }
//   @override
//   Widget build(BuildContext context) => AnimatedBuilder(animation: _c,
//       builder: (_, __) => CustomPaint(painter: _BgP(_c.value),
//           size: Size.infinite, child: const SizedBox.expand()));
// }
//
// // ─────────────────────────────────────────────────────────────────────────────
// //  PAINTERS
// // ─────────────────────────────────────────────────────────────────────────────
// class _ArcP extends CustomPainter {
//   final double a; final Color c;
//   _ArcP(this.a, this.c);
//   @override
//   void paint(Canvas cv, Size s) {
//     final r = Rect.fromCircle(center: Offset(s.width/2,s.height/2), radius: s.width/2-1.5);
//     cv.drawArc(r, a, math.pi*1.5, false, Paint()
//       ..shader = SweepGradient(colors:[c.withOpacity(0.6),Colors.transparent],
//           transform: GradientRotation(a)).createShader(r)
//       ..style = PaintingStyle.stroke ..strokeWidth = 2.4 ..strokeCap = StrokeCap.round);
//   }
//   @override bool shouldRepaint(_ArcP o) => o.a != a;
// }
//
// class _SpinP extends CustomPainter {
//   final double t; final bool active; final Color c;
//   _SpinP(this.t, this.active, this.c);
//   @override
//   void paint(Canvas cv, Size s) {
//     if (!active) return;
//     final center = Offset(s.width/2, s.height/2);
//     final ang = t * 2 * math.pi;
//     cv.drawArc(Rect.fromCircle(center:center, radius:s.width/2),
//         ang, math.pi*1.35, false, Paint()
//           ..color=c.withOpacity(0.50) ..style=PaintingStyle.stroke
//           ..strokeWidth=2.6 ..strokeCap=StrokeCap.round);
//     cv.drawArc(Rect.fromCircle(center:center, radius:s.width/2),
//         ang+math.pi, math.pi*0.5, false, Paint()
//           ..color=c.withOpacity(0.16) ..style=PaintingStyle.stroke
//           ..strokeWidth=1.5 ..strokeCap=StrokeCap.round);
//   }
//   @override bool shouldRepaint(_SpinP o) => o.t!=t || o.active!=active;
// }
//
// class _BgP extends CustomPainter {
//   final double t; _BgP(this.t);
//   @override
//   void paint(Canvas c, Size s) {
//     c.drawRect(Rect.fromLTWH(0,0,s.width,s.height), Paint()..color=_T.bg);
//     void g(double fx,double fy,double r,Color col,double op){
//       final a=t*2*math.pi;
//       final x=s.width*(fx+0.07*math.sin(a+fy*3));
//       final y=s.height*(fy+0.06*math.cos(a+fx*2));
//       c.drawCircle(Offset(x,y),s.width*r,Paint()
//         ..shader=RadialGradient(colors:[col.withOpacity(op),Colors.transparent])
//             .createShader(Rect.fromCircle(center:Offset(x,y),radius:s.width*r)));
//     }
//     g(0.82,0.06,0.44,_T.accentBlue,0.16);
//     g(0.12,0.88,0.38,_T.accentPurple,0.11);
//     g(0.50,0.44,0.20,_T.accentCyan,0.05);
//   }
//   @override bool shouldRepaint(_BgP o) => o.t!=t;
// }
//
// // ─────────────────────────────────────────────────────────────────────────────
// //  SLIDE ROUTE
// // ─────────────────────────────────────────────────────────────────────────────
// PageRoute _slide(Widget page) => PageRouteBuilder(
//   pageBuilder: (_, __, ___) => page,
//   transitionsBuilder: (_, a, __, child) => SlideTransition(
//       position: Tween<Offset>(begin:const Offset(1,0), end:Offset.zero)
//           .animate(CurvedAnimation(parent:a, curve:Curves.easeOutCubic)),
//       child: child),
//   transitionDuration: const Duration(milliseconds: 340),
// );