import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

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
  final bookingStartDateTextEditingController = TextEditingController();
  final bookingEndDateTextEditingController = TextEditingController();
  RangeValues currentPriceRangeValue = const RangeValues(0, 0);
  RangeValues currentRatingRangeValue = const RangeValues(0, 0);

  String currentFacility = "None";
  String currentService = "None";
  double currentFacilityQuantity = 0;
  double currentServicePrice = 0;
  final locationService = locator.get<ILocationService>();
  final autoCompleteService = locator.get<IAutoCompleteService>();
  HomestayType homestayType = HomestayType.homestay;
  LocationType locationType = LocationType.nearby;
  Distance distance = Distance.one;

  dynamic data;

  String displayStringForOption(Prediction prediction) =>
      utf8.decode(prediction.description!.runes.toList());

  @override
  Widget build(BuildContext context) {
    List<String> facilities = ["None"];
    List<String> services = ["None"];
    int homestayHighestPrice = 100;
    int homestayServiceHighestPrice = 100;
    final contextArguments = ModalRoute.of(context)!.settings.arguments as Map;
    FilterAddtionalInformationModel filterAdditional =
        contextArguments["filterAddtionalInformation"];
    Position? position = contextArguments["position"];
    if (filterAdditional.homestayFacilityNames != null ||
        filterAdditional.homestayFacilityNames!.isNotEmpty) {
      facilities.addAll(filterAdditional.homestayFacilityNames!);
    }
    if (filterAdditional.homestayServiceNames != null ||
        filterAdditional.homestayServiceNames!.isNotEmpty) {
      services.addAll(filterAdditional.homestayServiceNames!);
    }
    if (filterAdditional.homestayHighestPrice != null) {
      homestayHighestPrice = filterAdditional.homestayHighestPrice!;
    }
    if (filterAdditional.homestayServiceHighestPrice != null) {
      homestayServiceHighestPrice =
          filterAdditional.homestayServiceHighestPrice!;
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
        child: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            const Text(
              "Choose homestay",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 20),
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: ListTile(
                    title: Text(HomestayType.homestay.name),
                    leading: Radio<HomestayType>(
                      activeColor: primaryColor,
                      value: HomestayType.homestay,
                      groupValue: homestayType,
                      onChanged: (value) {},
                    ),
                  ),
                ),
                const SizedBox(
                  width: 30,
                ),
                Expanded(
                  flex: 1,
                  child: ListTile(
                    title: Text(HomestayType.bloc.name),
                    leading: Radio<HomestayType>(
                      activeColor: primaryColor,
                      value: HomestayType.bloc,
                      groupValue: homestayType,
                      onChanged: (value) {},
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 30,
            ),
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
                              lastDate:
                                  DateTime.now().add(const Duration(days: 365)))
                          .then((value) {
                        bookingStartDateTextEditingController.text =
                            dateFormat.format(value!);
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
                                  .parse(bookingStartDateTextEditingController
                                      .text)
                                  .add(const Duration(days: 1)),
                              firstDate: dateFormat
                                  .parse(bookingStartDateTextEditingController
                                      .text)
                                  .add(const Duration(days: 1)),
                              lastDate: dateFormat
                                  .parse(bookingStartDateTextEditingController
                                      .text)
                                  .add(const Duration(days: 365)))
                          .then((value) {
                        bookingEndDateTextEditingController.text =
                            dateFormat.format(value!);
                      });
                    },
                  ),
                )
              ],
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
                            groupValue: locationType,
                            onChanged: (value) {},
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
                            groupValue: locationType,
                            onChanged: (value) {},
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

              fieldViewBuilder: (context, textEditingController, focusNode,
                      onFieldSubmitted) =>
                  SizedBox(
                width: 350,
                child: TextFormField(
                  readOnly: true,
                  controller: textEditingController,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    hintText: "Enter address",
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                            color: Colors.black45, width: 1.0)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                            color: Colors.black45, width: 1.0)),
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
                            groupValue: distance,
                            activeColor: primaryColor,
                            onChanged: (value) {},
                          ),
                        )),
                    Expanded(
                        flex: 1,
                        child: ListTile(
                          title: const Text("3 km"),
                          leading: Radio<Distance>(
                            value: Distance.three,
                            groupValue: distance,
                            activeColor: primaryColor,
                            onChanged: (value) {},
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
                            groupValue: distance,
                            activeColor: primaryColor,
                            onChanged: (value) {},
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
                  labels: RangeLabels(currentRatingRangeValue.start.toString(),
                      currentRatingRangeValue.end.toString()),
                  values: currentRatingRangeValue,
                  onChanged: (value) {
                    setState(() {
                      currentRatingRangeValue = value;
                    });
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Lowest: ${currentRatingRangeValue.start}"),
                    const Icon(
                      Icons.star,
                      color: Colors.yellow,
                    ),
                    const SizedBox(
                      width: 170,
                    ),
                    Text("Highest: ${currentRatingRangeValue.end}"),
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
                  values: currentPriceRangeValue,
                  labels: RangeLabels(
                      currencyFormat.format(currentPriceRangeValue.start),
                      currencyFormat.format(currentPriceRangeValue.end)),
                  onChanged: (value) {
                    setState(() {
                      currentPriceRangeValue = value;
                    });
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Lowest: "),
                    Text(
                        "${currencyFormat.format(currentPriceRangeValue.start.toInt())} VND"),
                    const SizedBox(
                      width: 100,
                    ),
                    const Text("Highest: "),
                    Text(
                        "${currencyFormat.format(currentPriceRangeValue.end.toInt())} VND")
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text("Homestay Facility filter",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20)),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: DropdownButton<String>(
                          value: currentFacility,
                          icon: const Icon(
                            Icons.house,
                            color: primaryColor,
                          ),
                          underline: Container(
                            color: Colors.transparent,
                          ),
                          items: facilities
                              .map<DropdownMenuItem<String>>(
                                  (e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(e),
                                      ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              currentFacility = value!;
                            });
                          },
                        )),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Slider(
                            activeColor: primaryColor,
                            min: 0,
                            max: 100,
                            divisions: 100,
                            label: currentFacilityQuantity.toInt().toString(),
                            value: currentFacilityQuantity,
                            onChanged: (value) {
                              setState(() {
                                if (currentFacility != "None") {
                                  currentFacilityQuantity = value;
                                }
                              });
                            },
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 20),
                            child: Text(
                                "Quantity: ${currentFacilityQuantity.toInt()}"),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text("Homestay Service filter",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20)),
                Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: DropdownButton<String>(
                          value: currentService,
                          icon: const Icon(
                            Icons.room_service,
                            color: primaryColor,
                          ),
                          underline: Container(
                            color: Colors.transparent,
                          ),
                          items: services
                              .map<DropdownMenuItem<String>>(
                                  (e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(e),
                                      ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              currentService = value!;
                            });
                          },
                        )),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Slider(
                            activeColor: primaryColor,
                            min: 0,
                            max: homestayServiceHighestPrice.toDouble(),
                            divisions: homestayServiceHighestPrice,
                            label: currencyFormat
                                .format(currentServicePrice.toInt()),
                            value: currentServicePrice,
                            onChanged: (value) {
                              setState(() {
                                if (currentService != "None") {
                                  currentServicePrice = value;
                                }
                              });
                            },
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 20),
                            child: Text(
                                "Price: ${currencyFormat.format(currentServicePrice.toInt())}"),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(top: 30, bottom: 10),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          maximumSize: const Size(150, 50),
                          minimumSize: const Size(150, 50),
                          backgroundColor: primaryColor),
                      onPressed: () {},
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
        ),
      ),
    );
  }
}
