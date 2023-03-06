import 'package:staywithme_passenger_application/model/search_filter_model.dart';

class SearchHomestayState {
  SearchHomestayState({this.homestayType, this.filterOptionModel});

  String? homestayType;
  FilterOptionModel? filterOptionModel;

  SearchFilterModel searchFilter() => SearchFilterModel(
      homestayType: homestayType, filterOption: filterOptionModel);
}
