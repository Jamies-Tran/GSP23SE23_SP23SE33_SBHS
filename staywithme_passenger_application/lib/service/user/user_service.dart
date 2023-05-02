import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:staywithme_passenger_application/global_variable.dart';
import 'package:staywithme_passenger_application/model/exc_model.dart';
import 'package:staywithme_passenger_application/model/passenger_model.dart';
import 'package:staywithme_passenger_application/service/share_preference/share_preference.dart';

abstract class IUserService {
  Future<dynamic> getPassengerPersonalInformation(String username);

  Future<dynamic> getPassengerDeposits(
      int page, int size, bool isNextPage, bool isPreviousPage);
}

class UserService extends IUserService {
  @override
  Future getPassengerPersonalInformation(String username) async {
    final client = http.Client();
    Uri uri = Uri.parse("$userInfoUrl?username=$username");
    try {
      final response = await client.get(uri, headers: {
        "content-type": "application/json",
      }).timeout(Duration(seconds: connectionTimeOut));
      if (response.statusCode == 200) {
        PassengerModel passenger =
            PassengerModel.fromJson(json.decode(response.body));
        return passenger;
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
  Future getPassengerDeposits(
      int page, int size, bool isNextPage, bool isPreviousPage) async {
    final client = http.Client();
    final url = Uri.parse(
        "$depositHistoryUrl?page=$page&size=$size&isNextPage=$isNextPage&isPreviousPage=$isPreviousPage");
    try {
      final userLoginInfo = await SharedPreferencesService.getUserLoginInfo();
      final accessToken = userLoginInfo["accessToken"];
      final response = await client.get(url, headers: {
        "content-type": "application/json",
        "Authorization": "Bearer $accessToken"
      });
      if (response.statusCode == 200) {
        BookingDepositListPagingModel depositListPaging =
            BookingDepositListPagingModel.fromJson(json.decode(response.body));
        return depositListPaging;
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
