import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../common/color_extension.dart';

class SelectPicker extends StatelessWidget {
  final String? selectVal;
  final String title;
  final List allVal;
  final Function(String) didchange;

  const SelectPicker(
      {Key? key,
      this.selectVal,
      required this.title,
      required this.allVal,
      required this.didchange})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_final_locals
    var media = MediaQuery.sizeOf(context);
    return InkWell(
      onTap: () {
        showCupertinoModalPopup(
            context: context,
            builder: (context) {
              return Container(
                height: 270,
                color: FitColors.white,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Done',
                              style: TextStyle(
                                color: FitColors.secondaryText,
                                fontSize: 16,
                              ),
                            ))
                      ],
                    ),
                    SizedBox(
                      height: 200,
                      child: CupertinoPicker(
                          itemExtent: 40,
                          onSelectedItemChanged: (index) {
                            didchange(allVal[index]);
                          },
                          children: allVal.map((itemObj) {
                            return Text(
                              itemObj.toString(),
                              style: TextStyle(
                                color: FitColors.secondaryText,
                                fontSize: 16,
                              ),
                            );
                          }).toList()),
                    )
                  ],
                ),
              );
            });
      },
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: media.width * 0.05,
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: FitColors.favClr,
                          fontSize: 20,
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 8),
                    Text(
                      selectVal ?? 'Select',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: FitColors.favClr,
                        fontSize: 18,
                      ),
                    ),
                  ]),
            ),
          ),
        ],
      ),
    );
  }
}
