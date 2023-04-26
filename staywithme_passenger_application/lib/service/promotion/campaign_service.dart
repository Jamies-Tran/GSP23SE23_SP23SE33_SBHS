import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:staywithme_passenger_application/global_variable.dart';
import 'package:staywithme_passenger_application/model/campaign_model.dart';
import 'package:staywithme_passenger_application/model/exc_model.dart';
import 'package:staywithme_passenger_application/service/share_preference/share_preference.dart';

abstract class ICampaignService {
  Future<dynamic> getCampaignListByStatus(
      String status, int page, int size, bool isNextPage, bool isPreviousPage);

  Future<dynamic> getCampaignById(int id);
}

class CampaignService extends ICampaignService {
  @override
  Future getCampaignById(int id) async {
    final client = http.Client();
    final uri = Uri.parse("$campaignUrl?campaignId=$id");
    try {
      final userLoginInfo = await SharedPreferencesService.getUserLoginInfo();
      final accessToken = userLoginInfo["accessToken"];
      final response = await client.get(uri, headers: {
        "content-type": "application/json",
        "Authorization": "Bearer $accessToken"
      }).timeout(Duration(seconds: connectionTimeOut));
      if (response.statusCode == 200) {
        CampaignModel campaignModel =
            CampaignModel.fromJson(json.decode(response.body));
        return campaignModel;
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
  Future getCampaignListByStatus(String status, int page, int size,
      bool isNextPage, bool isPreviousPage) async {
    final client = http.Client();
    final uri = Uri.parse(
        "$campaignListUrl?status=$status&page=$page&size=$size&isNextPage=$isNextPage&isPreviousPage=$isPreviousPage");
    try {
      final userLoginInfo = await SharedPreferencesService.getUserLoginInfo();
      final accessToken = userLoginInfo["accessToken"];
      final response = await client.get(uri, headers: {
        "content-type": "application/json",
        "Authorization": "Bearer $accessToken"
      }).timeout(Duration(seconds: connectionTimeOut));
      if (response.statusCode == 200) {
        CampaignListPagingModel campaignListPaging =
            CampaignListPagingModel.fromJson(json.decode(response.body));
        return campaignListPaging;
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
