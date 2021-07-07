import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:tasmee3/helper/consts.dart';
import 'package:tasmee3/model/user_model.dart';
import 'package:tasmee3/view_model/day_statistics_viewModel.dart';
import 'package:tasmee3/widgets/custom_text.dart';

import 'package:pie_chart/pie_chart.dart';

class DailyStatistics extends StatelessWidget {
  final UserModel currentUser;
  final DateTime now = DateTime.now();
  DailyStatistics({this.currentUser});
  @override
  Widget build(BuildContext context) {
    return GetBuilder<TeacherDayStatisticsViewModel>(
        init: TeacherDayStatisticsViewModel(),
        builder: (controller) => controller.loading.value
            ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(primaryColor),
                ),
              )
            : GetBuilder<TeacherDayStatisticsViewModel>(
                init: Get.find(),
                builder: (controller) => Scaffold(
                      key: controller.globalKey,
                      appBar: AppBar(
                        toolbarHeight: 75,
                        backgroundColor: primaryColor,
                        centerTitle: true,
                        title: CustomText(
                          text: controller.groupName,
                          color: Colors.white,
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      body: Padding(
                        padding: const EdgeInsets.only(
                            top: 20.0, right: 10.0, left: 10.0),
                        child: Container(
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: controller.clickable
                                      ? () async {
                                          try {
                                            final result =
                                                await InternetAddress.lookup(
                                                    'google.com');
                                            if (result.isNotEmpty &&
                                                result[0]
                                                    .rawAddress
                                                    .isNotEmpty) {
                                              controller.setClickable();
                                              await controller
                                                  .pickDate(context);
                                              controller.setClickable();
                                            }
                                          } on SocketException catch (_) {
                                            controller.globalKey.currentState
                                                .showSnackBar(
                                                    controller.snackBar);
                                          }
                                        }
                                      : null,
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: 100,
                                          child: Icon(LineAwesomeIcons.calendar,
                                              color: primaryColor, size: 70.0),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              border: Border.all(
                                                color: accentColor,
                                                width: 3.0,
                                              )),
                                          height: 50.0,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.30,
                                          child: controller.loading.value
                                              ? CircularProgressIndicator(
                                                  valueColor:
                                                      AlwaysStoppedAnimation(
                                                          primaryColor),
                                                )
                                              : TextField(
                                                  textAlignVertical:
                                                      TextAlignVertical.top,
                                                  textDirection:
                                                      TextDirection.rtl,
                                                  enabled: false,
                                                  cursorColor: primaryColor,
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      height: 1.0,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  controller:
                                                      controller.dateController,
                                                  textAlign: TextAlign.center,
                                                ),
                                        ),
                                      ]),
                                ),
                                SizedBox(
                                  height: 15.0,
                                ),
                                Table(
                                  border: TableBorder.all(),
                                  children: [
                                    TableRow(children: [
                                      Container(
                                        padding: EdgeInsets.all(5.0),
                                        height: 60.0,
                                        child: Center(
                                          child: Text(
                                            'عدم تسميع',
                                            style: TextStyle(
                                                fontSize: 13.0,
                                                fontWeight: FontWeight.bold),
                                            textDirection: TextDirection.rtl,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(5.0),
                                        height: 60.0,
                                        child: Center(
                                          child: Text(
                                            'تم كامل مع العقوبة',
                                            style: TextStyle(
                                                fontSize: 11.0,
                                                fontWeight: FontWeight.bold),
                                            textDirection: TextDirection.rtl,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(5.0),
                                        height: 60.0,
                                        child: Center(
                                          child: Text(
                                            'تم ناقص',
                                            style: TextStyle(
                                                fontSize: 13.0,
                                                fontWeight: FontWeight.bold),
                                            textDirection: TextDirection.rtl,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(5.0),
                                        height: 60.0,
                                        child: Center(
                                          child: Text(
                                            'تم كامل',
                                            style: TextStyle(
                                                fontSize: 13.0,
                                                fontWeight: FontWeight.bold),
                                            textDirection: TextDirection.rtl,
                                          ),
                                        ),
                                      ),
                                    ]),
                                    TableRow(children: [
                                      Container(
                                        padding: EdgeInsets.all(5.0),
                                        height: 60.0,
                                        child: Center(
                                          child: Text(
                                            controller.noTasmee3.toString(),
                                            style: TextStyle(
                                                color: primaryColor,
                                                fontSize: 17.0,
                                                fontWeight: FontWeight.bold),
                                            textDirection: TextDirection.rtl,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(5.0),
                                        height: 60.0,
                                        child: Center(
                                          child: Text(
                                            controller.completeWithPunish
                                                .toString(),
                                            style: TextStyle(
                                                color: primaryColor,
                                                fontSize: 17.0,
                                                fontWeight: FontWeight.bold),
                                            textDirection: TextDirection.rtl,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(5.0),
                                        height: 60.0,
                                        child: Center(
                                          child: Text(
                                            controller.uncomplete.toString(),
                                            style: TextStyle(
                                                color: primaryColor,
                                                fontSize: 17.0,
                                                fontWeight: FontWeight.bold),
                                            textDirection: TextDirection.rtl,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(5.0),
                                        height: 60.0,
                                        child: Center(
                                          child: Text(
                                            controller.complete.toString(),
                                            style: TextStyle(
                                                color: primaryColor,
                                                fontSize: 17.0,
                                                fontWeight: FontWeight.bold),
                                            textDirection: TextDirection.rtl,
                                          ),
                                        ),
                                      ),
                                    ]),
                                  ],
                                ),
                                SizedBox(
                                  height: 130.0,
                                ),
                                PieChart(
                                  emptyColor: Colors.green.withOpacity(0.6),
                                  key: ValueKey(controller.key),
                                  dataMap: controller.generateData(),
                                  animationDuration: Duration(seconds: 1),
                                  chartLegendSpacing:
                                      controller.chartLegendSpacing,
                                  chartRadius: 250,
                                  colorList: controller.colorList,
                                  initialAngleInDegree: 3,
                                  chartType: controller.chartType,
                                  legendOptions: LegendOptions(
                                    showLegendsInRow:
                                        controller.showLegendsInRow,
                                    legendPosition: controller.legendPosition,
                                    showLegends: controller.showLegends,
                                    legendShape: controller.legendShape ==
                                            LegendShape.Circle
                                        ? BoxShape.circle
                                        : BoxShape.rectangle,
                                    legendTextStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  chartValuesOptions: ChartValuesOptions(
                                    showChartValueBackground:
                                        controller.showChartValueBackground,
                                    showChartValues: controller.showChartValues,
                                    showChartValuesInPercentage:
                                        controller.showChartValuesInPercentage,
                                    showChartValuesOutside:
                                        controller.showChartValuesOutside,
                                  ),
                                  ringStrokeWidth: controller.ringStrokeWidth,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    )));
  }
}
