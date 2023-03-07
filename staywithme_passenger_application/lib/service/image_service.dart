import 'package:firebase_storage/firebase_storage.dart';

abstract class IImageService {
  Future<dynamic> getAreaImage(String area);

  Future<dynamic> getHomestayImage(String img);
}

class ImageService extends IImageService {
  final fireStorage = FirebaseStorage.instance.ref();

  @override
  Future getAreaImage(String area) async {
    String img = "$area.jpg";
    String url = await fireStorage
        .child("homepage")
        .child("homepage_mobile")
        .child(img)
        .getDownloadURL();

    return url;
  }

  @override
  Future getHomestayImage(String img) async {
    try {
      String url =
          await fireStorage.child("homestay").child(img).getDownloadURL();
      return url;
    } on FirebaseException {
      return null;
    }
  }
}
