// ignore: unused_import
import 'dart:convert';
import 'dart:io';
// ignore: unnecessary_import
import 'dart:typed_data';
import 'package:Kaizen/providers/onboarding_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: unused_import
import 'package:google_mlkit_commons/google_mlkit_commons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
// ignore: unused_import
import 'package:flutter_downloader/flutter_downloader.dart';
// ignore: unused_import
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

class PDFScreen extends StatefulWidget {
  @override
  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> {
  PDFView? pdfWidget;
  bool isPDFRendered = false;
  bool isLoading = false;

  String apiUrl =
      'https://api.kaizenposturealignment.com:9080/user/generate_report';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // ignore: unused_local_variable
    final userData = Provider.of<UserData>(context); // Access it here if needed
    fetchAndDisplayImage();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final userData = Provider.of<UserData>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Report'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading) CircularProgressIndicator(),
            if (pdfWidget != null && isPDFRendered)
              Expanded(
                child: pdfWidget!,
              ),
            SizedBox(height: 20),
            Text('Name: ${userData.name}'),
            Text('Date of Birth: ${userData.selectDate.toString()}'),
            Text('Height: ${userData.selectHeight}'),
            Text('Weight: ${userData.selectWeight}'),
            Text('Gender: ${userData.isMale ? "Male" : "Female"}'),
          ],
        ),
      ),
    );
  }

  Future<void> fetchAndDisplayImage() async {
    setState(() {
      isLoading = true; // Show loader while fetching and processing data
    });
    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
    final userData = Provider.of<UserData>(context);
    // ignore: unused_local_variable
    bool isAppleHealth = userData.isAppleHealth;
    // ignore: unused_local_variable
    DateTime selectDate = userData.selectDate;
    String selectHeight = userData.selectHeight;
    String selectWeight = userData.selectWeight;
    bool isMale = userData.isMale;
    String name = userData.name;
    request.fields.addAll({
      'name': name,
      'dob': '5-07-97',
      'gender': isMale.toString(),
      'front_coordinates': jsonEncode(userData.imageData!["back"]["posesJson"]),
      'back_coordinates': jsonEncode(userData.imageData!["back"]["posesJson"]),
      'left_coordinates': jsonEncode(userData.imageData!["back"]["posesJson"]),
      'right_coordinates': jsonEncode(userData.imageData!["back"]["posesJson"]),
      'height': selectHeight,
      'weight': selectWeight,
      'fitness': 'Beginner'
    });

    List<String> filesToUpload = [
      'front',
      'back',
      'right',
      'left'
    ];
    File uploadFile;
    filesToUpload.forEach((element) {
      uploadFile = userData.imageData![element]["image"];
      request.files.add(
          http.MultipartFile(
              "${element}_image",
              uploadFile.readAsBytes().asStream(),
              uploadFile.lengthSync(),
              filename: uploadFile.path.split("/").last
          )
      );
    });

    http.StreamedResponse response = await request.send();
    // pdfWidget = await getAndShowPdf();

    if (response.statusCode == 200) {
      //  print(await response.stream.bytesToString());
      print('Error 2 : ${response.reasonPhrase}');
      print('Response headers: ${response.headers}');
      // pdfWidget = (await getAndShowPdf(response)) as PDFView?;

      // Extract PDF data from response
      Uint8List pdfData = await response.stream.toBytes();

      // Show the PDF in PDFView
      pdfWidget = (await getAndShowPdf(pdfData)) as PDFView?;

      // Save PDF data as a file
      await savePDFFile(pdfData);

      // await copyPDFToLocal();

      // await downloadAndSavePDF(pdfData);
      //  Widget pdfWidget = await getAndShowPdf(response as http.Response);
      setState(() {
        isPDFRendered = true;
        isLoading = false;
      });
    } else {
      print('Error 3 : ${response.reasonPhrase}');
    }
  }

  Future<Widget> getAndShowPdf(Uint8List pdfData) async {
    final dir = await getTemporaryDirectory();
    final file = File("${dir.path}/pdfFromWeb.pdf");
    await file.writeAsBytes(pdfData);

    return PDFView(
      filePath: file.path,
      enableSwipe: true,
      swipeHorizontal: true,
      autoSpacing: false,
      pageFling: false,
    );
  }

  Future<void> savePDFFile(Uint8List pdfData) async {
    final dir = await Directory('/storage/emulated/0/Download');
    final file = File("${dir?.path}/Kaizen_pdf.pdf");

    await file.writeAsBytes(pdfData);

    print('PDF file saved at path: ${file.path}');
  }

  // Future<void> copyPDFToLocal() async {
  //   final sourceFilePath = await getPDFFilePath(); // Get the source file path
  //   final sourceFile = File(sourceFilePath);
  //   //final sourceFile = File(await getPDFFilePath()); // Get the source file path
  //   //final destinationDir = await getExternalStorageDirectory();
  //   // final destinationFile = File("${destinationDir?.path}/downloaded_pdf.pdf");

  //   // try {
  //   //   await sourceFile.copy(destinationFile.path);
  //   //   print('PDF file copied to local storage ${destinationFile.path}');
  //   // } catch (e) {
  //   //   print('Error copying PDF file: $e');
  //   // }

  //   if (sourceFile.existsSync()) {
  //     final destinationDir = await getExternalStorageDirectory();
  //     final destinationFilePath = "${destinationDir?.path}/downloaded_pdf.pdf";

  //     final destinationFile = File(destinationFilePath);

  //     try {
  //       await sourceFile.copy(destinationFile.path);
  //       print('PDF file copied to local storage');
  //     } catch (e) {
  //       print('Error copying PDF file: $e');
  //     }
  //   } else {
  //     print('Source PDF file does not exist at path: $sourceFilePath');
  //   }
  // }

  // Future<String> getPDFFilePath() async {
  //   final dir = await getExternalStorageDirectory();
  //   return "${dir?.path}/downloaded_pdf.pdf";
  // }

  // Future<void> downloadAndSavePDF(Uint8List pdfData) async {
  //   final status = await Permission.storage.request();
  //   if (status.isGranted) {
  //     final dir = await getExternalStorageDirectory();
  //     final file = File("${dir?.path}/downloaded_pdf.pdf");
  //     await file.writeAsBytes(pdfData);

  //     final taskId = await FlutterDownloader.enqueue(
  //       // url:
  //       //     'https://api.kaizenposturealignment.com:9080/', // Use the correct file path for the PDF
  //       // headers: ({
  //       //   'coordinates': jsonEncode({
  //       //     'Parts': widget.landmarkInfo,
  //       //     'x': widget.xCoordinates,
  //       //     'y': widget.yCoordinates,
  //       //     'z': widget.zCoordinates,
  //       //   }),
  //       //   'name': 'Test',
  //       //   'dob': '5-07-97',
  //       //   'gender': 'M',
  //       // }),
  //       url: '', // Use the correct file path for the PDF
  //       savedDir: dir!.path,
  //       fileName: 'downloaded_pdf.pdf',
  //       showNotification: true,
  //       openFileFromNotification: true,
  //     );
  //     print('Download task ID: $taskId');
  //   } else {
  //     print('Permission denied');
  //   }
  // }

  Future<Uint8List> pickAndConvertImage() async {
    final picker = ImagePicker();
    // ignore: deprecated_member_use
    final pickedFile = await picker.getImage(
        source: // ImageSource.camera
            ImageSource.gallery);

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

  // Future<Widget> getAndShowPdf(Uint8List pdfData) async {
  //   final dir = await getExternalStorageDirectory();
  //   final file = File("${dir?.path}/pdfFromWeb.pdf");

  //   await file.writeAsBytes(pdfData);

  //   return PDFView(
  //     filePath: await getPDFFilePath(),
  //     enableSwipe: true,
  //     swipeHorizontal: true,
  //     autoSpacing: false,
  //     pageFling: false,
  //   );
  // }

  Future<void> printExternalStorageDirectory() async {
    final externalDir = await getExternalStorageDirectory();
    print('External Storage Directory: ${externalDir?.path}');
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserData(),
      child: MaterialApp(
        home: PDFScreen(),
      ),
    ),
  );
}

// void main() => runApp(MaterialApp(home: PDFScreen()));
