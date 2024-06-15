// import 'dart:ffi';
// import 'dart:js';
// import 'dart:math';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:ionicons/ionicons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tourist/activities%20page/Balloon_ride.dart';
import 'package:tourist/activities%20page/river_cruise.dart';
import 'package:tourist/activities%20page/wine_testing.dart';
import 'package:tourist/bottem_nav/bookmark.dart';
import 'package:tourist/bottem_nav/bottem_nav.dart';
import 'package:tourist/components.dart';
import 'package:tourist/login.dart';
import 'package:tourist/recomandationpage/botanic-garden.dart';
import 'package:tourist/recomandationpage/fed_square.dart';
import 'package:tourist/recomandationpage/kilda.dart';
import 'package:tourist/recomandationpage/market.dart';
import 'package:tourist/recomandationpage/ocen-road.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:tourist/register.dart';
import 'package:tourist/user_model.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class home_page extends StatefulWidget {
  const home_page({super.key});

  @override
  State<home_page> createState() => _home_pageState();
}

final userdetail = Get.put(Register());
final db = FirebaseFirestore.instance;

class _home_pageState extends State<home_page> {
  final user = FirebaseAuth.instance.currentUser;
  final String apikey = "dbcab126534348897d8e7ae5f268fa3a";
  double latitude = 0.0;
  double longitude = 0.0;
  int temperature = 0;
  String description = "";
  double wspeed = 0.0;
  int humidity = 0;
  String iconUrl = '';
  List items = [];
  var user_name = "";

  Future<void> readJson() async {
    final String response =
        await rootBundle.loadString('Assests/activities.json');
    final data = await json.decode(response);
    setState(() {
      items = data["items"];
    });
  }

  Future<UserModel> userdetail(String email) async {
    final snapshot =
        await db.collection('User_info').where('email', isEqualTo: email).get();
    final userdata = snapshot.docs.map((e) => UserModel.fromsnapshot(e)).single;
    return userdata;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getlocation();
    readJson();
    loadWeatherData();
    getuser();
  }

  Future<void> usersignout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushNamed(context, 'login');
  }

  Future<void> getuser() async {
    final value = await userdetail(user!.email.toString());
    setState(() {
      user_name = value.name;
    });
    SharedPreferences username = await SharedPreferences.getInstance();
    await username.setString('userName', user_name);
  }

  void getWeather() async {
    // call the weather api
    Uri uri = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apikey');

    http.Response reponse = await http.get(uri);

    String data = reponse.body;
    var decodedData = jsonDecode(data);

    double temperaturekal = decodedData["main"]["temp"];
    temperature = (temperaturekal - 273.15).round().toInt();
    humidity = decodedData["main"]["humidity"];
    description = decodedData["weather"][0]["description"];
    wspeed = decodedData["wind"]["speed"];
    String iconCode = decodedData["weather"][0]["icon"];
    String country = decodedData["sys"]["country"];
    print(country);
    print(iconCode);
    iconUrl = 'http://openweathermap.org/img/wn/$iconCode.png';

    // save api values to json file
    saveWeatherDataToFile({
      'temperature': temperature,
      'humidity': humidity,
      'description': description,
      'wspeed': wspeed,
      'iconUrl': iconUrl,
      'country': country,
    });
  }

  Future<void> saveWeatherDataToFile(Map<String, dynamic> data) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/weather_data.json');
      await file.writeAsString(jsonEncode(data));
      print('Weather data saved to JSON file');
    } catch (e) {
      print('Error saving data: $e');
    }
  }

  Future<Map<String, dynamic>> readWeatherDataFromFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/weather_data.json');
      if (await file.exists()) {
        final jsonString = await file.readAsString();
        final jsonData = jsonDecode(jsonString);
        return jsonData;
      }
      print("Retrived weather data");
    } catch (e) {
      print('Error reading data: $e');
    }
    return {};
  }

  Future<void> loadWeatherData() async {
    final weatherData = await readWeatherDataFromFile();
    if (weatherData.isNotEmpty) {
      setState(() {
        temperature = weatherData['temperature'];
        humidity = weatherData['humidity'];
        description = weatherData['description'];
        wspeed = weatherData['wspeed'];
        iconUrl = weatherData['iconUrl'];
      });
    }
  }

  void getlocation() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    latitude = position.latitude;
    longitude = position.longitude;

    getWeather();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          toolbarHeight: 100,
          title: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey[200],
                child: Icon(Icons.person, color: Colors.grey, size: 30),
              ),
              SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hi, ${user_name.isNotEmpty ? user_name : 'Loading...'}",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "Welcome back",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
          backgroundColor: Colors.white,
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(Ionicons.notifications_outline, color: Colors.black),
            ),
            IconButton(
              onPressed: () {
                usersignout();
              },
              icon: Icon(Ionicons.log_out_outline, color: Colors.black),
            ),
          ],
        ),

        body: Column(
          children: [
            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                height: 130,
                width: double.maxFinite,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFCAF4FF), Colors.white],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 2), // changes position of shadow
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0, left: 12.0),
                          child: Text(
                            temperature.toString() + "°C",
                            style: TextStyle(
                                fontSize: 50, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Row(
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Icon(Icons.water_drop, color: Colors.blue),
                                  SizedBox(width: 3),
                                  Text(
                                    humidity.toString() + "%",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                              SizedBox(width: 10),
                              Text(
                                description,
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        iconUrl.isNotEmpty
                            ? Image.network(iconUrl,
                                width: 150, height: 120, fit: BoxFit.contain)
                            : SizedBox(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(15),
                children: [
                  //const catagory_page(),
                  SizedBox(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Recomandation",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      TextButton(
                          onPressed: () {},
                          child: const Text("View all",
                              style: TextStyle(
                                color: Colors.blue,
                              ))),
                    ],
                  ),

// fed square

                  SizedBox(
                    height: 280,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        Card(
                          elevation: 0.5,
                          child: SizedBox(
                            width: 190,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                        pageBuilder: (context, animation,
                                                secondaryAnimation) =>
                                            fed_square(),
                                        transitionsBuilder: (context, animation,
                                            secondaryAnimation, child) {
                                          return FadeTransition(
                                            opacity: animation,
                                            child: child,
                                          );
                                        },
                                        transitionDuration:
                                            Duration(milliseconds: 500)));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.asset(
                                        'Assests/Icons/federation_square.jpg',
                                        height: 150,
                                        width: 170,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        Text('Federation square',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold)),
                                        Icon(
                                          Icons.star,
                                          color: Colors.yellow,
                                          size: 15,
                                        ),
                                        Text('4.3')
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Icon(Ionicons.location_outline),
                                        Expanded(
                                            child: Text(
                                                'Swanston St & Flinders St')),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        // st kilda beach
                        Card(
                          elevation: 0.5,
                          child: SizedBox(
                            width: 190,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                        pageBuilder: (context, animation,
                                                secondaryAnimation) =>
                                            Kilda(),
                                        transitionsBuilder: (context, animation,
                                            secondaryAnimation, child) {
                                          return FadeTransition(
                                            opacity: animation,
                                            child: child,
                                          );
                                        },
                                        transitionDuration:
                                            Duration(milliseconds: 500)));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.asset(
                                        'Assests/Icons/kilda_beach.png',
                                        height: 150,
                                        width: 160,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        Text('St. kilda beach',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
                                        Icon(
                                          Icons.star,
                                          color: Colors.yellow,
                                          size: 15,
                                        ),
                                        Text('4.4')
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Icon(Ionicons.location_outline),
                                        Text('St Kilda, Victoria')
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        // royal botanic garden
                        Card(
                          elevation: 0.5,
                          child: SizedBox(
                            width: 190,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                        pageBuilder: (context, animation,
                                                secondaryAnimation) =>
                                            BotanicGarden(),
                                        transitionsBuilder: (context, animation,
                                            secondaryAnimation, child) {
                                          return FadeTransition(
                                            opacity: animation,
                                            child: child,
                                          );
                                        },
                                        transitionDuration:
                                            Duration(milliseconds: 500)));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.asset(
                                        'Assests/Icons/botanic_garden.jpg',
                                        height: 150,
                                        width: 160,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                            child: Text('Royal botanic garden',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold))),
                                        Icon(
                                          Icons.star,
                                          color: Colors.yellow,
                                          size: 15,
                                        ),
                                        Text('4.2')
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Icon(Ionicons.location_outline),
                                        Expanded(
                                            child: Text(
                                                'Birdwood Ave, South Yarra'))
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        // victoria market
                        Card(
                          elevation: 0.5,
                          child: SizedBox(
                            width: 190,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                        pageBuilder: (context, animation,
                                                secondaryAnimation) =>
                                            Market(),
                                        transitionsBuilder: (context, animation,
                                            secondaryAnimation, child) {
                                          return FadeTransition(
                                            opacity: animation,
                                            child: child,
                                          );
                                        },
                                        transitionDuration:
                                            Duration(milliseconds: 500)));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.asset(
                                        'Assests/Icons/victoria_market.jpeg',
                                        height: 150,
                                        width: 160,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        Text('Victoria market',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
                                        Icon(
                                          Icons.star,
                                          color: Colors.yellow,
                                          size: 15,
                                        ),
                                        Text('4.6')
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Icon(Ionicons.location_outline),
                                        Text('Queen St, Melbourne')
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        // ocean road
                        Card(
                          elevation: 0.5,
                          child: SizedBox(
                            width: 190,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                        pageBuilder: (context, animation,
                                                secondaryAnimation) =>
                                            OceanRoad(),
                                        transitionsBuilder: (context, animation,
                                            secondaryAnimation, child) {
                                          return FadeTransition(
                                            opacity: animation,
                                          );
                                        },
                                        transitionDuration:
                                            Duration(milliseconds: 500)));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.asset(
                                        'Assests/Icons/ocen_road.jpg',
                                        height: 150,
                                        width: 160,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                            child: Text('The great ocean road',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold))),
                                        Icon(
                                          Icons.star,
                                          color: Colors.yellow,
                                          size: 15,
                                        ),
                                        Text('4.6')
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Icon(Ionicons.location_outline),
                                        Expanded(
                                            child: Text(
                                                'Great Ocean Road, Port Campbell'))
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  //Activities
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Activities",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      TextButton(
                          onPressed: () {},
                          child: const Text("View all",
                              style: TextStyle(
                                color: Colors.blue,
                              ))),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: SizedBox(
                      height: 300,
                      width: double.maxFinite,
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, items[index]['link']);
                            },
                            child: Card(
                                elevation: 0.5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(13),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(13),
                                        child: Image.asset(
                                          items[index]['img'],
                                          height: 150,
                                          width: 150,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Container(
                                          constraints: BoxConstraints(
                                            maxWidth: 180,
                                          ),
                                          child: Column(children: [
                                            Text(
                                              items[index]['name'],
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Icon(Icons.location_pin,
                                                    color: Colors.red),
                                                Expanded(
                                                  child: Text(
                                                      items[index]['address']),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.star,
                                                      color: Colors.yellow,
                                                    ),
                                                    Text(
                                                        items[index]['rating']),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      items[index]['price'],
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20,
                                                          color: Colors.green),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ]),
                                        ),
                                      )
                                    ],
                                  ),
                                )),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
