import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MediPaw',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyAppPage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyAppPage extends StatefulWidget {
  const MyAppPage({super.key, required this.title});



  final String title;

  @override
  State<MyAppPage> createState() => _MyAppPageState();
}

class _MyAppPageState extends State<MyAppPage> {

  TextEditingController ipc= new TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // automaticallyImplyLeading: false,
        title: Text(widget.title),
      ),
      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(padding: EdgeInsets.all(10), child: TextField(
                keyboardType: TextInputType.text,
                controller: ipc,
                decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'IP'))),
            ElevatedButton(onPressed: (){
              send_data();
            }, child: Text('Submit')),
          ],
        ),
      ),

    );
  }
  void send_data() async{
    String ipdata = ipc.text;
    SharedPreferences sh = await SharedPreferences.getInstance();
    sh.setString("ip",ipdata);
    sh.setString("url", "http://"+ ipdata +":8000");
    sh.setString("Image_url", "http://"+ ipdata +":8000");
    Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage(title: 'login',)));

  }
}