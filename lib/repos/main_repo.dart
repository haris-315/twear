import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

Future<List<String>> uploadImagesToFolder(
    List<XFile> images, String folderName) async {
  const String cloudName = "dume7lvn5";
  const String uploadPreset = "my_preset"; 

  final List<String> uploadedUrls = [];

  for (var image in images) {
    try {
      final Uri url =
          Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/image/upload");

      final http.MultipartRequest request = http.MultipartRequest('POST', url)
        ..fields['upload_preset'] = uploadPreset
        ..fields['folder'] = folderName;

  
      final Uint8List bytes = await image.readAsBytes();

      
      request.files.add(http.MultipartFile.fromBytes(
        'file', 
        bytes,
        filename: image.name,
      ));

  
      final http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
    
        final http.Response responseData =
            await http.Response.fromStream(response);
        final Map<String, dynamic> jsonResponse =
            json.decode(responseData.body);
        final String imageUrl = jsonResponse['secure_url'];
        uploadedUrls.add(imageUrl);
      } else {
       
        final String errorResponse =
            await http.Response.fromStream(response).then((r) => r.body);
        print(
            'Failed to upload image. Status code: ${response.statusCode}, response: $errorResponse');
      }
    } catch (e) {
      
      print('Error uploading image: $e');
    }
  }

  print(
      'Successfully uploaded ${uploadedUrls.length}/${images.length} images.');
  return uploadedUrls;
}
