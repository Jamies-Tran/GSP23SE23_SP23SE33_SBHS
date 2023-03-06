import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:staywithme_passenger_application/bloc/event/filter_homestay_event.dart';
import 'package:staywithme_passenger_application/bloc/filter_homestay_bloc.dart';
import 'package:staywithme_passenger_application/bloc/state/filter_homestay_state.dart';

import 'package:staywithme_passenger_application/global_variable.dart';
import 'package:staywithme_passenger_application/model/auto_complete_model.dart';
import 'package:staywithme_passenger_application/model/search_filter_model.dart';
import 'package:staywithme_passenger_application/service/homestay/homestay_service.dart';
import 'package:staywithme_passenger_application/service/location/location_service.dart';
import 'package:staywithme_passenger_application/service/user/auto_complete_service.dart';
import 'package:staywithme_passenger_application/service_locator/service_locator.dart';

enum HomestayType { homestay, bloc }

enum LocationType { nearby, address }

enum Distance { one, three, five }

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});
  static const filterScreenRoute = "/filter-homestay";

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  final homestayService = locator.get<IHomestayService>();
  final filterHomestayBloc = FilterHomestayBloc();
  final bookingStartDateTextEditingController = TextEditingController();
  final bookingEndDateTextEditingController = TextEditingController();
  final bookingTotalRoomTextEditingController = TextEditingController();
  RangeValues currentPriceRangeValue = const RangeValues(0, 0);
  RangeValues currentRatingRangeValue = const RangeValues(0, 0);

  String currentFacility = "None";
  String currentService = "None";
  double currentFacilityQuantity = 0;
  double currentServicePrice = 0;
  final locationService = locator.get<ILocationService>();
  final autoCompleteService = locator.get<IAutoCompleteService>();
  // HomestayType homestayType = HomestayType.homestay;
  LocationType locationType = LocationType.nearby;
  Distance distance = Distance.one;

  String displayStringForOption(Prediction prediction) =>
      utf8.decode(prediction.description!.runes.toList());

  @override
  void dispose() {
    filterHomestayBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> facilities = ["None"];
    List<String> services = ["None"];
    int homestayHighestPrice = 100000;
    int homestayServiceHighestPrice = 100000;
    final contextArguments = ModalRoute.of(context)!.settings.arguments as Map;
    FilterAddtionalInformationModel? filterAdditional =
        contextArguments["filterAddtionalInformation"];
    Position? position = contextArguments["position"];
    String? homestayType = contextArguments["homestayType"];
    if (filterAdditional != null) {
      if (filterAdditional.homestayFacilityNames != null ||
          filterAdditional.homestayFacilityNames!.isNotEmpty) {
        facilities.addAll(filterAdditional.homestayFacilityNames!);
      }
      if (filterAdditional.homestayServiceNames != null ||
          filterAdditional.homestayServiceNames!.isNotEmpty) {
        services.addAll(filterAdditional.homestayServiceNames!);
      }
      if (filterAdditional.homestayHighestPrice != null &&
          filterAdditional.homestayHighestPrice! > 0) {
        homestayHighestPrice = filterAdditional.homestayHighestPrice!;
      }
      if (filterAdditional.homestayServiceHighestPrice != null &&
          filterAdditional.homestayServiceHighestPrice! > 0) {
        homestayServiceHighestPrice =
            filterAdditional.homestayServiceHighestPrice!;
      }
    }

    return Scaffold(
      appBar: AppBar(
          title: const Text(
            "Filter",
            style: TextStyle(
                fontFamily: "Lobster",
                color: Colors.black,
                fontWeight: FontWeight.bold),
          ),
          automaticallyImplyLeading: false,
          backgroundColor: primaryColor,
          centerTitle: true,
          actions: [
            TextButton(
                onPressed: () {},
                child: const Text(
                  "Back",
                  style: TextStyle(
                      fontFamily: "Lobster",
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ))
          ]),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: StreamBuilder<FilterHomestayState>(
            stream: filterHomestayBloc.stateController.stream,
            initialData: filterHomestayBloc.initData(homestayType!),
            builder: (context, snapshot) {
              return Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  // const Text(
                  //   "Choose homestay",
                  //   style: TextStyle(
                  //       fontWeight: FontWeight.bold,
                  //       color: Colors.black,
                  //       fontSize: 20),
                  // ),
                  // const SizedBox(
                  //   height: 5,
                  // ),
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       flex: 1,
                  //       child: ListTile(
                  //         title: Text(HomestayType.homestay.name),
                  //         leading: Radio<HomestayType>(
                  //           activeColor: primaryColor,
                  //           value: HomestayType.homestay,
                  //           groupValue: snapshot.data!.homestayType,
                  //           onChanged: (value) {
                  //             filterHomestayBloc.eventController.sink.add(
                  //                 ChooseHomestayTypeFilterEvent(
                  //                     homestayType: value));
                  //           },
                  //         ),
                  //       ),
                  //     ),
                  //     const SizedBox(
                  //       width: 30,
                  //     ),
                  //     Expanded(
                  //       flex: 1,
                  //       child: ListTile(
                  //         title: Text(HomestayType.bloc.name),
                  //         leading: Radio<HomestayType>(
                  //           activeColor: primaryColor,
                  //           value: HomestayType.bloc,
                  //           groupValue: snapshot.data!.homestayType,
                  //           onChanged: (value) {
                  //             filterHomestayBloc.eventController.sink.add(
                  //                 ChooseHomestayTypeFilterEvent(
                  //                     homestayType: value));
                  //           },
                  //         ),
                  //       ),
                  //     )
                  //   ],
                  // ),
                  // const SizedBox(
                  //   height: 30,
                  // ),
                  const Text(
                    "Booking date filter",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                          controller: bookingStartDateTextEditingController,
                          readOnly: true,
                          decoration: InputDecoration(
                              hintText: "Start date",
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(
                                      color: secondaryColor, width: 1.0)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(
                                      color: secondaryColor, width: 1.0))),
                          onTap: () {
                            showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.now()
                                        .add(const Duration(days: 365)))
                                .then((value) {
                              bookingStartDateTextEditingController.text =
                                  dateFormat.format(value!);
                              filterHomestayBloc.eventController.sink.add(
                                  ChooseBookingStartDateFilterEvent(
                                      start:
                                          bookingStartDateTextEditingController
                                              .text));
                            });
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                          controller: bookingEndDateTextEditingController,
                          readOnly: true,
                          decoration: InputDecoration(
                              hintText: "End date",
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(
                                      color: secondaryColor, width: 1.0)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(
                                      color: secondaryColor, width: 1.0))),
                          onTap: () {
                            showDatePicker(
                                    context: context,
                                    initialDate: dateFormat
                                        .parse(
                                            bookingStartDateTextEditingController
                                                .text)
                                        .add(const Duration(days: 1)),
                                    firstDate: dateFormat
                                        .parse(
                                            bookingStartDateTextEditingController
                                                .text)
                                        .add(const Duration(days: 1)),
                                    lastDate: dateFormat
                                        .parse(
                                            bookingStartDateTextEditingController
                                                .text)
                                        .add(const Duration(days: 365)))
                                .then((value) {
                              bookingEndDateTextEditingController.text =
                                  dateFormat.format(value!);
                              filterHomestayBloc.eventController.sink.add(
                                  ChooseBookingEndDateFilterEvent(
                                      end: bookingEndDateTextEditingController
                                          .text));
                            });
                          },
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: bookingTotalRoomTextEditingController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        hintText: "Total room",
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                                color: secondaryColor, width: 1.0)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                                color: secondaryColor, width: 1.0))),
                    onChanged: (value) {
                      filterHomestayBloc.eventController.sink.add(
                          InputTotalBookingRoomEvent(
                              totalBookingRoom: int.parse(value)));
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text("Location filter",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20)),
                  const SizedBox(
                    height: 5,
                  ),
                  position != null
                      ? Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: ListTile(
                                title: Text(LocationType.address.name),
                                leading: Radio<LocationType>(
                                  activeColor: primaryColor,
                                  value: LocationType.address,
                                  groupValue: snapshot.data!.locationType,
                                  onChanged: (value) {
                                    filterHomestayBloc.eventController.sink.add(
                                        ChooseLocationTypeFilterEvent(
                                            locationType: value));
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 50,
                            ),
                            Expanded(
                              flex: 1,
                              child: ListTile(
                                title: Text(LocationType.nearby.name),
                                leading: Radio<LocationType>(
                                  activeColor: primaryColor,
                                  value: LocationType.nearby,
                                  groupValue: snapshot.data!.locationType,
                                  onChanged: (value) {
                                    filterHomestayBloc.eventController.sink.add(
                                        ChooseLocationTypeFilterEvent(
                                            locationType: value));
                                    filterHomestayBloc.eventController.sink.add(
                                        ChooseNearByFilterEvent(
                                            position: position));
                                  },
                                ),
                              ),
                            ),
                          ],
                        )
                      : const SizedBox(),
                  const SizedBox(
                    height: 5,
                  ),
                  Autocomplete<Prediction>(
                    displayStringForOption: displayStringForOption,

                    fieldViewBuilder: (context, textEditingController,
                            focusNode, onFieldSubmitted) =>
                        SizedBox(
                      width: 350,
                      child: TextFormField(
                        readOnly: snapshot.data!.isInputAddress!,
                        controller: textEditingController,
                        focusNode: focusNode,
                        decoration: InputDecoration(
                          hintText: "Enter address",
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                  color: snapshot.data!.isInputAddress!
                                      ? Colors.black45
                                      : primaryColor,
                                  width: 1.0)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                  color: snapshot.data!.isInputAddress!
                                      ? Colors.black45
                                      : primaryColor,
                                  width: 1.0)),
                        ),
                      ),
                    ),
                    optionsBuilder: (textEditingValue) {
                      if (textEditingValue.text.isEmpty ||
                          textEditingValue.text == '') {
                        return const Iterable.empty();
                      }

                      return autoCompleteService
                          .autoComplete(textEditingValue.text)
                          .then((value) {
                        if (value is PlacesResult) {
                          return value.predictions!.where((element) => utf8
                              .decode(element.description!.runes.toList())
                              .toLowerCase()
                              .contains(textEditingValue.text.toLowerCase()));
                        } else {
                          return const Iterable.empty();
                        }
                      });
                    },
                    // onSelected: (option) => ,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        Text(
                          "choose distance",
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                              flex: 1,
                              child: ListTile(
                                title: const Text("1 km"),
                                leading: Radio<Distance>(
                                  value: Distance.one,
                                  groupValue: snapshot.data!.distance,
                                  activeColor: primaryColor,
                                  onChanged: (value) {
                                    filterHomestayBloc.eventController.sink.add(
                                        ChooseDistanceFilterEvent(
                                            distance: value));
                                  },
                                ),
                              )),
                          Expanded(
                              flex: 1,
                              child: ListTile(
                                title: const Text("3 km"),
                                leading: Radio<Distance>(
                                  value: Distance.three,
                                  groupValue: snapshot.data!.distance,
                                  activeColor: primaryColor,
                                  onChanged: (value) {
                                    filterHomestayBloc.eventController.sink.add(
                                        ChooseDistanceFilterEvent(
                                            distance: value));
                                  },
                                ),
                              )),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                              flex: 1,
                              child: ListTile(
                                title: const Text("5 km"),
                                leading: Radio<Distance>(
                                  value: Distance.five,
                                  groupValue: snapshot.data!.distance,
                                  activeColor: primaryColor,
                                  onChanged: (value) {
                                    filterHomestayBloc.eventController.sink.add(
                                        ChooseDistanceFilterEvent(
                                            distance: value));
                                  },
                                ),
                              )),
                          const Expanded(
                            flex: 1,
                            child: SizedBox(),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text("Rating filter",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20)),
                      const SizedBox(
                        height: 20,
                      ),
                      RangeSlider(
                        activeColor: primaryColor,
                        divisions: 5,
                        min: 0,
                        max: 5,
                        labels: RangeLabels(
                            snapshot.data!.ratingRangeValue!.start.toString(),
                            snapshot.data!.ratingRangeValue!.end.toString()),
                        values: snapshot.data!.ratingRangeValue!,
                        onChanged: (value) {
                          filterHomestayBloc.eventController.sink.add(
                              ChooseRatingFilterEvent(
                                  end: value.end, start: value.start));
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                              "Lowest: ${snapshot.data!.ratingRangeValue!.start}"),
                          const Icon(
                            Icons.star,
                            color: Colors.yellow,
                          ),
                          const SizedBox(
                            width: 170,
                          ),
                          Text(
                              "Highest: ${snapshot.data!.ratingRangeValue!.end}"),
                          const Icon(
                            Icons.star,
                            color: Colors.yellow,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      const Text("Price filter",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20)),
                      RangeSlider(
                        activeColor: primaryColor,
                        divisions: 5,
                        min: 0,
                        max: homestayHighestPrice.toDouble(),
                        values: snapshot.data!.priceRangeValue!,
                        labels: RangeLabels(
                            currencyFormat
                                .format(snapshot.data!.priceRangeValue!.start),
                            currencyFormat
                                .format(snapshot.data!.priceRangeValue!.end)),
                        onChanged: (value) {
                          filterHomestayBloc.eventController.sink.add(
                              ChoosePriceFilterEvent(
                                  start: value.start, end: value.end));
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Lowest: "),
                          Text(
                              "${currencyFormat.format(snapshot.data!.priceRangeValue!.start.toInt())} VND"),
                          const SizedBox(
                            width: 100,
                          ),
                          const Text("Highest: "),
                          Text(
                              "${currencyFormat.format(snapshot.data!.priceRangeValue!.end.toInt())} VND")
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      const Text("Homestay facility filter",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20)),
                      const SizedBox(
                        height: 20,
                      ),
                      DropdownButton<String>(
                        value: snapshot.data!.facilityName,
                        icon: const Icon(
                          Icons.arrow_downward,
                          color: primaryColor,
                        ),
                        underline: Container(
                          height: 2,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: primaryColor),
                        ),
                        items: facilities
                            .map<DropdownMenuItem<String>>(
                                (e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e),
                                    ))
                            .toList(),
                        onChanged: (value) {
                          filterHomestayBloc.eventController.sink.add(
                              ChooseFacilityFilterEvent(facilityName: value));
                        },
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Slider(
                            activeColor: primaryColor,
                            min: 0,
                            max: 100,
                            divisions: 100,
                            label: snapshot.data!.facilityQuantity!
                                .toInt()
                                .toString(),
                            value: snapshot.data!.facilityQuantity!.toDouble(),
                            onChanged: (value) {
                              filterHomestayBloc.eventController.sink.add(
                                  ChooseFacilityQuantityFilterEvent(
                                      quantity: value));
                            },
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 20),
                            child: Text(
                                "Quantity: ${snapshot.data!.facilityQuantity!.toInt()}"),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text("Homestay service filter",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20)),
                      DropdownButton<String>(
                        value: snapshot.data!.serviceName,
                        icon: const Icon(
                          Icons.arrow_downward,
                          color: primaryColor,
                        ),
                        underline: Container(
                          height: 2,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: primaryColor),
                        ),
                        items: services
                            .map<DropdownMenuItem<String>>(
                                (e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e),
                                    ))
                            .toList(),
                        onChanged: (value) {
                          filterHomestayBloc.eventController.sink.add(
                              ChooseHomestayServiceFilterEvent(
                                  serviceName: value));
                        },
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Slider(
                            activeColor: primaryColor,
                            min: 0,
                            max: homestayServiceHighestPrice.toDouble(),
                            divisions: homestayServiceHighestPrice,
                            label: currencyFormat
                                .format(snapshot.data!.servicePrice),
                            value: snapshot.data!.servicePrice!.toDouble(),
                            onChanged: (value) {
                              filterHomestayBloc.eventController.sink.add(
                                  ChooseHomestayServicePriceFilterEvent(
                                      price: value));
                            },
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 20),
                            child: Text(
                                "Price: ${currencyFormat.format(snapshot.data!.servicePrice)}"),
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 30, bottom: 30),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                maximumSize: const Size(150, 50),
                                minimumSize: const Size(150, 50),
                                backgroundColor: primaryColor),
                            onPressed: () {
                              filterHomestayBloc.eventController.sink.add(
                                  OnClickSearchHomestayEvent(
                                      context: context,
                                      searchFilterModel: snapshot.data!
                                          .generateSearchFilterModel(),
                                      homestayType: homestayType));
                            },
                            child: const Text(
                              "Search",
                              style: TextStyle(
                                  fontFamily: "Lobster",
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            )),
                      )
                    ],
                  )
                ],
              );
            }),
      ),
    );
  }
}
