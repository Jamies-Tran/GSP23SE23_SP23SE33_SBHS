import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:staywithme_passenger_application/bloc/booking_bloc.dart';
import 'package:staywithme_passenger_application/bloc/choose_service_bloc.dart';
import 'package:staywithme_passenger_application/bloc/event/choose_service_event.dart';
import 'package:staywithme_passenger_application/bloc/event/overview_booking_event.dart';
import 'package:staywithme_passenger_application/bloc/event/view_facility_event.dart';
import 'package:staywithme_passenger_application/bloc/event/view_rule_event.dart';
import 'package:staywithme_passenger_application/bloc/overview_booking_bloc.dart';
import 'package:staywithme_passenger_application/bloc/state/booking_state.dart';
import 'package:staywithme_passenger_application/bloc/state/choose_service_state.dart';
import 'package:staywithme_passenger_application/bloc/state/overview_booking_state.dart';
import 'package:staywithme_passenger_application/bloc/view_facility_bloc.dart';
import 'package:staywithme_passenger_application/bloc/view_rule_bloc.dart';
import 'package:staywithme_passenger_application/global_variable.dart';
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
          int bookingId,
          String bookingStart,
          String bookingEnd,
          List<HomestayServiceModel> homestayServiceList,
          int totalServicePrice) =>
      [
        ViewHomestayFacilityScreen(
          homestayFacilityList: homestay.homestayFacilities,
          homestay: homestay,
          bookingId: bookingId,
          bookingStart: bookingStart,
          bookingEnd: bookingEnd,
        ),
        ViewHomestayRuleScreen(
          homestayRuleList: homestay.homestayRules,
          homestay: homestay,
          bookingId: bookingId,
          bookingStart: bookingStart,
          bookingEnd: bookingEnd,
        ),
        ChooseServiceScreen(
          homestayServiceList: homestay.homestayServices,
          bookingId: bookingId,
          homestay: homestay,
          bookingStart: bookingStart,
          bookingEnd: bookingEnd,
        ),
        OverviewBookingScreen(
          homestay: homestay,
          bookingId: bookingId,
          bookingStart: bookingStart,
          bookingEnd: bookingEnd,
          homestayServiceList: homestayServiceList,
          totalServicePrice: totalServicePrice,
        ),
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
                      icon: Icon(Icons.chair),
                      label: "Facilities",
                      backgroundColor: primaryColor),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.rule),
                      label: "Rules",
                      backgroundColor: primaryColor),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.room_service),
                      label: "Services",
                      backgroundColor: primaryColor),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.alarm),
                      label: "Overview",
                      backgroundColor: primaryColor)
                ],
                currentIndex: streamSnapshot.data!.selectedIndex!,
                selectedItemColor: Colors.black,
                selectedLabelStyle: const TextStyle(
                    fontFamily: "Lobster", fontWeight: FontWeight.bold),
                showUnselectedLabels: false,
              ),
            ),
            body: widgetList(
                streamSnapshot.data!.homestay!,
                streamSnapshot.data!.bookingId!,
                streamSnapshot.data!.bookingStart!,
                streamSnapshot.data!.bookingEnd!,
                streamSnapshot.data!.homestayServiceList!,
                streamSnapshot.data!
                    .totalServicePrice!)[streamSnapshot.data!.selectedIndex!],
          ));
        });
  }
}

class ChooseServiceScreen extends StatefulWidget {
  const ChooseServiceScreen(
      {super.key,
      this.homestayServiceList,
      this.homestay,
      this.bookingId,
      this.bookingStart,
      this.bookingEnd});
  final List<HomestayServiceModel>? homestayServiceList;
  final HomestayModel? homestay;
  final int? bookingId;
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
              TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: 1),
                duration: const Duration(seconds: 1),
                builder: (context, value, child) =>
                    Opacity(opacity: value, child: child),
                child: const Text(
                  "Choose your service",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: primaryColor),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 500,
                child: ListView.builder(
                  itemCount: widget.homestayServiceList!.length,
                  itemBuilder: (context, index) {
                    return TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0, end: 1),
                      duration: Duration(seconds: index + 1),
                      builder: (context, value, child) =>
                          Opacity(opacity: value, child: child),
                      child: GestureDetector(
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
                                  : Colors.grey),
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
                                      color: streamSnapshot.data!
                                                  .isServiceChoose(widget
                                                      .homestayServiceList![
                                                          index]
                                                      .name!) ==
                                              true
                                          ? Colors.black
                                          : secondaryColor,
                                      fontWeight: FontWeight.bold),
                                )
                              ]),
                        ),
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
                        OnNextStepToOverviewBookingHomestayEvent(
                            context: context,
                            homestay: widget.homestay,
                            bookingId: widget.bookingId,
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
  const ViewHomestayFacilityScreen({
    super.key,
    this.homestayFacilityList,
    this.homestay,
    this.bookingId,
    this.bookingStart,
    this.bookingEnd,
  });
  final List<HomestayFacilityModel>? homestayFacilityList;
  final HomestayModel? homestay;
  final int? bookingId;
  final String? bookingStart;
  final String? bookingEnd;

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
          TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: 1),
            duration: const Duration(seconds: 1),
            builder: (context, value, child) => Opacity(
              opacity: value,
              child: child,
            ),
            child: const Text(
              "Homestay Facility List",
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: primaryColor),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 500,
            child: ListView.builder(
              itemCount: widget.homestayFacilityList!.length,
              itemBuilder: (context, index) {
                return TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: Duration(seconds: index + 1),
                  builder: (context, value, child) => Opacity(
                    opacity: value,
                    child: child,
                  ),
                  child: Container(
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
                  ),
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
                viewHomestayFacilityBloc.eventController.sink
                    .add(OnNextStepToHomestayRuleEvent(
                  homestay: widget.homestay,
                  bookingId: widget.bookingId,
                  bookingStart: widget.bookingStart,
                  bookingEnd: widget.bookingEnd,
                  context: context,
                ));
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
  const ViewHomestayRuleScreen({
    super.key,
    this.homestay,
    this.bookingId,
    this.homestayRuleList,
    this.bookingStart,
    this.bookingEnd,
  });
  final List<HomestayRuleModel>? homestayRuleList;
  final HomestayModel? homestay;
  final int? bookingId;
  final String? bookingStart;
  final String? bookingEnd;

  @override
  State<ViewHomestayRuleScreen> createState() => _ViewHomestayRuleScreenState();
}

class _ViewHomestayRuleScreenState extends State<ViewHomestayRuleScreen> {
  final viewHomestayRuleBloc = ViewHomestayRuleBloc();

  @override
  void dispose() {
    viewHomestayRuleBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(builder: (context, snapshot) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: 1),
            duration: const Duration(seconds: 1),
            builder: (context, value, child) =>
                Opacity(opacity: value, child: child),
            child: const Text(
              "View Homestay Rules",
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: primaryColor),
            ),
          ),
          SizedBox(
            height: 500,
            child: ListView.builder(
              itemCount: widget.homestayRuleList!.length,
              itemBuilder: (context, index) {
                return TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: Duration(seconds: index + 1),
                  builder: (context, value, child) => Opacity(
                    opacity: value,
                    child: child,
                  ),
                  child: Container(
                    height: 200,
                    margin: const EdgeInsets.only(bottom: 10),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("${index + 1}",
                              style: const TextStyle(
                                  fontFamily: "Lobster",
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor)),
                          const SizedBox(
                            width: 100,
                          ),
                          Text(
                            "${widget.homestayRuleList![index].description}",
                            style: const TextStyle(
                                fontFamily: "Lobster",
                                fontWeight: FontWeight.bold),
                          )
                        ]),
                  ),
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
                viewHomestayRuleBloc.eventController.sink
                    .add(OnNextStepToChooseHomestayServiceEvent(
                  context: context,
                  homestay: widget.homestay,
                  bookingId: widget.bookingId,
                  bookingStart: widget.bookingStart,
                  bookingEnd: widget.bookingEnd,
                ));
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

// ignore: constant_identifier_names
enum PaymentMethod { swm_wallet, cash }

class OverviewBookingScreen extends StatefulWidget {
  const OverviewBookingScreen(
      {super.key,
      this.homestay,
      this.bookingId,
      this.bookingStart,
      this.bookingEnd,
      this.homestayServiceList,
      this.totalServicePrice});
  final HomestayModel? homestay;
  final int? bookingId;
  final String? bookingStart;
  final String? bookingEnd;
  final List<HomestayServiceModel>? homestayServiceList;
  final int? totalServicePrice;

  @override
  State<OverviewBookingScreen> createState() => _OverviewBookingScreenState();
}

class _OverviewBookingScreenState extends State<OverviewBookingScreen> {
  final overviewBookingBloc = OverviewBookingBloc();

  @override
  void dispose() {
    overviewBookingBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<OverviewBookingState>(
        stream: overviewBookingBloc.stateController.stream,
        initialData: overviewBookingBloc.initData(
            widget.homestay!,
            widget.bookingStart!,
            widget.bookingEnd!,
            widget.homestay!.availableRooms!,
            widget.homestayServiceList!,
            widget.totalServicePrice!),
        builder: (context, snapshot) {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: const Duration(seconds: 1),
                  builder: (context, value, child) => Opacity(
                    opacity: value,
                    child: child,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white24,
                        boxShadow: const [
                          BoxShadow(
                              blurRadius: 2.0,
                              blurStyle: BlurStyle.outer,
                              offset: Offset(0.5, 0.5),
                              color: Colors.black45)
                        ]),
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TweenAnimationBuilder(
                            tween: Tween<double>(begin: 0, end: 1),
                            duration: const Duration(seconds: 2),
                            builder: (context, value, child) => Opacity(
                              opacity: value,
                              child: child,
                            ),
                            child: const Text(
                              "BOOKING INFORMATION",
                              style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                  letterSpacing: 1.0),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TweenAnimationBuilder(
                            tween: Tween<double>(begin: 0, end: 1),
                            duration: const Duration(seconds: 3),
                            builder: (context, value, child) => Opacity(
                              opacity: value,
                              child: child,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(children: [
                                SizedBox(
                                  height: 200,
                                  child: Column(children: [
                                    Row(
                                      children: [
                                        const Text(
                                          "Homestay:",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(utf8.decode(snapshot
                                            .data!.homestay!.name!.runes
                                            .toList()))
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          "Address:",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Flexible(
                                          child: Text(
                                            utf8.decode(snapshot
                                                .data!.homestay!.address!.runes
                                                .toList()),
                                            maxLines: 2,
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          "Booking from:",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(snapshot.data!.bookingStart!)
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          "Booking to:",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(snapshot.data!.bookingEnd!)
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          "Total reservation:",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(snapshot.data!.totalReservation
                                            .toString())
                                      ],
                                    ),
                                  ]),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Total booking price(VND):",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(currencyFormat.format(
                                        snapshot.data!.totalBookingPrice()))
                                  ],
                                )
                              ]),
                            ),
                          ),
                        ]),
                  ),
                ),
                TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: 50),
                  duration: const Duration(seconds: 1),
                  builder: (context, value, child) => SizedBox(
                    height: value,
                    child: child,
                  ),
                  child: const SizedBox(),
                ),
                TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: const Duration(seconds: 1),
                  builder: (context, value, child) => Opacity(
                    opacity: value,
                    child: child,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white24,
                        boxShadow: const [
                          BoxShadow(
                              blurRadius: 2.0,
                              blurStyle: BlurStyle.outer,
                              offset: Offset(0.5, 0.5),
                              color: Colors.black45)
                        ]),
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    child: Column(children: [
                      TweenAnimationBuilder(
                        tween: Tween<double>(begin: 0, end: 1),
                        duration: const Duration(seconds: 2),
                        builder: (context, value, child) =>
                            Opacity(opacity: value, child: child),
                        child: const Text(
                          "SERVICE LIST",
                          style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              letterSpacing: 1.0),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(children: [
                          snapshot.data!.homestayServiceList!.isNotEmpty
                              ? SizedBox(
                                  height: 100,
                                  child: ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    itemCount: snapshot
                                        .data!.homestayServiceList!.length,
                                    itemBuilder: (context, index) => Container(
                                      margin: const EdgeInsets.only(bottom: 5),
                                      child: TweenAnimationBuilder(
                                        tween: Tween<double>(begin: 0, end: 1),
                                        duration: Duration(seconds: index + 1),
                                        builder: (context, value, child) =>
                                            Opacity(
                                                opacity: value, child: child),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              TweenAnimationBuilder(
                                                tween: Tween<double>(
                                                    begin: 0, end: 1),
                                                duration:
                                                    const Duration(seconds: 3),
                                                builder:
                                                    (context, value, child) =>
                                                        Opacity(
                                                  opacity: value,
                                                  child: child,
                                                ),
                                                child: Text(
                                                  snapshot
                                                      .data!
                                                      .homestayServiceList![
                                                          index]
                                                      .name!,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 100,
                                              ),
                                              TweenAnimationBuilder(
                                                tween: Tween<double>(
                                                    begin: 0, end: 1),
                                                duration:
                                                    const Duration(seconds: 3),
                                                builder:
                                                    (context, value, child) =>
                                                        Opacity(
                                                            opacity: value,
                                                            child: child),
                                                child: Text(
                                                  "Price(VND): ${currencyFormat.format(snapshot.data!.homestayServiceList![index].price)}",
                                                  style: const TextStyle(
                                                      fontFamily: "Lobster",
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              )
                                            ]),
                                      ),
                                    ),
                                  ),
                                )
                              : TweenAnimationBuilder(
                                  tween: Tween<double>(begin: 0, end: 1),
                                  duration: const Duration(seconds: 2),
                                  builder: (context, value, child) =>
                                      Opacity(opacity: value, child: child),
                                  child: const Center(
                                      child: SizedBox(
                                          height: 100,
                                          child: Text(
                                              "You haven't choose any service"))),
                                ),
                          const SizedBox(
                            height: 10,
                          ),
                          TweenAnimationBuilder(
                            tween: Tween<double>(begin: 0, end: 1),
                            duration: const Duration(seconds: 2),
                            builder: (context, value, child) =>
                                Opacity(opacity: value, child: child),
                            child: TextButton(
                                onPressed: () {
                                  overviewBookingBloc.eventController.sink.add(
                                      EditHomestayServiceBookingEvent(
                                          conext: context,
                                          homestayServiceList:
                                              widget.homestayServiceList,
                                          homestay: widget.homestay,
                                          bookingStart: widget.bookingStart,
                                          bookingEnd: widget.bookingEnd,
                                          bookingId: widget.bookingId,
                                          totalServicePrice:
                                              widget.totalServicePrice));
                                },
                                child: const Text("Edit",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TweenAnimationBuilder(
                            tween: Tween<double>(begin: 0, end: 1),
                            duration: const Duration(seconds: 3),
                            builder: (context, value, child) =>
                                Opacity(opacity: value, child: child),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Total service price(VND): ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(currencyFormat
                                    .format(snapshot.data!.totalServicePrice))
                              ],
                            ),
                          )
                        ]),
                      )
                    ]),
                  ),
                ),
                TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: 10),
                  duration: const Duration(seconds: 1),
                  builder: (context, value, child) =>
                      SizedBox(height: value, child: child),
                  child: const SizedBox(),
                ),
                Column(
                  children: [
                    TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0, end: 1),
                      duration: const Duration(seconds: 1),
                      builder: (context, value, child) =>
                          Opacity(opacity: value, child: child),
                      child: const Text(
                        "Choose payment method: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0, end: 1),
                      duration: const Duration(seconds: 2),
                      builder: (context, value, child) =>
                          Opacity(opacity: value, child: child),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: ListTile(
                              title: const Text("SWM Wallet"),
                              leading: Radio<PaymentMethod>(
                                value: PaymentMethod.swm_wallet,
                                groupValue: snapshot.data!.paymentMethod!,
                                onChanged: (value) => overviewBookingBloc
                                    .eventController.sink
                                    .add(ChoosePaymentMethodEvent(
                                        paymentMethod: value)),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            flex: 1,
                            child: ListTile(
                              title: const Text("Cash"),
                              leading: Radio<PaymentMethod>(
                                value: PaymentMethod.cash,
                                groupValue: snapshot.data!.paymentMethod!,
                                onChanged: (value) => overviewBookingBloc
                                    .eventController.sink
                                    .add(ChoosePaymentMethodEvent(
                                        paymentMethod: value)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: 20),
                  duration: const Duration(seconds: 1),
                  builder: (context, value, child) =>
                      SizedBox(height: value, child: child),
                  child: const SizedBox(),
                ),
                TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: const Duration(seconds: 1),
                  builder: (context, value, child) =>
                      Opacity(opacity: value, child: child),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            minimumSize: const Size(200, 50),
                            maximumSize: const Size(200, 50)),
                        onPressed: () {
                          overviewBookingBloc.eventController.sink.add(
                              SaveBookingHomestayEvent(
                                  bookingHomestay:
                                      snapshot.data!.bookingHomestayModel(),
                                  bookingStart: widget.bookingStart,
                                  bookingEnd: widget.bookingEnd,
                                  bookingId: widget.bookingId,
                                  context: context));
                        },
                        child: const Text(
                          "Proceed",
                          style: TextStyle(
                              fontFamily: "Lobster",
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        )),
                  ),
                )
              ],
            ),
          );
        });
  }
}
