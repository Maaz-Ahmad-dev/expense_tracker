import 'package:expense_tracker/constants/app_colors.dart';
import 'package:expense_tracker/models/add_data.dart';
import 'package:expense_tracker/models/utility.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final box = Hive.box<AddData>('data');
  TextEditingController nameController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  FocusNode fn = FocusNode();
  DateTime date = DateTime.now();
  String? selectedItem;
  String? selectedType;
  String helpText = '';
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

  @override
  void initState() {
    fn.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            headerCard(w, h, context),
            Positioned(
                top: h * 0.12,
                child: Container(
                  height: h * 0.65,
                  width: w * 0.8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                          child: typeField(w, h),
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
                          style:
                              TextStyle(fontSize: w * 0.04, color: Colors.red),
                        ),
                        SizedBox(
                          height: h * 0.015,
                        ),
                        saveButton(w, h)
                      ],
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  GestureDetector saveButton(double w, double h) {
    return GestureDetector(
      onTap: () {
        int tot = total();
        int val = int.parse(amountController.text.toString());
        if (tot - val > 0) {
          var add = AddData(
            selectedItem!,
            nameController.text,
            amountController.text,
            selectedType!,
            date,
          );
          box.add(add);
          Navigator.pop(context);
        } else {
          setState(() {
            helpText = "Insufficient balance";
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
              initialDate: date,
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

  DropdownButton<String> typeField(double w, double h) {
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

  DropdownButton<String> categoryField(double w, double h) {
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

  TextFormField amountField(double w) {
    return TextFormField(
      controller: amountController,
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

  TextFormField nameField(double w) {
    return TextFormField(
      controller: nameController,
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

  Column headerCard(double w, double h, BuildContext context) {
    return Column(
      children: [
        Container(
          width: w,
          height: h * 0.3,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15),
            ),
            color: AppColors.primary,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        size: w * 0.08,
                        color: Colors.white,
                      )),
                  Text(
                    "Add an item",
                    style: TextStyle(
                        fontSize: w * 0.06,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.attach_file_outlined,
                        size: w * 0.07,
                        color: Colors.white,
                      ))
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
