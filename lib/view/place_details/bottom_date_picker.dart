import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prime_travel_flutter_ui_kit/util/common_button.dart';
import 'package:prime_travel_flutter_ui_kit/util/string_config.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../util/colors.dart';
import '../../util/size_config.dart';

// ignore: must_be_immutable
class BottomDatePicker extends StatelessWidget {
  BottomDatePicker({Key? key}) : super(key: key);
  String selectedDate = '';
  String dateCount = '';
  String range = '';
  String rangeCount = '';

  @override
  Widget build(BuildContext context) {
    // Use MediaQuery to get width and height dynamically
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          height: height / 60,
        ),
        Container(
          width: width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(width / 30),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(height / 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: height / 2.8,
                  child: Card(
                    margin: const EdgeInsets.fromLTRB(10, 2, 10, 10),
                    shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: ColorFile.borderColor,
                        ),
                        borderRadius: const BorderRadius.all(
                            Radius.circular(SizeFile.height10))),
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: const ColorScheme.light(
                          primary: ColorFile.appColor,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: SfDateRangePicker(
                          view: DateRangePickerView.month,
                          monthViewSettings: DateRangePickerMonthViewSettings(
                              firstDayOfWeek: 6),
                          selectionMode: DateRangePickerSelectionMode.multiple,
                          selectionColor: ColorFile.appColor,
                          showNavigationArrow: true,
                          onSubmit: (val) {
                            if (kDebugMode) {
                              print(val);
                            }
                          },
                          onCancel: () {},
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: SizeFile.height10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: ShortButton(
                            width: 0,
                            text: StringConfig.cancel,
                            textColor: ColorFile.onBordingColor,
                            buttonColor:
                                ColorFile.appColor.withValues(alpha: 0.15),
                          )),
                    ),
                    SizedBox(
                      width: SizeFile.height20,
                    ),
                    Expanded(
                      child: GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: ShortButton(
                            width: 0,
                            text: StringConfig.apply,
                            textColor: ColorFile.whiteColor,
                            buttonColor: ColorFile.appColor,
                          )),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
