import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../common/color_extension.dart';

class SelectDateTime extends StatelessWidget {
  final DateTime? selectDate;
  final String title;
  final Function(DateTime) didchange;

  const SelectDateTime(
      {Key? key, this.selectDate, required this.title, required this.didchange})
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
                      child: CupertinoDatePicker(
                          initialDateTime: selectDate,
                          dateOrder: DatePickerDateOrder.ymd,
                          mode: CupertinoDatePickerMode.date,
                          onDateTimeChanged: didchange),
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
                      selectDate == null
                          ? 'Select Date'
                          : DateFormat(' MMM d , y').format(selectDate!),
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
