class SearchFilterModel {
  SearchFilterModel({this.filterOption, this.searchString});

  FilterOptionModel? filterOption;
  String? searchString;

  Map<String, dynamic> toJson() =>
      {"filterOption": filterOption?.toJson(), "searchString": searchString};
}

class FilterOptionModel {
  FilterOptionModel(
      {this.homestayType,
      this.filterByRatingRange,
      this.filterByBookingDateRange,
      this.filterByAddress,
      this.filterByFacility,
      this.filterByPriceRange,
      this.filterByHomestayService});

  String? homestayType;
  FilterByRatingRange? filterByRatingRange;
  FilterByBookingDate? filterByBookingDateRange;
  FilterByAddress? filterByAddress;
  FilterByFacility? filterByFacility;
  FilterByPriceRange? filterByPriceRange;
  FilterByHomestayService? filterByHomestayService;

  Map<String, dynamic> toJson() => {
        "homestayType": homestayType,
        "filterByRatingRange": filterByRatingRange,
        "filterByBookingDateRange": filterByBookingDateRange?.toJson(),
        "filterByAddress": filterByAddress?.toJson(),
        "filterByFacility": filterByFacility?.toJson(),
        "filterByPriceRange": filterByPriceRange?.toJson(),
        "filterByHomestayService": filterByHomestayService?.toJson()
      };
}

class FilterByFacility {
  FilterByFacility({this.name, this.quantity});

  String? name;
  String? quantity;

  Map<String, dynamic> toJson() => {"name": name, "quantity": quantity};
}

class FilterByRatingRange {
  FilterByRatingRange({this.highest, this.lowest});

  double? highest;
  double? lowest;

  Map<String, dynamic> toJson() => {"highest": highest, "lowest": lowest};
}

class FilterByBookingDate {
  FilterByBookingDate({this.start, this.end, this.totalRoom});

  String? start;
  String? end;
  int? totalRoom;

  Map<String, dynamic> toJson() =>
      {"start": start, "end": end, "totalRoom": totalRoom};
}

class FilterByAddress {
  FilterByAddress({this.address, this.isGeometry, this.distance});

  String? address;
  int? distance;
  bool? isGeometry;

  Map<String, dynamic> toJson() =>
      {"address": address, "distance": distance, "isGeometry": isGeometry};
}

class FilterByPriceRange {
  FilterByPriceRange({this.highest, this.lowest});

  int? highest;
  int? lowest;

  Map<String, dynamic> toJson() => {"highest": highest, "lowest": lowest};
}

class FilterByHomestayService {
  FilterByHomestayService({this.name, this.price});

  String? name;
  int? price;

  Map<String, dynamic> toJson() => {"name": name, "price": price};
}

class FilterAddtionalInformationModel {
  FilterAddtionalInformationModel(
      {this.homestayFacilityNames,
      this.homestayServiceNames,
      this.homestayHighestPrice,
      this.homestayServiceHighestPrice});

  List<String>? homestayFacilityNames;
  List<String>? homestayServiceNames;
  int? homestayHighestPrice;
  int? homestayServiceHighestPrice;

  factory FilterAddtionalInformationModel.fromJson(Map<String, dynamic> json) =>
      FilterAddtionalInformationModel(
          homestayFacilityNames: List<String>.from(
              json["homestayFacilityNames"].map((e) => e.toString())),
          homestayServiceNames: List<String>.from(
              json["homestayServiceNames"].map<String>((e) => e.toString())),
          homestayHighestPrice: json["homestayHighestPrice"],
          homestayServiceHighestPrice: json["homestayServiceHighestPrice"]);
}
