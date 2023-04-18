import 'package:staywithme_passenger_application/model/booking_model.dart';
import 'package:staywithme_passenger_application/model/homestay_model.dart';
import 'package:staywithme_passenger_application/model/search_filter_model.dart';
import 'package:staywithme_passenger_application/service/homestay/homestay_service.dart';
import 'package:staywithme_passenger_application/service_locator/service_locator.dart';

class RatingHomestayState {
  RatingHomestayState(
      {this.booking,
      this.bookingHomestay,
      this.blocBookingValidation,
      this.securityPoint,
      this.servicePoint,
      this.locationPoint,
      this.comment,
      this.isRatingFinished,
      this.homestayType,
      this.viewDetail});

  BookingModel? booking;
  BookingHomestayModel? bookingHomestay;
  BlocBookingDateValidationModel? blocBookingValidation;
  double? securityPoint;
  double? servicePoint;
  double? locationPoint;
  String? comment;
  bool? isRatingFinished;
  String? homestayType;
  bool? viewDetail;

  final _homestayService = locator.get<IHomestayService>();

  RatingModel ratingModel() {
    String homestayName = homestayType == "homestay"
        ? bookingHomestay!.homestay!.name!
        : booking!.bloc!.name!;
    return RatingModel(
        homestayName: homestayName,
        securityPoint: securityPoint,
        servicePoint: servicePoint,
        locationPoint: locationPoint,
        comment: comment);
  }

  Future<List<HomestayModel>> getSimilarHomestayList() async {
    String address = homestayType == "homestay"
        ? bookingHomestay!.homestay!.address!
        : booking!.bloc!.address!;
    double totalAverageRating = homestayType == "homestay"
        ? bookingHomestay!.homestay!.totalAverageRating!
        : booking!.bloc!.totalAverageRating!;
    FilterByAddress filterByAddress =
        FilterByAddress(address: address, distance: 5000, isGeometry: true);
    FilterByRatingRange filterByRatingRange = FilterByRatingRange(
      lowest: totalAverageRating,
      highest: totalAverageRating != 5 ? 5 : totalAverageRating,
    );
    int totalReservation = 5;
    FilterByBookingDate filterByBookingDate = FilterByBookingDate(
        start: booking!.bookingFrom!,
        end: booking!.bookingTo!,
        totalReservation: totalReservation);
    FilterOptionModel? filterOptionModel = FilterOptionModel(
        filterByAddress: filterByAddress,
        filterByRatingRange: filterByRatingRange,
        filterByBookingDateRange: filterByBookingDate);
    SearchFilterModel searchFilter = SearchFilterModel(
        filterOption: filterOptionModel, homestayType: homestayType);
    HomestayListPagingModel homestayList = await _homestayService
        .getHomestayByFilter(searchFilter, 0, 5, false, false);
    if (homestayList.homestays!.isEmpty) {
      filterOptionModel = null;
      searchFilter = SearchFilterModel(
          filterOption: filterOptionModel, homestayType: homestayType);
      homestayList = await _homestayService.getHomestayByFilter(
          searchFilter, 0, 5, false, false);
    }
    return homestayList.homestays!;
  }
}
