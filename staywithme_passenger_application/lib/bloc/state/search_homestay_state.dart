import 'package:staywithme_passenger_application/model/search_filter_model.dart';

class SearchHomestayState {
  SearchHomestayState(
      {this.homestayType, this.searchString, this.filterOptionModel});

  String? homestayType;
  String? searchString;
  FilterOptionModel? filterOptionModel;

  SearchFilterModel searchFilter() => SearchFilterModel(
      homestayType: homestayType,
      searchString: searchString,
      filterOption: filterOptionModel);
}
