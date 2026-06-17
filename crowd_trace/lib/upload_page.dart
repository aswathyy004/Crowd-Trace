// import 'dart:convert';
// import 'dart:io';
// import 'dart:ui';
//
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:http/http.dart' as http;
// import 'package:location/location.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:video_player/video_player.dart';
//
// class UploadPage extends StatefulWidget {
//   const UploadPage({super.key});
//
//   @override
//   State<UploadPage> createState() => _UploadPageState();
// }
//
// class _UploadPageState extends State<UploadPage> {
//
//   File? selectedFile;
//   bool isVideo = false;
//
//   VideoPlayerController? videoController;
//
//   bool loading = false;
//
//   double latitude = 0;
//   double longitude = 0;
//
//   List results = [];
//
//   final picker = ImagePicker();
//
//   // ===============================
//   // PICK IMAGE
//   // ===============================
//
//   Future pickImage() async {
//
//     final picked = await picker.pickImage(
//       source: ImageSource.gallery,
//     );
//
//     if (picked != null) {
//
//       videoController?.dispose();
//
//       setState(() {
//         selectedFile = File(picked.path);
//         isVideo = false;
//         results.clear();
//       });
//     }
//   }
//
//   // ===============================
//   // PICK VIDEO
//   // ===============================
//
//   Future pickVideo() async {
//
//     final picked = await picker.pickVideo(
//       source: ImageSource.gallery,
//     );
//
//     if (picked != null) {
//
//       selectedFile = File(picked.path);
//
//       videoController = VideoPlayerController.file(selectedFile!)
//         ..initialize().then((_) {
//           setState(() {});
//         });
//
//       setState(() {
//         isVideo = true;
//         results.clear();
//       });
//     }
//   }
//
//   // ===============================
//   // LOCATION
//   // ===============================
//
//   Future getLocation() async {
//
//     Location location = Location();
//
//     bool serviceEnabled;
//     PermissionStatus permissionGranted;
//
//     serviceEnabled = await location.serviceEnabled();
//
//     if (!serviceEnabled) {
//       serviceEnabled = await location.requestService();
//     }
//
//     permissionGranted = await location.hasPermission();
//
//     if (permissionGranted == PermissionStatus.denied) {
//       permissionGranted = await location.requestPermission();
//     }
//
//     LocationData data = await location.getLocation();
//
//     latitude = data.latitude ?? 0;
//     longitude = data.longitude ?? 0;
//   }
//
//   // ===============================
//   // UPLOAD FILE
//   // ===============================
//
//   Future uploadFile() async {
//
//     if (selectedFile == null) {
//
//       Fluttertoast.showToast(msg: "Select image or video");
//       return;
//     }
//
//     setState(() {
//       loading = true;
//     });
//
//     await getLocation();
//
//     SharedPreferences sh = await SharedPreferences.getInstance();
//
//     String baseUrl = sh.getString("url") ?? "";
//     String uid = sh.getString("lid") ?? "";
//
//     if(baseUrl.isEmpty || uid.isEmpty){
//
//       Fluttertoast.showToast(msg: "Login session expired");
//
//       setState(() {
//         loading = false;
//       });
//
//       return;
//     }
//
//     var uri = Uri.parse("$baseUrl/user_detect_person/");
//
//     var request = http.MultipartRequest("POST", uri);
//
//     request.fields["uid"] = uid;
//     request.fields["latitude"] = latitude.toString();
//     request.fields["longitude"] = longitude.toString();
//
//     request.files.add(
//       await http.MultipartFile.fromPath(
//         "file",
//         selectedFile!.path,
//       ),
//     );
//
//     try {
//
//       var response = await request.send();
//
//       var res = await http.Response.fromStream(response);
//
//       var data = jsonDecode(res.body);
//
//       setState(() {
//         loading = false;
//       });
//
//       if (data["status"] == "ok") {
//
//         setState(() {
//           results = data["result"];
//         });
//
//         Fluttertoast.showToast(msg: "Detection Completed");
//
//       } else {
//
//         Fluttertoast.showToast(
//             msg: data["message"] ?? "Detection Failed");
//
//       }
//
//     } catch (e) {
//
//       setState(() {
//         loading = false;
//       });
//
//       Fluttertoast.showToast(msg: "Server Error");
//
//       print(e);
//     }
//   }
//
//   // ===============================
//   // PREVIEW
//   // ===============================
//
//   Widget previewWidget(){
//
//     if(selectedFile == null){
//       return const Center(
//         child: Text(
//           "Select Image or Video",
//           style: TextStyle(color: Colors.white70),
//         ),
//       );
//     }
//
//     if(isVideo){
//
//       if(videoController != null &&
//           videoController!.value.isInitialized){
//
//         return AspectRatio(
//           aspectRatio: videoController!.value.aspectRatio,
//           child: VideoPlayer(videoController!),
//         );
//
//       }else{
//         return const Center(
//           child: CircularProgressIndicator(),
//         );
//       }
//
//     }else{
//
//       return Image.file(
//         selectedFile!,
//         fit: BoxFit.cover,
//       );
//
//     }
//   }
//
//   // ===============================
//   // GLASS CARD
//   // ===============================
//
//   Widget glassCard(Widget child){
//
//     return ClipRRect(
//
//       borderRadius: BorderRadius.circular(20),
//
//       child: BackdropFilter(
//
//         filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//
//         child: Container(
//
//           decoration: BoxDecoration(
//
//             borderRadius: BorderRadius.circular(20),
//
//             color: Colors.white.withOpacity(0.05),
//
//             border: Border.all(
//               color: Colors.white.withOpacity(0.1),
//             ),
//
//           ),
//
//           child: child,
//
//         ),
//
//       ),
//
//     );
//
//   }
//
//   // ===============================
//   // BUTTON STYLE
//   // ===============================
//
//   Widget gradientButton(
//       String text,
//       IconData icon,
//       VoidCallback onTap){
//
//     return GestureDetector(
//
//       onTap: onTap,
//
//       child: Container(
//
//         padding: const EdgeInsets.symmetric(
//             vertical: 14),
//
//         decoration: BoxDecoration(
//
//           borderRadius: BorderRadius.circular(30),
//
//           gradient: const LinearGradient(
//             colors: [
//               Color(0xff4facfe),
//               Color(0xff8e2de2)
//             ],
//           ),
//
//           boxShadow: [
//             BoxShadow(
//               color: Colors.blueAccent.withOpacity(0.6),
//               blurRadius: 20,
//             )
//           ],
//
//         ),
//
//         child: Row(
//
//           mainAxisAlignment: MainAxisAlignment.center,
//
//           children: [
//
//             Icon(icon,color: Colors.white),
//
//             const SizedBox(width: 8),
//
//             Text(
//               text,
//               style: const TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold),
//             ),
//
//           ],
//
//         ),
//
//       ),
//
//     );
//
//   }
//
//   // ===============================
//   // UI
//   // ===============================
//
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
//           "AI Person Detection",
//           style: TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//       ),
//
//       body: Padding(
//
//         padding: const EdgeInsets.all(16),
//
//         child: Column(
//
//           children: [
//
//             glassCard(
//
//               Container(
//                 height: 220,
//                 width: double.infinity,
//                 alignment: Alignment.center,
//                 child: previewWidget(),
//               ),
//
//             ),
//
//             const SizedBox(height: 20),
//
//             Row(
//
//               children: [
//
//                 Expanded(
//                     child: gradientButton(
//                         "Image",
//                         Icons.image,
//                         pickImage)),
//
//                 const SizedBox(width: 10),
//
//                 Expanded(
//                     child: gradientButton(
//                         "Video",
//                         Icons.video_library,
//                         pickVideo)),
//
//               ],
//
//             ),
//
//             const SizedBox(height: 20),
//
//             gradientButton(
//                 loading ? "Processing..." : "Detect Person",
//                 Icons.search,
//                 loading ? (){} : uploadFile),
//
//             const SizedBox(height: 20),
//
//             Expanded(
//
//               child: results.isEmpty
//
//                   ? const Center(
//                 child: Text(
//                   "No detection results",
//                   style: TextStyle(
//                       color: Colors.white70),
//                 ),
//               )
//
//                   : ListView.builder(
//
//                 itemCount: results.length,
//
//                 itemBuilder: (context, index){
//
//                   var r = results[index];
//
//                   return glassCard(
//
//                     ListTile(
//
//                       leading: const Icon(
//                         Icons.person,
//                         color: Colors.white,
//                       ),
//
//                       title: Text(
//                         r["name"] ?? "",
//                         style: const TextStyle(
//                             color: Colors.white),
//                       ),
//
//                       subtitle: Text(
//                         r["category"] ?? "",
//                         style: const TextStyle(
//                             color: Colors.white70),
//                       ),
//
//                     ),
//
//                   );
//
//                 },
//
//               ),
//
//             )
//
//           ],
//
//         ),
//
//       ),
//
//     );
//   }
//
//   @override
//   void dispose() {
//
//     videoController?.dispose();
//
//     super.dispose();
//   }
//
// }



import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {

  File? selectedFile;
  bool isVideo = false;

  VideoPlayerController? videoController;

  bool loading = false;

  double latitude = 0;
  double longitude = 0;

  List results = [];

  final picker = ImagePicker();

  // ===============================
  // PICK IMAGE
  // ===============================
  Future pickImage() async {

    final picked = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (picked != null) {

      videoController?.dispose();

      setState(() {
        selectedFile = File(picked.path);
        isVideo = false;
        results.clear();
      });
    }
  }

  // ===============================
  // PICK VIDEO
  // ===============================
  Future pickVideo() async {

    final picked = await picker.pickVideo(
      source: ImageSource.gallery,
    );

    if (picked != null) {

      selectedFile = File(picked.path);

      videoController = VideoPlayerController.file(selectedFile!)
        ..initialize().then((_) {
          setState(() {});
        });

      setState(() {
        isVideo = true;
        results.clear();
      });
    }
  }

  // ===============================
  // LOCATION
  // ===============================
  Future getLocation() async {

    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();

    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
    }

    permissionGranted = await location.hasPermission();

    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
    }

    LocationData data = await location.getLocation();

    latitude = data.latitude ?? 0;
    longitude = data.longitude ?? 0;
  }

  // ===============================
  // UPLOAD FILE
  // ===============================
  Future uploadFile() async {

    if (selectedFile == null) {
      Fluttertoast.showToast(msg: "Select image or video");
      return;
    }

    setState(() {
      loading = true;
    });

    await getLocation();

    SharedPreferences sh = await SharedPreferences.getInstance();

    String baseUrl = sh.getString("url") ?? "";
    String uid = sh.getString("lid") ?? "";

    if(baseUrl.isEmpty || uid.isEmpty){

      Fluttertoast.showToast(msg: "Login session expired");

      setState(() {
        loading = false;
      });

      return;
    }

    var uri = Uri.parse("$baseUrl/user_detect_person/");

    var request = http.MultipartRequest("POST", uri);

    request.fields["uid"] = uid;
    request.fields["latitude"] = latitude.toString();
    request.fields["longitude"] = longitude.toString();

    request.files.add(
      await http.MultipartFile.fromPath(
        "file",
        selectedFile!.path,
      ),
    );

    try {

      var response = await request.send();
      var res = await http.Response.fromStream(response);
      var data = jsonDecode(res.body);

      setState(() {
        loading = false;
      });

      if (data["status"] == "ok") {

        setState(() {
          results = data["result"];
        });

        Fluttertoast.showToast(msg: "Detection Completed");

      } else {

        Fluttertoast.showToast(
            msg: data["message"] ?? "Detection Failed");

      }

    } catch (e) {

      setState(() {
        loading = false;
      });

      Fluttertoast.showToast(msg: "Server Error");

      print(e);
    }
  }

  // ===============================
  // PREVIEW
  // ===============================
  Widget previewWidget(){

    if(selectedFile == null){
      return const Center(
        child: Text(
          "Select Image or Video",
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    if(isVideo){

      if(videoController != null &&
          videoController!.value.isInitialized){

        return AspectRatio(
          aspectRatio: videoController!.value.aspectRatio,
          child: VideoPlayer(videoController!),
        );

      }else{
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

    }else{

      return Image.file(
        selectedFile!,
        fit: BoxFit.cover,
      );

    }
  }

  // ===============================
  // GLASS CARD
  // ===============================
  Widget glassCard(Widget child){

    return ClipRRect(

      borderRadius: BorderRadius.circular(20),

      child: BackdropFilter(

        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),

        child: Container(

          decoration: BoxDecoration(

            borderRadius: BorderRadius.circular(20),

            color: Colors.white.withOpacity(0.05),

            border: Border.all(
              color: Colors.white.withOpacity(0.1),
            ),

          ),

          child: child,

        ),

      ),

    );

  }

  // ===============================
  // BUTTON STYLE
  // ===============================
  Widget gradientButton(
      String text,
      IconData icon,
      VoidCallback onTap){

    return GestureDetector(

      onTap: onTap,

      child: Container(

        padding: const EdgeInsets.symmetric(
            vertical: 14),

        decoration: BoxDecoration(

          borderRadius: BorderRadius.circular(30),

          gradient: const LinearGradient(
            colors: [
              Color(0xff4facfe),
              Color(0xff8e2de2)
            ],
          ),

          boxShadow: [
            BoxShadow(
              color: Colors.blueAccent.withOpacity(0.6),
              blurRadius: 20,
            )
          ],

        ),

        child: Row(

          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            Icon(icon,color: Colors.white),

            const SizedBox(width: 8),

            Text(
              text,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),

          ],

        ),

      ),

    );

  }

  // ===============================
  // UI
  // ===============================
  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          "AI Person Detection",
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: Padding(

        padding: const EdgeInsets.all(16),

        child: Column(

          children: [

            glassCard(

              Container(
                height: 220,
                width: double.infinity,
                alignment: Alignment.center,
                child: previewWidget(),
              ),

            ),

            const SizedBox(height: 20),

            Row(

              children: [

                Expanded(
                    child: gradientButton(
                        "Image",
                        Icons.image,
                        pickImage)),

                const SizedBox(width: 10),

                Expanded(
                    child: gradientButton(
                        "Video",
                        Icons.video_library,
                        pickVideo)),

              ],

            ),

            const SizedBox(height: 20),

            // ✅ UPDATED TEXT HERE ONLY
            gradientButton(
                loading ? "Scanning 4 Angles..." : "Detect Person",
                Icons.search,
                loading ? (){} : uploadFile),

            const SizedBox(height: 20),

            Expanded(

              child: results.isEmpty

                  ? const Center(
                child: Text(
                  "No detection results",
                  style: TextStyle(
                      color: Colors.white70),
                ),
              )

                  : ListView.builder(

                itemCount: results.length,

                itemBuilder: (context, index){

                  var r = results[index];

                  return glassCard(

                    ListTile(

                      leading: const Icon(
                        Icons.person,
                        color: Colors.white,
                      ),

                      title: Text(
                        r["name"] ?? "",
                        style: const TextStyle(
                            color: Colors.white),
                      ),

                      subtitle: Text(
                        r["category"] ?? "",
                        style: const TextStyle(
                            color: Colors.white70),
                      ),

                    ),

                  );

                },

              ),

            )

          ],

        ),

      ),

    );
  }

  @override
  void dispose() {

    videoController?.dispose();

    super.dispose();
  }

}