import 'package:flutter/material.dart';
import 'package:staywithme_passenger_application/bloc/booking_history_bloc.dart';
import 'package:staywithme_passenger_application/bloc/event/booking_history_event.dart';
import 'package:staywithme_passenger_application/bloc/state/booking_history_state.dart';
import 'package:staywithme_passenger_application/global_variable.dart';
import 'package:staywithme_passenger_application/model/booking_model.dart';
import 'package:staywithme_passenger_application/service/user/booking_service.dart';
import 'package:staywithme_passenger_application/service_locator/service_locator.dart';

class BookingHistoryScreen extends StatefulWidget {
  const BookingHistoryScreen({super.key});
  static const String bookingHistoryScreenRoute = "/booking-history";

  @override
  State<BookingHistoryScreen> createState() => _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends State<BookingHistoryScreen> {
  final bookingHistoryBloc = BookingHistoryBloc();
  final bookingService = locator.get<IBookingService>();

  @override
  void dispose() {
    bookingHistoryBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: StreamBuilder<BookingHistoryState>(
          stream: bookingHistoryBloc.stateController.stream,
          initialData: bookingHistoryBloc.initData(),
          builder: (context, streamSnapshot) {
            return SafeArea(
              child: SingleChildScrollView(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
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
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              bookingHistoryBloc.eventController.sink.add(
                                  ChooseHostOrGuestHomestayEvent(isHost: true));
                            },
                            child: Container(
                              height: 50,
                              width: 170,
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      bottomLeft: Radius.circular(20)),
                                  color: streamSnapshot.data!.isHost!
                                      ? Colors.redAccent
                                      : Colors.white),
                              child: Center(
                                child: Text(
                                  "Host",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: streamSnapshot.data!.isHost!
                                          ? Colors.white
                                          : Colors.black),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              bookingHistoryBloc.eventController.sink.add(
                                  ChooseHostOrGuestHomestayEvent(
                                      isHost: false));
                            },
                            child: Container(
                              height: 50,
                              width: 170,
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(20),
                                      bottomRight: Radius.circular(20)),
                                  color: streamSnapshot.data!.isHost!
                                      ? Colors.white
                                      : Colors.redAccent),
                              child: Center(
                                child: Text(
                                  "Guest",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: streamSnapshot.data!.isHost!
                                          ? Colors.black
                                          : Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ]),
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
                        SizedBox(
                          width: 150,
                          child: DecoratedBox(
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    bottomLeft: Radius.circular(10)),
                                color: Colors.grey),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: DropdownButton(
                                items: List<DropdownMenuItem<String>>.from(
                                    streamSnapshot.data!.homestayTypeList
                                        .map((e) => DropdownMenuItem(
                                              value: e,
                                              child: Text(
                                                e,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),
                                            ))),
                                icon: const Icon(
                                  Icons.house,
                                  color: Colors.black,
                                ),
                                onChanged: (value) {
                                  bookingHistoryBloc.eventController.sink.add(
                                      ChooseHomestayTypeEvent(
                                          homestayType: value));
                                },
                                value: streamSnapshot.data!.homestayType,
                                underline: Container(),
                                isExpanded: true,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 150,
                          child: DecoratedBox(
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    bottomRight: Radius.circular(10)),
                                color: Colors.grey),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: DropdownButton(
                                items: List<DropdownMenuItem<String>>.from(
                                    streamSnapshot.data!.statusList
                                        .map((e) => DropdownMenuItem(
                                            value: e,
                                            child: Text(
                                              e,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                            )))),
                                icon: const Icon(
                                  Icons.access_alarm_rounded,
                                  color: Colors.black,
                                ),
                                onChanged: (value) {
                                  bookingHistoryBloc.eventController.sink.add(
                                      ChooseHomestayStatusEvent(status: value));
                                },
                                value: streamSnapshot.data!.status,
                                isExpanded: true,
                                underline: Container(),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  FutureBuilder(
                    future: bookingService.getBookingHistory(
                        streamSnapshot.data!.filterBookingModel(),
                        0,
                        5,
                        true,
                        true),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return const SizedBox();
                        case ConnectionState.done:
                          if (snapshot.hasData) {
                            final bookingHistoryData = snapshot.data;
                            if (bookingHistoryData is BookingHistoryModel) {
                              if (bookingHistoryData.bookings!.isNotEmpty) {
                                return SizedBox(
                                  height: 500,
                                  child: ListView.builder(
                                    itemCount:
                                        bookingHistoryData.bookings!.length,
                                    itemBuilder: (context, index) {
                                      return TweenAnimationBuilder(
                                        tween: Tween<double>(begin: 0, end: 1),
                                        duration: Duration(seconds: index + 2),
                                        builder: (context, value, child) =>
                                            Opacity(
                                          opacity: value,
                                          child: child,
                                        ),
                                        child: TweenAnimationBuilder(
                                          tween:
                                              Tween<double>(begin: 0, end: 10),
                                          duration:
                                              Duration(seconds: index + 3),
                                          builder: (context, value, child) =>
                                              Container(
                                            margin:
                                                EdgeInsets.only(bottom: value),
                                            child: child,
                                          ),
                                          child: GestureDetector(
                                            onTap: () {
                                              bookingHistoryBloc
                                                  .eventController.sink
                                                  .add(ViewBookingDetailEvent(
                                                      context: context,
                                                      bookingId:
                                                          bookingHistoryData
                                                              .bookings![index]
                                                              .id,
                                                      homestayType:
                                                          bookingHistoryData
                                                              .bookings![index]
                                                              .homestayType!
                                                              .toLowerCase()));
                                            },
                                            child: Container(
                                              height: 220,
                                              padding: const EdgeInsets.all(10),
                                              margin: const EdgeInsets.only(
                                                  left: 10,
                                                  right: 10,
                                                  bottom: 10),
                                              decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(20)),
                                                  color: Colors.white,
                                                  boxShadow: <BoxShadow>[
                                                    BoxShadow(
                                                        blurRadius: 1.0,
                                                        blurStyle:
                                                            BlurStyle.outer,
                                                        offset:
                                                            Offset(2.0, 2.0),
                                                        color: Colors.black)
                                                  ]),
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      bookingHistoryData
                                                          .bookings![index]
                                                          .code!,
                                                      style: const TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          flex: 1,
                                                          child: Row(
                                                            children: [
                                                              const Icon(
                                                                Icons.schedule,
                                                                color:
                                                                    secondaryColor,
                                                              ),
                                                              const SizedBox(
                                                                width: 5,
                                                              ),
                                                              Text(
                                                                bookingHistoryData
                                                                    .bookings![
                                                                        index]
                                                                    .bookingFrom!,
                                                                style: const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        Expanded(
                                                            flex: 1,
                                                            child: Row(
                                                              children: [
                                                                const Icon(
                                                                  Icons
                                                                      .schedule,
                                                                  color:
                                                                      secondaryColor,
                                                                ),
                                                                const SizedBox(
                                                                  width: 5,
                                                                ),
                                                                Text(
                                                                  bookingHistoryData
                                                                      .bookings![
                                                                          index]
                                                                      .bookingTo!,
                                                                  style: const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                )
                                                              ],
                                                            ))
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 15,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          flex: 1,
                                                          child: SizedBox(
                                                            child:
                                                                Row(children: [
                                                              const Icon(
                                                                Icons
                                                                    .holiday_village,
                                                                color:
                                                                    secondaryColor,
                                                              ),
                                                              const SizedBox(
                                                                width: 5,
                                                              ),
                                                              Text(
                                                                "${bookingHistoryData.bookings![index].bookingHomestays!.length} - Homestay(s)",
                                                                style: const TextStyle(
                                                                    letterSpacing:
                                                                        1.0),
                                                              )
                                                            ]),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: SizedBox(
                                                            child:
                                                                Row(children: [
                                                              const Icon(
                                                                Icons
                                                                    .attach_money_outlined,
                                                                color:
                                                                    secondaryColor,
                                                              ),
                                                              Text(
                                                                "${currencyFormat.format(bookingHistoryData.bookings![index].totalBookingPrice)} VND",
                                                                style: const TextStyle(
                                                                    letterSpacing:
                                                                        1.0),
                                                              )
                                                            ]),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 15,
                                                    ),
                                                    bookingHistoryData
                                                                .bookings![
                                                                    index]
                                                                .homestayType! ==
                                                            "HOMESTAY"
                                                        ? Column(
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Expanded(
                                                                    flex: 1,
                                                                    child:
                                                                        SizedBox(
                                                                      child: Row(
                                                                          children: [
                                                                            const Text(
                                                                              "Pending(s):",
                                                                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber),
                                                                            ),
                                                                            const SizedBox(
                                                                              width: 5,
                                                                            ),
                                                                            Text("${bookingHistoryData.bookings![index].bookingHomestays!.where((e) => e.status == "PENDING").toList().isEmpty ? 0 : bookingHistoryData.bookings![index].bookingHomestays!.where((e) => e.status == "PENDING").toList().length}")
                                                                          ]),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 1,
                                                                    child:
                                                                        SizedBox(
                                                                      child: Row(
                                                                          children: [
                                                                            const Text(
                                                                              "Accepted(s):",
                                                                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.greenAccent),
                                                                            ),
                                                                            const SizedBox(
                                                                              width: 5,
                                                                            ),
                                                                            Text("${bookingHistoryData.bookings![index].bookingHomestays!.where((e) => e.status == "ACCEPTED").toList().isEmpty ? 0 : bookingHistoryData.bookings![index].bookingHomestays!.where((e) => e.status == "ACCEPTED").toList().length}")
                                                                          ]),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              const SizedBox(
                                                                height: 15,
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Expanded(
                                                                      flex: 1,
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          const Text(
                                                                            "Checked-in(s):",
                                                                            style:
                                                                                TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold),
                                                                          ),
                                                                          const SizedBox(
                                                                            width:
                                                                                5,
                                                                          ),
                                                                          Text(
                                                                              "${bookingHistoryData.bookings![index].bookingHomestays!.where((e) => e.status == "CHECKEDIN").toList().length}")
                                                                        ],
                                                                      )),
                                                                  Expanded(
                                                                      flex: 1,
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          const Text(
                                                                            "Checked-out(s):",
                                                                            style:
                                                                                TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold),
                                                                          ),
                                                                          const SizedBox(
                                                                            width:
                                                                                5,
                                                                          ),
                                                                          Text(
                                                                              "${bookingHistoryData.bookings![index].bookingHomestays!.where((e) => e.status == "CHECKEDOUT").toList().length}")
                                                                        ],
                                                                      ))
                                                                ],
                                                              ),
                                                              const SizedBox(
                                                                height: 15,
                                                              ),
                                                              SizedBox(
                                                                child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      const Text(
                                                                        "Rejected(s):",
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color: Colors.redAccent),
                                                                      ),
                                                                      const SizedBox(
                                                                        width:
                                                                            5,
                                                                      ),
                                                                      Text(
                                                                          "${bookingHistoryData.bookings![index].bookingHomestays!.where((e) => e.status == "REJECTED").toList().isEmpty ? 0 : bookingHistoryData.bookings![index].bookingHomestays!.where((e) => e.status == "REJECTED").toList().length}")
                                                                    ]),
                                                              )
                                                            ],
                                                          )
                                                        : Row(children: [
                                                            const Expanded(
                                                              flex: 1,
                                                              child: Text(
                                                                "Status:",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color:
                                                                        secondaryColor),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              flex: 1,
                                                              child: Text(
                                                                bookingHistoryData
                                                                    .bookings![
                                                                        index]
                                                                    .status!,
                                                                style: TextStyle(
                                                                    fontWeight: FontWeight.bold,
                                                                    color: bookingHistoryData.bookings![index].status! == "PENDING"
                                                                        ? Colors.amber
                                                                        : bookingHistoryData.bookings![index].status! == "ACCEPTED"
                                                                            ? Colors.greenAccent
                                                                            : bookingHistoryData.bookings![index].status! == "REJECTED"
                                                                                ? Colors.redAccent
                                                                                : Colors.black),
                                                              ),
                                                            )
                                                          ]),
                                                  ]),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              } else {
                                return const Center(
                                  child: Text(
                                    "Currently, you don't have any booking.",
                                    style: TextStyle(
                                        fontFamily: "Lobster",
                                        fontWeight: FontWeight.bold),
                                  ),
                                );
                              }
                            }
                          } else {
                            return const SizedBox();
                          }
                          return Container();
                        default:
                          break;
                      }
                      return const SizedBox();
                    },
                  )
                ],
              )),
            );
          }),
    );
  }
}
