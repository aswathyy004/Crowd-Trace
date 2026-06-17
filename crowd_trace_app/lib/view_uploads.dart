import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewUploads extends StatefulWidget {
  const ViewUploads({super.key});

  @override
  State<ViewUploads> createState() => _ViewUploadsState();
}

class _ViewUploadsState extends State<ViewUploads> {

  List uploads = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    userViewDetections();
  }

  // FETCH DATA
  Future userViewDetections() async {

    SharedPreferences sh = await SharedPreferences.getInstance();

    String baseUrl = sh.getString("url") ?? "";
    String imageBase = sh.getString("Image_url") ?? "";
    String uid = sh.getString("lid") ?? "";

    var uri = Uri.parse("$baseUrl/user_view_detections/");

    var response = await http.post(uri, body: {
      "uid": uid
    });

    var data = jsonDecode(response.body);

    if (data["status"] == "ok") {

      List temp = data["data"];

      for (int i = 0; i < temp.length; i++) {
        temp[i]["photo"] = imageBase + temp[i]["photo"];
      }

      setState(() {
        uploads = temp;
        loading = false;
      });

    } else {
      setState(() {
        loading = false;
      });
    }
  }

  // CHECK VIDEO
  bool isVideo(String url) {
    return url.toLowerCase().endsWith(".mp4") ||
        url.toLowerCase().endsWith(".avi") ||
        url.toLowerCase().endsWith(".mov") ||
        url.toLowerCase().endsWith(".mkv");
  }

  // OPEN VIDEO
  Future openVideo(String url) async {
    final Uri uri = Uri.parse(url);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  // PLAY BUTTON
  Widget playButton(String url) {

    return GestureDetector(

      onTap: () {
        openVideo(url);
      },

      child: AnimatedContainer(

        duration: const Duration(milliseconds: 200),

        padding: const EdgeInsets.symmetric(
            horizontal: 30, vertical: 16),

        decoration: BoxDecoration(

          borderRadius: BorderRadius.circular(40),

          gradient: const LinearGradient(
            colors: [
              Color(0xff4facfe),
              Color(0xff8e2de2)
            ],
          ),

          boxShadow: [

            BoxShadow(
              color: Colors.blueAccent.withOpacity(0.6),
              blurRadius: 25,
            )

          ],

        ),

        child: const Row(

          mainAxisSize: MainAxisSize.min,

          children: [

            Icon(Icons.play_arrow,
                color: Colors.white, size: 28),

            SizedBox(width: 8),

            Text(
              "Play Video",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),

          ],

        ),

      ),

    );

  }

  // GLASS CARD
  Widget glassCard(Widget child) {

    return ClipRRect(

      borderRadius: BorderRadius.circular(25),

      child: BackdropFilter(

        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),

        child: Container(

          margin: const EdgeInsets.symmetric(vertical: 12),

          decoration: BoxDecoration(

            borderRadius: BorderRadius.circular(25),

            color: Colors.white.withOpacity(0.05),

            border: Border.all(
              color: Colors.white.withOpacity(0.08),
            ),

          ),

          child: child,

        ),

      ),

    );

  }

  // OPEN FULL IMAGE
  void openFullImage(String url, String tag) {

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FullScreenImage(
          imageUrl: url,
          tag: tag,
        ),
      ),
    );

  }

  // BACK BUTTON
  Widget animatedBackButton() {

    return IconButton(

      icon: const Icon(Icons.arrow_back_ios_new,
          color: Colors.white),

      onPressed: () {
        Navigator.pop(context);
      },

    );

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.black,

      appBar: AppBar(

        backgroundColor: Colors.black,
        elevation: 0,

        leading: animatedBackButton(),

        title: const Text(
          "My Uploads",
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold),
        ),

        centerTitle: true,

      ),

      body: loading

          ? const Center(
          child: CircularProgressIndicator())

          : uploads.isEmpty

          ? const Center(
        child: Text(
          "No uploads found",
          style: TextStyle(
              color: Colors.white,
              fontSize: 18),
        ),
      )

          : ListView.builder(

        padding: const EdgeInsets.all(16),

        itemCount: uploads.length,

        itemBuilder: (context, index) {

          var u = uploads[index];
          String url = u["photo"] ?? "";

          return glassCard(

            Column(

              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                if (url != "")

                  isVideo(url)

                      ? Container(
                    height: 200,
                    alignment: Alignment.center,
                    child: playButton(url),
                  )

                      : GestureDetector(

                    onTap: () {
                      openFullImage(url, "img$index");
                    },

                    child: Hero(

                      tag: "img$index",

                      child: ClipRRect(

                        borderRadius:
                        const BorderRadius.vertical(
                            top: Radius.circular(25)),

                        child: Image.network(
                          url,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),

                      ),

                    ),

                  ),

                Padding(

                  padding: const EdgeInsets.all(18),

                  child: Column(

                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [

                      Text(
                        u["name"],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        "Category: ${u["category"]}",
                        style: const TextStyle(
                            color: Colors.white70),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        "Date: ${u["date"]}",
                        style: const TextStyle(
                            color: Colors.white70),
                      ),

                    ],

                  ),

                )

              ],

            ),

          );

        },

      ),

    );

  }

}






class FullScreenImage extends StatelessWidget {

  final String imageUrl;
  final String tag;

  const FullScreenImage({
    super.key,
    required this.imageUrl,
    required this.tag,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.black,

      body: GestureDetector(

        onTap: () {
          Navigator.pop(context);
        },

        child: Center(

          child: Hero(

            tag: tag,

            child: InteractiveViewer(

              minScale: 1,
              maxScale: 5,

              child: Image.network(imageUrl),

            ),

          ),

        ),

      ),

    );

  }

}