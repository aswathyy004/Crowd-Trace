import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class user_view_profile extends StatefulWidget {
  @override
  _user_view_profileState createState() => _user_view_profileState();
}

class _user_view_profileState extends State<user_view_profile> {

  String name="";
  String email="";
  String phone="";
  String house="";
  String place="";
  String post="";
  String pin="";
  String image="";
  String points="";

  @override
  void initState() {
    super.initState();
    getdata();
  }

  Future getdata() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String url = prefs.getString("url")!;
    String lid = prefs.getString("uid")!;

    var response = await http.post(
        Uri.parse("$url/user_view_profile"),
        body: {
          "lid": lid
        });

    var jsondata = json.decode(response.body);

    if(jsondata['status']=="ok"){

      setState(() {

        name = jsondata['name'];
        email = jsondata['email'];
        phone = jsondata['phone'];
        house = jsondata['house'];
        place = jsondata['place'];
        post = jsondata['post'];
        pin = jsondata['pin'];
        image = jsondata['image'];
        points = jsondata['reward_points'].toString();

      });

    }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: Text("Profile"),
        backgroundColor: Color(0xFF5D3A1A),
      ),

      body: Padding(
        padding: EdgeInsets.all(20),

        child: Column(
          children: [

            CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(image),
            ),

            SizedBox(height:20),

            Text(name,
                style: TextStyle(
                    fontSize:22,
                    fontWeight: FontWeight.bold
                )
            ),

            SizedBox(height:10),

            Text(email),
            Text(phone),

            SizedBox(height:20),

            Card(
              child: ListTile(
                title: Text("House"),
                subtitle: Text(house),
              ),
            ),

            Card(
              child: ListTile(
                title: Text("Place"),
                subtitle: Text(place),
              ),
            ),

            Card(
              child: ListTile(
                title: Text("Post"),
                subtitle: Text(post),
              ),
            ),

            Card(
              child: ListTile(
                title: Text("Pin"),
                subtitle: Text(pin),
              ),
            ),

            Card(
              child: ListTile(
                title: Text("Reward Points"),
                subtitle: Text(points),
              ),
            ),

          ],
        ),
      ),
    );
  }
}