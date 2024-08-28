// ignore_for_file: file_names

import 'package:expense_tracker/constants/app_colors.dart';
import 'package:expense_tracker/models/add_data.dart';
import 'package:expense_tracker/models/utility.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class EditTransfer extends StatefulWidget {
  final int index;
  final String category;
  final String name;
  final String amount;
  final String type;
  final DateTime date;
  const EditTransfer({
    super.key,
    required this.index,
    required this.category,
    required this.name,
    required this.amount,
    required this.type,
    required this.date,
  });

  @override
  State<EditTransfer> createState() => _EditTransferState();
}

class _EditTransferState extends State<EditTransfer> {
  final box = Hive.box<AddData>('data');
  FocusNode fn = FocusNode();
  String? selectedName;
  String? selectedAmount;
  String? selectedItem;
  String? selectedType;
  DateTime date = DateTime.now();
  final List<String> _items = [
    'Food',
    "Transfer",
    'Transport',
    "Education",
    'Shopping'
  ];
  final List<String> _types = [
    'Income',
    "Expense",
  ];
  String helpText = "";
  @override
  void initState() {
    selectedAmount = widget.amount;
    selectedItem = widget.category;
    selectedName = widget.name;
    selectedType = widget.type;
    fn.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return AlertDialog(
      title: Text(
        "Update",
        style: TextStyle(fontSize: w * 0.04),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: categoryField(w, h),
            ),
            SizedBox(
              height: h * 0.03,
            ),
            nameField(w),
            SizedBox(
              height: h * 0.03,
            ),
            amountField(w),
            SizedBox(
              height: h * 0.03,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: typeField(
                w,
                h,
              ),
            ),
            SizedBox(
              height: h * 0.03,
            ),
            dateField(w, context),
            SizedBox(
              height: h * 0.015,
            ),
            Text(
              helpText,
              style: TextStyle(fontSize: w * 0.04, color: Colors.red),
            ),
            SizedBox(
              height: h * 0.015,
            ),
            updateButton(
              w,
              h,
            ),
          ],
        ),
      ),
    );
  }

  DropdownButton<String> categoryField(
    double w,
    double h,
  ) {
    return DropdownButton<String>(
      value: selectedItem,
      isExpanded: true,
      dropdownColor: Colors.white,
      hint: Text(
        "Category",
        style: TextStyle(fontSize: w * 0.04, color: Colors.black38),
      ),
      borderRadius: BorderRadius.circular(10),
      items: _items
          .map((e) => DropdownMenuItem<String>(
                value: e,
                child: Row(
                  children: [
                    Image.asset(
                      // ignore: unnecessary_brace_in_string_interps
                      "assets/images/${e}.png",
                      height: h * 0.05,
                      width: w * 0.1,
                    ),
                    SizedBox(
                      width: w * 0.05,
                    ),
                    Text(
                      e,
                      style: TextStyle(fontSize: w * 0.05),
                    ),
                  ],
                ),
              ))
          .toList(),
      onChanged: ((value) {
        setState(() {
          selectedItem = value!;
        });
      }),
      selectedItemBuilder: (context) => _items
          .map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Row(
                children: [
                  Image.asset(
                    // ignore: unnecessary_brace_in_string_interps
                    "assets/images/${e}.png",
                    height: h * 0.4,
                    width: w * 0.08,
                  ),
                  SizedBox(
                    width: w * 0.05,
                  ),
                  Text(
                    e,
                    style: TextStyle(fontSize: w * 0.05),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  TextFormField nameField(
    double w,
  ) {
    return TextFormField(
      initialValue: selectedName,
      onChanged: (value) {
        setState(() {
          selectedName = value;
        });
      },
      focusNode: fn,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 15),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(width: 1, color: Colors.black38)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(width: 2, color: AppColors.darkShade)),
          labelText: "Name",
          labelStyle: TextStyle(fontSize: w * 0.04, color: Colors.black38)),
    );
  }

  TextFormField amountField(
    double w,
  ) {
    return TextFormField(
      initialValue: selectedAmount,
      onChanged: (value) {
        setState(() {
          selectedAmount = value;
        });
      },
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 15),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(width: 1, color: Colors.black38)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(width: 2, color: AppColors.darkShade)),
          label: const Text("Amount"),
          labelStyle: TextStyle(fontSize: w * 0.04, color: Colors.black38)),
    );
  }

  DropdownButton<String> typeField(
    double w,
    double h,
  ) {
    return DropdownButton<String>(
      value: selectedType,
      isExpanded: true,
      dropdownColor: Colors.white,
      hint: Text(
        "Type",
        style: TextStyle(fontSize: w * 0.04, color: Colors.black38),
      ),
      borderRadius: BorderRadius.circular(10),
      items: _types
          .map((e) => DropdownMenuItem<String>(
                value: e,
                child: Row(
                  children: [
                    Text(
                      e,
                      style: TextStyle(fontSize: w * 0.05),
                    ),
                  ],
                ),
              ))
          .toList(),
      onChanged: ((value) {
        setState(() {
          selectedType = value!;
        });
      }),
      selectedItemBuilder: (context) => _types
          .map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Row(
                children: [
                  Text(
                    e,
                    style: TextStyle(
                        fontSize: w * 0.05, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Container dateField(double w, BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      width: w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 1, color: Colors.black38),
      ),
      child: TextButton(
        onPressed: () async {
          DateTime? newDate = await showDatePicker(
              context: context,
              initialDate: widget.date,
              firstDate: DateTime(2020),
              lastDate: DateTime(2100));

          if (newDate == null) {
            return;
          } else {
            setState(() {
              date = newDate;
            });
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Date: ${date.year} / ${date.month} / ${date.day} ",
              style: TextStyle(color: Colors.black, fontSize: w * 0.04),
            ),
            Icon(
              Icons.arrow_drop_down,
              size: w * 0.07,
              color: Colors.black54,
            )
          ],
        ),
      ),
    );
  }

  GestureDetector updateButton(
    double w,
    double h,
  ) {
    return GestureDetector(
      onTap: () {
        int tot = total();
        int val = int.parse(selectedAmount!);
        if (tot - val > 0) {
          var update = AddData(
            selectedItem!,
            selectedName!,
            selectedAmount!,
            selectedType!,
            date,
          );
          box.putAt(widget.index, update);
          Navigator.pop(context);
        } else {
          setState(() {
            helpText = "Insuficient Balance";
          });
        }
      },
      child: Container(
        width: w * 0.35,
        height: h * 0.06,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.primary,
        ),
        child: Text(
          "Save",
          style: TextStyle(
              color: Colors.white,
              fontSize: w * 0.05,
              fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
