import 'package:flutter/material.dart';

import '../../common/color_extension.dart';
import '../../common_widget/round_button.dart';
import 'step1_view.dart';

class OnBoardingView extends StatefulWidget {
  @override
  State<OnBoardingView> createState() => _OnBoardingView();
}

class _OnBoardingView extends State<OnBoardingView> {
  PageController? controller = PageController();
  int selectPage = 0;

  List pageArr = [
    {
      'title': 'Have a good health',
      'subtitle': 'Being healthy is all, no health is nothing.\n why do not we',
      'image': 'assets/img/welcomeBgImage2.png'
    },
    {
      'title': 'Be stronger',
      'subtitle':
          'Take a 30 minutes of bodybuilding every day \nto get physically fit and healthly',
      'image': 'assets/img/cardio.png'
    },
    {
      'title': 'Have a nice body',
      'subtitle':
          'Bad body shape, poor sleep, lack of strength,\nweight gain,weak bones,\n poor metabolism ',
      'image': 'assets/img/welcomeBgImage1.png'
    },
  ];

  @override
  void initState() {
    super.initState();
    controller?.addListener(() {
      selectPage = controller?.page?.round() ?? 0;
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_final_locals
    var media = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: FitColors.primary,
      body: Stack(
        children: [
          Image.asset(
            'assets/img/superBody.jpg',
            width: media.width,
            height: media.height,
            fit: BoxFit.cover,
          ),
          SafeArea(
            child: PageView.builder(
                controller: controller,
                itemCount: pageArr.length,
                itemBuilder: (context, index) {
                  // ignore: prefer_final_locals
                  var pObj = pageArr[index] as Map? ?? {};
                  return Column(
                    children: [
                      SizedBox(
                        height: media.width * 0.1,
                      ),
                      Text(
                        pObj['title'].toString(),
                        style: TextStyle(
                            color: FitColors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        height: media.width * 0.22,
                      ),
                      Expanded(
                        child: Image.asset(
                          pObj['image'].toString(),
                          width: media.width * 0.6,
                          height: media.height * 0.6,
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(
                        height: media.width * 0.1,
                      ),
                      Expanded(
                        child: Text(
                          pObj['subtitle'].toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: FitColors.white,
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ],
                  );
                }),
          ),
          SafeArea(
            child: Column(
              children: [
                const Spacer(),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: pageArr.map((pObj) {
                    // ignore: prefer_final_locals
                    var index = pageArr.indexOf(pObj);
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                          color: selectPage == index
                              ? FitColors.white
                              : FitColors.white.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(6)),
                    );
                  }).toList(),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                  child: RoundButton(
                      title: 'Start',
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Step1View()),
                            (route) => false);
                      }),
                ),
                // SizedBox(
                //   height: media.width * 0.02,
                // ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
