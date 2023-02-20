import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:staywithme_passenger_application/global_variable.dart';
import 'package:staywithme_passenger_application/model/auto_complete_model.dart';
import 'package:staywithme_passenger_application/model/exc_model.dart';

abstract class IAutoCompleteService {
  Future<dynamic> autoComplet(String place);
}

class AutoCompleteService extends IAutoCompleteService {
  @override
  Future autoComplet(String place) async {
    final client = http.Client();
    Uri uri = Uri.parse("$autoCompleteUrl?place=$place");
    try {
      final response = await client.get(uri, headers: {
        "content-type": "application/json"
      }).timeout(Duration(seconds: connectionTimeOut));
      if (response.statusCode == 200) {
        PlacesResult placesResult =
            PlacesResult.fromJson(json.decode(response.body));

        return placesResult;
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
    throw UnimplementedError();
  }
}
