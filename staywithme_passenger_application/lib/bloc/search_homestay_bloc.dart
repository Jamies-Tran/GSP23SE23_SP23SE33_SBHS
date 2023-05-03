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
  String? _sortBy;

  SearchHomestayState initData(FilterOptionModel? filterOption,
      String? homestayType, String? searchString) {
    _homestayType = homestayType;
    _searchString = searchString;
    _sortBy = "Rating";
    return SearchHomestayState(
        homestayType: _homestayType,
        searchString: _searchString,
        filterOptionModel: filterOption,
        sortBy: "Rating");
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
            "homestayType": _homestayType,
            "searchString": _searchString
          });
    } else if (event is OnViewHomestayDetailEvent) {
      Navigator.pushNamed(
          event.context!, HomestayDetailScreen.homestayDetailScreenRoute,
          arguments: {
            "homestayName": event.homestayName,
            "isHomestayInBloc": false
          });
    } else if (event is OnViewBlocHomestayDetailEvent) {
      Navigator.pushNamed(
          event.context!, BlocDetailScreen.blocDetailScreenRoute,
          arguments: {"blocName": event.blocName});
    } else if (event is ChooseSortByEvent) {
      _sortBy = event.sortBy;
    } else if (event is SearchHomestayByStringEvent) {
      _searchString = event.searchString;
    }
    stateController.sink.add(SearchHomestayState(
        homestayType: _homestayType,
        sortBy: _sortBy,
        searchString: _searchString));
  }
}
