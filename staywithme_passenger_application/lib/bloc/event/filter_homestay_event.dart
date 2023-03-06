import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:staywithme_passenger_application/model/search_filter_model.dart';
import 'package:staywithme_passenger_application/screen/homestay/filter_screen.dart';

abstract class FilterHomestayEvent {}

class ChooseHomestayTypeFilterEvent extends FilterHomestayEvent {
  ChooseHomestayTypeFilterEvent({this.homestayType});

  HomestayType? homestayType;
}

class ChooseBookingStartDateFilterEvent extends FilterHomestayEvent {
  ChooseBookingStartDateFilterEvent({this.start});

  String? start;
}

class ChooseBookingEndDateFilterEvent extends FilterHomestayEvent {
  ChooseBookingEndDateFilterEvent({this.end});

  String? end;
}

class ChooseLocationTypeFilterEvent extends FilterHomestayEvent {
  ChooseLocationTypeFilterEvent({this.locationType});

  LocationType? locationType;
}

class InputAddressFilterEvent extends FilterHomestayEvent {
  InputAddressFilterEvent({this.address});

  String? address;
}

class InputTotalBookingRoomEvent extends FilterHomestayEvent {
  InputTotalBookingRoomEvent({this.totalBookingRoom});

  int? totalBookingRoom;
}

class ChooseNearByFilterEvent extends FilterHomestayEvent {
  ChooseNearByFilterEvent({this.position});

  Position? position;
}

class ChooseDistanceFilterEvent extends FilterHomestayEvent {
  ChooseDistanceFilterEvent({this.distance});

  Distance? distance;
}

class ChooseRatingFilterEvent extends FilterHomestayEvent {
  ChooseRatingFilterEvent({this.start, this.end});

  double? start;
  double? end;
}

class ChoosePriceFilterEvent extends FilterHomestayEvent {
  ChoosePriceFilterEvent({this.start, this.end});

  double? start;
  double? end;
}

class ChooseFacilityFilterEvent extends FilterHomestayEvent {
  ChooseFacilityFilterEvent({this.facilityName});

  String? facilityName;
}

class ChooseFacilityQuantityFilterEvent extends FilterHomestayEvent {
  ChooseFacilityQuantityFilterEvent({this.quantity});

  double? quantity;
}

class ChooseHomestayServiceFilterEvent extends FilterHomestayEvent {
  ChooseHomestayServiceFilterEvent({this.serviceName});

  String? serviceName;
}

class ChooseHomestayServicePriceFilterEvent extends FilterHomestayEvent {
  ChooseHomestayServicePriceFilterEvent({this.price});

  double? price;
}

class OnClickSearchHomestayEvent extends FilterHomestayEvent {
  OnClickSearchHomestayEvent(
      {this.searchFilterModel, this.context, this.homestayType});

  SearchFilterModel? searchFilterModel;
  String? homestayType;
  BuildContext? context;
}
