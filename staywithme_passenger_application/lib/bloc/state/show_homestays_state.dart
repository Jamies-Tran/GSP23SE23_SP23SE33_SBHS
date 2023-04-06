import 'package:staywithme_passenger_application/model/bloc_model.dart';
import 'package:staywithme_passenger_application/model/booking_model.dart';
import 'package:staywithme_passenger_application/model/homestay_model.dart';

class ShowHomestaysState {
  ShowHomestaysState(
      {this.bloc,
      this.blocBookingValidation,
      this.booking,
      this.paymentMethod,
      this.selectedBlocHomestayList});

  BlocHomestayModel? bloc;
  BlocBookingDateValidationModel? blocBookingValidation;
  BookingModel? booking;
  String? paymentMethod;
  List<HomestayInBlocModel>? selectedBlocHomestayList;

  bool isBlocHomestayFree(HomestayInBlocModel homestay) {
    for (HomestayModel h in blocBookingValidation!.homestays!) {
      if (h.id == homestay.id) {
        return true;
      }
    }
    return false;
  }

  bool isBlocHomestayBookedByUser(HomestayInBlocModel homestay) {
    for (BookingHomestayModel b in booking!.bookingHomestays!) {
      if (b.homestay!.id == homestay.id) {
        return true;
      }
    }
    return false;
  }

  bool isHomestaySelected(HomestayInBlocModel homestay) {
    for (HomestayInBlocModel h in selectedBlocHomestayList!) {
      if (h.id == homestay.id) {
        return true;
      }
    }

    return false;
  }
}
