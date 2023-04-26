import 'package:flutter/material.dart';
import 'package:staywithme_passenger_application/bloc/choose_date_block_bloc.dart';
import 'package:staywithme_passenger_application/bloc/choose_date_homestay_bloc.dart';
import 'package:staywithme_passenger_application/bloc/event/choose_date_block_event.dart';
import 'package:staywithme_passenger_application/bloc/event/choose_date_homestay_event.dart';
import 'package:staywithme_passenger_application/bloc/state/choose_date_block_state.dart';
import 'package:staywithme_passenger_application/bloc/state/choose_date_homestay_state.dart';
import 'package:staywithme_passenger_application/global_variable.dart';

class ChooseBookingDateForHomestayScreen extends StatefulWidget {
  const ChooseBookingDateForHomestayScreen({super.key});

  static const chooseBookingDateForHomestayScreenRoute =
      "/booking-date-homestay";

  @override
  State<ChooseBookingDateForHomestayScreen> createState() =>
      _ChooseBookingDateForHomestayScreenState();
}

class _ChooseBookingDateForHomestayScreenState
    extends State<ChooseBookingDateForHomestayScreen> {
  final chooseDateForHomestayBloc = ChooseDateForHomestayBloc();
  final bookingStartDateTextEditingController = TextEditingController();
  final bookingEndDateTextEditingController = TextEditingController();

  @override
  void dispose() {
    chooseDateForHomestayBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ChooseDateForHomestayState>(
        stream: chooseDateForHomestayBloc.stateController.stream,
        initialData: chooseDateForHomestayBloc.initData(context),
        builder: (context, streamSnapshot) {
          if (streamSnapshot.data!.brownseHomestayFlag!) {
            bookingStartDateTextEditingController.text =
                streamSnapshot.data!.bookingStart!;
            bookingEndDateTextEditingController.text =
                streamSnapshot.data!.bookingEnd!;
          }
          return Scaffold(
            backgroundColor: primaryColor,
            body: Center(
                child: Container(
              width: 350,
              height: 200,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const <BoxShadow>[
                    BoxShadow(
                        blurRadius: 1.0,
                        blurStyle: BlurStyle.outer,
                        color: Colors.black,
                        offset: Offset(2.0, 2.0)),
                  ],
                  color: Colors.white),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Choose Date",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                          controller: bookingStartDateTextEditingController,
                          readOnly: true,
                          decoration: InputDecoration(
                              hintText: "Start date",
                              enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: secondaryColor, width: 1.0)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(
                                      color: secondaryColor, width: 1.0))),
                          onTap: () {
                            if (!streamSnapshot.data!.brownseHomestayFlag!) {
                              showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.now()
                                          .add(const Duration(days: 365)))
                                  .then((value) {
                                bookingStartDateTextEditingController.text =
                                    dateFormat.format(value!);
                              });
                            }
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                          controller: bookingEndDateTextEditingController,
                          readOnly: true,
                          decoration: const InputDecoration(
                            hintText: "End date",
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: secondaryColor, width: 1.0)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: secondaryColor, width: 1.0)),
                          ),
                          onTap: () {
                            if (!streamSnapshot.data!.brownseHomestayFlag!) {
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
                                          .add(const Duration(days: 365)))
                                  .then((value) {
                                bookingEndDateTextEditingController.text =
                                    dateFormat.format(value!);
                                chooseDateForHomestayBloc.eventController.sink
                                    .add(CheckValidBookingDateEvent(
                                  bookingStart:
                                      bookingStartDateTextEditingController
                                          .text,
                                  bookingEnd:
                                      bookingEndDateTextEditingController.text,
                                ));
                              });
                            }
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                    ],
                  ),
                  streamSnapshot.data!.msg != null
                      ? Text(
                          streamSnapshot.data!.msg!,
                          style: TextStyle(
                              color: streamSnapshot.data!.msgFontColor),
                        )
                      : const SizedBox(),
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size(200, 50),
                            maximumSize: const Size(200, 50),
                            backgroundColor:
                                streamSnapshot.data!.isBookingValid == true ||
                                        streamSnapshot
                                                .data!.brownseHomestayFlag ==
                                            true
                                    ? Colors.green
                                    : Colors.grey),
                        onPressed: () {
                          if (streamSnapshot.data!.isBookingValid == true ||
                              streamSnapshot.data!.brownseHomestayFlag ==
                                  true) {
                            // chooseDateForHomestayBloc
                            //     .eventController
                            //     .sink
                            //     .add(CreateBookingEvent(
                            //         context:
                            //             context,
                            //         homestay: data,
                            //         bookingStart:
                            //             bookingStartDateTextEditingController
                            //                 .text,
                            //         bookingEnd:
                            //             bookingEndDateTextEditingController
                            //                 .text));
                            chooseDateForHomestayBloc.eventController.sink.add(
                                CreateBookingEvent(
                                    bookingStart:
                                        bookingStartDateTextEditingController
                                            .text,
                                    bookingEnd:
                                        bookingEndDateTextEditingController
                                            .text,
                                    context: context));
                          }
                        },
                        child: const Text(
                          "Book",
                          style: TextStyle(
                              fontFamily: "Lobster",
                              fontWeight: FontWeight.bold),
                        )),
                  ),
                  const SizedBox(
                    height: 20,
                  )
                ],
              ),
            )),
          );
        });
  }
}

class ChooseBookingDateForBlocHomestayScreen extends StatefulWidget {
  const ChooseBookingDateForBlocHomestayScreen({super.key});
  static const chooseBookingDateForBlocHomestayScreenRoute =
      "/booking-date-bloc";

  @override
  State<ChooseBookingDateForBlocHomestayScreen> createState() =>
      _ChooseBookingDateForBlocScreenState();
}

class _ChooseBookingDateForBlocScreenState
    extends State<ChooseBookingDateForBlocHomestayScreen> {
  final bookingStartDateTextEditingController = TextEditingController();
  final bookingEndDateTextEditingController = TextEditingController();
  final chooseDateForBlocHomestayBloc = ChooseDateForBlocHomestayBloc();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ChooseDateForBlocHomestayState>(
        stream: chooseDateForBlocHomestayBloc.stateController.stream,
        initialData: chooseDateForBlocHomestayBloc.initData(context),
        builder: (context, streamSnapshot) {
          return Scaffold(
            backgroundColor: primaryColor,
            body: Center(
                child: Container(
              width: 350,
              height: 200,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const <BoxShadow>[
                    BoxShadow(
                        blurRadius: 1.0,
                        blurStyle: BlurStyle.outer,
                        color: Colors.black,
                        offset: Offset(2.0, 2.0)),
                  ],
                  color: Colors.white),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Choose Date",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            controller: bookingStartDateTextEditingController,
                            readOnly: true,
                            decoration: InputDecoration(
                                hintText: "Start date",
                                enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: secondaryColor, width: 1.0)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: const BorderSide(
                                        color: secondaryColor, width: 1.0))),
                            onTap: () {
                              showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.now()
                                          .add(const Duration(days: 365)))
                                  .then((value) {
                                bookingStartDateTextEditingController.text =
                                    dateFormat.format(value!);
                              });
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            controller: bookingEndDateTextEditingController,
                            readOnly: true,
                            decoration: const InputDecoration(
                              hintText: "End date",
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: secondaryColor, width: 1.0)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: secondaryColor, width: 1.0)),
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
                                          .add(const Duration(days: 365)))
                                  .then((value) {
                                bookingEndDateTextEditingController.text =
                                    dateFormat.format(value!);
                                chooseDateForBlocHomestayBloc
                                    .eventController.sink
                                    .add(GetAvailableHomestayListInBlocEvent(
                                  bookingStart:
                                      bookingStartDateTextEditingController
                                          .text,
                                  bookingEnd:
                                      bookingEndDateTextEditingController.text,
                                ));
                              });
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        )
                      ],
                    ),
                    streamSnapshot.data!.msg != null
                        ? Text(
                            streamSnapshot.data!.msg!,
                            style: TextStyle(
                                color: streamSnapshot.data!.msgFontColor),
                          )
                        : const SizedBox(),
                    const SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              minimumSize: const Size(200, 50),
                              maximumSize: const Size(200, 50),
                              backgroundColor:
                                  streamSnapshot.data!.isBookingValid == true
                                      ? primaryColor
                                      : Colors.grey),
                          onPressed: () {
                            if (streamSnapshot.data!.isBookingValid == true) {
                              chooseDateForBlocHomestayBloc.eventController.sink
                                  .add(CreateBookingForBlocEvent(
                                      context: context,
                                      bookingStart:
                                          bookingStartDateTextEditingController
                                              .text,
                                      bookingEnd:
                                          bookingEndDateTextEditingController
                                              .text));
                              // homestayDetailBloc
                              //     .eventController.sink
                              //     .add(CreateBookingEvent(
                              //         context: context,
                              //         homestayName: data.name,
                              //         homestayId: data.id,
                              //         bookingStart:
                              //             bookingStartDateTextEditingController
                              //                 .text,
                              //         bookingEnd:
                              //             bookingEndDateTextEditingController
                              //                 .text));
                            }
                          },
                          child: const Text(
                            "Book",
                            style: TextStyle(
                                fontFamily: "Lobster",
                                fontWeight: FontWeight.bold),
                          )),
                    )
                  ]),
            )),
          );
        });
  }
}
