class PromotionModel {
  PromotionModel(
      {this.id,
      this.code,
      this.endDate,
      this.status,
      this.discountAmount,
      this.homestayType});

  int? id;
  String? code;
  String? endDate;
  String? status;
  int? discountAmount;
  String? homestayType;

  factory PromotionModel.fromJson(Map<String, dynamic> json) => PromotionModel(
      id: json["id"],
      code: json["code"],
      endDate: json["endDate"],
      status: json["status"],
      discountAmount: json["discountAmount"],
      homestayType: json["homestayType"]);
}

class PromotionListPagingModel {
  PromotionListPagingModel({this.promotions, this.pageNumber});

  List<PromotionModel>? promotions;
  int? pageNumber;

  factory PromotionListPagingModel.fromJson(Map<String, dynamic> json) =>
      PromotionListPagingModel(
          promotions: json["promotions"] != null
              ? List<PromotionModel>.from(
                  json["promotions"].map((e) => PromotionModel.fromJson(e)))
              : <PromotionModel>[],
          pageNumber: json["pageNumber"]);
}
