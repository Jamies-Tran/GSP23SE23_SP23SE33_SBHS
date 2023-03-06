import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:staywithme_passenger_application/bloc/event/search_homestay_event.dart';
import 'package:staywithme_passenger_application/bloc/state/search_homestay_state.dart';
import 'package:staywithme_passenger_application/model/search_filter_model.dart';
import 'package:staywithme_passenger_application/screen/homestay/filter_transaction_screen.dart';
import 'package:staywithme_passenger_application/screen/homestay/search_homestay_screen.dart';

class SearchHomestayBloc {
  final eventController = StreamController<SearchHomestayEvent>();
  final stateController = StreamController<SearchHomestayState>();

  void dispose() {
    eventController.close();
    stateController.close();
  }

  String? _homestayType;

  SearchHomestayState initData(
      FilterOptionModel? filterOption, String? homestayType) {
    _homestayType = homestayType;
    return SearchHomestayState(
        homestayType: _homestayType, filterOptionModel: filterOption);
  }

  SearchHomestayBloc() {
    eventController.stream.listen((event) {
      eventHandler(event);
    });
  }

  void eventHandler(SearchHomestayEvent event) {
    if (event is OnTabChooseFilterEvent) {
      Navigator.pushNamed(
          event.context!, FilterTransactionScreen.filterTransactionScreenRoute,
          arguments: {
            "position": event.position,
            "homestayType": event.homestayType
          });
    } else if (event is OnTabChooseHomestayTypeEvent) {
      _homestayType = event.homestayType!;
      Navigator.pushReplacementNamed(
          event.context!, SearchHomestayScreen.searchHomestayScreenRoute,
          arguments: {
            "position": event.position,
            "homestayType": _homestayType
          });
    }
    stateController.sink.add(SearchHomestayState(homestayType: _homestayType));
  }
}
