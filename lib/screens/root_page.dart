import 'package:expense_tracker/constants/app_colors.dart';
import 'package:expense_tracker/screens/add_screen.dart';
import 'package:expense_tracker/screens/home_screen.dart';
import 'package:expense_tracker/screens/stats_screen.dart';
import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int selectedIndex = 0;
  List screens = const [
    HomeScreen(),
    StatsScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: screens[selectedIndex],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: AppColors.primary,
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const AddScreen()));
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: w * 0.1,
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
                onPressed: () {
                  setState(() {
                    selectedIndex = 0;
                  });
                },
                icon: Icon(
                  Icons.home,
                  color:
                      selectedIndex == 0 ? AppColors.primary : Colors.black38,
                  size: w * 0.09,
                )),
            IconButton(
                onPressed: () {
                  setState(() {
                    selectedIndex = 1;
                  });
                },
                icon: Icon(
                  Icons.bar_chart_outlined,
                  color:
                      selectedIndex == 1 ? AppColors.primary : Colors.black38,
                  size: w * 0.09,
                )),
          ],
        ),
      ),
    );
  }
}
