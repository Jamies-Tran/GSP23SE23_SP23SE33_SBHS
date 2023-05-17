import 'package:staywithme_passenger_application/model/bloc_model.dart';
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
    SearchFilterModel searchFilter = SearchFilterModel(
        filterOption: FilterOptionModel(), homestayType: "homestay");
    HomestayListPagingModel homestayList = await _homestayService
        .getHomestayByFilter(searchFilter, 0, 2000, false, false,
            sortBy: "Rating");

    return homestayList.homestays!;
  }

  Future<List<BlocHomestayModel>> getSimilarBlocHomestayList() async {
    SearchFilterModel searchFilter = SearchFilterModel(
        filterOption: FilterOptionModel(), homestayType: homestayType);
    HomestayListPagingModel homestayList = await _homestayService
        .getHomestayByFilter(searchFilter, 0, 2000, false, false,
            sortBy: "Rating");

    return homestayList.blocs!;
  }
}
