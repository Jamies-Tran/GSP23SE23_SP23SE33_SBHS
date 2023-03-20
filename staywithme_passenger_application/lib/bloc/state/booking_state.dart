import 'package:staywithme_passenger_application/model/homestay_model.dart';

class BookingState {
  BookingState(
      {this.homestayName,
      this.selectedIndex,
      this.bookingStart,
      this.bookingEnd,
      this.homestayServiceList,
      this.totalServicePrice});

  String? homestayName;
  int? selectedIndex;
  String? bookingStart;
  String? bookingEnd;
  List<HomestayServiceModel>? homestayServiceList;
  int? totalServicePrice;
}
