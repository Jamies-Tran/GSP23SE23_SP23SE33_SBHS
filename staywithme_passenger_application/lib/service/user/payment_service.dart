import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:staywithme_passenger_application/global_variable.dart';
import 'package:staywithme_passenger_application/model/exc_model.dart';
import 'package:staywithme_passenger_application/model/payment_model.dart';
import 'package:staywithme_passenger_application/service/authentication/firebase_service.dart';
import 'package:staywithme_passenger_application/service_locator/service_locator.dart';
import 'package:http/http.dart' as http;

abstract class IPaymentService {
  Future<dynamic> requestPayment(String username, int amount);

  Future<dynamic> getPaymentHistories(String username, int page, int size);
}

class PaymentService extends IPaymentService {
  final _firebaseService = locator.get<IFirebaseService>();

  @override
  Future requestPayment(String username, int amount) async {
    final client = http.Client();
    try {
      final token = await _firebaseService.getUserTokenByUsername(username);
      if (token is String) {
        final uri =
            Uri.parse("$paymentUrl?amount=$amount&walletType=PASSENGER_WALLET");
        final response = await client.put(uri, headers: {
          "content-type": "application/json",
          "Authorization": "Bearer $token"
        }).timeout(Duration(seconds: connectionTimeOut));
        if (response.statusCode == 200) {
          PaymentModel paymentModel =
              PaymentModel.fromJson(json.decode(response.body));
          return paymentModel;
        } else {
          ServerExceptionModel serverExceptionModel =
              ServerExceptionModel.fromJson(json.decode(response.body));
          return serverExceptionModel;
        }
      }
    } on TimeoutException catch (e) {
      return e;
    } on SocketException catch (e) {
      return e;
    }
  }

  @override
  Future getPaymentHistories(String username, int page, int size) async {
    final client = http.Client();

    try {
      final token = await _firebaseService.getUserTokenByUsername(username);
      if (token is String) {
        Uri uri = Uri.parse("$paymentHistoryUrl?page=$page&size=$size");
        final response = await client.get(uri, headers: {
          "content-type": "application/json",
          "Authorization": "Bearer $token"
        });
        if (response.statusCode == 200) {
          final responseData = json.decode(response.body);
          final paymentHistories = List<PaymentHistoryModel>.from(
              responseData.map((e) => PaymentHistoryModel.fromJson(e)));
          return paymentHistories;
        } else {
          ServerExceptionModel serverExceptionModel =
              ServerExceptionModel.fromJson(json.decode(response.body));
          return serverExceptionModel;
        }
      }
    } on TimeoutException catch (e) {
      return e;
    } on SocketException catch (e) {
      return e;
    }
  }
}
