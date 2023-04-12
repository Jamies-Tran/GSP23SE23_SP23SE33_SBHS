import 'package:staywithme_passenger_application/model/booking_model.dart';

class BookingHistoryState {
  BookingHistoryState({this.homestayType, this.status, this.isHost});

  String? homestayType;
  String? status;
  bool? isHost;

  List<String> homestayTypeList = ["Homestay", "Block"];

  List<String> statusList = ["All", "Pending", "Accepted", "Rejected"];

  FilterBookingModel filterBookingModel() {
    if (status == "All") {
      status = null;
    }
    if (homestayType == "Block") {
      homestayType = "bloc";
    }
    return FilterBookingModel(
        homestayType: homestayType, isHost: isHost, status: status);
  }

  int totalUnpaidDeposit(List<BookingDepositModel> bookingDepositList) {
    int total = 0;
    for (BookingDepositModel b in bookingDepositList) {
      total = total + b.unpaidAmount!;
    }

    return total;
  }
}
