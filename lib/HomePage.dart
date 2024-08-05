import 'package:flutter/material.dart';
import 'package:hotel_app/AppDrawer.dart';
import 'package:hotel_app/BarChart.dart';
import 'package:hotel_app/HeaderWidget.dart';
import 'package:hotel_app/PieChartWidget.dart';
import 'package:hotel_app/RadiusWidget.dart';
import 'package:hotel_app/main.dart';
import 'storage_service.dart';
import 'ApiService.dart';

class HotelApp extends StatelessWidget {
  const HotelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          appBarTheme: const AppBarTheme(backgroundColor: MyApp.secondColor)),
      debugShowCheckedModeBanner: false,
      home: const MyHotelApp(),
    );
  }
}

class MyHotelApp extends StatelessWidget {
  const MyHotelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 1,
        child: Scaffold(
          bottomNavigationBar: Container(
            color: MyApp.secondColor,
            child: const TabBar(
              labelColor: Colors.black,
              tabs: [
                Tab(
                  icon: Icon(
                    Icons.dashboard_outlined,
                    color: Colors.black,
                  ),
                  text: "Dashboard",
                ),
              ],
              indicatorColor: Colors.black,
            ),
          ),
          body: const TabBarView(children: [MyHomePage()]),
        ));
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<Map<String, double>> getDailyCounts() async {
    String? myToken;
    try {
      myToken = await getToken();
      final response = await ApiService.getDailyCounts(myToken!);
      return response;
    } catch (e) {
      print("Error $e");
      return {};
    }
  }

  Future<Map<String, dynamic>> getUser() async {
    String? myToken;
    try {
      myToken = await getToken();
      final response = await ApiService.getUser(myToken!);
      return response;
    } catch (e) {
      print("Error $e");
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    const int numOfRooms = 31;
    return FutureBuilder<Map<String, dynamic>>(
      future: getUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
              backgroundColor: MyApp.color,
              body: Center(
                  child: CircularProgressIndicator(
                color: MyApp.loadindCircularColor,
              )));
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          // ignore: unused_local_variable
          final user = snapshot.data!;
          DateTime businessDate = DateTime.parse(user["businessDay"]) ;
          return Scaffold(
            key: _scaffoldKey,
            drawer: AppDrawer(),
            backgroundColor: MyApp.color,
            appBar: AppBar(
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(2.5),
                  child: Container(
                    color: Colors.black,
                    height: 2.5,
                  ),
                ),
                leading: AppBar(
        title: Text('Home'),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        
      ),
                backgroundColor: MyApp.secondColor,
                automaticallyImplyLeading: false,
                centerTitle: true,
                title: const Column(
                  children: [
                    Text(
                      "Dashboard",
                      style: MyApp.titleTextStyle
                    ),
                  ],
                )),
            body: Padding(
              padding: const EdgeInsets.all(10.0),
              child: FutureBuilder<Map<String, double>>(
                  future: getDailyCounts(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                          child: CircularProgressIndicator(
                        color: MyApp.loadindCircularColor,
                      ));
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.hasData) {
                      final counts = snapshot.data;

                      return SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column( mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            HeaderWidget(hotelName: MyApp.hotelName, businessDate: businessDate,),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                CircularProgressWidget(
                                  text: "Occupied",
                                  upperNumber: counts!["inReservations"]!.toInt(),
                                  lowerNumber:
                                      "${((counts["inReservations"]! / numOfRooms)*100).toStringAsFixed(2)}%",
                                  percentage:
                                      (counts["inReservations"]! / numOfRooms),
                                  progressColor: Colors.red,
                                ),
                                CircularProgressWidget(
                                  text: "Vacant",
                                  upperNumber:
                                      counts["totalVacantRooms"]!.toInt(),
                                  lowerNumber:
                                      "${((counts["totalVacantRooms"]! / numOfRooms)*100).toStringAsFixed(2)}%",
                                  percentage:
                                      (counts["totalVacantRooms"]! / numOfRooms),
                                  progressColor: Colors.green[200]!,
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                CircularProgressWidget(
                                  text: "Booked",
                                  upperNumber:
                                      counts["totalReservedRooms"]!.toInt(),
                                  lowerNumber:
                                      "${((counts["totalReservedRooms"]! / numOfRooms)*100).toStringAsFixed(2)}%",
                                  percentage: (counts["totalReservedRooms"]! /
                                      numOfRooms),
                                  progressColor: Colors.blue.shade300,
                                ),
                                CircularProgressWidget(
                                  text: "Dirty",
                                  upperNumber:
                                      counts["totalDirtyRooms"]!.toInt(),
                                  lowerNumber:
                                      "${((counts["totalDirtyRooms"]! / numOfRooms)*100).toStringAsFixed(2)}%",
                                  percentage:
                                      (counts["totalDirtyRooms"]! / numOfRooms),
                                  progressColor: Colors.yellow[400]!,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Flexible(
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(0, 25, 0, 25),
                                    child: SizedBox(
                                      height: 250,
                                      child: BarChartWidget(
                                          soldYesterday: counts["totalSoldYesterday"]!,
                                          stayingOvernight: counts["totalSleepingOverNight"]!,
                                          arrivals: counts["totalArrivals"]!,
                                          checkouts: counts["checkedOutReservations"]!,
                                          arrivedToday: counts["checkedInReservations"]!),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            
              Row(children: [
                Expanded(child: PieChartWidget(
                  totalGuests: counts["totalNumOfGuests"]!.toInt(),
                  boGuests: counts["totalBOGuests"]!,
                  boField1: counts["totalBOGuests"]!.toString(),
                  boField2: "${((counts["totalBOGuests"]!/counts["totalNumOfGuests"]!)*100).toStringAsFixed(2)}%",
                  boField3: "R# ${counts["totalBoRooms"]!}",
                  bbGuests: counts["totalBBGuests"]!,
                  bbField1: counts["totalBBGuests"]!.toString(),
                  bbField2: "${((counts["totalBBGuests"]!/counts["totalNumOfGuests"]!)*100).toStringAsFixed(2)}%",
                  bbField3: "R# ${counts["totalBbRooms"]!}",
                  hbGuests: counts["totalHBGuests"]!,
                  hbField1: counts["totalHBGuests"]!.toString(),
                  hbField2: "${((counts["totalHBGuests"]!/counts["totalNumOfGuests"]!)*100).toStringAsFixed(2)}%",
                  hbField3: "R# ${counts["totalHbRooms"]!}",
                  fbGuests: counts["totalFBGuests"]!,
                  fbField1: counts["totalFBGuests"]!.toString(),
                  fbField2: "${((counts["totalFBGuests"]!/counts["totalNumOfGuests"]!)*100).toStringAsFixed(2)}%",
                  fbField3: "R# ${counts["totalFbRooms"]!}" ))
              ],)
                          ],
                        ),
                      );
                    } else {
                      return const Center(child: Text('No counts found'));
                    }
                  }),
            ),
          );
        } else {
          return const Center(child: Text('No user found'));
        }
      },
    );
  }
}
