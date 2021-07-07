import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:tasmee3/helper/consts.dart';
import 'package:tasmee3/model/user_model.dart';
import 'package:tasmee3/view_model/group_statistics_viewModel.dart';
import 'package:tasmee3/widgets/custom_text.dart';

class GroupStatistics extends StatelessWidget {
  final UserModel currentUser;
  GroupStatistics({this.currentUser});
  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    return GetBuilder<GroupStatisticsViewModel>(
      init: GroupStatisticsViewModel(),
      builder: (controller) => controller.loading.value
          ? Center(
              child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(primaryColor),
            ))
          : GetBuilder<GroupStatisticsViewModel>(
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
                body: controller.loading.value
                    ? Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(primaryColor),
                        ),
                      )
                    : GetBuilder<GroupStatisticsViewModel>(
                        init: Get.find(),
                        builder: (controller) => Container(
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
                                              result[0].rawAddress.isNotEmpty) {
                                            controller.setClickable();
                                            await controller.pickDateRange(
                                                context, currentUser.id);
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 90.0,
                                      child: Icon(LineAwesomeIcons.calendar,
                                          color: primaryColor, size: 65.0),
                                    ),
                                    // SizedBox(width: 20.0),
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          color: Colors.grey.shade100,
                                          border: Border.all(
                                            color: accentColor,
                                            width: 2.0,
                                          )),
                                      height: 47.0,
                                      width: MediaQuery.of(context).size.width *
                                          0.25,
                                      child: TextField(
                                        textDirection: TextDirection.rtl,
                                        enabled: false,
                                        cursorColor: primaryColor,
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            height: 1.0,
                                            fontWeight: FontWeight.bold),
                                        controller: controller.dateUntil,
                                        textAlign: TextAlign.center,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'الي',
                                          hintStyle: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 13.0),
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
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          color: Colors.grey.shade100,
                                          border: Border.all(
                                            color: accentColor,
                                            width: 2.0,
                                          )),
                                      height: 47.0,
                                      width: MediaQuery.of(context).size.width *
                                          0.25,
                                      child: controller.loading.value
                                          ? CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation(
                                                      primaryColor),
                                            )
                                          : TextField(
                                              textDirection: TextDirection.rtl,
                                              enabled: false,
                                              cursorColor: primaryColor,
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  height: 1,
                                                  fontWeight: FontWeight.bold),
                                              controller: controller.dateFrom,
                                              textAlign: TextAlign.center,
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                hintText: 'من',
                                                hintStyle: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 13.0),
                                              ),
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(
                                    right: 0.0, left: 5.0),
                                height: orientation == Orientation.portrait
                                    ? MediaQuery.of(context).size.height * 0.47
                                    : MediaQuery.of(context).size.height * 0.1,
                                width: MediaQuery.of(context).size.width,
                                child: ListView(
                                  children: [
                                    Container(
                                        alignment: Alignment.center,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.99,
                                        child: controller
                                            .buildBody(controller.userDetails)),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              Expanded(
                                child: PieChart(
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
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
            ),
    );
  }
}
