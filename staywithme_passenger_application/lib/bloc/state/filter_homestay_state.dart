import 'package:flutter/material.dart';
import 'package:staywithme_passenger_application/model/search_filter_model.dart';
import 'package:staywithme_passenger_application/screen/homestay/filter_screen.dart';

class FilterHomestayState {
  FilterHomestayState(
      {this.homestayType,
      this.locationType,
      this.address,
      this.distance,
      this.distanceValue,
      this.isGeometry,
      this.bookingStartDate,
      this.bookingEndDate,
      this.totalBookingReservation,
      this.ratingRangeValue,
      this.priceRangeValue,
      this.facilityName,
      this.facilityQuantity,
      this.serviceName,
      this.servicePrice,
      this.isInputAddress,
      this.locationPermission});

  String? homestayType;
  LocationType? locationType;
  String? address;
  Distance? distance;
  int? distanceValue;
  bool? isGeometry;
  bool? isInputAddress;
  bool? locationPermission;
  String? bookingStartDate;
  String? bookingEndDate;
  int? totalBookingReservation;
  RangeValues? ratingRangeValue;
  RangeValues? priceRangeValue;
  String? facilityName;
  int? facilityQuantity;
  String? serviceName;
  int? servicePrice;

  SearchFilterModel generateSearchFilterModel() {
    FilterByAddress? filterByAddress;
    FilterByFacility? filterByFacility;
    FilterByHomestayService? filterByHomestayService;
    FilterByBookingDate? filterByBookingDate;
    FilterByRatingRange? filterByRatingRange;
    FilterByPriceRange? filterByPriceRange;
    if (ratingRangeValue!.start == 0 && ratingRangeValue!.end == 0) {
      filterByRatingRange = null;
    } else {
      filterByRatingRange = FilterByRatingRange(
          lowest: ratingRangeValue!.start, highest: ratingRangeValue!.end);
    }

    if (bookingStartDate == "" ||
        bookingStartDate == null ||
        bookingEndDate == "" ||
        bookingEndDate == null) {
      filterByBookingDate = null;
    } else {
      filterByBookingDate = FilterByBookingDate(
          start: bookingStartDate,
          end: bookingEndDate,
          totalReservation: totalBookingReservation);
    }

    if (address == "" || address == null) {
      filterByAddress = null;
    } else {
      filterByAddress = FilterByAddress(
          address: address, distance: distanceValue, isGeometry: isGeometry);
    }

    if (facilityName == "None") {
      filterByFacility = null;
    } else {
      filterByFacility = FilterByFacility(
          name: facilityName, quantity: facilityQuantity!.toInt());
    }
    if (priceRangeValue!.start == 0 && priceRangeValue!.end == 0) {
      filterByPriceRange = null;
    } else {
      filterByPriceRange = FilterByPriceRange(
          lowest: priceRangeValue!.start.toInt(),
          highest: priceRangeValue!.end.toInt());
    }

    if (serviceName == "None") {
      filterByHomestayService = null;
    } else {
      filterByHomestayService = FilterByHomestayService(
          name: serviceName, price: servicePrice!.toInt());
    }

    FilterOptionModel filterOptionModel = FilterOptionModel(
      filterByAddress: filterByAddress,
      filterByBookingDateRange: filterByBookingDate,
      filterByFacility: filterByFacility,
      filterByHomestayService: filterByHomestayService,
      filterByPriceRange: filterByPriceRange,
      filterByRatingRange: filterByRatingRange,
    );
    SearchFilterModel searchFilterModel = SearchFilterModel(
        filterOption: filterOptionModel, homestayType: homestayType);
    return searchFilterModel;
  }
}
