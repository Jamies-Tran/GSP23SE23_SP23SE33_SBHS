import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:staywithme_passenger_application/bloc/event/main_screen_event.dart';
import 'package:staywithme_passenger_application/bloc/main_screen_bloc.dart';
import 'package:staywithme_passenger_application/bloc/state/main_screen_state.dart';
import 'package:staywithme_passenger_application/global_variable.dart';
import 'package:staywithme_passenger_application/screen/authenticate/authenticate_wrapper.dart';
import 'package:staywithme_passenger_application/screen/homestay/homestay_screen.dart';
import 'package:staywithme_passenger_application/service/location/location_service.dart';
import 'package:staywithme_passenger_application/service_locator/service_locator.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, this.position});
  final Position? position;

  static const String mainScreenRoute = "/main-screen";
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final mainscreenBloc = MainScreenBloc();
  final locationService = locator.get<ILocationService>();

  List<Widget> widgets(Position? position) =>
      [HomestayScreen(position: position), const AuthenticateWrapperScreen()];

  @override
  void dispose() {
    mainscreenBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final contextArguments = ModalRoute.of(context)!.settings.arguments as Map?;
    int? startingIndex =
        contextArguments != null ? contextArguments["startingIndex"] : null;
    return StreamBuilder<MainScreenState>(
        initialData: mainscreenBloc.initialData(startingIndex),
        stream: mainscreenBloc.stateController.stream,
        builder: (context, snapshot) => Scaffold(
              body: widgets(widget.position).elementAt(snapshot.data!.index!),
              bottomNavigationBar: BottomNavigationBar(
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.home,
                        color: Colors.black,
                      ),
                      label: "Homestay"),
                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.person,
                        color: Colors.black,
                      ),
                      label: "Personal")
                ],
                currentIndex: snapshot.data!.index!,
                backgroundColor: primaryColor,
                selectedItemColor: Colors.black,
                selectedLabelStyle: const TextStyle(
                    fontFamily: "Lobster", fontWeight: FontWeight.bold),
                showUnselectedLabels: false,
                onTap: (value) => mainscreenBloc.eventController.sink
                    .add(TapNavigationBarEvent(index: value)),
              ),
            ));
  }
}
