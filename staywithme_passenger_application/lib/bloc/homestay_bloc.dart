import 'dart:async';

import 'package:flutter/material.dart';
import 'package:staywithme_passenger_application/bloc/event/homestay_event.dart';
import 'package:staywithme_passenger_application/screen/homestay/bloc_detail_screen.dart';
import 'package:staywithme_passenger_application/screen/homestay/homestay_detail_screen.dart';
import 'package:staywithme_passenger_application/screen/homestay/search_homestay_screen.dart';

class HomestayBloc {
  final eventController = StreamController<HomestayEvent>();

  HomestayBloc() {
    eventController.stream.listen((event) {
      eventHandler(event);
    });
  }

  void eventHandler(HomestayEvent event) {
    if (event is OnClickSearchTextFieldEvent) {
      Navigator.pushNamed(
          event.context!, SearchHomestayScreen.searchHomestayScreenRoute,
          arguments: {"position": event.position, "homestayType": "homestay"});
    } else if (event is OnClickAreaEvent) {
      Navigator.pushNamed(
          event.context!, SearchHomestayScreen.searchHomestayScreenRoute,
          arguments: {
            "position": event.position,
            "homestayType": event.homestayType,
            "searchString": event.cityProvince
          });
    } else if (event is OnClickCampaignEvent) {
      Navigator.pushNamed(
          event.context!, SearchHomestayScreen.searchHomestayScreenRoute,
          arguments: {
            "position": event.position,
            "homestayType": "homestay",
            "searchString": event.campaignName
          });
    } else if (event is ViewHomestayDetailEvent) {
      Navigator.pushNamed(
          event.context!, HomestayDetailScreen.homestayDetailScreenRoute,
          arguments: {"homestayName": event.homestayName});
    } else if (event is ViewBlocHomestayDetailEvent) {
      Navigator.pushNamed(
          event.context!, BlocDetailScreen.blocDetailScreenRoute,
          arguments: {"blocName": event.blocName});
    }
  }
}
