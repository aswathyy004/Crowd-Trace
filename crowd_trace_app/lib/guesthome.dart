import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

class GuestHomePage extends StatefulWidget {
  const GuestHomePage({super.key});

  @override
  State<GuestHomePage> createState() => _GuestHomePageState();
}

class _GuestHomePageState extends State<GuestHomePage> {

  static const Color navyDark = Color(0xFF0A1F5C);
  static const Color navyMid = Color(0xFF1A3A8C);
  static const Color navyLight = Color(0xFF2756C5);
  static const Color offWhite = Color(0xFFF0F4FF);

  File? selectedFile;
  bool isVideo=false;

  VideoPlayerController? controller;

  final picker=ImagePicker();

  bool loading=false;

  double latitude=0;
  double longitude=0;

  List results=[];

  TextEditingController descriptionController=TextEditingController();

  // PICK IMAGE
  Future pickImage() async{

    final picked=await picker.pickImage(source: ImageSource.gallery);

    if(picked!=null){

      controller?.dispose();

      setState(() {

        selectedFile=File(picked.path);
        isVideo=false;
        results.clear();

      });
    }
  }

  // PICK VIDEO
  Future pickVideo() async{

    final picked=await picker.pickVideo(source: ImageSource.gallery);

    if(picked!=null){

      selectedFile=File(picked.path);

      controller=VideoPlayerController.file(selectedFile!)
        ..initialize().then((_) {
          setState(() {});
        });

      setState(() {

        isVideo=true;
        results.clear();

      });
    }
  }

  // LOCATION
  Future getLocation() async{

    Location location=Location();

    LocationData data=await location.getLocation();

    latitude=data.latitude??0;
    longitude=data.longitude??0;

  }

  // UPLOAD
  Future upload() async{

    if(selectedFile==null){

      Fluttertoast.showToast(msg:"Select image/video");
      return;

    }

    setState(() {
      loading=true;
    });

    await getLocation();

    SharedPreferences sh=await SharedPreferences.getInstance();

    String url=sh.getString("url")??"";

    var uri=Uri.parse("$url/public_detect_person/");

    var request=http.MultipartRequest("POST",uri);

    request.fields["latitude"]=latitude.toString();
    request.fields["longitude"]=longitude.toString();
    request.fields["description"]=descriptionController.text;

    request.files.add(await http.MultipartFile.fromPath("file",selectedFile!.path));

    var response=await request.send();

    var res=await http.Response.fromStream(response);

    var data=jsonDecode(res.body);

    setState(() {
      loading=false;
    });

    if(data["status"]=="ok"){

      results=data["result"];

      Fluttertoast.showToast(msg:"Detection Completed");

    }else{

      Fluttertoast.showToast(msg:"Detection Failed");

    }

    setState(() {});
  }

  Widget preview(){

    if(selectedFile==null){
      return const Text(
        "Select Image or Video",
        style: TextStyle(color: Colors.grey),
      );
    }

    if(isVideo){

      if(controller!=null && controller!.value.isInitialized){

        return AspectRatio(
          aspectRatio: controller!.value.aspectRatio,
          child: VideoPlayer(controller!),
        );

      }

      return const CircularProgressIndicator();
    }

    return Image.file(selectedFile!,fit:BoxFit.cover);

  }

  Widget actionButton(String title, IconData icon, Function() onTap){

    return Expanded(
      child: ElevatedButton.icon(

        style: ElevatedButton.styleFrom(
          backgroundColor: navyDark,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),

        onPressed: onTap,

        icon: Icon(icon),

        label: Text(title),

      ),
    );

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: offWhite,

      appBar: AppBar(
        backgroundColor: navyDark,
        title: const Text("Guest Person Detection"),
        centerTitle: true,
      ),

      body: SingleChildScrollView(

        padding: const EdgeInsets.all(20),

        child: Column(

          children: [

            /// PREVIEW CARD
            Container(

              height:220,
              width:double.infinity,

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    color: Colors.black12,
                    offset: Offset(0,4),
                  )
                ],
              ),

              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Center(child: preview()),
              ),

            ),

            const SizedBox(height:20),

            /// DESCRIPTION
            TextField(

              controller:descriptionController,

              decoration: InputDecoration(

                labelText:"Description",

                filled:true,
                fillColor:Colors.white,

                border:OutlineInputBorder(
                  borderRadius:BorderRadius.circular(12),
                ),

              ),

            ),

            const SizedBox(height:20),

            /// IMAGE VIDEO BUTTONS
            Row(

              children: [

                actionButton("Image",Icons.image,pickImage),

                const SizedBox(width:12),

                actionButton("Video",Icons.video_library,pickVideo),

              ],

            ),

            const SizedBox(height:20),

            /// DETECT BUTTON
            SizedBox(

              width:double.infinity,

              child: ElevatedButton.icon(

                style: ElevatedButton.styleFrom(
                  backgroundColor:navyMid,
                  padding: const EdgeInsets.symmetric(vertical:16),
                  shape: RoundedRectangleBorder(
                    borderRadius:BorderRadius.circular(12),
                  ),
                ),

                onPressed: loading?null:upload,

                icon: const Icon(Icons.search),

                label: Text(
                    loading
                        ?"Processing..."
                        :"Detect Person"
                ),

              ),

            ),

            const SizedBox(height:25),

            /// RESULTS
            results.isEmpty
                ? const Text(
                "No detection results",
                style: TextStyle(color: Colors.black54)
            )
                : ListView.builder(

              shrinkWrap:true,
              physics:NeverScrollableScrollPhysics(),

              itemCount:results.length,

              itemBuilder:(c,i){

                var r=results[i];

                return Card(

                  elevation:4,

                  shape:RoundedRectangleBorder(
                    borderRadius:BorderRadius.circular(12),
                  ),

                  child:ListTile(

                    leading: CircleAvatar(
                      backgroundColor:navyLight,
                      child: const Icon(Icons.person,color:Colors.white),
                    ),

                    title:Text(
                      r["name"],
                      style: const TextStyle(fontWeight:FontWeight.bold),
                    ),

                    subtitle:Text(r["category"]),

                  ),

                );

              },

            )

          ],

        ),

      ),

    );
  }

  @override
  void dispose(){

    controller?.dispose();

    super.dispose();
  }
}