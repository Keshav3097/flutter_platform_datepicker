library flutter_platform_datepicker;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:intl/intl.dart';

class PlatFormDatePicker extends StatefulWidget {
  final BuildContext context;
  final double width;
  String initialValue;
  final String hintText;
  final bool futureDateEnable;
  final bool pastDateEnable;
  final Widget? prefixIcon;
  final Function(String formattedDate)? onClick;

  PlatFormDatePicker({
    required this.context,
    required this.width,
    required this.initialValue,
    this.hintText = "Select date",
    this.prefixIcon,
    this.futureDateEnable = true,
    this.pastDateEnable = true,
    required this.onClick,
  });

  @override
  State<PlatFormDatePicker> createState() => _PlatFormDatePickerState();
}

class _PlatFormDatePickerState extends State<PlatFormDatePicker> {
  bool isEmpty = false;
  var initializeDate = DateTime.now();
  static const String dateFormat = "dd/MM/yyyy";
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.text = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {

    if (widget.initialValue.isNotEmpty) {
      initializeDate = DateFormat(dateFormat).parse(widget.initialValue);
      controller.text = widget.initialValue;
    }

    return SizedBox(
      width: widget.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: widget.width,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                  ),
                  //color: FlexoColorConstants.CONTROL_BACKGROUND_COLOR
                ),
                alignment: Alignment.center,
                child: TextFormField(
                  controller: controller,
                  readOnly: true,
                  onTap: () async {
                    FocusScope.of(context).unfocus();
                    if (Platform.isIOS) {
                      showModalBottomSheet(
                          context: context,
                          builder: (BuildContext builder) {
                            return SizedBox(
                              height: MediaQuery.of(context)
                                      .copyWith()
                                      .size
                                      .height *
                                  0.25,
                              child: CupertinoTheme(
                                data: const CupertinoThemeData(
                                    textTheme: CupertinoTextThemeData(
                                      dateTimePickerTextStyle: TextStyle(
                                          color: Colors.black, fontSize: 16),
                                      textStyle: TextStyle(
                                          color: Colors.black, fontSize: 16),
                                    ),
                                    scaffoldBackgroundColor: Colors.grey,
                                    barBackgroundColor: Colors.blue,
                                    primaryContrastingColor: Colors.red),
                                child: CupertinoDatePicker(
                                  mode: CupertinoDatePickerMode.date,
                                  onDateTimeChanged: (value) {
                                    initializeDate = value;
                                    String formattedDate = DateFormat(dateFormat).format(initializeDate);
                                    widget.initialValue = formattedDate;
                                    controller.text = formattedDate;
                                    widget.onClick!(formattedDate);
                                  },
                                  initialDateTime: initializeDate,
                                  maximumDate: widget.futureDateEnable
                                      ? DateTime(DateTime.now().year + 1000, 1)
                                      : DateTime.now(),
                                  minimumDate: widget.pastDateEnable
                                      ? DateTime(DateTime.now().year - 1000, 1)
                                      : DateTime.now(),
                                ),
                              ),
                            );
                          });
                    } else {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: initializeDate,
                          firstDate: widget.pastDateEnable
                              ? DateTime(DateTime.now().year - 1000, 1)
                              : DateTime.now(),
                          lastDate: widget.futureDateEnable
                              ? DateTime(DateTime.now().year + 1000, 1)
                              : DateTime.now(),
                          builder: (context, child) {
                            return child!;
                          });
                      if (pickedDate != null) {
                        String formattedDate =
                            DateFormat(dateFormat).format(pickedDate);
                        setState(() {
                          widget.initialValue = formattedDate;
                          widget.onClick!(formattedDate);
                          controller.text = formattedDate;
                        });
                      }
                    }
                  },
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                  textAlign: TextAlign.start,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    prefixIcon: widget.prefixIcon,
                    hintStyle:
                        const TextStyle(color: Colors.grey, fontSize: 16),
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    isDense: true,
                    hintText: widget.hintText,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    errorStyle: const TextStyle(height: 0, fontSize: 0),
                    isCollapsed: true,
                  ),
                  textInputAction: TextInputAction.next,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
