import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_advanced_avatar/flutter_advanced_avatar.dart';

import 'package:staywithme_passenger_application/bloc/booking_list_bloc.dart';
import 'package:staywithme_passenger_application/bloc/booking_loading_bloc.dart';
import 'package:staywithme_passenger_application/bloc/event/booking_list_event.dart';
import 'package:staywithme_passenger_application/bloc/event/booking_loading_event.dart';
import 'package:staywithme_passenger_application/bloc/state/booking_list_state.dart';
import 'package:staywithme_passenger_application/bloc/state/booking_loading_state.dart';
import 'package:staywithme_passenger_application/global_variable.dart';
import 'package:staywithme_passenger_application/model/booking_model.dart';
import 'package:staywithme_passenger_application/model/exc_model.dart';
import 'package:staywithme_passenger_application/model/homestay_model.dart';
import 'package:staywithme_passenger_application/service/image_service.dart';
import 'package:staywithme_passenger_application/service/user/booking_service.dart';
import 'package:staywithme_passenger_application/service_locator/service_locator.dart';

class BookingLoadingScreen extends StatelessWidget {
  const BookingLoadingScreen({super.key});
  static const bookingLoadingScreen = "/booking-loading";

  @override
  Widget build(BuildContext context) {
    final bookingService = locator.get<IBookingService>();
    final bookingLoadingBloc = BookingLoadingBloc();

    return StreamBuilder<BookingLoadingState>(
        stream: bookingLoadingBloc.stateController.stream,
        initialData: bookingLoadingBloc.initData(context),
        builder: (context, streamSnapshot) {
          return Scaffold(
            body: FutureBuilder(
              future: bookingService
                  .getBookingById(streamSnapshot.data!.bookingId!),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const SizedBox();
                  case ConnectionState.done:
                    if (snapshot.hasData) {
                      final bookingData = snapshot.data;
                      if (bookingData is BookingModel) {
                        bookingLoadingBloc.eventController.sink.add(
                            GetBookingSuccessEvent(
                                booking: bookingData,
                                homestayType: streamSnapshot.data!.homestayType,
                                context: context));
                      } else if (bookingData is ServerExceptionModel) {
                        return AlertDialog(
                          title: const Center(child: Text("Notice")),
                          content: SizedBox(
                            height: 100,
                            width: 100,
                            child: Text(bookingData.message!),
                          ),
                        );
                      } else if (bookingData is SocketException ||
                          bookingData is TimeoutException) {
                        return const AlertDialog(
                          title: Center(child: Text("Notice")),
                          content: SizedBox(
                            height: 100,
                            width: 100,
                            child: Text("Fail to connect to server"),
                          ),
                        );
                      }
                    } else {
                      return const SizedBox();
                    }
                    break;
                  default:
                    break;
                }
                return const SizedBox();
              },
            ),
          );
        });
  }
}

class BookingListScreen extends StatefulWidget {
  const BookingListScreen({super.key});
  static const String bookingListScreenRoute = "/booking-list";

  @override
  State<BookingListScreen> createState() => _BookingListScreenState();
}

class _BookingListScreenState extends State<BookingListScreen> {
  final bookingService = locator.get<IBookingService>();
  final imageService = locator.get<IImageService>();
  final bookingListBloc = BookingListBloc();
  final bookingStartDateTextEditingController = TextEditingController();
  final bookingEndDateTextEditingController = TextEditingController();

  @override
  void dispose() {
    bookingListBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(seconds: 1),
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: child,
      ),
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          backgroundColor: primaryColor,
          body: StreamBuilder<BookingListState>(
            stream: bookingListBloc.stateController.stream,
            initialData: bookingListBloc.initData(context),
            builder: (context, streamSnapshot) {
              bookingStartDateTextEditingController.text =
                  streamSnapshot.data!.booking!.bookingFrom!;
              bookingEndDateTextEditingController.text =
                  streamSnapshot.data!.booking!.bookingTo!;
              return TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: 1),
                duration: const Duration(seconds: 1),
                builder: (context, value, child) => Opacity(
                  opacity: value,
                  child: child,
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 50,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "BOOKING FROM",
                                    style: TextStyle(
                                        fontFamily: "Lobster",
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  TextFormField(
                                    controller:
                                        bookingStartDateTextEditingController,
                                    readOnly: true,
                                    style:
                                        const TextStyle(fontFamily: "Lobster"),
                                    decoration: InputDecoration(
                                        hintText: "Start date yyyy-MM-dd",
                                        contentPadding: const EdgeInsets.only(
                                            left: 60, right: 50),
                                        filled: true,
                                        fillColor: Colors.white,
                                        enabledBorder: const OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: secondaryColor,
                                                width: 1.0)),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            borderSide: const BorderSide(
                                                color: secondaryColor,
                                                width: 1.0))),
                                    onTap: () {
                                      showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime.now(),
                                              lastDate: DateTime.now().add(
                                                  const Duration(days: 365)))
                                          .then((value) {
                                        bookingStartDateTextEditingController
                                            .text = dateFormat.format(value!);
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "BOOKING TO",
                                    style: TextStyle(
                                        fontFamily: "Lobster",
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  TextFormField(
                                    controller:
                                        bookingEndDateTextEditingController,
                                    readOnly: true,
                                    style:
                                        const TextStyle(fontFamily: "Lobster"),
                                    decoration: const InputDecoration(
                                      hintText: "End date yyyy-MM-dd",
                                      filled: true,
                                      fillColor: Colors.white,
                                      contentPadding:
                                          EdgeInsets.only(left: 60, right: 50),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: secondaryColor,
                                              width: 1.0)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: secondaryColor,
                                              width: 1.0)),
                                    ),
                                    onTap: () {
                                      showDatePicker(
                                              context: context,
                                              initialDate: dateFormat
                                                  .parse(
                                                      bookingStartDateTextEditingController
                                                          .text)
                                                  .add(const Duration(days: 1)),
                                              firstDate: dateFormat
                                                  .parse(
                                                      bookingStartDateTextEditingController
                                                          .text)
                                                  .add(const Duration(days: 1)),
                                              lastDate: dateFormat
                                                  .parse(
                                                      bookingStartDateTextEditingController
                                                          .text)
                                                  .add(const Duration(
                                                      days: 365)))
                                          .then((value) {
                                        bookingEndDateTextEditingController
                                            .text = dateFormat.format(value!);
                                        bookingListBloc.eventController.sink
                                            .add(UpdateBookingDateEvent(
                                                context: context,
                                                bookingEnd:
                                                    bookingEndDateTextEditingController
                                                        .text,
                                                bookingStart:
                                                    bookingStartDateTextEditingController
                                                        .text,
                                                booking: streamSnapshot
                                                    .data!.booking!,
                                                bookingId: streamSnapshot
                                                    .data!.booking!.id));
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Booking code",
                              style: TextStyle(
                                  fontFamily: "Lobster",
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            Text(
                              " ${streamSnapshot.data!.booking!.code}",
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                bookingListBloc.eventController.sink
                                    .add(ChooseViewHomestayListEvent());
                              },
                              child: Container(
                                height: 50,
                                width: 150,
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        bottomLeft: Radius.circular(10)),
                                    color:
                                        streamSnapshot.data!.isBookingHomestay!
                                            ? secondaryColor
                                            : Colors.white),
                                child: Center(
                                  child: Text(
                                    "View Homestays",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: streamSnapshot
                                                .data!.isBookingHomestay!
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                bookingListBloc.eventController.sink
                                    .add(ChooseViewServiceListEvent());
                              },
                              child: Container(
                                height: 50,
                                width: 150,
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(10),
                                        bottomRight: Radius.circular(10)),
                                    color:
                                        streamSnapshot.data!.isBookingHomestay!
                                            ? Colors.white
                                            : secondaryColor),
                                child: Center(
                                  child: Text(
                                    "View Services",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: streamSnapshot
                                                .data!.isBookingHomestay!
                                            ? Colors.black
                                            : Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        streamSnapshot.data!.isBookingHomestay!
                            ? SizedBox(
                                height: 500,
                                child: ListView.builder(
                                  itemCount: streamSnapshot
                                      .data!.booking!.bookingHomestays!.length,
                                  itemBuilder: (context, index) => Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          bookingListBloc.eventController.sink
                                              .add(ChooseBookingHomestayEvent(
                                                  bookingHomestay: streamSnapshot
                                                          .data!
                                                          .booking!
                                                          .bookingHomestays![
                                                      index]));
                                        },
                                        child: Container(
                                          height: 100,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          margin: const EdgeInsets.only(
                                              left: 10, right: 10),
                                          decoration: const BoxDecoration(
                                              color: Colors.white,
                                              boxShadow: <BoxShadow>[
                                                BoxShadow(
                                                    blurRadius: 2.0,
                                                    blurStyle: BlurStyle.outer,
                                                    offset: Offset(1.0, 1.0))
                                              ]),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                      flex: 1,
                                                      child: FutureBuilder(
                                                        future: imageService
                                                            .getHomestayImage(
                                                                streamSnapshot
                                                                    .data!
                                                                    .booking!
                                                                    .bookingHomestays![
                                                                        index]
                                                                    .homestay!
                                                                    .homestayImages!
                                                                    .first
                                                                    .imageUrl!),
                                                        builder: (context,
                                                            imgSnapshot) {
                                                          switch (imgSnapshot
                                                              .connectionState) {
                                                            case ConnectionState
                                                                .waiting:
                                                              return Container(
                                                                width: 30,
                                                                height: 30,
                                                                color: Colors
                                                                    .white24,
                                                              );
                                                            case ConnectionState
                                                                .done:
                                                              final imageData =
                                                                  imgSnapshot
                                                                      .data;
                                                              String imageUrl =
                                                                  imageData ??
                                                                      "https://i.ytimg.com/vi/0jDUx3jOBfU/mqdefault.jpg";
                                                              return AdvancedAvatar(
                                                                image:
                                                                    NetworkImage(
                                                                        imageUrl),
                                                              );
                                                            default:
                                                              break;
                                                          }
                                                          return Container(
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 10,
                                                                    right: 10),
                                                            width: 30,
                                                            height: 30,
                                                            color:
                                                                Colors.white24,
                                                          );
                                                        },
                                                      )),
                                                  Expanded(
                                                      flex: 2,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            streamSnapshot
                                                                .data!
                                                                .booking!
                                                                .bookingHomestays![
                                                                    index]
                                                                .homestay!
                                                                .name!
                                                                .toUpperCase(),
                                                            style: const TextStyle(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black45),
                                                          ),
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                          Row(
                                                            children: [
                                                              Expanded(
                                                                flex: 1,
                                                                child: Text(
                                                                  "Price(VND): ${currencyFormat.format(streamSnapshot.data!.booking!.bookingHomestays![index].totalBookingPrice)}",
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          12),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                flex: 1,
                                                                child: Text(
                                                                  "Reservation: ${streamSnapshot.data!.booking!.bookingHomestays![index].totalReservation}",
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          12),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                          Row(
                                                            children: [
                                                              Expanded(
                                                                flex: 1,
                                                                child: Text(
                                                                  "Services: ${streamSnapshot.data!.booking!.bookingHomestayServices!.where((element) => element.homestayName == streamSnapshot.data!.booking!.bookingHomestays![index].homestay!.name).toList().length}",
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          12),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                flex: 2,
                                                                child: Text(
                                                                  "Service Pr.(VND): ${currencyFormat.format(streamSnapshot.data!.totalBookingServicePrice(streamSnapshot.data!.booking!.bookingHomestays![index].homestay!.name!))}",
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          12),
                                                                ),
                                                              )
                                                            ],
                                                          )
                                                        ],
                                                      )),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      streamSnapshot.data!
                                                  .isBookingHomestayChosen(
                                                      streamSnapshot
                                                              .data!
                                                              .booking!
                                                              .bookingHomestays![
                                                          index]) ==
                                              true
                                          ? TweenAnimationBuilder(
                                              tween: Tween<double>(
                                                  begin: 0, end: 50),
                                              duration:
                                                  const Duration(seconds: 1),
                                              builder:
                                                  (context, value, child) =>
                                                      SizedBox(
                                                height: value,
                                                child: child,
                                              ),
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                    left: 10, right: 10),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 1,
                                                      child: ElevatedButton(
                                                          style: ElevatedButton.styleFrom(
                                                              backgroundColor:
                                                                  Colors.red,
                                                              maximumSize:
                                                                  const Size(
                                                                      150, 50),
                                                              minimumSize:
                                                                  const Size(
                                                                      150, 50)),
                                                          onPressed: () {},
                                                          child: const Text(
                                                            "Delete",
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                fontFamily:
                                                                    "Lobster",
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          )),
                                                    ),
                                                    Expanded(
                                                      flex: 2,
                                                      child: ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .greenAccent,
                                                                  maximumSize:
                                                                      const Size(
                                                                          150,
                                                                          50),
                                                                  minimumSize:
                                                                      const Size(
                                                                          150,
                                                                          50)),
                                                          onPressed: () {},
                                                          child: const Text(
                                                            "View services",
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                fontFamily:
                                                                    "Lobster",
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          )),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          : const SizedBox()
                                    ],
                                  ),
                                ),
                              )
                            : SizedBox(
                                height: 500,
                                child: Column(children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        onPressed: () {},
                                        icon: const Icon(
                                          Icons.arrow_back_ios_new,
                                          color: secondaryColor,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                          streamSnapshot.data!
                                              .selectedHomestay()!
                                              .name!,
                                          style: const TextStyle(
                                              fontFamily: "Lobster",
                                              fontWeight: FontWeight.bold)),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      IconButton(
                                        onPressed: () {},
                                        icon: const Icon(
                                          Icons.arrow_forward_ios,
                                          color: secondaryColor,
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    height: 200,
                                    child: ListView.builder(
                                      itemCount: streamSnapshot.data!
                                          .selectedHomestay()!
                                          .homestayServices!
                                          .length,
                                      itemBuilder: (context, index) {
                                        HomestayServiceModel homestayService =
                                            streamSnapshot.data!
                                                .selectedHomestay()!
                                                .homestayServices![index];
                                        return GestureDetector(
                                          onTap: () {
                                            bookingListBloc.eventController.sink
                                                .add(
                                                    ChooseNewHomestayServiceEvent(
                                                        serviceName:
                                                            homestayService
                                                                .name));
                                          },
                                          child: Container(
                                            height: 50,
                                            margin: const EdgeInsets.only(
                                                bottom: 10,
                                                left: 10,
                                                right: 10),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(10)),
                                                color: streamSnapshot.data!
                                                        .isServiceBooked(
                                                            homestayService
                                                                .name!)
                                                    ? secondaryColor
                                                    : Colors.white),
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                    flex: 1,
                                                    child: Center(
                                                      child: Text(
                                                        homestayService.name!,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: streamSnapshot
                                                                    .data!
                                                                    .isServiceBooked(
                                                                        homestayService
                                                                            .name!)
                                                                ? Colors.white
                                                                : Colors.black),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: Center(
                                                      child: Text(
                                                        "${currencyFormat.format(homestayService.price)}VND",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: streamSnapshot
                                                                    .data!
                                                                    .isServiceBooked(
                                                                        homestayService
                                                                            .name!)
                                                                ? Colors.white
                                                                : Colors.black),
                                                      ),
                                                    ),
                                                  ),
                                                ]),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  streamSnapshot.data!.activeUpdateService!
                                      ? Row(
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              Colors.redAccent),
                                                  onPressed: () {},
                                                  child: const Text(
                                                    "Cancel",
                                                    style: TextStyle(
                                                        fontFamily: "Lobster",
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              Colors
                                                                  .greenAccent),
                                                  onPressed: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          AlertDialog(
                                                        title: const Center(
                                                          child: Text("Notice"),
                                                        ),
                                                        content: SizedBox(
                                                          height: 150,
                                                          width: 50,
                                                          child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                const Text(
                                                                  "Do you want to update your booking service?",
                                                                ),
                                                                const SizedBox(
                                                                  height: 20,
                                                                ),
                                                                Text(
                                                                    "Total price ${currencyFormat.format(streamSnapshot.data!.totalChosenHomestayServicePrice())}"),
                                                                Row(
                                                                  children: [
                                                                    Expanded(
                                                                        child:
                                                                            ElevatedButton(
                                                                      style: ElevatedButton.styleFrom(
                                                                          backgroundColor:
                                                                              Colors.redAccent),
                                                                      onPressed:
                                                                          () {},
                                                                      child:
                                                                          const Text(
                                                                        "No",
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                "Lobster",
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color: Colors.white),
                                                                      ),
                                                                    )),
                                                                    Expanded(
                                                                        child:
                                                                            ElevatedButton(
                                                                      style: ElevatedButton.styleFrom(
                                                                          backgroundColor:
                                                                              Colors.greenAccent),
                                                                      onPressed:
                                                                          () {
                                                                        bookingListBloc.eventController.sink.add(UpdateHomestayServiceEvent(
                                                                            context:
                                                                                context,
                                                                            bookingId:
                                                                                streamSnapshot.data!.booking!.id,
                                                                            homestayName: streamSnapshot.data!.selectedHomestay()!.name,
                                                                            homestayType: streamSnapshot.data!.homestayType,
                                                                            serviceNameList: streamSnapshot.data!.serviceNameList));
                                                                      },
                                                                      child:
                                                                          const Text(
                                                                        "Yes",
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                "Lobster",
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color: Colors.white),
                                                                      ),
                                                                    )),
                                                                  ],
                                                                )
                                                              ]),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: const Text(
                                                    "Update",
                                                    style: TextStyle(
                                                        fontFamily: "Lobster",
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )),
                                            )
                                          ],
                                        )
                                      : const SizedBox(),
                                ]),
                              ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Total booking price: ${currencyFormat.format(streamSnapshot.data!.booking!.totalBookingPrice)}",
                          style: const TextStyle(fontFamily: "Lobster"),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                flex: 1,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.greenAccent,
                                  ),
                                  onPressed: () {},
                                  child: const Text(
                                    "Browse for more",
                                    style: TextStyle(
                                        fontFamily: "Lobster",
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                flex: 1,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: secondaryColor,
                                  ),
                                  onPressed: () {},
                                  child: const Text(
                                    "Submit",
                                    style: TextStyle(
                                        fontFamily: "Lobster",
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                            ]),
                      ]),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
