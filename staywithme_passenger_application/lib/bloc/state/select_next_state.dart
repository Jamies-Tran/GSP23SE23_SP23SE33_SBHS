import 'package:staywithme_passenger_application/model/booking_model.dart';
import 'package:staywithme_passenger_application/model/search_filter_model.dart';

class SelectNextHomestayState {
  SelectNextHomestayState(
      {this.homestayType,
      this.filterOption,
      this.bookingId,
      this.brownseHomestayFlag,
      this.bookingStart,
      this.bookingEnd,
      this.blocBookingValidation});

  String? homestayType;
  FilterOptionModel? filterOption;
  int? bookingId;
  bool? brownseHomestayFlag;
  String? bookingStart;
  String? bookingEnd;
  BlocBookingDateValidationModel? blocBookingValidation;

  SearchFilterModel searchFilter() {
    return SearchFilterModel(
        filterOption: filterOption, homestayType: homestayType);
  }
}
