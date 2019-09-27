import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:mobile/communication/pojos/PojoGrade.dart';


class GradesChart extends StatefulWidget {

  String subjectName;
  List<PojoGrade> grades;
  
  GradesChart({Key key, @required this.subjectName, @required this.grades}) : super(key: key);

  @override
  _GradesChart createState() => _GradesChart();
}

class _GradesChart extends State<GradesChart> with TickerProviderStateMixin , AutomaticKeepAliveClientMixin {

  StreamController<LineTouchResponse> controller;


  @override
  void initState() {
    controller = StreamController();
    controller.stream.distinct().listen((LineTouchResponse response){});
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FlChart(
      chart: LineChart(
        LineChartData(
          lineTouchData: LineTouchData(

              touchResponseSink: controller.sink,
              touchTooltipData: TouchTooltipData (
                tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
              )
          ),
          gridData: FlGridData(
            show: true,
          ),
          titlesData: FlTitlesData(
            bottomTitles: SideTitles(
              showTitles: true,
              reservedSize: 22,
              textStyle: TextStyle(
                color: const Color(0xff72719b),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              margin: 10,
              getTitles: (value) {
                switch(value.toInt()) {
                  case 2:
                    return 'SEPT';
                  case 7:
                    return 'OCT';
                  case 12:
                    return 'DEC';
                  case 16:
                    return 'DEC2';
                  case 19:
                    return 'DEC3';
                }
                return '';
              },
            ),
            leftTitles: SideTitles(
              showTitles: true,
              textStyle: TextStyle(
                color: Color(0xff75729e),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              getTitles: (value) {
                switch(value.toInt()) {
                  case 1: return '1';
                  case 2: return '2';
                  case 3: return '3';
                  case 4: return '4';
                  case 4: return '5';
                }
                return '';
              },
              margin: 8,
              reservedSize: 30,
            ),
          ),
          borderData: FlBorderData(
              show: true,
              border: Border(
                bottom: BorderSide(
                  color: Color(0xff4e4965),
                  width: 4,
                ),
                left: BorderSide(
                  color: Colors.transparent,
                ),
                right: BorderSide(
                  color: Colors.transparent,
                ),
                top: BorderSide(
                  color: Colors.transparent,
                ),
              )
          ),
          minX: 0,
          maxX: 14,
          maxY: 4,
          minY: 0,
          lineBarsData: [
            LineChartBarData(
              spots: [
                FlSpot(1, 1),
                FlSpot(3, 1.5),
                FlSpot(5, 1.4),
                FlSpot(7, 3.4),
                FlSpot(10, 2),
                FlSpot(12, 2.2),
                FlSpot(13, 1.8),
              ],
              isCurved: false,
              colors: [
                Color(0xff4af699),
              ],
              barWidth: 8,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: false,
              ),
              belowBarData: BelowBarData(
                show: false,
              ),
            ),
            LineChartBarData(
              spots: [
                FlSpot(1, 1),
                FlSpot(3, 2.8),
                FlSpot(7, 1.2),
                FlSpot(10, 2.8),
                FlSpot(12, 2.6),
                FlSpot(13, 3.9),
              ],
              isCurved: false,
              colors: [
                Color(0xffaa4cfc),
              ],
              barWidth: 5,
              isStrokeCapRound: false,
              dotData: FlDotData(
                show: false,
              ),
              belowBarData: BelowBarData(
                show: false,
              ),
            ),
            LineChartBarData(
              spots: [
                FlSpot(1, 2.8),
                FlSpot(3, 1.9),
                FlSpot(6, 3),
                FlSpot(10, 1.3),
                FlSpot(13, 2.5),
              ],
              isCurved: true,
              colors: [
                Color(0xff27b6fc),
              ],
              barWidth: 8,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: false,
              ),
              belowBarData: BelowBarData(
                show: false,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}



