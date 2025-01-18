import 'dart:convert';
import 'dart:html' as html;
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

Future<List<String>> uploadImagesToFolder(
    List<dynamic> images, String folderName) async {
  const String cloudName = "dume7lvn5";
  const String uploadPreset =
      "my_preset"; // Ensure it's configured in Cloudinary.

  final List<String> uploadedUrls = [];

  for (var image in images) {
    try {
      final Uri url =
          Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/image/upload");

      final http.MultipartRequest request = http.MultipartRequest('POST', url)
        ..fields['upload_preset'] = uploadPreset
        ..fields['folder'] = folderName;

      if (image is XFile) {
        // Handle images picked on native platforms
        request.files.add(await http.MultipartFile.fromPath(
          'file',
          image.path,
        ));
      } else if (image is html.File) {
        // Handle images picked on the web
        final html.FileReader reader = html.FileReader();
        reader.readAsArrayBuffer(image);
        await reader.onLoad.first;

        final Uint8List bytes = reader.result as Uint8List;
        request.files.add(http.MultipartFile.fromBytes(
          'file',
          bytes,
          filename: image.name,
        ));
      }

      // Send the request
      final http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        // Parse the response and extract the secure URL
        final http.Response responseData =
            await http.Response.fromStream(response);
        final Map<String, dynamic> jsonResponse =
            json.decode(responseData.body);
        final String imageUrl = jsonResponse['secure_url'];
        uploadedUrls.add(imageUrl);
      } else {
        // Handle upload errors
        final String errorResponse =
            await http.Response.fromStream(response).then((r) => r.body);
        print(
            'Failed to upload image. Status code: ${response.statusCode}, response: $errorResponse');
      }
    } catch (e) {
      // Log any exceptions during the upload
      print('Error uploading image: $e');
    }
  }

  print(
      'Successfully uploaded ${uploadedUrls.length}/${images.length} images.');
  return uploadedUrls;
}
