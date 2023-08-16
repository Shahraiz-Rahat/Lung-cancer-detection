import 'package:flutter/material.dart';

import '../common/color_extension.dart';

class FitnessLevelSelector extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onPressed;
  final bool isSelect;
  const FitnessLevelSelector(
      {required this.title,
      required this.subtitle,
      required this.onPressed,
      required this.isSelect});
  @override
  Widget build(BuildContext context) {
    // ignore: prefer_final_locals
    var media = MediaQuery.sizeOf(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: FitColors.favClr,
                fontSize: 22,
                fontWeight: FontWeight.w700),
          ),
          InkWell(
            onTap: onPressed,
            child: Padding(
              padding: EdgeInsets.only(
                  left: 15,
                  top: media.width * 0.05,
                  bottom: media.height * 0.05),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      subtitle,
                      style: TextStyle(
                          color:
                              isSelect ? FitColors.selected : FitColors.favClr,
                          fontSize: 18,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  if (isSelect)
                    Image.asset(
                      'assets/img/tick.png',
                      color: FitColors.selected,
                      width: 30,
                      height: 30,
                    ),
                ],
              ),
            ),
          ),
          Divider(
            color: FitColors.divider,
            height: 1,
          ),
          SizedBox(
            height: media.height * 0.05,
          )
        ],
      ),
    );
  }
}
