import 'package:flutter/material.dart';
import 'package:staywithme_passenger_application/global_variable.dart';
import 'package:staywithme_passenger_application/model/homestay_city_province_model.dart';
import 'package:staywithme_passenger_application/service/user/user_service.dart';
import 'package:staywithme_passenger_application/service_locator/service_locator.dart';

class HomestayScreen extends StatefulWidget {
  const HomestayScreen({super.key});

  @override
  State<HomestayScreen> createState() => _HomestayScreenState();
}

class _HomestayScreenState extends State<HomestayScreen> {
  final userService = locator.get<IUserService>();

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
                              itemBuilder: (context, index) => Container(
                                decoration: BoxDecoration(
                                    color: Colors.white10,
                                    borderRadius: BorderRadius.circular(10)),
                                height: 150,
                                width: 150,
                                margin: const EdgeInsets.only(left: 10),
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
                                  SizedBox(
                                    height: 250,
                                    width: MediaQuery.of(context).size.width,
                                    child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount:
                                            data.totalHomestays!.length > 5
                                                ? 5
                                                : data.totalHomestays!.length,
                                        itemBuilder: (context, index) =>
                                            TweenAnimationBuilder(
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
                                              child: Container(
                                                height: 150,
                                                width: 150,
                                                margin: const EdgeInsets.only(
                                                    left: 10),
                                                padding: const EdgeInsets.only(
                                                    top: 62.5, bottom: 62.5),
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        image: NetworkImage(data
                                                            .totalHomestays![
                                                                index]
                                                            .avatarUrl!),
                                                        fit: BoxFit.fill),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: TweenAnimationBuilder(
                                                  tween: Tween<double>(
                                                      begin: 0, end: 1),
                                                  duration: const Duration(
                                                      seconds: 5),
                                                  builder:
                                                      (context, value, child) =>
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
                                                        "${userService.getFullCityProvinceName(data.totalHomestays![index].cityProvince!)}",
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            letterSpacing: 1.0),
                                                      ),
                                                      Text(
                                                        "${data.totalHomestays![index].total} Homestays",
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            letterSpacing: 1.0),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )),
                                  ),
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
                              itemBuilder: (context, index) => Container(
                                decoration: BoxDecoration(
                                    color: Colors.white10,
                                    borderRadius: BorderRadius.circular(10)),
                                height: 200,
                                width: 200,
                                margin: const EdgeInsets.only(left: 10),
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
                                  SizedBox(
                                    height: 150,
                                    width: MediaQuery.of(context).size.width,
                                    child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount:
                                            data.totalHomestays!.length > 5
                                                ? 5
                                                : data.totalHomestays!.length,
                                        itemBuilder: (context, index) =>
                                            TweenAnimationBuilder(
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
                                              child: Container(
                                                height: 200,
                                                width: 200,
                                                margin: const EdgeInsets.only(
                                                    left: 10),
                                                padding: const EdgeInsets.only(
                                                    top: 50, bottom: 50),
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        image: NetworkImage(data
                                                            .totalHomestays![
                                                                index]
                                                            .avatarUrl!),
                                                        fit: BoxFit.fill),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: TweenAnimationBuilder(
                                                  tween: Tween<double>(
                                                      begin: 0, end: 1),
                                                  duration: const Duration(
                                                      seconds: 5),
                                                  builder:
                                                      (context, value, child) =>
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
                                                        "${userService.getFullCityProvinceName(data.totalHomestays![index].cityProvince!)}",
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            letterSpacing: 1.0),
                                                      ),
                                                      Text(
                                                        "${data.totalHomestays![index].total} Homestays",
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            letterSpacing: 1.0),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )),
                                  ),
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
              ],
            )),
      ),
    );
  }
}
