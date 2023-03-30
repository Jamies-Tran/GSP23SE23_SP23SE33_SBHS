import 'package:staywithme_passenger_application/model/search_filter_model.dart';

class SelectNextHomestayState {
  SelectNextHomestayState(
      {this.homestayType, this.filterOption, this.bookingId});

  String? homestayType;
  FilterOptionModel? filterOption;
  int? bookingId;

  SearchFilterModel searchFilter() {
    return SearchFilterModel(
        filterOption: filterOption, homestayType: homestayType);
  }
}
