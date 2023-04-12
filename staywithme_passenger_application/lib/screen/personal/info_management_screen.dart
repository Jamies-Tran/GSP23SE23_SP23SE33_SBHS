import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_advanced_avatar/flutter_advanced_avatar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:staywithme_passenger_application/bloc/event/info_mng_event.dart';
import 'package:staywithme_passenger_application/bloc/info_mng_bloc.dart';
import 'package:staywithme_passenger_application/bloc/state/info_mng_state.dart';
import 'package:staywithme_passenger_application/global_variable.dart';
import 'package:staywithme_passenger_application/model/exc_model.dart';

import 'package:staywithme_passenger_application/model/passenger_model.dart';
import 'package:staywithme_passenger_application/service/authentication/google_auth_service.dart';
import 'package:staywithme_passenger_application/service/user/user_service.dart';
import 'package:staywithme_passenger_application/service_locator/service_locator.dart';

class PassengerInfoManagementScreen extends StatefulWidget {
  const PassengerInfoManagementScreen({super.key, this.username});
  final String? username;
  static const passengerInfoManagementScreenRoute = "/info-management";

  @override
  State<PassengerInfoManagementScreen> createState() =>
      _PassengerInfoManagementScreenState();
}

class _PassengerInfoManagementScreenState
    extends State<PassengerInfoManagementScreen> {
  final fireAuthService = locator.get<IAuthenticateByGoogleService>();
  final userService = locator.get<IUserService>();
  final totalBalanceTextEditingController = TextEditingController();
  final infoManagementBloc = InfoManagementBloc();
  final inputInviteCodeEditingController = TextEditingController();

  @override
  void dispose() {
    infoManagementBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<InfoManagementState>(
        stream: infoManagementBloc.stateController.stream,
        initialData: infoManagementBloc.initData(),
        builder: (context, streamSnapshot) {
          return Scaffold(
            body: SafeArea(
              child: FutureBuilder(
                  future: userService
                      .getPassengerPersonalInformation(widget.username!),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                primaryColor,
                                Colors.white,
                                secondaryColor
                              ])),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                SpinKitCircle(
                                  color: Colors.amber,
                                ),
                                Text("Getting your information")
                              ],
                            ),
                          ),
                        );
                      case ConnectionState.done:
                        final data = snapshot.data;
                        if (data is PassengerModel) {
                          totalBalanceTextEditingController.text =
                              "${currencyFormat.format(data.passengerPropertyModel!.balanceWalletModel!.totalBalance)} VND";
                          return Container(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                  primaryColor,
                                  Colors.white,
                                  secondaryColor
                                ])),
                            // margin: const EdgeInsets.only(top: 50),
                            child: SingleChildScrollView(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Center(
                                  child: Column(children: [
                                    const SizedBox(
                                      height: 25,
                                    ),
                                    const AdvancedAvatar(
                                      image: AssetImage("images/swm.png"),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      utf8.decode(
                                          data.username!.runes.toList()),
                                      style: const TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.attach_money,
                                            color: secondaryColor,
                                            size: 20,
                                          ),
                                          Text(currencyFormat.format(data
                                              .passengerPropertyModel!
                                              .balanceWalletModel!
                                              .totalBalance)),
                                          const SizedBox(
                                            width: 25,
                                          ),
                                          const Icon(
                                            Icons.house,
                                            color: secondaryColor,
                                            size: 20,
                                          ),
                                          const Text("0"),
                                          const SizedBox(
                                            width: 25,
                                          ),
                                          const Icon(
                                            Icons.wallet_giftcard,
                                            color: secondaryColor,
                                            size: 20,
                                          ),
                                          const Text("0")
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 50,
                                    ),
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20)),
                                                side: BorderSide(
                                                    width: 1.0,
                                                    color: Colors.black45)),
                                            backgroundColor: Colors.white,
                                            foregroundColor: Colors.black45,
                                            maximumSize: Size(
                                                MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    1.5,
                                                50),
                                            minimumSize: Size(
                                                MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    1.5,
                                                50)),
                                        onPressed: () {
                                          infoManagementBloc
                                              .eventController.sink
                                              .add(
                                                  NavigateToBookingHistoryScreenEvent(
                                                      context: context));
                                        },
                                        child: const Text(
                                          "Booking",
                                          style:
                                              TextStyle(fontFamily: "Lobster"),
                                        )),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20)),
                                                side: BorderSide(
                                                    width: 1.0,
                                                    color: Colors.black45)),
                                            backgroundColor: Colors.white,
                                            foregroundColor: Colors.black45,
                                            maximumSize: Size(
                                                MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    1.5,
                                                50),
                                            minimumSize: Size(
                                                MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    1.5,
                                                50)),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              content: SizedBox(
                                                  height: 600,
                                                  child: Center(
                                                    child: Column(children: [
                                                      const Text(
                                                        "Total",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "Lobster",
                                                            fontWeight:
                                                                FontWeight
                                                                    .w300),
                                                      ),
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(50),
                                                        width: 200,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          border: const Border
                                                                  .fromBorderSide(
                                                              BorderSide(
                                                                  color: Colors
                                                                      .black45,
                                                                  width: 1.0)),
                                                        ),
                                                        child: Center(
                                                            child: Text(
                                                          "${currencyFormat.format(data.passengerPropertyModel!.balanceWalletModel!.totalBalance)} VND",
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .green),
                                                        )),
                                                      ),
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                      const Text(
                                                        "Deposits",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "Lobster",
                                                            fontWeight:
                                                                FontWeight
                                                                    .w300),
                                                      ),
                                                      Container(
                                                        width: 200,
                                                        padding:
                                                            const EdgeInsets
                                                                .all(50),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          border: const Border
                                                                  .fromBorderSide(
                                                              BorderSide(
                                                                  color: Colors
                                                                      .black45,
                                                                  width: 1.0)),
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            "- ${currencyFormat.format(data.passengerPropertyModel!.balanceWalletModel!.passengerWalletModel!.totalDeposit())} VND",
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .red),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                      const Text(
                                                        "Available",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "Lobster",
                                                            fontWeight:
                                                                FontWeight
                                                                    .w300),
                                                      ),
                                                      Container(
                                                        width: 200,
                                                        padding:
                                                            const EdgeInsets
                                                                .all(50),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          border: const Border
                                                                  .fromBorderSide(
                                                              BorderSide(
                                                                  color: Colors
                                                                      .black45,
                                                                  width: 1.0)),
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            "${currencyFormat.format(data.passengerPropertyModel!.balanceWalletModel!.actualBalance)} VND",
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .orange,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis),
                                                          ),
                                                        ),
                                                      ),
                                                    ]),
                                                  )),
                                              actions: [
                                                ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                        backgroundColor:
                                                            Colors.orange,
                                                        maximumSize: Size(
                                                            MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                2,
                                                            50),
                                                        minimumSize: Size(
                                                            MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                3,
                                                            50)),
                                                    onPressed: () {
                                                      infoManagementBloc
                                                          .eventController.sink
                                                          .add(NavigateToPaymentHistoryScreenEvent(
                                                              context: context,
                                                              username: data
                                                                  .username));
                                                    },
                                                    child: const Text(
                                                        "Payment history")),
                                                ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                        backgroundColor:
                                                            Colors.green,
                                                        maximumSize: Size(
                                                            MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                3,
                                                            50),
                                                        minimumSize: Size(
                                                            MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                3,
                                                            50)),
                                                    onPressed: () {
                                                      infoManagementBloc
                                                          .eventController
                                                          .add(NavigateToAddBalanceScreenEvent(
                                                              context: context,
                                                              username: data
                                                                  .username));
                                                    },
                                                    child: const Text(
                                                        "Add balance"))
                                              ],
                                            ),
                                          );
                                        },
                                        child: const Text(
                                          "Wallet",
                                          style:
                                              TextStyle(fontFamily: "Lobster"),
                                        )),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20)),
                                                side: BorderSide(
                                                    width: 1.0,
                                                    color: Colors.black45)),
                                            backgroundColor: Colors.white,
                                            foregroundColor: Colors.black45,
                                            maximumSize: Size(
                                                MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    1.5,
                                                50),
                                            minimumSize: Size(
                                                MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    1.5,
                                                50)),
                                        onPressed: () {},
                                        child: const Text(
                                          "Promotions",
                                          style:
                                              TextStyle(fontFamily: "Lobster"),
                                        )),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20)),
                                                side: BorderSide(
                                                    width: 1.0,
                                                    color: Colors.black45)),
                                            backgroundColor: Colors.white,
                                            foregroundColor: Colors.black45,
                                            maximumSize: Size(
                                                MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    1.5,
                                                50),
                                            minimumSize: Size(
                                                MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    1.5,
                                                50)),
                                        onPressed: () {
                                          infoManagementBloc
                                              .eventController.sink
                                              .add(ActiveInputInviteCodeEvent(
                                                  context: context));
                                        },
                                        child: const Text(
                                          "Invite Code",
                                          style:
                                              TextStyle(fontFamily: "Lobster"),
                                        )),
                                    const SizedBox(
                                      height: 50,
                                    ),
                                    const Text(
                                      "Change account",
                                      style: TextStyle(
                                          fontFamily: "Lobster",
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 50,
                                    ),
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            maximumSize: Size(
                                                MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    1.5,
                                                50),
                                            minimumSize: Size(
                                                MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    1.5,
                                                50),
                                            backgroundColor: secondaryColor),
                                        onPressed: () => infoManagementBloc
                                            .eventController.sink
                                            .add(
                                                SignOutEvent(context: context)),
                                        child: const Text(
                                          "sign out",
                                          style: TextStyle(
                                              fontFamily: "Lobster",
                                              fontWeight: FontWeight.bold),
                                        ))
                                  ]),
                                )
                              ],
                            )),
                          );
                        } else if (data is ServerExceptionModel) {
                          infoManagementBloc.eventController.sink
                              .add(SignOutEvent(context: context));
                          return const SizedBox();
                        } else if (data is SocketException ||
                            data is TimeoutException) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  "Something wrong with server",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "Please try again later",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return const SizedBox();
                        }

                      default:
                        break;
                    }
                    return const Center(
                      child: SpinKitCircle(color: Colors.amber),
                    );
                  }),
            ),
          );
        });
  }
}
