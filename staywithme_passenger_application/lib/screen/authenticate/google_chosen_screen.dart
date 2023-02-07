import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:staywithme_passenger_application/screen/authenticate/register_screen.dart';

import '../../bloc/complete_google_reg_bloc.dart';
import '../../bloc/event/log_in_event.dart';
import '../../bloc/event/reg_event.dart';
import '../../bloc/event/reg_google_event.dart';
import '../../bloc/log_in_bloc.dart';
import '../../bloc/reg_bloc.dart';

class ChooseGoogleAccountScreen extends StatefulWidget {
  const ChooseGoogleAccountScreen({super.key});

  static const chooseGoogleAccountScreenRoute = "/choose-google-account";

  @override
  State<ChooseGoogleAccountScreen> createState() =>
      _ChooseGoogleAccountScreenState();
}

class _ChooseGoogleAccountScreenState extends State<ChooseGoogleAccountScreen> {
  final registerBloc = RegisterBloc();
  final completeGoogleAuthBloc = CompleteGoogleRegBloc();
  final loginBloc = LoginBloc();

  @override
  void dispose() {
    registerBloc.dispose();
    completeGoogleAuthBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final googleSignIn = GoogleSignIn();
    final contextArguments = ModalRoute.of(context)!.settings.arguments as Map;
    // isGoogleRegister true when register , false when login
    final isGoogleRegister = contextArguments["isGoogleRegister"];

    return Scaffold(
        backgroundColor: Colors.blueAccent,
        body: FutureBuilder(
          future: googleSignIn.signIn(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error);
              if (snapshot.error.toString().contains("PlatformException")) {
                completeGoogleAuthBloc.eventController.sink
                    .add(BackwardToRegisterScreenEvent(context: context));
              }
            } else {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      SpinKitCircle(
                        color: Colors.white,
                      ),
                      Text(
                        "Wait a sec...",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            fontFamily: "SourceCodePro"),
                      ),
                    ],
                  );
                case ConnectionState.done:
                  if (snapshot.hasData) {
                    if (isGoogleRegister == true) {
                      registerBloc.eventController.sink.add(
                          ValidateGoogleAccountEvent(
                              context: context, googleSignIn: googleSignIn));
                    } else {
                      loginBloc.eventController.sink.add(
                          ValidateGoogleAccountLoginEvent(
                              context: context, googleSignIn: googleSignIn));
                    }
                  } else {
                    print("snapshot has data: ${snapshot.hasData}");
                    completeGoogleAuthBloc.eventController.sink.add(
                        BackwardToRegisterScreenEvent(
                            context: context, message: ""));
                  }
                  break;
                default:
                  return Container();
              }
            }

            return Container();
          },
        ));
  }
}
