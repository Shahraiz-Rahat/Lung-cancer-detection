// ignore: unused_import
import 'dart:convert';
import 'dart:io';
// ignore: unnecessary_import
import 'dart:typed_data';
import 'package:Kaizen/user_data_provider.dart';
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
  void initState() {
    super.initState();
    fetchAndDisplayImage();
  }

  @override
  Widget build(BuildContext context) {
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
    print("Working fine here , but agy ja k mot py jandi hy inu");
    request.fields.addAll({
      'name': name,
      'dob': '5-07-97',
      'gender': isMale.toString(),
      'front_coordinates':
          '{"Parts": ["PoseLandmarkType.nose", "PoseLandmarkType.leftEyeInner", "PoseLandmarkType.leftEye", "PoseLandmarkType.leftEyeOuter", "PoseLandmarkType.rightEyeInner", "PoseLandmarkType.rightEye", "PoseLandmarkType.rightEyeOuter", "PoseLandmarkType.leftEar", "PoseLandmarkType.rightEar", "PoseLandmarkType.leftMouth", "PoseLandmarkType.rightMouth", "PoseLandmarkType.leftShoulder", "PoseLandmarkType.rightShoulder", "PoseLandmarkType.leftElbow", "PoseLandmarkType.rightElbow", "PoseLandmarkType.leftWrist", "PoseLandmarkType.rightWrist", "PoseLandmarkType.leftPinky", "PoseLandmarkType.rightPinky", "PoseLandmarkType.leftIndex", "PoseLandmarkType.rightIndex", "PoseLandmarkType.leftThumb", "PoseLandmarkType.rightThumb", "PoseLandmarkType.leftHip", "PoseLandmarkType.rightHip", "PoseLandmarkType.leftKnee", "PoseLandmarkType.rightKnee", "PoseLandmarkType.leftAnkle", "PoseLandmarkType.rightAnkle", "PoseLandmarkType.leftHeel", "PoseLandmarkType.rightHeel", "PoseLandmarkType.leftFootIndex", "PoseLandmarkType.rightFootIndex"], "x": [625.0697631835938, 646.7388305664062, 663.4198608398438, 679.5223388671875, 600.0662231445312, 587.9764404296875, 575.8153076171875, 704.6240234375, 561.02490234375, 664.4953002929688, 602.3020629882812, 830.6730346679688, 480.6244812011719, 767.545166015625, 318.2401123046875, 487.6826477050781, 178.59088134765625, 428.61614990234375, 115.75270080566406, 420.0767822265625, 123.34139251708984, 439.4665222167969, 154.476806640625, 739.9375, 524.9330444335938, 716.0554809570312, 498.94952392578125, 681.6533203125, 477.61773681640625, 687.4583129882812, 477.09954833984375, 619.9705810546875, 465.899169921875], "y": [175.6158447265625, 142.7200164794922, 141.1238555908203, 138.25828552246094, 147.41595458984375, 150.1839599609375, 152.53843688964844, 156.45654296875, 175.2053680419922, 215.14134216308594, 218.6996612548828, 375.47344970703125, 368.79913330078125, 654.652099609375, 594.6901245117188, 598.0252075195312, 435.5631408691406, 591.9931030273438, 402.5274963378906, 546.2178344726562, 370.44012451171875, 542.8884887695312, 384.37835693359375, 852.3903198242188, 827.5252075195312, 1167.5135498046875, 1147.41455078125, 1458.2659912109375, 1437.436279296875, 1498.0423583984375, 1476.2232666015625, 1574.4697265625, 1559.6094970703125], "z": [-842.067138671875, -803.6666870117188, -803.6666870117188, -803.2095336914062, -761.6090698242188, -762.066162109375, -762.5233154296875, -500.1202392578125, -307.2036437988281, -725.0371704101562, -668.3507690429688, -404.8048095703125, -9.62868595123291, -750.637451171875, -306.2893371582031, -1301.958251953125, -1056.0125732421875, -1446.4171142578125, -1173.04248046875, -1400.702392578125, -1209.6143798828125, -1294.6439208984375, -1089.8414306640625, -85.82958984375, 87.02960205078125, -314.2894287109375, -81.20096588134766, 273.3746643066406, 344.232666015625, 323.4324035644531, 381.71881103515625, 40.5719108581543, 92.80110168457031]}',
      'back_coordinates':
          '{"Parts": ["PoseLandmarkType.nose", "PoseLandmarkType.leftEyeInner", "PoseLandmarkType.leftEye", "PoseLandmarkType.leftEyeOuter", "PoseLandmarkType.rightEyeInner", "PoseLandmarkType.rightEye", "PoseLandmarkType.rightEyeOuter", "PoseLandmarkType.leftEar", "PoseLandmarkType.rightEar", "PoseLandmarkType.leftMouth", "PoseLandmarkType.rightMouth", "PoseLandmarkType.leftShoulder", "PoseLandmarkType.rightShoulder", "PoseLandmarkType.leftElbow", "PoseLandmarkType.rightElbow", "PoseLandmarkType.leftWrist", "PoseLandmarkType.rightWrist", "PoseLandmarkType.leftPinky", "PoseLandmarkType.rightPinky", "PoseLandmarkType.leftIndex", "PoseLandmarkType.rightIndex", "PoseLandmarkType.leftThumb", "PoseLandmarkType.rightThumb", "PoseLandmarkType.leftHip", "PoseLandmarkType.rightHip", "PoseLandmarkType.leftKnee", "PoseLandmarkType.rightKnee", "PoseLandmarkType.leftAnkle", "PoseLandmarkType.rightAnkle", "PoseLandmarkType.leftHeel", "PoseLandmarkType.rightHeel", "PoseLandmarkType.leftFootIndex", "PoseLandmarkType.rightFootIndex"], "x": [625.0697631835938, 646.7388305664062, 663.4198608398438, 679.5223388671875, 600.0662231445312, 587.9764404296875, 575.8153076171875, 704.6240234375, 561.02490234375, 664.4953002929688, 602.3020629882812, 830.6730346679688, 480.6244812011719, 767.545166015625, 318.2401123046875, 487.6826477050781, 178.59088134765625, 428.61614990234375, 115.75270080566406, 420.0767822265625, 123.34139251708984, 439.4665222167969, 154.476806640625, 739.9375, 524.9330444335938, 716.0554809570312, 498.94952392578125, 681.6533203125, 477.61773681640625, 687.4583129882812, 477.09954833984375, 619.9705810546875, 465.899169921875], "y": [175.6158447265625, 142.7200164794922, 141.1238555908203, 138.25828552246094, 147.41595458984375, 150.1839599609375, 152.53843688964844, 156.45654296875, 175.2053680419922, 215.14134216308594, 218.6996612548828, 375.47344970703125, 368.79913330078125, 654.652099609375, 594.6901245117188, 598.0252075195312, 435.5631408691406, 591.9931030273438, 402.5274963378906, 546.2178344726562, 370.44012451171875, 542.8884887695312, 384.37835693359375, 852.3903198242188, 827.5252075195312, 1167.5135498046875, 1147.41455078125, 1458.2659912109375, 1437.436279296875, 1498.0423583984375, 1476.2232666015625, 1574.4697265625, 1559.6094970703125], "z": [-842.067138671875, -803.6666870117188, -803.6666870117188, -803.2095336914062, -761.6090698242188, -762.066162109375, -762.5233154296875, -500.1202392578125, -307.2036437988281, -725.0371704101562, -668.3507690429688, -404.8048095703125, -9.62868595123291, -750.637451171875, -306.2893371582031, -1301.958251953125, -1056.0125732421875, -1446.4171142578125, -1173.04248046875, -1400.702392578125, -1209.6143798828125, -1294.6439208984375, -1089.8414306640625, -85.82958984375, 87.02960205078125, -314.2894287109375, -81.20096588134766, 273.3746643066406, 344.232666015625, 323.4324035644531, 381.71881103515625, 40.5719108581543, 92.80110168457031]}',
      'left_coordinates':
          '{"Parts": ["PoseLandmarkType.nose", "PoseLandmarkType.leftEyeInner", "PoseLandmarkType.leftEye", "PoseLandmarkType.leftEyeOuter", "PoseLandmarkType.rightEyeInner", "PoseLandmarkType.rightEye", "PoseLandmarkType.rightEyeOuter", "PoseLandmarkType.leftEar", "PoseLandmarkType.rightEar", "PoseLandmarkType.leftMouth", "PoseLandmarkType.rightMouth", "PoseLandmarkType.leftShoulder", "PoseLandmarkType.rightShoulder", "PoseLandmarkType.leftElbow", "PoseLandmarkType.rightElbow", "PoseLandmarkType.leftWrist", "PoseLandmarkType.rightWrist", "PoseLandmarkType.leftPinky", "PoseLandmarkType.rightPinky", "PoseLandmarkType.leftIndex", "PoseLandmarkType.rightIndex", "PoseLandmarkType.leftThumb", "PoseLandmarkType.rightThumb", "PoseLandmarkType.leftHip", "PoseLandmarkType.rightHip", "PoseLandmarkType.leftKnee", "PoseLandmarkType.rightKnee", "PoseLandmarkType.leftAnkle", "PoseLandmarkType.rightAnkle", "PoseLandmarkType.leftHeel", "PoseLandmarkType.rightHeel", "PoseLandmarkType.leftFootIndex", "PoseLandmarkType.rightFootIndex"], "x": [625.0697631835938, 646.7388305664062, 663.4198608398438, 679.5223388671875, 600.0662231445312, 587.9764404296875, 575.8153076171875, 704.6240234375, 561.02490234375, 664.4953002929688, 602.3020629882812, 830.6730346679688, 480.6244812011719, 767.545166015625, 318.2401123046875, 487.6826477050781, 178.59088134765625, 428.61614990234375, 115.75270080566406, 420.0767822265625, 123.34139251708984, 439.4665222167969, 154.476806640625, 739.9375, 524.9330444335938, 716.0554809570312, 498.94952392578125, 681.6533203125, 477.61773681640625, 687.4583129882812, 477.09954833984375, 619.9705810546875, 465.899169921875], "y": [175.6158447265625, 142.7200164794922, 141.1238555908203, 138.25828552246094, 147.41595458984375, 150.1839599609375, 152.53843688964844, 156.45654296875, 175.2053680419922, 215.14134216308594, 218.6996612548828, 375.47344970703125, 368.79913330078125, 654.652099609375, 594.6901245117188, 598.0252075195312, 435.5631408691406, 591.9931030273438, 402.5274963378906, 546.2178344726562, 370.44012451171875, 542.8884887695312, 384.37835693359375, 852.3903198242188, 827.5252075195312, 1167.5135498046875, 1147.41455078125, 1458.2659912109375, 1437.436279296875, 1498.0423583984375, 1476.2232666015625, 1574.4697265625, 1559.6094970703125], "z": [-842.067138671875, -803.6666870117188, -803.6666870117188, -803.2095336914062, -761.6090698242188, -762.066162109375, -762.5233154296875, -500.1202392578125, -307.2036437988281, -725.0371704101562, -668.3507690429688, -404.8048095703125, -9.62868595123291, -750.637451171875, -306.2893371582031, -1301.958251953125, -1056.0125732421875, -1446.4171142578125, -1173.04248046875, -1400.702392578125, -1209.6143798828125, -1294.6439208984375, -1089.8414306640625, -85.82958984375, 87.02960205078125, -314.2894287109375, -81.20096588134766, 273.3746643066406, 344.232666015625, 323.4324035644531, 381.71881103515625, 40.5719108581543, 92.80110168457031]}',
      'right_coordinates':
          '{"Parts": ["PoseLandmarkType.nose", "PoseLandmarkType.leftEyeInner", "PoseLandmarkType.leftEye", "PoseLandmarkType.leftEyeOuter", "PoseLandmarkType.rightEyeInner", "PoseLandmarkType.rightEye", "PoseLandmarkType.rightEyeOuter", "PoseLandmarkType.leftEar", "PoseLandmarkType.rightEar", "PoseLandmarkType.leftMouth", "PoseLandmarkType.rightMouth", "PoseLandmarkType.leftShoulder", "PoseLandmarkType.rightShoulder", "PoseLandmarkType.leftElbow", "PoseLandmarkType.rightElbow", "PoseLandmarkType.leftWrist", "PoseLandmarkType.rightWrist", "PoseLandmarkType.leftPinky", "PoseLandmarkType.rightPinky", "PoseLandmarkType.leftIndex", "PoseLandmarkType.rightIndex", "PoseLandmarkType.leftThumb", "PoseLandmarkType.rightThumb", "PoseLandmarkType.leftHip", "PoseLandmarkType.rightHip", "PoseLandmarkType.leftKnee", "PoseLandmarkType.rightKnee", "PoseLandmarkType.leftAnkle", "PoseLandmarkType.rightAnkle", "PoseLandmarkType.leftHeel", "PoseLandmarkType.rightHeel", "PoseLandmarkType.leftFootIndex", "PoseLandmarkType.rightFootIndex"], "x": [625.0697631835938, 646.7388305664062, 663.4198608398438, 679.5223388671875, 600.0662231445312, 587.9764404296875, 575.8153076171875, 704.6240234375, 561.02490234375, 664.4953002929688, 602.3020629882812, 830.6730346679688, 480.6244812011719, 767.545166015625, 318.2401123046875, 487.6826477050781, 178.59088134765625, 428.61614990234375, 115.75270080566406, 420.0767822265625, 123.34139251708984, 439.4665222167969, 154.476806640625, 739.9375, 524.9330444335938, 716.0554809570312, 498.94952392578125, 681.6533203125, 477.61773681640625, 687.4583129882812, 477.09954833984375, 619.9705810546875, 465.899169921875], "y": [175.6158447265625, 142.7200164794922, 141.1238555908203, 138.25828552246094, 147.41595458984375, 150.1839599609375, 152.53843688964844, 156.45654296875, 175.2053680419922, 215.14134216308594, 218.6996612548828, 375.47344970703125, 368.79913330078125, 654.652099609375, 594.6901245117188, 598.0252075195312, 435.5631408691406, 591.9931030273438, 402.5274963378906, 546.2178344726562, 370.44012451171875, 542.8884887695312, 384.37835693359375, 852.3903198242188, 827.5252075195312, 1167.5135498046875, 1147.41455078125, 1458.2659912109375, 1437.436279296875, 1498.0423583984375, 1476.2232666015625, 1574.4697265625, 1559.6094970703125], "z": [-842.067138671875, -803.6666870117188, -803.6666870117188, -803.2095336914062, -761.6090698242188, -762.066162109375, -762.5233154296875, -500.1202392578125, -307.2036437988281, -725.0371704101562, -668.3507690429688, -404.8048095703125, -9.62868595123291, -750.637451171875, -306.2893371582031, -1301.958251953125, -1056.0125732421875, -1446.4171142578125, -1173.04248046875, -1400.702392578125, -1209.6143798828125, -1294.6439208984375, -1089.8414306640625, -85.82958984375, 87.02960205078125, -314.2894287109375, -81.20096588134766, 273.3746643066406, 344.232666015625, 323.4324035644531, 381.71881103515625, 40.5719108581543, 92.80110168457031]}',
      'height': selectHeight,
      'weight': selectWeight,
      'fitness': 'Beginner'
    });
    print("lo g ithy tk phnch gy  , but agy ja k mot py jandi hy inu");

    final frontImageBytes = await rootBundle.load('assets/img/cardio.png');
    final backImageBytes = await rootBundle.load('assets/img/girlHoldDumb.jpg');
    final leftImageBytes = await rootBundle.load('assets/img/strength.png');
    final rightImageBytes =
        await rootBundle.load('assets/img/welcomeBgImage1.png');
    // Add your request fields here

    // Convert the InputImage to image bytes using image_picker
    // ignore: unused_local_variable
    Uint8List imageBytes = await pickAndConvertImage();

    // Add the image to the request
    // request.files.add(await http.MultipartFile.fromBytes('images', imageBytes,
    //     filename: 'cardio.png'));

    // Add image bytes as MultipartFiles
    // request.files.add(http.MultipartFile.fromBytes('front_image', imageBytes,
    //     filename: 'cardio.png'));
    // request.files.add(http.MultipartFile.fromBytes('back_image', imageBytes,
    //     filename: 'girlHoldDumb.jpg'));
    // request.files.add(http.MultipartFile.fromBytes('left_image', imageBytes,
    //     filename: 'strength.png'));
    // request.files.add(http.MultipartFile.fromBytes('right_image', imageBytes,
    //     filename: 'welcomeBgImage1.png'));

    request.files.add(http.MultipartFile.fromBytes(
        'front_image', frontImageBytes.buffer.asUint8List(),
        filename: 'patliKuri.png'));
    request.files.add(http.MultipartFile.fromBytes(
        'back_image', backImageBytes.buffer.asUint8List(),
        filename: 'welcomeBgImage1.jpg'));
    request.files.add(http.MultipartFile.fromBytes(
        'left_image', leftImageBytes.buffer.asUint8List(),
        filename: 'strength.png'));
    request.files.add(http.MultipartFile.fromBytes(
        'right_image', rightImageBytes.buffer.asUint8List(),
        filename: 'superBody.png'));

    print(" DEBUGGING FILES FOR TEST  ${request.files}");

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
      // await savePDFFile(pdfData);

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

  // Future<void> savePDFFile(Uint8List pdfData) async {
  //   final dir = await getExternalStorageDirectory();
  //   final file = File("${dir?.path}/Kaizen_pdf.pdf");

  //   await file.writeAsBytes(pdfData);

  //   print('PDF file saved at path: ${file.path}');
  // }

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
