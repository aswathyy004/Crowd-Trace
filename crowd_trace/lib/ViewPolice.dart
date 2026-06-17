// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
//
// class ViewPolicepage extends StatefulWidget {
//
//   final String stationId;
//
//   const ViewPolicepage({
//     super.key,
//     required this.stationId,
//   });
//
//   @override
//   State<ViewPolicepage> createState() => _ViewPolicepageState();
// }
//
// class _ViewPolicepageState extends State<ViewPolicepage> {
//
//   List<String> name_ = [];
//   List<String> address_ = [];
//   List<String> phone_ = [];
//   List<String> designation_ = [];
//
//   @override
//   void initState() {
//     super.initState();
//     fetchPolice();
//   }
//
//   Future<void> fetchPolice() async {
//
//     SharedPreferences sh = await SharedPreferences.getInstance();
//     String urls = sh.getString('url') ?? '';
//
//     String url = '$urls/ViewPolice/';
//
//     var response = await http.post(
//       Uri.parse(url),
//       body: {
//         'station_id': widget.stationId,
//       },
//     );
//
//     var jsonData = json.decode(response.body);
//
//     if (jsonData['status'] == 'ok') {
//
//       var arr = jsonData['data'];
//
//       List<String> n = [];
//       List<String> a = [];
//       List<String> p = [];
//       List<String> d = [];
//
//       for (int i = 0; i < arr.length; i++) {
//         n.add(arr[i]['full_name'].toString());
//         a.add(arr[i]['address'].toString());
//         p.add(arr[i]['phone'].toString());
//         d.add(arr[i]['designation'].toString());
//       }
//
//       setState(() {
//         name_ = n;
//         address_ = a;
//         phone_ = p;
//         designation_ = d;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Police List"),
//       ),
//       body: name_.isEmpty
//           ? const Center(child: Text("No Police Found"))
//           : ListView.builder(
//         itemCount: name_.length,
//         itemBuilder: (context, index) {
//           return Card(
//             margin: const EdgeInsets.all(10),
//             child: Padding(
//               padding: const EdgeInsets.all(15),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text("Name: ${name_[index]}"),
//                   const SizedBox(height: 4),
//                   Text("Designation: ${designation_[index]}"),
//                   const SizedBox(height: 4),
//                   Text("Phone: ${phone_[index]}"),
//                   const SizedBox(height: 4),
//                   Text("Address: ${address_[index]}"),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }



import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ViewPolicepage extends StatefulWidget {
  final String stationId;
  const ViewPolicepage({super.key, required this.stationId});

  @override
  State<ViewPolicepage> createState() => _ViewPolicepageState();
}

class _ViewPolicepageState extends State<ViewPolicepage>
    with TickerProviderStateMixin {

  // ── Palette ────────────────────────────────────────────────────────────────
  static const Color navyDark    = Color(0xFF0A1F5C);
  static const Color navyMid     = Color(0xFF1A3A8C);
  static const Color navyLight   = Color(0xFF2756C5);
  static const Color navyAccent  = Color(0xFF4A90E2);
  static const Color iceBlue     = Color(0xFF7EB8F7);
  static const Color snowWhite   = Color(0xFFFFFFFF);
  static const Color offWhite    = Color(0xFFF0F4FF);
  static const Color hintGrey    = Color(0xFF8FA3BF);
  static const Color cardBorder  = Color(0xFFDDE8FF);
  static const Color successGreen= Color(0xFF2ECC71);

  // ── Data (backend unchanged) ───────────────────────────────────────────────
  List<String> name_        = [];
  List<String> address_     = [];
  List<String> phone_       = [];
  List<String> designation_ = [];

  // ── Filtered list ──────────────────────────────────────────────────────────
  List<int> _filteredIndexes = [];
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  bool _isLoading = true;

  // ── Animations ─────────────────────────────────────────────────────────────
  late AnimationController _bgController;    // orb drift
  late AnimationController _shimmerCtrl;     // shimmer sweep on glass cards
  late AnimationController _heroCtrl;        // header hero entrance
  late Animation<double>   _heroFade;
  late Animation<Offset>   _heroSlide;

  // Per-card stagger
  final Map<int, AnimationController> _cardCtrl = {};
  final Map<int, Animation<double>>   _cardAnim = {};

  @override
  void initState() {
    super.initState();

    _bgController = AnimationController(
      vsync: this, duration: const Duration(seconds: 9),
    )..repeat(reverse: true);

    _shimmerCtrl = AnimationController(
      vsync: this, duration: const Duration(seconds: 3),
    )..repeat();

    _heroCtrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 800),
    );
    _heroFade  = CurvedAnimation(parent: _heroCtrl, curve: Curves.easeOut);
    _heroSlide = Tween<Offset>(
        begin: const Offset(0, -0.2), end: Offset.zero)
        .animate(CurvedAnimation(parent: _heroCtrl, curve: Curves.easeOut));

    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
        _applyFilter();
      });
    });

    fetchPolice();
  }

  @override
  void dispose() {
    _bgController.dispose();
    _shimmerCtrl.dispose();
    _heroCtrl.dispose();
    _searchController.dispose();
    for (var c in _cardCtrl.values) c.dispose();
    super.dispose();
  }

  // ── Filter ─────────────────────────────────────────────────────────────────
  void _applyFilter() {
    List<int> idx = List.generate(name_.length, (i) => i);
    if (_searchQuery.isNotEmpty) {
      idx = idx.where((i) =>
      name_[i].toLowerCase().contains(_searchQuery) ||
          designation_[i].toLowerCase().contains(_searchQuery) ||
          phone_[i].contains(_searchQuery) ||
          address_[i].toLowerCase().contains(_searchQuery)).toList();
    }
    _filteredIndexes = idx;
  }

  // ── Card entrance stagger ──────────────────────────────────────────────────
  void _ensureCardAnim(int pos) {
    if (_cardCtrl.containsKey(pos)) return;
    final c = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 420 + pos * 75),
    );
    _cardCtrl[pos] = c;
    _cardAnim[pos] = CurvedAnimation(parent: c, curve: Curves.easeOutBack);
    Future.delayed(Duration(milliseconds: pos * 75), () {
      if (mounted) c.forward();
    });
  }

  // ── Backend (UNCHANGED) ────────────────────────────────────────────────────
  Future<void> fetchPolice() async {
    setState(() => _isLoading = true);
    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String urls = sh.getString('url') ?? '';
      String url  = '$urls/ViewPolice/';

      var response = await http.post(
        Uri.parse(url),
        body: {'station_id': widget.stationId},
      );

      var jsonData = json.decode(response.body);

      if (jsonData['status'] == 'ok') {
        var arr = jsonData['data'];
        List<String> n=[], a=[], p=[], d=[];
        for (int i = 0; i < arr.length; i++) {
          n.add(arr[i]['full_name'].toString());
          a.add(arr[i]['address'].toString());
          p.add(arr[i]['phone'].toString());
          d.add(arr[i]['designation'].toString());
        }
        setState(() {
          name_        = n;
          address_     = a;
          phone_       = p;
          designation_ = d;
          _cardCtrl.clear();
          _cardAnim.clear();
          _applyFilter();
        });
        _heroCtrl.forward();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: $e'),
          backgroundColor: navyDark,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ));
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  BUILD
  // ══════════════════════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        return false;
      },
      child: Scaffold(
        backgroundColor: offWhite,
        extendBodyBehindAppBar: true,
        appBar: _buildAppBar(),
        body: Stack(children: [
          // Layer 0 — full-page gradient base
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFE8EFFF), Color(0xFFF5F8FF), Color(0xFFEBF2FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // Layer 1 — animated orbs
          _buildOrbLayer(),
          // Layer 2 — dot grid
          Positioned.fill(
            child: CustomPaint(
                painter: _DotGridPainter(navyLight.withOpacity(0.04))),
          ),
          // Layer 3 — content
          SafeArea(
            child: Column(children: [
              const SizedBox(height: 8),
              _buildHeroHeader(),
              _buildSearchBar(),
              Expanded(child: _buildBody()),
            ]),
          ),
        ]),
      ),
    );
  }

  // ── AppBar (transparent, glass-styled) ────────────────────────────────────
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: navyDark.withOpacity(0.88),
      centerTitle: true,
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Container(color: Colors.transparent),
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded,
            color: snowWhite, size: 20),
        tooltip: 'Back',
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: const Text('Police Officers',
          style: TextStyle(color: snowWhite, fontSize: 17,
              fontWeight: FontWeight.w700, letterSpacing: 0.8)),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh_rounded, color: snowWhite, size: 22),
          tooltip: 'Refresh',
          onPressed: fetchPolice,
        ),
      ],
    );
  }

  // ── Animated orb layer ─────────────────────────────────────────────────────
  Widget _buildOrbLayer() {
    return AnimatedBuilder(
      animation: _bgController,
      builder: (_, __) {
        final t = _bgController.value;
        return Stack(children: [
          Positioned(top: 60 + 40*sin(t*pi), right: -60 + 20*cos(t*pi),
              child: _orb(220, navyLight.withOpacity(0.13))),
          Positioned(top: 300 + 35*cos(t*pi), left: -70 + 25*sin(t*pi),
              child: _orb(190, navyAccent.withOpacity(0.10))),
          Positioned(bottom: 60 + 30*sin(t*pi), right: -30 + 15*cos(t*pi),
              child: _orb(160, iceBlue.withOpacity(0.10))),
          Positioned(bottom: 280 + 20*cos(t*pi), left: 20 + 12*sin(t*pi),
              child: _orb(100, navyMid.withOpacity(0.08))),
          // Extra small sparkle orbs
          Positioned(top: 180 + 20*sin(t*2*pi), left: 80 + 15*cos(t*2*pi),
              child: _orb(50, iceBlue.withOpacity(0.12))),
          Positioned(bottom: 150 + 18*cos(t*2*pi), right: 60 + 12*sin(t*2*pi),
              child: _orb(60, navyAccent.withOpacity(0.09))),
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

  // ── Hero header ────────────────────────────────────────────────────────────
  Widget _buildHeroHeader() {
    return FadeTransition(
      opacity: _heroFade,
      child: SlideTransition(
        position: _heroSlide,
        child: Container(
          margin: const EdgeInsets.fromLTRB(16, 4, 16, 0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      navyDark.withOpacity(0.85),
                      navyMid.withOpacity(0.80),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: snowWhite.withOpacity(0.15), width: 1.2),
                  boxShadow: [
                    BoxShadow(color: navyDark.withOpacity(0.25),
                        blurRadius: 24, offset: const Offset(0, 10)),
                  ],
                ),
                child: Row(children: [
                  // Glass shield icon
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        width: 56, height: 56,
                        decoration: BoxDecoration(
                          color: snowWhite.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              color: snowWhite.withOpacity(0.25), width: 1.2),
                        ),
                        child: const Icon(Icons.local_police_rounded,
                            color: snowWhite, size: 30),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('Station Officers',
                        style: TextStyle(color: snowWhite, fontSize: 18,
                            fontWeight: FontWeight.w800, letterSpacing: 0.5)),
                    const SizedBox(height: 4),
                    Text(
                      _isLoading
                          ? 'Loading officers…'
                          : '${_filteredIndexes.length} of ${name_.length} officer${name_.length == 1 ? '' : 's'}',
                      style: TextStyle(
                          color: snowWhite.withOpacity(0.72), fontSize: 13),
                    ),
                  ])),
                  // Live badge
                  if (!_isLoading && name_.isNotEmpty)
                    _glowBadge('LIVE', successGreen),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _glowBadge(String label, Color color) {
    return AnimatedBuilder(
      animation: _shimmerCtrl,
      builder: (_, __) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: color.withOpacity(0.18),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: color.withOpacity(0.5 + 0.4 * sin(_shimmerCtrl.value * 2 * pi)),
              width: 1.4),
          boxShadow: [
            BoxShadow(
                color: color.withOpacity(
                    0.3 * (0.5 + 0.5 * sin(_shimmerCtrl.value * 2 * pi))),
                blurRadius: 12, spreadRadius: 1),
          ],
        ),
        child: Text(label,
            style: TextStyle(color: color, fontSize: 11,
                fontWeight: FontWeight.w800, letterSpacing: 1.2)),
      ),
    );
  }

  // ── Search bar (glass style) ───────────────────────────────────────────────
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            decoration: BoxDecoration(
              color: snowWhite.withOpacity(0.75),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                  color: _searchQuery.isNotEmpty
                      ? navyLight.withOpacity(0.6)
                      : cardBorder,
                  width: _searchQuery.isNotEmpty ? 2.0 : 1.2),
              boxShadow: [
                BoxShadow(color: navyDark.withOpacity(0.07),
                    blurRadius: 16, offset: const Offset(0, 4)),
              ],
            ),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: navyDark, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Search by name, designation or phone…',
                hintStyle: TextStyle(color: hintGrey, fontSize: 13),
                prefixIcon: const Icon(Icons.search_rounded,
                    color: navyLight, size: 22),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                    icon: const Icon(Icons.close_rounded,
                        color: hintGrey, size: 20),
                    onPressed: () {
                      _searchController.clear();
                      setState(() { _searchQuery=''; _applyFilter(); });
                    })
                    : null,
                filled: true,
                fillColor: Colors.transparent,
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 14, horizontal: 16),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Body ───────────────────────────────────────────────────────────────────
  Widget _buildBody() {
    if (_isLoading) return _loadingState();
    if (_filteredIndexes.isEmpty) return _emptyState();

    return RefreshIndicator(
      onRefresh: fetchPolice,
      color: navyDark,
      backgroundColor: snowWhite,
      strokeWidth: 2.5,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics()),
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
        itemCount: _filteredIndexes.length,
        itemBuilder: (context, listPos) {
          final idx = _filteredIndexes[listPos];
          _ensureCardAnim(listPos);
          final anim = _cardAnim[listPos]!;
          return ScaleTransition(
            scale: anim,
            child: FadeTransition(
              opacity: anim,
              child: _buildOfficerCard(idx, listPos),
            ),
          );
        },
      ),
    );
  }

  // ── Liquid glass officer card ──────────────────────────────────────────────
  Widget _buildOfficerCard(int idx, int listPos) {
    // Alternating slight tint for variety
    final tints = [navyLight, navyAccent, iceBlue, navyMid];
    final tint = tints[listPos % tints.length];

    return AnimatedBuilder(
      animation: _shimmerCtrl,
      builder: (_, child) {
        final shimmer = sin(_shimmerCtrl.value * 2 * pi + listPos * 0.8);
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(color: navyDark.withOpacity(0.08),
                  blurRadius: 20, offset: const Offset(0, 8)),
              BoxShadow(
                  color: tint.withOpacity(0.07 + 0.04 * shimmer),
                  blurRadius: 30, spreadRadius: 2,
                  offset: const Offset(0, 4)),
            ],
          ),
          child: child,
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Container(
            decoration: BoxDecoration(
              // Liquid glass gradient
              gradient: LinearGradient(
                colors: [
                  snowWhite.withOpacity(0.88),
                  snowWhite.withOpacity(0.72),
                  offWhite.withOpacity(0.90),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                  color: snowWhite.withOpacity(0.9), width: 1.5),
            ),
            child: Column(children: [
              // ── Card top accent strip ──────────────────────────────────
              Container(
                height: 4,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [tint.withOpacity(0.6), tint.withOpacity(0.2)]),
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(24)),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                child: Column(children: [

                  // ── Top row: avatar + name + designation ───────────────
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    // Glass avatar circle
                    ClipOval(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                        child: Container(
                          width: 52, height: 52,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [tint.withOpacity(0.25), navyDark.withOpacity(0.15)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: tint.withOpacity(0.4), width: 1.8),
                          ),
                          child: Center(
                            child: Text(
                              name_[idx].isNotEmpty
                                  ? name_[idx][0].toUpperCase()
                                  : '?',
                              style: TextStyle(
                                  color: tint.withOpacity(0.9),
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(name_[idx],
                          style: const TextStyle(color: navyDark, fontSize: 16,
                              fontWeight: FontWeight.w800)),
                      const SizedBox(height: 4),
                      // Designation badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: tint.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: tint.withOpacity(0.3), width: 1.2),
                        ),
                        child: Text(designation_[idx],
                            style: TextStyle(color: tint,
                                fontSize: 11, fontWeight: FontWeight.w700,
                                letterSpacing: 0.4)),
                      ),
                    ])),
                    // Rank number badge
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: navyDark.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: navyDark.withOpacity(0.12)),
                          ),
                          child: Text('#${listPos + 1}',
                              style: TextStyle(color: navyDark.withOpacity(0.5),
                                  fontSize: 12, fontWeight: FontWeight.w700)),
                        ),
                      ),
                    ),
                  ]),

                  const SizedBox(height: 14),
                  Divider(height: 1, thickness: 0.8,
                      color: navyLight.withOpacity(0.12)),
                  const SizedBox(height: 12),

                  // ── Phone row ──────────────────────────────────────────
                  Row(children: [
                    _glassInfoIcon(Icons.phone_outlined, tint),
                    const SizedBox(width: 10),
                    Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Phone', style: TextStyle(
                          color: hintGrey, fontSize: 11,
                          fontWeight: FontWeight.w500)),
                      Text(phone_[idx], style: const TextStyle(
                          color: navyDark, fontSize: 14,
                          fontWeight: FontWeight.w600)),
                    ])),
                    // Call button
                    GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Row(children: [
                            const Icon(Icons.call_rounded,
                                color: snowWhite, size: 16),
                            const SizedBox(width: 8),
                            Text('Calling ${name_[idx]}…'),
                          ]),
                          backgroundColor: successGreen,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          duration: const Duration(seconds: 2),
                        ));
                        // Enable: launchUrl(Uri.parse('tel:${phone_[idx]}'));
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: successGreen.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: successGreen.withOpacity(0.35)),
                            ),
                            child: const Row(children: [
                              Icon(Icons.call_rounded,
                                  color: successGreen, size: 15),
                              SizedBox(width: 5),
                              Text('Call', style: TextStyle(
                                  color: successGreen, fontSize: 12,
                                  fontWeight: FontWeight.w700)),
                            ]),
                          ),
                        ),
                      ),
                    ),
                  ]),

                  const SizedBox(height: 12),

                  // ── Address row ────────────────────────────────────────
                  Row(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _glassInfoIcon(Icons.home_outlined, tint),
                        const SizedBox(width: 10),
                        Expanded(child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text('Address', style: TextStyle(
                              color: hintGrey, fontSize: 11,
                              fontWeight: FontWeight.w500)),
                          Text(address_[idx], style: const TextStyle(
                              color: navyDark, fontSize: 13,
                              fontWeight: FontWeight.w500),
                              maxLines: 2, overflow: TextOverflow.ellipsis),
                        ])),
                      ]),
                ]),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  // ── Glass icon container ───────────────────────────────────────────────────
  Widget _glassInfoIcon(IconData icon, Color tint) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Container(
          width: 34, height: 34,
          decoration: BoxDecoration(
            color: tint.withOpacity(0.10),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: tint.withOpacity(0.25)),
          ),
          child: Icon(icon, color: tint, size: 17),
        ),
      ),
    );
  }

  // ── Loading (glass shimmer skeleton) ──────────────────────────────────────
  Widget _loadingState() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
      itemCount: 4,
      itemBuilder: (_, i) => AnimatedBuilder(
        animation: _shimmerCtrl,
        builder: (_, __) {
          final shimmerPos = (_shimmerCtrl.value * 2 - 1);
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            height: 130,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              boxShadow: [BoxShadow(color: navyDark.withOpacity(0.06),
                  blurRadius: 16, offset: const Offset(0, 6))],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        snowWhite.withOpacity(0.70),
                        snowWhite.withOpacity(0.90),
                        snowWhite.withOpacity(0.70),
                      ],
                      stops: [
                        (shimmerPos - 0.4).clamp(0.0, 1.0),
                        (shimmerPos + 0.0).clamp(0.0, 1.0),
                        (shimmerPos + 0.4).clamp(0.0, 1.0),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: snowWhite.withOpacity(0.8)),
                  ),
                  padding: const EdgeInsets.all(18),
                  child: Row(children: [
                    Container(width: 52, height: 52,
                        decoration: BoxDecoration(
                            color: navyLight.withOpacity(0.08),
                            shape: BoxShape.circle)),
                    const SizedBox(width: 14),
                    Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(height: 14, width: 140,
                              decoration: BoxDecoration(
                                  color: navyLight.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(8))),
                          const SizedBox(height: 10),
                          Container(height: 10, width: 90,
                              decoration: BoxDecoration(
                                  color: navyLight.withOpacity(0.06),
                                  borderRadius: BorderRadius.circular(8))),
                          const SizedBox(height: 10),
                          Container(height: 10, width: 120,
                              decoration: BoxDecoration(
                                  color: navyLight.withOpacity(0.06),
                                  borderRadius: BorderRadius.circular(8))),
                        ])),
                  ]),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Empty state ────────────────────────────────────────────────────────────
  Widget _emptyState() {
    final isSearch = _searchQuery.isNotEmpty;
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        ClipOval(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              width: 100, height: 100,
              decoration: BoxDecoration(
                color: snowWhite.withOpacity(0.6),
                shape: BoxShape.circle,
                border: Border.all(color: cardBorder, width: 2),
              ),
              child: Icon(
                  isSearch ? Icons.search_off_rounded : Icons.badge_outlined,
                  size: 48, color: hintGrey),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(isSearch ? 'No Officers Found' : 'No Police Found',
            style: const TextStyle(color: navyDark, fontSize: 20,
                fontWeight: FontWeight.w800)),
        const SizedBox(height: 8),
        Text(isSearch ? 'Try a different search term'
            : 'Pull down to refresh',
            style: TextStyle(color: hintGrey, fontSize: 13)),
        if (isSearch) ...[
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              _searchController.clear();
              setState(() { _searchQuery = ''; _applyFilter(); });
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 13),
                  decoration: BoxDecoration(
                    color: navyDark.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: snowWhite.withOpacity(0.15)),
                  ),
                  child: const Text('Clear Search',
                      style: TextStyle(color: snowWhite,
                          fontWeight: FontWeight.w700, fontSize: 14)),
                ),
              ),
            ),
          ),
        ],
      ]),
    );
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