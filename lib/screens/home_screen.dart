import 'package:expense_tracker/components/edit_Transfer.dart';
import 'package:expense_tracker/constants/app_colors.dart';
import 'package:expense_tracker/models/add_data.dart';
import 'package:expense_tracker/models/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // ignore: prefer_typing_uninitialized_variables
  var history;
  final box = Hive.box<AddData>("data");

  void updateTile(int index, AddData dataList) {
    showDialog(
      context: context,
      builder: (context) {
        return EditTransfer(
          index: index,
          category: dataList.category,
          name: dataList.name,
          amount: dataList.amount,
          type: dataList.type,
          date: dataList.datetime,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
        body: SafeArea(
            child: ValueListenableBuilder(
      valueListenable: box.listenable(),
      builder: (context, value, child) {
        return Column(
          children: [
            getHeader(h, w),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Transaction History",
                    style: TextStyle(
                      fontSize: w * 0.043,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    "see all",
                    style: TextStyle(
                      fontSize: w * 0.035,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                itemCount: box.length,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                separatorBuilder: (context, index) => const SizedBox(
                  height: 5,
                ),
                itemBuilder: (context, index) {
                  history = box.values.toList()[index];
                  return actionsItem(index, h, w, history, context);
                },
              ),
            ),
          ],
        );
      },
    )));
  }

  Widget actionsItem(index, h, w, dataBlock, context) {
    return Slidable(
      startActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              AddData dataList = box.values.toList()[index];
              updateTile(index, dataList);
            },
            icon: Icons.edit,
            borderRadius: BorderRadius.circular(10),
            backgroundColor: Colors.blue.shade300,
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              box.values.toList()[index].delete();
            },
            icon: Icons.delete,
            borderRadius: BorderRadius.circular(10),
            backgroundColor: Colors.red.shade300,
          ),
        ],
      ),
      child: dataTile(index, h, w, history),
    );
  }

  ListTile dataTile(int index, double h, double w, AddData dataBlock) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(
          "assets/images/${dataBlock.category}.png",
          height: h * 0.06,
          width: w * 0.13,
          fit: BoxFit.fill,
        ),
      ),
      title: Text(
        '${dataBlock.category} (${dataBlock.name})',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: w * 0.045),
      ),
      subtitle: Text(
        "${dataBlock.datetime.day}/${dataBlock.datetime.month}/${dataBlock.datetime.year}",
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: w * 0.035,
            color: Colors.black45),
      ),
      trailing: Text(
        "\$ ${dataBlock.amount}",
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: w * 0.05,
            color: dataBlock.type == "Expense" ? Colors.red : Colors.green),
      ),
    );
  }

  SizedBox getHeader(double h, double w) {
    return SizedBox(
      height: h * 0.43,
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                width: w,
                height: h * 0.30,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: SizedBox(
                  width: w,
                  height: h * 0.15,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Welcome to",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                  fontSize: w * 0.05),
                            ),
                            Text(
                              "Expense Tracker",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: w * 0.070),
                            ),
                          ],
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            height: h * 0.06,
                            width: w * 0.15,
                            color: AppColors.lightShade,
                            child: Icon(
                              Icons.swap_vert,
                              size: w * 0.09,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: h * 0.18,
            child: SizedBox(
              width: w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: h * 0.23,
                    width: w * 0.85,
                    decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(47, 125, 121, 0.3),
                          spreadRadius: 6,
                          blurRadius: 3,
                          offset: Offset(0, 6),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(20),
                      color: AppColors.darkShade,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Total balance",
                                style: TextStyle(
                                    color: Colors.white, fontSize: w * 0.05),
                              ),
                              Icon(
                                Icons.more_horiz_outlined,
                                color: Colors.white,
                                size: w * 0.08,
                              )
                            ],
                          ),
                          Text(
                            "\$ ${total()}",
                            style: TextStyle(
                                fontSize: w * 0.11,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: w * 0.055,
                                        backgroundColor: AppColors.lightShade,
                                        child: Icon(
                                          Icons.arrow_downward,
                                          color: Colors.white,
                                          size: w * 0.06,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        "Income",
                                        style: TextStyle(
                                            color: Colors.white38,
                                            fontSize: w * 0.05),
                                      )
                                    ],
                                  ),
                                  Text(
                                    "\$ ${income()}",
                                    style: TextStyle(
                                        fontSize: w * 0.05,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: w * 0.055,
                                        backgroundColor: AppColors.lightShade,
                                        child: Icon(
                                          Icons.arrow_upward,
                                          color: Colors.white,
                                          size: w * 0.06,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        "Expense",
                                        style: TextStyle(
                                            color: Colors.white38,
                                            fontSize: w * 0.05),
                                      )
                                    ],
                                  ),
                                  Text(
                                    "\$ ${expense()}",
                                    style: TextStyle(
                                        fontSize: w * 0.05,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
