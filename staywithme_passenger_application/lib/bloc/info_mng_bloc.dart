import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:staywithme_passenger_application/bloc/event/info_mng_event.dart';
import 'package:staywithme_passenger_application/bloc/state/info_mng_state.dart';
import 'package:staywithme_passenger_application/model/booking_model.dart';
import 'package:staywithme_passenger_application/model/exc_model.dart';
import 'package:staywithme_passenger_application/screen/booking/booking_history_screen.dart';
import 'package:staywithme_passenger_application/screen/booking/booking_list_screen.dart';
import 'package:staywithme_passenger_application/screen/main_screen.dart';
import 'package:staywithme_passenger_application/screen/personal/add_balance_screen.dart';
import 'package:staywithme_passenger_application/screen/personal/passenger_wallet_screen.dart';
import 'package:staywithme_passenger_application/service/authentication/google_auth_service.dart';
import 'package:staywithme_passenger_application/service/user/booking_service.dart';
import 'package:staywithme_passenger_application/service_locator/service_locator.dart';

class InfoManagementBloc {
  final eventController = StreamController<InfoManagementEvent>();
  final stateController = StreamController<InfoManagementState>();

  final _fireAuthService = locator.get<IAuthenticateByGoogleService>();
  final _bookingService = locator.get<IBookingService>();
  final formKey = GlobalKey<FormState>();

  final bool _inputInviteCode = false;

  String? _validInviteCode;
  String? _inviteCode = "";

  InfoManagementState initData() => InfoManagementState(
      inputInviteCode: false, validInviteCode: null, inviteCode: "");

  void dispose() {
    eventController.close();
    stateController.close();
  }

  InfoManagementBloc() {
    eventController.stream.listen((event) {
      eventHandler(event);
    });
  }

  Future<void> eventHandler(InfoManagementEvent event) async {
    if (event is NavigateToAddBalanceScreenEvent) {
      Navigator.pushNamed(
          event.context!, AddBalanceScreen.addBalanceScreenRoute,
          arguments: {"username": event.username});
    } else if (event is NavigateToPaymentHistoryScreenEvent) {
      Navigator.pushNamed(
          event.context!, PassengerWalletScreen.passengerWalletScreen,
          arguments: {"user": event.user});
    } else if (event is SignOutEvent) {
      await _fireAuthService.signOut();
      Navigator.pushNamed(event.context!, MainScreen.mainScreenRoute,
          arguments: {"startingIndex": 1});
    } else if (event is NavigateToBookingHistoryScreenEvent) {
      Navigator.pushNamed(
          event.context!, BookingHistoryScreen.bookingHistoryScreenRoute);
    } else if (event is ActiveInputInviteCodeEvent) {
      showDialog(
        context: event.context!,
        builder: (context) => AlertDialog(
          title: const Center(
            child: Text("Enter Invite Code"),
          ),
          content: SizedBox(
            height: 120,
            width: 150,
            child: Column(children: [
              Form(
                key: formKey,
                child: Column(children: [
                  SizedBox(
                    width: 170,
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Invite code empty";
                        }
                        return _validInviteCode;
                      },
                      decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide:
                                  BorderSide(width: 1, color: Colors.black)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide:
                                  BorderSide(width: 1, color: Colors.black)),
                          hintText: "Invite code"),
                      onChanged: (value) => _inviteCode = value,
                    ),
                  ),
                  TextButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          final inviteCodeData = await _bookingService
                              .applyBookingInviteCode(_inviteCode!);
                          if (inviteCodeData is BookingInviteModel) {
                            BookingModel booking = inviteCodeData.booking!;
                            Navigator.pushNamed(event.context!,
                                BookingLoadingScreen.bookingLoadingScreen,
                                arguments: {
                                  "bookingId": booking.id,
                                  "homestayType": booking.homestayType,
                                  "viewDetail": true
                                });
                          } else if (inviteCodeData is ServerExceptionModel) {
                            _validInviteCode = inviteCodeData.message;
                          } else if (inviteCodeData is TimeoutException ||
                              inviteCodeData is SocketException) {
                            _validInviteCode = "Can't connect to server";
                          }
                        }
                      },
                      child: const Text("Apply",
                          style: TextStyle(fontWeight: FontWeight.bold)))
                ]),
              ),
            ]),
          ),
        ),
      );
    } else if (event is InputInviteCodeEvent) {
      if (event.inviteCode == null || event.inviteCode!.isEmpty) {
        _validInviteCode = "Invite code empty";
      } else {
        _inviteCode = event.inviteCode;
      }
    } else if (event is SubmitInviteCodeEvent) {
      final inviteCodeData =
          await _bookingService.applyBookingInviteCode(event.inviteCode!);
      if (inviteCodeData is BookingInviteModel) {
        BookingModel booking = inviteCodeData.booking!;
        Navigator.pushNamed(
            event.context!, BookingLoadingScreen.bookingLoadingScreen,
            arguments: {
              "bookingId": booking.id,
              "homestayType": booking.homestayType
            });
      } else if (inviteCodeData is ServerExceptionModel) {
        _validInviteCode = inviteCodeData.message;
      } else if (inviteCodeData is TimeoutException ||
          inviteCodeData is SocketException) {
        _validInviteCode = "Can't connect to server";
      }
    }

    stateController.sink.add(InfoManagementState(
        inputInviteCode: _inputInviteCode,
        validInviteCode: _validInviteCode,
        inviteCode: _inviteCode));
  }
}
