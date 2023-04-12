import 'dart:async';

import 'package:flutter/material.dart';
import 'package:staywithme_passenger_application/bloc/event/info_loading_event.dart';
import 'package:staywithme_passenger_application/screen/main_screen.dart';
import 'package:staywithme_passenger_application/screen/personal/info_management_screen.dart';
import 'package:staywithme_passenger_application/service/authentication/google_auth_service.dart';
import 'package:staywithme_passenger_application/service_locator/service_locator.dart';

class InfoLoadingBloc {
  final eventController = StreamController<InfoLoadingEvent>();

  final _firebaseAuthService = locator.get<IAuthenticateByGoogleService>();

  void dispose() {
    eventController.close();
  }

  InfoLoadingBloc() {
    eventController.stream.listen((event) {
      eventHandler(event);
    });
  }

  Future<void> eventHandler(InfoLoadingEvent event) async {
    if (event is OnLoadUserInfoEvent) {
      Navigator.pushNamed(event.context!,
          PassengerInfoManagementScreen.passengerInfoManagementScreenRoute,
          arguments: {"user": event.user});
    } else if (event is SignOutOnErrorEvent) {
      await _firebaseAuthService.signOut();
      Navigator.pushReplacementNamed(event.context!, MainScreen.mainScreenRoute,
          arguments: {"startingIndex": 1});
    }
  }
}
