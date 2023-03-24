import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:staywithme_passenger_application/bloc/event/search_homestay_event.dart';
import 'package:staywithme_passenger_application/bloc/state/search_homestay_state.dart';
import 'package:staywithme_passenger_application/model/search_filter_model.dart';
import 'package:staywithme_passenger_application/screen/homestay/bloc_detail_screen.dart';
import 'package:staywithme_passenger_application/screen/homestay/filter_transaction_screen.dart';
import 'package:staywithme_passenger_application/screen/homestay/homestay_detail_screen.dart';
import 'package:staywithme_passenger_application/screen/homestay/search_homestay_screen.dart';

class SearchHomestayBloc {
  final eventController = StreamController<SearchHomestayEvent>();
  final stateController = StreamController<SearchHomestayState>();

  void dispose() {
    eventController.close();
    stateController.close();
  }

  String? _homestayType;
  String? _searchString;

  SearchHomestayState initData(FilterOptionModel? filterOption,
      String? homestayType, String? searchString) {
    _homestayType = homestayType;
    _searchString = searchString;
    return SearchHomestayState(
        homestayType: _homestayType,
        searchString: _searchString,
        filterOptionModel: filterOption);
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
    } else if (event is OnViewHomestayDetailEvent) {
      Navigator.pushNamed(
          event.context!, HomestayDetailScreen.homestayDetailScreenRoute,
          arguments: {"homestayName": event.homestayName});
    } else if (event is OnViewBlocHomestayDetailEvent) {
      Navigator.pushNamed(
          event.context!, BlocDetailScreen.blocDetailScreenRoute,
          arguments: {"blocName": event.blocName});
    }
    stateController.sink.add(SearchHomestayState(homestayType: _homestayType));
  }
}
