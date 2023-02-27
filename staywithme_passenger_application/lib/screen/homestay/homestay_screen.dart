import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:staywithme_passenger_application/global_variable.dart';
import 'package:staywithme_passenger_application/model/bloc_model.dart';
import 'package:staywithme_passenger_application/model/homestay_city_province_model.dart';
import 'package:staywithme_passenger_application/model/homestay_model.dart';
import 'package:staywithme_passenger_application/service/user/homestay_service.dart';
import 'package:staywithme_passenger_application/service/user/user_service.dart';
import 'package:staywithme_passenger_application/service_locator/service_locator.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';

class HomestayScreen extends StatefulWidget {
  const HomestayScreen({super.key});

  @override
  State<HomestayScreen> createState() => _HomestayScreenState();
}

class _HomestayScreenState extends State<HomestayScreen> {
  final userService = locator.get<IUserService>();
  final homestayService = locator.get<IHomestayService>();
  // final formKey = GlobalKey<FormState>();
  // final searchOptionTextEditingController = TextEditingController();

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
                  height: 350,
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  child: FutureBuilder(
                    future: userService.getAreaHomestayInfo(),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TweenAnimationBuilder(
                                      tween: Tween<double>(begin: 0, end: 1),
                                      duration: const Duration(seconds: 4),
                                      builder: (context, value, child) =>
                                          Opacity(
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
                                  data.totalHomestays!.isNotEmpty
                                      ? SizedBox(
                                          height: 250,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: data.totalHomestays!
                                                          .length >
                                                      5
                                                  ? 5
                                                  : data.totalHomestays!.length,
                                              itemBuilder: (context, index) =>
                                                  TweenAnimationBuilder(
                                                    tween: Tween<double>(
                                                        begin: 0, end: 1),
                                                    duration: const Duration(
                                                        seconds: 4),
                                                    builder: (context, value,
                                                            child) =>
                                                        Opacity(
                                                      opacity: value,
                                                      child: child,
                                                    ),
                                                    child: Container(
                                                      height: 150,
                                                      width: 150,
                                                      margin:
                                                          const EdgeInsets.only(
                                                              left: 10),
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 62.5,
                                                              bottom: 62.5),
                                                      decoration: BoxDecoration(
                                                          image: DecorationImage(
                                                              image: NetworkImage(data
                                                                  .totalHomestays![
                                                                      index]
                                                                  .avatarUrl!),
                                                              fit: BoxFit.fill),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10)),
                                                      child:
                                                          TweenAnimationBuilder(
                                                        tween: Tween<double>(
                                                            begin: 0, end: 1),
                                                        duration:
                                                            const Duration(
                                                                seconds: 5),
                                                        builder: (context,
                                                                value, child) =>
                                                            Opacity(
                                                          opacity: value,
                                                          child: child,
                                                        ),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              "${getCityProvinceName(utf8.decode(data.totalHomestays![index].cityProvince!.runes.toList()), false)}",
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  letterSpacing:
                                                                      1.0),
                                                            ),
                                                            Text(
                                                              "${data.totalHomestays![index].total} Homestays",
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  letterSpacing:
                                                                      1.0),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  )),
                                        )
                                      : SizedBox(
                                          height: 250,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: TweenAnimationBuilder(
                                            tween:
                                                Tween<double>(begin: 0, end: 1),
                                            duration:
                                                const Duration(seconds: 4),
                                            builder: (context, value, child) =>
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
                  child: FutureBuilder(
                    future: userService.getAreaHomestayInfo(),
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
                                  builder: (context, value, child) => Opacity(
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TweenAnimationBuilder(
                                      tween: Tween<double>(begin: 0, end: 1),
                                      duration: const Duration(seconds: 4),
                                      builder: (context, value, child) =>
                                          Opacity(
                                            opacity: value,
                                            child: child,
                                          ),
                                      child: Container(
                                        margin: const EdgeInsets.only(left: 10),
                                        child: const Text(
                                          "Where can you find bloc of homestay",
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
                                  data.totalBlocs!.isNotEmpty
                                      ? SizedBox(
                                          height: 150,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount:
                                                  data.totalBlocs!.length > 5
                                                      ? 5
                                                      : data.totalBlocs!.length,
                                              itemBuilder: (context, index) =>
                                                  TweenAnimationBuilder(
                                                    tween: Tween<double>(
                                                        begin: 0, end: 1),
                                                    duration: const Duration(
                                                        seconds: 4),
                                                    builder: (context, value,
                                                            child) =>
                                                        Opacity(
                                                      opacity: value,
                                                      child: child,
                                                    ),
                                                    child: Container(
                                                      height: 200,
                                                      width: 200,
                                                      margin:
                                                          const EdgeInsets.only(
                                                              left: 10),
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 50,
                                                              bottom: 50),
                                                      decoration: BoxDecoration(
                                                          image: DecorationImage(
                                                              image: NetworkImage(data
                                                                  .totalBlocs![
                                                                      index]
                                                                  .avatarUrl!),
                                                              fit: BoxFit.fill),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10)),
                                                      child:
                                                          TweenAnimationBuilder(
                                                        tween: Tween<double>(
                                                            begin: 0, end: 1),
                                                        duration:
                                                            const Duration(
                                                                seconds: 5),
                                                        builder: (context,
                                                                value, child) =>
                                                            Opacity(
                                                          opacity: value,
                                                          child: child,
                                                        ),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              "${getCityProvinceName(utf8.decode(data.totalBlocs![index].cityProvince!.runes.toList()), false)}",
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  letterSpacing:
                                                                      1.0),
                                                            ),
                                                            Text(
                                                              "${data.totalBlocs![index].total} bloc of homestay",
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  letterSpacing:
                                                                      1.0),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  )),
                                        )
                                      : SizedBox(
                                          height: 150,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: TweenAnimationBuilder(
                                            tween:
                                                Tween<double>(begin: 0, end: 1),
                                            duration:
                                                const Duration(seconds: 4),
                                            builder: (context, value, child) =>
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
                  child: FutureBuilder(
                    future: homestayService
                        .getHomestayListOrderByTotalAverageRating(
                            0, 5, true, true),
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
                                  builder: (context, value, child) => Opacity(
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TweenAnimationBuilder(
                                      tween: Tween<double>(begin: 0, end: 1),
                                      duration: const Duration(seconds: 4),
                                      builder: (context, value, child) =>
                                          Opacity(
                                            opacity: value,
                                            child: child,
                                          ),
                                      child: Container(
                                        margin: const EdgeInsets.only(left: 10),
                                        child: const Text(
                                          "Recommand homestay for holiday",
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
                                  data.homestays!.isNotEmpty
                                      ? SizedBox(
                                          height: 350,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount:
                                                  data.homestays!.length > 5
                                                      ? 5
                                                      : data.homestays!.length,
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
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Container(
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
                                                              decoration: BoxDecoration(
                                                                  image: DecorationImage(
                                                                      image: NetworkImage(data
                                                                          .homestays![
                                                                              index]
                                                                          .homestayImages![
                                                                              0]
                                                                          .imageUrl!),
                                                                      fit: BoxFit
                                                                          .fill),
                                                                  borderRadius: const BorderRadius
                                                                          .only(
                                                                      topLeft: Radius
                                                                          .circular(
                                                                              10),
                                                                      topRight:
                                                                          Radius.circular(
                                                                              10))),
                                                            ),
                                                            Container(
                                                              height: 150,
                                                              width: 200,
                                                              margin:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 10),
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
                                                              child: Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            10),
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
                                                                      Row(
                                                                        children: [
                                                                          Text(
                                                                            data.homestays![index].name!,
                                                                            style:
                                                                                const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                                                          ),
                                                                          Text(
                                                                            "(${data.homestays![index].availableRooms} rooms)",
                                                                            style:
                                                                                const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            2,
                                                                      ),
                                                                      RatingStars(
                                                                        animationDuration:
                                                                            const Duration(seconds: 4),
                                                                        maxValue:
                                                                            5.0,
                                                                        starColor:
                                                                            secondaryColor,
                                                                        starBuilder:
                                                                            (index, color) =>
                                                                                Icon(
                                                                          Icons
                                                                              .star,
                                                                          color:
                                                                              color,
                                                                          size:
                                                                              15,
                                                                        ),
                                                                        value: data
                                                                            .homestays![index]
                                                                            .totalAverageRating!,
                                                                        starOffColor:
                                                                            Colors.lightBlueAccent,
                                                                        starCount:
                                                                            5,
                                                                        valueLabelVisibility:
                                                                            false,
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            10,
                                                                      ),
                                                                      Text(
                                                                          "(${data.homestays![index].numberOfRating} number of reviews)"),
                                                                      const SizedBox(
                                                                        height:
                                                                            15,
                                                                      ),
                                                                      Text(
                                                                          "VND: ${currencyFormat.format(data.homestays![index].price)} / day")
                                                                    ]),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      )),
                                        )
                                      : SizedBox(
                                          height: 150,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: TweenAnimationBuilder(
                                            tween:
                                                Tween<double>(begin: 0, end: 1),
                                            duration:
                                                const Duration(seconds: 4),
                                            builder: (context, value, child) =>
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
                  child: FutureBuilder(
                    future: homestayService
                        .getBlocListOrderByTotalAverageRating(0, 5, true, true),
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
                                  builder: (context, value, child) => Opacity(
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
                            if (data is BlocHomestayListPagingModel) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TweenAnimationBuilder(
                                      tween: Tween<double>(begin: 0, end: 1),
                                      duration: const Duration(seconds: 4),
                                      builder: (context, value, child) =>
                                          Opacity(
                                            opacity: value,
                                            child: child,
                                          ),
                                      child: Container(
                                        margin: const EdgeInsets.only(left: 10),
                                        child: const Text(
                                          "Best place for big party, greate choice for family picnic",
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
                                  data.blocs!.isNotEmpty
                                      ? SizedBox(
                                          height: 350,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: data.blocs!.length > 5
                                                  ? 5
                                                  : data.blocs!.length,
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
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Container(
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
                                                              decoration: BoxDecoration(
                                                                  image: DecorationImage(
                                                                      image: NetworkImage(data
                                                                          .blocs![
                                                                              index]
                                                                          .homestays![
                                                                              0]
                                                                          .homestayImages![
                                                                              0]
                                                                          .imageUrl!),
                                                                      fit: BoxFit
                                                                          .fill),
                                                                  borderRadius: const BorderRadius
                                                                          .only(
                                                                      topLeft: Radius
                                                                          .circular(
                                                                              10),
                                                                      topRight:
                                                                          Radius.circular(
                                                                              10))),
                                                            ),
                                                            Container(
                                                              height: 150,
                                                              width: 200,
                                                              margin:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 10),
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
                                                              child: Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            10),
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
                                                                      Row(
                                                                        children: [
                                                                          Text(
                                                                            data.blocs![index].name!,
                                                                            style:
                                                                                const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                                                          ),
                                                                          Text(
                                                                            "(${data.blocs![index].homestays!.length} homestays)",
                                                                            style:
                                                                                const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            2,
                                                                      ),
                                                                      RatingStars(
                                                                        animationDuration:
                                                                            const Duration(seconds: 4),
                                                                        maxValue:
                                                                            5.0,
                                                                        starColor:
                                                                            secondaryColor,
                                                                        starBuilder:
                                                                            (index, color) =>
                                                                                Icon(
                                                                          Icons
                                                                              .star,
                                                                          color:
                                                                              color,
                                                                          size:
                                                                              15,
                                                                        ),
                                                                        value: data
                                                                            .blocs![index]
                                                                            .totalAverageRating!,
                                                                        starOffColor:
                                                                            Colors.lightBlueAccent,
                                                                        starCount:
                                                                            5,
                                                                        valueLabelVisibility:
                                                                            false,
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            10,
                                                                      ),
                                                                      Text(
                                                                          "(${data.blocs![index].numberOfRating} number of reviews)"),
                                                                      const SizedBox(
                                                                        height:
                                                                            15,
                                                                      ),
                                                                      Text(
                                                                          "VND: ${currencyFormat.format(data.blocs![index].homestays![0].price)} ~ ${currencyFormat.format(data.blocs![index].homestays![data.blocs![index].homestays!.length - 1].price)} / day")
                                                                    ]),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      )),
                                        )
                                      : SizedBox(
                                          height: 150,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: TweenAnimationBuilder(
                                            tween:
                                                Tween<double>(begin: 0, end: 1),
                                            duration:
                                                const Duration(seconds: 4),
                                            builder: (context, value, child) =>
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
                )
              ],
            )),
      ),
    );
  }
}
