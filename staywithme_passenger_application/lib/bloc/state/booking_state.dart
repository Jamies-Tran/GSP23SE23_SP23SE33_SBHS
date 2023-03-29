import 'package:staywithme_passenger_application/model/homestay_model.dart';

class BookingState {
  BookingState(
      {this.homestay,
      this.bookingId,
      this.selectedIndex,
      this.bookingStart,
      this.bookingEnd,
      this.homestayServiceList,
      this.totalServicePrice});

  HomestayModel? homestay;
  int? bookingId;
  int? selectedIndex;
  String? bookingStart;
  String? bookingEnd;
  List<HomestayServiceModel>? homestayServiceList;
  int? totalServicePrice;
}
