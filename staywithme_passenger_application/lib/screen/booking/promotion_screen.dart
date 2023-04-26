import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';
import 'package:staywithme_passenger_application/bloc/event/promotion_event.dart';
import 'package:staywithme_passenger_application/bloc/promotion_bloc.dart';
import 'package:staywithme_passenger_application/bloc/state/promotion_state.dart';
import 'package:staywithme_passenger_application/global_variable.dart';
import 'package:staywithme_passenger_application/model/promotion_model.dart';
import 'package:staywithme_passenger_application/service/promotion/promotion_service.dart';
import 'package:staywithme_passenger_application/service_locator/service_locator.dart';

class PromotionScreen extends StatefulWidget {
  const PromotionScreen({super.key});
  static const String promotionScreenRoute = "/promotion-screen";

  @override
  State<PromotionScreen> createState() => _PromotionScreenState();
}

class _PromotionScreenState extends State<PromotionScreen> {
  final promotionBloc = PromotionBloc();
  final promotionService = locator.get<IPromotionService>();

  @override
  void dispose() {
    promotionBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: WillPopScope(
        onWillPop: () async => false,
        child: StreamBuilder<PromotionState>(
            stream: promotionBloc.stateController.stream,
            initialData: promotionBloc.initData(context),
            builder: (context, streamSnapshot) {
              return Center(
                  child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                margin: const EdgeInsets.only(
                    top: 50, bottom: 20, left: 20, right: 20),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.white),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text("Choose Promotion",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25)),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "Apply for: ",
                        style: TextStyle(color: Colors.black45, fontSize: 10),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        streamSnapshot.data!.booking!.code!,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: 300,
                        height: 495,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey),
                        child: FutureBuilder(
                          future: promotionService
                              .getPromotionListByStatusAndHomestayType(
                                  streamSnapshot.data!.status!,
                                  streamSnapshot.data!.homestayType!,
                                  0,
                                  5,
                                  true,
                                  true),
                          builder: (context, snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.waiting:
                                return const SizedBox();
                              case ConnectionState.done:
                                if (snapshot.hasData) {
                                  final promotionListData = snapshot.data;
                                  if (promotionListData
                                      is PromotionListPagingModel) {
                                    promotionListData.promotions!.sort(
                                      (a, b) {
                                        return dateFormat
                                                .parse(b.endDate!)
                                                .difference(dateFormat.parse(
                                                    DateTime.now()
                                                        .toIso8601String()))
                                                .inDays -
                                            dateFormat
                                                .parse(a.endDate!)
                                                .difference(dateFormat.parse(
                                                    DateTime.now()
                                                        .toIso8601String()))
                                                .inDays;
                                      },
                                    );
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const SizedBox(
                                          height: 30,
                                        ),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: const [
                                              Expanded(
                                                  flex: 1,
                                                  child: Center(
                                                    child: Text("Code",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 13,
                                                            color:
                                                                Colors.white)),
                                                  )),
                                              Expanded(
                                                  flex: 1,
                                                  child: Center(
                                                    child: Text("Discount(%)",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 13,
                                                            color:
                                                                Colors.white)),
                                                  )),
                                              Expanded(
                                                  flex: 1,
                                                  child: Center(
                                                    child: Text("Expired(day)",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 13,
                                                            color:
                                                                Colors.white)),
                                                  )),
                                            ]),
                                        SizedBox(
                                          width: 300,
                                          height: 426,
                                          child: ListView.builder(
                                            itemCount: promotionListData
                                                .promotions!.length,
                                            itemBuilder: (context, index) {
                                              final promotion =
                                                  promotionListData
                                                      .promotions![index];
                                              return GestureDetector(
                                                onTap: () {
                                                  promotionBloc
                                                      .eventController.sink
                                                      .add(ChoosePromotionEvent(
                                                          promotion:
                                                              promotion));
                                                },
                                                child: Container(
                                                  height: 50,
                                                  width: 150,
                                                  margin: const EdgeInsets.only(
                                                      bottom: 5,
                                                      left: 5,
                                                      right: 5),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      color: streamSnapshot
                                                              .data!
                                                              .isPromotionChosen(
                                                                  promotion)
                                                          ? primaryColor
                                                          : Colors.white),
                                                  child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        Expanded(
                                                            flex: 1,
                                                            child: Center(
                                                              child: Text(
                                                                  promotion
                                                                      .code!,
                                                                  style: const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold)),
                                                            )),
                                                        Expanded(
                                                            flex: 1,
                                                            child: Center(
                                                              child: Text(
                                                                  "${promotion.discountAmount}",
                                                                  style: const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold)),
                                                            )),
                                                        Expanded(
                                                            flex: 1,
                                                            child: Center(
                                                              child: Text(
                                                                  "${dateFormat.parse(promotion.endDate!).difference(dateFormat.parse(DateTime.now().toIso8601String())).inDays}",
                                                                  style: const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold)),
                                                            )),
                                                      ]),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    );
                                  } else {
                                    return const Center(
                                        child: Text(
                                      "Something wrong with server",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ));
                                  }
                                } else {
                                  return const Center(
                                      child: Text(
                                    "Can't get Promotion data",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ));
                                }
                              default:
                                break;
                            }
                            return const SizedBox();
                          },
                        ),
                      ),
                      Text(
                          "You've discounted for ${currencyFormat.format(streamSnapshot.data!.totalDiscountAmount())} đ",
                          style: const TextStyle(color: Colors.black45)),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Total booking price",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      streamSnapshot.data!.promotions!.isNotEmpty
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${currencyFormat.format(streamSnapshot.data!.booking!.totalBookingPrice)}đ",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.lineThrough,
                                      color: Colors.red),
                                ),
                                Text(
                                  "${currencyFormat.format(streamSnapshot.data!.totalBookingPriceAfterDiscount)}đ",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black45),
                                )
                              ],
                            )
                          : Text(
                              "${currencyFormat.format(streamSnapshot.data!.booking!.totalBookingPrice)}đ",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black45),
                            ),
                      const SizedBox(
                        height: 10,
                      ),
                      ConfirmationSlider(
                        backgroundColor: Colors.white54,
                        backgroundColorEnd: primaryColor,
                        sliderButtonContent: const Icon(
                          Icons.add_home,
                        ),
                        foregroundColor: primaryColor,
                        stickToEnd: true,
                        text: "slide to book",
                        textStyle: const TextStyle(
                            fontFamily: "Lobster", fontWeight: FontWeight.bold),
                        onConfirmation: () {
                          if (streamSnapshot.data!.promotions!.isNotEmpty) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                backgroundColor: primaryColor,
                                content: SizedBox(
                                  width: 50,
                                  height: 100,
                                  child: FutureBuilder(
                                    future: promotionService.applyPromotions(
                                        streamSnapshot.data!.promotions!
                                            .map((e) => e.code!)
                                            .toList(),
                                        streamSnapshot.data!.booking!.id!),
                                    builder: (context, snapshot) {
                                      switch (snapshot.connectionState) {
                                        case ConnectionState.waiting:
                                          return Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: const [
                                              SpinKitChasingDots(
                                                color: Colors.black,
                                                duration: Duration(seconds: 4),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                "We're ready your booking...",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'Lobster'),
                                              )
                                            ],
                                          );
                                        case ConnectionState.done:
                                          promotionBloc.eventController.sink
                                              .add(ConfirmBookingEvent(
                                                  context: context));
                                          break;
                                        default:
                                          break;
                                      }
                                      return const SizedBox();
                                    },
                                  ),
                                ),
                              ),
                            );
                          } else {
                            promotionBloc.eventController.sink
                                .add(ConfirmBookingEvent(context: context));
                          }
                        },
                      )
                    ]),
              ));
            }),
      ),
    );
  }
}
