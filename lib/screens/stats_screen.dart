import 'package:expense_tracker/components/chart.dart';
import 'package:expense_tracker/constants/app_colors.dart';
import 'package:expense_tracker/models/add_data.dart';
import 'package:expense_tracker/models/utility.dart';
import 'package:flutter/material.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  List day = ['Day', 'Week', 'Month', 'Year'];
  List periodicData = [today(), weekly(), monthly(), yearly()];
  List<AddData> dataList = [];
  int selectedIndex = 0;
  ValueNotifier kj = ValueNotifier(0);
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: kj,
          builder: (context, dynamic value, child) {
            dataList = periodicData[value];
            return scrollBuilder(h, w);
          },
        ),
      ),
    );
  }

  CustomScrollView scrollBuilder(double h, double w) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            children: [
              SizedBox(
                height: h * 0.015,
              ),
              Text(
                "Statistics",
                style:
                    TextStyle(fontSize: w * 0.08, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: h * 0.015,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ...List.generate(4, (index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                            kj.value = index;
                          });
                        },
                        child: Container(
                          height: h * 0.045,
                          width: w * 0.20,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: selectedIndex == index
                                ? AppColors.primary
                                : Colors.transparent,
                          ),
                          child: Text(
                            day[index],
                            style: TextStyle(
                                color: selectedIndex == index
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: w * 0.045),
                          ),
                        ),
                      );
                    })
                  ],
                ),
              ),
              SizedBox(
                height: h * 0.015,
              ),
              SizedBox(
                height: h * 0.015,
              ),
              Chart(
                indexx: selectedIndex,
              ),
              SizedBox(
                height: h * 0.015,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Top Spending",
                      style: TextStyle(
                          fontSize: w * 0.04, fontWeight: FontWeight.bold),
                    ),
                    Icon(
                      Icons.swap_vert,
                      color: Colors.grey,
                      size: w * 0.06,
                    )
                  ],
                ),
              ),
              SizedBox(
                height: h * 0.015,
              ),
            ],
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            return ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  "assets/images/${dataList[index].category}.png",
                  height: h * 0.06,
                  width: w * 0.13,
                  fit: BoxFit.fill,
                ),
              ),
              title: Text(
                '${dataList[index].category} (${dataList[index].name})',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: w * 0.045),
              ),
              subtitle: Text(
                "${dataList[index].datetime.day}/${dataList[index].datetime.month}/${dataList[index].datetime.year}",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: w * 0.035,
                    color: Colors.black45),
              ),
              trailing: Text(
                "\$ ${dataList[index].amount}",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: w * 0.05,
                    color: dataList[index].type == "Expense"
                        ? Colors.red
                        : Colors.green),
              ),
            );
          }, childCount: dataList.length),
        )
      ],
    );
  }
}
