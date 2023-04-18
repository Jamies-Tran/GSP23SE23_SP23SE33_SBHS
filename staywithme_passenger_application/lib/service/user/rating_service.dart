import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:staywithme_passenger_application/global_variable.dart';
import 'package:staywithme_passenger_application/model/exc_model.dart';
import 'package:staywithme_passenger_application/model/homestay_model.dart';
import 'package:http/http.dart' as http;
import 'package:staywithme_passenger_application/service/share_preference/share_preference.dart';

abstract class IRatingService {
  Future<dynamic> ratingHomestay(RatingModel rating);

  Future<dynamic> ratingBloc(RatingModel rating);
}

class RatingService extends IRatingService {
  @override
  Future ratingBloc(RatingModel rating) async {
    final client = http.Client();
    final uri = Uri.parse(ratingBlocUrl);
    try {
      final userLoginInfo = await SharedPreferencesService.getUserLoginInfo();
      final accessToken = userLoginInfo["accessToken"];
      final response = await client
          .post(uri,
              headers: {
                "content-type": "application/json",
                "Authorization": "Bearer $accessToken"
              },
              body: json.encode(rating.toJson()))
          .timeout(Duration(seconds: connectionTimeOut));
      if (response.statusCode == 200) {
        RatingModel rating = RatingModel.fromJson(json.decode(response.body));
        return rating;
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
  Future ratingHomestay(RatingModel rating) async {
    final client = http.Client();
    final uri = Uri.parse(ratingHomestayUrl);
    try {
      final userLoginInfo = await SharedPreferencesService.getUserLoginInfo();
      final accessToken = userLoginInfo["accessToken"];
      final response = await client
          .post(uri,
              headers: {
                "content-type": "application/json",
                "Authorization": "Bearer $accessToken"
              },
              body: json.encode(rating.toJson()))
          .timeout(Duration(seconds: connectionTimeOut));
      if (response.statusCode == 200) {
        RatingModel responseRating =
            RatingModel.fromJson(json.decode(response.body));
        return responseRating;
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
