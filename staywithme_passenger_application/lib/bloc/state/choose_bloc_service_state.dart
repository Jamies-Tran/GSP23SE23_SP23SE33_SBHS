import 'package:staywithme_passenger_application/model/homestay_model.dart';

class ChooseBlocServiceState {
  ChooseBlocServiceState({this.homestayServiceList, this.overviewFlag = false});

  List<HomestayServiceModel>? homestayServiceList;
  bool? overviewFlag;

  bool isHomestayServiceSelected(String serviceName) {
    for (HomestayServiceModel service in homestayServiceList!) {
      if (service.name == serviceName) {
        return true;
      }
    }
    return false;
  }

  int totalServicePrice() {
    int totalPrice = 0;
    for (HomestayServiceModel service in homestayServiceList!) {
      totalPrice = totalPrice + service.price!;
    }
    return totalPrice;
  }
}
