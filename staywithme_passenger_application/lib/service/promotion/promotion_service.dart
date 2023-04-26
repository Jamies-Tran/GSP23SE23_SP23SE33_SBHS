import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:staywithme_passenger_application/global_variable.dart';
import 'package:staywithme_passenger_application/model/exc_model.dart';
import 'package:staywithme_passenger_application/model/promotion_model.dart';
import 'package:staywithme_passenger_application/service/share_preference/share_preference.dart';

abstract class IPromotionService {
  Future<dynamic> getPromotionByCode(String code);

  Future<dynamic> getPromotionListByStatusAndHomestayType(
      String status,
      String homestayType,
      int page,
      int size,
      bool isNextPage,
      bool isPreviousPage);

  Future<dynamic> applyPromotions(List<String> promotionCodes, int bookingId);
}

class PromotionService extends IPromotionService {
  @override
  Future applyPromotions(List<String> promotionCodes, int bookingId) async {
    final client = http.Client();
    final uri = Uri.parse("$applyPromotionUrl?bookingId=$bookingId");

    try {
      final userLoginInfo = await SharedPreferencesService.getUserLoginInfo();
      final accessToken = userLoginInfo["accessToken"];
      final response = await client
          .put(uri,
              headers: {
                "content-type": "application/json",
                "Authorization": "Bearer $accessToken"
              },
              body: json.encode(promotionCodes))
          .timeout(Duration(seconds: connectionTimeOut));
      if (response.statusCode == 200) {
        return true;
      } else {
        ServerExceptionModel serverExceptionModel =
            ServerExceptionModel.fromJson(json.decode(response.body));
        return serverExceptionModel;
      }
    } on TimeoutException catch (e) {
      return e;
    } on SocketException catch (e) {
      return e;
    }
  }

  @override
  Future getPromotionByCode(String code) async {
    final client = http.Client();
    final uri = Uri.parse("$getPromotionByCodeUrl?code=$code");
    try {
      final userLoginInfo = await SharedPreferencesService.getUserLoginInfo();
      final accessToken = userLoginInfo["accessToken"];
      final response = await client.get(uri, headers: {
        "content-type": "application/json",
        "Authorization": "Bearer $accessToken"
      }).timeout(Duration(seconds: connectionTimeOut));
      if (response.statusCode == 200) {
        PromotionModel promotion =
            PromotionModel.fromJson(json.decode(response.body));
        return promotion;
      } else {
        ServerExceptionModel serverExceptionModel =
            ServerExceptionModel.fromJson(json.decode(response.body));
        return serverExceptionModel;
      }
    } on TimeoutException catch (e) {
      return e;
    } on SocketException catch (e) {
      return e;
    }
  }

  @override
  Future getPromotionListByStatusAndHomestayType(
      String status,
      String homestayType,
      int page,
      int size,
      bool isNextPage,
      bool isPreviousPage) async {
    final client = http.Client();
    final uri = Uri.parse(
        "$getPromotionListByStatusUrl?status=$status&homestayType=$homestayType&page=$page&size=$size&isNextPage=$isNextPage&isPreviousPage=$isPreviousPage");
    try {
      final userLoginInfo = await SharedPreferencesService.getUserLoginInfo();
      final accessToken = userLoginInfo["accessToken"];
      final response = await client.get(uri, headers: {
        "content-type": "application/json",
        "Authorization": "Bearer $accessToken"
      }).timeout(Duration(seconds: connectionTimeOut));
      if (response.statusCode == 200) {
        PromotionListPagingModel promotionList =
            PromotionListPagingModel.fromJson(json.decode(response.body));
        return promotionList;
      } else {
        ServerExceptionModel serverExceptionModel =
            ServerExceptionModel.fromJson(json.decode(response.body));
        return serverExceptionModel;
      }
    } on TimeoutException catch (e) {
      return e;
    } on SocketException catch (e) {
      return e;
    }
  }
}
