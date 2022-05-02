import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FileRequests {
  static final ImagePicker _picker = ImagePicker();
  static final getImage = (ImageSource source) async {
    try {
      final XFile? file = await _picker.pickImage(source: source);
      if (file != null) {
        return await file.readAsBytes();
      }
    } catch (e) {
      print(e);
      return null;
    }
    return null;
  };
  static final uploadImage = (Uint8List image) async {
    //get date
    var time = DateTime.now();
    String dir = '${time.microsecondsSinceEpoch}.png';
    try {
      //upload file
      var ref = FirebaseStorage.instance
          .ref('/user/${FirebaseAuth.instance.currentUser!.uid}/$dir');
      await ref.putData(image);

      //get file url
      return ref.getDownloadURL();
    } catch (e) {
      return null;
    }
  };
}
