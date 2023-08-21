import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

Future<Widget> getAndShowPdf(http.StreamedResponse response) async {
  final dir = await getExternalStorageDirectory();
  final file = File("${dir?.path}/pdfFromWeb.pdf");

  await file.writeAsBytes(await response.stream.toBytes());

  return PDFView(
    filePath: file.path,
    enableSwipe: true,
    swipeHorizontal: true,
    autoSpacing: false,
    pageFling: false,
  );
}

class PDFScreen extends StatefulWidget {
  final List<String> landmarkInfo;
  final List<double>? xCoordinates;
  final List<double> yCoordinates;
  final List<double> zCoordinates;
  final List<double> likelihoods;
  final InputImage inputImage; // Add this parameter to receive the image data

  PDFScreen({
    required this.landmarkInfo,
    required this.xCoordinates,
    required this.yCoordinates,
    required this.zCoordinates,
    required this.likelihoods,
    required this.inputImage, // Receive the image data
  });

  @override
  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> {
  PDFView? pdfWidget;

  String apiUrl = 'https://api.kaizenposturealignment.com:9080/';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: fetchAndDisplayImage,
              child: Text('Fetch and Display Image'),
            ),
            if (pdfWidget != null) // Show the PDF widget if it's available
              Expanded(child: pdfWidget!),
          ],
        ),
      ),
    );
  }

  Future<void> fetchAndDisplayImage() async {
    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
    // Add your request fields here
    request.fields.addAll({
      'coordinates': jsonEncode({
        'x': widget.xCoordinates,
        'y': widget.yCoordinates,
        'z': widget.zCoordinates,
      }),
      'name': 'Test',
      'dob': '5-07-97',
      'gender': 'M',
    });

    // Convert the InputImage to image bytes using image_picker
    Uint8List imageBytes = await pickAndConvertImage();

    // Add the image to the request
    request.files.add(await http.MultipartFile.fromBytes('images', imageBytes,
        filename: 'cardio.png'));

    print("SHAHZEB DEBUG ${request.files}");

    http.StreamedResponse response = await request.send();
// pdfWidget = await getAndShowPdf();
    if (response.statusCode == 200) {
      //  print(await response.stream.bytesToString());
      print('Error 2 : ${response.reasonPhrase}');
      print('Response headers: ${response.headers}');
      pdfWidget = (await getAndShowPdf(response)) as PDFView?;
      //  Widget pdfWidget = await getAndShowPdf(response as http.Response);
      setState(() {
        // pdfWidget = pdfWidget;
        // Optionally, you can store the imageBytes for later use if needed
        // Decompress the response
        // Uint8List decompressedResponse =
        //     await http.ByteStream(response.stream).toBytes();

        // // Decode the JSON content
        // String decodedResponse = utf8.decode(decompressedResponse);
        // print('Decoded Response: $decodedResponse');
      });
    } else {
      print('Error 3 : ${response.reasonPhrase}');
    }
  }

  Future<Uint8List> pickAndConvertImage() async {
    final picker = ImagePicker();
    // ignore: deprecated_member_use
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // Convert the picked image to Uint8List
      Uint8List imageData = await pickedFile.readAsBytes();
      print(imageData);
      return imageData;
    } else {
      // Handle no image picked scenario
      return Uint8List(0); // Or return null or handle the situation accordingly
    }
  }
}

// void main() => runApp(MaterialApp(home: PDFScreen()));
