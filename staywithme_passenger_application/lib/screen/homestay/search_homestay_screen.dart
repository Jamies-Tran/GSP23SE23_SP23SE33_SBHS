import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:geolocator/geolocator.dart';
import 'package:staywithme_passenger_application/bloc/event/search_homestay_event.dart';
import 'package:staywithme_passenger_application/bloc/event/select_next_event.dart';
import 'package:staywithme_passenger_application/bloc/search_homestay_bloc.dart';
import 'package:staywithme_passenger_application/bloc/select_next_bloc.dart';
import 'package:staywithme_passenger_application/bloc/state/search_homestay_state.dart';
import 'package:staywithme_passenger_application/bloc/state/select_next_state.dart';
import 'package:staywithme_passenger_application/global_variable.dart';
import 'package:staywithme_passenger_application/model/homestay_model.dart';
import 'package:staywithme_passenger_application/model/search_filter_model.dart';
import 'package:staywithme_passenger_application/service/homestay/homestay_service.dart';
import 'package:staywithme_passenger_application/service/image_service.dart';
import 'package:staywithme_passenger_application/service/user/user_service.dart';

import 'package:staywithme_passenger_application/service_locator/service_locator.dart';

class SearchHomestayScreen extends StatefulWidget {
  const SearchHomestayScreen({super.key});
  static const String searchHomestayScreenRoute = "/search_homestay";

  @override
  State<SearchHomestayScreen> createState() => _SearchHomestayScreenState();
}

class _SearchHomestayScreenState extends State<SearchHomestayScreen> {
  final homestayService = locator.get<IHomestayService>();
  final searchTextFieldController = TextEditingController();
  final userService = locator.get<IUserService>();
  final imageService = locator.get<IImageService>();

  SearchHomestayBloc searchHomestayBloc = SearchHomestayBloc();

  @override
  void dispose() {
    searchHomestayBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final contextArguments = ModalRoute.of(context)!.settings.arguments as Map?;
    Position? position =
        contextArguments != null ? contextArguments["position"] : null;
    String? homestayType = contextArguments?["homestayType"];
    String? searchString = contextArguments?["searchString"];
    FilterOptionModel? filterOptionModel =
        contextArguments != null ? contextArguments["filterOption"] : null;

    return Scaffold(
      body: StreamBuilder<SearchHomestayState>(
          stream: searchHomestayBloc.stateController.stream,
          initialData: searchHomestayBloc.initData(
              filterOptionModel, homestayType, searchString),
          builder: (context, streamSnapshot) {
            // String? observeHomestayType =
            //     homestayType ?? streamSnapshot.data!.homestayType;
            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.only(top: 20),
              color: secondaryColor,
              child: SafeArea(
                child: Column(
                  children: [
                    SizedBox(
                      width: 320,
                      child: Row(children: [
                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                            onTap: () {
                              searchHomestayBloc.eventController.sink.add(
                                  OnTabChooseHomestayTypeEvent(
                                      homestayType: "homestay",
                                      context: context,
                                      position: position));
                            },
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      bottomLeft: Radius.circular(20)),
                                  color: homestayType == "homestay"
                                      ? primaryColor
                                      : Colors.white),
                              child: const Center(
                                  child: Text(
                                "Homestay",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                            onTap: () {
                              searchHomestayBloc.eventController.sink.add(
                                  OnTabChooseHomestayTypeEvent(
                                      homestayType: "bloc",
                                      context: context,
                                      position: position));
                            },
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(20),
                                      bottomRight: Radius.circular(20)),
                                  color: homestayType == "bloc"
                                      ? primaryColor
                                      : Colors.white),
                              child: const Center(
                                  child: Text(
                                "Bloc",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                            ),
                          ),
                        ),
                      ]),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () => searchHomestayBloc.eventController.sink.add(
                          OnTabChooseFilterEvent(
                              context: context,
                              position: position,
                              homestayType: homestayType)),
                      child: Container(
                        width: 200,
                        height: 50,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            color: primaryColor,
                            border: Border.fromBorderSide(
                                BorderSide(width: 2.0, color: Colors.black))),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.filter_alt,
                                color: Colors.black,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Choose filter",
                                style: TextStyle(
                                    fontFamily: "Lobster",
                                    fontWeight: FontWeight.bold),
                              )
                            ]),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    FutureBuilder(
                      future: homestayService.getHomestayByFilter(
                          streamSnapshot.data!.searchFilter(),
                          0,
                          5,
                          false,
                          false),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return SizedBox(
                              height: 600,
                              child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: 5,
                                  itemBuilder: (context, index) =>
                                      TweenAnimationBuilder(
                                        tween: Tween<double>(begin: 0, end: 1),
                                        duration: const Duration(seconds: 4),
                                        builder: (context, value, child) =>
                                            Opacity(
                                          opacity: value,
                                          child: child,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 150,
                                              width: 400,
                                              margin: const EdgeInsets.only(
                                                  left: 10, right: 10),
                                              padding: const EdgeInsets.only(
                                                top: 50,
                                              ),
                                              decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  10),
                                                          topRight:
                                                              Radius.circular(
                                                                  10)),
                                                  color: Colors.white24),
                                            ),
                                            Container(
                                              height: 150,
                                              width: 400,
                                              margin: const EdgeInsets.only(
                                                  left: 10, right: 10),
                                              decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  10),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  10)),
                                                  color: Colors.white),
                                              child: Container(
                                                padding: const EdgeInsets.only(
                                                  left: 10,
                                                ),
                                                child: const SizedBox(),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                          ],
                                        ),
                                      )),
                            );

                          case ConnectionState.done:
                            final data = snapshot.data;
                            if (data is HomestayListPagingModel) {
                              switch (homestayType!.toUpperCase()) {
                                case "HOMESTAY":
                                  if (data.homestays!.isNotEmpty) {
                                    return Column(
                                      children: [
                                        Text(
                                          "${data.homestays!.length} homestay were found",
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        SizedBox(
                                          height: 600,
                                          child: ListView.builder(
                                              scrollDirection: Axis.vertical,
                                              itemCount: data.homestays!.length,
                                              itemBuilder:
                                                  (context, index) =>
                                                      TweenAnimationBuilder(
                                                        tween: Tween<double>(
                                                            begin: 0, end: 1),
                                                        duration: Duration(
                                                            seconds: index + 1),
                                                        builder: (context,
                                                                value, child) =>
                                                            Opacity(
                                                          opacity: value,
                                                          child: child,
                                                        ),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            FutureBuilder(
                                                              future: imageService
                                                                  .getHomestayImage(data
                                                                      .homestays![
                                                                          index]
                                                                      .homestayImages![
                                                                          0]
                                                                      .imageUrl!),
                                                              builder: (context,
                                                                  imageSnapshot) {
                                                                switch (imageSnapshot
                                                                    .connectionState) {
                                                                  case ConnectionState
                                                                      .waiting:
                                                                    return Container(
                                                                      height:
                                                                          150,
                                                                      width:
                                                                          400,
                                                                      margin: const EdgeInsets
                                                                              .only(
                                                                          left:
                                                                              10,
                                                                          right:
                                                                              10),
                                                                      padding:
                                                                          const EdgeInsets
                                                                              .only(
                                                                        top: 50,
                                                                      ),
                                                                      decoration: const BoxDecoration(
                                                                          color: Colors
                                                                              .white24,
                                                                          borderRadius: BorderRadius.only(
                                                                              topLeft: Radius.circular(10),
                                                                              topRight: Radius.circular(10))),
                                                                    );
                                                                  case ConnectionState
                                                                      .done:
                                                                    String
                                                                        imageUrl =
                                                                        imageSnapshot.data ??
                                                                            'https://i.ytimg.com/vi/0jDUx3jOBfU/mqdefault.jpg';
                                                                    return GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        searchHomestayBloc
                                                                            .eventController
                                                                            .sink
                                                                            .add(OnViewHomestayDetailEvent(
                                                                                context: context,
                                                                                homestayName: data.homestays![index].name));
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            150,
                                                                        width:
                                                                            400,
                                                                        margin: const EdgeInsets.only(
                                                                            left:
                                                                                10,
                                                                            right:
                                                                                10),
                                                                        padding:
                                                                            const EdgeInsets.only(
                                                                          top:
                                                                              50,
                                                                        ),
                                                                        decoration: BoxDecoration(
                                                                            image:
                                                                                DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.fill),
                                                                            borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),
                                                                      ),
                                                                    );
                                                                  default:
                                                                    break;
                                                                }
                                                                return Container(
                                                                  height: 150,
                                                                  width: 200,
                                                                  margin: const EdgeInsets
                                                                          .only(
                                                                      left: 10),
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                    top: 50,
                                                                  ),
                                                                  decoration: const BoxDecoration(
                                                                      color: Colors
                                                                          .white24,
                                                                      borderRadius: BorderRadius.only(
                                                                          topLeft: Radius.circular(
                                                                              10),
                                                                          topRight:
                                                                              Radius.circular(10))),
                                                                );
                                                              },
                                                            ),
                                                            Container(
                                                              height: 150,
                                                              width: 400,
                                                              margin:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 10,
                                                                      right: 10,
                                                                      bottom:
                                                                          10),
                                                              decoration: const BoxDecoration(
                                                                  borderRadius: BorderRadius.only(
                                                                      bottomLeft:
                                                                          Radius.circular(
                                                                              10),
                                                                      bottomRight:
                                                                          Radius.circular(
                                                                              10)),
                                                                  color: Colors
                                                                      .white),
                                                              child:
                                                                  GestureDetector(
                                                                onTap: () => {},
                                                                child:
                                                                    Container(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                    left: 10,
                                                                  ),
                                                                  child: Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        const SizedBox(
                                                                          height:
                                                                              10,
                                                                        ),
                                                                        Text(
                                                                          utf8.decode(data
                                                                              .homestays![index]
                                                                              .name!
                                                                              .runes
                                                                              .toList()),
                                                                          style: const TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 25),
                                                                        ),
                                                                        const SizedBox(
                                                                          height:
                                                                              2,
                                                                        ),
                                                                        Text(
                                                                          "Address: ${utf8.decode(data.homestays![index].address!.runes.toList())}",
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                        ),
                                                                        const SizedBox(
                                                                          height:
                                                                              10,
                                                                        ),
                                                                        RatingStars(
                                                                          animationDuration:
                                                                              const Duration(seconds: 4),
                                                                          maxValue:
                                                                              5.0,
                                                                          starColor:
                                                                              secondaryColor,
                                                                          value: data
                                                                              .homestays![index]
                                                                              .totalAverageRating!,
                                                                          starOffColor:
                                                                              Colors.lightBlueAccent,
                                                                          starCount:
                                                                              5,
                                                                          valueLabelMargin:
                                                                              const EdgeInsets.only(
                                                                            right:
                                                                                1.0,
                                                                          ),
                                                                          valueLabelVisibility:
                                                                              true,
                                                                        ),
                                                                        const SizedBox(
                                                                          width:
                                                                              5,
                                                                        ),
                                                                        Text(
                                                                            "(${data.homestays![index].numberOfRating} number of reviews)"),
                                                                        const SizedBox(
                                                                          height:
                                                                              10,
                                                                        ),
                                                                        Row(
                                                                          children: [
                                                                            Expanded(
                                                                              flex: 3,
                                                                              child: Text(
                                                                                "VND: ${currencyFormat.format(data.homestays![index].price)} / day",
                                                                                style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                                                                              ),
                                                                            ),
                                                                            Expanded(
                                                                              flex: 1,
                                                                              child: Text(
                                                                                "${data.homestays![index].availableRooms} rooms",
                                                                                style: const TextStyle(fontWeight: FontWeight.w300, fontSize: 15),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        )
                                                                      ]),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )),
                                        ),
                                      ],
                                    );
                                  } else {
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: const [
                                        Text(
                                          "Oop, we can't find the homestay which you're looking for.",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    );
                                  }

                                case "BLOC":
                                  if (data.blocs!.isNotEmpty) {
                                    return Column(
                                      children: [
                                        Text(
                                          "${data.blocs!.length} blocs were found",
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        SizedBox(
                                          height: 600,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: ListView.builder(
                                              scrollDirection: Axis.vertical,
                                              itemCount: data.blocs!.length,
                                              itemBuilder:
                                                  (context, index) =>
                                                      TweenAnimationBuilder(
                                                        tween: Tween<double>(
                                                            begin: 0, end: 1),
                                                        duration:
                                                            const Duration(
                                                                seconds: 4),
                                                        builder: (context,
                                                                value, child) =>
                                                            Opacity(
                                                          opacity: value,
                                                          child: child,
                                                        ),
                                                        child: GestureDetector(
                                                          onTap: () => searchHomestayBloc
                                                              .eventController
                                                              .sink
                                                              .add(OnViewBlocHomestayDetailEvent(
                                                                  context:
                                                                      context,
                                                                  blocName: data
                                                                      .blocs![
                                                                          index]
                                                                      .name)),
                                                          child: Container(
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    bottom: 10),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                FutureBuilder(
                                                                  future: imageService.getHomestayImage(data
                                                                      .blocs![
                                                                          index]
                                                                      .homestays![
                                                                          0]
                                                                      .homestayImages![
                                                                          0]
                                                                      .imageUrl!),
                                                                  builder: (context,
                                                                      imageSnapshot) {
                                                                    String
                                                                        imageUrl =
                                                                        imageSnapshot.data ??
                                                                            'https://i.ytimg.com/vi/0jDUx3jOBfU/mqdefault.jpg';
                                                                    switch (imageSnapshot
                                                                        .connectionState) {
                                                                      case ConnectionState
                                                                          .waiting:
                                                                        return Container(
                                                                          height:
                                                                              150,
                                                                          width:
                                                                              200,
                                                                          margin:
                                                                              const EdgeInsets.only(left: 10),
                                                                          padding:
                                                                              const EdgeInsets.only(
                                                                            top:
                                                                                50,
                                                                          ),
                                                                          decoration: const BoxDecoration(
                                                                              color: Colors.white24,
                                                                              borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),
                                                                        );
                                                                      case ConnectionState
                                                                          .done:
                                                                        return Container(
                                                                          height:
                                                                              150,
                                                                          width:
                                                                              400,
                                                                          margin: const EdgeInsets.only(
                                                                              left: 10,
                                                                              right: 10),
                                                                          padding:
                                                                              const EdgeInsets.only(
                                                                            top:
                                                                                50,
                                                                          ),
                                                                          decoration: BoxDecoration(
                                                                              image: DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.fill),
                                                                              borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),
                                                                        );
                                                                      default:
                                                                        break;
                                                                    }
                                                                    return Container(
                                                                      height:
                                                                          150,
                                                                      width:
                                                                          200,
                                                                      margin: const EdgeInsets
                                                                              .only(
                                                                          left:
                                                                              10,
                                                                          right:
                                                                              10),
                                                                      padding:
                                                                          const EdgeInsets
                                                                              .only(
                                                                        top: 50,
                                                                      ),
                                                                      decoration: const BoxDecoration(
                                                                          color: Colors
                                                                              .white24,
                                                                          borderRadius: BorderRadius.only(
                                                                              topLeft: Radius.circular(10),
                                                                              topRight: Radius.circular(10))),
                                                                    );
                                                                  },
                                                                ),
                                                                Container(
                                                                  height: 150,
                                                                  width: 400,
                                                                  margin: const EdgeInsets
                                                                          .only(
                                                                      left: 10,
                                                                      right:
                                                                          10),
                                                                  decoration: const BoxDecoration(
                                                                      borderRadius: BorderRadius.only(
                                                                          bottomLeft: Radius.circular(
                                                                              10),
                                                                          bottomRight: Radius.circular(
                                                                              10)),
                                                                      color: Colors
                                                                          .white),
                                                                  child:
                                                                      Container(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            10),
                                                                    child: Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment
                                                                                .start,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        children: [
                                                                          const SizedBox(
                                                                            height:
                                                                                10,
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              Text(
                                                                                utf8.decode(data.blocs![index].name!.runes.toList()),
                                                                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          const SizedBox(
                                                                            height:
                                                                                2,
                                                                          ),
                                                                          Text(
                                                                              "Address: ${utf8.decode(data.blocs![index].address!.runes.toList())}",
                                                                              overflow: TextOverflow.ellipsis),
                                                                          RatingStars(
                                                                            animationDuration:
                                                                                const Duration(seconds: 4),
                                                                            maxValue:
                                                                                5.0,
                                                                            starColor:
                                                                                secondaryColor,
                                                                            value:
                                                                                data.blocs![index].totalAverageRating!,
                                                                            starOffColor:
                                                                                Colors.lightBlueAccent,
                                                                            starCount:
                                                                                5,
                                                                            valueLabelMargin:
                                                                                const EdgeInsets.only(right: 1.0),
                                                                            valueLabelVisibility:
                                                                                true,
                                                                          ),
                                                                          const SizedBox(
                                                                            height:
                                                                                5,
                                                                          ),
                                                                          Text(
                                                                              "(${data.blocs![index].numberOfRating} number of reviews)"),
                                                                          const SizedBox(
                                                                            height:
                                                                                15,
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              Expanded(
                                                                                flex: 2,
                                                                                child: Text(
                                                                                  "VND: ${currencyFormat.format(data.blocs![index].homestays![0].price)} ~ ${currencyFormat.format(data.blocs![index].homestays![data.blocs![index].homestays!.length - 1].price)} / day",
                                                                                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                                                                                ),
                                                                              ),
                                                                              Expanded(
                                                                                flex: 1,
                                                                                child: Text(
                                                                                  "(${data.blocs![index].homestays!.length} homestays)",
                                                                                  style: const TextStyle(fontWeight: FontWeight.w300, fontSize: 15),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          )
                                                                        ]),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      )),
                                        ),
                                      ],
                                    );
                                  } else {
                                    return const Center(
                                      child: Text(
                                        "Oop, we can't find the homestay which you're looking for.",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    );
                                  }
                              }
                              return const SizedBox();
                            } else {
                              return const SizedBox();
                            }

                          default:
                            break;
                        }

                        return const SizedBox();
                      },
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}

class SelectNextHomestayScreen extends StatefulWidget {
  const SelectNextHomestayScreen({super.key});
  static const String selectNextHomestayScreenRoute = "/next-homestay";

  @override
  State<SelectNextHomestayScreen> createState() =>
      _SelectNextHomestayScreenState();
}

class _SelectNextHomestayScreenState extends State<SelectNextHomestayScreen> {
  final selectNextHomestayBloc = SelectNextHomestayBloc();
  final homestayService = locator.get<IHomestayService>();
  final imageService = locator.get<IImageService>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder<SelectNextHomestayState>(
          stream: selectNextHomestayBloc.stateController.stream,
          initialData: selectNextHomestayBloc.initData(context),
          builder: (context, streamSnapshot) {
            return Scaffold(
              backgroundColor: primaryColor,
              body: SingleChildScrollView(
                child: Column(children: [
                  GestureDetector(
                    onTap: () => selectNextHomestayBloc.eventController.sink
                        .add(OnTabChooseFilterNextHomestayEvent(
                            context: context,
                            homestayType: streamSnapshot.data!.homestayType)),
                    child: Container(
                      width: 200,
                      height: 50,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: primaryColor,
                          border: Border.fromBorderSide(
                              BorderSide(width: 2.0, color: Colors.black))),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.filter_alt,
                              color: Colors.black,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Choose filter",
                              style: TextStyle(
                                  fontFamily: "Lobster",
                                  fontWeight: FontWeight.bold),
                            )
                          ]),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  FutureBuilder(
                      future: homestayService.getHomestayByFilter(
                          streamSnapshot.data!.searchFilter(),
                          0,
                          5,
                          false,
                          false),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return SizedBox(
                              height: 600,
                              child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: 5,
                                  itemBuilder: (context, index) =>
                                      TweenAnimationBuilder(
                                        tween: Tween<double>(begin: 0, end: 1),
                                        duration: const Duration(seconds: 4),
                                        builder: (context, value, child) =>
                                            Opacity(
                                          opacity: value,
                                          child: child,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 150,
                                              width: 400,
                                              margin: const EdgeInsets.only(
                                                  left: 10, right: 10),
                                              padding: const EdgeInsets.only(
                                                top: 50,
                                              ),
                                              decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  10),
                                                          topRight:
                                                              Radius.circular(
                                                                  10)),
                                                  color: Colors.white24),
                                            ),
                                            Container(
                                              height: 150,
                                              width: 400,
                                              margin: const EdgeInsets.only(
                                                  left: 10, right: 10),
                                              decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  10),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  10)),
                                                  color: Colors.white),
                                              child: Container(
                                                padding: const EdgeInsets.only(
                                                  left: 10,
                                                ),
                                                child: const SizedBox(),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                          ],
                                        ),
                                      )),
                            );
                          case ConnectionState.done:
                            final data = snapshot.data;
                            if (data is HomestayListPagingModel) {
                              if (data.homestays!.isNotEmpty) {
                                return Column(
                                  children: [
                                    Text(
                                      "${data.homestays!.length} homestay were found",
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    SizedBox(
                                      height: 600,
                                      child: ListView.builder(
                                          scrollDirection: Axis.vertical,
                                          itemCount: data.homestays!.length,
                                          itemBuilder: (context, index) =>
                                              TweenAnimationBuilder(
                                                tween: Tween<double>(
                                                    begin: 0, end: 1),
                                                duration: Duration(
                                                    seconds: index + 1),
                                                builder:
                                                    (context, value, child) =>
                                                        Opacity(
                                                  opacity: value,
                                                  child: child,
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    FutureBuilder(
                                                      future: imageService
                                                          .getHomestayImage(data
                                                              .homestays![index]
                                                              .homestayImages![
                                                                  0]
                                                              .imageUrl!),
                                                      builder: (context,
                                                          imageSnapshot) {
                                                        switch (imageSnapshot
                                                            .connectionState) {
                                                          case ConnectionState
                                                              .waiting:
                                                            return Container(
                                                              height: 150,
                                                              width: 400,
                                                              margin:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 10,
                                                                      right:
                                                                          10),
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                top: 50,
                                                              ),
                                                              decoration: const BoxDecoration(
                                                                  color: Colors
                                                                      .white24,
                                                                  borderRadius: BorderRadius.only(
                                                                      topLeft: Radius
                                                                          .circular(
                                                                              10),
                                                                      topRight:
                                                                          Radius.circular(
                                                                              10))),
                                                            );
                                                          case ConnectionState
                                                              .done:
                                                            String imageUrl =
                                                                imageSnapshot
                                                                        .data ??
                                                                    'https://i.ytimg.com/vi/0jDUx3jOBfU/mqdefault.jpg';
                                                            return GestureDetector(
                                                              onTap: () {
                                                                selectNextHomestayBloc
                                                                    .eventController
                                                                    .sink
                                                                    .add(ViewNextHomestayDetailEvent(
                                                                        context:
                                                                            context,
                                                                        homestayName: data
                                                                            .homestays![index]
                                                                            .name));
                                                              },
                                                              child: Container(
                                                                height: 150,
                                                                width: 400,
                                                                margin:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            10,
                                                                        right:
                                                                            10),
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                  top: 50,
                                                                ),
                                                                decoration: BoxDecoration(
                                                                    image: DecorationImage(
                                                                        image: NetworkImage(
                                                                            imageUrl),
                                                                        fit: BoxFit
                                                                            .fill),
                                                                    borderRadius: const BorderRadius
                                                                            .only(
                                                                        topLeft:
                                                                            Radius.circular(
                                                                                10),
                                                                        topRight:
                                                                            Radius.circular(10))),
                                                              ),
                                                            );
                                                          default:
                                                            break;
                                                        }
                                                        return Container(
                                                          height: 150,
                                                          width: 200,
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 10),
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                            top: 50,
                                                          ),
                                                          decoration: const BoxDecoration(
                                                              color: Colors
                                                                  .white24,
                                                              borderRadius: BorderRadius.only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          10),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          10))),
                                                        );
                                                      },
                                                    ),
                                                    Container(
                                                      height: 150,
                                                      width: 400,
                                                      margin:
                                                          const EdgeInsets.only(
                                                              left: 10,
                                                              right: 10,
                                                              bottom: 10),
                                                      decoration: const BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          10),
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          10)),
                                                          color: Colors.white),
                                                      child: GestureDetector(
                                                        onTap: () => {},
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                            left: 10,
                                                          ),
                                                          child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                const SizedBox(
                                                                  height: 10,
                                                                ),
                                                                Text(
                                                                  utf8.decode(data
                                                                      .homestays![
                                                                          index]
                                                                      .name!
                                                                      .runes
                                                                      .toList()),
                                                                  style: const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          25),
                                                                ),
                                                                const SizedBox(
                                                                  height: 2,
                                                                ),
                                                                Text(
                                                                  "Address: ${utf8.decode(data.homestays![index].address!.runes.toList())}",
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                                const SizedBox(
                                                                  height: 10,
                                                                ),
                                                                RatingStars(
                                                                  animationDuration:
                                                                      const Duration(
                                                                          seconds:
                                                                              4),
                                                                  maxValue: 5.0,
                                                                  starColor:
                                                                      secondaryColor,
                                                                  value: data
                                                                      .homestays![
                                                                          index]
                                                                      .totalAverageRating!,
                                                                  starOffColor:
                                                                      Colors
                                                                          .lightBlueAccent,
                                                                  starCount: 5,
                                                                  valueLabelMargin:
                                                                      const EdgeInsets
                                                                          .only(
                                                                    right: 1.0,
                                                                  ),
                                                                  valueLabelVisibility:
                                                                      true,
                                                                ),
                                                                const SizedBox(
                                                                  width: 5,
                                                                ),
                                                                Text(
                                                                    "(${data.homestays![index].numberOfRating} number of reviews)"),
                                                                const SizedBox(
                                                                  height: 10,
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Expanded(
                                                                      flex: 3,
                                                                      child:
                                                                          Text(
                                                                        "VND: ${currencyFormat.format(data.homestays![index].price)} / day",
                                                                        style: const TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            fontSize: 15),
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child:
                                                                          Text(
                                                                        "${data.homestays![index].availableRooms} rooms",
                                                                        style: const TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.w300,
                                                                            fontSize: 15),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )
                                                              ]),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )),
                                    ),
                                  ],
                                );
                              } else {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: const [
                                    Text(
                                      "Oop, we can't find the homestay which you're looking for.",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                );
                              }
                            } else {
                              return const SizedBox();
                            }

                          default:
                            break;
                        }
                        return const SizedBox();
                      })
                ]),
              ),
            );
          }),
    );
  }
}
