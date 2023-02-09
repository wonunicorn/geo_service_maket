import 'dart:math';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Geo Service',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final TextEditingController _longitude = TextEditingController();
  final TextEditingController _latitude = TextEditingController();
  final TextEditingController _z = TextEditingController();

  var x;
  var y;

  num longitudeToX(double longitude){
    var result = (longitude + 180)/360* pow(2, 19);
    return result.floor();
  }

  num latitudeToY(double latitude){
    var result = (1- log(tan(latitude * pi/180) + 1/cos(latitude*pi/180))/pi)/2 * pow(2,19);
    return result.floor();
  }

  @override
  void dispose() {
    _longitude.dispose();
    _latitude.dispose();
    _z.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _longitude,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        hintStyle: TextStyle(color: Colors.blue),
                        hintText: "longitude"
                    ),
                  ),
                ),
                const SizedBox(width: 15,),
                Expanded(
                  child: TextField(  
                    controller: _latitude,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        hintStyle: TextStyle(color: Colors.blue),
                        hintText: "latitude"
                    ),
                  ),
                ),
                const SizedBox(width: 15,),
                Expanded(
                  child: TextField(
                    controller: _z,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        hintStyle: TextStyle(color: Colors.blue),
                        hintText: "z"
                    ),
                  ),
                ),
                const SizedBox(width: 15,),
                ElevatedButton(
                    onPressed: () async{
                      if(_longitude.text.isNotEmpty && _latitude.text.isNotEmpty && _z.text.isNotEmpty){

                        setState(() {
                          x = longitudeToX(double.parse(_longitude.text.trim()));
                          y = latitudeToY(double.parse(_latitude.text.trim()));
                        });

                        //var newUrl = "https://yandex.ru/maps/geo/moskva/53166393/?l=carparks&x=$x&y=$y&z=${_z.text.trim()}";

                        var url = "https://yandex.ru/maps/geo/moskva/53166393/?l=carparks&ll=${_longitude.text.trim()}%2C${_latitude.text.trim()}&z=${_z.text.trim()}";
                        await launchUrl(Uri.parse(url));
                      }
                    },
                    child: const Text("Search"),
                ),
              ],
            ),
            const SizedBox(width: 15,),
            Text("X is ${x.toString()}"),
            const SizedBox(width: 15,),
            Text("Y is ${y.toString()}"),
          ],
        ),

      ),
    );
  }
}
