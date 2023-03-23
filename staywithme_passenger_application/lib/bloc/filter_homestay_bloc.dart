import 'dart:async';

import 'package:flutter/material.dart';
import 'package:staywithme_passenger_application/bloc/event/filter_homestay_event.dart';
import 'package:staywithme_passenger_application/bloc/state/filter_homestay_state.dart';
import 'package:staywithme_passenger_application/screen/homestay/filter_screen.dart';
import 'package:staywithme_passenger_application/screen/homestay/search_homestay_screen.dart';

class FilterHomestayBloc {
  final eventController = StreamController<FilterHomestayEvent>();
  final stateController = StreamController<FilterHomestayState>();

  String? _homestayType;
  LocationType? _locationType = LocationType.address;
  Distance? _distance = Distance.one;
  String? _bookingStartDate = "";
  String? _bookingEndDate = "";
  int? _totalBookingReservation = 0;
  bool? _isInputAddress = true;
  String? _address = "";
  bool? _isGeometry = false;
  int? _distanceValue = 1000;
  RangeValues? _ratingRangeValues = const RangeValues(0, 0);
  RangeValues? _priceRangeValues = const RangeValues(0, 0);
  String? _facilityName = "None";
  int? _facilityQuantity = 0;
  String? _serviceName = "None";
  int? _servicePrice = 0;

  FilterHomestayState initData(String homestayType) {
    _homestayType = homestayType;
    return FilterHomestayState(
      distance: _distance,
      isInputAddress: _isInputAddress,
      facilityName: _facilityName,
      facilityQuantity: _facilityQuantity,
      homestayType: _homestayType,
      locationType: _locationType,
      priceRangeValue: _priceRangeValues,
      ratingRangeValue: _ratingRangeValues,
      serviceName: _serviceName,
      servicePrice: _servicePrice,
    );
  }

  void dispose() {
    eventController.close();
    stateController.close();
  }

  FilterHomestayBloc() {
    eventController.stream.listen((event) {
      eventHandler(event);
    });
  }

  void eventHandler(FilterHomestayEvent event) {
    if (event is ChooseBookingStartDateFilterEvent) {
      _bookingStartDate = event.start;
    } else if (event is ChooseBookingEndDateFilterEvent) {
      _bookingEndDate = event.end;
    } else if (event is InputTotalBookingRoomEvent) {
      _totalBookingReservation = event.totalReservation;
    } else if (event is ChooseLocationTypeFilterEvent) {
      _locationType = event.locationType;
      switch (_locationType) {
        case LocationType.address:
          _isInputAddress = false;
          break;
        case LocationType.nearby:
          _isInputAddress = true;
          break;
        default:
          _isInputAddress = false;
          break;
      }
    } else if (event is InputAddressFilterEvent) {
      _address = event.address;
      _isGeometry = true;
    } else if (event is ChooseNearByFilterEvent) {
      _address = "${event.position!.latitude},${event.position!.longitude}";
      _isGeometry = false;
    } else if (event is ChooseDistanceFilterEvent) {
      _distance = event.distance;
      switch (_distance) {
        case Distance.one:
          _distanceValue = 1000;
          break;
        case Distance.three:
          _distanceValue = 3000;
          break;
        case Distance.five:
          _distanceValue = 5000;
          break;
        default:
          _distanceValue = 0;
          break;
      }
    } else if (event is ChooseRatingFilterEvent) {
      _ratingRangeValues = RangeValues(event.start!, event.end!);
    } else if (event is ChoosePriceFilterEvent) {
      _priceRangeValues = RangeValues(event.start!, event.end!);
    } else if (event is ChooseFacilityFilterEvent) {
      _facilityName = event.facilityName;
    } else if (event is ChooseFacilityQuantityFilterEvent) {
      if (_facilityName != "None") {
        _facilityQuantity = event.quantity!.toInt();
      }
    } else if (event is ChooseHomestayServiceFilterEvent) {
      _serviceName = event.serviceName;
    } else if (event is ChooseHomestayServicePriceFilterEvent) {
      if (_serviceName != "None") {
        _servicePrice = event.price!.toInt();
      }
    } else if (event is OnClickSearchHomestayEvent) {
      Navigator.pushNamed(
          event.context!, SearchHomestayScreen.searchHomestayScreenRoute,
          arguments: {
            "filterOption": event.searchFilterModel!.filterOption,
            "homestayType": _homestayType,
            "position": event.position
          });
    }

    stateController.sink.add(
      FilterHomestayState(
        address: _address,
        bookingEndDate: _bookingEndDate,
        bookingStartDate: _bookingStartDate,
        distance: _distance,
        distanceValue: _distanceValue,
        facilityName: _facilityName,
        facilityQuantity: _facilityQuantity,
        homestayType: _homestayType,
        isGeometry: _isGeometry,
        isInputAddress: _isInputAddress,
        locationType: _locationType,
        priceRangeValue: _priceRangeValues,
        ratingRangeValue: _ratingRangeValues,
        serviceName: _serviceName,
        servicePrice: _servicePrice,
        totalBookingReservation: _totalBookingReservation,
      ),
    );
  }
}
