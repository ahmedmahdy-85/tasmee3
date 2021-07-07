import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tasmee3/helper/consts.dart';
import 'package:tasmee3/model/user_model.dart';
import 'package:tasmee3/view_model/StudentDailyStatistics.dart';
import 'package:tasmee3/widgets/chart_data.dart';
import 'package:tasmee3/widgets/custom_text.dart';

class StudentStatistics extends StatelessWidget {
  final UserModel currentUser;
  StudentStatistics({this.currentUser});
  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    return GetBuilder<StudentStatisticsViewModel>(
      init: StudentStatisticsViewModel(),
      builder: (controller) => controller.loading.value
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(primaryColor),
              ),
            )
          : GetBuilder<StudentStatisticsViewModel>(
              init: Get.find(),
              builder: (controller) => Scaffold(
                appBar: AppBar(
                  toolbarHeight: 75.0,
                  backgroundColor: primaryColor,
                  centerTitle: true,
                  title: controller.loading.value
                      ? CustomText(
                          text: '',
                        )
                      : CustomText(
                          text: controller.groupName,
                          color: Colors.white,
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                        ),
                ),
                body: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.only(top: 30.0, right: 5.0, left: 5.0),
                    height: orientation == Orientation.portrait
                        ? MediaQuery.of(context).size.height
                        : MediaQuery.of(context).size.height * 2,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: GestureDetector(
                            onTap: controller.clickable
                                ? () async {
                                    try {
                                      final result =
                                          await InternetAddress.lookup(
                                              'google.com');
                                      if (result.isNotEmpty &&
                                          result[0].rawAddress.isNotEmpty) {
                                        controller.setClickable();
                                        await controller.pickDateRange(
                                            context,
                                            currentUser.teacherId,
                                            currentUser.id);
                                        controller.setClickable();
                                      }
                                    } on SocketException catch (_) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(controller.snackBar);
                                    }
                                  }
                                : null,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 90.0,
                                  child: Icon(LineAwesomeIcons.calendar,
                                      color: primaryColor, size: 60.0),
                                ),
                                // SizedBox(width: 20.0),
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Colors.grey.shade100,
                                      border: Border.all(
                                        color: accentColor,
                                        width: 2.0,
                                      )),
                                  height: 47.0,
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
                                  child: TextField(
                                    textDirection: TextDirection.rtl,
                                    enabled: false,
                                    cursorColor: primaryColor,
                                    style: TextStyle(
                                        fontSize: 14.0,
                                        height: 1.0,
                                        fontWeight: FontWeight.bold),
                                    controller: controller.dateUntil,
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'الي',
                                      hintStyle: TextStyle(
                                          color: Colors.grey, fontSize: 14.0),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Text(
                                  ':',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25.0),
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Colors.grey.shade100,
                                      border: Border.all(
                                        color: accentColor,
                                        width: 2.0,
                                      )),
                                  height: 47.0,
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
                                  child: controller.loading.value
                                      ? CircularProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation(
                                              primaryColor),
                                        )
                                      : TextField(
                                          textDirection: TextDirection.rtl,
                                          enabled: false,
                                          cursorColor: primaryColor,
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              height: 1,
                                              fontWeight: FontWeight.bold),
                                          controller: controller.dateFrom,
                                          textAlign: TextAlign.center,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'من',
                                            hintStyle: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 14.0),
                                          ),
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: controller.buildBody(
                                controller.userDetails, orientation)),
                        SizedBox(
                          height: 40.0,
                        ),
                        Expanded(
                          child: SfCartesianChart(

                              // Initialize category axis
                              primaryXAxis: CategoryAxis(
                                  labelStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.0)),
                              primaryYAxis: NumericAxis(
                                labelStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0),
                                interval: 1,
                                // rangePadding: ChartRangePadding.round),
                              ),
                              series: <ColumnSeries<ChartData, String>>[
                                ColumnSeries<ChartData, String>(
                                    // Bind data source
                                    dataSource: controller.getChartData(),
                                    xValueMapper: (ChartData data, _) => data.x,
                                    yValueMapper: (ChartData data, _) => data.y,
                                    pointColorMapper: (ChartData data, _) =>
                                        data.color)
                              ]),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
