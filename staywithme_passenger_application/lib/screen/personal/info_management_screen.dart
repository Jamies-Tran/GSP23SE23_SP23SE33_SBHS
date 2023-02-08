import 'package:flutter/material.dart';
import 'package:flutter_advanced_avatar/flutter_advanced_avatar.dart';

class PassengerInfoManagementScreen extends StatelessWidget {
  const PassengerInfoManagementScreen({super.key});
  static const passengerInfoManagementScreenRoute = "/info-management";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
            child: Column(
          children: [
            Row(
              children: const [
                AdvancedAvatar(
                  image: AssetImage("images/login_background.jpg"),
                )
              ],
            )
          ],
        )),
      ),
    );
  }
}
