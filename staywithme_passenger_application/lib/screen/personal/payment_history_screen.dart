import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:staywithme_passenger_application/global_variable.dart';
import 'package:staywithme_passenger_application/model/payment_model.dart';
import 'package:staywithme_passenger_application/service/user/payment_service.dart';
import 'package:staywithme_passenger_application/service_locator/service_locator.dart';

class PaymentHistoryScreen extends StatefulWidget {
  const PaymentHistoryScreen({super.key});
  static const String paymentHistoryScreenRoute = "/payment-history";

  @override
  State<PaymentHistoryScreen> createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  final _paymentService = locator.get<IPaymentService>();

  @override
  Widget build(BuildContext context) {
    final contextArguments = ModalRoute.of(context)!.settings.arguments as Map;
    final username = contextArguments["username"];
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.orange, Colors.white])),
        child: Center(
            child: Container(
          height: 350,
          width: MediaQuery.of(context).size.width - 10,
          decoration: BoxDecoration(boxShadow: const [
            BoxShadow(blurRadius: 1.0, blurStyle: BlurStyle.normal)
          ], borderRadius: BorderRadius.circular(20), color: Colors.white),
          child: Container(
            padding: const EdgeInsets.only(left: 40, right: 40),
            child: Column(children: [
              FutureBuilder(
                future: _paymentService.getPaymentHistories(username, 0, 5),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const SpinKitCircle(color: Colors.orange);
                    case ConnectionState.done:
                      final snapshotData = snapshot.data;
                      if (snapshotData is List<PaymentHistoryModel>) {
                        return Column(
                          children: [
                            SizedBox(
                              height: 50,
                              width: MediaQuery.of(context).size.width / 1.2,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      "amount",
                                      style: TextStyle(
                                          fontFamily: "Lobster",
                                          fontSize: 15,
                                          color: Colors.orange,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.0),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      "currency",
                                      style: TextStyle(
                                          fontFamily: "Lobster",
                                          fontSize: 15,
                                          color: Colors.orange,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.0),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      "method",
                                      style: TextStyle(
                                          fontFamily: "Lobster",
                                          fontSize: 15,
                                          color: Colors.orange,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.0),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      "date",
                                      style: TextStyle(
                                          fontFamily: "Lobster",
                                          fontSize: 15,
                                          color: Colors.orange,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.0),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 100,
                              width: MediaQuery.of(context).size.width / 1.2,
                              child: ListView.builder(
                                itemCount: snapshotData.length,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (context, index) => Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Text(currencyFormat.format(
                                            snapshotData[index].amount)),
                                      ),
                                      const Expanded(
                                        flex: 2,
                                        child: Text(
                                          "VND",
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                            "${snapshotData[index].paymentMethod}"),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                            "${snapshotData[index].createdDate}"),
                                      ),
                                    ]),
                              ),
                            )
                          ],
                        );
                      }
                      break;
                    default:
                      break;
                  }
                  return const SizedBox();
                },
              )
            ]),
          ),
        )),
      ),
    );
  }
}
