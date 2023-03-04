import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:staywithme_passenger_application/bloc/event/search_homestay_event.dart';
import 'package:staywithme_passenger_application/screen/homestay/filter_screen.dart';
import 'package:staywithme_passenger_application/screen/homestay/filter_transaction_screen.dart';

class SearchHomestayBloc {
  final eventController = StreamController<SearchHomestayEvent>();

  void dispose() {
    eventController.close();
  }

  SearchHomestayBloc() {
    eventController.stream.listen((event) {
      eventHandler(event);
    });
  }

  void eventHandler(SearchHomestayEvent event) {
    if (event is OnClickChooseFilterEvent) {
      Navigator.pushNamed(
          event.context!, FilterTransactionScreen.filterTransactionScreenRoute,
          arguments: {"position": event.position});
    }
  }
}
