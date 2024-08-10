import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

import 'image_cache.dart';


final ImagePicker _picker = ImagePicker();
FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;
ImageCacheManager _imageCacheManager = ImageCacheManager();
Future<String?> pickImages(ImageSource source) async {
  XFile? file = await _picker.pickImage(source: source);
  final storageReference = FirebaseStorage.instance
      .ref()
      .child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');
  try {
    if (file != null) {
      EasyLoading.show();
      File imageFile = File(file.path);
      int imageSizeInBytes = imageFile.lengthSync();
      double imageSizeInMB = imageSizeInBytes / (1024 * 1024);
      if (imageSizeInMB > 2) {
        double scaleFactor = 2 / imageSizeInMB;
        List<int> imageBytes = await resizeImage(imageFile, scaleFactor);
        file = await saveResizedImage(imageBytes);
      }
      final uploadTask = storageReference.putFile(File(file.path));
      await uploadTask.whenComplete(() {});
      final downloadUrl = await storageReference.getDownloadURL();
      await firestore.collection('Users').doc(auth.currentUser!.uid).update({
        "image":downloadUrl
      });
      EasyLoading.dismiss();
      return downloadUrl;
    } else {
      return null;
    }
  } catch (e) {
    print('Error picking images: $e');
    // Handle errors as needed
    return null;
  }
}

Future<List<int>> resizeImage(File imageFile, double scaleFactor) async {
  String cacheKey = '${path.basename(imageFile.path)}_$scaleFactor';
  // Check if the resized image is already in the cache
  Uint8List? cachedImage = await _imageCacheManager.getImageFromCache(cacheKey);
  if (cachedImage != null) {
    print('Using cached image for resizing: $cacheKey');
    return cachedImage;
  }

  try {
    // Read original image bytes
    List<int> originalBytes = await imageFile.readAsBytes();

    // Get original image dimensions
    img.Image originalImage = img.decodeImage( Uint8List.fromList(originalBytes))!;
    int originalWidth = originalImage.width;
    int originalHeight = originalImage.height;

    // Compress and resize the image
    List<int> compressedBytes = await FlutterImageCompress.compressWithList(
      Uint8List.fromList(originalBytes),
      minHeight: (originalHeight * scaleFactor).toInt(),
      minWidth: (originalWidth * scaleFactor).toInt(),
      quality: 90, // Adjust the quality as needed
    );

    // Add the resized image to the cache
    _imageCacheManager.addToCache(cacheKey, Uint8List.fromList(compressedBytes));

    return compressedBytes;
  } catch (e) {
    print('Error resizing image: $e');
    throw e;
  }
}

Future<XFile> saveResizedImage(List<int> imageBytes) async {
  File resizedFile = File('${(await getTemporaryDirectory()).path}/resized_image.jpg');
  await resizedFile.writeAsBytes(imageBytes);
  return XFile(resizedFile.path);
}