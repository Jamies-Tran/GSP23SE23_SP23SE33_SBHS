import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:staywithme_passenger_application/global_variable.dart';
import 'package:staywithme_passenger_application/model/bloc_model.dart';
import 'package:staywithme_passenger_application/model/exc_model.dart';
import 'package:staywithme_passenger_application/model/homestay_city_province_model.dart';
import 'package:staywithme_passenger_application/model/homestay_model.dart';
import 'package:staywithme_passenger_application/model/search_filter_model.dart';
import 'package:staywithme_passenger_application/service/image_service.dart';
import 'package:staywithme_passenger_application/service_locator/service_locator.dart';

abstract class IHomestayService {
  Future<dynamic> getHomestayListOrderByTotalAverageRating(
      int page, int size, bool isNextPage, bool isPreviousPage);

  Future<dynamic> getBlocListOrderByTotalAverageRating(
      int page, int size, bool isNextPage, bool isPreviousPage);

  Future<dynamic> getHomestayByFilter(SearchFilterModel filter, int page,
      int size, bool isNextPage, bool isPreviousPage);

  Future<dynamic> getHomestayDetailByName(String name);

  Future<dynamic> getBlocDetailByName(String name);

  Future<dynamic> getHomestayFilterAdditionalInformation(String homestayType);

  Future<dynamic> getAreaHomestayInfo();
}

class HomestayService extends IHomestayService {
  final imageService = locator.get<IImageService>();

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

  @override
  Future getHomestayByFilter(SearchFilterModel filter, int page, int size,
      bool isNextPage, bool isPreviousPage) async {
    final client = http.Client();
    final uri = Uri.parse(
        "$homestayByFilterUrl?page=$page&size=$size&isNextPage=$isNextPage&isPreviousPage=$isPreviousPage");
    try {
      final response = await client.post(uri,
          headers: {"content-type": "application/json"},
          body: json.encode(filter.toJson()));
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
  Future getHomestayFilterAdditionalInformation(String homestayType) async {
    final client = http.Client();
    final uri =
        Uri.parse("$homestayFilterAddtionalUrl?homestayType=$homestayType");
    try {
      final response =
          await client.get(uri, headers: {"content-type": "application/json"});
      if (response.statusCode == 200) {
        FilterAddtionalInformationModel addtionalInformation =
            FilterAddtionalInformationModel.fromJson(
                json.decode(response.body));
        return addtionalInformation;
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
  Future getAreaHomestayInfo() async {
    final client = http.Client();
    final uri = Uri.parse(cityProvincesUrl);
    try {
      final response =
          await client.get(uri, headers: {"content-type": "application/json"});
      if (response.statusCode == 200) {
        TotalHomestayFromLocationModel totalHomestayFromLocationModel =
            TotalHomestayFromLocationModel.fromJson(json.decode(response.body));
        if (totalHomestayFromLocationModel.totalHomestays!.isNotEmpty) {
          for (var e in totalHomestayFromLocationModel.totalHomestays!) {
            String avatarUrl = await imageService
                .getAreaImage(utf8.decode(e.cityProvince!.runes.toList()));
            e.avatarUrl = avatarUrl;
          }
        }

        if (totalHomestayFromLocationModel.totalBlocs!.isNotEmpty) {
          for (var e in totalHomestayFromLocationModel.totalBlocs!) {
            String avatarUrl = await imageService
                .getAreaImage(utf8.decode(e.cityProvince!.runes.toList()));
            e.avatarUrl = avatarUrl;
          }
        }
        return totalHomestayFromLocationModel;
      }
    } on SocketException catch (e) {
      return e;
    } on TimeoutException catch (e) {
      return e;
    }
  }

  @override
  Future getHomestayDetailByName(String name) async {
    final client = http.Client();
    final uri = Uri.parse("$homestayDetailUrl?name=$name");
    try {
      final response = await client.get(uri, headers: {
        "content-type": "application/json"
      }).timeout(Duration(seconds: connectionTimeOut));
      if (response.statusCode == 200) {
        HomestayModel homestayModel =
            HomestayModel.fromJson(json.decode(response.body));
        return homestayModel;
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
  Future getBlocDetailByName(String name) async {
    final client = http.Client();
    final uri = Uri.parse("$blocDetailUrl?name=$name");
    try {
      final response =
          await client.get(uri, headers: {"content-type": "application/json"});
      if (response.statusCode == 200) {
        BlocHomestayModel bloc =
            BlocHomestayModel.fromJson(json.decode(response.body));
        return bloc;
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
