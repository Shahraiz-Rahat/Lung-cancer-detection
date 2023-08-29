import 'package:Kaizen/providers/onboarding_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import '../../common/color_extension.dart';
import '../../common_widget/round_button.dart';
import '../../common_widget/select_date_time.dart';
import '../../common_widget/select_picker.dart';
import '../../main.dart';

class Step3View extends StatefulWidget {
  @override
  State<Step3View> createState() => _Step3ViewState();
}

class _Step3ViewState extends State<Step3View> {
  bool isAppleHealth = true;
  DateTime? selectDate;
  String? selectHeight;
  String? selectWeight;
  bool? isMale = true;
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_final_locals
    var media = MediaQuery.sizeOf(context);

    return Container(
      child: Scaffold(
        // backgroundColor: FitColors.primary,
        appBar: AppBar(
          backgroundColor: FitColors.primary,
          centerTitle: true,
          title: Text(
            'Step 3 of 3',
            style: TextStyle(
                color: FitColors.white,
                fontSize: 22,
                fontWeight: FontWeight.w700),
          ),
        ),
        body: Stack(
          children: [
            Image.asset(
              'assets/img/dumbBalls.jpg',
              width: media.width,
              height: media.height,
              fit: BoxFit.cover,
            ),
            SafeArea(
              child: Container(
                margin: const EdgeInsets.only(left: 15, right: 15),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        'Personal Details',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: FitColors.favClr,
                            fontSize: 24,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Text(
                        'Let us know about you to speed up the result, Get fit with your personal workout plan!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: FitColors.favClr,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: media.width * 0.08,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Apple Health',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: FitColors.favClr,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Allow access to fill parameters',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: FitColors.favClr,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Switch(
                                  activeColor: FitColors.favClr,
                                  value: isAppleHealth,
                                  onChanged: (newVal) {
                                    setState(() {
                                      isAppleHealth = newVal;
                                    });
                                  })
                            ],
                          ),
                          SizedBox(
                            height: media.width * 0.05,
                          ),
                          Divider(
                            color: FitColors.divider,
                            height: 1,
                          ),
                          SizedBox(
                            height: media.width * 0.02,
                          ),
                          TextField(
                            style: const TextStyle(color: Colors.white),
                            controller: nameController,
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Colors.white,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                hintText: "Name",
                                hintStyle: const TextStyle(color: Colors.white),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                          // TextField(
                          //   controller: nameController,
                          //   decoration: InputDecoration(
                          //     labelText:
                          //         'Name', // Change this label text as needed
                          //     border: OutlineInputBorder(),
                          //   ),
                          // ),
                          SizedBox(
                            height: media.width * 0.02,
                          ),
                          Divider(
                            color: FitColors.divider,
                            height: 1,
                          ),

                                SelectDateTime(
                                  title: 'DoB',
                                  didchange: (newDate) {
                                    setState(() {
                                      selectDate = newDate;
                                    });
                                  },
                                  selectDate: selectDate,
                                ),
                                Divider(
                                  color: FitColors.divider,
                                  height: 1,
                                ),
                                SelectPicker(
                                  allVal: [
                                    '160 cm',
                                    '161 cm',
                                    '162 cm',
                                    '163 cm',
                                    '164 cm',
                                    '165 cm',
                                    '166 cm',
                                    '167 cm',
                                    '168 cm',
                                    '169 cm',
                                    '170 cm',
                                    '171 cm',
                                    '172 cm',
                                    '173 cm',
                                    '174 cm',
                                    '175 cm',
                                    '176 cm',
                                    '177 cm',
                                    '178 cm',
                                    '179 cm',
                                    '180 cm',
                                    '181 cm',
                                    '182 cm',
                                    '183 cm',
                                    '184 cm',
                                    '185 cm',
                                    '186 cm',
                                    '187 cm',
                                    '188 cm',
                                    '189 cm',
                                    '190 cm',
                                  ],
                                  didchange: (newVal) {
                                    setState(() {
                                      selectHeight = newVal;
                                    });
                                  },
                                  title: 'Height',
                                  selectVal: selectHeight,
                                ),
                                Divider(
                                  color: FitColors.divider,
                                  height: 1,
                                ),
                                SelectPicker(
                                  allVal: [
                                    '50-55 kg',
                                    '56-60 kg',
                                    '61-65 kg',
                                    '66-70 kg',
                                    '71-75 kg',
                                    '76-80 kg',
                                    '81-85 kg',
                                    '86-90 kg',
                                    '91-95 kg',
                                    '96-100 kg',
                                    '101-105 kg',
                                    '106-110 kg',
                                    '111-115 kg',
                                    '116-120 kg',
                                  ],
                                  didchange: (newVal) {
                                    setState(() {
                                      selectWeight = newVal;
                                    });
                                  },
                                  title: 'Weight',
                                  selectVal: selectWeight,
                                ),
                                Divider(
                                  color: FitColors.divider,
                                  height: 1,
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: media.width * 0.05,
                                  ),
                                  child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Gender',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: FitColors.favClr,
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
                              ],
                            ),
                          ),
                          const Spacer(),
                          Padding(
                            padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                            child: RoundButton(
                                title: 'Start',
                                onPressed: () {
                                  // Access the UserData provider
                                  final userData =
                                  Provider.of<UserData>(context, listen: false);

                                  // Update the user data using values from the form
                                  userData.updateData(
                                    isAppleHealth: isAppleHealth,
                                    selectDate: selectDate!,
                                    selectHeight: selectHeight!,
                                    selectWeight: selectWeight!,
                                    isMale: isMale!,
                                    name: nameController.text,
                                  );

                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(builder: (context) => Home()),
                                  // );
                                }),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [1, 2, 3].map((pObj) {
                              return Container(
                                margin: const EdgeInsets.symmetric(horizontal: 10),
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                    color: 3 == pObj
                                        ? FitColors.primary
                                        : FitColors.gray.withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(6)),
                              );
                            }).toList(),
                          ),
                          SizedBox(
                            height: media.width * 0.02,
                          ),
                        ],
                      ),
                    ),
              ),
              ],
            )
      ),
    );
  }
}
