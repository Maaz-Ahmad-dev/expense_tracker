import 'package:expense_tracker/constants/app_colors.dart';
import 'package:expense_tracker/models/add_data.dart';
import 'package:expense_tracker/models/chart_sales.dart';
import 'package:expense_tracker/models/utility.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Chart extends StatefulWidget {
  final int indexx;
  const Chart({super.key, required this.indexx});

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  List<AddData>? a;
  bool b = true;
  bool j = true;
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    switch (widget.indexx) {
      case 0:
        a = today();
        b = true;
        j = true;
        break;
      case 1:
        a = weekly();
        b = false;
        j = true;
        break;
      case 2:
        a = monthly();
        b = false;
        j = true;
        break;
      case 3:
        a = yearly();
        b = true;
        j = false;
        break;
    }
    return SizedBox(
      height: h * 0.35,
      width: w,
      child: SfCartesianChart(
        primaryXAxis: const CategoryAxis(),
        series: <SplineSeries<salesData, String>>[
          SplineSeries<salesData, String>(
            color: AppColors.primary,
            width: 3,
            dataSource: <salesData>[
              ...List.generate(time(a!, b ? true : false).length, (index) {
                return salesData(
                    j
                        ? b
                            ? a![index].datetime.hour.toString()
                            : a![index].datetime.day.toString()
                        : a![index].datetime.month.toString(),
                    b
                        ? index > 0
                            ? time(a!, true)[index] + time(a!, true)[index - 1]
                            : time(a!, true)[index]
                        : index > 0
                            ? time(a!, false)[index] +
                                time(a!, false)[index - 1]
                            : time(a!, false)[index]);
              })
            ],
            xValueMapper: (salesData sales, _) => sales.year,
            yValueMapper: (salesData sales, _) => sales.sales,
          )
        ],
      ),
    );
  }
}
