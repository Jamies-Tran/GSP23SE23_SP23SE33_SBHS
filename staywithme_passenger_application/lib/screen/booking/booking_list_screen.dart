import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_advanced_avatar/flutter_advanced_avatar.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:staywithme_passenger_application/bloc/booking_list_bloc.dart';
import 'package:staywithme_passenger_application/bloc/booking_loading_bloc.dart';
import 'package:staywithme_passenger_application/bloc/event/booking_list_event.dart';
import 'package:staywithme_passenger_application/bloc/event/booking_loading_event.dart';
import 'package:staywithme_passenger_application/bloc/event/show_homestays_event.dart';
import 'package:staywithme_passenger_application/bloc/show_homestays_bloc.dart';
import 'package:staywithme_passenger_application/bloc/state/booking_list_state.dart';
import 'package:staywithme_passenger_application/bloc/state/show_homestays_state.dart';
import 'package:staywithme_passenger_application/global_variable.dart';
import 'package:staywithme_passenger_application/model/bloc_model.dart';
import 'package:staywithme_passenger_application/model/booking_model.dart';
import 'package:staywithme_passenger_application/model/exc_model.dart';
import 'package:staywithme_passenger_application/model/homestay_model.dart';
import 'package:staywithme_passenger_application/service/image_service.dart';
import 'package:staywithme_passenger_application/service/user/booking_service.dart';
import 'package:staywithme_passenger_application/service_locator/service_locator.dart';

class BookingLoadingScreen extends StatefulWidget {
  const BookingLoadingScreen({super.key});
  static const bookingLoadingScreen = "/booking-loading";

  @override
  State<BookingLoadingScreen> createState() => _BookingLoadingScreenState();
}

class _BookingLoadingScreenState extends State<BookingLoadingScreen> {
  final bookingService = locator.get<IBookingService>();
  final bookingLoadingBloc = BookingLoadingBloc();

  @override
  void dispose() {
    bookingLoadingBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final contextArguments = ModalRoute.of(context)!.settings.arguments as Map;
    final bookingId = contextArguments["bookingId"];
    final homestayType = contextArguments["homestayType"];
    BlocBookingDateValidationModel? blocBookingValidation =
        contextArguments["blocBookingValidation"];
    bool? isBookingHomestay = contextArguments["isBookingHomestay"] ?? true;
    int? bookingHomestayIndex = contextArguments["bookingHomestayIndex"] ?? 0;
    return Scaffold(
      body: FutureBuilder(
        future: bookingService.getBookingById(bookingId),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const SpinKitCircle(
                color: Colors.black,
                duration: Duration(seconds: 4),
              );
            case ConnectionState.done:
              if (snapshot.hasData) {
                final bookingData = snapshot.data;
                if (bookingData is BookingModel) {
                  bookingLoadingBloc.eventController.sink.add(
                      GetBookingSuccessEvent(
                          booking: bookingData,
                          homestayType: homestayType,
                          bookingHomestayIndex: bookingHomestayIndex,
                          isBookingHomestay: isBookingHomestay,
                          context: context,
                          blocBookingValidation: blocBookingValidation));
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
  }
}

// ignore: constant_identifier_names
enum BlocPaymentMethod { swm_wallet, cash }

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
    return StreamBuilder<BookingListState>(
        stream: bookingListBloc.stateController.stream,
        initialData: bookingListBloc.initData(context),
        builder: (context, streamSnapshot) {
          bookingStartDateTextEditingController.text =
              streamSnapshot.data!.booking!.bookingFrom!;
          bookingEndDateTextEditingController.text =
              streamSnapshot.data!.booking!.bookingTo!;
          return WillPopScope(
            onWillPop: () async => false,
            child: Scaffold(
                backgroundColor: primaryColor,
                body: SingleChildScrollView(
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
                                height: streamSnapshot.data!.booking!
                                            .bookingHomestays!.length <
                                        3
                                    ? 300
                                    : 400,
                                child:
                                    streamSnapshot.data!.booking!
                                            .bookingHomestays!.isNotEmpty
                                        ? ListView.builder(
                                            itemCount: streamSnapshot
                                                .data!
                                                .booking!
                                                .bookingHomestays!
                                                .length,
                                            itemBuilder: (context, index) =>
                                                Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    bookingListBloc
                                                        .eventController.sink
                                                        .add(ChooseBookingHomestayEvent(
                                                            bookingHomestay:
                                                                streamSnapshot
                                                                        .data!
                                                                        .booking!
                                                                        .bookingHomestays![
                                                                    index]));
                                                  },
                                                  child: Container(
                                                    height: 100,
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    margin:
                                                        const EdgeInsets.only(
                                                            left: 10,
                                                            right: 10),
                                                    decoration:
                                                        const BoxDecoration(
                                                            color: Colors.white,
                                                            boxShadow: <
                                                                BoxShadow>[
                                                          BoxShadow(
                                                              blurRadius: 2.0,
                                                              blurStyle:
                                                                  BlurStyle
                                                                      .outer,
                                                              offset: Offset(
                                                                  1.0, 1.0))
                                                        ]),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                                flex: 1,
                                                                child:
                                                                    FutureBuilder(
                                                                  future: imageService.getHomestayImage(streamSnapshot
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
                                                                          width:
                                                                              30,
                                                                          height:
                                                                              30,
                                                                          color:
                                                                              Colors.white24,
                                                                        );
                                                                      case ConnectionState
                                                                          .done:
                                                                        final imageData =
                                                                            imgSnapshot.data;
                                                                        String
                                                                            imageUrl =
                                                                            imageData ??
                                                                                "https://i.ytimg.com/vi/0jDUx3jOBfU/mqdefault.jpg";
                                                                        return AdvancedAvatar(
                                                                          image:
                                                                              NetworkImage(imageUrl),
                                                                        );
                                                                      default:
                                                                        break;
                                                                    }
                                                                    return Container(
                                                                      margin: const EdgeInsets
                                                                              .only(
                                                                          left:
                                                                              10,
                                                                          right:
                                                                              10),
                                                                      width: 30,
                                                                      height:
                                                                          30,
                                                                      color: Colors
                                                                          .white24,
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
                                                                          fontSize:
                                                                              20,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color:
                                                                              Colors.black45),
                                                                    ),
                                                                    const SizedBox(
                                                                      height:
                                                                          10,
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        Expanded(
                                                                          flex:
                                                                              1,
                                                                          child:
                                                                              Text(
                                                                            "Price: ${currencyFormat.format(streamSnapshot.data!.booking!.bookingHomestays![index].homestay!.price)}",
                                                                            style:
                                                                                const TextStyle(fontSize: 12),
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                          flex:
                                                                              1,
                                                                          child:
                                                                              Text(
                                                                            "Total: ${currencyFormat.format(streamSnapshot.data!.booking!.bookingHomestays![index].totalBookingPrice)}",
                                                                            style:
                                                                                const TextStyle(fontSize: 12),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    const SizedBox(
                                                                      height: 5,
                                                                    ),
                                                                    streamSnapshot.data!.homestayType ==
                                                                            "homestay"
                                                                        ? Row(
                                                                            children: [
                                                                              Expanded(
                                                                                flex: 1,
                                                                                child: Text(
                                                                                  "Services: ${streamSnapshot.data!.booking!.bookingHomestayServices!.where((element) => element.homestayName == streamSnapshot.data!.booking!.bookingHomestays![index].homestay!.name).toList().length}",
                                                                                  style: const TextStyle(fontSize: 12),
                                                                                ),
                                                                              ),
                                                                              Expanded(
                                                                                flex: 1,
                                                                                child: Text(
                                                                                  "Total(service): ${currencyFormat.format(streamSnapshot.data!.totalBookingServicePrice(streamSnapshot.data!.booking!.bookingHomestays![index].homestay!.name!))}",
                                                                                  style: const TextStyle(fontSize: 12),
                                                                                ),
                                                                              )
                                                                            ],
                                                                          )
                                                                        : const SizedBox()
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
                                                            const Duration(
                                                                seconds: 1),
                                                        builder: (context,
                                                                value, child) =>
                                                            SizedBox(
                                                          height: value,
                                                          child: child,
                                                        ),
                                                        child: Container(
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 10,
                                                                  right: 10),
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                flex: 1,
                                                                child:
                                                                    ElevatedButton(
                                                                        style: ElevatedButton.styleFrom(
                                                                            backgroundColor: Colors
                                                                                .red,
                                                                            maximumSize: const Size(150,
                                                                                50),
                                                                            minimumSize: const Size(150,
                                                                                50)),
                                                                        onPressed:
                                                                            () {
                                                                          showDialog(
                                                                            context:
                                                                                context,
                                                                            builder: (context) =>
                                                                                AlertDialog(
                                                                              title: const Center(child: Text("Notice")),
                                                                              content: SizedBox(
                                                                                height: 100,
                                                                                child: Column(children: [
                                                                                  const Text("Do you want to delete this homestay?"),
                                                                                  const SizedBox(
                                                                                    height: 10,
                                                                                  ),
                                                                                  Row(
                                                                                    children: [
                                                                                      Expanded(
                                                                                          flex: 1,
                                                                                          child: ElevatedButton(
                                                                                              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                                                                              onPressed: () {
                                                                                                Navigator.pop(context);
                                                                                              },
                                                                                              child: const Text("No", style: TextStyle(fontFamily: "Lobster", fontWeight: FontWeight.bold, color: Colors.white)))),
                                                                                      Expanded(
                                                                                          flex: 1,
                                                                                          child: ElevatedButton(
                                                                                              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                                                                              onPressed: () {
                                                                                                bookingListBloc.eventController.sink.add(DeleteBookingHomestayEvent(context: context, homestayId: streamSnapshot.data!.booking!.bookingHomestays![index].homestay!.id));
                                                                                              },
                                                                                              child: const Text("Yes", style: TextStyle(fontFamily: "Lobster", fontWeight: FontWeight.bold, color: Colors.white))))
                                                                                    ],
                                                                                  )
                                                                                ]),
                                                                              ),
                                                                            ),
                                                                          );
                                                                        },
                                                                        child:
                                                                            Row(
                                                                          children: const [
                                                                            Icon(
                                                                              Icons.delete,
                                                                              color: Colors.white,
                                                                            ),
                                                                            SizedBox(
                                                                              width: 10,
                                                                            ),
                                                                            Text(
                                                                              "Delete",
                                                                              style: TextStyle(fontSize: 15, fontFamily: "Lobster", fontWeight: FontWeight.bold),
                                                                            ),
                                                                          ],
                                                                        )),
                                                              ),
                                                              Expanded(
                                                                flex: 2,
                                                                child:
                                                                    ElevatedButton(
                                                                        style: ElevatedButton.styleFrom(
                                                                            backgroundColor: Colors
                                                                                .greenAccent,
                                                                            maximumSize: const Size(150,
                                                                                50),
                                                                            minimumSize: const Size(150,
                                                                                50)),
                                                                        onPressed:
                                                                            () {
                                                                          bookingListBloc
                                                                              .eventController
                                                                              .sink
                                                                              .add(ViewHomestayDetailScreenEvent(context: context, homestayName: streamSnapshot.data!.booking!.bookingHomestays![index].homestay!.name));
                                                                        },
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: const [
                                                                            Icon(
                                                                              Icons.remove_red_eye,
                                                                              color: Colors.white,
                                                                            ),
                                                                            SizedBox(
                                                                              width: 10,
                                                                            ),
                                                                            Text(
                                                                              "View",
                                                                              style: TextStyle(fontSize: 15, fontFamily: "Lobster", fontWeight: FontWeight.bold),
                                                                            ),
                                                                          ],
                                                                        )),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                    : const SizedBox(),
                                                index ==
                                                        streamSnapshot
                                                                .data!
                                                                .booking!
                                                                .bookingHomestays!
                                                                .length -
                                                            1
                                                    ? GestureDetector(
                                                        onTap: () {
                                                          if (streamSnapshot
                                                                  .data!
                                                                  .homestayType ==
                                                              "homestay") {
                                                            showDialog(
                                                              context: context,
                                                              builder:
                                                                  (context) =>
                                                                      AlertDialog(
                                                                title:
                                                                    const Center(
                                                                  child: Text(
                                                                      "Notice"),
                                                                ),
                                                                content:
                                                                    SizedBox(
                                                                  height: 150,
                                                                  width: 50,
                                                                  child: Column(
                                                                      children: [
                                                                        const Text(
                                                                          "Do you want to find homestay similar with this homestay?",
                                                                        ),
                                                                        const SizedBox(
                                                                          height:
                                                                              30,
                                                                        ),
                                                                        Text(
                                                                            streamSnapshot.data!
                                                                                .selectedHomestay()!
                                                                                .name!,
                                                                            style: const TextStyle(
                                                                                fontFamily: "Lobster",
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.black)),
                                                                        Row(
                                                                          children: [
                                                                            Expanded(
                                                                                child: ElevatedButton(
                                                                              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                                                                              onPressed: () {
                                                                                bookingListBloc.eventController.sink.add(BrowseMoreHomestayEvent(context: context, homestay: streamSnapshot.data!.selectedHomestay()!, similarWithAnotherHomestay: false));
                                                                              },
                                                                              child: const Text(
                                                                                "No",
                                                                                style: TextStyle(fontFamily: "Lobster", fontWeight: FontWeight.bold, color: Colors.white),
                                                                              ),
                                                                            )),
                                                                            Expanded(
                                                                                child: ElevatedButton(
                                                                              style: ElevatedButton.styleFrom(backgroundColor: Colors.greenAccent),
                                                                              onPressed: () {
                                                                                bookingListBloc.eventController.sink.add(BrowseMoreHomestayEvent(context: context, homestay: streamSnapshot.data!.selectedHomestay()!, similarWithAnotherHomestay: true));
                                                                              },
                                                                              child: const Text(
                                                                                "Yes",
                                                                                style: TextStyle(fontFamily: "Lobster", fontWeight: FontWeight.bold, color: Colors.white),
                                                                              ),
                                                                            )),
                                                                          ],
                                                                        )
                                                                      ]),
                                                                ),
                                                              ),
                                                            );
                                                          } else {
                                                            bookingListBloc
                                                                .eventController
                                                                .sink
                                                                .add(ChooseHomestayListInBlocEvent(
                                                                    bloc: streamSnapshot
                                                                        .data!
                                                                        .booking!
                                                                        .bloc,
                                                                    context:
                                                                        context,
                                                                    blocBookingValidation:
                                                                        streamSnapshot
                                                                            .data!
                                                                            .blocBookingValidation,
                                                                    booking: streamSnapshot
                                                                        .data!
                                                                        .booking));
                                                          }
                                                        },
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Container(
                                                              height: 50,
                                                              width:
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                              margin:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 10,
                                                                      right: 10,
                                                                      top: 30,
                                                                      bottom:
                                                                          5),
                                                              decoration: const BoxDecoration(
                                                                  color:
                                                                      secondaryColor,
                                                                  boxShadow: <BoxShadow>[
                                                                    BoxShadow(
                                                                        blurRadius:
                                                                            2.0,
                                                                        blurStyle:
                                                                            BlurStyle
                                                                                .outer,
                                                                        offset: Offset(
                                                                            1.0,
                                                                            1.0))
                                                                  ]),
                                                              child: const Center(
                                                                  child: Icon(Icons
                                                                      .add_circle)),
                                                            ),
                                                            streamSnapshot.data!
                                                                        .homestayType ==
                                                                    "homestay"
                                                                ? Column(
                                                                    children: [
                                                                      const Text(
                                                                          "Filter by: ",
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Colors.black45)),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          IconButton(
                                                                            onPressed:
                                                                                () {
                                                                              bookingListBloc.eventController.sink.add(BackwardHomestayEvent());
                                                                            },
                                                                            icon:
                                                                                const Icon(
                                                                              Icons.arrow_back_ios_new,
                                                                              color: secondaryColor,
                                                                            ),
                                                                          ),
                                                                          const SizedBox(
                                                                            width:
                                                                                5,
                                                                          ),
                                                                          Text(
                                                                              streamSnapshot.data!.selectedHomestay()!.name!,
                                                                              style: const TextStyle(fontFamily: "Lobster", fontWeight: FontWeight.bold)),
                                                                          const SizedBox(
                                                                            width:
                                                                                5,
                                                                          ),
                                                                          IconButton(
                                                                            onPressed:
                                                                                () {
                                                                              bookingListBloc.eventController.sink.add(ForwardHomestayEvent());
                                                                            },
                                                                            icon:
                                                                                const Icon(
                                                                              Icons.arrow_forward_ios,
                                                                              color: secondaryColor,
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  )
                                                                : const SizedBox()
                                                          ],
                                                        ),
                                                      )
                                                    : const SizedBox(),
                                              ],
                                            ),
                                          )
                                        : GestureDetector(
                                            onTap: () {
                                              if (streamSnapshot
                                                      .data!.homestayType ==
                                                  "homestay") {
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
                                                      child: Column(children: [
                                                        const Text(
                                                          "Do you want to find homestay similar with this homestay?",
                                                        ),
                                                        const SizedBox(
                                                          height: 30,
                                                        ),
                                                        Text(
                                                            streamSnapshot.data!
                                                                .selectedHomestay()!
                                                                .name!,
                                                            style: const TextStyle(
                                                                fontFamily:
                                                                    "Lobster",
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black)),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                                child:
                                                                    ElevatedButton(
                                                              style: ElevatedButton
                                                                  .styleFrom(
                                                                      backgroundColor:
                                                                          Colors
                                                                              .redAccent),
                                                              onPressed: () {
                                                                bookingListBloc
                                                                    .eventController
                                                                    .sink
                                                                    .add(BrowseMoreHomestayEvent(
                                                                        context:
                                                                            context,
                                                                        homestay: streamSnapshot
                                                                            .data!
                                                                            .selectedHomestay()!,
                                                                        similarWithAnotherHomestay:
                                                                            false));
                                                              },
                                                              child: const Text(
                                                                "No",
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        "Lobster",
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            )),
                                                            Expanded(
                                                                child:
                                                                    ElevatedButton(
                                                              style: ElevatedButton
                                                                  .styleFrom(
                                                                      backgroundColor:
                                                                          Colors
                                                                              .greenAccent),
                                                              onPressed: () {
                                                                bookingListBloc
                                                                    .eventController
                                                                    .sink
                                                                    .add(BrowseMoreHomestayEvent(
                                                                        context:
                                                                            context,
                                                                        homestay: streamSnapshot
                                                                            .data!
                                                                            .selectedHomestay()!,
                                                                        similarWithAnotherHomestay:
                                                                            true));
                                                              },
                                                              child: const Text(
                                                                "Yes",
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        "Lobster",
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            )),
                                                          ],
                                                        )
                                                      ]),
                                                    ),
                                                  ),
                                                );
                                              } else {
                                                bookingListBloc
                                                    .eventController.sink
                                                    .add(ChooseHomestayListInBlocEvent(
                                                        bloc: streamSnapshot
                                                            .data!
                                                            .booking!
                                                            .bloc,
                                                        context: context,
                                                        blocBookingValidation:
                                                            streamSnapshot.data!
                                                                .blocBookingValidation,
                                                        booking: streamSnapshot
                                                            .data!.booking));
                                              }
                                            },
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  height: 50,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  margin: const EdgeInsets.only(
                                                      left: 10,
                                                      right: 10,
                                                      top: 30,
                                                      bottom: 5),
                                                  decoration:
                                                      const BoxDecoration(
                                                          color: secondaryColor,
                                                          boxShadow: <
                                                              BoxShadow>[
                                                        BoxShadow(
                                                            blurRadius: 2.0,
                                                            blurStyle:
                                                                BlurStyle.outer,
                                                            offset: Offset(
                                                                1.0, 1.0))
                                                      ]),
                                                  child: const Center(
                                                      child: Icon(
                                                          Icons.add_circle)),
                                                ),
                                                streamSnapshot.data!
                                                            .homestayType ==
                                                        "homestay"
                                                    ? Column(
                                                        children: [
                                                          const Text(
                                                              "Filter by: ",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .black45)),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              IconButton(
                                                                onPressed: () {
                                                                  bookingListBloc
                                                                      .eventController
                                                                      .sink
                                                                      .add(
                                                                          BackwardHomestayEvent());
                                                                },
                                                                icon:
                                                                    const Icon(
                                                                  Icons
                                                                      .arrow_back_ios_new,
                                                                  color:
                                                                      secondaryColor,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 5,
                                                              ),
                                                              Text(
                                                                  streamSnapshot
                                                                      .data!
                                                                      .selectedHomestay()!
                                                                      .name!,
                                                                  style: const TextStyle(
                                                                      fontFamily:
                                                                          "Lobster",
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold)),
                                                              const SizedBox(
                                                                width: 5,
                                                              ),
                                                              IconButton(
                                                                onPressed: () {
                                                                  bookingListBloc
                                                                      .eventController
                                                                      .sink
                                                                      .add(
                                                                          ForwardHomestayEvent());
                                                                },
                                                                icon:
                                                                    const Icon(
                                                                  Icons
                                                                      .arrow_forward_ios,
                                                                  color:
                                                                      secondaryColor,
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ],
                                                      )
                                                    : const SizedBox()
                                              ],
                                            ),
                                          ),
                              )
                            : SizedBox(
                                height: 500,
                                child: Column(children: [
                                  streamSnapshot.data!.homestayType ==
                                          "homestay"
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                bookingListBloc
                                                    .eventController.sink
                                                    .add(
                                                        BackwardHomestayEvent());
                                              },
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
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                bookingListBloc
                                                    .eventController.sink
                                                    .add(
                                                        ForwardHomestayEvent());
                                              },
                                              icon: const Icon(
                                                Icons.arrow_forward_ios,
                                                color: secondaryColor,
                                              ),
                                            )
                                          ],
                                        )
                                      : const SizedBox(),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  streamSnapshot.data!.homestayType ==
                                          "homestay"
                                      ? SizedBox(
                                          height: 200,
                                          child: ListView.builder(
                                            itemCount: streamSnapshot.data!
                                                .selectedHomestay()!
                                                .homestayServices!
                                                .length,
                                            itemBuilder: (context, index) {
                                              HomestayServiceModel
                                                  homestayService =
                                                  streamSnapshot.data!
                                                      .selectedHomestay()!
                                                      .homestayServices![index];
                                              return GestureDetector(
                                                onTap: () {
                                                  bookingListBloc
                                                      .eventController.sink
                                                      .add(ChooseNewHomestayServiceEvent(
                                                          homestayService:
                                                              homestayService));
                                                },
                                                child: Container(
                                                  height: 50,
                                                  margin: const EdgeInsets.only(
                                                      bottom: 10,
                                                      left: 10,
                                                      right: 10),
                                                  decoration: BoxDecoration(
                                                      borderRadius: const BorderRadius.all(
                                                          Radius.circular(10)),
                                                      color: streamSnapshot.data!
                                                                  .isServiceBooked(
                                                                      homestayService
                                                                          .id!) &&
                                                              streamSnapshot
                                                                  .data!
                                                                  .isServiceSelected(
                                                                      homestayService
                                                                          .id!)
                                                          ? secondaryColor
                                                          : streamSnapshot.data!
                                                                  .isServiceBooked(
                                                                      homestayService
                                                                          .id!)
                                                              ? Colors.red
                                                              : streamSnapshot
                                                                      .data!
                                                                      .isServiceSelected(homestayService.id!)
                                                                  ? Colors.green
                                                                  : Colors.white),
                                                  child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Expanded(
                                                          flex: 1,
                                                          child: Center(
                                                            child: Text(
                                                              homestayService
                                                                  .name!,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: streamSnapshot
                                                                          .data!
                                                                          .isServiceBooked(homestayService
                                                                              .id!)
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black),
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Center(
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                  "${currencyFormat.format(homestayService.price)}VND",
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: streamSnapshot.data!.isServiceBooked(homestayService
                                                                              .id!)
                                                                          ? Colors
                                                                              .white
                                                                          : Colors
                                                                              .black),
                                                                ),
                                                                const SizedBox(
                                                                  width: 10,
                                                                ),
                                                                streamSnapshot
                                                                            .data!
                                                                            .isServiceBooked(homestayService
                                                                                .id!) &&
                                                                        streamSnapshot
                                                                            .data!
                                                                            .isServiceSelected(homestayService
                                                                                .id!)
                                                                    ? const Icon(
                                                                        Icons
                                                                            .check,
                                                                        color: Colors
                                                                            .white,
                                                                      )
                                                                    : streamSnapshot
                                                                            .data!
                                                                            .isServiceBooked(homestayService.id!)
                                                                        ? const Icon(
                                                                            Icons.delete,
                                                                            color:
                                                                                Colors.white,
                                                                          )
                                                                        : streamSnapshot.data!.isServiceSelected(homestayService.id!)
                                                                            ? const Icon(
                                                                                Icons.add_business,
                                                                                color: Colors.white,
                                                                              )
                                                                            : const SizedBox()
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ]),
                                                ),
                                              );
                                            },
                                          ),
                                        )
                                      : SizedBox(
                                          height: 200,
                                          child: ListView.builder(
                                            itemCount: streamSnapshot
                                                .data!
                                                .booking!
                                                .bloc!
                                                .homestayServices!
                                                .length,
                                            itemBuilder: (context, index) {
                                              HomestayServiceModel
                                                  homestayService =
                                                  streamSnapshot.data!
                                                              .homestayType ==
                                                          "homestay"
                                                      ? streamSnapshot.data!
                                                              .selectedHomestay()!
                                                              .homestayServices![
                                                          index]
                                                      : streamSnapshot
                                                              .data!
                                                              .booking!
                                                              .bloc!
                                                              .homestayServices![
                                                          index];
                                              return GestureDetector(
                                                onTap: () {
                                                  bookingListBloc
                                                      .eventController.sink
                                                      .add(ChooseNewHomestayServiceEvent(
                                                          homestayService:
                                                              homestayService));
                                                },
                                                child: Container(
                                                  height: 50,
                                                  margin: const EdgeInsets.only(
                                                      bottom: 10,
                                                      left: 10,
                                                      right: 10),
                                                  decoration: BoxDecoration(
                                                      borderRadius: const BorderRadius.all(
                                                          Radius.circular(10)),
                                                      color: streamSnapshot.data!
                                                                  .isServiceBooked(
                                                                      homestayService
                                                                          .id!) &&
                                                              streamSnapshot
                                                                  .data!
                                                                  .isServiceSelected(
                                                                      homestayService
                                                                          .id!)
                                                          ? secondaryColor
                                                          : streamSnapshot.data!
                                                                  .isServiceBooked(
                                                                      homestayService
                                                                          .id!)
                                                              ? Colors.red
                                                              : streamSnapshot
                                                                      .data!
                                                                      .isServiceSelected(homestayService.id!)
                                                                  ? Colors.green
                                                                  : Colors.white),
                                                  child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Expanded(
                                                          flex: 1,
                                                          child: Center(
                                                            child: Text(
                                                              homestayService
                                                                  .name!,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: streamSnapshot
                                                                          .data!
                                                                          .isServiceBooked(homestayService
                                                                              .id!)
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black),
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Center(
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                  "${currencyFormat.format(homestayService.price)}VND",
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: streamSnapshot.data!.isServiceBooked(homestayService
                                                                              .id!)
                                                                          ? Colors
                                                                              .white
                                                                          : Colors
                                                                              .black),
                                                                ),
                                                                const SizedBox(
                                                                  width: 10,
                                                                ),
                                                                streamSnapshot
                                                                            .data!
                                                                            .isServiceBooked(homestayService
                                                                                .id!) &&
                                                                        streamSnapshot
                                                                            .data!
                                                                            .isServiceSelected(homestayService
                                                                                .id!)
                                                                    ? const Icon(
                                                                        Icons
                                                                            .check,
                                                                        color: Colors
                                                                            .white,
                                                                      )
                                                                    : streamSnapshot
                                                                            .data!
                                                                            .isServiceBooked(homestayService.id!)
                                                                        ? const Icon(
                                                                            Icons.delete,
                                                                            color:
                                                                                Colors.white,
                                                                          )
                                                                        : streamSnapshot.data!.isServiceSelected(homestayService.id!)
                                                                            ? const Icon(
                                                                                Icons.add_business,
                                                                                color: Colors.white,
                                                                              )
                                                                            : const SizedBox()
                                                              ],
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
                                                  onPressed: () {
                                                    bookingListBloc
                                                        .eventController.sink
                                                        .add(
                                                            CancelUpdateServiceEvent(
                                                                context:
                                                                    context));
                                                  },
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
                                                                          () {
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
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
                                                                            serviceNameList: streamSnapshot.data!.serviceList!.map((e) => e.name!).toList()));
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
                        streamSnapshot.data!.homestayType == "bloc"
                            ? SizedBox(
                                child: Column(children: [
                                  const Text(
                                    "Choose payment method: ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: ListTile(
                                          title: const Text("SWM Wallet"),
                                          leading: Radio<BlocPaymentMethod>(
                                            value: BlocPaymentMethod.swm_wallet,
                                            activeColor: Colors.greenAccent,
                                            groupValue: streamSnapshot
                                                .data!.paymentMethod!,
                                            onChanged: (value) => bookingListBloc
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
                                          leading: Radio<BlocPaymentMethod>(
                                            value: BlocPaymentMethod.cash,
                                            activeColor: Colors.greenAccent,
                                            groupValue: streamSnapshot
                                                .data!.paymentMethod!,
                                            onChanged: (value) => bookingListBloc
                                                .eventController.sink
                                                .add(ChoosePaymentMethodEvent(
                                                    paymentMethod: value)),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ]),
                              )
                            : const SizedBox(),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          "Total booking price: ${currencyFormat.format(streamSnapshot.data!.booking!.totalBookingPrice)}",
                          style: const TextStyle(
                              fontFamily: "Lobster",
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: secondaryColor,
                              minimumSize: const Size(200, 50),
                              maximumSize: const Size(200, 50)),
                          onPressed: () {
                            bookingListBloc.eventController.sink
                                .add(SubmitBookingEvent(context: context));
                          },
                          child: const Text(
                            "Submit",
                            style: TextStyle(
                                fontFamily: "Lobster",
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ]),
                )),
          );
        });
  }
}

class ShowBlocHomestayListScreen extends StatefulWidget {
  const ShowBlocHomestayListScreen({super.key});
  static const showBlocHomestayListScreenRoute = "/show-bloc-homestays";

  @override
  State<ShowBlocHomestayListScreen> createState() =>
      _ShowBlocHomestayListScreenState();
}

class _ShowBlocHomestayListScreenState
    extends State<ShowBlocHomestayListScreen> {
  final imageService = locator<IImageService>();
  final showHomestaysBloc = ShowHomestaysBloc();

  @override
  void dispose() {
    showHomestaysBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ShowHomestaysState>(
        stream: showHomestaysBloc.stateController.stream,
        initialData: showHomestaysBloc.initData(context),
        builder: (context, snapshot) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Block Homestay List"),
              backgroundColor: secondaryColor,
              centerTitle: true,
              automaticallyImplyLeading: false,
              leading: IconButton(
                  onPressed: () {
                    showHomestaysBloc.eventController.sink.add(
                        BackwardToBookingListScreenEvent(context: context));
                  },
                  icon: const Icon(Icons.arrow_back_ios)),
            ),
            backgroundColor: primaryColor,
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                      "${snapshot.data!.bloc!.name!.toUpperCase()}'s Homestay List",
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 500,
                    height: MediaQuery.of(context).size.height,
                    child: ListView.builder(
                        itemCount: snapshot.data!.bloc!.homestays!.length,
                        itemBuilder: (context, index) {
                          HomestayInBlocModel homestay =
                              snapshot.data!.bloc!.homestays![index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    showHomestaysBloc.eventController.sink.add(
                                        SelectHomestayInBlocEvent(
                                            homestay: homestay));
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: <BoxShadow>[
                                          BoxShadow(
                                              blurRadius: 1.0,
                                              blurStyle: BlurStyle.outer,
                                              offset: Offset(2.0, 2.0),
                                              color: Colors.black45)
                                        ]),
                                    child: Row(children: [
                                      Expanded(
                                          flex: 1,
                                          child: FutureBuilder(
                                            future: imageService
                                                .getHomestayImage(snapshot
                                                    .data!
                                                    .bloc!
                                                    .homestays![index]
                                                    .homestayImages!
                                                    .first
                                                    .imageUrl!),
                                            builder: (context, imgSnapshot) {
                                              switch (
                                                  imgSnapshot.connectionState) {
                                                case ConnectionState.waiting:
                                                  return Container(
                                                    width: 30,
                                                    height: 30,
                                                    color: Colors.white24,
                                                  );
                                                case ConnectionState.done:
                                                  final imageData =
                                                      imgSnapshot.data;
                                                  String imageUrl = imageData ??
                                                      "https://i.ytimg.com/vi/0jDUx3jOBfU/mqdefault.jpg";
                                                  return AdvancedAvatar(
                                                    image:
                                                        NetworkImage(imageUrl),
                                                  );
                                                default:
                                                  break;
                                              }
                                              return Container(
                                                margin: const EdgeInsets.only(
                                                    left: 10, right: 10),
                                                width: 30,
                                                height: 30,
                                                color: Colors.white24,
                                              );
                                            },
                                          )),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                          flex: 2,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                homestay.name!,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20),
                                              ),
                                              RatingStars(
                                                animationDuration:
                                                    const Duration(seconds: 4),
                                                maxValue: 5.0,
                                                starColor: secondaryColor,
                                                starBuilder: (index, color) =>
                                                    Icon(
                                                  Icons.star,
                                                  color: color,
                                                  size: 15,
                                                ),
                                                value: homestay
                                                    .totalAverageRating!,
                                                starOffColor:
                                                    Colors.lightBlueAccent,
                                                starCount: 5,
                                                valueLabelVisibility: false,
                                              ),
                                              Text(
                                                utf8.decode(snapshot
                                                    .data!.bloc!.address!.runes
                                                    .toList()),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    flex: 1,
                                                    child: Row(
                                                      children: [
                                                        const Text("Rooms:",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text(
                                                            "${snapshot.data!.bloc!.homestays![index].availableRooms}")
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: Row(
                                                      children: [
                                                        const Text("Capacity:",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text(
                                                            "${snapshot.data!.bloc!.homestays![index].roomCapacity}")
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              )
                                            ],
                                          ))
                                    ]),
                                  ),
                                ),
                                snapshot.data!.isHomestaySelected(homestay) ==
                                        true
                                    ? TweenAnimationBuilder(
                                        tween: Tween<double>(begin: 0, end: 50),
                                        duration: const Duration(seconds: 1),
                                        builder: (context, value, child) =>
                                            SizedBox(
                                          height: value,
                                          child: child,
                                        ),
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                              left: 10, right: 10),
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: snapshot.data!
                                                            .isBlocHomestayBookedByUser(
                                                                homestay) ==
                                                        true
                                                    ? Colors.red
                                                    : snapshot.data!
                                                                .isBlocHomestayFree(
                                                                    homestay) ==
                                                            true
                                                        ? Colors.green
                                                        : Colors.grey,
                                                maximumSize: Size(
                                                    MediaQuery.of(context)
                                                        .size
                                                        .width,
                                                    50),
                                                minimumSize: Size(
                                                    MediaQuery.of(context)
                                                        .size
                                                        .width,
                                                    50)),
                                            onPressed: () {
                                              if (snapshot.data!
                                                  .isBlocHomestayBookedByUser(
                                                      homestay)) {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      AlertDialog(
                                                          title: const Center(
                                                            child:
                                                                Text("Notice"),
                                                          ),
                                                          content: SizedBox(
                                                            width: 100,
                                                            height: 120,
                                                            child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  const Text(
                                                                      "Do you want to delete this homestay from booking?"),
                                                                  const SizedBox(
                                                                    height: 20,
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Expanded(
                                                                        flex: 1,
                                                                        child: ElevatedButton(
                                                                            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                                                            onPressed: () {
                                                                              Navigator.pop(context);
                                                                            },
                                                                            child: const Text("No", style: TextStyle(fontFamily: "Lobster", fontWeight: FontWeight.bold, color: Colors.white))),
                                                                      ),
                                                                      Expanded(
                                                                        flex: 2,
                                                                        child: ElevatedButton(
                                                                            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                                                            onPressed: () {
                                                                              showHomestaysBloc.eventController.sink.add(DeleteBookingHomestayInBlocEvent(homestayId: homestay.id));
                                                                              Navigator.pop(context);
                                                                            },
                                                                            child: const Text("Yes", style: TextStyle(fontFamily: "Lobster", fontWeight: FontWeight.bold, color: Colors.white))),
                                                                      ),
                                                                    ],
                                                                  )
                                                                ]),
                                                          )),
                                                );
                                              } else if (snapshot.data!
                                                  .isBlocHomestayFree(
                                                      homestay)) {
                                                showHomestaysBloc
                                                    .eventController.sink
                                                    .add(AddHomestayInBlocEvent(
                                                        context: context,
                                                        homestayName:
                                                            homestay.name));
                                              }
                                            },
                                            child: Text(
                                                snapshot.data!
                                                            .isBlocHomestayBookedByUser(
                                                                homestay) ==
                                                        true
                                                    ? "Delete"
                                                    : snapshot.data!
                                                                .isBlocHomestayFree(
                                                                    homestay) ==
                                                            true
                                                        ? "Book"
                                                        : "Unavailable",
                                                style: const TextStyle(
                                                    fontFamily: "Lobster",
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white)),
                                          ),
                                        ),
                                      )
                                    : const SizedBox()
                              ],
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
