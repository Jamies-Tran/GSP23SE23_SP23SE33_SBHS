import 'package:staywithme_passenger_application/model/homestay_model.dart';

class ChooseServiceState {
  ChooseServiceState({this.homestayServiceList = const []});

  List<HomestayServiceModel> homestayServiceList;

  int totalServicePrice() {
    int totalPrice = 0;
    for (HomestayServiceModel service in homestayServiceList) {
      totalPrice = totalPrice + service.price!;
    }
    return totalPrice;
  }

  bool isServiceChoose(String serviceName) {
    for (HomestayServiceModel homestayServiceModel in homestayServiceList) {
      if (homestayServiceModel.name == serviceName) {
        return true;
      }
    }
    return false;
  }
}
