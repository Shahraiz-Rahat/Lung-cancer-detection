import 'package:flutter/material.dart';

import '../../common/color_extension.dart';
import '../../common_widget/fitness_level_selector.dart';
import '../../common_widget/round_button.dart';
import 'step3_view.dart';

class Step2View extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Step2ViewState();
}

class _Step2ViewState extends State<Step2View> {
  var selectIndex = 0;
  @override
  Widget build(BuildContext context) {
    // ignore: prefer_final_locals
    var media = MediaQuery.sizeOf(context);
    return Scaffold(
      // backgroundColor: FitColors.primary,
      appBar: AppBar(
        backgroundColor: FitColors.primary,
        centerTitle: true,
        title: Text(
          'Step 2 of 3',
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
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    'Select your fitness level',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: FitColors.favClr,
                        fontSize: 24,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                FitnessLevelSelector(
                    title: 'Beginer',
                    subtitle: 'You are new to fitness training',
                    onPressed: () {
                      setState(() {
                        selectIndex = 0;
                      });
                    },
                    isSelect: selectIndex == 0),
                FitnessLevelSelector(
                    title: 'Intermediate',
                    subtitle: 'You have been training regularly',
                    onPressed: () {
                      setState(() {
                        selectIndex = 1;
                      });
                    },
                    isSelect: selectIndex == 1),
                FitnessLevelSelector(
                    title: 'Advance',
                    subtitle:
                        'You are fit and ready for an intensive workout plan',
                    onPressed: () {
                      setState(() {
                        selectIndex = 3;
                      });
                    },
                    isSelect: selectIndex == 3),
                const Spacer(),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  child: RoundButton(
                      title: 'Next',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Step3View()),
                        );
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
                          color: 2 == pObj
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
          )
        ],
      ),
    );
  }
}
