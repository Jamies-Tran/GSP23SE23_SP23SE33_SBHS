import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:staywithme_passenger_application/bloc/event/passenger_wallet_event.dart';
import 'package:staywithme_passenger_application/bloc/event/payment_history_event.dart';
import 'package:staywithme_passenger_application/bloc/passenger_wallet_bloc.dart';
import 'package:staywithme_passenger_application/bloc/state/passenger_wallet_state.dart';

import 'package:staywithme_passenger_application/global_variable.dart';
import 'package:staywithme_passenger_application/model/booking_model.dart';
import 'package:staywithme_passenger_application/model/passenger_model.dart';
import 'package:staywithme_passenger_application/model/payment_model.dart';
import 'package:staywithme_passenger_application/service/user/payment_service.dart';
import 'package:staywithme_passenger_application/service/user/user_service.dart';
import 'package:staywithme_passenger_application/service_locator/service_locator.dart';

class PassengerWalletScreen extends StatefulWidget {
  const PassengerWalletScreen({super.key});
  static const String passengerWalletScreen = "/passenger-wallet";

  @override
  State<PassengerWalletScreen> createState() => _PassengerWalletScreen();
}

class _PassengerWalletScreen extends State<PassengerWalletScreen> {
  final _paymentService = locator.get<IPaymentService>();
  final _userService = locator.get<IUserService>();
  final passengerWalletBloc = PassengerWalletBloc();

  @override
  void dispose() {
    passengerWalletBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PassengerWalletState>(
        stream: passengerWalletBloc.stateController.stream,
        initialData: passengerWalletBloc.initData(context),
        builder: (context, streamSnapshot) {
          return Scaffold(
            backgroundColor: primaryColor,
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text("Available",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black45,
                            fontSize: 10)),
                    Text(
                      "${currencyFormat.format(streamSnapshot.data!.actualBalance)}đ",
                      style: const TextStyle(
                          fontSize: 25,
                          color: Colors.green,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      width: 25,
                      child: Divider(
                        color: Colors.black45,
                        thickness: 1.0,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              "Total",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black45,
                                  fontSize: 10),
                            ),
                            Text(
                              "${currencyFormat.format(streamSnapshot.data!.totalBalance)}đ",
                              style: const TextStyle(
                                  fontSize: 25,
                                  color: Colors.deepOrange,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              "Deposits",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black45,
                                  fontSize: 10),
                            ),
                            Text(
                              "${currencyFormat.format(streamSnapshot.data!.totalDeposits)}đ",
                              style: const TextStyle(
                                  fontSize: 25,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    streamSnapshot.data!.isPaymentHistory!
                        ? Container(
                            height: 350,
                            width: MediaQuery.of(context).size.width - 10,
                            decoration: BoxDecoration(
                                boxShadow: const [
                                  BoxShadow(
                                      blurRadius: 1.0,
                                      blurStyle: BlurStyle.normal)
                                ],
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white),
                            child: Container(
                              padding:
                                  const EdgeInsets.only(left: 40, right: 40),
                              child: Column(children: [
                                FutureBuilder(
                                  future: _paymentService.getPaymentHistories(
                                      streamSnapshot.data!.user!.username!,
                                      0,
                                      5,
                                      true,
                                      true),
                                  builder: (context, snapshot) {
                                    switch (snapshot.connectionState) {
                                      case ConnectionState.waiting:
                                        return const Center(
                                            child: SpinKitCircle(
                                                color: Colors.orange));
                                      case ConnectionState.done:
                                        final snapshotData = snapshot.data;
                                        if (snapshotData
                                            is PaymentHistoryPagingModel) {
                                          return Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  IconButton(
                                                      onPressed: () {
                                                        // paymentHistoryBloc
                                                        //   .eventController.sink
                                                        //   .add(PreviousPageEvent(
                                                        //       username: username,
                                                        //       context: context,
                                                        //       pageNumber:
                                                        //           snapshotData.pageNumber));
                                                      },
                                                      icon: const Icon(
                                                        Icons.arrow_back_ios,
                                                        color: secondaryColor,
                                                      )),
                                                  Text(
                                                    "Page ${snapshotData.pageNumber! + 1}",
                                                    style: const TextStyle(
                                                        color: primaryColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        letterSpacing: 1.0),
                                                  ),
                                                  IconButton(
                                                      onPressed: () {
                                                        // paymentHistoryBloc
                                                        //   .eventController.sink
                                                        //   .add(NextPageEvent(
                                                        //       username: username,
                                                        //       context: context,
                                                        //       pageNumber:
                                                        //           snapshotData.pageNumber));
                                                      },
                                                      icon: const Icon(
                                                        Icons.arrow_forward_ios,
                                                        color: secondaryColor,
                                                      )),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              SizedBox(
                                                height: 17,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    1.2,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: const [
                                                    Expanded(
                                                      flex: 2,
                                                      child: Text(
                                                        "date",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "Lobster",
                                                            fontSize: 15,
                                                            color:
                                                                Colors.orange,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            letterSpacing: 1.0),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 2,
                                                      child: Text(
                                                        "amount",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "Lobster",
                                                            fontSize: 15,
                                                            color:
                                                                Colors.orange,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            letterSpacing: 1.0),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Text(
                                                        "currency",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "Lobster",
                                                            fontSize: 15,
                                                            color:
                                                                Colors.orange,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            letterSpacing: 1.0),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 100,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    1.2,
                                                child: ListView.builder(
                                                  itemCount: snapshotData
                                                      .paymentHistoriesModel!
                                                      .length,
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  itemBuilder:
                                                      (context, index) => Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                        Expanded(
                                                          flex: 2,
                                                          child: Text(
                                                              "${snapshotData.paymentHistoriesModel![index].createdDate}"),
                                                        ),
                                                        Expanded(
                                                          flex: 2,
                                                          child: Text(currencyFormat
                                                              .format(snapshotData
                                                                  .paymentHistoriesModel![
                                                                      index]
                                                                  .amount)),
                                                        ),
                                                        const Expanded(
                                                          flex: 1,
                                                          child: Text(
                                                            "VND",
                                                          ),
                                                        ),
                                                      ]),
                                                ),
                                              ),
                                            ],
                                          );
                                        }
                                        break;
                                      default:
                                        break;
                                    }
                                    return const SizedBox();
                                  },
                                ),
                              ]),
                            ),
                          )
                        : Container(
                            height: 350,
                            width: MediaQuery.of(context).size.width - 10,
                            decoration: BoxDecoration(
                                boxShadow: const [
                                  BoxShadow(
                                      blurRadius: 1.0,
                                      blurStyle: BlurStyle.normal)
                                ],
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white),
                            child: Container(
                              padding:
                                  const EdgeInsets.only(left: 40, right: 40),
                              child: Column(children: [
                                FutureBuilder(
                                  future: _userService.getPassengerDeposits(
                                      0, 10, true, true),
                                  builder: (context, snapshot) {
                                    switch (snapshot.connectionState) {
                                      case ConnectionState.waiting:
                                        return const Center(
                                            child: SpinKitCircle(
                                                color: Colors.orange));
                                      case ConnectionState.done:
                                        final snapshotData = snapshot.data;
                                        if (snapshotData
                                            is BookingDepositListPagingModel) {
                                          return Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  IconButton(
                                                      onPressed: () {
                                                        passengerWalletBloc
                                                            .eventController
                                                            .sink
                                                            .add(
                                                                PreviousDepositEvent());
                                                      },
                                                      icon: const Icon(
                                                        Icons.arrow_back_ios,
                                                        color: secondaryColor,
                                                      )),
                                                  Text(
                                                    "Page ${snapshotData.pageNumber}",
                                                    style: const TextStyle(
                                                        color: primaryColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        letterSpacing: 1.0),
                                                  ),
                                                  IconButton(
                                                      onPressed: () {
                                                        // passengerWalletBloc
                                                        //     .eventController
                                                        //     .sink
                                                        //     .add(NextDepositEvent(
                                                        //         maxSize:
                                                        //             snapshotData
                                                        //                 .deposits!
                                                        //                 .length));
                                                      },
                                                      icon: const Icon(
                                                        Icons.arrow_forward_ios,
                                                        color: secondaryColor,
                                                      )),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              SizedBox(
                                                height: 17,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    1.2,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: const [
                                                    Expanded(
                                                      flex: 2,
                                                      child: Text(
                                                        "Booking code",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "Lobster",
                                                            fontSize: 15,
                                                            color:
                                                                Colors.orange,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            letterSpacing: 1.0),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Text(
                                                        "Unpaid",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "Lobster",
                                                            fontSize: 15,
                                                            color:
                                                                Colors.orange,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            letterSpacing: 1.0),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Text(
                                                        "Paid",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "Lobster",
                                                            fontSize: 15,
                                                            color:
                                                                Colors.orange,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            letterSpacing: 1.0),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Text(
                                                        "Status",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "Lobster",
                                                            fontSize: 15,
                                                            color:
                                                                Colors.orange,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            letterSpacing: 1.0),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 100,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    1.2,
                                                child: ListView.builder(
                                                  itemCount: snapshotData
                                                      .bookingDeposits!.length,
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  itemBuilder:
                                                      (context, index) {
                                                    BookingDepositModel
                                                        bookingDeposit =
                                                        snapshotData
                                                                .bookingDeposits![
                                                            index];
                                                    return Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Expanded(
                                                            flex: 2,
                                                            child: Text(
                                                                "${bookingDeposit.booking!.code}", style: const TextStyle(fontSize: 13),),
                                                          ),
                                                          Expanded(
                                                            flex: 1,
                                                            child: Text(
                                                                currencyFormat.format(
                                                                    bookingDeposit
                                                                        .unpaidAmount),
                                                                style:  TextStyle(
                                                                    color: bookingDeposit.status! == "PAID" ? Colors.green : Colors.red, fontSize: 13)),
                                                          ),
                                                          Expanded(
                                                            flex: 1,
                                                            child: Text(currencyFormat
                                                                .format(bookingDeposit
                                                                    .paidAmount), style: const TextStyle(fontSize:13),),
                                                          ),
                                                          Expanded(
                                                            flex: 1,
                                                            child: Text(bookingDeposit.status!, style:  TextStyle(fontSize: 13, color: bookingDeposit.status! == "PAID" ? Colors.green : Colors.red),),
                                                          ),
                                                        ]);
                                                  },
                                                ),
                                              ),
                                            ],
                                          );
                                        }
                                        break;
                                      default:
                                        break;
                                    }
                                    return const SizedBox();
                                  },
                                ),
                              ]),
                            ),
                          ),
                    const SizedBox(
                      height: 25,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10, right: 10),
                      width: MediaQuery.of(context).size.width,
                      child: Row(children: [
                        Expanded(
                          flex: 2,
                          child: GestureDetector(
                            onTap: () {
                              passengerWalletBloc.eventController.sink
                                  .add(ChoosePaymentHistoriesEvent());
                            },
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    bottomLeft: Radius.circular(20),
                                  ),
                                  color: streamSnapshot.data!.isPaymentHistory!
                                      ? secondaryColor
                                      : Colors.white),
                              child: const Center(
                                  child: Text(
                                "Payments",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: GestureDetector(
                            onTap: () {
                              passengerWalletBloc.eventController.sink
                                  .add(ChooseDepositsEvent());
                            },
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(20),
                                      bottomRight: Radius.circular(20)),
                                  color: streamSnapshot.data!.isPaymentHistory!
                                      ? Colors.white
                                      : secondaryColor),
                              child: const Center(
                                  child: Text(
                                "Deposits",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                            ),
                          ),
                        ),
                      ]),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Column(
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                maximumSize: const Size(150, 50),
                                minimumSize: const Size(150, 50)),
                            onPressed: () {
                              passengerWalletBloc.eventController.sink
                                  .add(AddBalanceEvent(context: context));
                            },
                            child: const Text(
                              "Add Balance",
                              style: TextStyle(fontFamily: "Lobster"),
                            )),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text("Pay with",
                            style: TextStyle(
                                color: Colors.black45,
                                fontSize: 10,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                          height: 100,
                          width: 100,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage("images/momo_icon.png"))),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
