import 'dart:async';

import 'package:flutter/material.dart';
import 'package:staywithme_passenger_application/bloc/event/filter_homestay_event.dart';
import 'package:staywithme_passenger_application/bloc/state/filter_homestay_state.dart';
import 'package:staywithme_passenger_application/screen/homestay/filter_screen.dart';
import 'package:staywithme_passenger_application/screen/homestay/search_homestay_screen.dart';
import 'package:staywithme_passenger_application/service/location/location_service.dart';
import 'package:staywithme_passenger_application/service/share_preference/share_preference.dart';
import 'package:staywithme_passenger_application/service_locator/service_locator.dart';

class FilterHomestayBloc {
  final eventController = StreamController<FilterHomestayEvent>();
  final stateController = StreamController<FilterHomestayState>();

  final locationService = locator.get<ILocationService>();

  String? _homestayType;
  LocationType? _locationType = LocationType.address;
  Distance? _distance = Distance.one;
  String? _bookingStartDate = "";
  String? _bookingEndDate = "";
  int? _totalBookingReservation = 0;
  bool? _isInputAddress = true;
  bool? _locationPermission;
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

  Future<void> eventHandler(FilterHomestayEvent event) async {
    final sharedPreferences =
        await SharedPreferencesService.initSharedPreferenced();

    if (event is ChooseBookingStartDateFilterEvent) {
      _bookingStartDate = event.start;
    } else if (event is ChooseBookingEndDateFilterEvent) {
      _bookingEndDate = event.end;
    } else if (event is InputTotalBookingRoomEvent) {
      _totalBookingReservation = event.totalReservation;
    } else if (event is ChooseLocationTypeFilterEvent) {
      switch (event.locationType) {
        case LocationType.address:
          _locationType = event.locationType;
          _isInputAddress = false;
          break;
        case LocationType.nearby:
          bool locationPermission =
              sharedPreferences.getBool("locationPermission")!;
          bool permissionDeniedForever =
              sharedPreferences.getBool("permissionDeniedForever")!;
          _locationPermission = locationPermission;
          if (locationPermission == false) {
            if (permissionDeniedForever == true) {
              showDialog(
                context: event.context!,
                builder: (context) => AlertDialog(
                    title: const Center(
                      child: Text("Notice"),
                    ),
                    content: Container(
                      height: 50,
                      width: 50,
                      child: const Text(
                          "Grand your location permisison and try again"),
                    ),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Cancel"))
                    ]),
              );
            }

            await locationService.getUserCurrentLocation();
          } else {
            _locationType = event.locationType;
            _address =
                "${sharedPreferences.getDouble("latitude")},${sharedPreferences.getDouble("longitude")}";
            _isGeometry = false;
          }
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
          locationPermission: _locationPermission),
    );
  }
}
