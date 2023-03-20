import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:staywithme_passenger_application/global_variable.dart';
import 'package:staywithme_passenger_application/model/exc_model.dart';
import 'package:staywithme_passenger_application/model/homestay_model.dart';
import 'package:staywithme_passenger_application/service/homestay/homestay_service.dart';
import 'package:staywithme_passenger_application/service_locator/service_locator.dart';

class BookingHomestayScreen extends StatefulWidget {
  const BookingHomestayScreen({super.key});
  static const bookingHomestayScreenRoute = "/booking-homestay";

  @override
  State<BookingHomestayScreen> createState() => _BookingHomestayScreenState();
}

class _BookingHomestayScreenState extends State<BookingHomestayScreen> {
  final homestayService = locator.get<IHomestayService>();

  List<Widget> widgetList(String homestayName) => [
        ChooseServiceScreen(
          homestayName: homestayName,
        )
      ];

  @override
  Widget build(BuildContext context) {
    final contextArguments = ModalRoute.of(context)!.settings.arguments as Map;
    String homestayName = contextArguments["homestayName"];
    int selectedIndex = contextArguments["selectedIndex"] ?? 0;

    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(MediaQuery.of(context).size.width, 100),
          child: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.room_service), label: "Services"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.chair), label: "Facilities"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.alarm), label: "Overview")
            ],
            currentIndex: selectedIndex,
            backgroundColor: primaryColor,
            selectedItemColor: Colors.black,
            selectedLabelStyle: const TextStyle(
                fontFamily: "Lobster", fontWeight: FontWeight.bold),
            showUnselectedLabels: false,
          ),
        ),
        body: widgetList(homestayName)[selectedIndex],
      ),
    );
  }
}

class ChooseServiceScreen extends StatefulWidget {
  const ChooseServiceScreen({super.key, this.homestayName});
  final String? homestayName;

  @override
  State<ChooseServiceScreen> createState() => _ChooseServiceScreenState();
}

class _ChooseServiceScreenState extends State<ChooseServiceScreen> {
  final homestayService = locator.get<IHomestayService>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: homestayService.getHomestayDetailByName(widget.homestayName!),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Column(
              children: const [
                SpinKitCircle(
                  color: primaryColor,
                ),
                Text("getting homestay service...")
              ],
            );
          case ConnectionState.done:
            if (snapshot.hasData) {
              final data = snapshot.data;
              if (data is HomestayModel) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Choose your service",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: primaryColor),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 500,
                      child: ListView.builder(
                        itemCount: data.homestayServices!.length,
                        itemBuilder: (context, index) {
                          return Container(
                            height: 100,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    style: BorderStyle.solid,
                                    color: Colors.black45,
                                    width: 1.0)),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    data.homestayServices![index].name!,
                                    style: const TextStyle(
                                        fontFamily: "Lobster",
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    width: 100,
                                  ),
                                  Text(
                                    "Price(VND): ${currencyFormat.format(data.homestayServices![index].price!)}",
                                    style: const TextStyle(
                                        fontFamily: "Lobster",
                                        letterSpacing: 1.0,
                                        color: secondaryColor,
                                        fontWeight: FontWeight.bold),
                                  )
                                ]),
                          );
                        },
                      ),
                    ),
                  ],
                );
              } else if (data is ServerExceptionModel) {
                return AlertDialog(
                  title: const Center(
                    child: Text("Notice"),
                  ),
                  content: SizedBox(
                    height: 100,
                    width: 250,
                    child: Center(child: Text(data.message!)),
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Try again"))
                  ],
                );
              } else {
                return AlertDialog(
                  title: const Center(
                    child: Text("Notice"),
                  ),
                  content: const SizedBox(
                    height: 100,
                    width: 250,
                    child: Center(child: Text("Network error")),
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Try again"))
                  ],
                );
              }
            } else {
              return AlertDialog(
                title: const Center(
                  child: Text("Notice"),
                ),
                content: SizedBox(
                  height: 100,
                  width: 250,
                  child: Center(child: Text(snapshot.error.toString())),
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Try again"))
                ],
              );
            }
          default:
            break;
        }
        return const SizedBox();
      },
    );
  }
}
