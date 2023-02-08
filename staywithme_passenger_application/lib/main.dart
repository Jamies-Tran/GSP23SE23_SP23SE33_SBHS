import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:staywithme_passenger_application/screen/authenticate/authenticate_wrapper.dart';
import 'package:staywithme_passenger_application/screen/authenticate/change_password_screen.dart';
import 'package:staywithme_passenger_application/screen/authenticate/complete_google_reg_screen.dart';
import 'package:staywithme_passenger_application/screen/authenticate/forget_password_screen.dart';
import 'package:staywithme_passenger_application/screen/authenticate/google_chosen_screen.dart';
import 'package:staywithme_passenger_application/screen/authenticate/google_validation_screen.dart';
import 'package:staywithme_passenger_application/screen/authenticate/log_in_screen.dart';
import 'package:staywithme_passenger_application/screen/authenticate/register_screen.dart';
import 'package:staywithme_passenger_application/screen/personal/info_management_screen.dart';
import 'package:staywithme_passenger_application/service_locator/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setup();
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stay with me',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      initialRoute: AuthenticateWrapperScreen.authenticateWrapperScreenRoute,
      routes: {
        LoginScreen.loginScreenRoute: (context) => const LoginScreen(),
        RegisterScreen.registerAccountRoute: (context) =>
            const RegisterScreen(),
        ChooseGoogleAccountScreen.chooseGoogleAccountScreenRoute: (context) =>
            const ChooseGoogleAccountScreen(),
        CompleteGoogleRegisterScreen.completeGoogleRegisterScreenRoute:
            (context) => const CompleteGoogleRegisterScreen(),
        GoogleAccountValidationScreen.checkValidGoogleAccountRoute: (context) =>
            const GoogleAccountValidationScreen(),
        ForgetPasswordScreen.forgetPasswordRoute: (context) =>
            const ForgetPasswordScreen(),
        SendMailScreen.sendMailScreenRoute: (context) => const SendMailScreen(),
        ValidatePasswordModificationOtpScreen
                .validatePasswordModificationScreenRoute:
            (context) => const ValidatePasswordModificationOtpScreen(),
        ChangePasswordScreen.changePasswordScreenRoute: (context) =>
            const ChangePasswordScreen(),
        AuthenticateWrapperScreen.authenticateWrapperScreenRoute: (context) =>
            const AuthenticateWrapperScreen(),
        PassengerInfoManagementScreen.passengerInfoManagementScreenRoute:
            (context) => const PassengerInfoManagementScreen()
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return const RegisterScreen();
  }
}
