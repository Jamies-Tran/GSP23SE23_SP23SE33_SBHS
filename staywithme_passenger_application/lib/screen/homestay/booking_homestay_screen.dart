import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:staywithme_passenger_application/bloc/booking_bloc.dart';
import 'package:staywithme_passenger_application/bloc/choose_service_bloc.dart';
import 'package:staywithme_passenger_application/bloc/event/choose_service_event.dart';
import 'package:staywithme_passenger_application/bloc/event/view_facility_event.dart';
import 'package:staywithme_passenger_application/bloc/state/booking_state.dart';
import 'package:staywithme_passenger_application/bloc/state/choose_service_state.dart';
import 'package:staywithme_passenger_application/bloc/view_facility_bloc.dart';
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
  final bookingBloc = BookingBloc();

  List<Widget> widgetList(
          HomestayModel homestay,
          String bookingStart,
          String bookingEnd,
          List<HomestayServiceModel> homestayServiceList,
          int totalServicePrice) =>
      [
        ChooseServiceScreen(
          homestayServiceList: homestay.homestayServices,
          homestayName: homestay.name,
          bookingStart: bookingStart,
          bookingEnd: bookingEnd,
        ),
        ViewHomestayFacilityScreen(
          homestayFacilityList: homestay.homestayFacilities,
          homestayName: homestay.name,
          bookingStart: bookingStart,
          bookingEnd: bookingEnd,
          homestayServiceList: homestayServiceList,
          totalServicePrice: totalServicePrice,
        ),
        ViewHomestayRuleScreen(
          homestayRuleList: homestay.homestayRules,
          homestayName: homestay.name,
          bookingStart: bookingStart,
          bookingEnd: bookingEnd,
          homestayServiceList: homestayServiceList,
          totalServicePrice: totalServicePrice,
        )
      ];

  @override
  void dispose() {
    bookingBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BookingState>(
        stream: bookingBloc.stateController.stream,
        initialData: bookingBloc.initData(context),
        builder: (context, streamSnapshot) {
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
                      icon: Icon(Icons.rule), label: "Rules"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.alarm), label: "Overview")
                ],
                currentIndex: streamSnapshot.data!.selectedIndex!,
                backgroundColor: primaryColor,
                selectedItemColor: Colors.black,
                selectedLabelStyle: const TextStyle(
                    fontFamily: "Lobster", fontWeight: FontWeight.bold),
                showUnselectedLabels: false,
              ),
            ),
            body: FutureBuilder(
              future: homestayService
                  .getHomestayDetailByName(streamSnapshot.data!.homestayName!),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Column(
                      children: const [
                        SpinKitCircle(
                          color: primaryColor,
                        ),
                        Text("getting homestay info...")
                      ],
                    );
                  case ConnectionState.done:
                    if (snapshot.hasData) {
                      final data = snapshot.data;
                      if (data is HomestayModel) {
                        return widgetList(
                                data,
                                streamSnapshot.data!.bookingStart!,
                                streamSnapshot.data!.bookingEnd!,
                                streamSnapshot.data!.homestayServiceList!,
                                streamSnapshot.data!.totalServicePrice!)[
                            streamSnapshot.data!.selectedIndex!];
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
            ),
          ));
        });
  }
}

class ChooseServiceScreen extends StatefulWidget {
  const ChooseServiceScreen(
      {super.key,
      this.homestayServiceList,
      this.homestayName,
      this.bookingStart,
      this.bookingEnd});
  final List<HomestayServiceModel>? homestayServiceList;
  final String? homestayName;
  final String? bookingStart;
  final String? bookingEnd;

  @override
  State<ChooseServiceScreen> createState() => _ChooseServiceScreenState();
}

class _ChooseServiceScreenState extends State<ChooseServiceScreen> {
  final homestayService = locator.get<IHomestayService>();
  final chooseHomestayServiceBloc = ChooseHomestayServiceBloc();

  @override
  void dispose() {
    chooseHomestayServiceBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ChooseServiceState>(
        stream: chooseHomestayServiceBloc.stateController.stream,
        initialData: chooseHomestayServiceBloc.initData(),
        builder: (context, streamSnapshot) {
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
                  itemCount: widget.homestayServiceList!.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        chooseHomestayServiceBloc.eventController.sink.add(
                            OnTabHomestayServiceEvent(
                                homestayServiceModel:
                                    widget.homestayServiceList![index]));
                      },
                      child: Container(
                        height: 100,
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                            color: streamSnapshot.data!.isServiceChoose(widget
                                        .homestayServiceList![index].name!) ==
                                    true
                                ? primaryColor
                                : Colors.white),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                widget.homestayServiceList![index].name!,
                                style: const TextStyle(
                                    fontFamily: "Lobster",
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                width: 100,
                              ),
                              Text(
                                "Price(VND): ${currencyFormat.format(widget.homestayServiceList![index].price!)}",
                                style: TextStyle(
                                    fontFamily: "Lobster",
                                    letterSpacing: 1.0,
                                    color: streamSnapshot.data!.isServiceChoose(
                                                widget
                                                    .homestayServiceList![index]
                                                    .name!) ==
                                            true
                                        ? Colors.black
                                        : secondaryColor,
                                    fontWeight: FontWeight.bold),
                              )
                            ]),
                      ),
                    );
                  },
                ),
              ),
              Text(
                "Total: ${currencyFormat.format(streamSnapshot.data!.totalServicePrice())}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      minimumSize: const Size(200, 50),
                      maximumSize: const Size(200, 50)),
                  onPressed: () {
                    chooseHomestayServiceBloc.eventController.sink.add(
                        OnNextStepToHomestayFacilityEvent(
                            context: context,
                            homestayName: widget.homestayName,
                            homestayServiceList:
                                streamSnapshot.data!.homestayServiceList,
                            totalServicePrice:
                                streamSnapshot.data!.totalServicePrice(),
                            bookingStart: widget.bookingStart,
                            bookingEnd: widget.bookingEnd));
                  },
                  child: const Text(
                    "Next",
                    style: TextStyle(
                        fontFamily: "Lobster",
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ))
            ],
          );
        });
  }
}

class ViewHomestayFacilityScreen extends StatefulWidget {
  const ViewHomestayFacilityScreen(
      {super.key,
      this.homestayFacilityList,
      this.homestayName,
      this.bookingStart,
      this.bookingEnd,
      this.homestayServiceList,
      this.totalServicePrice});
  final List<HomestayFacilityModel>? homestayFacilityList;
  final String? homestayName;
  final String? bookingStart;
  final String? bookingEnd;
  final List<HomestayServiceModel>? homestayServiceList;
  final int? totalServicePrice;

  @override
  State<ViewHomestayFacilityScreen> createState() =>
      _ViewHomestayFacilityScreenState();
}

class _ViewHomestayFacilityScreenState
    extends State<ViewHomestayFacilityScreen> {
  final viewHomestayFacilityBloc = ViewHomestayFacilityBloc();

  @override
  void dispose() {
    viewHomestayFacilityBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(builder: (context, snapshot) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Homestay Facility List",
            style: TextStyle(
                fontSize: 25, fontWeight: FontWeight.bold, color: primaryColor),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 500,
            child: ListView.builder(
              itemCount: widget.homestayFacilityList!.length,
              itemBuilder: (context, index) {
                return Container(
                  height: 100,
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Colors.white),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          widget.homestayFacilityList![index].name!,
                          style: const TextStyle(
                              fontFamily: "Lobster",
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          width: 100,
                        ),
                        Text(
                          "Quantity: ${widget.homestayFacilityList![index].quantity!}",
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
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  minimumSize: const Size(200, 50),
                  maximumSize: const Size(200, 50)),
              onPressed: () {
                viewHomestayFacilityBloc.eventController.sink.add(
                    OnNextStepToHomestayRuleEvent(
                        homestayName: widget.homestayName,
                        bookingStart: widget.bookingStart,
                        bookingEnd: widget.bookingEnd,
                        context: context,
                        homestayServiceList: widget.homestayServiceList,
                        totalServicePrice: widget.totalServicePrice));
              },
              child: const Text(
                "Next",
                style: TextStyle(
                    fontFamily: "Lobster",
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ))
        ],
      );
    });
  }
}

class ViewHomestayRuleScreen extends StatefulWidget {
  const ViewHomestayRuleScreen(
      {super.key,
      this.homestayName,
      this.homestayRuleList,
      this.bookingStart,
      this.bookingEnd,
      this.homestayServiceList,
      this.totalServicePrice});
  final List<HomestayRule>? homestayRuleList;
  final String? homestayName;
  final String? bookingStart;
  final String? bookingEnd;
  final List<HomestayServiceModel>? homestayServiceList;
  final int? totalServicePrice;

  @override
  State<ViewHomestayRuleScreen> createState() => _ViewHomestayRuleScreenState();
}

class _ViewHomestayRuleScreenState extends State<ViewHomestayRuleScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "View Homestay Rules",
          style: TextStyle(
              fontSize: 25, fontWeight: FontWeight.bold, color: primaryColor),
        ),
        SizedBox(
          height: 500,
          child: ListView.builder(
            itemCount: widget.homestayRuleList!.length,
            itemBuilder: (context, index) {
              return Container();
            },
          ),
        )
      ],
    );
  }
}
