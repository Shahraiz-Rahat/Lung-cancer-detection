import 'package:flutter/material.dart';

class LandmarkListScreen extends StatefulWidget {
  final List<String> landmarkInfo;
  final List<double> xCoordinates;

  final List<double> yCoordinates;

  final List<double> zCoordinates;

  final List<double> likelihoods;

  LandmarkListScreen(
    this.landmarkInfo,
    this.xCoordinates,
    this.yCoordinates,
    this.zCoordinates,
    this.likelihoods,
  );

  @override
  State<LandmarkListScreen> createState() => _LandmarkListScreenState();
}

class _LandmarkListScreenState extends State<LandmarkListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Landmark List')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'LandMark Type',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    'LikeliHoods',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 690,
              child: ListView.builder(
                itemCount: widget.landmarkInfo.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(widget.landmarkInfo[index].toString()),
                    subtitle: Text(
                        '${widget.xCoordinates[index].toStringAsFixed(2)} , ${widget.yCoordinates[index].toStringAsFixed(2)} , ${widget.zCoordinates[index].toStringAsFixed(2)}'),
                    trailing:
                        Text(widget.likelihoods[index].toStringAsFixed(2)),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
