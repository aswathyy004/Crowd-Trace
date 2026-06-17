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
      return const Text("No file selected");
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

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Guest Detection"),
      ),

      body: Padding(

        padding: const EdgeInsets.all(16),

        child: Column(

          children: [

            Container(
              height:200,
              width:double.infinity,
              decoration:BoxDecoration(
                border:Border.all(),
              ),
              child:Center(child:preview()),
            ),

            const SizedBox(height:20),

            TextField(
              controller:descriptionController,
              decoration:const InputDecoration(
                labelText:"Description",
                border:OutlineInputBorder(),
              ),
            ),

            const SizedBox(height:20),

            Row(
              children: [

                Expanded(
                  child: ElevatedButton(
                    onPressed: pickImage,
                    child: const Text("Image"),
                  ),
                ),

                const SizedBox(width:10),

                Expanded(
                  child: ElevatedButton(
                    onPressed: pickVideo,
                    child: const Text("Video"),
                  ),
                ),

              ],
            ),

            const SizedBox(height:20),

            ElevatedButton(

              onPressed: loading?null:upload,

              child:Text(
                  loading?"Processing...":"Detect Person"),

            ),

            const SizedBox(height:20),

            Expanded(

              child:ListView.builder(

                itemCount:results.length,

                itemBuilder:(c,i){

                  var r=results[i];

                  return ListTile(

                    leading:const Icon(Icons.person),

                    title:Text(r["name"]),

                    subtitle:Text(r["category"]),

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
  void dispose(){

    controller?.dispose();

    super.dispose();
  }
}