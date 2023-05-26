import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:staywithme_passenger_application/bloc/event/homestay_event.dart';
import 'package:staywithme_passenger_application/bloc/homestay_bloc.dart';
import 'package:staywithme_passenger_application/global_variable.dart';
import 'package:staywithme_passenger_application/model/campaign_model.dart';
import 'package:staywithme_passenger_application/model/homestay_city_province_model.dart';
import 'package:staywithme_passenger_application/model/homestay_model.dart';
import 'package:staywithme_passenger_application/model/search_filter_model.dart';
import 'package:staywithme_passenger_application/service/homestay/homestay_service.dart';
import 'package:staywithme_passenger_application/service/image_service.dart';
import 'package:staywithme_passenger_application/service/promotion/campaign_service.dart';
import 'package:staywithme_passenger_application/service/user/user_service.dart';
import 'package:staywithme_passenger_application/service_locator/service_locator.dart';

class HomestayScreen extends StatefulWidget {
  const HomestayScreen({super.key, this.position});
  final Position? position;

  @override
  State<HomestayScreen> createState() => _HomestayScreenState();
}

class _HomestayScreenState extends State<HomestayScreen> {
  final userService = locator.get<IUserService>();
  final homestayService = locator.get<IHomestayService>();
  final imageService = locator.get<IImageService>();
  final campaignService = locator.get<ICampaignService>();
  final homestayBloc = HomestayBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.only(top: 50),
        color: secondaryColor,
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: const Duration(seconds: 2),
                  builder: (context, value, child) => Opacity(
                    opacity: value,
                    child: child,
                  ),
                  child: const Center(
                    child: Text("Stay with me",
                        style: TextStyle(
                            fontFamily: "Lobster",
                            fontSize: 50,
                            color: Colors.black)),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: const Duration(seconds: 3),
                  builder: (context, value, child) =>
                      Opacity(opacity: value, child: child),
                  child: SizedBox(
                    width: 320,
                    child: TextFormField(
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Where do you want to go...",
                        hintStyle: TextStyle(
                            fontFamily: "Lobster", color: Colors.black45),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: secondaryColor),
                            borderRadius:
                                BorderRadius.all(Radius.circular(50))),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: secondaryColor),
                            borderRadius:
                                BorderRadius.all(Radius.circular(50))),
                      ),
                      readOnly: true,
                      onTap: () => homestayBloc.eventController.sink.add(
                          OnClickSearchTextFieldEvent(
                              context: context,
                              position: widget.position,
                              homestayType: "homestay")),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white10),
                  height: 408,
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  child: Column(
                    children: [
                      TweenAnimationBuilder(
                          tween: Tween<double>(begin: 0, end: 1),
                          duration: const Duration(seconds: 4),
                          builder: (context, value, child) => Opacity(
                                opacity: value,
                                child: child,
                              ),
                          child: Container(
                            margin: const EdgeInsets.only(left: 10),
                            child: const Text(
                              "Promotion for you",
                              style: TextStyle(
                                  fontFamily: "Lobster",
                                  fontWeight: FontWeight.bold,
                                  color: Colors.lightBlueAccent,
                                  fontSize: 30),
                            ),
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                      FutureBuilder(
                        future: campaignService.getCampaignListByStatus(
                            "PROGRESSING", 0, 2000, true, true),
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return SizedBox(
                                height: 150,
                                width: MediaQuery.of(context).size.width,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 5,
                                  itemBuilder: (context, index) =>
                                      TweenAnimationBuilder(
                                    tween: Tween<double>(
                                      begin: 0,
                                      end: 1,
                                    ),
                                    duration: const Duration(seconds: 1),
                                    builder: (context, value, child) => Opacity(
                                      opacity: value,
                                      child: child,
                                    ),
                                    child: TweenAnimationBuilder(
                                      tween: Tween<double>(begin: 1, end: 0),
                                      duration: const Duration(seconds: 3),
                                      builder: (context, value, child) =>
                                          Opacity(
                                        opacity: value,
                                        child: child,
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white10,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        height: 200,
                                        width: 200,
                                        margin: const EdgeInsets.only(left: 10),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            case ConnectionState.done:
                              if (snapshot.hasData) {
                                final data = snapshot.data;
                                if (data is CampaignListPagingModel) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      data.campaigns!.isNotEmpty
                                          ? SizedBox(
                                              height: 350,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: ListView.builder(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount:
                                                      data.campaigns!.length > 5
                                                          ? 5
                                                          : data.campaigns!
                                                              .length,
                                                  itemBuilder:
                                                      (context, index) =>
                                                          TweenAnimationBuilder(
                                                            tween:
                                                                Tween<double>(
                                                                    begin: 0,
                                                                    end: 1),
                                                            duration:
                                                                const Duration(
                                                                    seconds: 4),
                                                            builder: (context,
                                                                    value,
                                                                    child) =>
                                                                Opacity(
                                                              opacity: value,
                                                              child: child,
                                                            ),
                                                            child:
                                                                GestureDetector(
                                                              onTap: () => homestayBloc
                                                                  .eventController
                                                                  .sink
                                                                  .add(OnClickCampaignEvent(
                                                                      context:
                                                                          context,
                                                                      campaignName: utf8.decode(data
                                                                          .campaigns![
                                                                              index]
                                                                          .name!
                                                                          .runes
                                                                          .toList()),
                                                                      position:
                                                                          widget
                                                                              .position)),
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  FutureBuilder(
                                                                    future: imageService.getCampaignImage(data
                                                                        .campaigns![
                                                                            index]
                                                                        .thumbnailUrl!),
                                                                    builder:
                                                                        (context,
                                                                            imageSnapshot) {
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
                                                                              top: 50,
                                                                            ),
                                                                            decoration:
                                                                                const BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),
                                                                          );
                                                                        case ConnectionState
                                                                            .done:
                                                                          String
                                                                              imageUrl =
                                                                              imageSnapshot.data ?? "https://i.ytimg.com/vi/0jDUx3jOBfU/mqdefault.jpg";
                                                                          return Container(
                                                                            height:
                                                                                150,
                                                                            width:
                                                                                200,
                                                                            margin:
                                                                                const EdgeInsets.only(left: 10),
                                                                            padding:
                                                                                const EdgeInsets.only(
                                                                              top: 50,
                                                                            ),
                                                                            decoration:
                                                                                BoxDecoration(image: DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.fill), borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),
                                                                          );
                                                                        default:
                                                                          break;
                                                                      }
                                                                      return Container(
                                                                        height:
                                                                            100,
                                                                        width:
                                                                            200,
                                                                        margin: const EdgeInsets.only(
                                                                            left:
                                                                                10),
                                                                        padding:
                                                                            const EdgeInsets.only(
                                                                          top:
                                                                              50,
                                                                        ),
                                                                        decoration: const BoxDecoration(
                                                                            color:
                                                                                Colors.white24,
                                                                            borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),
                                                                      );
                                                                    },
                                                                  ),
                                                                  Container(
                                                                    height: 100,
                                                                    width: 200,
                                                                    margin: const EdgeInsets
                                                                            .only(
                                                                        left:
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
                                                                          crossAxisAlignment: CrossAxisAlignment
                                                                              .start,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          children: [
                                                                            const SizedBox(
                                                                              height: 10,
                                                                            ),
                                                                            Row(
                                                                              children: [
                                                                                Text(
                                                                                  utf8.decode(data.campaigns![index].name!.runes.toList()),
                                                                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                                                                ),
                                                                                // Text(
                                                                                //   "(${data.homestays![index].availableRooms} rooms)",
                                                                                //   style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                                                                // ),
                                                                              ],
                                                                            ),
                                                                            const SizedBox(
                                                                              height: 2,
                                                                            ),
                                                                            Text("Discount ${data.campaigns![index].discountPercentage}%"),
                                                                            const SizedBox(
                                                                              height: 10,
                                                                            ),
                                                                            Text("${dateFormat.parseUTC(data.campaigns![index].endDate!).difference(dateFormat.parse(DateTime.now().toString())).inDays} days left"),
                                                                            const SizedBox(
                                                                              height: 15,
                                                                            ),
                                                                          ]),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          )),
                                            )
                                          : SizedBox(
                                              height: 150,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: TweenAnimationBuilder(
                                                tween: Tween<double>(
                                                    begin: 0, end: 1),
                                                duration:
                                                    const Duration(seconds: 4),
                                                builder:
                                                    (context, value, child) =>
                                                        Opacity(
                                                  opacity: value,
                                                  child: child,
                                                ),
                                                child: const Center(
                                                  child: Text(
                                                    "We don't have any bloc homestay right now",
                                                    style: TextStyle(
                                                        fontFamily: "Lobster"),
                                                  ),
                                                ),
                                              )),
                                    ],
                                  );
                                }
                              }
                              break;
                            default:
                              break;
                          }
                          return const SizedBox();
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white10),
                  height: 350,
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  child: Column(
                    children: [
                      TweenAnimationBuilder(
                          tween: Tween<double>(begin: 0, end: 1),
                          duration: const Duration(seconds: 4),
                          builder: (context, value, child) => Opacity(
                                opacity: value,
                                child: child,
                              ),
                          child: Container(
                            margin: const EdgeInsets.only(left: 10),
                            child: const Text(
                              "Places with most homestay",
                              style: TextStyle(
                                  fontFamily: "Lobster",
                                  fontWeight: FontWeight.bold,
                                  color: Colors.lightBlueAccent,
                                  fontSize: 30),
                            ),
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                      FutureBuilder(
                        future: homestayService.getAreaHomestayInfo(),
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return SizedBox(
                                height: 250,
                                width: MediaQuery.of(context).size.width,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 5,
                                  itemBuilder: (context, index) =>
                                      TweenAnimationBuilder(
                                    tween: Tween<double>(begin: 0, end: 1),
                                    duration: const Duration(seconds: 1),
                                    builder: (context, value, child) =>
                                        Opacity(opacity: value, child: child),
                                    child: TweenAnimationBuilder(
                                      tween: Tween<double>(begin: 1, end: 0),
                                      duration: const Duration(seconds: 3),
                                      builder: (context, value, child) =>
                                          Opacity(opacity: value, child: child),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white10,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        height: 150,
                                        width: 150,
                                        margin: const EdgeInsets.only(left: 10),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            case ConnectionState.done:
                              if (snapshot.hasData) {
                                final data = snapshot.data;
                                if (data is TotalHomestayFromLocationModel) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      data.totalHomestays!.isNotEmpty
                                          ? SizedBox(
                                              height: 250,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: ListView.builder(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount: data
                                                              .totalHomestays!
                                                              .length >
                                                          5
                                                      ? 5
                                                      : data.totalHomestays!
                                                          .length,
                                                  itemBuilder:
                                                      (context, index) =>
                                                          TweenAnimationBuilder(
                                                            tween:
                                                                Tween<double>(
                                                                    begin: 0,
                                                                    end: 1),
                                                            duration:
                                                                const Duration(
                                                                    seconds: 4),
                                                            builder: (context,
                                                                    value,
                                                                    child) =>
                                                                Opacity(
                                                              opacity: value,
                                                              child: child,
                                                            ),
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                homestayBloc.eventController.sink.add(OnClickAreaEvent(
                                                                    context:
                                                                        context,
                                                                    position: widget
                                                                        .position,
                                                                    homestayType:
                                                                        "homestay",
                                                                    cityProvince: utf8.decode(data
                                                                        .totalHomestays![
                                                                            index]
                                                                        .cityProvince!
                                                                        .runes
                                                                        .toList())));
                                                              },
                                                              child: Container(
                                                                height: 150,
                                                                width: 150,
                                                                margin:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            10),
                                                                padding: const EdgeInsets
                                                                        .only(
                                                                    top: 62.5,
                                                                    bottom:
                                                                        62.5),
                                                                decoration: BoxDecoration(
                                                                    image: DecorationImage(
                                                                        image: NetworkImage(data
                                                                            .totalHomestays![
                                                                                index]
                                                                            .avatarUrl!),
                                                                        fit: BoxFit
                                                                            .fill),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10)),
                                                                child:
                                                                    TweenAnimationBuilder(
                                                                  tween: Tween<
                                                                          double>(
                                                                      begin: 0,
                                                                      end: 1),
                                                                  duration:
                                                                      const Duration(
                                                                          seconds:
                                                                              5),
                                                                  builder: (context,
                                                                          value,
                                                                          child) =>
                                                                      Opacity(
                                                                    opacity:
                                                                        value,
                                                                    child:
                                                                        child,
                                                                  ),
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Text(
                                                                        "${getCityProvinceName(utf8.decode(data.totalHomestays![index].cityProvince!.runes.toList()), false)}",
                                                                        style: const TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontWeight: FontWeight.bold,
                                                                            letterSpacing: 1.0),
                                                                      ),
                                                                      Text(
                                                                        "${data.totalHomestays![index].total} Homestays",
                                                                        style: const TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontWeight: FontWeight.bold,
                                                                            letterSpacing: 1.0),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          )),
                                            )
                                          : SizedBox(
                                              height: 250,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: TweenAnimationBuilder(
                                                tween: Tween<double>(
                                                    begin: 0, end: 1),
                                                duration:
                                                    const Duration(seconds: 4),
                                                builder:
                                                    (context, value, child) =>
                                                        Opacity(
                                                  opacity: value,
                                                  child: child,
                                                ),
                                                child: const Text(
                                                  "We don't have any homestay right now",
                                                  style: TextStyle(
                                                      fontFamily: "Lobster"),
                                                ),
                                              )),
                                    ],
                                  );
                                }
                              }
                              break;
                            default:
                              break;
                          }
                          return const SizedBox();
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white10),
                  height: 300,
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  child: Column(
                    children: [
                      TweenAnimationBuilder(
                          tween: Tween<double>(begin: 0, end: 1),
                          duration: const Duration(seconds: 4),
                          builder: (context, value, child) => Opacity(
                                opacity: value,
                                child: child,
                              ),
                          child: Container(
                            margin: const EdgeInsets.only(left: 10),
                            child: const Text(
                              "Where can you find block of homestay",
                              style: TextStyle(
                                  fontFamily: "Lobster",
                                  fontWeight: FontWeight.bold,
                                  color: Colors.lightBlueAccent,
                                  fontSize: 30),
                            ),
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                      FutureBuilder(
                        future: homestayService.getAreaHomestayInfo(),
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return SizedBox(
                                height: 150,
                                width: MediaQuery.of(context).size.width,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 5,
                                  itemBuilder: (context, index) =>
                                      TweenAnimationBuilder(
                                    tween: Tween<double>(
                                      begin: 0,
                                      end: 1,
                                    ),
                                    duration: const Duration(seconds: 1),
                                    builder: (context, value, child) => Opacity(
                                      opacity: value,
                                      child: child,
                                    ),
                                    child: TweenAnimationBuilder(
                                      tween: Tween<double>(begin: 1, end: 0),
                                      duration: const Duration(seconds: 3),
                                      builder: (context, value, child) =>
                                          Opacity(
                                        opacity: value,
                                        child: child,
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white10,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        height: 200,
                                        width: 200,
                                        margin: const EdgeInsets.only(left: 10),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            case ConnectionState.done:
                              if (snapshot.hasData) {
                                final data = snapshot.data;
                                if (data is TotalHomestayFromLocationModel) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      data.totalBlocs!.isNotEmpty
                                          ? SizedBox(
                                              height: 150,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: ListView.builder(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount: data.totalBlocs!
                                                              .length >
                                                          5
                                                      ? 5
                                                      : data.totalBlocs!.length,
                                                  itemBuilder:
                                                      (context, index) =>
                                                          TweenAnimationBuilder(
                                                            tween:
                                                                Tween<double>(
                                                                    begin: 0,
                                                                    end: 1),
                                                            duration:
                                                                const Duration(
                                                                    seconds: 4),
                                                            builder: (context,
                                                                    value,
                                                                    child) =>
                                                                Opacity(
                                                              opacity: value,
                                                              child: child,
                                                            ),
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                homestayBloc.eventController.sink.add(OnClickAreaEvent(
                                                                    context:
                                                                        context,
                                                                    homestayType:
                                                                        "bloc",
                                                                    position: widget
                                                                        .position,
                                                                    cityProvince: utf8.decode(data
                                                                        .totalBlocs![
                                                                            index]
                                                                        .cityProvince!
                                                                        .runes
                                                                        .toList())));
                                                              },
                                                              child: Container(
                                                                height: 200,
                                                                width: 200,
                                                                margin:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            10),
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top: 50,
                                                                        bottom:
                                                                            50),
                                                                decoration: BoxDecoration(
                                                                    image: DecorationImage(
                                                                        image: NetworkImage(data
                                                                            .totalBlocs![
                                                                                index]
                                                                            .avatarUrl!),
                                                                        fit: BoxFit
                                                                            .fill),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10)),
                                                                child:
                                                                    TweenAnimationBuilder(
                                                                  tween: Tween<
                                                                          double>(
                                                                      begin: 0,
                                                                      end: 1),
                                                                  duration:
                                                                      const Duration(
                                                                          seconds:
                                                                              5),
                                                                  builder: (context,
                                                                          value,
                                                                          child) =>
                                                                      Opacity(
                                                                    opacity:
                                                                        value,
                                                                    child:
                                                                        child,
                                                                  ),
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Text(
                                                                        "${getCityProvinceName(utf8.decode(data.totalBlocs![index].cityProvince!.runes.toList()), false)}",
                                                                        style: const TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontWeight: FontWeight.bold,
                                                                            letterSpacing: 1.0),
                                                                      ),
                                                                      Text(
                                                                        "${data.totalBlocs![index].total} bloc of homestay",
                                                                        style: const TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontWeight: FontWeight.bold,
                                                                            letterSpacing: 1.0),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          )),
                                            )
                                          : SizedBox(
                                              height: 150,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: TweenAnimationBuilder(
                                                tween: Tween<double>(
                                                    begin: 0, end: 1),
                                                duration:
                                                    const Duration(seconds: 4),
                                                builder:
                                                    (context, value, child) =>
                                                        Opacity(
                                                  opacity: value,
                                                  child: child,
                                                ),
                                                child: const Center(
                                                  child: Text(
                                                    "We don't have any block homestay right now",
                                                    style: TextStyle(
                                                        fontFamily: "Lobster"),
                                                  ),
                                                ),
                                              )),
                                    ],
                                  );
                                }
                              }
                              break;
                            default:
                              break;
                          }
                          return const SizedBox();
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white10),
                  height: 450,
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  child: Column(
                    children: [
                      TweenAnimationBuilder(
                          tween: Tween<double>(begin: 0, end: 1),
                          duration: const Duration(seconds: 4),
                          builder: (context, value, child) => Opacity(
                                opacity: value,
                                child: child,
                              ),
                          child: Container(
                            margin: const EdgeInsets.only(left: 10),
                            child: const Text(
                              "Recommand Homestays",
                              style: TextStyle(
                                  fontFamily: "Lobster",
                                  fontWeight: FontWeight.bold,
                                  color: Colors.lightBlueAccent,
                                  fontSize: 30),
                            ),
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                      FutureBuilder(
                        future: homestayService.getHomestayByFilter(
                          SearchFilterModel(homestayType: "Homestay"),
                          0,
                          5,
                          false,
                          false,
                          sortBy: "Rating",
                        ),
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return SizedBox(
                                height: 350,
                                width: MediaQuery.of(context).size.width,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 5,
                                  itemBuilder: (context, index) =>
                                      TweenAnimationBuilder(
                                    tween: Tween<double>(
                                      begin: 0,
                                      end: 1,
                                    ),
                                    duration: const Duration(seconds: 1),
                                    builder: (context, value, child) => Opacity(
                                      opacity: value,
                                      child: child,
                                    ),
                                    child: TweenAnimationBuilder(
                                      tween: Tween<double>(begin: 1, end: 0),
                                      duration: const Duration(seconds: 3),
                                      builder: (context, value, child) =>
                                          Opacity(
                                        opacity: value,
                                        child: child,
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white10,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        height: 200,
                                        width: 200,
                                        margin: const EdgeInsets.only(left: 10),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            case ConnectionState.done:
                              if (snapshot.hasData) {
                                final data = snapshot.data;
                                if (data is HomestayListPagingModel) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      data.homestays!.isNotEmpty
                                          ? SizedBox(
                                              height: 350,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: ListView.builder(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount:
                                                      data.homestays!.length > 5
                                                          ? 5
                                                          : data.homestays!
                                                              .length,
                                                  itemBuilder:
                                                      (context, index) =>
                                                          TweenAnimationBuilder(
                                                            tween:
                                                                Tween<double>(
                                                                    begin: 0,
                                                                    end: 1),
                                                            duration:
                                                                const Duration(
                                                                    seconds: 4),
                                                            builder: (context,
                                                                    value,
                                                                    child) =>
                                                                Opacity(
                                                              opacity: value,
                                                              child: child,
                                                            ),
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                homestayBloc
                                                                    .eventController
                                                                    .sink
                                                                    .add(ViewHomestayDetailEvent(
                                                                        context:
                                                                            context,
                                                                        homestayName: data
                                                                            .homestays![index]
                                                                            .name));
                                                              },
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
                                                                        .homestays![
                                                                            index]
                                                                        .homestayImages![
                                                                            0]
                                                                        .imageUrl!),
                                                                    builder:
                                                                        (context,
                                                                            imageSnapshot) {
                                                                      switch (imageSnapshot
                                                                          .connectionState) {
                                                                        case ConnectionState
                                                                            .waiting:
                                                                          return Container(
                                                                            height:
                                                                                150,
                                                                            width:
                                                                                300,
                                                                            margin:
                                                                                const EdgeInsets.only(left: 10),
                                                                            padding:
                                                                                const EdgeInsets.only(
                                                                              top: 50,
                                                                            ),
                                                                            decoration:
                                                                                const BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),
                                                                          );
                                                                        case ConnectionState
                                                                            .done:
                                                                          String
                                                                              imageUrl =
                                                                              imageSnapshot.data ?? "https://i.ytimg.com/vi/0jDUx3jOBfU/mqdefault.jpg";
                                                                          return Container(
                                                                            height:
                                                                                150,
                                                                            width:
                                                                                300,
                                                                            margin:
                                                                                const EdgeInsets.only(left: 10),
                                                                            padding:
                                                                                const EdgeInsets.only(
                                                                              top: 50,
                                                                            ),
                                                                            decoration:
                                                                                BoxDecoration(image: DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.fill), borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),
                                                                          );
                                                                        default:
                                                                          break;
                                                                      }
                                                                      return Container(
                                                                        height:
                                                                            150,
                                                                        width:
                                                                            300,
                                                                        margin: const EdgeInsets.only(
                                                                            left:
                                                                                10),
                                                                        padding:
                                                                            const EdgeInsets.only(
                                                                          top:
                                                                              50,
                                                                        ),
                                                                        decoration: const BoxDecoration(
                                                                            color:
                                                                                Colors.white24,
                                                                            borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),
                                                                      );
                                                                    },
                                                                  ),
                                                                  Container(
                                                                    height: 150,
                                                                    width: 300,
                                                                    margin: const EdgeInsets
                                                                            .only(
                                                                        left:
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
                                                                          crossAxisAlignment: CrossAxisAlignment
                                                                              .start,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          children: [
                                                                            const SizedBox(
                                                                              height: 10,
                                                                            ),
                                                                            Row(
                                                                              children: [
                                                                                Flexible(
                                                                                  child: Text(
                                                                                    utf8.decode(data.homestays![index].name!.runes.toList()),
                                                                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                                                                    overflow: TextOverflow.ellipsis,
                                                                                  ),
                                                                                ),
                                                                                // Text(
                                                                                //   "(${data.homestays![index].availableRooms} rooms)",
                                                                                //   style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                                                                // ),
                                                                              ],
                                                                            ),
                                                                            const SizedBox(
                                                                              height: 2,
                                                                            ),
                                                                            // RatingStars(
                                                                            //   animationDuration:
                                                                            //       const Duration(seconds: 4),
                                                                            //   maxValue:
                                                                            //       5.0,
                                                                            //   starColor:
                                                                            //       secondaryColor,
                                                                            //   starBuilder: (index, color) =>
                                                                            //       Icon(
                                                                            //     Icons.star,
                                                                            //     color: color,
                                                                            //     size: 15,
                                                                            //   ),
                                                                            //   value:
                                                                            //       data.homestays![index].totalAverageRating!,
                                                                            //   starOffColor:
                                                                            //       Colors.lightBlueAccent,
                                                                            //   starCount:
                                                                            //       5,
                                                                            //   valueLabelVisibility:
                                                                            //       false,
                                                                            // ),
                                                                            // const SizedBox(
                                                                            //   height:
                                                                            //       10,
                                                                            // ),
                                                                            // Text(
                                                                            //     "(${data.homestays![index].numberOfRating} number of reviews)"),
                                                                            Row(
                                                                              children: [
                                                                                Expanded(
                                                                                  flex: 2,
                                                                                  child: Row(
                                                                                    children: [
                                                                                      const Icon(
                                                                                        Icons.star,
                                                                                        color: Colors.amber,
                                                                                      ),
                                                                                      Text("${double.parse(data.homestays![index].totalAverageRating!.toStringAsFixed(2))}")
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                Expanded(
                                                                                  flex: 2,
                                                                                  child: Row(
                                                                                    children: [
                                                                                      const Icon(
                                                                                        Icons.assistant_photo,
                                                                                        color: Colors.amber,
                                                                                      ),
                                                                                      Text("${data.homestays![index].totalBookings}")
                                                                                    ],
                                                                                  ),
                                                                                )
                                                                              ],
                                                                            ),
                                                                            const SizedBox(
                                                                              height: 2,
                                                                            ),
                                                                            Row(
                                                                              children: [
                                                                                Expanded(
                                                                                  flex: 1,
                                                                                  child: Row(
                                                                                    children: [
                                                                                      const Icon(Icons.location_on, color: Colors.amber),
                                                                                      const SizedBox(
                                                                                        width: 5,
                                                                                      ),
                                                                                      Flexible(
                                                                                        child: Text(
                                                                                          utf8.decode(data.homestays![index].address!.split(",").first.runes.toList()),
                                                                                          overflow: TextOverflow.ellipsis,
                                                                                        ),
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                Expanded(
                                                                                  flex: 1,
                                                                                  child: Row(
                                                                                    children: [
                                                                                      const Icon(Icons.location_city, color: Colors.amber),
                                                                                      const SizedBox(
                                                                                        width: 5,
                                                                                      ),
                                                                                      Text(
                                                                                        getCityProvinceName(data.homestays![index].cityProvince!, false)!,
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            const SizedBox(
                                                                              height: 15,
                                                                            ),
                                                                            Text("VND: ${currencyFormat.format(data.homestays![index].price)} / day")
                                                                          ]),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          )),
                                            )
                                          : SizedBox(
                                              height: 150,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: TweenAnimationBuilder(
                                                tween: Tween<double>(
                                                    begin: 0, end: 1),
                                                duration:
                                                    const Duration(seconds: 4),
                                                builder:
                                                    (context, value, child) =>
                                                        Opacity(
                                                  opacity: value,
                                                  child: child,
                                                ),
                                                child: const Center(
                                                  child: Text(
                                                    "We don't have any bloc homestay right now",
                                                    style: TextStyle(
                                                        fontFamily: "Lobster"),
                                                  ),
                                                ),
                                              )),
                                    ],
                                  );
                                }
                              }
                              break;
                            default:
                              break;
                          }
                          return const SizedBox();
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white10),
                  height: 450,
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  child: Column(
                    children: [
                      TweenAnimationBuilder(
                          tween: Tween<double>(begin: 0, end: 1),
                          duration: const Duration(seconds: 4),
                          builder: (context, value, child) => Opacity(
                                opacity: value,
                                child: child,
                              ),
                          child: Container(
                            margin: const EdgeInsets.only(left: 10),
                            child: const Text(
                              "Recommand Blocks",
                              style: TextStyle(
                                  fontFamily: "Lobster",
                                  fontWeight: FontWeight.bold,
                                  color: Colors.lightBlueAccent,
                                  fontSize: 30),
                            ),
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                      FutureBuilder(
                        future: homestayService.getHomestayByFilter(
                          SearchFilterModel(homestayType: "BLOC"),
                          0,
                          5,
                          false,
                          false,
                          sortBy: "Rating",
                        ),
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return SizedBox(
                                height: 350,
                                width: MediaQuery.of(context).size.width,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 5,
                                  itemBuilder: (context, index) =>
                                      TweenAnimationBuilder(
                                    tween: Tween<double>(
                                      begin: 0,
                                      end: 1,
                                    ),
                                    duration: const Duration(seconds: 1),
                                    builder: (context, value, child) => Opacity(
                                      opacity: value,
                                      child: child,
                                    ),
                                    child: TweenAnimationBuilder(
                                      tween: Tween<double>(begin: 1, end: 0),
                                      duration: const Duration(seconds: 3),
                                      builder: (context, value, child) =>
                                          Opacity(
                                        opacity: value,
                                        child: child,
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white10,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        height: 200,
                                        width: 200,
                                        margin: const EdgeInsets.only(left: 10),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            case ConnectionState.done:
                              if (snapshot.hasData) {
                                final data = snapshot.data;
                                if (data is HomestayListPagingModel) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      data.blocs!.isNotEmpty
                                          ? SizedBox(
                                              height: 350,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: ListView.builder(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount:
                                                      data.blocs!.length > 5
                                                          ? 5
                                                          : data.blocs!.length,
                                                  itemBuilder:
                                                      (context, index) =>
                                                          TweenAnimationBuilder(
                                                            tween:
                                                                Tween<double>(
                                                                    begin: 0,
                                                                    end: 1),
                                                            duration:
                                                                const Duration(
                                                                    seconds: 4),
                                                            builder: (context,
                                                                    value,
                                                                    child) =>
                                                                Opacity(
                                                              opacity: value,
                                                              child: child,
                                                            ),
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                homestayBloc
                                                                    .eventController
                                                                    .sink
                                                                    .add(ViewBlocHomestayDetailEvent(
                                                                        context:
                                                                            context,
                                                                        blocName: data
                                                                            .blocs![index]
                                                                            .name));
                                                              },
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
                                                                    builder:
                                                                        (context,
                                                                            imageSnapshot) {
                                                                      switch (imageSnapshot
                                                                          .connectionState) {
                                                                        case ConnectionState
                                                                            .waiting:
                                                                          return Container(
                                                                            height:
                                                                                150,
                                                                            width:
                                                                                300,
                                                                            margin:
                                                                                const EdgeInsets.only(left: 10),
                                                                            padding:
                                                                                const EdgeInsets.only(
                                                                              top: 50,
                                                                            ),
                                                                            decoration:
                                                                                const BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),
                                                                          );
                                                                        case ConnectionState
                                                                            .done:
                                                                          String
                                                                              imageUrl =
                                                                              imageSnapshot.data ?? 'https://i.ytimg.com/vi/0jDUx3jOBfU/mqdefault.jpg';
                                                                          return Container(
                                                                            height:
                                                                                150,
                                                                            width:
                                                                                300,
                                                                            margin:
                                                                                const EdgeInsets.only(left: 10),
                                                                            padding:
                                                                                const EdgeInsets.only(
                                                                              top: 50,
                                                                            ),
                                                                            decoration:
                                                                                BoxDecoration(image: DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.fill), borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),
                                                                          );
                                                                        default:
                                                                          break;
                                                                      }
                                                                      return Container(
                                                                        height:
                                                                            150,
                                                                        width:
                                                                            300,
                                                                        margin: const EdgeInsets.only(
                                                                            left:
                                                                                10),
                                                                        padding:
                                                                            const EdgeInsets.only(
                                                                          top:
                                                                              50,
                                                                        ),
                                                                        decoration: const BoxDecoration(
                                                                            color:
                                                                                Colors.white24,
                                                                            borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),
                                                                      );
                                                                    },
                                                                  ),
                                                                  Container(
                                                                    height: 150,
                                                                    width: 300,
                                                                    margin: const EdgeInsets
                                                                            .only(
                                                                        left:
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
                                                                          crossAxisAlignment: CrossAxisAlignment
                                                                              .start,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          children: [
                                                                            const SizedBox(
                                                                              height: 10,
                                                                            ),
                                                                            Row(
                                                                              children: [
                                                                                Text(
                                                                                  utf8.decode(data.blocs![index].name!.runes.toList()),
                                                                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            const SizedBox(
                                                                              height: 2,
                                                                            ),
                                                                            Row(
                                                                              children: [
                                                                                Expanded(
                                                                                  flex: 1,
                                                                                  child: Row(
                                                                                    children: [
                                                                                      const Icon(Icons.star, color: Colors.yellow),
                                                                                      const SizedBox(
                                                                                        width: 5,
                                                                                      ),
                                                                                      Text("${double.parse(data.blocs![index].totalAverageRating!.toStringAsFixed(2))} (${data.blocs![index].numberOfRating})")
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                Expanded(
                                                                                    flex: 1,
                                                                                    child: Row(
                                                                                      children: [
                                                                                        const Icon(Icons.assistant_photo, color: Colors.amber),
                                                                                        const SizedBox(
                                                                                          width: 5,
                                                                                        ),
                                                                                        Text("${data.blocs![index].totalBookings}")
                                                                                      ],
                                                                                    ))
                                                                              ],
                                                                            ),
                                                                            const SizedBox(
                                                                              height: 2,
                                                                            ),
                                                                            Row(
                                                                              children: [
                                                                                Expanded(
                                                                                  flex: 1,
                                                                                  child: Row(
                                                                                    children: [
                                                                                      const Icon(Icons.location_on, color: Colors.amber),
                                                                                      const SizedBox(
                                                                                        width: 5,
                                                                                      ),
                                                                                      Flexible(
                                                                                        child: Text(
                                                                                          utf8.decode(data.blocs![index].address!.split(",").first.runes.toList()),
                                                                                          overflow: TextOverflow.ellipsis,
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                Expanded(
                                                                                  flex: 1,
                                                                                  child: Row(
                                                                                    children: [
                                                                                      const Icon(
                                                                                        Icons.location_city,
                                                                                        color: Colors.amber,
                                                                                      ),
                                                                                      const SizedBox(
                                                                                        width: 5,
                                                                                      ),
                                                                                      Text(getCityProvinceName(data.blocs![index].cityProvince!, false)!)
                                                                                    ],
                                                                                  ),
                                                                                )
                                                                              ],
                                                                            ),
                                                                            const SizedBox(
                                                                              height: 15,
                                                                            ),
                                                                            Text("VND: ${currencyFormat.format(data.blocs![index].homestays![0].price)} ~ ${currencyFormat.format(data.blocs![index].homestays![data.blocs![index].homestays!.length - 1].price)} / day")
                                                                          ]),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          )),
                                            )
                                          : SizedBox(
                                              height: 150,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: TweenAnimationBuilder(
                                                tween: Tween<double>(
                                                    begin: 0, end: 1),
                                                duration:
                                                    const Duration(seconds: 4),
                                                builder:
                                                    (context, value, child) =>
                                                        Opacity(
                                                  opacity: value,
                                                  child: child,
                                                ),
                                                child: const Center(
                                                  child: Text(
                                                    "We don't have any bloc homestay right now",
                                                    style: TextStyle(
                                                        fontFamily: "Lobster"),
                                                  ),
                                                ),
                                              )),
                                    ],
                                  );
                                }
                              }
                              break;
                            default:
                              break;
                          }
                          return const SizedBox();
                        },
                      ),
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }
}
