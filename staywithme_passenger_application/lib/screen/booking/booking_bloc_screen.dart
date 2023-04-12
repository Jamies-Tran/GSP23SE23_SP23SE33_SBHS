import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_advanced_avatar/flutter_advanced_avatar.dart';
import 'package:staywithme_passenger_application/bloc/booking_bloc_homestay_bloc.dart';
import 'package:staywithme_passenger_application/bloc/choose_bloc_service_bloc.dart';
import 'package:staywithme_passenger_application/bloc/choose_homestay_bloc.dart';
import 'package:staywithme_passenger_application/bloc/event/choose_homestay_event.dart';
import 'package:staywithme_passenger_application/bloc/event/overview_bloc_booking_event.dart';
import 'package:staywithme_passenger_application/bloc/event/view_bloc_facility_event.dart';
import 'package:staywithme_passenger_application/bloc/event/view_bloc_rule_event.dart';
import 'package:staywithme_passenger_application/bloc/state/booking_bloc_state.dart';
import 'package:staywithme_passenger_application/bloc/state/choose_bloc_service_state.dart';
import 'package:staywithme_passenger_application/bloc/state/choose_homestay_state.dart';
import 'package:staywithme_passenger_application/bloc/state/overview_bloc_booking_state.dart';
import 'package:staywithme_passenger_application/bloc/state/view_bloc_facility_state.dart';
import 'package:staywithme_passenger_application/bloc/view_bloc_facility_bloc.dart';
import 'package:staywithme_passenger_application/bloc/view_bloc_rule_bloc.dart';
import 'package:staywithme_passenger_application/global_variable.dart';
import 'package:staywithme_passenger_application/model/bloc_model.dart';
import 'package:staywithme_passenger_application/model/booking_model.dart';
import 'package:staywithme_passenger_application/model/homestay_model.dart';
import 'package:staywithme_passenger_application/service/image_service.dart';
import 'package:staywithme_passenger_application/service_locator/service_locator.dart';

import '../../bloc/event/choose_bloc_service_event.dart';
import '../../bloc/overview_bloc_booking_bloc.dart';

class BookingBlocScreen extends StatefulWidget {
  const BookingBlocScreen({super.key});
  static const bookingBlocScreenRoute = "/booking-bloc";

  @override
  State<BookingBlocScreen> createState() => _BookingBlocScreenState();
}

class _BookingBlocScreenState extends State<BookingBlocScreen> {
  final bookingBlocHomestayBloc = BookingBlocHomestayBloc();
  List<Widget> widgetList(
      BlocHomestayModel bloc,
      int bookingId,
      String? bookingStart,
      String? bookingEnd,
      BlocBookingDateValidationModel? blocBookingValidation,
      List<BookingBlocModel> bookingBlocList,
      List<HomestayServiceModel> blocServiceList,
      int? totalHomestayPrice,
      int? totalServicePrice,
      bool? overviewFlag) {
    return <Widget>[
      ViewBlocHomestayFacilityScreen(
        bookingStart: bookingStart,
        bookingEnd: bookingEnd,
        bloc: bloc,
        blocBookingValidation: blocBookingValidation,
        blocServiceList: blocServiceList,
        bookingBlocList: bookingBlocList,
        bookingId: bookingId,
        totalHomestayPrice: totalHomestayPrice,
        totalServicePrice: totalServicePrice,
      ),
      ViewBlocHomestayRuleScreen(
        bookingStart: bookingStart,
        bookingEnd: bookingEnd,
        bloc: bloc,
        blocBookingValidation: blocBookingValidation,
        bookingBlocList: bookingBlocList,
        blocServiceList: blocServiceList,
        bookingId: bookingId,
        totalHomestayPrice: totalHomestayPrice,
        totalServicePrice: totalServicePrice,
      ),
      ChooseHomestayScreen(
        bloc: bloc,
        bookingId: bookingId,
        bookingStart: bookingStart,
        bookingEnd: bookingEnd,
        blocBookingDateValidation: blocBookingValidation,
        blocServiceList: blocServiceList,
        overviewFlag: overviewFlag,
        totalServicePrice: totalServicePrice,
        bookingBlocList: bookingBlocList,
      ),
      ChooseBlocServiceScreen(
        bookingStart: bookingStart,
        bookingEnd: bookingEnd,
        blocServiceList: bloc.homestayServices,
        bloc: bloc,
        bookingBlocList: bookingBlocList,
        bookingId: bookingId,
        totalHomestayPrice: totalHomestayPrice,
        blocBookingDateValidation: blocBookingValidation,
      ),
      OverviewBlocBookingScreen(
        bookingStart: bookingStart,
        bookingEnd: bookingEnd,
        bloc: bloc,
        bookingBlocList: bookingBlocList,
        blocServiceList: blocServiceList,
        bookingId: bookingId,
        totalHomestayPrice: totalHomestayPrice,
        totalServicePrice: totalServicePrice,
        blocBookingValidation: blocBookingValidation,
      )
    ];
  }

  @override
  void dispose() {
    bookingBlocHomestayBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BookingBlocHomestayState>(
        stream: bookingBlocHomestayBloc.stateController.stream,
        initialData: bookingBlocHomestayBloc.initData(context),
        builder: (context, snapshot) {
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
                        icon: Icon(Icons.house),
                        label: "Homestays",
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
                  currentIndex: snapshot.data!.selectedIndex!,
                  selectedItemColor: Colors.black,
                  selectedLabelStyle: const TextStyle(
                      fontFamily: "Lobster", fontWeight: FontWeight.bold),
                  showUnselectedLabels: false,
                ),
              ),
              body: widgetList(
                  snapshot.data!.bloc!,
                  snapshot.data!.bookingId!,
                  snapshot.data!.bookingStart,
                  snapshot.data!.bookingEnd,
                  snapshot.data!.blocBookingDateValidation,
                  snapshot.data!.bookingBlocList!,
                  snapshot.data!.blocServiceList!,
                  snapshot.data!.totalHomestayPrice,
                  snapshot.data!.totalServicePrice,
                  snapshot.data!.overviewFlag)[snapshot.data!.selectedIndex!],
            ),
          );
        });
  }
}

class ChooseHomestayScreen extends StatefulWidget {
  const ChooseHomestayScreen(
      {super.key,
      this.bloc,
      this.bookingId,
      this.bookingStart,
      this.bookingEnd,
      this.blocBookingDateValidation,
      this.overviewFlag = false,
      this.blocServiceList = const <HomestayServiceModel>[],
      this.totalServicePrice = 0,
      this.bookingBlocList});
  final BlocHomestayModel? bloc;
  final int? bookingId;
  final String? bookingStart;
  final String? bookingEnd;
  final BlocBookingDateValidationModel? blocBookingDateValidation;
  final bool? overviewFlag;
  final int? totalServicePrice;
  final List<HomestayServiceModel>? blocServiceList;
  final List<BookingBlocModel>? bookingBlocList;

  @override
  State<ChooseHomestayScreen> createState() => _ChooseHomestayScreenState();
}

class _ChooseHomestayScreenState extends State<ChooseHomestayScreen> {
  final chooseHomestayBloc = ChooseHomestayBloc();
  final imageService = locator.get<IImageService>();

  @override
  void dispose() {
    chooseHomestayBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<HomestayModel> homestays =
        widget.blocBookingDateValidation!.homestays!;
    return StreamBuilder<ChooseHomestayState>(
      stream: chooseHomestayBloc.stateController.stream,
      initialData: chooseHomestayBloc.initData(widget.bookingBlocList),
      builder: (context, snapshot) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: 20),
              duration: const Duration(seconds: 3),
              builder: (context, value, child) => SizedBox(
                height: value,
                child: child,
              ),
              child: const SizedBox(),
            ),
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: 1),
              duration: const Duration(seconds: 2),
              builder: (context, value, child) => Opacity(
                opacity: value,
                child: child,
              ),
              child: const Text(
                "Choose Homestays In Block",
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: primaryColor),
              ),
            ),
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: 20),
              duration: const Duration(seconds: 3),
              builder: (context, value, child) => SizedBox(
                height: value,
                child: child,
              ),
              child: const SizedBox(),
            ),
            SizedBox(
              height: 500,
              child: ListView.builder(
                itemCount: homestays.length,
                itemBuilder: (context, index) {
                  BookingBlocModel bookingBloc = BookingBlocModel(
                      homestayName: homestays[index].name,
                      totalBookingPrice: homestays[index].price);
                  return TweenAnimationBuilder(
                    tween: Tween<double>(begin: 0, end: 1),
                    duration: Duration(seconds: index + 2),
                    builder: (context, value, child) => Opacity(
                      opacity: value,
                      child: child,
                    ),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            chooseHomestayBloc.eventController.sink.add(
                                OnChooseHomestayEvent(
                                    bookingBloc: bookingBloc));
                          },
                          child: TweenAnimationBuilder(
                            tween: Tween<double>(begin: 0, end: 10),
                            duration: const Duration(seconds: 2),
                            builder: (context, value, child) => Container(
                              margin: EdgeInsets.only(bottom: value),
                              child: child,
                            ),
                            child: Container(
                              // margin: const EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20)),
                                  color: snapshot.data!.isHomestaySelected(
                                          homestays[index].name!)
                                      ? primaryColor
                                      : Colors.grey),
                              child: Row(children: [
                                FutureBuilder(
                                  future: imageService.getHomestayImage(
                                      homestays[index]
                                          .homestayImages!
                                          .first
                                          .imageUrl!),
                                  builder: (context, snapshot) {
                                    switch (snapshot.connectionState) {
                                      case ConnectionState.waiting:
                                        return const AdvancedAvatar(
                                          child: SizedBox(),
                                        );
                                      case ConnectionState.done:
                                        final imageUrl = snapshot.data ??
                                            "https://i.ytimg.com/vi/0jDUx3jOBfU/mqdefault.jpg";
                                        return AdvancedAvatar(
                                          image: NetworkImage(imageUrl),
                                        );

                                      default:
                                        break;
                                    }
                                    return const SizedBox();
                                  },
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      "Name: ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      utf8.decode(homestays[index]
                                          .name!
                                          .runes
                                          .toList()),
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Price: ",
                                      style: TextStyle(
                                          fontFamily: "Lobster",
                                          fontWeight: FontWeight.bold,
                                          color: snapshot.data!
                                                  .isHomestaySelected(
                                                      homestays[index].name!)
                                              ? Colors.white
                                              : primaryColor),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      currencyFormat
                                          .format(homestays[index].price),
                                      style: const TextStyle(
                                          fontFamily: "Lobster"),
                                    )
                                  ],
                                )
                              ]),
                            ),
                          ),
                        ),
                        snapshot.data!
                                .isHomestaySelected(homestays[index].name!)
                            ? GestureDetector(
                                onTap: () {
                                  chooseHomestayBloc.eventController.sink.add(
                                      OnShowHomestayDetailEvent(
                                          context: context,
                                          homestayName: homestays[index].name));
                                },
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(
                                        Icons.remove_red_eye,
                                        size: 20,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "View",
                                        style: TextStyle(
                                            fontFamily: "Lobster",
                                            fontWeight: FontWeight.bold),
                                      )
                                    ]),
                              )
                            : const SizedBox()
                      ],
                    ),
                  );
                },
              ),
            ),
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: 20),
              duration: const Duration(seconds: 2),
              builder: (context, value, child) => SizedBox(
                height: value,
                child: child,
              ),
              child: const SizedBox(),
            ),
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: 1),
              duration: const Duration(seconds: 3),
              builder: (context, value, child) => Opacity(
                opacity: value,
                child: child,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Total Price(VND):",
                    style: TextStyle(
                        fontFamily: "Lobster",
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    currencyFormat.format(snapshot.data!.totalHomestayPrice()),
                    style: const TextStyle(fontFamily: "Lobster"),
                  )
                ],
              ),
            ),
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: 1),
              duration: const Duration(seconds: 3),
              builder: (context, value, child) => Opacity(
                opacity: value,
                child: child,
              ),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: snapshot.data!.bookingBlocList.isNotEmpty
                          ? primaryColor
                          : Colors.grey,
                      maximumSize: const Size(200, 50),
                      minimumSize: const Size(200, 50)),
                  onPressed: () {
                    if (snapshot.data!.bookingBlocList.isNotEmpty) {
                      chooseHomestayBloc.eventController.sink.add(
                          OnNextStepToChooseServiceEvent(
                              bloc: widget.bloc,
                              blocBookingValidation:
                                  widget.blocBookingDateValidation,
                              bookingStart: widget.bookingStart,
                              bookingEnd: widget.bookingEnd,
                              bookingBlocList: snapshot.data!.bookingBlocList,
                              blocServiceList: widget.blocServiceList,
                              totalServicePrice: widget.totalServicePrice,
                              bookingId: widget.bookingId,
                              context: context,
                              totalHomestayPrice:
                                  snapshot.data!.totalHomestayPrice(),
                              overviewFlag: widget.overviewFlag));
                    }
                  },
                  child: Text(
                    widget.overviewFlag == false ? "Next" : "Ok",
                    style: const TextStyle(
                        fontFamily: "Lobster",
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  )),
            )
          ],
        );
      },
    );
  }
}

class ChooseBlocServiceScreen extends StatefulWidget {
  const ChooseBlocServiceScreen(
      {super.key,
      this.bookingStart,
      this.bookingEnd,
      this.blocBookingDateValidation,
      this.bookingBlocList,
      this.blocServiceList,
      this.bloc,
      this.bookingId,
      this.totalHomestayPrice});
  final String? bookingStart;
  final String? bookingEnd;
  final BlocBookingDateValidationModel? blocBookingDateValidation;
  final List<BookingBlocModel>? bookingBlocList;
  final List<HomestayServiceModel>? blocServiceList;
  final BlocHomestayModel? bloc;
  final int? bookingId;
  final int? totalHomestayPrice;

  @override
  State<ChooseBlocServiceScreen> createState() =>
      _ChooseBlocServiceScreenState();
}

class _ChooseBlocServiceScreenState extends State<ChooseBlocServiceScreen> {
  final chooseBlocServiceBloc = ChooseBlocServiceBloc();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ChooseBlocServiceState>(
      stream: chooseBlocServiceBloc.stateController.stream,
      initialData: chooseBlocServiceBloc.initData(widget.blocServiceList),
      builder: (context, snapshot) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: 20),
              duration: const Duration(seconds: 3),
              builder: (context, value, child) => SizedBox(
                height: value,
                child: child,
              ),
              child: const SizedBox(),
            ),
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: 1),
              duration: const Duration(seconds: 2),
              builder: (context, value, child) => Opacity(
                opacity: value,
                child: child,
              ),
              child: const Text(
                "Choose Block Service",
                style: TextStyle(
                    fontSize: 25,
                    color: primaryColor,
                    fontWeight: FontWeight.bold),
              ),
            ),
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: 20),
              duration: const Duration(seconds: 3),
              builder: (context, value, child) => SizedBox(
                height: value,
                child: child,
              ),
              child: const SizedBox(
                height: 20,
              ),
            ),
            SizedBox(
              height: 450,
              child: ListView.builder(
                itemCount: widget.blocServiceList!.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      chooseBlocServiceBloc.eventController.sink.add(
                          OnChooseServiceEvent(
                              homestayServiceModel:
                                  widget.blocServiceList![index]));
                    },
                    child: TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0, end: 1),
                      duration: const Duration(seconds: 2),
                      builder: (context, value, child) => Opacity(
                        opacity: value,
                        child: child,
                      ),
                      child: TweenAnimationBuilder(
                        tween: Tween<double>(begin: 0, end: 10),
                        duration: const Duration(seconds: 3),
                        builder: (context, value, child) => Container(
                          margin: EdgeInsets.only(bottom: value),
                          child: child,
                        ),
                        child: Container(
                          height: 100,
                          // margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                              color: snapshot.data!.isHomestayServiceSelected(
                                      widget.blocServiceList![index].name!)
                                  ? primaryColor
                                  : Colors.grey),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                widget.blocServiceList![index].name!,
                                style: const TextStyle(
                                    fontFamily: "Lobster",
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                width: 100,
                              ),
                              Row(
                                children: [
                                  const Text(
                                    "Price(VND):",
                                    style: TextStyle(
                                        fontFamily: "Lobster",
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    currencyFormat.format(
                                        widget.blocServiceList![index].price),
                                    style:
                                        const TextStyle(fontFamily: "Lobster"),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Total Service Price(VND):",
                  style: TextStyle(
                      fontFamily: "Lobster",
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  currencyFormat.format(snapshot.data!.totalServicePrice()),
                  style: const TextStyle(fontFamily: "Lobster"),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Total Homestay Price(VND):",
                  style: TextStyle(
                      fontFamily: "Lobster",
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  currencyFormat.format(widget.totalHomestayPrice),
                  style: const TextStyle(fontFamily: "Lobster"),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    maximumSize: const Size(200, 50),
                    minimumSize: const Size(200, 50)),
                onPressed: () {
                  chooseBlocServiceBloc.eventController.sink.add(
                      OnNextStepToOviewBlocBookingEvent(
                          bloc: widget.bloc,
                          blocBookingValidation:
                              widget.blocBookingDateValidation,
                          bookingStart: widget.bookingStart,
                          bookingEnd: widget.bookingEnd,
                          blocServiceList: snapshot.data!.homestayServiceList,
                          bookingBlocList: widget.bookingBlocList,
                          bookingId: widget.bookingId,
                          context: context,
                          totalHomestayPrice: widget.totalHomestayPrice,
                          totalServicePrice:
                              snapshot.data!.totalServicePrice()));
                },
                child: Text(
                  snapshot.data!.overviewFlag == true ? "Next" : "Ok",
                  style: const TextStyle(
                      fontFamily: "Lobster",
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                )),
          ],
        );
      },
    );
  }
}

class ViewBlocHomestayFacilityScreen extends StatefulWidget {
  const ViewBlocHomestayFacilityScreen(
      {super.key,
      this.bookingStart,
      this.bookingEnd,
      this.blocBookingValidation,
      this.bookingBlocList,
      this.blocServiceList,
      this.bloc,
      this.bookingId,
      this.totalHomestayPrice,
      this.totalServicePrice});
  final String? bookingStart;
  final String? bookingEnd;
  final BlocBookingDateValidationModel? blocBookingValidation;
  final List<BookingBlocModel>? bookingBlocList;
  final List<HomestayServiceModel>? blocServiceList;
  final BlocHomestayModel? bloc;
  final int? bookingId;
  final int? totalHomestayPrice;
  final int? totalServicePrice;

  @override
  State<ViewBlocHomestayFacilityScreen> createState() =>
      _ViewBlocHomestayFacilityScreenState();
}

class _ViewBlocHomestayFacilityScreenState
    extends State<ViewBlocHomestayFacilityScreen> {
  final viewHomestayInBlocFacilityBloc = ViewHomestayInBlocFacilityBloc();

  @override
  void dispose() {
    viewHomestayInBlocFacilityBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ViewHomestayInBlocFacilityState>(
        stream: viewHomestayInBlocFacilityBloc.stateController.stream,
        initialData: viewHomestayInBlocFacilityBloc.initData(),
        builder: (context, snapshot) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: 20),
                duration: const Duration(seconds: 3),
                builder: (context, value, child) => SizedBox(
                  height: value,
                  child: child,
                ),
                child: const SizedBox(),
              ),
              TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: 1),
                duration: const Duration(seconds: 2),
                builder: (context, value, child) => Opacity(
                  opacity: value,
                  child: child,
                ),
                child: const Text(
                  "View Block Facility List",
                  style: TextStyle(
                      fontSize: 25,
                      color: primaryColor,
                      fontWeight: FontWeight.bold),
                ),
              ),
              TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: 20),
                duration: const Duration(seconds: 3),
                builder: (context, value, child) => SizedBox(
                  height: 20,
                  child: child,
                ),
                child: const SizedBox(),
              ),
              TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: 1),
                duration: const Duration(seconds: 2),
                builder: (context, value, child) => Opacity(
                  opacity: value,
                  child: child,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: () {
                          viewHomestayInBlocFacilityBloc.eventController.sink
                              .add(SelectHomestayInBlocEvent(
                                  currentIndex: snapshot.data!.selectedIndex,
                                  isNext: false,
                                  totalHomestays:
                                      widget.bloc!.homestays!.length - 1));
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: primaryColor,
                        )),
                    Text(
                      widget.bloc!.homestays![snapshot.data!.selectedIndex!]
                          .name!,
                      style: const TextStyle(
                          fontFamily: "Lobster",
                          fontWeight: FontWeight.bold,
                          color: Colors.black45),
                    ),
                    IconButton(
                        onPressed: () {
                          viewHomestayInBlocFacilityBloc.eventController.sink
                              .add(SelectHomestayInBlocEvent(
                                  currentIndex: snapshot.data!.selectedIndex,
                                  isNext: true,
                                  totalHomestays:
                                      widget.bloc!.homestays!.length - 1));
                        },
                        icon: const Icon(
                          Icons.arrow_forward_ios,
                          color: primaryColor,
                        )),
                  ],
                ),
              ),
              TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: 10),
                duration: const Duration(seconds: 3),
                builder: (context, value, child) => SizedBox(
                  height: value,
                  child: child,
                ),
                child: const SizedBox(),
              ),
              SizedBox(
                height: 500,
                child: ListView.builder(
                    itemCount: widget
                        .bloc!
                        .homestays![snapshot.data!.selectedIndex!]
                        .homestayFacilities!
                        .length,
                    itemBuilder: (context, index) {
                      final facilityList = widget
                          .bloc!
                          .homestays![snapshot.data!.selectedIndex!]
                          .homestayFacilities;
                      return TweenAnimationBuilder(
                        tween: Tween<double>(begin: 0, end: 1),
                        duration: Duration(seconds: index + 2),
                        builder: (context, value, child) => Opacity(
                          opacity: value,
                          child: child,
                        ),
                        child: TweenAnimationBuilder(
                          tween: Tween<double>(begin: 0, end: 10),
                          duration: const Duration(seconds: 3),
                          builder: (context, value, child) => Container(
                            margin: EdgeInsets.only(bottom: value),
                            child: child,
                          ),
                          child: Container(
                            height: 100,
                            // margin: const EdgeInsets.only(bottom: 10),
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                color: Colors.white,
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      blurRadius: 2.0,
                                      blurStyle: BlurStyle.outer,
                                      offset: Offset(1.0, 1.0)),
                                ]),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    facilityList![index].name!,
                                    style: const TextStyle(
                                        fontFamily: "Lobster",
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    width: 100,
                                  ),
                                  Text(
                                    "Quanity: ${facilityList[index].quantity}",
                                    style: const TextStyle(
                                        fontFamily: "Lobster",
                                        fontWeight: FontWeight.bold),
                                  )
                                ]),
                          ),
                        ),
                      );
                    }),
              ),
              TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: 20),
                duration: const Duration(seconds: 3),
                builder: (context, value, child) =>
                    SizedBox(height: value, child: child),
                child: const SizedBox(),
              ),
              TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: 1),
                duration: const Duration(seconds: 2),
                builder: (context, value, child) => Opacity(
                  opacity: value,
                  child: child,
                ),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        maximumSize: const Size(200, 50),
                        minimumSize: const Size(200, 50)),
                    onPressed: () {
                      viewHomestayInBlocFacilityBloc.eventController.sink.add(
                          OnNextStepToBlocRuleEvent(
                              context: context,
                              bookingStart: widget.bookingStart,
                              bookingEnd: widget.bookingEnd,
                              bloc: widget.bloc,
                              blocBookingvalidation:
                                  widget.blocBookingValidation,
                              blocServiceList: widget.blocServiceList,
                              bookingBlocList: widget.bookingBlocList,
                              bookingId: widget.bookingId,
                              totalHomestayPrice: widget.totalHomestayPrice,
                              totalServicePrice: widget.totalServicePrice));
                    },
                    child: const Text(
                      "Next",
                      style: TextStyle(
                          fontFamily: "Lobster",
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    )),
              )
            ],
          );
        });
  }
}

class ViewBlocHomestayRuleScreen extends StatefulWidget {
  const ViewBlocHomestayRuleScreen(
      {super.key,
      this.bookingStart,
      this.bookingEnd,
      this.bloc,
      this.blocBookingValidation,
      this.bookingBlocList,
      this.blocServiceList,
      this.bookingId,
      this.totalHomestayPrice,
      this.totalServicePrice});
  final String? bookingStart;
  final String? bookingEnd;
  final BlocHomestayModel? bloc;
  final BlocBookingDateValidationModel? blocBookingValidation;
  final List<BookingBlocModel>? bookingBlocList;
  final List<HomestayServiceModel>? blocServiceList;
  final int? bookingId;
  final int? totalHomestayPrice;
  final int? totalServicePrice;

  @override
  State<ViewBlocHomestayRuleScreen> createState() =>
      _ViewBlocHomestayRuleScreenState();
}

class _ViewBlocHomestayRuleScreenState
    extends State<ViewBlocHomestayRuleScreen> {
  final viewBlocHomestayRuleBloc = ViewBlocHomestayRuleBloc();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: 20),
          duration: const Duration(seconds: 3),
          builder: (context, value, child) => SizedBox(
            height: value,
            child: child,
          ),
          child: const SizedBox(),
        ),
        TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: 1),
          duration: const Duration(seconds: 2),
          builder: (context, value, child) => Opacity(
            opacity: value,
            child: child,
          ),
          child: const Text(
            "View Block Homestay Rules",
            style: TextStyle(
                fontSize: 25, fontWeight: FontWeight.bold, color: primaryColor),
          ),
        ),
        TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: 20),
          duration: const Duration(seconds: 3),
          builder: (context, value, child) => SizedBox(
            height: value,
            child: child,
          ),
          child: const SizedBox(),
        ),
        SizedBox(
          height: 500,
          child: ListView.builder(
            itemCount: widget.bloc!.homestayRules!.length,
            itemBuilder: (context, index) => TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: 1),
              duration: Duration(seconds: index + 2),
              builder: (context, value, child) => Opacity(
                opacity: value,
                child: child,
              ),
              child: Container(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Colors.white),
                child: TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: 10),
                  duration: const Duration(seconds: 3),
                  builder: (context, value, child) => Container(
                    margin: EdgeInsets.only(bottom: value, left: 10, right: 10),
                    child: child,
                  ),
                  child: Container(
                    height: 50,
                    // margin:
                    //     const EdgeInsets.only(bottom: 10, left: 10, right: 10),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Colors.white,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              blurRadius: 2.0,
                              blurStyle: BlurStyle.outer,
                              offset: Offset(1.0, 1.0)),
                        ]),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${index + 1}",
                            style: const TextStyle(
                                fontFamily: "Lobster",
                                fontWeight: FontWeight.bold,
                                color: primaryColor),
                          ),
                          const SizedBox(
                            width: 100,
                          ),
                          Text(
                            widget.bloc!.homestayRules![index].description!,
                            style: const TextStyle(
                                fontFamily: "Lobster",
                                fontWeight: FontWeight.bold),
                          )
                        ]),
                  ),
                ),
              ),
            ),
          ),
        ),
        TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: 20),
          duration: const Duration(seconds: 3),
          builder: (context, value, child) => SizedBox(
            height: value,
            child: child,
          ),
          child: const SizedBox(),
        ),
        TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: 1),
          duration: const Duration(seconds: 2),
          builder: (context, value, child) => Opacity(
            opacity: value,
            child: child,
          ),
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  maximumSize: const Size(200, 50),
                  minimumSize: const Size(200, 50)),
              onPressed: () {
                viewBlocHomestayRuleBloc.eventController.sink.add(
                    OnNextStepToChooseHomestayInBlocEvent(
                        bloc: widget.bloc,
                        blocBookingValidation: widget.blocBookingValidation,
                        blocServiceList: widget.blocServiceList,
                        bookingBlocList: widget.bookingBlocList,
                        bookingStart: widget.bookingStart,
                        bookingEnd: widget.bookingEnd,
                        bookingId: widget.bookingId,
                        context: context,
                        totalHomestayPrice: widget.totalHomestayPrice,
                        totalServicePrice: widget.totalServicePrice));
              },
              child: const Text(
                "Next",
                style: TextStyle(
                    fontFamily: "Lobster",
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              )),
        )
      ],
    );
  }
}

class OverviewBlocBookingScreen extends StatefulWidget {
  const OverviewBlocBookingScreen(
      {super.key,
      this.bookingStart,
      this.bookingEnd,
      this.bloc,
      this.blocBookingValidation,
      this.bookingBlocList,
      this.blocServiceList,
      this.bookingId,
      this.totalHomestayPrice,
      this.totalServicePrice});
  final String? bookingStart;
  final String? bookingEnd;
  final List<BookingBlocModel>? bookingBlocList;
  final List<HomestayServiceModel>? blocServiceList;
  final BlocBookingDateValidationModel? blocBookingValidation;
  final BlocHomestayModel? bloc;
  final int? bookingId;
  final int? totalHomestayPrice;
  final int? totalServicePrice;

  @override
  State<OverviewBlocBookingScreen> createState() =>
      _OverviewBlocBookingScreenState();
}

class _OverviewBlocBookingScreenState extends State<OverviewBlocBookingScreen> {
  final overviewBookingBloc = OverviewBookingBlocHomestayBloc();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<OverviewBookingBlocState>(
        stream: overviewBookingBloc.stateController.stream,
        initialData: overviewBookingBloc.initData(
            widget.bookingStart!,
            widget.bookingEnd!,
            widget.bloc!,
            widget.bookingBlocList!,
            widget.blocServiceList!,
            widget.bookingId!,
            widget.totalHomestayPrice!,
            widget.totalServicePrice!),
        builder: (context, snapshot) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: 20),
                  duration: const Duration(seconds: 3),
                  builder: (context, value, child) => SizedBox(
                    height: value,
                    child: child,
                  ),
                  child: const SizedBox(),
                ),
                TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: const Duration(seconds: 2),
                  builder: (context, value, child) =>
                      Opacity(opacity: value, child: child),
                  child: const Text(
                    "Overview Your Block Booking",
                    style: TextStyle(
                        fontSize: 25,
                        color: primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: 20),
                  duration: const Duration(seconds: 3),
                  builder: (context, value, child) => SizedBox(
                    height: value,
                    child: child,
                  ),
                  child: const SizedBox(),
                ),
                TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: const Duration(seconds: 2),
                  builder: (context, value, child) =>
                      Opacity(opacity: value, child: child),
                  child: Container(
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              blurRadius: 2.0,
                              blurStyle: BlurStyle.outer,
                              offset: Offset(1.0, 1.0))
                        ]),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "BOOKING INFORMATION",
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(children: [
                              Row(
                                children: [
                                  const Text(
                                    "Block Homestay:",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(utf8.decode(
                                      widget.bloc!.name!.runes.toList()))
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  const Text(
                                    "Address:",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Flexible(
                                      child: Text(
                                    utf8.decode(
                                        widget.bloc!.address!.runes.toList()),
                                    maxLines: 2,
                                  ))
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  const Text(
                                    "Booking from:",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(widget.bookingStart!),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  const Text(
                                    "Booking to:",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(widget.bookingEnd!),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  const Text(
                                    "Total homestays:",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(widget.bookingBlocList!.length
                                      .toString()),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      overviewBookingBloc.eventController.sink
                                          .add(EditHomestayInBlocEvent(
                                              bloc: widget.bloc,
                                              blocBookingValidation:
                                                  widget.blocBookingValidation,
                                              blocServiceList:
                                                  widget.blocServiceList,
                                              bookingBlocList:
                                                  widget.bookingBlocList,
                                              bookingStart: widget.bookingStart,
                                              bookingEnd: widget.bookingEnd,
                                              bookingId: widget.bookingId,
                                              context: context,
                                              overviewFlag: true,
                                              totalHomestayPrice:
                                                  widget.totalHomestayPrice,
                                              totalServicePrice:
                                                  widget.totalServicePrice));
                                    },
                                    child: const Text("Edit"),
                                  )
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
                                "Total Homestay Price(VND):",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(currencyFormat
                                  .format(snapshot.data!.totalBookingPrice())),
                            ],
                          )
                        ]),
                  ),
                ),
                TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: 15),
                  duration: const Duration(seconds: 3),
                  builder: (context, value, child) => SizedBox(
                    height: value,
                    child: child,
                  ),
                  child: const SizedBox(),
                ),
                TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: const Duration(seconds: 2),
                  builder: (context, value, child) =>
                      Opacity(opacity: value, child: child),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                blurRadius: 2.0,
                                blurStyle: BlurStyle.outer,
                                offset: Offset(1.0, 1.0))
                          ]),
                      child: Column(children: [
                        const Text("SERVICE LIST",
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                        const SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              snapshot.data!.blocServiceList!.isNotEmpty
                                  ? SizedBox(
                                      height: 100,
                                      child: ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        itemCount: snapshot
                                            .data!.blocServiceList!.length,
                                        itemBuilder: (context, index) =>
                                            Container(
                                          margin:
                                              const EdgeInsets.only(bottom: 5),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  utf8.decode(snapshot
                                                      .data!
                                                      .blocServiceList![index]
                                                      .name!
                                                      .runes
                                                      .toList()),
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const SizedBox(
                                                  width: 100,
                                                ),
                                                TweenAnimationBuilder(
                                                  tween: Tween<double>(
                                                      begin: 0, end: 1),
                                                  duration: const Duration(
                                                      seconds: 3),
                                                  builder:
                                                      (context, value, child) =>
                                                          Opacity(
                                                              opacity: value,
                                                              child: child),
                                                  child: Text(
                                                    "Price(VND): ${currencyFormat.format(snapshot.data!.blocServiceList![index].price)}",
                                                    style: const TextStyle(
                                                        fontFamily: "Lobster",
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                )
                                              ]),
                                        ),
                                      ),
                                    )
                                  : const Center(
                                      child: SizedBox(
                                          height: 100,
                                          child: Text(
                                              "You haven't choose any service"))),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextButton(
                            onPressed: () {
                              overviewBookingBloc.eventController.sink.add(
                                  EditBlocServiceListEvent(
                                      bloc: widget.bloc,
                                      blocBookingValidation:
                                          widget.blocBookingValidation,
                                      blocServiceList: widget.blocServiceList,
                                      bookingBlocList: widget.bookingBlocList,
                                      bookingStart: widget.bookingStart,
                                      bookingEnd: widget.bookingEnd,
                                      bookingId: widget.bookingId,
                                      context: context,
                                      totalHomestayPrice:
                                          widget.totalHomestayPrice,
                                      overviewFlag: true,
                                      totalServicePrice:
                                          widget.totalServicePrice));
                            },
                            child: const Text("Edit")),
                        const SizedBox(),
                        Row(
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
                        )
                      ]),
                    ),
                  ),
                ),
                TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: 5),
                  duration: const Duration(seconds: 3),
                  builder: (context, value, child) => SizedBox(
                    height: value,
                    child: child,
                  ),
                  child: const SizedBox(),
                ),
                Column(
                  children: [
                    // TweenAnimationBuilder(
                    //   tween: Tween<double>(begin: 0, end: 1),
                    //   duration: const Duration(seconds: 2),
                    //   builder: (context, value, child) =>
                    //       Opacity(opacity: value, child: child),
                    //   child: const Text(
                    //     "Choose payment method: ",
                    //     style: TextStyle(fontWeight: FontWeight.bold),
                    //   ),
                    // ),
                    // TweenAnimationBuilder(
                    //   tween: Tween<double>(begin: 0, end: 10),
                    //   duration: const Duration(seconds: 3),
                    //   builder: (context, value, child) => SizedBox(
                    //     height: value,
                    //     child: child,
                    //   ),
                    //   child: const SizedBox(),
                    // ),
                    // TweenAnimationBuilder(
                    //   tween: Tween<double>(begin: 0, end: 1),
                    //   duration: const Duration(seconds: 2),
                    //   builder: (context, value, child) =>
                    //       Opacity(opacity: value, child: child),
                    //   child: Row(
                    //     children: [
                    //       Expanded(
                    //         flex: 1,
                    //         child: ListTile(
                    //           title: const Text("SWM Wallet"),
                    //           leading: Radio<BlocPaymentMethod>(
                    //             value: BlocPaymentMethod.swm_wallet,
                    //             groupValue: snapshot.data!.paymentMethod!,
                    //             onChanged: (value) => overviewBookingBloc
                    //                 .eventController.sink
                    //                 .add(ChooseBlocPaymentMethodEvent(
                    //                     paymentMethod: value)),
                    //           ),
                    //         ),
                    //       ),
                    //       const SizedBox(
                    //         width: 10,
                    //       ),
                    //       Expanded(
                    //         flex: 1,
                    //         child: ListTile(
                    //           title: const Text("Cash"),
                    //           leading: Radio<BlocPaymentMethod>(
                    //             value: BlocPaymentMethod.cash,
                    //             groupValue: snapshot.data!.paymentMethod!,
                    //             onChanged: (value) => overviewBookingBloc
                    //                 .eventController.sink
                    //                 .add(ChooseBlocPaymentMethodEvent(
                    //                     paymentMethod: value)),
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0, end: 5),
                      duration: const Duration(seconds: 3),
                      builder: (context, value, child) => SizedBox(
                        height: value,
                        child: child,
                      ),
                      child: const SizedBox(),
                    ),
                    TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0, end: 1),
                      duration: const Duration(seconds: 2),
                      builder: (context, value, child) =>
                          Opacity(opacity: value, child: child),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              maximumSize: const Size(200, 50),
                              minimumSize: const Size(200, 50)),
                          onPressed: () {
                            overviewBookingBloc.eventController.sink.add(
                                SubmitBookingBlocHomestayEvent(
                                    bookingBlocHomestay: snapshot.data!
                                        .bookingBlocHomestayModel(),
                                    bookingId: widget.bookingId,
                                    context: context,
                                    blocBookingDateValidation:
                                        widget.blocBookingValidation));
                          },
                          child: const Text("Proceed",
                              style: TextStyle(
                                  fontFamily: "Lobster",
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white))),
                    )
                  ],
                ),
              ],
            ),
          );
        });
  }
}
