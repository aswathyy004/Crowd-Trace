import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class _T {
  static const bgDeep = Color(0xFF04091A);
  static const accentBlue = Color(0xFF1D6BFF);
  static const accentCyan = Color(0xFF00C2FF);
  static const accentPurple = Color(0xFF7B5CFF);
  static const accentRed = Color(0xFFFF4057);
  static const success = Color(0xFF00E676);
  static const textPrimary = Color(0xFFEEF3FF);
  static const textSub = Color(0xFF6E8CB8);
  static const glass = Color(0x12FFFFFF);
  static const glassBorder = Color(0x22FFFFFF);
}

class ReportCasePage extends StatefulWidget {
  const ReportCasePage({super.key});

  @override
  State<ReportCasePage> createState() => _ReportCasePageState();
}

class _ReportCasePageState extends State<ReportCasePage>
    with SingleTickerProviderStateMixin {

  /// CONTROLLERS

  final descriptionController = TextEditingController();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();

  final missingPlaceController = TextEditingController();
  final ageController = TextEditingController();
  final dobController = TextEditingController();
  final genderController = TextEditingController();
  final parentController = TextEditingController();
  final itemsController = TextEditingController();
  final heightController = TextEditingController();
  final marksController = TextEditingController();
  final clothesController = TextEditingController();

  File? image;
  bool loading = false;

  double latitude = 0;
  double longitude = 0;

  final picker = ImagePicker();

  late AnimationController _pulse;

  @override
  void initState() {
    super.initState();

    _pulse = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 2))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  /// IMAGE

  Future pickCamera() async {
    final picked = await picker.pickImage(source: ImageSource.camera);
    if (picked != null) {
      setState(() {
        image = File(picked.path);
      });
    }
  }

  Future pickGallery() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        image = File(picked.path);
      });
    }
  }

  /// LOCATION

  Future getLocation() async {

    Location location = Location();

    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
    }

    PermissionStatus permission = await location.hasPermission();
    if (permission == PermissionStatus.denied) {
      permission = await location.requestPermission();
    }

    LocationData data = await location.getLocation();

    latitude = data.latitude!;
    longitude = data.longitude!;
  }

  /// SEND CASE

  Future sendCase() async {

    if (descriptionController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Enter case description");
      return;
    }

    if (image == null) {
      Fluttertoast.showToast(msg: "Upload photo");
      return;
    }

    setState(() {
      loading = true;
    });

    await getLocation();

    SharedPreferences sh = await SharedPreferences.getInstance();

    String url = sh.getString("url").toString();
    String lid = sh.getString("lid").toString();

    var uri = Uri.parse("$url/user_report_case/");

    var request = http.MultipartRequest("POST", uri);

    request.fields['lid'] = lid;
    request.fields['description'] = descriptionController.text;
    request.fields['latitude'] = latitude.toString();
    request.fields['longitude'] = longitude.toString();

    request.fields['name'] = nameController.text;
    request.fields['phone'] = phoneController.text;
    request.fields['email'] = emailController.text;
    request.fields['address'] = addressController.text;

    request.fields['missing_place'] = missingPlaceController.text;
    request.fields['age'] = ageController.text;
    request.fields['date_of_birth'] = dobController.text;
    request.fields['gender'] = genderController.text;
    request.fields['parent_name'] = parentController.text;
    request.fields['items_carried'] = itemsController.text;
    request.fields['height'] = heightController.text;
    request.fields['identification_marks'] = marksController.text;
    request.fields['clothes_ornaments'] = clothesController.text;

    request.files.add(
        await http.MultipartFile.fromPath('photo', image!.path));

    var response = await request.send();
    var res = await http.Response.fromStream(response);

    var data = jsonDecode(res.body);

    setState(() {
      loading = false;
    });

    if (data['status'] == "ok") {

      Fluttertoast.showToast(
          msg: "Case sent to: ${data['station']}");

      Navigator.pop(context);

    } else {

      Fluttertoast.showToast(msg: "Failed to submit case");

    }
  }

  /// UI

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: _T.bgDeep,

      body: Stack(
        children: [

          const _BgPainter(),

          SafeArea(
            child: Column(
              children: [

                _header(),

                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(20),

                    child: Column(
                      children: [

                        _inputCard("Name", nameController),
                        const SizedBox(height: 15),

                        _inputCard("Phone", phoneController),
                        const SizedBox(height: 15),

                        _inputCard("Email", emailController),
                        const SizedBox(height: 15),

                        _inputCard("Address", addressController),
                        const SizedBox(height: 15),

                        _inputCard("Missing Place", missingPlaceController),
                        const SizedBox(height: 15),

                        _inputCard("Age", ageController),
                        const SizedBox(height: 15),

                        _inputCard("Date of Birth", dobController),
                        const SizedBox(height: 15),

                        _inputCard("Gender", genderController),
                        const SizedBox(height: 15),

                        _inputCard("Parent Name", parentController),
                        const SizedBox(height: 15),

                        _inputCard("Items Carried", itemsController),
                        const SizedBox(height: 15),

                        _inputCard("Height", heightController),
                        const SizedBox(height: 15),

                        _inputCard("Identification Marks", marksController),
                        const SizedBox(height: 15),

                        _inputCard("Clothes / Ornaments", clothesController),
                        const SizedBox(height: 20),

                        _descriptionCard(),
                        const SizedBox(height: 20),

                        _imagePreview(),
                        const SizedBox(height: 15),

                        _imageButtons(),
                        const SizedBox(height: 30),

                        _submitButton(),

                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  /// HEADER

  Widget _header() {

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [

          _GlassButton(
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: _T.textPrimary, size: 18)
          ),

          const SizedBox(width: 15),

          ShaderMask(
            shaderCallback: (r) => const LinearGradient(
                colors: [_T.textPrimary, _T.accentCyan]
            ).createShader(r),
            child: const Text(
              "Report Case",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Colors.white
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// INPUT CARD

  Widget _inputCard(String title, TextEditingController controller) {

    return ClipRRect(
      borderRadius: BorderRadius.circular(18),

      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),

        child: Container(
          padding: const EdgeInsets.all(16),

          decoration: BoxDecoration(
            color: _T.glass,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: _T.glassBorder),
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              Text(
                title,
                style: const TextStyle(
                    color: _T.textPrimary,
                    fontWeight: FontWeight.w700
                ),
              ),

              const SizedBox(height: 10),

              TextField(
                controller: controller,
                style: const TextStyle(color: _T.textPrimary),

                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Enter",
                  hintStyle: TextStyle(color: _T.textSub),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// DESCRIPTION CARD

  Widget _descriptionCard() {

    return _inputCard("Case Description", descriptionController);
  }

  /// IMAGE PREVIEW

  Widget _imagePreview() {

    return ClipRRect(
      borderRadius: BorderRadius.circular(18),

      child: Container(
        height: 200,
        width: double.infinity,

        decoration: BoxDecoration(
          color: _T.glass,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: _T.glassBorder),
        ),

        child: image == null
            ? const Center(
          child: Text(
            "No Image Selected",
            style: TextStyle(color: _T.textSub),
          ),
        )
            : Image.file(image!, fit: BoxFit.cover),
      ),
    );
  }

  /// IMAGE BUTTONS

  Widget _imageButtons() {

    return Row(
      children: [

        Expanded(
          child: _actionButton(
              "Camera",
              Icons.camera_alt_rounded,
              _T.accentBlue,
              pickCamera
          ),
        ),

        const SizedBox(width: 15),

        Expanded(
          child: _actionButton(
              "Gallery",
              Icons.photo_rounded,
              _T.accentPurple,
              pickGallery
          ),
        ),
      ],
    );
  }

  /// SUBMIT BUTTON

  Widget _submitButton() {

    return GestureDetector(
      onTap: loading ? null : sendCase,

      child: AnimatedBuilder(
        animation: _pulse,

        builder: (_, __) {

          final glow = 0.2 + (_pulse.value * 0.2);

          return Container(
            width: double.infinity,

            padding: const EdgeInsets.symmetric(vertical: 16),

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),

              gradient: const LinearGradient(
                colors: [_T.accentRed, _T.accentPurple],
              ),

              boxShadow: [
                BoxShadow(
                  color: _T.accentRed.withOpacity(glow),
                  blurRadius: 20,
                )
              ],
            ),

            child: Center(
              child: loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                "Submit Case",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// BUTTON

  Widget _actionButton(
      String text,
      IconData icon,
      Color color,
      VoidCallback onTap
      ) {

    return GestureDetector(
      onTap: onTap,

      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),

          gradient: LinearGradient(
              colors: [color, color.withOpacity(0.6)]
          ),
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            Icon(icon, color: Colors.white),

            const SizedBox(width: 8),

            Text(text,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600
                )),
          ],
        ),
      ),
    );
  }
}

/// GLASS BUTTON

class _GlassButton extends StatelessWidget {

  final VoidCallback onTap;
  final Widget child;

  const _GlassButton({
    required this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: onTap,

      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),

        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),

          child: Container(
            width: 42,
            height: 42,

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
}

/// BACKGROUND

class _BgPainter extends StatelessWidget {
  const _BgPainter();

  @override
  Widget build(BuildContext context) =>
      SizedBox.expand(child: CustomPaint(painter: _BgCP()));
}

class _BgCP extends CustomPainter {

  @override
  void paint(Canvas canvas, Size s) {

    canvas.drawRect(
        Rect.fromLTWH(0, 0, s.width, s.height),
        Paint()..color = _T.bgDeep
    );

    void glow(Offset c, double r, Color col, double op) {

      canvas.drawCircle(
          c,
          r,
          Paint()
            ..shader = RadialGradient(
                colors: [col.withOpacity(op), Colors.transparent]
            ).createShader(Rect.fromCircle(center: c, radius: r))
      );
    }

    glow(Offset(s.width * 0.8, s.height * 0.1), s.width * 0.5,
        _T.accentBlue, 0.25);

    glow(Offset(s.width * 0.2, s.height * 0.9), s.width * 0.4,
        _T.accentPurple, 0.20);
  }

  @override
  bool shouldRepaint(_) => false;
}







//
//
//
// import 'dart:convert';
// import 'dart:io';
// import 'dart:ui';
// import 'dart:math' as math;
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:location/location.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
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
//   static const accentRed    = Color(0xFFFF4057);
//   static const accentGreen  = Color(0xFF00E676);
//   static const accentGold   = Color(0xFFFFB547);
//   static const textPrimary  = Color(0xFFEEF3FF);
//   static const textSub      = Color(0xFF5A7299);
//   static const textMid      = Color(0xFF8AAAD4);
//   static const glass        = Color(0x0FFFFFFF);
//   static const glassBorder  = Color(0x18FFFFFF);
// }
//
// // ─────────────────────────────────────────────────────────────────────────────
// //  PAGE
// // ─────────────────────────────────────────────────────────────────────────────
// class ReportCasePage extends StatefulWidget {
//   const ReportCasePage({super.key});
//   @override
//   State<ReportCasePage> createState() => _ReportCasePageState();
// }
//
// class _ReportCasePageState extends State<ReportCasePage>
//     with SingleTickerProviderStateMixin {
//
//   // ── controllers (same field names sent to backend) ──────────────────────
//   final _desc        = TextEditingController(); // description
//   final _name        = TextEditingController(); // name
//   final _phone       = TextEditingController(); // phone
//   final _email       = TextEditingController(); // email
//   final _address     = TextEditingController(); // address
//   final _place       = TextEditingController(); // missing_place
//   final _age         = TextEditingController(); // age
//   final _dob         = TextEditingController(); // date_of_birth
//   final _parent      = TextEditingController(); // parent_name
//   final _items       = TextEditingController(); // items_carried
//   final _height      = TextEditingController(); // height
//   final _marks       = TextEditingController(); // identification_marks
//   final _clothes     = TextEditingController(); // clothes_ornaments
//
//   // gender stored as a string value — sent to backend as-is
//   String _gender = '';
//
//   File?  _image;
//   bool   _loading = false;
//   double _latitude = 0, _longitude = 0;
//
//   final _picker = ImagePicker();
//   late  AnimationController _pulse;
//
//   // step tracker (0=reporter, 1=missing person, 2=description+photo)
//   int _step = 0;
//   final _pageCtrl = PageController();
//
//   @override
//   void initState() {
//     super.initState();
//     _pulse = AnimationController(vsync: this,
//         duration: const Duration(seconds: 2))..repeat(reverse: true);
//   }
//
//   @override
//   void dispose() {
//     _pulse.dispose();
//     _pageCtrl.dispose();
//     for (final c in [_desc,_name,_phone,_email,_address,
//       _place,_age,_dob,_parent,_items,
//       _height,_marks,_clothes]) { c.dispose(); }
//     super.dispose();
//   }
//
//   // ── image ────────────────────────────────────────────────────────────────
//   Future<void> _pickCamera() async {
//     final p = await _picker.pickImage(source: ImageSource.camera, imageQuality: 85);
//     if (p != null) setState(() => _image = File(p.path));
//   }
//
//   Future<void> _pickGallery() async {
//     final p = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
//     if (p != null) setState(() => _image = File(p.path));
//   }
//
//   // ── date picker ──────────────────────────────────────────────────────────
//   Future<void> _pickDob() async {
//     final now = DateTime.now();
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime(now.year - 20),
//       firstDate: DateTime(1920),
//       lastDate: now,
//       builder: (ctx, child) => Theme(
//         data: ThemeData.dark().copyWith(
//           colorScheme: const ColorScheme.dark(
//             primary: _T.accentCyan,
//             onPrimary: Colors.white,
//             surface: Color(0xFF0C1535),
//             onSurface: _T.textPrimary,
//           ),
//           dialogBackgroundColor: _T.surface,
//         ),
//         child: child!,
//       ),
//     );
//     if (picked != null) {
//       final d = '${picked.day.toString().padLeft(2,'0')}-'
//           '${picked.month.toString().padLeft(2,'0')}-'
//           '${picked.year}';
//       _dob.text = d;
//       // auto-fill age
//       final age = now.year - picked.year -
//           (now.month < picked.month ||
//               (now.month == picked.month && now.day < picked.day) ? 1 : 0);
//       _age.text = age.toString();
//       setState(() {});
//     }
//   }
//
//   // ── location ─────────────────────────────────────────────────────────────
//   Future<void> _getLocation() async {
//     final loc = Location();
//     if (!await loc.serviceEnabled()) await loc.requestService();
//     if (await loc.hasPermission() == PermissionStatus.denied) {
//       await loc.requestPermission();
//     }
//     final d = await loc.getLocation();
//     _latitude  = d.latitude!;
//     _longitude = d.longitude!;
//   }
//
//   // ── validation ───────────────────────────────────────────────────────────
//   bool _validateStep(int step) {
//     if (step == 0) {
//       if (_name.text.trim().isEmpty) { _toast('Enter reporter name'); return false; }
//       if (_phone.text.trim().isEmpty) { _toast('Enter phone number'); return false; }
//     }
//     if (step == 1) {
//       if (_place.text.trim().isEmpty) { _toast('Enter missing place'); return false; }
//       if (_gender.isEmpty) { _toast('Select gender'); return false; }
//     }
//     if (step == 2) {
//       if (_desc.text.trim().isEmpty) { _toast('Enter case description'); return false; }
//       if (_image == null) { _toast('Please upload a photo'); return false; }
//     }
//     return true;
//   }
//
//   void _toast(String msg) => Fluttertoast.showToast(
//       msg: msg,
//       backgroundColor: _T.card,
//       textColor: _T.textPrimary);
//
//   // ── submit ───────────────────────────────────────────────────────────────
//   Future<void> _submit() async {
//     if (!_validateStep(2)) return;
//     setState(() => _loading = true);
//
//     try {
//       await _getLocation();
//       final sh  = await SharedPreferences.getInstance();
//       final url = sh.getString('url') ?? '';
//       final lid = sh.getString('lid') ?? '';
//
//       final req = http.MultipartRequest('POST', Uri.parse('$url/user_report_case/'));
//
//       // ── exact same field names the backend expects ──
//       req.fields['lid']                  = lid;
//       req.fields['description']          = _desc.text;
//       req.fields['latitude']             = _latitude.toString();
//       req.fields['longitude']            = _longitude.toString();
//       req.fields['name']                 = _name.text;
//       req.fields['phone']                = _phone.text;
//       req.fields['email']                = _email.text;
//       req.fields['address']              = _address.text;
//       req.fields['missing_place']        = _place.text;
//       req.fields['age']                  = _age.text;
//       req.fields['date_of_birth']        = _dob.text;
//       req.fields['gender']               = _gender;
//       req.fields['parent_name']          = _parent.text;
//       req.fields['items_carried']        = _items.text;
//       req.fields['height']               = _height.text;
//       req.fields['identification_marks'] = _marks.text;
//       req.fields['clothes_ornaments']    = _clothes.text;
//
//       req.files.add(await http.MultipartFile.fromPath('photo', _image!.path));
//
//       final streamed = await req.send();
//       final res      = await http.Response.fromStream(streamed);
//       final data     = jsonDecode(res.body);
//
//       if (data['status'] == 'ok') {
//         _toast('Case sent to: ${data['station']}');
//         if (mounted) Navigator.pop(context);
//       } else {
//         _toast('Failed to submit case');
//       }
//     } catch (e) {
//       _toast('Network error. Please try again.');
//     }
//
//     if (mounted) setState(() => _loading = false);
//   }
//
//   // ── navigation ───────────────────────────────────────────────────────────
//   void _next() {
//     if (!_validateStep(_step)) return;
//     if (_step < 2) {
//       setState(() => _step++);
//       _pageCtrl.animateToPage(_step,
//           duration: const Duration(milliseconds: 380),
//           curve: Curves.easeInOutCubic);
//     } else {
//       _submit();
//     }
//   }
//
//   void _prev() {
//     if (_step > 0) {
//       setState(() => _step--);
//       _pageCtrl.animateToPage(_step,
//           duration: const Duration(milliseconds: 380),
//           curve: Curves.easeInOutCubic);
//     } else {
//       Navigator.pop(context);
//     }
//   }
//
//   // ─────────────────────────────────────────────────────────────────────────
//   //  BUILD
//   // ─────────────────────────────────────────────────────────────────────────
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: _T.bg,
//       body: Stack(children: [
//         // Animated background
//         const _RcBg(),
//
//         SafeArea(child: Column(children: [
//           // ── App bar ──────────────────────────────────────────────
//           _AppBar(onBack: _prev, step: _step),
//
//           // ── Step indicator ───────────────────────────────────────
//           _StepBar(step: _step),
//
//           const SizedBox(height: 6),
//
//           // ── Page content ─────────────────────────────────────────
//           Expanded(child: PageView(
//             controller: _pageCtrl,
//             physics: const NeverScrollableScrollPhysics(),
//             children: [
//               _Step1(
//                 name: _name, phone: _phone,
//                 email: _email, address: _address,
//               ),
//               _Step2(
//                 place: _place, age: _age, dob: _dob,
//                 gender: _gender, parent: _parent,
//                 height: _height, marks: _marks, clothes: _clothes,
//                 items: _items,
//                 onPickDob: _pickDob,
//                 onGender: (v) => setState(() => _gender = v),
//               ),
//               _Step3(
//                 desc: _desc, image: _image,
//                 onCamera: _pickCamera, onGallery: _pickGallery,
//               ),
//             ],
//           )),
//
//           // ── Bottom button ─────────────────────────────────────────
//           _BottomBtn(
//             step: _step, loading: _loading,
//             pulse: _pulse, onTap: _next,
//           ),
//         ])),
//       ]),
//     );
//   }
// }
//
// // ─────────────────────────────────────────────────────────────────────────────
// //  APP BAR
// // ─────────────────────────────────────────────────────────────────────────────
// class _AppBar extends StatelessWidget {
//   final VoidCallback onBack; final int step;
//   const _AppBar({required this.onBack, required this.step});
//
//   static const _titles = ['Reporter Info', 'Missing Person', 'Details & Photo'];
//
//   @override
//   Widget build(BuildContext context) {
//     // back button
//     final backBtn = GestureDetector(
//       onTap: onBack,
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(12),
//         child: BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//           child: Container(
//             width: 40, height: 40,
//             decoration: BoxDecoration(
//               color: _T.glass,
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(color: _T.glassBorder),
//             ),
//             child: const Icon(Icons.arrow_back_ios_new_rounded,
//                 color: _T.textPrimary, size: 17),
//           ),
//         ),
//       ),
//     );
//
//     // title column
//     final titleCol = Expanded(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           ShaderMask(
//             shaderCallback: (r) => const LinearGradient(
//                 colors: [_T.textPrimary, _T.accentCyan]).createShader(r),
//             child: const Text('Report Missing Case',
//                 style: TextStyle(color: Colors.white,
//                     fontSize: 18, fontWeight: FontWeight.w800)),
//           ),
//           Text(_titles[step],
//               style: const TextStyle(color: _T.textSub, fontSize: 11.5)),
//         ],
//       ),
//     );
//
//     // step badge
//     final badge = Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//       decoration: BoxDecoration(
//         color: _T.accentBlue.withOpacity(0.14),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: _T.accentBlue.withOpacity(0.30)),
//       ),
//       child: Text('${step + 1} / 3',
//           style: const TextStyle(color: _T.accentCyan,
//               fontSize: 11, fontWeight: FontWeight.w800)),
//     );
//
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
//       child: Row(
//         children: [
//           backBtn,
//           const SizedBox(width: 14),
//           titleCol,
//           badge,
//         ],
//       ),
//     );
//   }
// }
//
// // ─────────────────────────────────────────────────────────────────────────────
// //  STEP PROGRESS BAR
// // ─────────────────────────────────────────────────────────────────────────────
// class _StepBar extends StatelessWidget {
//   final int step;
//   const _StepBar({required this.step});
//
//   @override
//   Widget build(BuildContext context) {
//     const labels = ['Reporter', 'Person', 'Submit'];
//     const icons  = [Icons.person_outlined, Icons.person_search_outlined, Icons.send_rounded];
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
//       child: Row(children: List.generate(3, (i) {
//         final done   = i < step;
//         final active = i == step;
//         final color  = done ? _T.accentGreen : active ? _T.accentCyan : _T.textSub;
//         return Expanded(child: Row(children: [
//           Expanded(child: Column(children: [
//             // circle
//             AnimatedContainer(duration: const Duration(milliseconds: 300),
//                 width: 38, height: 38,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   gradient: active ? const LinearGradient(
//                       colors: [_T.accentBlue, _T.accentCyan],
//                       begin: Alignment.topLeft, end: Alignment.bottomRight) : null,
//                   color: active ? null : done
//                       ? _T.accentGreen.withOpacity(0.14)
//                       : _T.card,
//                   border: Border.all(color: color.withOpacity(0.50), width: 1.5),
//                   boxShadow: active ? [BoxShadow(color: _T.accentCyan.withOpacity(0.30),
//                       blurRadius: 10)] : [],
//                 ),
//                 child: Icon(done ? Icons.check_rounded : icons[i],
//                     color: done ? _T.accentGreen : active ? Colors.white : _T.textSub,
//                     size: 17)),
//             const SizedBox(height: 5),
//             Text(labels[i], style: TextStyle(color: color,
//                 fontSize: 9.5, fontWeight: FontWeight.w600)),
//           ])),
//           // connector line
//           if (i < 2)
//             Expanded(child: Container(
//               height: 2, margin: const EdgeInsets.only(bottom: 18),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(1),
//                 gradient: i < step
//                     ? const LinearGradient(colors: [_T.accentGreen, _T.accentCyan])
//                     : null,
//                 color: i < step ? null : _T.glassBorder,
//               ),
//             )),
//         ]));
//       })),
//     );
//   }
// }
//
// // ─────────────────────────────────────────────────────────────────────────────
// //  STEP 1  — Reporter info
// // ─────────────────────────────────────────────────────────────────────────────
// class _Step1 extends StatelessWidget {
//   final TextEditingController name, phone, email, address;
//   const _Step1({required this.name, required this.phone,
//     required this.email, required this.address});
//
//   @override
//   Widget build(BuildContext context) => SingleChildScrollView(
//     physics: const BouncingScrollPhysics(),
//     padding: const EdgeInsets.fromLTRB(18, 16, 18, 20),
//     child: Column(children: [
//       _SectionCard(
//         title: 'Your Contact Details',
//         icon: Icons.contact_phone_rounded,
//         color: _T.accentBlue,
//         children: [
//           _Field(label: 'Full Name *', ctrl: name,
//               hint: 'Enter your full name',
//               icon: Icons.person_outline_rounded),
//           _Field(label: 'Phone Number *', ctrl: phone,
//               hint: 'Enter mobile number',
//               icon: Icons.phone_outlined,
//               keyboard: TextInputType.phone,
//               inputFormatters: [FilteringTextInputFormatter.digitsOnly]),
//           _Field(label: 'Email Address', ctrl: email,
//               hint: 'Enter email (optional)',
//               icon: Icons.email_outlined,
//               keyboard: TextInputType.emailAddress),
//           _Field(label: 'Your Address', ctrl: address,
//               hint: 'Enter your address',
//               icon: Icons.home_outlined,
//               maxLines: 2),
//         ],
//       ),
//       const SizedBox(height: 16),
//       // Info note
//       Container(
//         padding: const EdgeInsets.all(14),
//         decoration: BoxDecoration(
//           color: _T.accentBlue.withOpacity(0.07),
//           borderRadius: BorderRadius.circular(14),
//           border: Border.all(color: _T.accentBlue.withOpacity(0.20)),
//         ),
//         child: const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
//           Icon(Icons.info_outline_rounded, color: _T.accentCyan, size: 16),
//           SizedBox(width: 8),
//           Expanded(child: Text(
//             'Your contact details help police reach you for follow-up. '
//                 'Phone number is required for verification.',
//             style: TextStyle(color: _T.textMid, fontSize: 11.5, height: 1.5),
//           )),
//         ]),
//       ),
//     ]),
//   );
// }
//
// // ─────────────────────────────────────────────────────────────────────────────
// //  STEP 2  — Missing person details
// // ─────────────────────────────────────────────────────────────────────────────
// class _Step2 extends StatelessWidget {
//   final TextEditingController place, age, dob, parent, height, marks, clothes, items;
//   final String gender;
//   final VoidCallback onPickDob;
//   final ValueChanged<String> onGender;
//
//   const _Step2({
//     required this.place, required this.age, required this.dob,
//     required this.gender, required this.parent, required this.height,
//     required this.marks, required this.clothes, required this.items,
//     required this.onPickDob, required this.onGender,
//   });
//
//   @override
//   Widget build(BuildContext context) => SingleChildScrollView(
//     physics: const BouncingScrollPhysics(),
//     padding: const EdgeInsets.fromLTRB(18, 16, 18, 20),
//     child: Column(children: [
//
//       // Location
//       _SectionCard(
//         title: 'Where & When',
//         icon: Icons.location_on_rounded,
//         color: _T.accentRed,
//         children: [
//           _Field(label: 'Last Known Location *', ctrl: place,
//               hint: 'Where was the person last seen?',
//               icon: Icons.place_outlined, maxLines: 2),
//         ],
//       ),
//
//       const SizedBox(height: 14),
//
//       // Identity
//       _SectionCard(
//         title: 'Personal Details',
//         icon: Icons.badge_outlined,
//         color: _T.accentPurple,
//         children: [
//           // DOB picker row
//           _DateField(label: 'Date of Birth', ctrl: dob, onTap: onPickDob),
//           _Field(label: 'Age', ctrl: age,
//               hint: 'Auto-filled from DOB',
//               icon: Icons.cake_outlined,
//               keyboard: TextInputType.number,
//               inputFormatters: [FilteringTextInputFormatter.digitsOnly]),
//           // Gender selector
//           _GenderPicker(selected: gender, onSelect: onGender),
//           _Field(label: 'Parent / Guardian Name', ctrl: parent,
//               hint: 'Father or mother name',
//               icon: Icons.family_restroom_rounded),
//         ],
//       ),
//
//       const SizedBox(height: 14),
//
//       // Physical
//       _SectionCard(
//         title: 'Physical Description',
//         icon: Icons.accessibility_new_rounded,
//         color: _T.accentCyan,
//         children: [
//           _Field(label: 'Height', ctrl: height,
//               hint: 'e.g. 165 cm or 5 ft 5 in',
//               icon: Icons.height_rounded),
//           _Field(label: 'Clothes / Ornaments', ctrl: clothes,
//               hint: 'What were they wearing?',
//               icon: Icons.checkroom_outlined, maxLines: 2),
//           _Field(label: 'Identification Marks', ctrl: marks,
//               hint: 'Moles, scars, tattoos etc.',
//               icon: Icons.fingerprint_rounded, maxLines: 2),
//           _Field(label: 'Items Carried', ctrl: items,
//               hint: 'Bag, phone, umbrella etc.',
//               icon: Icons.backpack_outlined, maxLines: 2),
//         ],
//       ),
//     ]),
//   );
// }
//
// // ─────────────────────────────────────────────────────────────────────────────
// //  STEP 3  — Description + Photo
// // ─────────────────────────────────────────────────────────────────────────────
// class _Step3 extends StatelessWidget {
//   final TextEditingController desc;
//   final File? image;
//   final VoidCallback onCamera, onGallery;
//   const _Step3({required this.desc, required this.image,
//     required this.onCamera, required this.onGallery});
//
//   @override
//   Widget build(BuildContext context) => SingleChildScrollView(
//     physics: const BouncingScrollPhysics(),
//     padding: const EdgeInsets.fromLTRB(18, 16, 18, 20),
//     child: Column(children: [
//
//       _SectionCard(
//         title: 'Case Description *',
//         icon: Icons.description_rounded,
//         color: _T.accentGold,
//         children: [
//           TextField(
//             controller: desc,
//             maxLines: 5,
//             style: const TextStyle(color: _T.textPrimary, fontSize: 14, height: 1.5),
//             decoration: InputDecoration(
//               hintText: 'Describe the circumstances — when was the person last seen, '
//                   'any witnesses, unusual behaviour, mental condition etc.',
//               hintStyle: const TextStyle(color: _T.textSub, fontSize: 13, height: 1.5),
//               border: InputBorder.none,
//               contentPadding: const EdgeInsets.symmetric(horizontal: 4),
//             ),
//           ),
//         ],
//       ),
//
//       const SizedBox(height: 16),
//
//       // Photo section
//       _SectionCard(
//         title: 'Recent Photo *',
//         icon: Icons.photo_camera_rounded,
//         color: _T.accentBlue,
//         children: [
//           // Preview
//           ClipRRect(
//             borderRadius: BorderRadius.circular(12),
//             child: Container(
//               height: 200, width: double.infinity,
//               decoration: BoxDecoration(
//                 color: _T.bg,
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(color: image != null
//                     ? _T.accentGreen.withOpacity(0.40)
//                     : _T.glassBorder),
//               ),
//               child: image == null
//                   ? Column(mainAxisAlignment: MainAxisAlignment.center, children: [
//                 Icon(Icons.add_photo_alternate_outlined,
//                     color: _T.textSub.withOpacity(0.45), size: 40),
//                 const SizedBox(height: 8),
//                 const Text('Upload a clear recent photo',
//                     style: TextStyle(color: _T.textSub, fontSize: 12)),
//               ])
//                   : Stack(children: [
//                 Image.file(image!, fit: BoxFit.cover,
//                     width: double.infinity, height: 200),
//                 Positioned(top: 8, right: 8,
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                       decoration: BoxDecoration(
//                           color: _T.accentGreen.withOpacity(0.85),
//                           borderRadius: BorderRadius.circular(10)),
//                       child: const Row(mainAxisSize: MainAxisSize.min, children: [
//                         Icon(Icons.check_rounded, color: Colors.white, size: 11),
//                         SizedBox(width: 4),
//                         Text('Photo added', style: TextStyle(color: Colors.white,
//                             fontSize: 10, fontWeight: FontWeight.w700)),
//                       ]),
//                     )),
//               ]),
//             ),
//           ),
//           const SizedBox(height: 12),
//           // Photo action buttons
//           Row(children: [
//             Expanded(child: _PhotoBtn(
//               label: 'Camera', icon: Icons.camera_alt_rounded,
//               color: _T.accentBlue, onTap: onCamera,
//             )),
//             const SizedBox(width: 10),
//             Expanded(child: _PhotoBtn(
//               label: 'Gallery', icon: Icons.photo_library_rounded,
//               color: _T.accentPurple, onTap: onGallery,
//             )),
//           ]),
//         ],
//       ),
//
//       const SizedBox(height: 14),
//
//       // Location note
//       Container(
//         padding: const EdgeInsets.all(13),
//         decoration: BoxDecoration(
//           color: _T.accentGreen.withOpacity(0.06),
//           borderRadius: BorderRadius.circular(13),
//           border: Border.all(color: _T.accentGreen.withOpacity(0.18)),
//         ),
//         child: const Row(children: [
//           Icon(Icons.my_location_rounded, color: _T.accentGreen, size: 16),
//           SizedBox(width: 8),
//           Expanded(child: Text(
//             'Your current location will be auto-captured when you submit.',
//             style: TextStyle(color: _T.textMid, fontSize: 11.5, height: 1.4),
//           )),
//         ]),
//       ),
//     ]),
//   );
// }
//
// // ─────────────────────────────────────────────────────────────────────────────
// //  BOTTOM BUTTON
// // ─────────────────────────────────────────────────────────────────────────────
// class _BottomBtn extends StatelessWidget {
//   final int step; final bool loading;
//   final AnimationController pulse; final VoidCallback onTap;
//   const _BottomBtn({required this.step, required this.loading,
//     required this.pulse, required this.onTap});
//
//   @override
//   Widget build(BuildContext context) {
//     final isLast = step == 2;
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(18, 10, 18, 20),
//       child: GestureDetector(
//         onTap: loading ? null : onTap,
//         child: AnimatedBuilder(animation: pulse, builder: (_, __) {
//           final g = isLast ? pulse.value * 0.22 : 0.0;
//           return Container(
//             width: double.infinity, height: 54,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(16),
//               gradient: LinearGradient(
//                 colors: isLast
//                     ? [_T.accentRed, _T.accentPurple]
//                     : [_T.accentBlue, _T.accentCyan],
//               ),
//               boxShadow: [BoxShadow(
//                 color: (isLast ? _T.accentRed : _T.accentBlue)
//                     .withOpacity(0.30 + g),
//                 blurRadius: 16 + g * 10,
//                 offset: const Offset(0, 4),
//               )],
//             ),
//             child: Center(child: loading
//                 ? const SizedBox(width: 22, height: 22,
//                 child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
//                 : Row(mainAxisSize: MainAxisSize.min, children: [
//               Text(isLast ? 'Submit Case' : 'Continue',
//                   style: const TextStyle(color: Colors.white,
//                       fontSize: 15, fontWeight: FontWeight.w800)),
//               const SizedBox(width: 8),
//               Icon(isLast ? Icons.send_rounded : Icons.arrow_forward_rounded,
//                   color: Colors.white, size: 17),
//             ])),
//           );
//         }),
//       ),
//     );
//   }
// }
//
// // ─────────────────────────────────────────────────────────────────────────────
// //  SHARED COMPONENTS
// // ─────────────────────────────────────────────────────────────────────────────
//
// // Section card with header
// class _SectionCard extends StatelessWidget {
//   final String title; final IconData icon; final Color color;
//   final List<Widget> children;
//   const _SectionCard({required this.title, required this.icon,
//     required this.color, required this.children});
//
//   @override
//   Widget build(BuildContext context) => Container(
//     width: double.infinity,
//     padding: const EdgeInsets.all(16),
//     decoration: BoxDecoration(
//       borderRadius: BorderRadius.circular(18),
//       color: _T.card,
//       border: Border.all(color: color.withOpacity(0.18)),
//     ),
//     child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//       // Card header
//       Row(children: [
//         Container(width: 32, height: 32,
//             decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 gradient: LinearGradient(colors: [color, color.withOpacity(0.55)])),
//             child: Icon(icon, color: Colors.white, size: 15)),
//         const SizedBox(width: 9),
//         Text(title, style: TextStyle(color: color,
//             fontSize: 13, fontWeight: FontWeight.w800)),
//       ]),
//       Divider(color: color.withOpacity(0.12), height: 20),
//       // Fields with spacing between them
//       for (int i = 0; i < children.length; i++) ...[
//         children[i],
//         if (i < children.length - 1) const SizedBox(height: 12),
//       ],
//     ]),
//   );
// }
//
// // Standard text field
// class _Field extends StatelessWidget {
//   final String label, hint; final IconData icon;
//   final TextEditingController ctrl;
//   final TextInputType keyboard;
//   final List<TextInputFormatter> inputFormatters;
//   final int maxLines;
//
//   const _Field({required this.label, required this.ctrl,
//     required this.hint, required this.icon,
//     this.keyboard = TextInputType.text,
//     this.inputFormatters = const [],
//     this.maxLines = 1});
//
//   @override
//   Widget build(BuildContext context) => Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Text(label, style: const TextStyle(color: _T.textMid,
//           fontSize: 11.5, fontWeight: FontWeight.w600)),
//       const SizedBox(height: 6),
//       Container(
//         decoration: BoxDecoration(
//           color: _T.surface,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: _T.glassBorder),
//         ),
//         child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
//           Padding(
//             padding: EdgeInsets.only(
//                 left: 12, top: maxLines > 1 ? 12 : 0,
//                 right: 4),
//             child: Icon(icon, color: _T.textSub.withOpacity(0.7), size: 17),
//           ),
//           Expanded(child: TextField(
//             controller: ctrl,
//             keyboardType: keyboard,
//             inputFormatters: inputFormatters,
//             maxLines: maxLines,
//             style: const TextStyle(color: _T.textPrimary, fontSize: 13.5, height: 1.4),
//             decoration: InputDecoration(
//               hintText: hint,
//               hintStyle: const TextStyle(color: _T.textSub, fontSize: 13),
//               border: InputBorder.none,
//               contentPadding: EdgeInsets.symmetric(
//                   vertical: maxLines > 1 ? 10 : 14, horizontal: 4),
//             ),
//           )),
//         ]),
//       ),
//     ],
//   );
// }
//
// // Date field with calendar tap
// class _DateField extends StatelessWidget {
//   final String label; final TextEditingController ctrl;
//   final VoidCallback onTap;
//   const _DateField({required this.label, required this.ctrl, required this.onTap});
//
//   @override
//   Widget build(BuildContext context) => Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Text(label, style: const TextStyle(color: _T.textMid,
//           fontSize: 11.5, fontWeight: FontWeight.w600)),
//       const SizedBox(height: 6),
//       GestureDetector(
//         onTap: onTap,
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
//           decoration: BoxDecoration(
//             color: _T.surface,
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(color: _T.accentCyan.withOpacity(0.25)),
//           ),
//           child: Row(children: [
//             const Icon(Icons.calendar_today_rounded, color: _T.accentCyan, size: 16),
//             const SizedBox(width: 10),
//             Expanded(child: Text(
//               ctrl.text.isEmpty ? 'Tap to pick date' : ctrl.text,
//               style: TextStyle(
//                   color: ctrl.text.isEmpty ? _T.textSub : _T.textPrimary,
//                   fontSize: 13.5),
//             )),
//             const Icon(Icons.chevron_right_rounded, color: _T.textSub, size: 18),
//           ]),
//         ),
//       ),
//     ],
//   );
// }
//
// // Gender picker  (sets text value that goes to backend)
// class _GenderPicker extends StatelessWidget {
//   final String selected; final ValueChanged<String> onSelect;
//   const _GenderPicker({required this.selected, required this.onSelect});
//
//   @override
//   Widget build(BuildContext context) => Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       const Text('Gender *', style: TextStyle(color: _T.textMid,
//           fontSize: 11.5, fontWeight: FontWeight.w600)),
//       const SizedBox(height: 8),
//       Row(children: [
//         for (final g in ['Male', 'Female', 'Other'])
//           Expanded(child: Padding(
//             padding: EdgeInsets.only(right: g == 'Other' ? 0 : 8),
//             child: GestureDetector(
//               onTap: () => onSelect(g),
//               child: AnimatedContainer(
//                 duration: const Duration(milliseconds: 200),
//                 height: 40,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   gradient: selected == g ? LinearGradient(colors: [
//                     _T.accentPurple, _T.accentBlue]) : null,
//                   color: selected == g ? null : _T.surface,
//                   border: Border.all(
//                     color: selected == g
//                         ? _T.accentPurple.withOpacity(0.60)
//                         : _T.glassBorder,
//                     width: selected == g ? 1.5 : 1,
//                   ),
//                 ),
//                 child: Center(child: Text(g, style: TextStyle(
//                     color: selected == g ? Colors.white : _T.textSub,
//                     fontSize: 12.5, fontWeight: FontWeight.w700))),
//               ),
//             ),
//           )),
//       ]),
//     ],
//   );
// }
//
// // Photo action button
// class _PhotoBtn extends StatefulWidget {
//   final String label; final IconData icon;
//   final Color color; final VoidCallback onTap;
//   const _PhotoBtn({required this.label, required this.icon,
//     required this.color, required this.onTap});
//   @override State<_PhotoBtn> createState() => _PhotoBtnState();
// }
// class _PhotoBtnState extends State<_PhotoBtn> {
//   bool _p = false;
//   @override
//   Widget build(BuildContext context) => GestureDetector(
//     onTap: widget.onTap,
//     onTapDown: (_) => setState(() => _p = true),
//     onTapUp: (_) => setState(() => _p = false),
//     onTapCancel: () => setState(() => _p = false),
//     child: AnimatedScale(scale: _p ? 0.95 : 1.0,
//       duration: const Duration(milliseconds: 100),
//       child: Container(
//         height: 46,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(12),
//           gradient: LinearGradient(
//               colors: [widget.color, widget.color.withOpacity(0.65)]),
//           boxShadow: [BoxShadow(color: widget.color.withOpacity(0.30),
//               blurRadius: 10, offset: const Offset(0, 3))],
//         ),
//         child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//           Icon(widget.icon, color: Colors.white, size: 18),
//           const SizedBox(width: 7),
//           Text(widget.label, style: const TextStyle(color: Colors.white,
//               fontSize: 13, fontWeight: FontWeight.w700)),
//         ]),
//       ),
//     ),
//   );
// }
//
// // ─────────────────────────────────────────────────────────────────────────────
// //  ANIMATED BACKGROUND
// // ─────────────────────────────────────────────────────────────────────────────
// class _RcBg extends StatefulWidget {
//   const _RcBg();
//   @override State<_RcBg> createState() => _RcBgState();
// }
// class _RcBgState extends State<_RcBg> with SingleTickerProviderStateMixin {
//   late final AnimationController _c;
//   @override void initState() { super.initState();
//   _c = AnimationController(vsync: this,
//       duration: const Duration(seconds: 10))..repeat(); }
//   @override void dispose() { _c.dispose(); super.dispose(); }
//   @override
//   Widget build(BuildContext context) => AnimatedBuilder(animation: _c,
//       builder: (_, __) => CustomPaint(
//           painter: _RcBgPainter(_c.value), size: Size.infinite,
//           child: const SizedBox.expand()));
// }
//
// class _RcBgPainter extends CustomPainter {
//   final double t; _RcBgPainter(this.t);
//   @override
//   void paint(Canvas c, Size s) {
//     c.drawRect(Rect.fromLTWH(0, 0, s.width, s.height), Paint()..color = _T.bg);
//     void g(double fx, double fy, double r, Color col, double op) {
//       final a = t * 2 * math.pi;
//       final x = s.width  * (fx + 0.06 * math.sin(a + fy * 3));
//       final y = s.height * (fy + 0.05 * math.cos(a + fx * 2));
//       c.drawCircle(Offset(x, y), s.width * r,
//           Paint()..shader = RadialGradient(
//               colors: [col.withOpacity(op), Colors.transparent])
//               .createShader(Rect.fromCircle(center: Offset(x, y), radius: s.width * r)));
//     }
//     g(0.80, 0.08, 0.42, _T.accentBlue,   0.14);
//     g(0.15, 0.85, 0.36, _T.accentPurple, 0.10);
//     g(0.50, 0.45, 0.18, _T.accentCyan,   0.04);
//   }
//   @override bool shouldRepaint(_RcBgPainter o) => o.t != t;
// }