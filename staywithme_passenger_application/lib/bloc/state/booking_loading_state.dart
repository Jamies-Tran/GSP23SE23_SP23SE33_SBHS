class BookingLoadingState {
  BookingLoadingState(
      {this.bookingId,
      this.homestayType,
      this.isBookingHomestay,
      this.bookingHomestayIndex});

  int? bookingId;
  String? homestayType;
  bool? isBookingHomestay;
  int? bookingHomestayIndex;
}
