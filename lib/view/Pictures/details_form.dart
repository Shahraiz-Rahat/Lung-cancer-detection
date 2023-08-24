import 'package:Kaizen/common_widget/round_button.dart';
import 'package:Kaizen/view/home/home_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../common/color_extension.dart';
// ignore: unused_import
import '../../main.dart';

class DetailsForm extends StatefulWidget {
  @override
  State<DetailsForm> createState() => _DetailsForm();
}

class _DetailsForm extends State<DetailsForm> {
  bool? isMale = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text(
          'Lets Generate Your Report',
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
        ),
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 40, top: 40),
            child: const Text('Enter Some Details To Continue',
                style: TextStyle(color: Colors.black, fontSize: 20)),
          ),
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 35, right: 35),
                    child: Column(
                      children: [
                        TextField(
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              fillColor: Colors.grey.shade100,
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                              hintText: "Name",
                              hintStyle: const TextStyle(color: Colors.black),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              )),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        TextField(
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              fillColor: Colors.grey.shade100,
                              filled: true,
                              hintText: "Date Of Birth",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              )),
                        ),
                        const SizedBox(
                          height: 30,
                        ),

                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 20, // media.width * 0.05,
                          ),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Gender',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: FitColors.primary,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700),
                                ),
                                SizedBox(height: 8),
                                CupertinoSegmentedControl<bool>(
                                  groupValue: isMale,
                                  selectedColor: FitColors.primary,
                                  unselectedColor: FitColors.favClr,
                                  borderColor: FitColors.favClr,
                                  children: const {
                                    true: Text(
                                      ' Male ',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    false: Text(
                                      ' Female ',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  },
                                  onValueChanged: (isMaleVal) {
                                    setState(() {
                                      isMale = isMaleVal;
                                    });
                                  },
                                  padding: EdgeInsets.zero,
                                ),
                              ]),
                        ),

                        // TextField(
                        //   style: const TextStyle(),
                        //   obscureText: true,
                        //   decoration: InputDecoration(
                        //       fillColor: Colors.grey.shade100,
                        //       filled: true,
                        //       hintText: "Gender",
                        //       border: OutlineInputBorder(
                        //         borderRadius: BorderRadius.circular(10),
                        //       )),
                        // ),
                        const SizedBox(
                          height: 40,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 20),
                          child: RoundButton(
                              title: 'Generate Report',
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PDFScreen()),
                                );
                              }),
                        ),
                        // const SizedBox(
                        //   height: 40,
                        // ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
