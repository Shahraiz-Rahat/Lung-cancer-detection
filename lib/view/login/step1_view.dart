import 'package:flutter/material.dart';

import '../../common/color_extension.dart';
import '../../common_widget/round_button.dart';
import 'step2_view.dart';

class Step1View extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Step1ViewState();
}

class _Step1ViewState extends State<Step1View> {
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
          'Step 1 of 3',
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
                const Spacer(),
                Image.asset(
                  'assets/img/patliKuri.jpg',
                  width: media.width * 0.5,
                  height: media.height * 0.5,
                  fit: BoxFit.contain,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    'Welcome to \n Fitness Application',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: FitColors.favClr,
                        fontSize: 22,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                Text(
                  'Personalized workouts will help you\n gain strength, get in better shape and\n embrace a healthy lifestyle',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: FitColors.favClr,
                      fontSize: 17,
                      fontWeight: FontWeight.w300),
                ),
                const Spacer(),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  child: RoundButton(
                      title: 'Get Started',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Step2View()),
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
                          color: 1 == pObj
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
