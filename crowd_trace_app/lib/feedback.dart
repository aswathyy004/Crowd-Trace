import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// ═══════════════════════════════════════════════════════════════════════════════
//  THEME  — matching app's dark-blue glassmorphic style
// ═══════════════════════════════════════════════════════════════════════════════
class _T {
  static const bgDeep       = Color(0xFF04091A);
  static const accentBlue   = Color(0xFF1D6BFF);
  static const accentCyan   = Color(0xFF00C2FF);
  static const accentPurple = Color(0xFF7B5CFF);
  static const accentGold   = Color(0xFFFFB730);   // star rating color
  static const success      = Color(0xFF00E5A0);
  static const textPrimary  = Color(0xFFEEF3FF);
  static const textSub      = Color(0xFF6E8CB8);
  static const glass        = Color(0x12FFFFFF);
  static const glassBorder  = Color(0x22FFFFFF);
}

// ═══════════════════════════════════════════════════════════════════════════════
//  ENTRY
// ═══════════════════════════════════════════════════════════════════════════════
void main() => runApp(const FeedbackScreen());

class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({super.key});
  @override
  Widget build(BuildContext context) => const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: FeedbackPage(title: 'My Feedbacks'),
  );
}

// ═══════════════════════════════════════════════════════════════════════════════
//  MAIN PAGE
// ═══════════════════════════════════════════════════════════════════════════════
class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key, required this.title});
  final String title;

  @override
  State<FeedbackPage> createState() => _ComplaintPageState();
}

class _ComplaintPageState extends State<FeedbackPage>
    with TickerProviderStateMixin {

  // ── data (original lists preserved) ──────────────────────────
  List<String> id_          = [];
  List<String> description_ = [];
  List<String> date_        = [];
  List<String> reply_       = [];

  final TextEditingController complaintController = TextEditingController();
  final ScrollController       _scrollCtrl        = ScrollController();
  final FocusNode              _focusNode          = FocusNode();

  bool isLoading  = true;
  bool isSending  = false;
  bool _isExpanded = false;

  // ── extras ───────────────────────────────────────────────────
  int    _starRating  = 0;           // 1–5 star rating
  String _selectedTag = '';          // quick mood tag
  int    _charCount   = 0;

  static const _moodTags = [
    '👍 Great',
    '💡 Suggestion',
    '🐛 Bug Report',
    '❤️ Compliment',
    '⚡ Performance',
  ];

  late final AnimationController _listAnim;
  late final AnimationController _composeAnim;
  late final AnimationController _pulseAnim;

  @override
  void initState() {
    super.initState();
    _listAnim    = AnimationController(vsync: this, duration: const Duration(milliseconds: 800))..forward();
    _composeAnim = AnimationController(vsync: this, duration: const Duration(milliseconds: 320));
    _pulseAnim   = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
    complaintController.addListener(() {
      setState(() => _charCount = complaintController.text.length);
    });
    user_view_complaints();
  }

  @override
  void dispose() {
    complaintController.dispose();
    _scrollCtrl.dispose();
    _focusNode.dispose();
    _listAnim.dispose();
    _composeAnim.dispose();
    _pulseAnim.dispose();
    super.dispose();
  }

  // ── backend: view feedbacks (original logic preserved) ────────
  Future<void> user_view_complaints() async {
    setState(() => isLoading = true);

    SharedPreferences sh = await SharedPreferences.getInstance();
    String urls = sh.getString('url') ?? '';
    String lid  = sh.getString('lid') ?? '';

    var response = await http.post(
      Uri.parse('$urls/user_view_feedback/'),
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
      Fluttertoast.showToast(msg: 'No feedback found');
      setState(() {
        id_ = []; description_ = []; date_ = []; reply_ = [];
        isLoading = false;
      });
    }
  }

  // ── backend: send feedback (original logic preserved) ─────────
  void _sendData() async {
    String complaintText = complaintController.text.trim();
    if (complaintText.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter your feedback");
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

    // Prepend tag + rating to message if selected
    String finalText = complaintText;
    if (_selectedTag.isNotEmpty) finalText = '$_selectedTag\n$finalText';
    if (_starRating > 0) finalText = '${'★' * _starRating}${'☆' * (5 - _starRating)}\n$finalText';

    var response = await http.post(
      Uri.parse('$url/user_send_feedback/'),
      body: {'complaint': finalText, 'lid': lid},
    );

    setState(() => isSending = false);

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      if (jsonData['status'] == 'ok') {
        Fluttertoast.showToast(msg: 'Feedback submitted — thank you!');
        complaintController.clear();
        setState(() { _starRating = 0; _selectedTag = ''; _charCount = 0; });
        _toggleCompose(open: false);
        await user_view_complaints();
      } else {
        Fluttertoast.showToast(msg: 'Failed to send feedback');
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

  // ─────────────────────────────────────────────────────────────
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
              if (!isLoading && id_.isNotEmpty) _buildSummaryBanner(),
              Expanded(child: _buildBody()),
              _buildComposePanel(),
            ]),
          ),
        ]),
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────────
  Widget _buildHeader() => Padding(
    padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
    child: Row(children: [
      _GlassButton(
        onTap: () => Navigator.pop(context),
        child: const Icon(Icons.arrow_back_ios_new_rounded,
            color: _T.textPrimary, size: 17),
      ),
      const SizedBox(width: 14),
      Expanded(child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShaderMask(
            shaderCallback: (r) => const LinearGradient(
              colors: [_T.textPrimary, _T.accentCyan],
            ).createShader(r),
            child: const Text("My Feedbacks",
                style: TextStyle(color: Colors.white, fontSize: 21,
                    fontWeight: FontWeight.w800, letterSpacing: 0.2)),
          ),
          Text(isLoading ? "Loading…"
              : "${id_.length} feedback${id_.length == 1 ? '' : 's'} submitted",
              style: const TextStyle(color: _T.textSub, fontSize: 12)),
        ],
      )),
      _GlassButton(
        onTap: user_view_complaints,
        child: const Icon(Icons.refresh_rounded, color: _T.accentCyan, size: 20),
      ),
    ]),
  );

  // ── Summary banner (avg stars etc.) ──────────────────────────
  Widget _buildSummaryBanner() {
    // Parse star ratings from stored messages (lines starting with ★)
    int ratingSum = 0, ratingCount = 0;
    for (final msg in description_) {
      final firstLine = msg.split('\n').first;
      final stars = firstLine.replaceAll('☆', '').replaceAll(' ', '');
      final count = '★'.allMatches(stars).length;
      if (count > 0 && count <= 5) { ratingSum += count; ratingCount++; }
    }
    final avgRating = ratingCount > 0
        ? (ratingSum / ratingCount).toStringAsFixed(1)
        : null;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _T.accentBlue.withOpacity(0.12),
                  _T.accentPurple.withOpacity(0.08),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _T.glassBorder),
            ),
            child: Row(children: [
              const Icon(Icons.auto_awesome_rounded,
                  size: 16, color: _T.accentGold),
              const SizedBox(width: 8),
              Expanded(child: Text(
                avgRating != null
                    ? "Your average rating: $avgRating / 5.0 ★"
                    : "Your feedback helps us improve the service",
                style: const TextStyle(color: _T.textPrimary,
                    fontSize: 13, fontWeight: FontWeight.w500),
              )),
              // total count chip
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _T.accentBlue.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _T.accentBlue.withOpacity(0.3)),
                ),
                child: Text('${id_.length} total',
                    style: const TextStyle(color: _T.accentCyan,
                        fontSize: 11, fontWeight: FontWeight.w700)),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  // ── Body ──────────────────────────────────────────────────────
  Widget _buildBody() {
    if (isLoading) {
      return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
        AnimatedBuilder(
          animation: _pulseAnim,
          builder: (_, __) => Transform.scale(
            scale: 0.9 + 0.1 * _pulseAnim.value,
            child: Container(
              width: 56, height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  _T.accentBlue.withOpacity(0.20 + 0.12 * _pulseAnim.value),
                  Colors.transparent,
                ]),
              ),
              child: const Center(child: SizedBox(width: 32, height: 32,
                  child: CircularProgressIndicator(strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(_T.accentCyan)))),
            ),
          ),
        ),
        const SizedBox(height: 14),
        const Text("Loading feedbacks…",
            style: TextStyle(color: _T.textSub, fontSize: 13)),
      ]));
    }

    if (id_.isEmpty) {
      return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.rate_review_outlined, size: 64,
            color: _T.textSub.withOpacity(0.22)),
        const SizedBox(height: 14),
        const Text("No feedbacks yet",
            style: TextStyle(color: _T.textSub, fontSize: 15,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        const Text("Tap + to share your first feedback",
            style: TextStyle(color: _T.textSub, fontSize: 12)),
      ]));
    }

    return RefreshIndicator(
      onRefresh: user_view_complaints,
      color: _T.accentCyan,
      backgroundColor: const Color(0xFF0D1B3E),
      child: ListView.builder(
        controller : _scrollCtrl,
        padding    : const EdgeInsets.fromLTRB(16, 0, 16, 16),
        itemCount  : id_.length,
        itemBuilder: (_, i) {
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
            child: _FeedbackCard(
              index      : i,
              description: description_[i],
              date       : date_[i],
              reply      : reply_[i],
            ),
          );
        },
      ),
    );
  }

  // ── Compose Panel ─────────────────────────────────────────────
  Widget _buildComposePanel() {
    return AnimatedBuilder(
      animation: _composeAnim,
      builder: (_, __) {
        final t = Curves.easeOutCubic.transform(_composeAnim.value);
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRect(child: Align(heightFactor: t, child: _buildComposeArea())),
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
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title row
                Row(children: [
                  const Icon(Icons.rate_review_rounded,
                      color: _T.accentCyan, size: 17),
                  const SizedBox(width: 8),
                  const Text("Share Feedback",
                      style: TextStyle(color: _T.textPrimary,
                          fontSize: 14, fontWeight: FontWeight.w700)),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => _toggleCompose(open: false),
                    child: const Icon(Icons.keyboard_arrow_down_rounded,
                        color: _T.textSub, size: 22),
                  ),
                ]),

                const SizedBox(height: 12),

                // ── Star rating ──────────────────────────────
                Row(children: [
                  const Text("Rate: ",
                      style: TextStyle(color: _T.textSub,
                          fontSize: 12, fontWeight: FontWeight.w500)),
                  const SizedBox(width: 4),
                  ...List.generate(5, (i) => GestureDetector(
                    onTap: () => setState(() =>
                    _starRating = (i + 1 == _starRating) ? 0 : i + 1),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        i < _starRating ? Icons.star_rounded : Icons.star_outline_rounded,
                        key: ValueKey('$i-${i < _starRating}'),
                        color: i < _starRating ? _T.accentGold : _T.textSub,
                        size: 26,
                      ),
                    ),
                  )),
                  const SizedBox(width: 8),
                  if (_starRating > 0)
                    Text(_ratingLabel(_starRating),
                        style: TextStyle(
                          color: _ratingColor(_starRating),
                          fontSize: 12, fontWeight: FontWeight.w600,
                        )),
                ]),

                const SizedBox(height: 10),

                // ── Mood tags ────────────────────────────────
                SizedBox(
                  height: 32,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _moodTags.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 6),
                    itemBuilder: (_, i) {
                      final active = _selectedTag == _moodTags[i];
                      return GestureDetector(
                        onTap: () => setState(() =>
                        _selectedTag = active ? '' : _moodTags[i]),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: active
                                ? _T.accentBlue.withOpacity(0.25)
                                : _T.glass,
                            border: Border.all(
                              color: active ? _T.accentBlue : _T.glassBorder,
                            ),
                          ),
                          child: Text(_moodTags[i],
                              style: TextStyle(
                                color: active ? _T.accentCyan : _T.textSub,
                                fontSize: 11,
                                fontWeight: active
                                    ? FontWeight.w700 : FontWeight.w400,
                              )),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 10),

                // ── Text field ───────────────────────────────
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: Container(
                      decoration: BoxDecoration(
                        color: _T.glass,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: _charCount > 450
                            ? Colors.orange.withOpacity(0.5)
                            : _T.glassBorder),
                      ),
                      child: TextField(
                        controller : complaintController,
                        focusNode  : _focusNode,
                        maxLines   : 3,
                        maxLength  : 500,
                        style      : const TextStyle(
                            color: _T.textPrimary, fontSize: 14, height: 1.5),
                        decoration : InputDecoration(
                          hintText: "Write your feedback here…",
                          hintStyle: const TextStyle(
                              color: _T.textSub, fontSize: 13),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(14),
                          counterStyle: TextStyle(
                            color: _charCount > 450
                                ? Colors.orange : _T.textSub,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // ── Submit row ───────────────────────────────
                Row(children: [
                  const Icon(Icons.lock_outline_rounded,
                      size: 12, color: _T.textSub),
                  const SizedBox(width: 4),
                  const Expanded(
                    child: Text("Your feedback is private and secure.",
                        style: TextStyle(color: _T.textSub, fontSize: 11)),
                  ),
                  GestureDetector(
                    onTap: isSending ? null : _sendData,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 11),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        gradient: isSending
                            ? LinearGradient(colors: [
                          _T.accentBlue.withOpacity(0.4),
                          _T.accentPurple.withOpacity(0.4),
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
                        Icon(Icons.send_rounded,
                            color: Colors.white, size: 15),
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

  Widget _buildBottomBar() => ClipRect(
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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _T.glass,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _T.glassBorder),
              ),
              child: Row(children: [
                const Icon(Icons.rate_review_outlined,
                    size: 13, color: _T.textSub),
                const SizedBox(width: 5),
                Text("${id_.length} feedback${id_.length == 1 ? '' : 's'}",
                    style: const TextStyle(color: _T.textSub, fontSize: 12)),
              ]),
            ),
            // FAB
            GestureDetector(
              onTap: _toggleCompose,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 52, height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: _isExpanded
                      ? LinearGradient(colors: [
                    Colors.white.withOpacity(0.10),
                    Colors.white.withOpacity(0.05),
                  ])
                      : const LinearGradient(
                    colors: [_T.accentBlue, _T.accentPurple],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
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

  // ── star helpers ──────────────────────────────────────────────
  String _ratingLabel(int r) {
    switch (r) {
      case 1: return 'Poor';
      case 2: return 'Fair';
      case 3: return 'Good';
      case 4: return 'Great';
      case 5: return 'Excellent!';
      default: return '';
    }
  }

  Color _ratingColor(int r) {
    if (r <= 2) return Colors.redAccent;
    if (r == 3) return _T.accentGold;
    return _T.success;
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  FEEDBACK CARD
// ═══════════════════════════════════════════════════════════════════════════════
class _FeedbackCard extends StatefulWidget {
  final int    index;
  final String description;
  final String date;
  final String reply;
  const _FeedbackCard({
    required this.index,
    required this.description,
    required this.date,
    required this.reply,
  });

  @override
  State<_FeedbackCard> createState() => _FeedbackCardState();
}

class _FeedbackCardState extends State<_FeedbackCard> {
  bool _expanded = false;

  // ── parse embedded stars ──────────────────────────────────────
  int get _stars {
    final firstLine = widget.description.split('\n').first;
    if (!firstLine.contains('★')) return 0;
    return '★'.allMatches(firstLine).length.clamp(0, 5);
  }

  String get _cleanText {
    final lines = widget.description.split('\n');
    // Remove first line if it's stars, second if it's a tag
    int skip = 0;
    if (lines.isNotEmpty && lines[0].contains('★')) skip++;
    if (lines.length > skip && _moodTags.any((t) => lines[skip].contains(t.substring(2)))) skip++;
    return lines.sublist(skip).join('\n').trim();
  }

  String get _tag {
    final lines = widget.description.split('\n');
    int checkIdx = (lines.isNotEmpty && lines[0].contains('★')) ? 1 : 0;
    if (lines.length > checkIdx) {
      for (final tag in _moodTags) {
        if (lines[checkIdx].contains(tag.substring(2))) return tag;
      }
    }
    return '';
  }

  static const _moodTags = [
    '👍 Great', '💡 Suggestion', '🐛 Bug Report',
    '❤️ Compliment', '⚡ Performance',
  ];

  bool _hasReply(String r) {
    final t = r.trim();
    if (t.isEmpty) return false;
    const placeholders = {
      'null', 'none', 'pending', 'no reply', 'no reply yet',
      'n/a', 'na', '-', '--', '...', '..', '.',
    };
    return !placeholders.contains(t.toLowerCase());
  }

  @override
  Widget build(BuildContext context) {
    final hasReply = _hasReply(widget.reply);
    final stars    = _stars;
    final tag      = _tag;
    final text     = _cleanText.isNotEmpty ? _cleanText : widget.description;

    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: hasReply
                ? _T.success.withOpacity(0.28)
                : _T.glassBorder,
            width: hasReply ? 1.2 : 1.0,
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
              color: _T.accentBlue.withOpacity(0.06),
              blurRadius: 18, spreadRadius: -6,
              offset: const Offset(0, 8),
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
                    // Index circle
                    Container(
                      width: 26, height: 26,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [_T.accentBlue, _T.accentPurple],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Center(child: Text('${widget.index + 1}',
                          style: const TextStyle(color: Colors.white,
                              fontSize: 10, fontWeight: FontWeight.w800))),
                    ),
                    const SizedBox(width: 10),
                    // Tag chip
                    if (tag.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: _T.accentBlue.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: _T.accentBlue.withOpacity(0.25)),
                        ),
                        child: Text(tag,
                            style: const TextStyle(
                                color: _T.accentCyan, fontSize: 10)),
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
                    const SizedBox(width: 8),
                    Icon(
                        _expanded
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                        color: _T.textSub, size: 18),
                  ]),

                  // ── Star rating display ─────────────────────
                  if (stars > 0) ...[
                    const SizedBox(height: 10),
                    Row(children: [
                      ...List.generate(5, (i) => Icon(
                        i < stars
                            ? Icons.star_rounded
                            : Icons.star_outline_rounded,
                        color: i < stars ? _T.accentGold : _T.textSub,
                        size: 16,
                      )),
                      const SizedBox(width: 6),
                      Text(_ratingLabel(stars),
                          style: TextStyle(
                            color: _ratingColor(stars),
                            fontSize: 11, fontWeight: FontWeight.w600,
                          )),
                    ]),
                  ],

                  const SizedBox(height: 10),

                  // ── Feedback text ──────────────────────────
                  Text(
                    text,
                    maxLines: _expanded ? null : 2,
                    overflow: _expanded
                        ? TextOverflow.visible
                        : TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: _T.textPrimary, fontSize: 14, height: 1.55),
                  ),

                  // ── Reply block ────────────────────────────
                  if (hasReply && _expanded) ...[
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
                          const Row(children: [
                            Icon(Icons.reply_rounded,
                                size: 13, color: _T.success),
                            SizedBox(width: 5),
                            Text("Official Response",
                                style: TextStyle(color: _T.success,
                                    fontSize: 11, fontWeight: FontWeight.w700)),
                          ]),
                          const SizedBox(height: 6),
                          Text(widget.reply,
                              style: const TextStyle(
                                  color: _T.textPrimary,
                                  fontSize: 13, height: 1.5)),
                        ],
                      ),
                    ),
                  ] else if (hasReply && !_expanded) ...[
                    const SizedBox(height: 8),
                    Row(children: [
                      const Icon(Icons.reply_rounded,
                          size: 12, color: _T.success),
                      const SizedBox(width: 4),
                      const Text("Response received — tap to view",
                          style: TextStyle(color: _T.success, fontSize: 11)),
                    ]),
                  ],

                  if (!_expanded && text.length > 80) ...[
                    const SizedBox(height: 6),
                    const Text("Tap to expand",
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

  String _ratingLabel(int r) {
    switch (r) {
      case 1: return 'Poor';
      case 2: return 'Fair';
      case 3: return 'Good';
      case 4: return 'Great';
      case 5: return 'Excellent!';
      default: return '';
    }
  }

  Color _ratingColor(int r) {
    if (r <= 2) return Colors.redAccent;
    if (r == 3) return _T.accentGold;
    return _T.success;
  }
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
    glow(Offset(s.width * 0.82, s.height * 0.06), s.width * 0.50,
        _T.accentBlue, 0.22);
    glow(Offset(s.width * 0.12, s.height * 0.88), s.width * 0.44,
        _T.accentPurple, 0.16);
    glow(Offset(s.width * 0.50, s.height * 0.46), s.width * 0.28,
        _T.accentCyan, 0.05);
  }
  @override
  bool shouldRepaint(_) => false;
}