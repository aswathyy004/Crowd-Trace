// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
//
// class ViewCriminalsPage extends StatefulWidget {
//   final String shopId;
//   const ViewCriminalsPage({super.key,required this.shopId});
//
//   @override
//   State<ViewCriminalsPage> createState() => ViewCriminalsPageState();
//
//   // _ViewCriminalsPage() {}
// }
//
// class ViewCriminalsPageState extends State<ViewCriminalsPage> {
//   List stylists = [];
//   bool loading = true;
//   String imageurl = "";
//
//   @override
//   void initState() {
//     super.initState();
//     fetchStylists();
//   }
//
//   Future<void> fetchStylists() async {
//     SharedPreferences sh = await SharedPreferences.getInstance();
//     String url = sh.getString('url').toString();
//     imageurl = sh.getString('Image_url').toString();
//     String lid = sh.getString('lid').toString();
//
//     final response = await http.post(
//       Uri.parse('$url/user_view_criminals/'),
//       body: {'lid': lid},
//     );
//
//     final data = json.decode(response.body);
//
//     if (data['status'] == 'ok') {
//       setState(() {
//         stylists = data['data'];
//         loading = false;
//       });
//     } else {
//       Fluttertoast.showToast(msg: "No stylists found");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Stylists")),
//       body: loading
//           ? const Center(child: CircularProgressIndicator())
//           : ListView.builder(
//         itemCount: stylists.length,
//         itemBuilder: (context, index) {
//           final s = stylists[index];
//           return Card(
//             margin: const EdgeInsets.all(10),
//             child: ListTile(
//               leading: s['photo'] != ""
//                   ? Image.network(
//                 imageurl + s['photo'],
//                 width: 60,
//                 height: 60,
//                 fit: BoxFit.cover,
//               )
//                   : const Icon(Icons.person, size: 60),
//               title: Text(s['name']),
//               subtitle: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text("Gender: ${s['gender']}"),
//                   Text("Details: ${s['experience']}"),
//                   Text("Age: ${s['phone']}"),
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
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// ═══════════════════════════════════════════════════════════════════════════════
//  THEME  — dark charcoal-black with subtle red accents
// ═══════════════════════════════════════════════════════════════════════════════
class _T {
  static const bgDeep         = Color(0xFF0C0C0F);   // near-black neutral
  static const bgCard         = Color(0xFF161618);   // dark charcoal card
  static const accentRed      = Color(0xFFB22234);   // muted deep red — used sparingly
  static const accentBright   = Color(0xFFE8394A);   // brighter red for badges/labels only
  static const accentOrange   = Color(0xFFE05C2A);   // warm accent, very sparse
  static const accentGold     = Color(0xFFD4A843);   // muted gold for WANTED text
  static const textPrimary    = Color(0xFFECECF0);   // clean near-white
  static const textSub        = Color(0xFF72727A);   // neutral grey sub-text
  static const glass          = Color(0x12FFFFFF);   // white glass — dominant surface
  static const glassBorder    = Color(0x1EFFFFFF);   // subtle white border
  static const glassRed       = Color(0x0CB22234);   // very faint red tint
  static const glassRedBorder = Color(0x24B22234);   // low-opacity red border
  static const success        = Color(0xFF2ECC71);
  static const warning        = Color(0xFFE67E22);
}

// ═══════════════════════════════════════════════════════════════════════════════
//  MAIN LIST PAGE
// ═══════════════════════════════════════════════════════════════════════════════
class ViewCriminalsPage extends StatefulWidget {
  final String shopId;
  const ViewCriminalsPage({super.key, required this.shopId});

  @override
  State<ViewCriminalsPage> createState() => ViewCriminalsPageState();
}

class ViewCriminalsPageState extends State<ViewCriminalsPage>
    with TickerProviderStateMixin {
  List   _all          = [];
  List   _filtered     = [];
  bool   _loading      = true;
  String _imageurl     = '';
  String _query        = '';
  String _filterGender = 'All';

  late final AnimationController _listAnim;
  late final AnimationController _pulseAnim;
  final TextEditingController _searchCtrl = TextEditingController();
  final ScrollController      _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    _listAnim  = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..forward();
    _pulseAnim = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
    fetchStylists();
  }

  @override
  void dispose() {
    _listAnim.dispose();
    _pulseAnim.dispose();
    _searchCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  // ── backend (original logic preserved) ──────────────────────
  Future<void> fetchStylists() async {
    setState(() => _loading = true);
    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String url   = sh.getString('url').toString();
      _imageurl    = sh.getString('Image_url').toString();
      String lid   = sh.getString('lid').toString();

      final response = await http.post(
        Uri.parse('$url/user_view_criminals/'),
        body: {'lid': lid},
      );

      final data = json.decode(response.body);

      if (data['status'] == 'ok') {
        setState(() {
          _all     = data['data'];
          _loading = false;
        });
        _applyFilter();
        _listAnim.forward(from: 0);
      } else {
        setState(() => _loading = false);
        Fluttertoast.showToast(msg: "No criminals found");
      }
    } catch (_) {
      setState(() => _loading = false);
      Fluttertoast.showToast(msg: "Connection error. Please retry.");
    }
  }

  void _applyFilter() {
    setState(() {
      _filtered = _all.where((p) {
        final name   = (p['name'] ?? '').toString().toLowerCase();
        final gender = (p['gender'] ?? '').toString();
        final matchQ = _query.isEmpty || name.contains(_query.toLowerCase());
        final matchG = _filterGender == 'All' || gender == _filterGender;
        return matchQ && matchG;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: _T.bgDeep,
        body: Stack(children: [
          const _BgPainter(),
          SafeArea(
            child: Column(children: [
              _Header(
                count    : _filtered.length,
                loading  : _loading,
                onBack   : () => Navigator.pop(context),
                onRefresh: fetchStylists,
              ),
              _SearchBar(
                controller: _searchCtrl,
                onChanged : (v) { _query = v; _applyFilter(); },
              ),
              _GenderFilter(
                selected: _filterGender,
                onSelect: (v) { _filterGender = v; _applyFilter(); },
              ),
              const SizedBox(height: 6),
              Expanded(child: _loading ? _Loader(anim: _pulseAnim) : _buildList()),
            ]),
          ),
          Positioned(
            bottom: 24, right: 20,
            child: _FabScrollTop(ctrl: _scrollCtrl),
          ),
        ]),
      ),
    );
  }

  Widget _buildList() {
    if (_filtered.isEmpty) {
      return _EmptyState(hasQuery: _query.isNotEmpty || _filterGender != 'All');
    }
    return ListView.builder(
      controller : _scrollCtrl,
      padding    : const EdgeInsets.fromLTRB(16, 4, 16, 100),
      itemCount  : _filtered.length,
      itemBuilder: (ctx, i) {
        final double start = ((i * 80) / 900.0).clamp(0.0, 0.85);
        final double end   = (start + 0.25).clamp(0.0, 1.0);
        final double span  = (end - start).clamp(0.01, 1.0);

        return AnimatedBuilder(
          animation: _listAnim,
          builder: (_, child) {
            final raw = ((_listAnim.value - start) / span).clamp(0.0, 1.0);
            final t   = Curves.easeOutCubic.transform(raw);
            return Opacity(
              opacity: t,
              child: Transform.translate(offset: Offset(0, 28 * (1 - t)), child: child),
            );
          },
          child: _CriminalCard(
            person  : _filtered[i],
            imageurl: _imageurl,
            index   : i,
            onTap   : () => Navigator.push(
              ctx,
              PageRouteBuilder(
                transitionDuration: const Duration(milliseconds: 450),
                pageBuilder: (_, a, __) => FadeTransition(
                  opacity: a,
                  child: _DetailPage(person: _filtered[i], imageurl: _imageurl),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  DETAIL PAGE
// ═══════════════════════════════════════════════════════════════════════════════
class _DetailPage extends StatefulWidget {
  final Map    person;
  final String imageurl;
  const _DetailPage({required this.person, required this.imageurl});

  @override
  State<_DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<_DetailPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(vsync: this, duration: const Duration(milliseconds: 700))..forward();
  }

  @override
  void dispose() { _anim.dispose(); super.dispose(); }

  bool get _hasPhoto {
    final p = widget.person['photo'];
    return p != null && p.toString().isNotEmpty;
  }

  String get _photoUrl => widget.imageurl + (widget.person['photo'] ?? '');

  Widget _slideIn({required double delay, required Widget child}) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) {
        final span = (1.0 - delay).clamp(0.01, 1.0);
        final raw  = ((_anim.value - delay) / span).clamp(0.0, 1.0);
        final t    = Curves.easeOutCubic.transform(raw);
        return Opacity(
          opacity: t,
          child: Transform.translate(offset: Offset(0, 20 * (1 - t)), child: child),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.person;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: _T.bgDeep,
        body: Stack(children: [
          const _BgPainter(),
          CustomScrollView(slivers: [
            SliverToBoxAdapter(child: _buildHero(context)),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 20),
                  _slideIn(delay: 0.10, child: const _SectionLabel(label: "PERSONAL INFORMATION")),
                  const SizedBox(height: 10),
                  _slideIn(delay: 0.15, child: _InfoGrid(person: p)),
                  const SizedBox(height: 20),
                  _slideIn(delay: 0.25, child: const _SectionLabel(label: "CRIMINAL RECORD")),
                  const SizedBox(height: 10),
                  _slideIn(delay: 0.30, child: _RecordCard(person: p)),
                  const SizedBox(height: 20),
                  _slideIn(delay: 0.40, child: const _SectionLabel(label: "THREAT LEVEL")),
                  const SizedBox(height: 10),
                  _slideIn(delay: 0.45, child: _ThreatCard(person: p)),
                  const SizedBox(height: 24),
                  _slideIn(delay: 0.55, child: _ReportButton(person: p)),
                ]),
              ),
            ),
          ]),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: _GlassButton(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: _T.textPrimary, size: 17),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _buildHero(BuildContext context) {
    return SizedBox(
      height: 340,
      child: Stack(fit: StackFit.expand, children: [
        // Photo or fallback
        if (_hasPhoto)
          GestureDetector(
            onTap: () => _openFullscreen(context),
            child: Hero(
              tag: 'criminal_photo_${widget.person['name']}',
              child: Image.network(
                _photoUrl, fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _gradientFallback(),
              ),
            ),
          )
        else
          _gradientFallback(),

        // Dark + red bottom fade
        Positioned(
          left: 0, right: 0, bottom: 0,
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter, end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  _T.bgDeep.withOpacity(0.85),
                  _T.bgDeep,
                ],
              ),
            ),
          ),
        ),

        // Very subtle dark vignette on sides
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.black.withOpacity(0.25),
                  Colors.transparent,
                  Colors.black.withOpacity(0.20),
                ],
              ),
            ),
          ),
        ),

        // Name + WANTED badge
        Positioned(
          left: 20, right: 20, bottom: 20,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // WANTED badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFCC1A2E), Color(0xFF8B0000)],
                        ),
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          BoxShadow(color: _T.accentRed.withOpacity(0.25),
                              blurRadius: 12, spreadRadius: -2),
                        ],
                      ),
                      child: const Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(Icons.gavel_rounded, size: 11, color: _T.accentGold),
                        SizedBox(width: 5),
                        Text("WANTED", style: TextStyle(
                          color: _T.accentGold, fontSize: 10,
                          fontWeight: FontWeight.w900, letterSpacing: 2.5,
                        )),
                      ]),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.person['name'] ?? 'Unknown',
                      style: const TextStyle(
                        color: _T.textPrimary, fontSize: 26,
                        fontWeight: FontWeight.w800, letterSpacing: 0.3,
                        shadows: [
                          Shadow(color: Colors.black87, blurRadius: 12),
                          Shadow(color: Color(0xFFCC1A2E), blurRadius: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (_hasPhoto)
                GestureDetector(
                  onTap: () => _openFullscreen(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: _T.glassRedBorder),
                    ),
                    child: const Row(children: [
                      Icon(Icons.fullscreen_rounded, color: _T.accentBright, size: 15),
                      SizedBox(width: 5),
                      Text("Full Photo",
                          style: TextStyle(color: _T.accentBright, fontSize: 11)),
                    ]),
                  ),
                ),
            ],
          ),
        ),
      ]),
    );
  }

  Widget _gradientFallback() => Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft, end: Alignment.bottomRight,
        colors: [Color(0xFF1E1A1C), Color(0xFF0C0C0F)],
      ),
    ),
    child: Center(
      child: Icon(Icons.person_rounded, size: 90,
          color: _T.accentRed.withOpacity(0.25)),
    ),
  );

  void _openFullscreen(BuildContext context) {
    if (!_hasPhoto) return;
    Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false,
        transitionDuration: const Duration(milliseconds: 350),
        pageBuilder: (_, a, __) => FadeTransition(
          opacity: a,
          child: _FullscreenPhoto(
            url : _photoUrl,
            tag : 'criminal_photo_${widget.person['name']}',
            name: widget.person['name'] ?? '',
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  FULLSCREEN PHOTO VIEWER
// ═══════════════════════════════════════════════════════════════════════════════
class _FullscreenPhoto extends StatefulWidget {
  final String url, tag, name;
  const _FullscreenPhoto({required this.url, required this.tag, required this.name});

  @override
  State<_FullscreenPhoto> createState() => _FullscreenPhotoState();
}

class _FullscreenPhotoState extends State<_FullscreenPhoto> {
  final TransformationController _tc = TransformationController();
  bool   _showUI = true;
  double _scale  = 1.0;

  @override
  void dispose() { _tc.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () => setState(() => _showUI = !_showUI),
        child: Stack(fit: StackFit.expand, children: [
          Center(
            child: InteractiveViewer(
              transformationController: _tc,
              minScale: 0.5, maxScale: 6.0,
              onInteractionUpdate: (_) =>
                  setState(() => _scale = _tc.value.getMaxScaleOnAxis()),
              child: Hero(
                tag: widget.tag,
                child: Image.network(
                  widget.url, fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) =>
                  const Icon(Icons.broken_image_rounded, size: 80, color: Colors.white24),
                ),
              ),
            ),
          ),

          AnimatedOpacity(
            opacity: _showUI ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter, end: Alignment.bottomCenter,
                  colors: [Colors.black87, Colors.transparent],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  child: Row(children: [
                    _GlassButton(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close_rounded, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(widget.name,
                          style: const TextStyle(color: Colors.white,
                              fontSize: 16, fontWeight: FontWeight.w700),
                          overflow: TextOverflow.ellipsis),
                    ),
                    if (_scale > 1.05)
                      _GlassButton(
                        onTap: () { _tc.value = Matrix4.identity(); setState(() => _scale = 1.0); },
                        child: const Icon(Icons.zoom_out_map_rounded, color: Colors.white70, size: 18),
                      ),
                  ]),
                ),
              ),
            ),
          ),

          AnimatedOpacity(
            opacity: _showUI ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter, end: Alignment.topCenter,
                    colors: [Colors.black87, Colors.transparent],
                  ),
                ),
                child: const Row(children: [
                  Icon(Icons.pinch_rounded, size: 13, color: Colors.white38),
                  SizedBox(width: 6),
                  Text("Pinch to zoom  •  Tap to toggle controls",
                      style: TextStyle(color: Colors.white38, fontSize: 12)),
                ]),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  REUSABLE WIDGETS
// ═══════════════════════════════════════════════════════════════════════════════

class _Header extends StatelessWidget {
  final int count; final bool loading;
  final VoidCallback onBack; final VoidCallback onRefresh;
  const _Header({required this.count, required this.loading,
    required this.onBack, required this.onRefresh});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
    child: Row(children: [
      _GlassButton(onTap: onBack,
          child: const Icon(Icons.arrow_back_ios_new_rounded,
              color: _T.textPrimary, size: 17)),
      const SizedBox(width: 14),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ShaderMask(
          shaderCallback: (r) => const LinearGradient(
            colors: [_T.textPrimary, _T.accentBright],
          ).createShader(r),
          child: const Text("Criminal Records",
              style: TextStyle(color: Colors.white, fontSize: 21,
                  fontWeight: FontWeight.w800, letterSpacing: 0.3)),
        ),
        Text(loading ? "Loading records…" : "$count record${count == 1 ? '' : 's'} found",
            style: const TextStyle(color: _T.textSub, fontSize: 12)),
      ])),
      _GlassButton(onTap: onRefresh,
          child: const Icon(Icons.refresh_rounded, color: _T.accentBright, size: 20)),
    ]),
  );
}

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>  onChanged;
  const _SearchBar({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: _T.glassRed,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _T.glassRedBorder),
          ),
          child: TextField(
            controller: controller, onChanged: onChanged,
            style: const TextStyle(color: _T.textPrimary, fontSize: 14),
            decoration: const InputDecoration(
              hintText: "Search by name…",
              hintStyle: TextStyle(color: _T.textSub, fontSize: 14),
              prefixIcon: Icon(Icons.search_rounded, color: _T.textSub, size: 20),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
      ),
    ),
  );
}

class _GenderFilter extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onSelect;
  const _GenderFilter({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    const opts = ['All', 'Male', 'Female', 'Other'];
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: opts.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final active = selected == opts[i];
          return GestureDetector(
            onTap: () => onSelect(opts[i]),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color : active ? _T.accentRed : _T.glassRed,
                border: Border.all(
                    color: active ? _T.accentBright : _T.glassRedBorder),
                boxShadow: active ? [
                  BoxShadow(color: _T.accentRed.withOpacity(0.20),
                      blurRadius: 12, spreadRadius: -3),
                ] : [],
              ),
              child: Text(opts[i], style: TextStyle(
                color: active ? Colors.white : _T.textSub,
                fontSize: 12,
                fontWeight: active ? FontWeight.w700 : FontWeight.w400,
              )),
            ),
          );
        },
      ),
    );
  }
}

// ── Criminal Card ─────────────────────────────────────────────────────────────
class _CriminalCard extends StatefulWidget {
  final Map person; final String imageurl;
  final int index;  final VoidCallback onTap;
  const _CriminalCard({required this.person, required this.imageurl,
    required this.index, required this.onTap});

  @override
  State<_CriminalCard> createState() => _CriminalCardState();
}

class _CriminalCardState extends State<_CriminalCard> {
  bool _pressed = false;

  bool get _hasPhoto {
    final p = widget.person['photo'];
    return p != null && p.toString().isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.person;
    return GestureDetector(
      onTap      : widget.onTap,
      onTapDown  : (_) => setState(() => _pressed = true),
      onTapUp    : (_) => setState(() => _pressed = false),
      onTapCancel:  () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: Container(
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: _T.glassRedBorder),
            gradient: LinearGradient(
              begin: Alignment.topLeft, end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.06),
                Colors.white.withOpacity(0.02),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: _T.accentRed.withOpacity(0.08),
                blurRadius: 24, spreadRadius: -6, offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
              child: Row(children: [
                // Photo strip with red overlay
                Stack(children: [
                  Container(
                    width: 90, height: 134,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(22),
                        bottomLeft: Radius.circular(22),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft, end: Alignment.bottomRight,
                        colors: [Color(0xFF1C1C20), _T.bgCard],
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(22),
                        bottomLeft: Radius.circular(22),
                      ),
                      child: _hasPhoto
                          ? Image.network(
                        widget.imageurl + p['photo'], fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _avatarFallback(),
                      )
                          : _avatarFallback(),
                    ),
                  ),
                  // Index badge
                  Positioned(
                    top: 8, left: 8,
                    child: Container(
                      width: 22, height: 22,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _T.accentRed,
                        boxShadow: [BoxShadow(color: _T.accentRed.withOpacity(0.18),
                            blurRadius: 6, spreadRadius: -2)],
                      ),
                      child: Center(
                        child: Text('${widget.index + 1}',
                            style: const TextStyle(color: Colors.white,
                                fontSize: 9, fontWeight: FontWeight.w900)),
                      ),
                    ),
                  ),
                ]),

                // Info section
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 14, 12, 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Expanded(
                            child: Text(p['name'] ?? 'Unknown',
                                style: const TextStyle(color: _T.textPrimary,
                                    fontSize: 15, fontWeight: FontWeight.w800),
                                overflow: TextOverflow.ellipsis),
                          ),
                          // WANTED chip
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                            decoration: BoxDecoration(
                              color: _T.accentRed.withOpacity(0.18),
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: _T.accentRed.withOpacity(0.22)),
                            ),
                            child: const Text("WANTED",
                                style: TextStyle(color: _T.accentBright,
                                    fontSize: 7, fontWeight: FontWeight.w900, letterSpacing: 1)),
                          ),
                        ]),
                        const SizedBox(height: 8),
                        _MiniRow(icon: Icons.wc_rounded, value: p['gender'] ?? '-'),
                        const SizedBox(height: 4),
                        _MiniRow(icon: Icons.cake_outlined, value: "Age: ${p['phone'] ?? '-'}"),
                        const SizedBox(height: 4),
                        _MiniRow(icon: Icons.gavel_rounded, value: p['experience'] ?? '-', maxLines: 1),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: const LinearGradient(
                                colors: [_T.accentRed, Color(0xFF8B0000)],
                              ),
                              boxShadow: [BoxShadow(
                                  color: _T.accentRed.withOpacity(0.20),
                                  blurRadius: 10, spreadRadius: -3)],
                            ),
                            child: const Row(mainAxisSize: MainAxisSize.min, children: [
                              Text("View Profile",
                                  style: TextStyle(color: Colors.white,
                                      fontSize: 11, fontWeight: FontWeight.w700)),
                              SizedBox(width: 4),
                              Icon(Icons.arrow_forward_ios_rounded,
                                  color: Colors.white, size: 10),
                            ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  Widget _avatarFallback() => Center(
    child: Icon(Icons.person_rounded, size: 42,
        color: _T.accentBright.withOpacity(0.35)),
  );
}

// ── Detail page widgets ───────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) => Row(children: [
    Container(
      width: 3, height: 16,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        gradient: const LinearGradient(
          colors: [_T.accentBright, Color(0xFF8B0000)],
          begin: Alignment.topCenter, end: Alignment.bottomCenter,
        ),
      ),
    ),
    const SizedBox(width: 8),
    Text(label, style: const TextStyle(color: _T.textSub,
        fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.0)),
  ]);
}

class _InfoGrid extends StatelessWidget {
  final Map person;
  const _InfoGrid({required this.person});

  @override
  Widget build(BuildContext context) {
    final items = [
      {'icon': Icons.wc_rounded,            'label': 'Gender',   'value': person['gender']          ?? '-'},
      {'icon': Icons.cake_outlined,          'label': 'Age',      'value': person['phone']           ?? '-'},
      {'icon': Icons.badge_rounded,          'label': 'Case ID',  'value': person['id']?.toString() ?? '-'},
      {'icon': Icons.calendar_month_rounded, 'label': 'Reported', 'value': person['date']            ?? '-'},
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, childAspectRatio: 2.5,
        crossAxisSpacing: 10, mainAxisSpacing: 10,
      ),
      itemCount: items.length,
      itemBuilder: (_, i) => _GlassTile(
        icon : items[i]['icon'] as IconData,
        label: items[i]['label'] as String,
        value: items[i]['value'] as String,
      ),
    );
  }
}

class _GlassTile extends StatelessWidget {
  final IconData icon; final String label; final String value;
  const _GlassTile({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(14),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: _T.glassRed,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _T.glassRedBorder),
        ),
        child: Row(children: [
          Container(
            width: 30, height: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _T.accentRed.withOpacity(0.2),
            ),
            child: Icon(icon, size: 14, color: _T.accentBright),
          ),
          const SizedBox(width: 10),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(label, style: const TextStyle(color: _T.textSub, fontSize: 10)),
              Text(value, style: const TextStyle(color: _T.textPrimary,
                  fontSize: 13, fontWeight: FontWeight.w700),
                  overflow: TextOverflow.ellipsis),
            ],
          )),
        ]),
      ),
    ),
  );
}

class _RecordCard extends StatelessWidget {
  final Map person;
  const _RecordCard({required this.person});

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(16),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _T.glassRed,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _T.glassRedBorder),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Icon(Icons.warning_rounded, size: 14, color: _T.accentBright),
            const SizedBox(width: 6),
            const Text("Offense / Details",
                style: TextStyle(color: _T.accentBright,
                    fontSize: 12, fontWeight: FontWeight.w700)),
          ]),
          const SizedBox(height: 10),
          Text(
            person['experience']?.toString().isNotEmpty == true
                ? person['experience'].toString()
                : 'No criminal record details provided.',
            style: const TextStyle(color: _T.textPrimary, fontSize: 14, height: 1.65),
          ),
        ]),
      ),
    ),
  );
}

class _ThreatCard extends StatelessWidget {
  final Map person;
  const _ThreatCard({required this.person});

  @override
  Widget build(BuildContext context) {
    final status  = person['status']?.toString() ?? 'Active';
    final caught  = status.toLowerCase() == 'caught' || status.toLowerCase() == 'arrested';
    final color   = caught ? _T.success : _T.accentBright;
    final bgColor = caught ? _T.success.withOpacity(0.07) : _T.accentRed.withOpacity(0.08);
    final border  = caught ? _T.success.withOpacity(0.35) : _T.accentRed.withOpacity(0.25);

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: border),
            boxShadow: caught ? [] : [
              BoxShadow(color: _T.accentRed.withOpacity(0.15),
                  blurRadius: 20, spreadRadius: -4),
            ],
          ),
          child: Row(children: [
            Container(
              width: 46, height: 46,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withOpacity(0.15),
              ),
              child: Icon(
                  caught ? Icons.lock_rounded : Icons.warning_amber_rounded,
                  color: color, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(caught ? "In Custody" : "At Large — Dangerous",
                      style: TextStyle(color: color,
                          fontSize: 15, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 3),
                  Text(caught
                      ? "Subject has been apprehended"
                      : "Subject is active — exercise caution",
                      style: const TextStyle(color: _T.textSub, fontSize: 12)),
                ])),
          ]),
        ),
      ),
    );
  }
}

class _ReportButton extends StatelessWidget {
  final Map person;
  const _ReportButton({required this.person});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () {
      final info =
          "🚨 CRIMINAL ALERT 🚨\n"
          "Name   : ${person['name']       ?? 'Unknown'}\n"
          "Gender : ${person['gender']     ?? '-'}\n"
          "Age    : ${person['phone']      ?? '-'}\n"
          "Record : ${person['experience'] ?? '-'}\n\n"
          "If you have information, please contact local authorities immediately.";
      Clipboard.setData(ClipboardData(text: info));
      Fluttertoast.showToast(msg: "Alert info copied to clipboard!");
    },
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [_T.accentRed, Color(0xFF7A0010)],
        ),
        boxShadow: [
          BoxShadow(color: _T.accentRed.withOpacity(0.22),
              blurRadius: 22, spreadRadius: -4, offset: const Offset(0, 8)),
        ],
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.share_rounded, color: Colors.white, size: 18),
          SizedBox(width: 8),
          Text("Report / Share Alert",
              style: TextStyle(color: Colors.white,
                  fontSize: 14, fontWeight: FontWeight.w700)),
        ],
      ),
    ),
  );
}

// ── Loader ────────────────────────────────────────────────────────────────────
class _Loader extends StatelessWidget {
  final AnimationController anim;
  const _Loader({required this.anim});

  @override
  Widget build(BuildContext context) => Center(
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      AnimatedBuilder(
        animation: anim,
        builder: (_, __) => Transform.scale(
          scale: 0.9 + 0.1 * anim.value,
          child: Container(
            width: 64, height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(colors: [
                _T.accentRed.withOpacity(0.15 + 0.10 * anim.value),
                Colors.transparent,
              ]),
            ),
            child: const Center(
              child: SizedBox(width: 36, height: 36,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(_T.accentBright),
                  )),
            ),
          ),
        ),
      ),
      const SizedBox(height: 16),
      const Text("Fetching records…",
          style: TextStyle(color: _T.textSub, fontSize: 13)),
    ]),
  );
}

// ── Empty State ───────────────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  final bool hasQuery;
  const _EmptyState({required this.hasQuery});

  @override
  Widget build(BuildContext context) => Center(
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      Icon(hasQuery ? Icons.search_off_rounded : Icons.no_accounts_rounded,
          size: 64, color: _T.textSub.withOpacity(0.25)),
      const SizedBox(height: 14),
      Text(hasQuery ? "No results found" : "No records available",
          style: const TextStyle(color: _T.textSub, fontSize: 15)),
      if (hasQuery) ...[
        const SizedBox(height: 6),
        const Text("Try a different name or filter",
            style: TextStyle(color: _T.textSub, fontSize: 12)),
      ],
    ]),
  );
}

// ── FAB scroll-to-top ─────────────────────────────────────────────────────────
class _FabScrollTop extends StatefulWidget {
  final ScrollController ctrl;
  const _FabScrollTop({required this.ctrl});

  @override
  State<_FabScrollTop> createState() => _FabScrollTopState();
}

class _FabScrollTopState extends State<_FabScrollTop> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    widget.ctrl.addListener(() {
      final show = widget.ctrl.hasClients && widget.ctrl.offset > 200;
      if (show != _visible) setState(() => _visible = show);
    });
  }

  @override
  Widget build(BuildContext context) => AnimatedOpacity(
    opacity: _visible ? 1.0 : 0.0,
    duration: const Duration(milliseconds: 250),
    child: AnimatedScale(
      scale: _visible ? 1.0 : 0.7,
      duration: const Duration(milliseconds: 250),
      child: _GlassButton(
        onTap: () => widget.ctrl.animateTo(0,
            duration: const Duration(milliseconds: 400), curve: Curves.easeOut),
        child: const Icon(Icons.keyboard_arrow_up_rounded,
            color: _T.accentBright, size: 22),
      ),
    ),
  );
}

// ── Glass Button ──────────────────────────────────────────────────────────────
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
            color: _T.glassRed,
            border: Border.all(color: _T.glassRedBorder),
          ),
          child: Center(child: child),
        ),
      ),
    ),
  );
}

// ── Mini info row ─────────────────────────────────────────────────────────────
class _MiniRow extends StatelessWidget {
  final IconData icon; final String value; final int maxLines;
  const _MiniRow({required this.icon, required this.value, this.maxLines = 1});

  @override
  Widget build(BuildContext context) => Row(children: [
    Icon(icon, size: 12, color: _T.textSub),
    const SizedBox(width: 5),
    Expanded(child: Text(value,
        style: const TextStyle(color: _T.textSub, fontSize: 12),
        maxLines: maxLines, overflow: TextOverflow.ellipsis)),
  ]);
}

// ── Background ────────────────────────────────────────────────────────────────
class _BgPainter extends StatelessWidget {
  const _BgPainter();

  @override
  Widget build(BuildContext context) =>
      SizedBox.expand(child: CustomPaint(painter: _BgCP()));
}

class _BgCP extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    // Base
    canvas.drawRect(Rect.fromLTWH(0, 0, s.width, s.height),
        Paint()..color = _T.bgDeep);

    void glow(Offset c, double r, Color col, double op) {
      canvas.drawCircle(c, r, Paint()
        ..shader = RadialGradient(
          colors: [col.withOpacity(op), Colors.transparent],
        ).createShader(Rect.fromCircle(center: c, radius: r)));
    }

    // Subtle dark-red hint top-right — barely visible
    glow(Offset(s.width * 0.85, s.height * 0.05), s.width * 0.50,
        _T.accentRed, 0.13);
    // Cool dark grey glow bottom-left — dominant
    glow(Offset(s.width * 0.10, s.height * 0.88), s.width * 0.50,
        const Color(0xFF2A2A2E), 0.60);
    // Very faint warm centre
    glow(Offset(s.width * 0.50, s.height * 0.45), s.width * 0.30,
        const Color(0xFF1E1A1A), 0.40);
  }

  @override
  bool shouldRepaint(_) => false;
}
