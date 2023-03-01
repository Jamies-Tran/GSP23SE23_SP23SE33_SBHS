import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:staywithme_passenger_application/global_variable.dart';
import 'package:staywithme_passenger_application/model/bloc_model.dart';
import 'package:staywithme_passenger_application/model/exc_model.dart';
import 'package:staywithme_passenger_application/model/homestay_model.dart';

abstract class IHomestayService {
  Future<dynamic> getHomestayListOrderByTotalAverageRating(
      int page, int size, bool isNextPage, bool isPreviousPage);

  Future<dynamic> getBlocListOrderByTotalAverageRating(
      int page, int size, bool isNextPage, bool isPreviousPage);
}

class HomestayService extends IHomestayService {
  @override
  Future getHomestayListOrderByTotalAverageRating(
      int page, int size, bool isNextPage, bool isPreviousPage) async {
    final client = http.Client();
    final uri = Uri.parse(
        "$homestayListOrderByRatingUrl?page=$page&size=$size&isNextPage=$isNextPage&isPreviousPage=$isPreviousPage");
    try {
      final response = await client.get(uri, headers: {
        "content-type": "application/json"
      }).timeout(Duration(seconds: connectionTimeOut));
      if (response.statusCode == 200) {
        HomestayListPagingModel homestayListPagingModel =
            HomestayListPagingModel.fromJson(json.decode(response.body));
        return homestayListPagingModel;
      } else {
        ServerExceptionModel serverExceptionModel =
            ServerExceptionModel.fromJson(json.decode(response.body));
        return serverExceptionModel;
      }
    } on SocketException catch (e) {
      return e;
    } on TimeoutException catch (e) {
      return e;
    }
  }

  @override
  Future getBlocListOrderByTotalAverageRating(
      int page, int size, bool isNextPage, bool isPreviousPage) async {
    final client = http.Client();
    final uri = Uri.parse(
        "$blocListOrderByRatingUrl?page=$page&size=$size&isNextPage=$isNextPage&isPreviousPage=$isPreviousPage");
    try {
      final response =
          await client.get(uri, headers: {"content-type": "application/json"});
      if (response.statusCode == 200) {
        BlocHomestayListPagingModel blocHomestayListPagingModel =
            BlocHomestayListPagingModel.fromJson(json.decode(response.body));
        return blocHomestayListPagingModel;
      } else {
        ServerExceptionModel serverExceptionModel =
            ServerExceptionModel.fromJson(json.decode(response.body));
        return serverExceptionModel;
      }
    } on SocketException catch (e) {
      return e;
    } on TimeoutException catch (e) {
      return e;
    }
  }
}
